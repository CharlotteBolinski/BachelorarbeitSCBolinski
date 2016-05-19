function [ transformation_matrix ] = transformation_matrix_calc( rotation_winkel,rotation_achse,translation )
%Matrix f�r Starrk�rpertransformation berechnen um diese Matrix flexibler
%Einsetzbar zu machen

    %Rotationswinkel in Rad umrechnen
    theta = deg2rad(rotation_winkel);

    %Achsen-Vektor Normierung
    %teilen des Vektors, der Achse sein soll durch seinen Betrag
    %achse sollte zeilenvektor sein, 3 Komponenten
    n = rotation_achse/norm(rotation_achse);
    
    %Rotationsmatrix
    %n(1):n(x), n(2):n(y), n(3):n(z)
    rot_1_1 = n(1).*n(1)+(1-n(1)^2).*cos(theta);
    rot_1_2 = n(1).*n(2).*(1-cos(theta))-n(3).*sin(theta);
    rot_1_3 = n(1).*n(3).*(1-cos(theta))+n(2).*sin(theta);
    
    rot_2_1 = n(1).*n(2).*(1-cos(theta))+n(3).*sin(theta);
    rot_2_2 = n(2).*n(2)+(1-n(2).*n(2)).*cos(theta);
    rot_2_3 = n(2).*n(3).*(1-cos(theta))-n(1).*sin(theta);
    
    rot_3_1 = n(1).*n(3).*(1-cos(theta))-n(2).*sin(theta);
    rot_3_2 = n(2).*n(3).*(1-cos(theta))+n(1).*sin(theta);
    rot_3_3 = n(3).*n(3)+(1-n(3).*n(3)).*cos(theta);

    rotation_matrix = [rot_1_1 rot_1_2 rot_1_3 0; rot_2_1 rot_2_2 rot_2_3 0; rot_3_1 rot_3_2 rot_3_3 0; 0 0 0 1];
    
    %translationsmatrix
    translation_matrix = [1 0 0 translation(1); 0 1 0 translation(2); 0 0 1 translation(3); 0 0 0 1];

    transformation_matrix = rotation_matrix*translation_matrix;
    
end
