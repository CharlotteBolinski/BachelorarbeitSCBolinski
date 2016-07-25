%HIER PASSIERT ERSTMAL ALLES TESTWEISE NUR FÜR 2 FRAMES

%Vektoren Frame 1-2 auswählen**********************************************
vektoren_A = proj_vektoren_A(1:20, :); %nur Vektoren Frame1->Frame2 holen, 1. Datensatz
vektoren_B = proj_vektoren_B(1:20, :);
vektoren_2D = [vektoren_A ; vektoren_B];

%vektoren_2D = [vektoren(:,1), vektoren(:,2)];

%{
proj_40A = projektion_A(:, 1:40); %nur Vektoren Frame1->Frame2 holen, 1. Datensatz
proj_40B = projektion_B(:, 1:40);
projektion_2frames = [proj_40A'; proj_40B'];
%}

%1:numBlock anstatt 1:20
proj_20A = projektion_A(:, 1:20); %nur Vektoren Frame1->Frame2 holen, 1. Datensatz
proj_20B = projektion_B(:, 1:20);
projektion_1frame = [proj_20A'; proj_20B'];


%fuzzy c-means Frame 1-2
%Vorclustering macht vor allem mit den Positionen Sinn!!
%[fuzzy_cluster1, fuzzy_cluster2 , fuzzy_komplett, fuzzy_clusterZentrum] = fuzzyCmeans_self(vektoren_2D, 2); %2 wird noch nicht gebraucht, Anzahl Cluster
%[fuzzy_cluster1, fuzzy_cluster2 , fuzzy_clusterZentrum2frames, p_fuzzy] = fuzzyCmeans_self(projektion_2frames, 2); %2 wird noch nicht gebraucht, Anzahl Cluster
%clusterPlot( fuzzy_cluster1, fuzzy_cluster2 , fuzzy_clusterZentrum2frames, 'Fuzzy C-means 2 Frames');

[fuzzy_cluster1, fuzzy_cluster2 , fuzzy_clusterZentrum1frame, p_fuzzy] = fuzzyCmeans_self(projektion_1frame, 2); %2 wird noch nicht gebraucht, Anzahl Cluster
clusterPlot( fuzzy_cluster1, fuzzy_cluster2 , fuzzy_clusterZentrum1frame, 'Fuzzy C-means 2 Frames');

%plot der Wahrscheinlichkeit
size_p = size(p_fuzzy);
rows_p = size_p(1);
r_p = 1:rows_p;

%figure('name', 'Wahrscheinlichkeit Fuzzy C-means');
%plot(r_p, p_fuzzy(:,1), 'r', r_p, p_fuzzy(:,2), 'b');
%title('Wahrscheinlichkeit Fuzzy C-means')

figure('name', 'Wahrscheinlichkeit Cluster1 Fuzzy C-means');
plot(r_p, p_fuzzy(:,2), 'b');
title('Wahrscheinlichkeit Cluster1 Fuzzy C-means')

figure('name', 'Wahrscheinlichkeit Cluster2 Fuzzy C-means');
plot(r_p, p_fuzzy(:,1), 'r');
title('Wahrscheinlichkeit Cluster2 Fuzzy C-means')


%--------------------------------------------------------------------------
%Clustering mit K-means
%[kmeans_cluster1, kmeans_cluster2 ,kmeans_clusterzentrum] = kmeans_self(projektion_2frames, 2);
%clusterPlot( kmeans_cluster1, kmeans_cluster2 ,kmeans_clusterzentrum, 'K-means' );

%--------------------------------------------------------------------------
%Clustering nur mit Homographie-Fehler
%vorclustering_komplett := [label, index, abstand_cluster1, abstand_cluster2, x_vektoren, y_vektoren, p, projektion_daten_start]
%[fuzzy_cluster_homo1, fuzzy_cluster_homo2 , fuzzy_clusterZentrum_homo] = fuzzyCmeans_homo(vorclustering_komplett, 2); %2 wird noch nicht gebraucht, Anzahl Cluster

cluster_input = [fuzzy_cluster1; fuzzy_cluster2]

[fuzzy_cluster_homo1, fuzzy_cluster_homo2 , fuzzy_clusterZentrum_homo, p_homo] = fuzzyCmeans_homo_pur(cluster_input, vektoren_2D,fuzzy_clusterZentrum1frame, p_fuzzy, 2);
clusterPlot( fuzzy_cluster_homo1, fuzzy_cluster_homo2 , fuzzy_clusterZentrum_homo, 'Fuzzy C-means, nur Homographie Optimierung');


%plot der Wahrscheinlichkeit
size_phomo = size(p_homo);
rows_phomo = size_phomo(1);
r_phhomo = 1:rows_phomo;

%figure('name', 'Wahrscheinlichkeit Fuzzy C-means nur Homographie');
%plot(r_phhomo, p_homo(:,1), 'r', r_phhomo, p_homo(:,2), 'b');
%xlabel('Datenpunkte');
%ylabel('Wahrscheinlichkeit');
%title('Wahrscheinlichkeit Fuzzy C-means nur Homographie')

figure('name', 'Wahrscheinlichkeit Cluster1 Fuzzy C-means nur Homographie');
plot(r_phhomo, p_homo(:,1), 'r');
xlabel('Datenpunkte');
ylabel('Wahrscheinlichkeit');
title('Wahrscheinlichkeit Cluster1 Fuzzy C-means nur Homographie')

figure('name', 'Wahrscheinlichkeit Cluster2 Fuzzy C-means nur Homographie');
plot(r_phhomo, p_homo(:,2), 'b');
xlabel('Datenpunkte');
ylabel('Wahrscheinlichkeit');
title('Wahrscheinlichkeit Cluster2 Fuzzy C-means nur Homographie')
