function [ Transformation_werte] = transformData3D(random_werte,transformation_matrix)
%Rotation in 3D um eine beliebige Achse

    linkdata on
    
    %Rotation in homogene Koordinaten überführen
    random_size = size(random_werte);
    random_werte_homo = [random_werte, ones(random_size(1),1)];
    
    %Transformationsmatrix berechnen
    %transformation_matrix = transformation_matrix_calc(rotation_winkel,rotation_achse,translation_punkt);
    
    %Messpunkte rotieren
    Transformation_werte_homo = random_werte_homo * transformation_matrix;
    
    Transformation_werte_dehomo = Transformation_werte_homo/Transformation_werte_homo(1,4);
    Transformation_werte = [Transformation_werte_dehomo(:,1),Transformation_werte_dehomo(:,2),Transformation_werte_dehomo(:,3)];
    
    %handle hier zuweisen
    Transformation_werte_plot = Transformation_werte';
    
    hold on
    scatter3(Transformation_werte_plot(1,:), Transformation_werte_plot(2,:), Transformation_werte_plot(3,:));   
    %hold off
    
    xlabel('x');
    ylabel('y');
    zlabel('z');
    
    %lim zum Testen
    %xlim([0 10])
    %ylim([0 10])
    %zlim([0 10])
    
    linkdata off
end

