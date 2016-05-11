function [ xRot,yRot,zRot ] = transformEbene3D( xEbene,yEbene,zEbene,transformation_matrix)
%Rotation der Ebenenrepräsentation in 3D seperat 

    linkdata on
    
    %Ebene in einzelne Matrix überführen, homogene Koordinaten
    ebene_x = [xEbene(1,:) , xEbene(2,:)];
    ebene_y = [yEbene(1,:) , yEbene(2,:)];
    ebene_z = [zEbene(1,:) , zEbene(2,:)];
    ebene_1 = ones(1,4);
    ebene_werte = [ebene_x; ebene_y; ebene_z; ebene_1]'
    
    %Transformationsmatrix berechnen
    %transformation_matrix = transformation_matrix_calc(rotation_winkel,rotation_achse,translation_punkt);
    
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
    surf(xRot, yRot, zRot);
    alpha(.2);
    hold off
    
    xlabel('x');
    ylabel('y');
    zlabel('z');
    
    %lim zum Testen
    %xlim([0 10])
    %ylim([0 10])
    %zlim([0 10])
    
    linkdata off

end

