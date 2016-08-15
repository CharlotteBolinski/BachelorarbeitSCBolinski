%function [ output_args ] = clusterPlot( cluster_daten, cluster_zentrum, name_figure )
function [ ] = clusterPlot( cluster1, cluster2 , cluster_zentrum, name_figure )
%Plot der geclusterten Daten
%Berechnen der 2D-Projektion der 3D-Ebene
%
%INPUT:
%
%   cluster1            =   Werte 2. Cluster mit Label
%   cluster2            =   Werte 1.  mit Label
%   cluster_zentrum     =   Clusterzentrum, dass dargestellt werden soll
%   name_figure         =   Titel des Plot Fensters
%
%OUTPUT:
%
%   []
%
%Autor: Sophie-Charlotte Bolinski, Matrikelnummer: 545839, htw-berlin

figure('name', name_figure);

scatter(cluster1(:,2), cluster1(:,3), 50,[1 0 0]);
hold on
scatter(cluster2(:,2), cluster2(:,3), 50,[0 0 1]);
 

%title(name_figure)
%legend('Cluster 1','Cluster 2');





%{
size_fuzzy = size(cluster_daten);
rows_f = size_fuzzy(1);
%columns_f = size_fuzzy(2);

figure('name', name_figure);
for r = 1:rows_f
    
    clust = cluster_daten(r,1);
    %disp(clust);

    hold on
    
    %beliebig viele cases wenn mehrere Cluster
    switch clust
        case 1
            scatter(cluster_daten(r,2), cluster_daten(r,3), 50,[0 0 1]);
        case 2
            scatter(cluster_daten(r,2), cluster_daten(r,3), 50,[1 0 0]);
        otherwise
            error('ERROR: Bisher nur für 2D.'); 
    end
    
end
%}

%Clusterzentren plotten..for wenn flexibel
scatter(cluster_zentrum(1,1), cluster_zentrum(1,2), 50,[0 0 0]);
scatter(cluster_zentrum(1,1), cluster_zentrum(1,2), 50,[0 0 0], '+');

scatter(cluster_zentrum(2,1), cluster_zentrum(2,2), 50,[0 0 0]);
scatter(cluster_zentrum(2,1), cluster_zentrum(2,2), 50,[0 0 0], '+');
    
hold off

set(gca,'FontSize',14);
xlabel('x');
ylabel('y');

axis equal
%grid on
%hold off

end

