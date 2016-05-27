%diagonal übereinander bewegende Ebenen
%Plot und Datenerzeugung
%Autor: Sophie-Charlotte Bolinski, Matrikelnummer: 545839, htw-berlin

%Ebenen erzeugen
[ x y z Random_werte] = ebene3D_scatter( 0,2,0,2,'z',20,[1 0 0]);
[ x2 y2 z2 Random_werte2] = ebene3D_scatter( 4,6,0,2,'z',20,[0 1 0]);

%Linearinterpolation

%einzeln..egal weil unterschiedliche CSV die wieder bel. konkatiniert werden können
%schreiben in eine csv
[Random_werte x y z] = transformation_export(Random_werte, x, y, z, [1 0 0], 0, [0 1 0],[5 5 0], 'uebereinander.csv')
[Random_werte2 x2 y2 z2] = transformation_export(Random_werte2, x2, y2, z2,[0 1 0], 0, [0 1 0],[-5 5 0], 'uebereinander.csv')

%Projektion
projektion = Data3D_Projektion('uebereinander_projektion.csv','uebereinander.csv', 1, 1, [2 2])

%Clustering
[label,energy,model] = kmeans(projektion,2); %2 Cluster, später dynamisch
projektion_2D = [projektion(1,:); projektion(2,:)];
plotClass(projektion_2D, label);
xlabel('x');
ylabel('y');