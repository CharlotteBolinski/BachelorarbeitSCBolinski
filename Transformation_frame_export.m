function [  ] = Transformation_frame_export( input_werte_matrix, xEbene, yEbene, zEbene, bis_winkel_rotation, achse, bis_punkt_translation)
%CSV Datei erzeugen, für die die Transformation von einem Anfangspunkt zu
%einem Endpunkt durchgeführt wird.
%25 Frames pro Sekunde werden angenommen.
%Ausgangswert wird eine Sekunde für die Transformation. Kann später auch im
%Funktionskopf übergeben werden um eine individuelle Dauer festzulegen.

%Diese Größen später der Funktion übergeben!!---------------------------
%frames und sekunden festlegen
frames = 25;
sekunden = 1;

%CSV-Namen festlegen
CSV_name = '1Sekunde.csv';

%-----------------------------------------------------------------------
%alles Änderung pro Frame umrechnen
winkel_frame = deg2rad(bis_winkel_rotation/(sekunden*frames));
translation_frame = bis_punkt_translation/(sekunden*frames);

rot_frame = input_werte_matrix;

for s = 1:sekunden
    
    for f = 1:frames
  
        %3D-Daten erzeugen-------------------------------------------
        %in CSV schreiben
        
        %[rot_frame, xEbene_neu, yEbene_neu, zEbene_neu] = rotateData3D_matrix_RotationTranslationZentrum(rot_frame, winkel_frame, achse, rotation_zentrum,translation_frame);
        rot_frame = rotateData3D_matrix_RotationTranslation(rot_frame,winkel_frame,achse,translation_frame);
        
        %schreibe in csv
        dlmwrite(CSV_name, rot_frame, '-append');
        
        %Projektion-Daten erzeugen-------------------------------------
        %in CSV schreiben
        
    end

end

    %Ebene kann extra geplottet werden, da nur zur Visualisierung
    rotateEbene3D_matrix_RotationTranslation(xEbene,yEbene,zEbene,bis_winkel_rotation,achse,bis_punkt_translation);

end