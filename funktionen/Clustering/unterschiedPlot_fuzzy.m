function [ fehler_fuzzy, anzahl_fehler ] = unterschiedPlot_fuzzy( wahr1, wahr2, clustering1, clustering2, vek1, vek2, cluster_zentrum, fehler_farbe, name_clustering, name_fehler )
%Erkennen, welche Daten unterschiedlich sind zu Ground Truth
%wahr: alle Daten mit Cluster Label, wahr
%Clustering: alle Daten mit Cluster Label, experiment
%unterschied: gibt Clustering mit Marker für die Werte zurück, die unterschiedlich sind.

wahr = [wahr1; wahr2];
clustering = [clustering1(:, 1:4); clustering2(:, 1:4)];
%dd = clustering-wahr
%f= clustering(dd(:,1) ~= 0, 2:3)

wahr_sort = sortrows(wahr,2);
clustering_sort = sortrows(clustering,2);

%sw = size(wahr)
%sc = size(clustering)

differenz= wahr_sort-clustering_sort(:,1:3);

%Je nach Cluster Zuordnung eien Option wählen
fehler_fuzzy= clustering_sort(differenz(:,1) ~= 0, 1:4); %von beiden Clustern
%fehler_fuzzy = clustering_sort(differenz(:,1) == 0, 1:4);

size_fehler = size(fehler_fuzzy);
anzahl_fehler = size_fehler(1);

%Plot--------------------------
figure('name',  name_clustering)

%Falsche Werte des Clusterings
scatter(clustering1(:,2), clustering1(:,3), 50,'r');
hold on
scatter(clustering2(:,2), clustering2(:,3), 50,'b');
s = scatter(fehler_fuzzy(:,2), fehler_fuzzy(:,3), 50, fehler_farbe, 'filled');
s.LineWidth = 6.0; 

scatter(cluster_zentrum(1,1), cluster_zentrum(1,2), 50,[0 0 0]);
scatter(cluster_zentrum(1,1), cluster_zentrum(1,2), 50,[0 0 0], '+');

scatter(cluster_zentrum(2,1), cluster_zentrum(2,2), 50,[0 0 0]);
scatter(cluster_zentrum(2,1), cluster_zentrum(2,2), 50,[0 0 0], '+');
hold off

xlabel('x');
ylabel('y');

axis equal
%title(name_clustering);
set(gca,'FontSize',18);

%Abbildungsfehler der falschen Werte 
fehler_cluster1_index = fehler_fuzzy(fehler_fuzzy(:,1) == 1, 4);
fehler_cluster2_index = fehler_fuzzy(fehler_fuzzy(:,1) == 2, 4);

vektoren1 = [];
vektoren2 = [];

%v = vek1(vek1(:,4) == fehler_cluster1_index(1), 2:3)

s_f1_index = size(fehler_cluster1_index);
rows_f1 = s_f1_index(1);
    
if ~isempty(fehler_cluster1_index) 

    start1 = fehler_fuzzy(fehler_fuzzy(:,1) == 1, 2:3); %Cluster1 Daten

    for i = 1:rows_f1
        vektoren1(i,:) = vek1(vek1(:,4) == fehler_cluster1_index(i), 2:3);
    end
    
    ziel1 =  start1 + vektoren1;
    
    [homographie_matrix1, homo_fehler1] = homographie_cluster(start1, ziel1);

else
    homo_fehler1 = zeros(rows_f1,1);
end


s_f2_index = size(fehler_cluster2_index);
rows_f2 = s_f2_index(1);
    
if ~isempty(fehler_cluster2_index)
    start2 = fehler_fuzzy(fehler_fuzzy(:,1) == 2, 2:3); %Cluster2 Daten

    for i = 1:rows_f2
        vektoren2(i,:) = vek2(vek2(:,4) == fehler_cluster2_index(i), 2:3);
    end

    ziel2 =  start2 + vektoren2;
    
    [homographie_matrix2, homo_fehler2] = homographie_cluster(start2, ziel2);

else
    homo_fehler2 = zeros(rows_f2,1);
    
end

%v1 = vektoren1
%v2 = vektoren2

homogFehlerPlot(homo_fehler1, homo_fehler2, 1, 1, name_fehler);


end

