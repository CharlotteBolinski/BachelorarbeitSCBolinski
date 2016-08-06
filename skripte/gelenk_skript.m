%Rotation 2er Ebenen
%Plot und Datenerzeugung
%Autor: Sophie-Charlotte Bolinski, Matrikelnummer: 545839, htw-berlin

%Pfad zu Funktionen
%path('/Users/Lola/Documents/UNI/HTW/BACHELOR/MATLAB/funktionen',path);

%alte Daten löschen
delete csv/gelenk_A.csv
delete csv/gelenk_B.csv
figure('name', 'Rotation Bewegung');

werte_pro_ebene = 60;
frames = 5;

%Ebenen erzeugen
%[ x y z Random_werte_A] = ebene3D_scatter( -2,2,-2,2,'z',20,[1 0 0]);
[ x y z Random_werte_A] = ebene3D_scatter( 0,6,0,3,'z',werte_pro_ebene,[1 0 0]);
[ x2 y2 z2 Random_werte_B] = ebene3D_scatter( 5.8,11.8,0,3,'z',werte_pro_ebene,[0 0 1]);

%Punke um die Ebene A und B rotieren sollen--Gelenkpunkt
rotation_punkt_A = [5.5 1 0]; %Mittelpunkt, hier manuell berechnet
rotation_punkt_B = [6.2 1 0]; %Mittelpunkt, hier manuell berechnet

%Linearinterpolation
%einzeln..egal weil unterschiedliche CSV die wieder bel. konkatiniert werden können
%schreiben in eine csv

[Random_werte_A x y z] = transformation_export(Random_werte_A, x, y, z,[1 0 0], 60, [0 0 1] ,rotation_punkt_A,[0 0 0], 'csv/gelenk_A.csv');
[Random_werte_B x2 y2 z2] = transformation_export(Random_werte_B, x2, y2, z2,[0 0 1], -60, [0 0 1],rotation_punkt_B ,[0 0 0], 'csv/gelenk_B.csv');


%--> MUSS ANDERS BERECHNET WERDEN! WENN NUR 1 FRAME KEINE FUNKTIONALITÄT!
%Projektion
projektion_A = Data3D_Projektion('csv/gelenk_A.csv', 1, 1, [2 2]);
projektion_B = Data3D_Projektion('csv/gelenk_B.csv', 1, 1, [2 2]);
%proj_vektoren = [proj_vektoren_A ; proj_vektoren_B];
%dlmwrite('parallel_vektoren.csv', proj_vektoren , '-append');

%Bewegungsvektoren ausrechnen, Ausgangsdaten für Clustering
proj_vektoren_A = projektion_vektoren(projektion_A, frames); %25=Anzahl Frames
proj_vektoren_B = projektion_vektoren(projektion_B, frames);
proj_vektoren = [proj_vektoren_A ; proj_vektoren_B];
%dlmwrite('parallel_vektoren.csv', proj_vektoren , '-append');

%Rauschen auf Bewegungsvektoren
%rauschen_A = daten_rauschen(proj_vektoren_A, 0, 1); %daten, von, bis
%(random)
rauschen_A = daten_rauschen(proj_vektoren_A, 0, 1); %daten, von, bis (random)
rauschen_B = daten_rauschen(proj_vektoren_B, 0, 1);
rauschen = [rauschen_A ; rauschen_B];
%dlmwrite('parallel_rauschen.csv', rauschen , '-append');
