%parallel aneinander vorbei bewegende Ebenen
%Plot und Datenerzeugung
%Autor: Sophie-Charlotte Bolinski, Matrikelnummer: 545839, htw-berlin

%Pfad zu Funktionen
path('/Users/Lola/Documents/UNI/HTW/BACHELOR/MATLAB/funktionen',path);

%alte Daten löschen
delete csv/parallel_A.csv
delete csv/parallel_B.csv
figure('name', 'Parallele Bewegung');

%Ebenen erzeugen
%[ x y z Random_werte_A] = ebene3D_scatter( -2,2,-2,2,'z',20,[1 0 0]);
[ x y z Random_werte_A] = ebene3D_scatter( 2,4,2,4,'z',20,[1 0 0]);
[ x2 y2 z2 Random_werte_B] = ebene3D_scatter( 6,8,6,8,'z',20,[0 1 0]);

%drehachsen Mittelpunkt
%drehachse_A = [3 3 0];
rotation_punkt_A = [0 0 0]; %Mittelpunkt, hier manuell berechnet
rotation_punkt_B = [0 0 0]; %Mittelpunkt, hier manuell berechnet

%Linearinterpolation
%einzeln..egal weil unterschiedliche CSV die wieder bel. konkatiniert werden können
%schreiben in eine csv
%ersten Datensatz berücksichtigen
dlmwrite('csv/parallel_A.csv', Random_werte_A, '-append');
dlmwrite('csv/parallel_B.csv', Random_werte_B, '-append');
%Transformationen
[Random_werte_A x y z] = transformation_export(Random_werte_A, x, y, z,[1 0 0], 0, [0 0 1] ,rotation_punkt_A,[0 3 0], 'csv/parallel_A.csv');
[Random_werte_B x2 y2 z2] = transformation_export(Random_werte_B, x2, y2, z2,[0 1 0], 0, [0 0 1],rotation_punkt_B ,[0 -3 0], 'csv/parallel_B.csv');

%Projektion
projektion_A = Data3D_Projektion('csv/parallel_A.csv', 1, 1, [2 2]);
projektion_B = Data3D_Projektion('csv/parallel_B.csv', 1, 1, [2 2]);
%proj_A = projektion_A';
%proj_B = projektion_B';
%proj_gesamt = [projektion_A'; projektion_B'];


%Bewegungsvektoren ausrechnen, Ausgangsdaten für Clustering --> MUSS ANDERS
%BERECHNET WERDEN! WENN NUR 1 FRAME KEINE FUNKTIONALITÄT!
proj_vektoren_A = projektion_vektoren(projektion_A, 6); %20=Anzahl Punkte pro block
proj_vektoren_B = projektion_vektoren(projektion_B, 6);
proj_vektoren = [proj_vektoren_A ; proj_vektoren_B];
%dlmwrite('parallel_vektoren.csv', proj_vektoren , '-append');

%Bewegungsvektoren plotten - Versuch
%figure()
%quiver(projektion_A(:,1),  projektion_A(:,2), projektion_A(:,1),  projektion_A(:,2));
%quiver3(Random_werte_A(:,1), Random_werte_A(:,2), Random_werte_A(:,3), Random_werte_A(:,1), Random_werte_A(:,2), Random_werte_A(:,3))
%quiver3(Z,U,V,W)
%Nur Anfangspunkte von den Vektoren... oder mittlerer Punkt
%quiver(proj_A(:,1:), proj_A(:,2), proj_vektoren_A(:,1),proj_vektoren_A(:,2))

%Rauschen auf Bewegungsvektoren
rauschen_A = daten_rauschen(proj_vektoren_A, 0, 1); %daten, von, bis (random)
rauschen_B = daten_rauschen(proj_vektoren_B, 0, 1);
rauschen = [rauschen_A ; rauschen_B];
%dlmwrite('parallel_rauschen.csv', rauschen , '-append');

%--Clustering--------------------------------------------------------------
%projektion_2D = [proj_vektoren(:,1), proj_vektoren(:,2)];
projektion_2D_alle = [rauschen(:,1), rauschen(:,2)];

%frame_select( projektion_daten, frame1, frame2, frames_gesamt)
frames_A = frame_select( rauschen_A, 1, 2, 6);
frames_B = frame_select( rauschen_B, 1, 2, 6);
frames = [frames_A ; frames_B];

%projektion_2D = [rauschen(:,1), rauschen(:,2)];
projektion_2D = [frames(:,1), frames(:,2)];

%--eigener fuzzyCmeans-----------------------------------------------------
%Clustering Bewegungsvektoren
[fuzzy_daten, fuzzy_cluster] = fuzzyCmeans_self(projektion_2D, 2);
clusterPlot(fuzzy_daten, fuzzy_cluster, 'Fuzzy C-means');

%--eigener fuzzyCmeans homographie-----------------------------------------
%Clustering Bewegungsvektoren
[fuzzy_daten_homo, fuzzy_cluster_homo] = fuzzyCmeans_homo(projektion_2D, 2);
clusterPlot( fuzzy_daten_homo, fuzzy_cluster_homo, 'Fuzzy C-means, Homographie' );

%--eigener kmeans----------------------------------------------------------
%Clustering Bewegungsvektoren
%[kmeans_daten,kmeans_cluster] = kmeans_self(projektion_2D, 2);
%clusterPlot( kmeans_daten, kmeans_cluster, 'K-means' );
