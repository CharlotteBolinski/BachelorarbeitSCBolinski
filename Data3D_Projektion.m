function [ X,Y ] = Data3D_Projektion( random_werte,CSV_name,daten_csv, fx, fy, principal_point)
%Berechnen der 2D-Projektion der 3D-Daten

    %input_daten = csvread(daten_csv);
    input_daten = random_werte;
    
    x = input_daten(:,1);
    y = input_daten(:,2);
    z = input_daten(:,3);

    X0 = principal_point(1);
    Y0 = principal_point(2);
    
    %Projektions_matrix = [-fx 0 X0; 0 -fy Y0; 0 0 1];
    %projektion = Projektions_matrix * input_daten;
    X = (X0-fx)*x./z;
    Y = (Y0-fy)*y./z;
    
    %in CSV schreiben
    dlmwrite(CSV_name, [X,Y], '-append');
    
    %hold on
    %neue figure/sub-figure
    figure
    
    %Daten Plot
    %scatter(X,Y)
    scatter(x,y)
    
    %Ebene Plot
    %surf(...)
    %contourf(X,Y,0)
    
end

