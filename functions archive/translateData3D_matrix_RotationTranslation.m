function [ Translation_werte_out] = translateData3D_matrix_RotationTranslation(random_werte,translation_point)
%Rotation in 3D um eine beliebige Achse

    linkdata on

    %Rotation in homogene Koordinaten überführen
    random_size = size(random_werte);
    random_werte_homo = [random_werte, ones(random_size(1),1)]';

    %Transformationsmatrix
    %Vielleicht besser übergeben?
    %transformation_matrix = transformation_matrix_calc(rotation_winkel,rotation_achse,translation);
    translation_matrix = translation_matrix_calc(translation_point);
    
    %Messpunkte rotieren
    %Rotation_werte_homo = transformation_matrix * random_werte_homo;
    Translation_werte_homo = translation_matrix * random_werte_homo;
    
    Translation_werte = Translation_werte_homo/Translation_werte_homo(4);
    Translation_werte_out = [Translation_werte(1,:)', Translation_werte(2,:)', Translation_werte(3,:)'];
    
    %hold on
    scatter3(Translation_werte(1,:), Translation_werte(2,:), Translation_werte(3,:));   
    %hold off
    
    xlabel('x');
    ylabel('y');
    zlabel('z');
    
    linkdata off
end

