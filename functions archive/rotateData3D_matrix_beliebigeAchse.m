function [ Rotation_werte, ebene_handle, punkte_handle] = rotateData3D_matrix_beliebigeAchse(random_werte,xEbene,yEbene,zEbene,winkel,achse)
%Rotation in 3D um eine beliebige Achse

    linkdata on
    
    %Rotationswinkel in Bogenmaß umrechnen
    %t steht für theta, den Rotationswikel.. hier im Bogenmaß
    theta = deg2rad(winkel);
    
    %Ebene in einzelne Matrix überführen
    ebene_x = [xEbene(:,1) ; xEbene(:,2)];
    ebene_y = [yEbene(:,1) ; yEbene(:,2)];
    ebene_z = [zEbene(:,1) ; zEbene(:,2)];
    ebene_werte = [ebene_x, ebene_y, ebene_z];
    
    %Achsen-Vektor Normierung
    %teilen des Vektors, der Achse sein soll durch seinen Betrag
    %achse sollte zeilenvektor sein, 3 Komponenten
    n = achse/norm(achse);
    
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

    rotation_matrix = [rot_1_1 rot_1_2 rot_1_3; rot_2_1 rot_2_2 rot_2_3; rot_3_1 rot_3_2 rot_3_3];
    
    %Ebene rotieren
    Ebene = ebene_werte * rotation_matrix;
        
    %Messpunkte rotieren
    Rotation_werte = random_werte * rotation_matrix;

    %Ebene wieder in einzelne Matrizen überführen für surface Plot
    xRot = [Ebene(1,1) Ebene(2,1) ; Ebene(3,1) Ebene(4,1)];
    yRot = [Ebene(1,2) Ebene(2,2) ; Ebene(3,2) Ebene(4,2)];
    zRot = [Ebene(1,3) Ebene(2,3) ; Ebene(3,3) Ebene(4,3)];
    
    %ebene_handle und punkte_handle sollen hier überschrieben werden,
    %gleiche Namen vergeben wie beim Aufruf von ebene3D_scatter!
    ebene_handle = surf(xRot, yRot, zRot);
    alpha(.2);
    
    hold on
    
    punkte_handle = scatter3(Rotation_werte(:,1), Rotation_werte(:,2), Rotation_werte(:,3));
    
    hold off
    
    xlabel('x');
    ylabel('y');
    zlabel('z');
    
    linkdata off
end

