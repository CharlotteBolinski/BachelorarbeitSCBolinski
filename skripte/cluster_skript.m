%HIER PASSIERT ERSTMAL ALLES TESTWEISE NUR FÜR 2 FRAMES

%Vektoren Frame 1-2 auswählen**********************************************
vektoren_A = proj_vektoren_A(1:20, :); %nur Vektoren Frame1->Frame2 holen, 1. Datensatz
vektoren_B = proj_vektoren_B(1:20, :);
vektoren_2D = [vektoren_A ; vektoren_B];

%vektoren_2D = [vektoren(:,1), vektoren(:,2)];

proj_20A = projektion_A(1:20, :); %nur Vektoren Frame1->Frame2 holen, 1. Datensatz
proj_20B = projektion_B(1:20, :);
projektion_2frames = [proj_20A'; proj_20B'];


%fuzzy c-means Frame 1-2
%Vorclustering macht vor allem mit den Positionen Sinn!!
%[fuzzy_cluster1, fuzzy_cluster2 , fuzzy_komplett, fuzzy_clusterZentrum] = fuzzyCmeans_self(vektoren_2D, 2); %2 wird noch nicht gebraucht, Anzahl Cluster
[fuzzy_cluster1, fuzzy_cluster2 , fuzzy_clusterZentrum2frames, p_fuzzy] = fuzzyCmeans_self(projektion_2frames, 2); %2 wird noch nicht gebraucht, Anzahl Cluster
clusterPlot( fuzzy_cluster1, fuzzy_cluster2 , fuzzy_clusterZentrum2frames, 'Fuzzy C-means 2 Frames');

%Vergleich der Punkte 
size_cl_wahr = size(proj_20A);
rows_cl_wahr = size_cl_wahr(1);

cl_alg = [fuzzy_cluster1; fuzzy_cluster2]
cl_wahr_vgl = cl_alg(1:20, 1); %20 = werte pro block
cl = 1:20;

figure();
plot(cl, cl_wahr_vgl);


%{
%plot der Wahrscheinlichkeit
size_p = size(p_fuzzy);
rows_p = size_p(1);
r_p = 1:rows_p;

figure('name', 'Wahrscheinlichkeit Fuzzy C-means');
plot(r_p, p_fuzzy(:,1), r_p, p_fuzzy(:,2));
title('Wahrscheinlichkeit Fuzzy C-means')


%fuzzy c-means alle Frames
[fuzzy_cluster1, fuzzy_cluster2 , fuzzy_komplett4alle, fuzzy_clusterZentrum4alle] = fuzzyCmeans_self(proj_gesamt, 2); %2 wird noch nicht gebraucht, Anzahl Cluster
clusterPlot( fuzzy_cluster1, fuzzy_cluster2 , fuzzy_clusterZentrum4alle, 'Fuzzy C-means alle Frames');
%}

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

%{
%ha := homographie, Abstand
[fuzzy_cluster_ha1, fuzzy_cluster_ha2 , fuzzy_clusterZentrum_ha, p_h, p_a] = fuzzyCmeans_homo_abstand(vorclustering_komplett, vektoren_2D, 2); %2 wird noch nicht gebraucht, Anzahl Cluster
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
%--------------------------------------------------------------------------
%Clustering mit Homographie-Fehler, vor geclustert durch Abstand AUTONOM
[fuzzy_cluster_ha_autonom1, fuzzy_cluster_ha_autonom2 , fuzzy_clusterZentrum_ha_autonom, p_h_autonom, p_a_autonom] = fuzzyCmeans_homo_abstand_autonom(projektion_2frames, vektoren_2D, 2); %2 wird noch nicht gebraucht, Anzahl Cluster
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


%--------------------------------------------------------------------------
%Clustering nur mit Homographie-Fehler
%vorclustering_komplett := [label, index, abstand_cluster1, abstand_cluster2, x_vektoren, y_vektoren, p, projektion_daten_start]
%[fuzzy_cluster_homo1, fuzzy_cluster_homo2 , fuzzy_clusterZentrum_homo] = fuzzyCmeans_homo(vorclustering_komplett, 2); %2 wird noch nicht gebraucht, Anzahl Cluster
%{
[fuzzy_cluster_homo1, fuzzy_cluster_homo2 , fuzzy_clusterZentrum_homo, p_homo] = fuzzyCmeans_homo_pur(projektion_2frames, vektoren_2D, 2);
clusterPlot( fuzzy_cluster_homo1, fuzzy_cluster_homo2 , fuzzy_clusterZentrum_homo, 'Fuzzy C-means, nur Homographie Optimierung');


%plot der Wahrscheinlichkeit
size_phomo = size(p_homo);
rows_phomo = size_phomo(1);
r_phhomo = 1:rows_phomo;

figure('name', 'Wahrscheinlichkeit Fuzzy C-means nur Homographie');
plot(r_phhomo, p_homo(:,1), 'r', r_phhomo, p_homo(:,2), 'b');
xlabel('Datenpunkte');
ylabel('Wahrscheinlichkeit');
title('Wahrscheinlichkeit Fuzzy C-means nur Homographie')
%}