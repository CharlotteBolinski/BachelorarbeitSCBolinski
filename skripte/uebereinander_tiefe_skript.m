%diagonal übereinander bewegende Ebenen
%Plot und Datenerzeugung
%Autor: Sophie-Charlotte Bolinski, Matrikelnummer: 545839, htw-berlin

%Pfad zu Funktionen
path('/Users/Lola/Documents/UNI/HTW/BACHELOR/MATLAB/funktionen',path);

%alte Daten löschen
delete uebereinander_A.csv
delete uebereinander_B.csv

%Ebenen erzeugen
[ x y z Random_werte_A] = ebene3D_scatter( 0,2,0,2,'z',20,[1 0 0]);
[ x2 y2 z2 Random_werte_B] = ebene3D_scatter( 4,6,0,2,'z',20,[0 1 0]);

%Linearinterpolation
[Random_werte_A x y z] = transformation_export(Random_werte_A, x, y, z, [1 0 0], 0, [0 1 0],[2 2 1], 'uebereinander_A.csv')
[Random_werte_B x2 y2 z2] = transformation_export(Random_werte_B, x2, y2, z2,[0 1 0], 0, [0 1 0],[-2 2 1], 'uebereinander_B.csv')

%Projektion
projektion_A = Data3D_Projektion('uebereinander_A.csv', 1, 1, [2 2]);
projektion_B = Data3D_Projektion('uebereinander_B.csv', 1, 1, [2 2]);

%Bewegungsvektoren ausrechnen, Ausgangsdaten für Clustering
%Rauschen JA, NEIN hier einstellen?
proj_vektoren_A = projektion_vektoren(projektion_A, 20); %20=Anzahl Punkte pro block
proj_vektoren_B = projektion_vektoren(projektion_B, 20);
proj_vektoren = [proj_vektoren_A ; proj_vektoren_B];
%dlmwrite('parallel_vektoren.csv', proj_vektoren , '-append');

%Rauschen auf Bewegungsvektoren
rauschen_A = daten_rauschen(proj_vektoren_A, 0, 1); %daten, von, bis (random)
rauschen_B = daten_rauschen(proj_vektoren_B, 0, 1);
rauschen = [rauschen_A ; rauschen_B];
%dlmwrite('parallel_rauschen.csv', rauschen , '-append');

%Clustering
%[label,energy,model] = kmeans(proj_vektoren',2); %2 Cluster, später dynamisch
%projektion_2D = [proj_vektoren(:,1), proj_vektoren(:,2)];

[label,energy,model] = kmeans(rauschen',2);
projektion_2D = [rauschen(:,1), rauschen(:,2)];

figure
plotClass(projektion_2D', label);
xlabel('x');
ylabel('y');