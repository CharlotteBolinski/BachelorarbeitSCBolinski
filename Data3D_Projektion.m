function [ projektion ] = Data3D_Projektion(daten_csv, fx, fy, principal_point)
%Berechnen der 2D-Projektion der 3D-Daten
%Autor: Sophie-Charlotte Bolinski, Matrikelnummer: 545839, htw-berlin
    input_daten = csvread(daten_csv);
    %input_daten = random_werte;

    X0 = principal_point(1);
    Y0 = principal_point(2);
    
    %Projektions_matrix = [-fx 0 X0 0; 0 -fy Y0 0; 0 0 1 0];
    %Projektions_matrix = [fx 0 X0 0; 0 fy Y0 0; 0 0 1 0]
    Projektions_matrix = [fx 0 X0 ; 0 fy Y0 ; 0 0 1 ] ;
    
    %projektion = input_daten * Projektions_matrix
    projektion = Projektions_matrix * input_daten';
    
    %in CSV schreiben
    %dlmwrite(CSV_name, projektion' , '-append');
    
    %Rauschen hinzufügen
    %noise = noise_2D( 50 , 0, 10, 0, 10);
    %dlmwrite(CSV_name, noise , '-append');
    
    %hold on
    %neue figure/sub-figure
    figure
    
    %Daten Plot
    scatter(projektion(:,1),projektion(:,2));
    
    %Ebene Plot
    %surf(...)
    %contourf(X,Y,0)
    
    %Clustering--------------------------------------------------------------
    %rng(1); % For reproducibility
    %X = csvread('1Sekunde_projektion.csv');
    %[label,energy,model] = kmeans/kmeans(projektion,2); %kmeans(daten,cluster_regionen)
    


end

