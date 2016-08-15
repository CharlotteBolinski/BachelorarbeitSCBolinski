function [ fehler_homo, anzahl_fehler ] = unterschiedPlot_homo( wahr_index, input_homo, homographie_init_index, cluster_zentrum, fehler_farbe, name_clustering, name_fehler, plot_unterdrueckt )
%Erkennen und darstellen, welche Daten unterschiedlich sind zu Ground Truth
%Plot der geclusterten Daten
%Homographie Verbesserung
%
%INPUT:
%
%   wahr_index                  =   Index der richtigen Werte, bekannt aus synthetischen Daten
%                                   [ alle Daten mit Cluster Label, wahr,index ]
%   input_homo                  =   alle output werte der Homographie Verbesserung (homographie_mad)
%   homographie_init_index      =   Initaile Homographie Fehler mit Index, aus Vorclustering
%   cluster_zentrum             =   Clusterzentrum, dass dargestellt werden soll
%   fehler_farbe                =   Farbe als Vektor [R G B], Werte 0-1
%   plot_unterdrueckt           =   'j' für ja 'n' für nein übergeben
%
%OUTPUT:
%
%   fehler_homo     =   Werte mit Index, die durch das Clustering nicht erkannt wurden
%   anzahl_fehler   =   Anzahl der falsch erkannten Werte
%
%Autor: Sophie-Charlotte Bolinski, Matrikelnummer: 545839, htw-berlin


clustering1 = [input_homo(input_homo(:,1) == 1, 1:3), input_homo(input_homo(:,1) == 1, 6)];
clustering2 = [input_homo(input_homo(:,1) == 2, 1:3), input_homo(input_homo(:,1) == 2, 6)];

clustering_homo = [clustering1; clustering2];
%dd = clustering-wahr
%f= clustering(dd(:,1) ~= 0, 2:3)

wahr_sort = sortrows(wahr_index,4);
clustering_sort = sortrows(clustering_homo,4);

%sw = size(wahr)
%sc = size(clustering)

differenz= wahr_sort(:,1:3)-clustering_sort(:,1:3);

%Je nach Cluster Zuordnung eien Option wählen
fehler_homo= clustering_sort(differenz(:,1) ~= 0, 1:4); %von beiden Clustern
%fehler_homo= clustering_sort(differenz(:,1) == 0, 1:4);

size_fehler = size(fehler_homo);
anzahl_fehler = size_fehler(1);

if plot_unterdrueckt == 'n'
    %Plot--------------------------
    figure('name',  name_clustering)

    %Falsche Werte des Clusterings
    scatter(clustering1(:,2), clustering1(:,3), 50,'r');
    hold on
    scatter(clustering2(:,2), clustering2(:,3), 50,'b');
    
    scatter(fehler_homo(:,2), fehler_homo(:,3), fehler_farbe, 'filled');
    
    %Plot des Fehlers, bei dem der Fehler des am größten ist (max_homo)
    %max_index = 120
    %scatter(fehler_homo(fehler_homo(:,4)== max_index,2), fehler_homo(fehler_homo(:,4)== max_index,3), 50,'c'); 

    scatter(cluster_zentrum(1,1), cluster_zentrum(1,2), 50,[0 0 0]);
    scatter(cluster_zentrum(1,1), cluster_zentrum(1,2), 50,[0 0 0], '+');

    scatter(cluster_zentrum(2,1), cluster_zentrum(2,2), 50,[0 0 0]);
    scatter(cluster_zentrum(2,1), cluster_zentrum(2,2), 50,[0 0 0], '+');
    hold off

    xlabel('x');
    ylabel('y');

    axis equal
    %title(name_clustering)
    set(gca,'FontSize',18);

end
    
    %Abbildungsfehler der falschen Werte 
    fehler_cluster1_index = fehler_homo(fehler_homo(:,1) == 1, 4);
    fehler_cluster2_index = fehler_homo(fehler_homo(:,1) == 2, 4);

    hf1_unterschied = homographie_init_index(fehler_cluster1_index,:)
    hf2_unterschied = homographie_init_index(fehler_cluster2_index,:)

    if plot_unterdrueckt == 'n'
        
        homogFehlerPlot(hf1_unterschied, hf2_unterschied, 1, 2, name_fehler);
    
    end


end

