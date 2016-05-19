%Ebenen erzeugen
[ x y z Random_werte] = ebene3D_scatter( 2,4,2,4,'z',20,[1 0 0]);
[ x2 y2 z2 Random_werte2] = ebene3D_scatter( 6,8,6,8,'z',20,[0 1 0]);

%Linearinterpolation

%einzeln..egal weil unterschiedliche CSV die wieder bel. konkatiniert werden können
%schreiben in eine csv
[Random_werte x y z] = transformation_export(Random_werte, x, y, z,[1 0 0], 0, [0 1 0],[0 5 0], 'parallel.csv')
[Random_werte2 x2 y2 z2] = transformation_export(Random_werte2, x2, y2, z2,[0 1 0], 0, [0 1 0],[0 -5 0], 'parallel.csv')

%Projektion
projektion = Data3D_Projektion('parallel_projektion.csv','parallel.csv', 1, 1, [2 2])

%Clustering
[label,energy,model] = kmeans(projektion,2); %2 Cluster, später dynamisch
projektion_2D = [projektion(1,:); projektion(2,:)];
plotClass(projektion_2D, label);
xlabel('x');
ylabel('y');