function [ fehler, anzahl_fehler ] = unterschiedPlot( wahr1, wahr2, clustering1, clustering2, cluster_zentrum, name_figure )
%Erkennen, welche Daten unterschiedlich sind zu Ground Truth
%wahr: alle Daten mit Cluster Label, wahr
%Clustering: alle Daten mit Cluster Label, experiment
%unterschied: gibt Clustering mit Marker f�r die Werte zur�ck, die unterschiedlich sind.

wahr = [wahr1; wahr2];
clustering = [clustering1(:, 1:4); clustering2(:, 1:4)];
%dd = clustering-wahr
%f= clustering(dd(:,1) ~= 0, 2:3)

wahr_sort = sortrows(wahr,2)
clustering_sort = sortrows(clustering,2);

%sw = size(wahr)
%sc = size(clustering)

differenz= wahr_sort-clustering_sort(:,1:3);

%Je nach Cluster Zuordnung eien Option w�hlen
%fehler= clustering_sort(differenz(:,1) ~= 0, 1:4) %von beiden Clustern
fehler= clustering_sort(differenz(:,1) == 0, 1:4);

size_fehler = size(fehler);
anzahl_fehler = size_fehler(1);

%Plot--------------------------
figure('name', name_figure)

scatter(clustering1(:,2), clustering1(:,3), 50,'r');
hold on
scatter(clustering2(:,2), clustering2(:,3), 50,'b');
scatter(fehler(:,2), fehler(:,3), 50,'g');

scatter(cluster_zentrum(1,1), cluster_zentrum(1,2), 50,[0 0 0]);
scatter(cluster_zentrum(1,1), cluster_zentrum(1,2), 50,[0 0 0], '+');

scatter(cluster_zentrum(2,1), cluster_zentrum(2,2), 50,[0 0 0]);
scatter(cluster_zentrum(2,1), cluster_zentrum(2,2), 50,[0 0 0], '+');
hold off

xlabel('x');
ylabel('y');

axis equal
title(name_figure)

end

