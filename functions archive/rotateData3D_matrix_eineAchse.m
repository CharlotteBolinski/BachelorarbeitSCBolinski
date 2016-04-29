function [ Rotation_werte, ebene_handle, punkte_handle] = rotateData3D_matrix_eineAchse( random_werte,xEbene,yEbene,zEbene,winkel,achse)
%Rotation in 3D um eine beliebige Achse

    linkdata on
    
    %Rotationswinkel in Bogenmaß umrechnen
    rotAngle = deg2rad(winkel);
    
    %Ebene in einzelne Matrix überführen
    ebene_x = [xEbene(:,1) ; xEbene(:,2)];
    ebene_y = [yEbene(:,1) ; yEbene(:,2)];
    ebene_z = [zEbene(:,1) ; zEbene(:,2)];
    ebene_werte = [ebene_x, ebene_y, ebene_z];
    
    %Rotationsmatrix aufschreiben -> nur noch eine, universelle Matrix bei
    %Rotation um beliebeige Achse! 
    rotation_matrix_x = [1 0 0; 0 cos(rotAngle) -sin(rotAngle); 0 sin(rotAngle) cos(rotAngle)];
    rotation_matrix_y = [cos(rotAngle) 0 sin(rotAngle); 0 1 0; -sin(rotAngle) 0 cos(rotAngle)];
    rotation_matrix_z = [cos(rotAngle) -sin(rotAngle) 0; sin(rotAngle) cos(rotAngle) 0; 0 0 1];

    if achse == 'x'
        %Ebene
        Ebene = ebene_werte * rotation_matrix_x;
        
        %Messpunkte
        Rotation_werte = random_werte * rotation_matrix_x;
    end
    
    if achse == 'y'
        %Ebene
        Ebene = ebene_werte * rotation_matrix_y;
        
        %Messpunkte
        Rotation_werte = random_werte * rotation_matrix_y;
    end
    
    if achse == 'z'
        %Ebene
        Ebene = ebene_werte * rotation_matrix_z;
        
        %Messpunkte
        Rotation_werte = random_werte * rotation_matrix_z;
    end
    
    %Ebene wieder in einzelne Matrizen überführen für surface Plot
    xRot = [Ebene(1,1) Ebene(2,1) ; Ebene(3,1) Ebene(4,1)];
    yRot = [Ebene(1,2) Ebene(2,2) ; Ebene(3,2) Ebene(4,2)];
    zRot = [Ebene(1,3) Ebene(2,3) ; Ebene(3,3) Ebene(4,3)];
    
    %hold on %zum gleichzeitigen plotten der vorangegangenen Ebene aus
    %ebene3d_scatter
    
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
end

