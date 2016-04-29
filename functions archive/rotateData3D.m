function [ xRot,yRot,zRot ] = rotateData3D( xRandom,yRandom,zRandom,ebene_handle,winkel,achse)
%Rotation in 3D um eine beliebige Achse
    
    %linkdata on %gucken, ob das geht

    rotAngle = deg2rad(winkel);

    if achse == 'x'
        %direction = [1 0 0];
        xRot = xRandom;
        yRot = yRandom.*cos(rotAngle)+zRandom.*(-sin(rotAngle));
        zRot = yRandom.*sin(rotAngle)+zRandom.*cos(rotAngle);
    end
    
    if achse == 'y'
        %direction = [0 1 0];
        xRot = xRandom.*cos(rotAngle)+zRandom.*sin(rotAngle);
        yRot = yRandom;
        zRot = xRandom.*(-sin(rotAngle)) + zRandom.*cos(rotAngle);
    end
    
    if achse == 'z'
        %direction = [0 0 1];
        xRot = xRandom.*cos(rotAngle)+yRandom.*(-sin(rotAngle));
        yRot = xRandom.*sin(rotAngle)+yRandom.*cos(rotAngle);
        zRot = zRandom;
    end
    
    %Besser die Eckpunkte der Ebene rotieren
    %rotate(ebene_handle,direction,winkel);

end

