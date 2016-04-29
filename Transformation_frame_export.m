function [ output_werte_matrix ] = Transformation_frame_export( input_werte_matrix, xEbene, yEbene, zEbene, bis_winkel_rotation, achse, bis_punkt_translation)
%CSV Datei erzeugen, f�r die die Transformation von einem Anfangspunkt zu
%einem Endpunkt durchgef�hrt wird.
%25 Frames pro Sekunde werden angenommen.
%Ausgangswert wird eine Sekunde f�r die Transformation. Kann sp�ter auch im
%Funktionskopf �bergeben werden um eine individuelle Dauer festzulegen.

%Diese Gr��en sp�ter der Funktion �bergeben!!---------------------------
%frames und sekunden festlegen
frames = 25;
sekunden = 1;

%CSV-Namen festlegen
CSV_name = '1Sekunde.csv';

%-----------------------------------------------------------------------


%alles auf Frame-Anzahl umrechnen
winkel_frame = bis_winkel_rotation/(sekunden*frames);
translation_frame = bis_punkt_translation/(sekunden*frames);

%rotateData3D_matrix_RotationTranslation
%(random_werte,xEbene,yEbene,zEbene,rotation_winkel,rotation_achse,translation)

rot_frame = input_werte_matrix;
eb_frame = zeros(4,4);

for s = 1:sekunden
    
    for f = 1:frames
        
        %rotateData3D_matrix_RotationTranslationZentrum
        %(random_werte,xEbene,yEbene,zEbene,rotation_winkel,rotation_achse,rotation_zentrum,translation)
        xRot = [eb_frame(1,1) eb_frame(1,2) ; eb_frame(1,3) eb_frame(1,4)];
        yRot = [eb_frame(2,1) eb_frame(2,2) ; eb_frame(2,3) eb_frame(2,4)];
        zRot = [eb_frame(3,1) eb_frame(3,2) ; eb_frame(3,3) eb_frame(3,4)];
        
        
        [rot_frame, eb_frame] = rotateData3D_matrix_RotationTranslation(rot_frame,xRot,yRot,zRot, winkel_frame, achse, translation_frame);
        
        %schreibe in csv
        dlmwrite(CSV_name, rot_frame, '-append');
        
        %Projektion-Daten erzeugen
        %in CSV schreiben
        
    end

end


end