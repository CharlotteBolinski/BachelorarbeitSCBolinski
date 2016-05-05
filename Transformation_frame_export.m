function [  ] = Transformation_frame_export( input_werte_matrix, xEbene, yEbene, zEbene, bis_winkel_rotation, achse, bis_punkt_translation)
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
%alles �nderung pro Frame umrechnen
winkel_frame = deg2rad(bis_winkel_rotation/(sekunden*frames));
translation_frame = bis_punkt_translation/(sekunden*frames);

%rotateData3D_matrix_RotationTranslation
%(random_werte,xEbene,yEbene,zEbene,rotation_winkel,rotation_achse,translation)

rot_frame = input_werte_matrix;

%Ebene in einzelne Matrix �berf�hren, homogene Koordinaten
%eb_frame = zeros(4,4);

for s = 1:sekunden
    
    for f = 1:frames
  
        %3D-Daten erzeugen-------------------------------------------
        %in CSV schreiben
        
        %Ebenen Daten vorbereiten f�r Funktions�bergabe
        if s == 1
            xRot = xEbene;
            yRot = yEbene;
            zRot = zEbene;
        else
            %rotateData3D_matrix_RotationTranslationZentrum
            %(random_werte,xEbene,yEbene,zEbene,rotation_winkel,rotation_achse,rotation_zentrum,translation)
            
            %R�ckgabewerte der Funktion werden verwendet um erneut zu
            %rotieren usw.
            xRot = xEbene_neu;
            yRot = yEbene_neu;
            zRot = zEbene_neu;
        end
        
        %Funktionsaufruf
        %translation_frame wird einfach so oft angerufen wie die for loop.
        %Damit wird zum Schluss die ganze Transformation ausgef�hrt sein.
        %[rot_frame, xEbene_neu, yEbene_neu, zEbene_neu] = rotateData3D_matrix_RotationTranslationZentrum(rot_frame,xRot,yRot,zRot, winkel_frame, achse, rotation_zentrum,translation_frame);
        [rot_frame, xEbene_neu, yEbene_neu, zEbene_neu] = rotateData3D_matrix_RotationTranslation(rot_frame,xRot,yRot,zRot,winkel_frame,achse,translation_frame);
        
        %schreibe in csv
        dlmwrite(CSV_name, rot_frame, '-append');
        
        %Projektion-Daten erzeugen-------------------------------------
        %in CSV schreiben
        
    end

end


end