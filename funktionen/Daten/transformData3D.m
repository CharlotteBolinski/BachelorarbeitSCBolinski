function [ Transformation_werte, scatter] = transformData3D(random_werte,transformation_matrix)
%Rotation in 3D um eine beliebige Achse
%
%INPUT:
%
%   random_werte            =   Random Werte auf der Ebene
%   transformation_matrix   =   Matrix, die gew�nschte Transformation ausf�hrt
%
%OUTPUT:
%
%   Transformation_werte    =   transformierte Werte
%   scatter                 =   Handle des Scatter Plots, Funktionen zur
%                               Ver�nderung des Plots k�nnen auf dieser Variablen aufgerufen werden
%
%Autor: Sophie-Charlotte Bolinski, Matrikelnummer: 545839, htw-berlin

    linkdata on
    
    %Rotation in homogene Koordinaten �berf�hren
    random_size = size(random_werte);
    random_werte_homo = [random_werte, ones(random_size(1),1)];
    
    %Messpunkte rotieren
    Transformation_werte_homo = random_werte_homo * transformation_matrix;
    %translation_matrix = [1 0 0 translation(1); 0 1 0 translation(2); 0 0 1 translation(3); 0 0 0 1];
    %Transformation_werte_homo = inv(translation_matrix) * transformation_matrix * translation_matrix * random_werte_homo';
    
    Transformation_werte_dehomo = Transformation_werte_homo/Transformation_werte_homo(1,4);
    Transformation_werte = [Transformation_werte_dehomo(:,1),Transformation_werte_dehomo(:,2),Transformation_werte_dehomo(:,3)];
    
    Transformation_werte_plot = Transformation_werte';
    
    %Plot-------------------------------------
    hold on
    scatter = scatter3(Transformation_werte_plot(1,:), Transformation_werte_plot(2,:), Transformation_werte_plot(3,:));   
    %hold off
    
    %Bewegungsvektoren plotten-----------------
    %arrow(random_werte , Transformation_werte_plot);    

            
    
    xlabel('x');
    ylabel('y');
    zlabel('z');
    
    linkdata off
end

