%parallel aneinander vorbei bewegende Ebenen
%Plot und Datenerzeugung
%Autor: Sophie-Charlotte Bolinski, Matrikelnummer: 545839, htw-berlin

%Pfad zu Funktionen
path('/Users/Lola/Documents/UNI/HTW/BACHELOR/MATLAB/funktionen',path);

%alte Daten löschen
delete csv/parallel_A.csv
delete csv/parallel_B.csv
figure();

%Ebenen erzeugen
%[ x y z Random_werte_A] = ebene3D_scatter( 2,4,2,4,'z',20,[1 0 0]);
%[ x2 y2 z2 Random_werte_B] = ebene3D_scatter( 2,4,2,4,'z',20,[0 1 0]);
[ x y z Random_werte_A] = ebene3D_scatter( 2,4,2,4,'z',20,[1 0 0]);
[ x2 y2 z2 Random_werte_B] = ebene3D_scatter( 6,8,6,8,'z',20,[0 1 0]);

%Linearinterpolation
%[Random_werte_A x y z] = transformation_export(Random_werte_A, x, y, z,[1 0 0], 0, [0 1 0],[0 0 0], 'parallel_A.csv')
%[Random_werte_B x2 y2 z2] = transformation_export(Random_werte_B, x2, y2, z2,[0 1 0], 0, [0 1 0],[0 0 0], 'parallel_B.csv')
[Random_werte_A x y z] = transformation_export(Random_werte_A, x, y, z,[1 0 0], 0, [0 1 0],[-3 -3 0], 'csv/parallel_A.csv');
[Random_werte_B x2 y2 z2] = transformation_export(Random_werte_B, x2, y2, z2,[0 1 0], 0, [0 1 0],[-7 -7 0], 'csv/parallel_B.csv');

%Projektion
projektion_A = Data3D_Projektion('csv/parallel_A.csv', 1, 1, [2 2]);
projektion_B = Data3D_Projektion('csv/parallel_B.csv', 1, 1, [2 2]);
%proj_gesamt = [projektion_A'; projektion_B'];


%Bewegungsvektoren ausrechnen, Ausgangsdaten für Clustering --> MUSS ANDERS
%BERECHNET WERDEN! WENN NUR 1 FRAME KEINE FUNKTIONALITÄT!
proj_vektoren_A = projektion_vektoren(projektion_A, 20); %20=Anzahl Punkte pro block
proj_vektoren_B = projektion_vektoren(projektion_B, 20);
proj_vektoren = [proj_vektoren_A ; proj_vektoren_B];
%dlmwrite('parallel_vektoren.csv', proj_vektoren , '-append');

%Rauschen auf Bewegungsvektoren
rauschen_A = daten_rauschen(proj_vektoren_A, 0, 1); %daten, von, bis (random)
rauschen_B = daten_rauschen(proj_vektoren_B, 0, 1);
rauschen = [rauschen_A ; rauschen_B];
%dlmwrite('parallel_rauschen.csv', rauschen , '-append');

%--eigener fuzzyCmeans-----------------------------------------------------
[fuzzy_daten, fuzzy_cluster] = fuzzyCmeans_self(projektion_2D, 2);
%[fuzzy_daten, fuzzy_cluster] = Copy_of_fuzzyCmeans_self(projektion_2D, 2);

size_fuzzy = size(fuzzy_daten);
rows_f = size_fuzzy(1);
columns_f = size_fuzzy(2);

figure('name', 'Fuzzy C-means');
for r = 1:rows_f
    
    clust = fuzzy_daten(r,1);
    %disp(clust);

    hold on
    
    switch clust
        case 1
            scatter(fuzzy_daten(r,2), fuzzy_daten(r,3), 50,[0 0 1]);
        case 2
            scatter(fuzzy_daten(r,2), fuzzy_daten(r,3), 50,[1 0 0]);
        otherwise
            error('ERROR: Bisher nur für 2D.'); 
    end
    
end

%Clusterzentren plotten..for wenn flexibel
scatter(fuzzy_cluster(1,1), fuzzy_cluster(1,2), 50,[0 0 0]);
scatter(fuzzy_cluster(1,1), fuzzy_cluster(1,2), 50,[0 0 0], '+');

scatter(fuzzy_cluster(2,1), fuzzy_cluster(2,2), 50,[0 0 0]);
scatter(fuzzy_cluster(2,1), fuzzy_cluster(2,2), 50,[0 0 0], '+');
    
hold off

xlabel('x');
ylabel('y');

axis equal
%grid on
hold off

%--eigener kmeans---------------------------------------------------------
%projektion_2D = [proj_vektoren(:,1), proj_vektoren(:,2)];
projektion_2D = [rauschen(:,1), rauschen(:,2)];

[kmeans_daten,kmeans_cluster] = kmeans_self(projektion_2D, 2);

size_kmeans = size(kmeans_daten);
rows = size_kmeans(1);
columns = size_kmeans(2);

figure('name', 'K-means');
for r = 1:rows
    
    clust = kmeans_daten(r,1);
    %disp(clust);

    hold on
    
    switch clust
        case 1
            scatter(kmeans_daten(r,2), kmeans_daten(r,3), 50,[0 0 1]);
        case 2
            scatter(kmeans_daten(r,2), kmeans_daten(r,3), 50,[1 0 0]);
        otherwise
            error('ERROR: Bisher nur für 2D.'); 
    end
    
end

%Clusterzentren plotten..for wenn flexibel
scatter(kmeans_cluster(1,1), kmeans_cluster(1,2), 50,[0 0 0]);
scatter(kmeans_cluster(1,1), kmeans_cluster(1,2), 50,[0 0 0], '+');

scatter(kmeans_cluster(2,1), kmeans_cluster(2,2), 50,[0 0 0]);
scatter(kmeans_cluster(2,1), kmeans_cluster(2,2), 50,[0 0 0], '+');
    
hold off

xlabel('x');
ylabel('y');

axis equal
%grid on
hold off
