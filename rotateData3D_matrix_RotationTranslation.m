function [ Rotation_werte_out] = rotateData3D_matrix_RotationTranslation(random_werte,rotation_winkel,rotation_achse,translation)
%Rotation in 3D um eine beliebige Achse

    linkdata on

    %Rotation in homogene Koordinaten überführen
    random_size = size(random_werte);
    random_werte_homo = [random_werte, ones(random_size(1),1)]';

    %Transformationsmatrix
    %Vielleicht besser übergeben?
    %transformation_matrix = transformation_matrix_calc(rotation_winkel,rotation_achse,translation);
    rotation_matrix = rotation_matrix_calc(rotation_winkel,rotation_achse);
    
    %Messpunkte rotieren
    %Rotation_werte_homo = transformation_matrix * random_werte_homo;
    Rotation_werte_homo = rotation_matrix * random_werte_homo;
    
    Rotation_werte = Rotation_werte_homo/Rotation_werte_homo(4);
    Rotation_werte_out = [Rotation_werte(1,:)', Rotation_werte(2,:)', Rotation_werte(3,:)'];
    
    %hold on
    scatter3(Rotation_werte(1,:), Rotation_werte(2,:), Rotation_werte(3,:));   
    %hold off
    
    xlabel('x');
    ylabel('y');
    zlabel('z');
    
    linkdata off
end

