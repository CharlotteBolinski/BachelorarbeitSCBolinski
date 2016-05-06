%Befehlsprotokoll 27.04.16

%Ebene erzeugen mit zufällig verteilten Punkten ebene3D_scatter( von,bis,zeroKomponente,anzahlRandom)
[ x y z Random_werte ebene_handle punkte_handle] = ebene3D_scatter( 2,4,'z',20);

%Rotation der Ebene um beliebige Achse, übergeben als letztes Argument in
%Form eines Vektors rotateData3D_matrix_beliebigeAchse(random_werte,xEbene,yEbene,zEbene,winkel,achse)
[ Rotation_werte ebene_handle punkte_handle] = rotateData3D_matrix_beliebigeAchse(Random_werte,x,y,z,30,[0 0 1]);

%Rotation mit Möglichkeit das Rotationszentrum anzugeben
%function [ Rotation_werte, ebene_werte, ebene_handle, punkte_handle] = rotateData3D_matrix_RotationTranslationZentrum(random_werte,xEbene,yEbene,zEbene,rotation_winkel,rotation_achse,rotation_zentrum,translation)
[ Rotation_werte ebene_handle punkte_handle] = rotateData3D_matrix_RotationTranslationZentrum(Random_werte,x,y,z,30,[1 1 1],[0 0 1],[2 2 2]);

%Linearinterpolation
Transformation_frame_export(Random_werte, x, y, z, 30, [0 0 1], [1 1 1], [4 4 4]);

%------
[ x y z Random_werte ebene_handle punkte_handle] = ebene3D_scatter( 2,4,'z',20);
[ Rotation_werte xRot yRot zRot] = rotateData3D_matrix_RotationTranslationZentrum(Random_werte,x,y,z,30,[0 0 1],[1 1 1],[2 2 2]);
[ Rotation_werte xRot yRot zRot] = rotateData3D_matrix_RotationTranslationZentrum(Rotation_werte,xRot,yRot,zRot,30,[0 0 1],[1 1 1],[2 2 2]);

%-------
%Werteberechnung mit ausgelagerten Funktionen
[ x y z Random_werte] = ebene3D_scatter( 2,4,'z',20);
Transformation_frame_export_save(Random_werte, x, y, z, 30, [0 0 1],[2 2 2])

%Probe:
[ x y z Random_werte] = ebene3D_scatter( 2,4,'z',20);
rotateEbene3D_matrix_RotationTranslation( x,y,z,30,[0 0 1],[2 2 2])
hold on
rotateData3D_matrix_RotationTranslation(Random_werte,30,[0 0 1],[2 2 2])
%-->Probe liefert richtiges Ergebnis!

%--------
%Einzelberechnung der Matrizen

%Versuch nur Rotation..stimmt dann das Ergebnis?
[ x y z Random_werte] = ebene3D_scatter( 2,4,'z',20);
rotateEbene3D_matrix_RotationTranslation( x,y,z,30,[0 0 1])
hold on
rotateData3D_matrix_RotationTranslation(Random_werte,30,[0 0 1])
%Ja stimmt!!

%Wie Rotation und Translation zusammen ausfühern...was zuerst?
%Eigene Funktionen für Rotation und Translation schreiben, dann können
%diese nach belieben aufgerufen werden!!
%gültige Strings: rotate,translate,transform
%transformData3D_matrix_RotationTranslation(random_werte,rotation_winkel,rotation_achse,translation_punkt, artString)
[ x y z Random_werte] = ebene3D_scatter( 2,4,'z',20);
transformData3D(Random_werte,30,[0 0 1],[2 2 2], 'rotate')
transformData3D(Random_werte,30,[0 0 1],[2 2 2], 'translate')
hold on
transformEbene3D( xEbene,yEbene,zEbene,30,[0 0 1],[2 2 2], 'rotate')
transformEbene3D( xEbene,yEbene,zEbene,30,[0 0 1],[2 2 2], 'translate')

%Nuten der Funktionen in Transformation_frame_export
[ x y z Random_werte] = ebene3D_scatter( 2,4,'z',20);
[Random_werte xEbene yEbene zEbene] = Transformation_frame_export( Random_werte, x, y, z, 30, [0 0 1], [2 2 2], 'rotate', '1Sekunde.csv')

%geht noch nicht :(
[Random_werte xEbene yEbene zEbene] = Transformation_frame_export( Random_werte, xEbene, yEbene, zEbene, 30, [0 0 1], [2 2 2], 'transform', '1Sekunde.csv')

%Projektion
%[ X,Y ] = rotateDate3D_Projektion( CSV_name,daten_csv, fx, fy, principal_point)
[ X,Y ] = Data3D_Projektion( '1Sekunde_projektion.csv','1Sekunde.csv',1, 1, [1;1])

%Test
[ X,Y ] = Data3D_Projektion( '1Sekunde_projektion.csv','1Sekunde.csv', Random_werte,1, 1, [1;1])

