function [ xRot,yRot,zRot,surface] = transformEbene3D( xEbene,yEbene,zEbene,transformation_matrix,color_array)
%Rotation der Ebenenrepräsentation in 3D seperat
%
%INPUT:
%
%   xEbene                  =   Matrix der x-Koordinaten der Ebene
%   yEbene                  =   Matrix der y-Koordinaten der Ebene
%   zEbene                  =   Matrix der z-Koordinaten der Ebene
%   transformation_matrix   =   Matrix, die gewünschte Transformation ausführt
%   color_array             =   Farbarray der Form [R G B], Werte 0-1
%
%OUTPUT:
%
%   xRot        =   transformierte Matrix der x-Koordinaten der Ebene
%   yRot        =   transformierte Matrix der y-Koordinaten der Ebene
%   zRot        =   transformierte Matrix der z-Koordinaten der Ebene
%   surface     =   Handle des Surface Plots, Funktionen zur
%                   Veränderung des Plots können auf dieser Variablen aufgerufen werden
%
%Autor: Sophie-Charlotte Bolinski, Matrikelnummer: 545839, htw-berlin

    linkdata on
    
    %Ebene in einzelne Matrix überführen, homogene Koordinaten
    ebene_x = [xEbene(1,:) , xEbene(2,:)];
    ebene_y = [yEbene(1,:) , yEbene(2,:)];
    ebene_z = [zEbene(1,:) , zEbene(2,:)];
    ebene_1 = ones(1,4);
    ebene_werte = [ebene_x; ebene_y; ebene_z; ebene_1]';
    
    %Ebene rotieren
    Ebene_homo = ebene_werte * transformation_matrix;
    
    %dehomogenisieren
    Ebene = Ebene_homo/Ebene_homo(1,4);
    
    %Ebene wieder in einzelne Matrizen überführen für surface Plot 
    xRot = [Ebene(1,1) Ebene(2,1) ; Ebene(3,1) Ebene(4,1)];
    yRot = [Ebene(1,2) Ebene(2,2) ; Ebene(3,2) Ebene(4,2)];
    zRot = [Ebene(1,3) Ebene(2,3) ; Ebene(3,3) Ebene(4,3)];
    
    
    %handle hier zuweisen
    hold on
    surface = surf(xRot, yRot, zRot);
    set(surface,'FaceColor',color_array,'FaceAlpha',0.2);
    
    %hold off
    
    set(gca,'FontSize',18);
    
    xlabel('x');
    ylabel('y');
    zlabel('z');
    
    linkdata off

end

