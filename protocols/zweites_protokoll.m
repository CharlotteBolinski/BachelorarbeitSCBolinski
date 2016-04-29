%Befehlsprotokoll 27.04.16

%Ebene erzeugen mit zuf�llig verteilten Punkten ebene3D_scatter( von,bis,zeroKomponente,anzahlRandom)
[ x y z Random_werte ebene_handle punkte_handle] = ebene3D_scatter( 2,4,'z',20);

%Rotation der Ebene um beliebige Achse, �bergeben als letztes Argument in
%Form eines Vektors rotateData3D_matrix_beliebigeAchse(random_werte,xEbene,yEbene,zEbene,winkel,achse)
[ Rotation_werte ebene_handle punkte_handle] = rotateData3D_matrix_beliebigeAchse(Random_werte,x,y,z,30,[0 0 1]);

%Rotation mit M�glichkeit das Rotationszentrum anzugeben
%function [ Rotation_werte, ebene_werte, ebene_handle, punkte_handle] = rotateData3D_matrix_RotationTranslationZentrum(random_werte,xEbene,yEbene,zEbene,rotation_winkel,rotation_achse,rotation_zentrum,translation)
[ Rotation_werte ebene_handle punkte_handle] = rotateData3D_matrix_RotationTranslationZentrum(Random_werte,x,y,z,30,[1 1 1],[0 0 1],[2 2 2]);