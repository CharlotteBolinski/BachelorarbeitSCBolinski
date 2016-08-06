function [ projektion ] = Data3D_Projektion(daten_csv, fx, fy, principal_point)
%Berechnung der Drehachse durch den Ebenenmittelpunkt.
%
%INPUT:
%
%   daten_csv           =   dreidimensionale Input Daten, 3xn
%   fx                  =   Brennweite x-Richtung
%   fy                  =   Brennweite y-Richtung
%   principal_point     =   Bildmittelpunkt
%
%OUTPUT:
%
%   projektion   = Daten, die in 2D Raum projeziert wurden, 2xn
%
%Autor: Sophie-Charlotte Bolinski, Matrikelnummer: 545839, htw-berlin

    input_daten = csvread(daten_csv);
    %input_daten = random_werte;

    X0 = principal_point(1);
    Y0 = principal_point(2);
    
    %Projektions_matrix = [-fx 0 X0 0; 0 -fy Y0 0; 0 0 1 0];
    %Projektions_matrix = [fx 0 X0 0; 0 fy Y0 0; 0 0 1 0]
    Projektions_matrix = [fx 0 X0 ; 0 fy Y0 ; 0 0 1 ] ;
    
    %projektion = input_daten * Projektions_matrix
    projektion_save = Projektions_matrix * input_daten';
    projektion = projektion_save(1:2, :)';
    

end

