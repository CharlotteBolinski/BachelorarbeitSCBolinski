%CLUSTERING GANZES VIDEO -- ITERATIV --------------------------------------
werte_pro_block = 60;
anzahl_frames = 3; %frames-2 wegen vektoren -1 und index -1

mitglieder_pro_iteration = zeros(anzahl_frames, 2);
mittlerer_homof = zeros(werte_pro_block*2, 2);
anzahl_fehler_fuzzy = zeros(anzahl_frames, 1);
anzahl_fehler_homo = zeros(anzahl_frames, 1);

homographie_fehler_sum = zeros(werte_pro_block*2,2);

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

eins = ones(werte_pro_block,1); %ground truth
zwei = ones(werte_pro_block,1).*2;
cluster1_wahr = [eins, proj_A]; %Optimale Daten
cluster2_wahr = [zwei, proj_B];
index_wahr = 1:(2*werte_pro_block);

wahr = [cluster1_wahr; cluster2_wahr];
wahr_index = [wahr, index_wahr'];
%clusterPlot(cluster1_wahr, cluster2_wahr, fuzzy_clusterZentrum1frame, 'Richtige Daten');

%Optimalfall Wahrscheinlichkeitsverteilung

p1 = zeros(werte_pro_block,1);
p2 = ones(werte_pro_block,1);

p1_plot = [p1; p2];
p2_plot = [p2; p1];

figure('name','AAAAAAA');
plot(p1_plot, 'r');
hold on
plot(p2_plot, 'b');
hold off

xlabel('Werte sortiert nach Wahrscheinlichkeit');
ylabel('Wahrscheinlichkeit');
set(gca,'FontSize',18);


%CLUSTERING%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Clustering nur mit Abstand-Fehler-----------------------------------------
[fuzzy_cluster1, fuzzy_cluster2 , vektoren1, vektoren2, fuzzy_clusterZentrum1frame, p_fuzzy] = fuzzyCmeans_self(projektion_start_index, vektoren_index, 2); %2 wird noch nicht gebraucht, Anzahl Cluster

p_fuzzy_sort = sortrows(p_fuzzy, 1);
wahrscheinlichkeitPlot(p_fuzzy_sort, 'Datenpunkte', 'Wahrscheinlichkeit', 'Wahrscheinlichkeit Cluster1 Fuzzy C-means',  'Wahrscheinlichkeit Cluster2 Fuzzy C-means');

%Kennzeichnung der zu Ground Truth unterschiedlichen Daten
[fehler_f, anzahl_fehler_f] = unterschiedPlot_fuzzy(cluster1_wahr, cluster2_wahr, fuzzy_cluster1, fuzzy_cluster2, vektoren1, vektoren2, fuzzy_clusterZentrum1frame, 'g', 'Fuzzy C-means unterschied', 'Fehler falsch zugeordnet, Fuzzy');
%clusterPlot( fuzzy_cluster1, fuzzy_cluster2 , fuzzy_clusterZentrum1frame, 'Fuzzy C-means');

%Clustering zusätzlich mit Homographie-Fehler------------------------------
cluster_input = [fuzzy_cluster1; fuzzy_cluster2]; %Vorclustering
%cluster_input = [eins, proj_A; zwei, proj_B]; %Optimale Daten

vektor_input = [vektoren1; vektoren2];

%Hier die unterschiedlichen Methodennamen und richtigen Parameter eintragen um die unterschiedlichen Ergebnisse zu sehen
[output_daten_homo, fuzzy_cluster_homo1, fuzzy_cluster_homo2, homographie_fehler_index, homographie_daten, homographie_init_index] = fuzzyCmeans_homo_mad(wahr_index, cluster_input, vektor_input, 2);

%Summe Homographie Fehler
homographie_fehler_sum = homographie_fehler_sum + homographie_fehler_index(:,1:2);

%Kennzeichnung der zu Ground Truth unterschiedlichen Daten
[fehler_h, anzahl_fehler_h] = unterschiedPlot_homo(wahr_index, output_daten_homo, homographie_init_index, fuzzy_clusterZentrum1frame, 'm', 'Homographie unterschied', 'Fehler falsch zugeordnet, Homographie', 'n');
%clusterPlot(fuzzy_cluster_homo1, fuzzy_cluster_homo2, fuzzy_clusterZentrum1frame, 'Fuzzy C-means, zusätzlich mit Homographie');

%Speichern der Analysewerte------------------------------------------------
s_1 = size(fuzzy_cluster_homo1);
s_2 = size(fuzzy_cluster_homo2);

%Änderung der Mitglieder pro Iteration
mitglieder_pro_iteration(f+1, 1) = s_1(1);
mitglieder_pro_iteration(f+1, 2) = s_2(1);

%Falsche Werte pro Iteration
anzahl_fehler_fuzzy(f+1, 1) = anzahl_fehler_f;
anzahl_fehler_homo(f+1, 1) = anzahl_fehler_h;

end

%Mittlerer Homographie Fehler und Cluster Zuweisung
homographie_diff = homographie_fehler_sum./anzahl_frames;
homographie_clustering = [zeros(werte_pro_block*2,1), homographie_daten, zeros(werte_pro_block*2,1)];

for cl = 1:(werte_pro_block*2)
    
    if homographie_diff(cl,1) < homographie_diff(cl,2)
        homographie_clustering(cl,1)=1;
    else
        homographie_clustering(cl,1)=2;
    end
    
end

%hcl =  homographie_clustering

%show_video_cl = homographie_clustering
video_cluster1 = homographie_clustering(homographie_clustering(:,1) == 1, :);
video_cluster2 = homographie_clustering(homographie_clustering(:,1) == 2, :);

%clusterPlot(video_cluster1, video_cluster2, fuzzy_clusterZentrum1frame, 'Clustering Ergebnis Video Sequenz!');
unterschiedPlot_video(cluster1_wahr, cluster2_wahr, video_cluster1, video_cluster2, vektoren1, vektoren2, fuzzy_clusterZentrum1frame, 'm', 'Clustering Ergebnis Video Sequenz!', 'Fehler falsch zugeordnet, Ergebnis');


%Analyse Plots-------------------------------------------------------------
%Plot der Mitglieder pro Iteration
it = 1:anzahl_frames;

figure('name', 'Mitglieder pro Iteration');
plot(it, mitglieder_pro_iteration(:,1),'r');
hold on
plot(it, mitglieder_pro_iteration(:,2),'b');
xlabel('Iterationen');
ylabel('Mitglieder');
set(gca,'FontSize',18);
%title('Mitglieder pro Iteration');

show_fehler_fuzzy = anzahl_fehler_fuzzy
show_fehler_homo = anzahl_fehler_homo;


figure('name', 'Falsche Werte Fuzzy C-means und Homographie');
plot(it, anzahl_fehler_fuzzy(:,1),'g');
%xlabel('Iterationen');
%ylabel('Falsche Werte');
%title('Falsch zugeordnete Werte, Fuzzy C-means');
hold on

%figure('name', 'Falsche Werte Homographie');
plot(it, anzahl_fehler_homo(:,1),'m');
xlabel('Iterationen');
ylabel('Falsche Werte');
set(gca,'FontSize',18);
%title('Falsch zugeordnete Werte, Homographie');
hold off
