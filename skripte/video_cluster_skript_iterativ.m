%Clustering über das ganze Video

%Übergabe: Daten pro Block, frames, vektorenA, vektorenB, projektionA, projektionB

%Daten auswählen%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
vektoren_A = proj_vektoren_A(1:20, :); %nur Vektoren Frame1->Frame2 holen, 1. Datensatz
vektoren_B = proj_vektoren_B(1:20, :);
vektoren_2D = [vektoren_A ; vektoren_B];

%1:numBlock anstatt 1:20
proj_20A = projektion_A(:, 1:20); %nur Vektoren Frame1->Frame2 holen, 1. Datensatz
proj_20B = projektion_B(:, 1:20);
projektion_1frame = [proj_20A'; proj_20B'];

%CLUSTERING%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Clustering nur mit Abstand-Fehler-----------------------------------------
[fuzzy_cluster1, fuzzy_cluster2 , fuzzy_clusterZentrum1frame, p_fuzzy] = fuzzyCmeans_self(projektion_1frame, 2); %2 wird noch nicht gebraucht, Anzahl Cluster

clusterPlot( fuzzy_cluster1, fuzzy_cluster2 , fuzzy_clusterZentrum1frame, 'Fuzzy C-means');
wahrscheinlichkeitPlot(p_fuzzy, 'Datenpunkte', 'Wahrscheinlichkeit', 'Wahrscheinlichkeit Cluster1 Fuzzy C-means',  'Wahrscheinlichkeit Cluster2 Fuzzy C-means');

%Clustering nur mit Homographie-Fehler-------------------------------------
cluster_input = [fuzzy_cluster1; fuzzy_cluster2]

[fuzzy_cluster_homo1, fuzzy_cluster_homo2 , fuzzy_clusterZentrum_homo, p_homo] = fuzzyCmeans_homo_pur(cluster_input, vektoren_2D,fuzzy_clusterZentrum1frame, p_fuzzy, 2);

clusterPlot( fuzzy_cluster_homo1, fuzzy_cluster_homo2 , fuzzy_clusterZentrum_homo, 'Fuzzy C-means, nur Homographie Optimierung');
wahrscheinlichkeitPlot(p_fuzzy, 'Datenpunkte', 'Wahrscheinlichkeit', 'Wahrscheinlichkeit Cluster1 Homographie',  'Wahrscheinlichkeit Cluster2 Homographie');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Clustering mit Homographie-Fehler, vor geclustert durch Abstand AUTONOM
%{
[fuzzy_cluster_ha_autonom1, fuzzy_cluster_ha_autonom2 , fuzzy_clusterZentrum_ha_autonom, p_h_autonom, p_a_autonom] = fuzzyCmeans_homo_abstand_autonom(projektion_1frame, vektoren_2D, 2); %2 wird noch nicht gebraucht, Anzahl Cluster
clusterPlot( fuzzy_cluster_ha_autonom1, fuzzy_cluster_ha_autonom2 , fuzzy_clusterZentrum_ha_autonom, 'Fuzzy C-means, Homographie und Abstand Optimierung AUTONOM');

%plot der Wahrscheinlichkeit
%homographie
size_ph = size(p_h_autonom);
rows_ph = size_ph(1);
r_ph = 1:rows_ph;

figure('name', 'Wahrscheinlichkeit Fuzzy C-means 2Faktoren Homographie AUTONOM');
plot(r_ph, p_h_autonom(:,1), 'r', r_ph, p_h_autonom(:,2), 'b');
title('Wahrscheinlichkeit Fuzzy C-means 2Faktoren Homographie AUTONOM')

%abstand
size_pa = size(p_a_autonom);
rows_pa = size_pa(1);
r_pa = 1:rows_pa;

figure('name', 'Wahrscheinlichkeit Fuzzy C-means 2Faktoren Abstand AUTONOM');
plot(r_pa, p_a_autonom(:,1), 'r', r_pa, p_a_autonom(:,2), 'b');
xlabel('Datenpunkte');
ylabel('Wahrscheinlichkeit');
title('Wahrscheinlichkeit Fuzzy C-means 2Faktoren Abstand AUTONOM')



%ha := homographie, Abstand
[fuzzy_cluster_ha1, fuzzy_cluster_ha2 , fuzzy_clusterZentrum_ha, p_h, p_a] = fuzzyCmeans_homo_abstand(cluster_input, vektoren_2D,fuzzy_clusterZentrum1frame, p_fuzzy, 2); %2 wird noch nicht gebraucht, Anzahl Cluster
clusterPlot( fuzzy_cluster_ha1, fuzzy_cluster_ha2 , fuzzy_clusterZentrum_ha, 'Fuzzy C-means, Homographie und Abstand Optimierung');

%plot der Wahrscheinlichkeit
%homographie
size_ph = size(p_h);
rows_ph = size_ph(1);
r_ph = 1:rows_ph;

figure('name', 'Wahrscheinlichkeit Fuzzy C-means 2Faktoren Homographie');
plot(r_ph, p_h(:,1), r_ph, p_h(:,2));
title('Wahrscheinlichkeit Fuzzy C-means 2Faktoren Homographie')

%abstand
size_pa = size(p_a);
rows_pa = size_pa(1);
r_pa = 1:rows_pa;

figure('name', 'Wahrscheinlichkeit Fuzzy C-means 2Faktoren Abstand');
plot(r_pa, p_a(:,1), r_pa, p_a(:,2));
xlabel('Datenpunkte');
ylabel('Wahrscheinlichkeit');
title('Wahrscheinlichkeit Fuzzy C-means 2Faktoren Abstand')
%}