function [ Transform_save, x,y,z ] = Transformation_frame_export( input_werte_matrix, xEbene, yEbene, zEbene, winkel, rotation_achse, translation_punkt, artString, CSV_name)
%CSV Datei erzeugen, f�r die die Transformation von einem Anfangspunkt zu
%einem Endpunkt durchgef�hrt wird.
%25 Frames pro Sekunde werden angenommen.
%Ausgangswert wird eine Sekunde f�r die Transformation. Kann sp�ter auch im
%Funktionskopf �bergeben werden um eine individuelle Dauer festzulegen.

%Diese Gr��en sp�ter der Funktion �bergeben!!---------------------------
%frames und sekunden festlegen
frames = 25;
sekunden = 1;

%-----------------------------------------------------------------------
%alles �nderung pro Frame umrechnen
winkel_frame = winkel/(sekunden*frames);
translation_frame = translation_punkt/(sekunden*frames);

transform_frame = input_werte_matrix;

x = xEbene;
y = yEbene;
z = zEbene;

%3D-Daten erzeugen-------------------------------------------
%in CSV schreiben
for s = 1:sekunden
    
    for f = 1:frames

        if strcmp(artString,'rotate')

            transform_frame = transformData3D(transform_frame,winkel_frame,rotation_achse,translation_frame,'rotate');

        elseif strcmp(artString,'translate')

            transform_frame = transformData3D(transform_frame,winkel_frame,rotation_achse,translation_frame,'translate');

        elseif strcmp(artString,'transform')

            transform_frame = transformData3D(transform_frame,winkel_frame,rotation_achse,translation_frame,'transform');

        else
            disp('Ung�ltige Eingabe!');
            disp('Relevante Strings: rotate, translate und transform');
        end
 
        %schreibe in csv
        dlmwrite(CSV_name, transform_frame, '-append');
        
    end


end

%Speichern des letzen Ergebnisses f�r weitere Transformationen
Transform_save = transform_frame;

%Ebenentransformation bekommt direkt die Endpunkte
if strcmp(artString,'rotate')

    [x,y,z] = transformEbene3D( x,y,z,winkel,rotation_achse,translation_punkt,'rotate');

elseif strcmp(artString,'translate')

    [x,y,z] = transformEbene3D(x,y,z,winkel,rotation_achse,translation_punkt,'translate');

elseif strcmp(artString,'transform')

    [x,y,z] = transformEbene3D( x,y,z,winkel,rotation_achse,translation_punkt,'transform');

else
    disp('Ung�ltige Eingabe f�r Ebene!');
    disp('Relevante Strings: rotate, translate und transform');
end
   
%Projektion-Daten erzeugen-------------------------------------
%in CSV schreiben

end