%Rotation 2er Ebenen
%Plot und Datenerzeugung
%Autor: Sophie-Charlotte Bolinski, Matrikelnummer: 545839, htw-berlin

%Pfad zu Funktionen
%path('/Users/Lola/Documents/UNI/HTW/BACHELOR/MATLAB/funktionen',path);

%alte Daten löschen
delete csv/rotation_A.csv
delete csv/rotation_B.csv
figure('name', 'Rotation Bewegung');

%Ebenen erzeugen
%[ x y z Random_werte_A] = ebene3D_scatter( -2,2,-2,2,'z',20,[1 0 0]);
[ x y z Random_werte_A] = ebene3D_scatter( 0,2,0,2,'z',60,[1 0 0]);
[ x2 y2 z2 Random_werte_B] = ebene3D_scatter( 0,2,2,4,'z',60,[0 0 1]);

%drehachsen Mittelpunkt
%drehachse_A = [3 3 0];
%rotation_punkt_A = [3 3 0]; %Mittelpunkt, hier manuell berechnet
%rotation_punkt_B = [7 7 0]; %Mittelpunkt, hier manuell berechnet

rotation_punkt_A = [1 2 0]; %Mittelpunkt, hier manuell berechnet
rotation_punkt_B = [1 2 0]; %Mittelpunkt, hier manuell berechnet

%drehachse_A_norm = drehachse_A./norm(drehachse_A);
%norm(drehachse_A_norm)

%drehachse_A = drehachse_mittelpunkt( x, y, z );
%drehachse_B = drehachse_mittelpunkt( x2, y2, z2 );
%hold on
%arrow(rotation_punkt_A, [3 3 1]);
%arrow(rotation_punkt_B, [7 7 1]);

%Linearinterpolation
%einzeln..egal weil unterschiedliche CSV die wieder bel. konkatiniert werden können
%schreiben in eine csv
%transformation_export( input_werte_matrix, xEbene, yEbene, zEbene,color_array, winkel, rotation_achse, rotation_punkt, translation_punkt, CSV_name)
[Random_werte_A x y z, ebene1_alle] = transformation_export(Random_werte_A, x, y, z,[1 0 0], 30, [0 1 0] ,rotation_punkt_A,[0 0 0], 'csv/rotation_A.csv');
[Random_werte_B x2 y2 z2, ebene2_alle] = transformation_export(Random_werte_B, x2, y2, z2,[0 0 1], -30, [0 1 0],rotation_punkt_B ,[0 0 0], 'csv/rotation_B.csv');

%Video Framebilder erzeugen
%1. Ebenenkoordinaten auslesen + plot
%{
figure('name', 'Frame Bild');
x_plot1 = ebene1_alle(1:2, 1:2);
y_plot1 = ebene1_alle(1:2, 3:4);
z_plot1 = ebene1_alle(1:2, 5:6);
surf(x_plot1, y_plot1, z_plot1);
set(surface,'FaceColor',[1 0 0],'FaceAlpha',0.2);

x_plot2 = ebene2_alle(1:2, 1:2);
y_plot2 = ebene2_alle(1:2, 3:4);
z_plot2 = ebene2_alle(1:2, 5:6);
surf(x_plot2, y_plot2, z_plot2);
set(surface,'FaceColor',[0 0 1],'FaceAlpha',0.2);

xlabel('x');
ylabel('y');
zlabel('z');

%2. Daten zu der Ebene auslesen + plot
%}

%--> MUSS ANDERS BERECHNET WERDEN! WENN NUR 1 FRAME KEINE FUNKTIONALITÄT!
%Projektion
projektion_A = Data3D_Projektion('csv/rotation_A.csv', 1, 1, [2 2]);
projektion_B = Data3D_Projektion('csv/rotation_B.csv', 1, 1, [2 2]);
%proj_vektoren = [proj_vektoren_A ; proj_vektoren_B];
%dlmwrite('parallel_vektoren.csv', proj_vektoren , '-append');

%Bewegungsvektoren ausrechnen, Ausgangsdaten für Clustering
proj_vektoren_A = projektion_vektoren(projektion_A, 20); %20=Anzahl Punkte pro block
proj_vektoren_B = projektion_vektoren(projektion_B, 20);
proj_vektoren = [proj_vektoren_A ; proj_vektoren_B];
%dlmwrite('parallel_vektoren.csv', proj_vektoren , '-append');

%Rauschen auf Bewegungsvektoren
%rauschen_A = daten_rauschen(proj_vektoren_A, 0, 1); %daten, von, bis
%(random)
rauschen_A = daten_rauschen(proj_vektoren_A, 0, 1); %daten, von, bis (random)
rauschen_B = daten_rauschen(proj_vektoren_B, 0, 1);
rauschen = [rauschen_A ; rauschen_B];
%dlmwrite('parallel_rauschen.csv', rauschen , '-append');