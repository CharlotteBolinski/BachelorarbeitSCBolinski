function [ Transformation_werte_out] = transformData3D(random_werte,rotation_winkel,rotation_achse,translation_punkt,artString)
%Rotation in 3D um eine beliebige Achse

    linkdata on

    %Rotation in homogene Koordinaten �berf�hren
    random_size = size(random_werte);
    random_werte_homo = [random_werte, ones(random_size(1),1)]';
    
    %Entscheidung der Transformation durch String-�bergabe
    %strcmp is 0 or 1, string compare function
    if strcmp(artString,'rotate')
        
        transformation_matrix = rotation_matrix_calc(rotation_winkel,rotation_achse);
        
    elseif strcmp(artString,'translate')
        
        transformation_matrix = translation_matrix_calc(translation_punkt);
        
    elseif strcmp(artString,'transform')
        
        transformation_matrix = transformation_matrix_calc(rotation_winkel,rotation_achse,translation_punkt);
        
    else
        disp('Ung�ltige Eingabe!');
        disp('Relevante Strings: rotate, translate und transform');
    end
    
    %Messpunkte rotieren
    Transformation_werte_homo = transformation_matrix * random_werte_homo;
    
    Transformation_werte = Transformation_werte_homo/Transformation_werte_homo(4);
    Transformation_werte_out = [Transformation_werte(1,:)', Transformation_werte(2,:)', Transformation_werte(3,:)'];

    scatter3(Transformation_werte(1,:), Transformation_werte(2,:), Transformation_werte(3,:));   
    
    xlabel('x');
    ylabel('y');
    zlabel('z');
    
    %lim �bergeben?
    xlim([0 10])
    ylim([0 10])
    zlim([0 10])
    
    linkdata off
end

