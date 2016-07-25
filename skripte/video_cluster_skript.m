%CLUSTERING GANZES VIDEO -- ITERATIV
werte_pro_block = 40;
anzahl_frames = 2; %frames-2 wegen vektoren -1 und index -1

mitglieder_pro_iteration = zeros(anzahl_frames, 2);

homo_diff_pro_iteration = zeros(anzahl_frames, 2);
p_hsave = zeros(werte_pro_block*anzahl_frames,2);

for f = 0:(anzahl_frames-1)

%input(f*werte_pro_block+1:(f+1)*werte_pro_block, :)

%CLUSTERING 2 FRAMES 
%Daten auswählen%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
vektoren_A = proj_vektoren_A(f*werte_pro_block+1:(f+1)*werte_pro_block, :); %nur Vektoren Frame1->Frame2 holen, 1. Datensatz
vektoren_B = proj_vektoren_B(f*werte_pro_block+1:(f+1)*werte_pro_block, :);
vektoren_2D = [vektoren_A ; vektoren_B];

%nur Projektion start und die dazugehörigen Vektoren werden benötigt 
proj_A = projektion_A(f*werte_pro_block+1:(f+1)*werte_pro_block, :); %nur Vektoren Frame1->Frame2 holen, 1. Datensatz
proj_B = projektion_B(f*werte_pro_block+1:(f+1)*werte_pro_block, :);
projektion_start = [proj_A ; proj_B];

%CLUSTERING%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Clustering nur mit Abstand-Fehler-----------------------------------------
[fuzzy_cluster1, fuzzy_cluster2 , fuzzy_clusterZentrum1frame, p_fuzzy] = fuzzyCmeans_self(projektion_start, 2); %2 wird noch nicht gebraucht, Anzahl Cluster

clusterPlot( fuzzy_cluster1, fuzzy_cluster2 , fuzzy_clusterZentrum1frame, 'Fuzzy C-means');
wahrscheinlichkeitPlot(p_fuzzy, 'Datenpunkte', 'Wahrscheinlichkeit', 'Wahrscheinlichkeit Cluster1 Fuzzy C-means',  'Wahrscheinlichkeit Cluster2 Fuzzy C-means');

%{
%Vergleich der Punkte 
cluster_ges = [fuzzy_cluster1; fuzzy_cluster2];
cl_wahr_vgl1 = cluster_ges(1:20, 1);
cl_wahr_vgl2 = cluster_ges(21:40, 1);
cl = 1:20;

figure();
plot(cl, cl_wahr_vgl1, cl, cl_wahr_vgl2);
%}

%Clustering nur mit Homographie-Fehler-------------------------------------
cluster_input = [fuzzy_cluster1; fuzzy_cluster2]; %Vorclustering
%eins = ones(werte_pro_block,1); %ground truth
%zwei = ones(werte_pro_block,1).*2;
%cluster_input = [eins, proj_A; zwei, proj_B]; %Optimale Daten

[fuzzy_cluster_homo1, fuzzy_cluster_homo2 , homo_fehler] = fuzzyCmeans_homo_pur(cluster_input, vektoren_2D, 2);

%Clusterzentrum aus vorclustering wird geplottet
clusterPlot( fuzzy_cluster_homo1, fuzzy_cluster_homo2 , fuzzy_clusterZentrum1frame, 'Fuzzy C-means, nur Homographie Optimierung');

%Plot der Homographie Fehler
size_p = size( homo_fehler);
rows_p = size_p(1);
r_p = 1:rows_p;
figure('name', 'Homographie Fehler der Cluster');
plot(r_p, homo_fehler(:,2), 'r', r_p, homo_fehler(:,3), 'b');
title('Homographie Fehler der Cluster')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%ha := homographie, Abstand
%[fuzzy_cluster_ha1, fuzzy_cluster_ha2 , fuzzy_clusterZentrum_ha, p_h, p_a] = fuzzyCmeans_homo_abstand(cluster_input, vektoren_2D,fuzzy_clusterZentrum1frame, p_fuzzy, 2); %2 wird noch nicht gebraucht, Anzahl Cluster
%clusterPlot( fuzzy_cluster_ha1, fuzzy_cluster_ha2 , fuzzy_clusterZentrum_ha, 'Fuzzy C-means, Homographie und Abstand Optimierung');

%Plot verschiedener Analysewerte-------------------------------------------
s_1 = size(fuzzy_cluster_homo1);
s_2 = size(fuzzy_cluster_homo2);

%Änderung der Mitglieder pro Iteration
mitglieder_pro_iteration(f+1, 1) = s_1(1);
mitglieder_pro_iteration(f+1, 2) = s_2(1);

%Änderung der Homographie pro Iteration
%{
if f == 0 
    p_hsave = p_homo;
    p_hmean = mean(p_homo);
    homo_diff_pro_iteration(f+1, 1) = p_hmean(1);
    homo_diff_pro_iteration(f+1, 1) = p_hmean(2);
else
    p_hmean = mean(p_homo-p_hsave);
    homo_diff_pro_iteration(f+1, 1) = p_hmean(1);
    homo_diff_pro_iteration(f+1, 1) = p_hmean(2);
end
%}


%plot der Wahrscheinlichkeiten
%homographie
%wahrscheinlichkeitPlot(p_h, 'Datenpunkte', 'Wahrscheinlichkeit', '2Stufen Wahrscheinlichkeit Cluster1 Homographie',  '2Stufen Wahrscheinlichkeit Cluster2 Homographie');
%Abstand
%wahrscheinlichkeitPlot(p_a, 'Datenpunkte', 'Wahrscheinlichkeit', '2Stufen Wahrscheinlichkeit Cluster1 Abstand',  '2Stufen Wahrscheinlichkeit Cluster2 Abstand');

end
%{
%Vergleich der Punkte 
cluster_ges = [fuzzy_cluster_ha1; fuzzy_cluster_ha2];
cl_wahr_vgl1 = cluster_ges(1:20, 1);
cl_wahr_vgl2 = cluster_ges(21:40, 1);
cl = 1:20;

figure();
plot(cl, cl_wahr_vgl1, cl, cl_wahr_vgl2);
%}


%Plot der Mitglieder pro Iteration
it = 1:anzahl_frames;

figure();
plot(it, mitglieder_pro_iteration(:,1),'r',it, mitglieder_pro_iteration(:,2),'b');
xlabel = ('iterationen');
ylabel = ('mitglieder');
title('Mitglieder pro Iteration, Abstand');

%{
figure();
plot(it, homo_diff_pro_iteration(:,1),'r',it, homo_diff_pro_iteration(:,2),'b');
xlabel = ('iterationen')
ylabel = ('Mittlere Wahrscheinlichkeit der Homographie')
title('Mittlere Wahrscheinlichkeit der Homographie pro Iteration');
%}