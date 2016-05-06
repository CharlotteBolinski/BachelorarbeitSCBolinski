function [ xRot,yRot,zRot ] = transformEbene3D( xEbene,yEbene,zEbene,rotation_winkel,rotation_achse,translation_punkt,artString)
%Rotation der Ebenenrepräsentation in 3D seperat 

    linkdata on
    
    %Ebene in einzelne Matrix überführen, homogene Koordinaten
    ebene_x = [xEbene(1,:) , xEbene(2,:)];
    ebene_y = [yEbene(1,:) , yEbene(2,:)];
    ebene_z = [zEbene(1,:) , zEbene(2,:)];
    ebene_1 = ones(1,4);
    ebene_werte = [ebene_x; ebene_y; ebene_z; ebene_1];
    
    %Entscheidung der Transformation durch String-Übergabe
    %strcmp is 0 or 1, string compare function
    if strcmp(artString,'rotate')
        
        transformation_matrix = rotation_matrix_calc(rotation_winkel,rotation_achse);
        
    elseif strcmp(artString,'translate')
        
        transformation_matrix = translation_matrix_calc(translation_punkt);
        
    elseif strcmp(artString,'transform')
        
        transformation_matrix = transformation_matrix_calc(rotation_winkel,rotation_achse,translation_punkt);
        
    else
        disp('Ungültige Eingabe!');
        disp('Relevante Strings: rotate, translate und transform');
    end
    
    %Ebene rotieren
    Ebene = transformation_matrix * ebene_werte;
    
    %Ebene wieder in einzelne Matrizen überführen für surface Plot
    xRot = [Ebene(1,1) Ebene(1,2) ; Ebene(1,3) Ebene(1,4)];
    yRot = [Ebene(2,1) Ebene(2,2) ; Ebene(2,3) Ebene(2,4)];
    zRot = [Ebene(3,1) Ebene(3,2) ; Ebene(3,3) Ebene(3,4)];
    
    hold on
    surf(xRot, yRot, zRot);
    alpha(.2);
    hold off
    
    xlabel('x');
    ylabel('y');
    zlabel('z');
    
    %lim übergeben?
    xlim([0 10])
    ylim([0 10])
    zlim([0 10])
    
    linkdata off

end

