function [ projektion ] = Ebene3D_Projektion(ebene_x, ebene_y, ebene_z, fx, fy, principal_point)
%Berechnen der 2D-Projektion der 3D-Ebene
%
%INPUT:
%
%   ebene_x         =   Matrix der x-Koordinaten der Ebene
%   ebene_y         =   Matrix der y-Koordinaten der Ebene
%   ebene_z         =   Matrix der z-Koordinaten der Ebene
%   fx              =   Brennweite in x-Richtung
%   fy              =   Brennweite in y-Richtung
%   principal_point =   Bildmittelpunkt
%
%OUTPUT:
%
%   projektion   = projezierte Punkte der Ebene
%
%Autor: Sophie-Charlotte Bolinski, Matrikelnummer: 545839, htw-berlin

    x = [ebene_x(1:2)'; ebene_x(3:4)'];
    y = [ebene_y(1:2)'; ebene_y(3:4)'];
    z = [ebene_z(1:2)'; ebene_z(3:4)'];

    input_daten = [x y z];

    X0 = principal_point(1);
    Y0 = principal_point(2);
    
    %Projektions_matrix = [-fx 0 X0 0; 0 -fy Y0 0; 0 0 1 0];
    %Projektions_matrix = [fx 0 X0 0; 0 fy Y0 0; 0 0 1 0]
    Projektions_matrix = [fx 0 X0 ; 0 fy Y0 ; 0 0 1 ] ;
    
    %projektion = input_daten * Projektions_matrix
    projektion_save = Projektions_matrix * input_daten';
    projektion = projektion_save(1:2, :)
    
    %Plot Ebene
    figure();
    
    x_poly = [projektion(1, 3) , projektion(1, 4), projektion(1, 2) , projektion(1, 1)]
    y_poly = [projektion(2, 3) , projektion(2, 4), projektion(2, 2) , projektion(2, 1)]

    %scatter(projektion(1,:), projektion(2,:));
    %hold on
    fill(x_poly, y_poly,'r', 'FaceAlpha',0.2) %gefülltes Polygon
    
end

