function [ Rotation_werte_out, xRot, yRot, zRot] = rotateData3D_matrix_RotationTranslationZentrum(random_werte,xEbene,yEbene,zEbene,rotation_winkel,rotation_achse,rotation_zentrum,translation)
%Rotation in 3D um eine beliebige Achse

    linkdata on
    
    %Rotationswinkel in Bogenmaß umrechnen
    %t steht für theta, den Rotationswikel.. hier im Bogenmaß
    theta = deg2rad(rotation_winkel);
    
    %Rotation in homogene Koordinaten überführen
    random_size = size(random_werte);
    random_werte_homo = [random_werte, ones(random_size(1),1)]';
    
    %Ebene in einzelne Matrix überführen, homogene Koordinaten
    ebene_x = [xEbene(1,:) , xEbene(2,:)];
    ebene_y = [yEbene(1,:) , yEbene(2,:)];
    ebene_z = [zEbene(1,:) , zEbene(2,:)];
    ebene_1 = ones(1,4);
    ebene_werte = [ebene_x; ebene_y; ebene_z; ebene_1];
    
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
    %Plus: translation_matrix = [0 0 0 translation(1); 0 0 0 translation(2); 0 0 0 translation(3); 0 0 0 0];

    
    %Ebene rotieren
    Ebene = rotation_matrix * translation_matrix * ebene_werte;
        
    %Messpunkte rotieren
    Rotation_werte_homo = rotation_matrix * translation_matrix * random_werte_homo;

    %Ebene wieder in einzelne Matrizen überführen für surface Plot
    xRot = [Ebene(1,1) Ebene(1,2) ; Ebene(1,3) Ebene(1,4)];
    yRot = [Ebene(2,1) Ebene(2,2) ; Ebene(2,3) Ebene(2,4)];
    zRot = [Ebene(3,1) Ebene(3,2) ; Ebene(3,3) Ebene(3,4)];
    
    %ebene_handle und punkte_handle sollen hier überschrieben werden,
    %gleiche Namen vergeben wie beim Aufruf von ebene3D_scatter!
    %ebene_handle = surf(xRot, yRot, zRot);
    surf(xRot, yRot, zRot);
    alpha(.2);
    
    hold on
    
    %Richtige Berechnung?? Umrechnung in Karthesische Koordinaten
    Rotation_werte = Rotation_werte_homo/Rotation_werte_homo(4);
    Rotation_werte_out = [Rotation_werte(1,:)', Rotation_werte(2,:)', Rotation_werte(3,:)'];
    %wg Transponiert: punkte_handle = scatter3(Rotation_werte(:,1), Rotation_werte(:,2), Rotation_werte(:,3));
    %punkte_handle = scatter3(Rotation_werte(1,:), Rotation_werte(2,:), Rotation_werte(3,:));
    scatter3(Rotation_werte(1,:), Rotation_werte(2,:), Rotation_werte(3,:));

        
    hold off
    
    xlabel('x');
    ylabel('y');
    zlabel('z');
    
    linkdata off
end

