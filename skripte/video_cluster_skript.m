%CLUSTERING GANZES VIDEO -- ITERATIV --------------------------------------
werte_pro_block = 60;
anzahl_frames = 3; %frames-2 wegen vektoren -1 und index -1

mitglieder_pro_iteration = zeros(anzahl_frames, 2);
mittlerer_homof = zeros(werte_pro_block*2, 2);
anzahl_fehler_fuzzy = zeros(anzahl_frames, 1);
anzahl_fehler_homo = zeros(anzahl_frames, 1);

homo_diff_pro_iteration = zeros(anzahl_frames, 2);
p_hsave = zeros(werte_pro_block*anzahl_frames,2);

for f = 0:(anzahl_frames-1)

%input(f*werte_pro_block+1:(f+1)*werte_pro_block, :)

%CLUSTERING 2 FRAMES 
%Daten auswählen%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
vektoren_A = proj_vektoren_A(f*werte_pro_block+1:(f+1)*werte_pro_block, :); %nur Vektoren Frame1->Frame2 holen, 1. Datensatz
vektoren_B = proj_vektoren_B(f*werte_pro_block+1:(f+1)*werte_pro_block, :);
vektoren_2D = [vektoren_A ; vektoren_B];

sv = size(vektoren_2D);
rv = sv(1);
index_vek = 1:rv;
vektoren_index = [vektoren_2D, index_vek'];

%nur Projektion start und die dazugehörigen Vektoren werden benötigt 
proj_A = projektion_A(f*werte_pro_block+1:(f+1)*werte_pro_block, :); %nur Vektoren Frame1->Frame2 holen, 1. Datensatz
proj_B = projektion_B(f*werte_pro_block+1:(f+1)*werte_pro_block, :);
projektion_start = [proj_A ; proj_B];

sp = size(projektion_start);
rp = sp(1);
index_proj = 1:rp;
projektion_start_index = [projektion_start, index_proj'];

%proj_A2 = projektion_A((f+1)*werte_pro_block+1:(f+2)*werte_pro_block, :); %nur Vektoren Frame1->Frame2 holen, 1. Datensatz
%proj_B2 = projektion_B((f+1)*werte_pro_block+1:(f+2)*werte_pro_block, :);
%projektion_start2 = [proj_A2 ; proj_B2];

eins = ones(werte_pro_block,1); %ground truth
zwei = ones(werte_pro_block,1).*2;
cluster1_wahr = [eins, proj_A]; %Optimale Daten
cluster2_wahr = [zwei, proj_B];
wahr = [cluster1_wahr; cluster2_wahr];
clusterPlot(cluster1_wahr, cluster2_wahr, fuzzy_clusterZentrum1frame, 'Richtige Daten');

%CLUSTERING%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Clustering nur mit Abstand-Fehler-----------------------------------------
[fuzzy_cluster1, fuzzy_cluster2 , vektoren1, vektoren2, fuzzy_clusterZentrum1frame, p_fuzzy] = fuzzyCmeans_self(projektion_start_index, vektoren_index, 2); %2 wird noch nicht gebraucht, Anzahl Cluster

%clusterPlot( fuzzy_cluster1, fuzzy_cluster2 , fuzzy_clusterZentrum1frame, 'Fuzzy C-means');

p_fuzzy_sort = sortrows(p_fuzzy, 1);
%wahrscheinlichkeitPlot(p_fuzzy_sort, 'Datenpunkte', 'Wahrscheinlichkeit', 'Wahrscheinlichkeit Cluster1 Fuzzy C-means',  'Wahrscheinlichkeit Cluster2 Fuzzy C-means');

%Kennzeichnung der zu Ground Truth unterschiedlichen Daten
[fehler_f, anzahl_fehler_f] = unterschiedPlot(cluster1_wahr, cluster2_wahr, fuzzy_cluster1, fuzzy_cluster2, fuzzy_clusterZentrum1frame, 'Fuzzy C-means unterschied');


%Clustering zusätzlich mit Homographie-Fehler------------------------------
cluster_input = [fuzzy_cluster1; fuzzy_cluster2]; %Vorclustering
%cluster_input = [eins, proj_A; zwei, proj_B]; %Optimale Daten
vektor_input = [vektoren1; vektoren2];

%Hier die unterschiedlichen Methodennamen eintragen um die unterschiedlichen Ergebnisse zu sehen
%Wahrscheinlichkeiten
%[fuzzy_cluster_homo1, fuzzy_cluster_homo2, homo_sort_fehler] = fuzzyCmeans_homo_vor(p_fuzzy, cluster_input, vektoren_2D, 2);

%Ausreißer
%[fuzzy_cluster_homo1, fuzzy_cluster_homo2, homo_sort_fehler] = fuzzyCmeans_homo_zaun2(cluster_input, vektor_input, 2);
[fuzzy_cluster_homo1, fuzzy_cluster_homo2, homo_sort_fehler] = fuzzyCmeans_homo_mad(cluster_input, vektor_input, fehler_f, 2);


%Kennzeichnung der zu Ground Truth unterschiedlichen Daten
[fehler_h, anzahl_fehler_h] = unterschiedPlot(cluster1_wahr, cluster2_wahr, fuzzy_cluster_homo1, fuzzy_cluster_homo2, fuzzy_clusterZentrum1frame, 'Homographie unterschied');

%clusterPlot(fuzzy_cluster_homo1, fuzzy_cluster_homo2, fuzzy_clusterZentrum1frame, 'Fuzzy C-means, zusätzlich mit Homographie');

%Clustering nur mit Homographie-Fehler-------------------------------------
%{
[fuzzy_cluster_homo1_pur, fuzzy_cluster_homo2_pur , cluster_zentrum, p_homo] = fuzzyCmeans_homo_pur_pur(projektion_start, vektoren_2D, 2);
clusterPlot(fuzzy_cluster_homo1_pur, fuzzy_cluster_homo2_pur , cluster_zentrum, 'Fuzzy C-means, nur mit Homographie');
%wahrscheinlichkeitPlot(p_homo, 'Datenpunkte', 'Wahrscheinlichkeit', 'Wahrscheinlichkeit Cluster1 Fuzzy C-means',  'Wahrscheinlichkeit Cluster2 Fuzzy C-means');
%}

%Speichern der Analysewerte------------------------------------------------
s_1 = size(fuzzy_cluster_homo1);
s_2 = size(fuzzy_cluster_homo2);

%Änderung der Mitglieder pro Iteration
mitglieder_pro_iteration(f+1, 1) = s_1(1);
mitglieder_pro_iteration(f+1, 2) = s_2(1);

%Änderung des Mittleren Homographie Fehlers pro Iteration
%mean_hf = mean(homo_sort_fehler)

%mittlerer_homographie_fehler (f+1, :) = mean_hf(1,2:3) %zaun
%mittlerer_homographie_fehler (f+1, :) = mean_hf(1,:);

%Falsche Werte pro Iteration
anzahl_fehler_fuzzy(f+1, 1) = anzahl_fehler_f;
anzahl_fehler_homo(f+1, 1) = anzahl_fehler_h;

end

%Analyse Plots-------------------------------------------------------------
%Plot der Mitglieder pro Iteration
it = 1:anzahl_frames;

figure();
plot(it, mitglieder_pro_iteration(:,1),'r',it, mitglieder_pro_iteration(:,2),'b');
xlabel = ('Iterationen');
ylabel = ('Mitglieder');
title('Mitglieder pro Iteration');

%{
figure();
plot(it, mittlerer_homographie_fehler(:,1),'r',it, mittlerer_homographie_fehler(:,2),'b');
xlabel = ('Iterationen');
ylabel = ('Mittlerer Homographie Fehler');
title('Mittlerer Homographie Fehler pro Iteration');

mean_alle_Punkte = mittlerer_homof./(frames+2)
mean_homo_gesamt = mean(mean_alle_Punkte)
%}

figure();
plot(it, anzahl_fehler_fuzzy(:,1),'g');
xlabel = ('Iterationen');
ylabel = ('Falsche Werte');
title('Falsch zugeordnete Werte, Fuzzy C-means');


figure();
plot(it, anzahl_fehler_homo(:,1),'g');
xlabel = ('Iterationen');
ylabel = ('Falsche Werte');
title('Falsch zugeordnete Werte, Homographie');

%{
%Vergleich der Punkte 
cluster_ges = [fuzzy_cluster_ha1; fuzzy_cluster_ha2];
cl_wahr_vgl1 = cluster_ges(1:20, 1);
cl_wahr_vgl2 = cluster_ges(21:40, 1);
cl = 1:20;

figure();
plot(cl, cl_wahr_vgl1, cl, cl_wahr_vgl2);
%}


%{
figure();
plot(it, homo_diff_pro_iteration(:,1),'r',it, homo_diff_pro_iteration(:,2),'b');
xlabel = ('iterationen')
ylabel = ('Mittlere Wahrscheinlichkeit der Homographie')
title('Mittlere Wahrscheinlichkeit der Homographie pro Iteration');


%truth
eins = ones(werte_pro_block,1); %ground truth
zwei = ones(werte_pro_block,1).*2;
cluster1_wahr = [eins, proj_A]; %Optimale Daten
cluster2_wahr = [zwei, proj_B];
clusterPlot(cluster1_wahr, cluster2_wahr, fuzzy_clusterZentrum1frame, 'Richtige Daten');


p_eins = [eins; zwei];
p_zwei = [zwei; eins];
p_wahr = [p_eins , p_zwei];
size_p = size( p_wahr);
rows_p = size_p(1);
r_p = 1:rows_p;
figure('name', 'Optimaler Fehler der Cluster');
plot(r_p, p_wahr(:,1), 'r', r_p, p_wahr(:,2), 'b');
title('Optimale Wahrscheinlichkeit der Cluster')
%}