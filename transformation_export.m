function [ Transform_save, x,y,z ] = transformation_export( input_werte_matrix, xEbene, yEbene, zEbene, winkel, rotation_achse, translation_punkt, CSV_name)
%CSV Datei erzeugen, für die die Transformation von einem Anfangspunkt zu
%einem Endpunkt durchgeführt wird.
%25 Frames pro Sekunde werden angenommen.
%Ausgangswert wird eine Sekunde für die Transformation. Kann später auch im
%Funktionskopf übergeben werden um eine individuelle Dauer festzulegen.

%Diese Größen später der Funktion übergeben!!---------------------------
%frames und sekunden festlegen
frames = 25;
sekunden = 1;

%---------------------------------------------------------------------------
%alles Änderung pro Frame umrechnen
winkel_frame = winkel/(sekunden*frames);
translation_frame = translation_punkt/(sekunden*frames);

transformation_matrix_schritt = transformation_matrix_calc(winkel_frame,rotation_achse,translation_frame);

transform_frame = input_werte_matrix;

x = xEbene;
y = yEbene;
z = zEbene;

%3D-Daten erzeugen%---------------------------------------------------------
%in CSV schreiben
for s = 1:sekunden
    
    for f = 1:frames

        transform_frame = transformData3D(transform_frame,transformation_matrix_schritt);
        [x,y,z] = transformEbene3D( x,y,z,transformation_matrix_schritt);

        %schreibe in csv
        dlmwrite(CSV_name, transform_frame, '-append');
        
    end


end

%Speichern des letzen Ergebnisses für weitere Transformationen
Transform_save = transform_frame;

%Rundungsfehler bei Matrix-Multiplikation?
%transformation_matrix_gesamt = transformation_matrix_calc(winkel,rotation_achse,translation_punkt);
%[x,y,z] = transformEbene3D( x,y,z,transformation_matrix_gesamt);

end