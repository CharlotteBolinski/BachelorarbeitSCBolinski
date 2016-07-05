%Vektoren Frame 1-2 ausw�hlen**********************************************
%frame_select( projektion_daten, frame1, frame2, frames_gesamt)
vektoren_A = frame_select( rauschen_A, 1, 2, 6);
vektoren_B = frame_select( rauschen_B, 1, 2, 6);
vektoren = [vektoren_A ; vektoren_B];

%projektion_2D = [rauschen(:,1), rauschen(:,2)];
vektoren_2D = [vektoren(:,1), vektoren(:,2)];

%Daten Frame 1-2 ausw�hlen*************************************************
projektion_A_select1 = frame_select(projektion_A', 1, 2, 6);
projektion_A_select2 = frame_select(projektion_A', 2, 3, 6);

%entspricht Bewegungsvektoren
%diff_A = projektion_A_select2-projektion_A_select1 

%Testing
%size(projektion_A_select1)
%size(projektion_A_select2)
%diff = projektion_A_select1(:,:) - projektion_A_select2(:,:);

%2. Cluster
projektion_B_select1 = frame_select(projektion_B', 1, 2, 6);
projektion_B_select2 = frame_select(projektion_B', 2, 3, 6);

%projektion_2D_select = [projektion_select(:,1), projektion_select(:,2)]

%--------------------------------------------------------------------------
%fuzzy c-means Frame 1-2
%[fuzzy_daten_homo, fuzzy_cluster_homo] = fuzzyCmeans_homo(vektoren_2D, 2);
%clusterPlot( fuzzy_daten_homo, fuzzy_cluster_homo, 'Fuzzy C-means, Homographie');

%--------------------------------------------------------------------------
%Homographie-Sch�tzung Frame 1-2
%Hier bekannt: es sind 2 K�rper/2 Cluster, sonst f�r jedes Cluster Iteration/Absch�tzung durchf�hren!
%function [ homographie_matrix,  homographie_fehler] = homographie_cluster( projektion_2frames, punkte_pro_frame)
%immer 2 Frames werden hier �bergeben!!
[homographie_matrixA, homographie_fehlerA] = homographie_cluster( projektion_A_select1, projektion_A_select2)
[homographie_matrixB, homographie_fehlerB] = homographie_cluster( projektion_B_select1, projektion_B_select2)

%function [ homographie_matrix,  homographie_fehler] = homographie( projektion_gesamt, anzahl_frames, frame_index_start, frame_index_ziel)
%[homographie_matrix, homographie_fehler] = homographie( projektion_A', 2, 1, 2)

%--------------------------------------------------------------------------
%Clustering mit Homographie-Fehler, vor geclustert durch Abstand



