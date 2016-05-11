%Reduzierten auf eine Transformationsmatrix

%---------------------------------------------------------------------------
%mit String-Übergabe
[ x y z Random_werte] = ebene3D_scatter( 2,4,'z',20);

%Test
%transformData3D(Random_werte,30,[0 0 1],[2 2 2])
%transformEbene3D( x,y,z,30,[0 0 1],[2 2 2])
%transformation_matrix_calc(30,[0 0 1],[2 2 2])

%Linearinterpolation
%Ebenentransformation: Rundungsfehler!
transformation_export(Random_werte, x, y, z, 30, [0 0 1],[2 2 2],'1Sekunde.csv')

%Test
%geht - sogar kein Rundungsfehler.. nur beim Winkel?
transformation_export(Random_werte, x, y, z, 0, [0 0 1],[2 2 2], '1Sekunde.csv')

%geht - sogar kein Rundungsfehler.. nur bei Matrixmultiplikation...Addition und Multi?
transformation_export(Random_werte, x, y, z, 30, [0 0 1],[0 0 0],'1Sekunde.csv')

%---------------------------------------------------------------------------
%Ohne Transformationsmatrix-Berechnung in der Funktion
[ x y z Random_werte] = ebene3D_scatter( 2,4,'z',20);

[ transformation_matrix ] = transformation_matrix_calc(30, [0 0 1],[2 2 2]);

%Test
%transformData3D(Random_werte,transformation_matrix)
%transformEbene3D( x,y,z,transformation_matrix)

transformation_export(Random_werte, x, y, z, 0, [0 0 1],[2 2 2], '1Sekunde.csv')

