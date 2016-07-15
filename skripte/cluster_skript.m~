%HIER PASSIERT ERSTMAL ALLES TESTWEISE NUR FÜR 2 FRAMES

%Vektoren Frame 1-2 auswählen**********************************************
vektoren_A = rauschen_A(1:40, :); %nur Vektoren Frame1->Frame2 holen, 1. Datensatz
vektoren_B = rauschen_B(1:40, :);
vektoren_2D = [vektoren_A ; vektoren_B];

%vektoren_2D = [vektoren(:,1), vektoren(:,2)];

proj_20A = projektion_A(:, 1:40); %nur Vektoren Frame1->Frame2 holen, 1. Datensatz
proj_20B = projektion_B(:, 1:40);
projektion_2frames = [proj_20A'; proj_20B'];

%fuzzy c-means Frame 1-2
%Vorclustering macht vor allem mit den Positionen Sinn!!
%[fuzzy_cluster1, fuzzy_cluster2 , fuzzy_komplett, fuzzy_clusterZentrum] = fuzzyCmeans_self(vektoren_2D, 2); %2 wird noch nicht gebraucht, Anzahl Cluster
[fuzzy_cluster1, fuzzy_cluster2 , fuzzy_komplett2frames, fuzzy_clusterZentrum2frames] = fuzzyCmeans_self(projektion_2frames, 2); %2 wird noch nicht gebraucht, Anzahl Cluster
clusterPlot( fuzzy_cluster1, fuzzy_cluster2 , fuzzy_clusterZentrum2frames, 'Fuzzy C-means 2 Frames');

%fuzzy c-means alle Frames
%[fuzzy_cluster1, fuzzy_cluster2 , fuzzy_komplett4alle, fuzzy_clusterZentrum4alle] = fuzzyCmeans_self(proj_gesamt, 2); %2 wird noch nicht gebraucht, Anzahl Cluster
%clusterPlot( fuzzy_cluster1, fuzzy_cluster2 , fuzzy_clusterZentrum4alle, 'Fuzzy C-means alle Frames');


%--------------------------------------------------------------------------
%Clustering mit K-means
%[kmeans_cluster1, kmeans_cluster2 ,kmeans_clusterzentrum] = kmeans_self(projektion_2frames, 2);
%clusterPlot( kmeans_cluster1, kmeans_cluster2 ,kmeans_clusterzentrum, 'K-means' );

%--------------------------------------------------------------------------
%Clustering mit Homographie-Fehler, vor geclustert durch Abstand
%Übergeben werden: 
%   - Vorgeclusterte Daten label, x, y
%   - homographie-matrix
%
%Zurückgegeben wird:
%   - berichtigte Daten getrennt in Clustern
%   - berichtigte Clusterdaten gesamt für Plot

proj_A = projektion_A';
proj_B = projektion_B';
projektionA_select_start = proj_A(1:20, :);
projektionB_select_start = proj_B(1:20, :);
projektion_start = [projektionA_select_start; projektionB_select_start];

%vorclustering_komplett := [label, index, abstand_cluster1, abstand_cluster2, x_vektoren, y_vektoren, p, projektion_daten_start]
vorclustering_komplett = [fuzzy_komplett2frames, projektion_2frames];

%ha := homographie, Abstand
[fuzzy_cluster_ha1, fuzzy_cluster_ha2 , fuzzy_clusterZentrum_ha] = fuzzyCmeans_homo_abstand(vorclustering_komplett, vektoren_2D, 2); %2 wird noch nicht gebraucht, Anzahl Cluster
clusterPlot( fuzzy_cluster_ha1, fuzzy_cluster_ha2 , fuzzy_clusterZentrum_ha, 'Fuzzy C-means, Homographie und Abstand Optimierung');

%--------------------------------------------------------------------------
%Clustering nur mit Homographie-Fehler
%vorclustering_komplett := [label, index, abstand_cluster1, abstand_cluster2, x_vektoren, y_vektoren, p, projektion_daten_start]
%[fuzzy_cluster_homo1, fuzzy_cluster_homo2 , fuzzy_clusterZentrum_homo] = fuzzyCmeans_homo(vorclustering_komplett, 2); %2 wird noch nicht gebraucht, Anzahl Cluster

[fuzzy_cluster_homo1, fuzzy_cluster_homo2 , fuzzy_clusterZentrum_homo] = fuzzyCmeans_homo_pur(projektion_2frames, vektoren_2D, 2);
clusterPlot( fuzzy_cluster_homo1, fuzzy_cluster_homo2 , fuzzy_clusterZentrum_homo, 'Fuzzy C-means, nur Homographie Optimierung');








