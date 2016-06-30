function [ Transform_save, x,y,z ] = transformation_export( input_werte_matrix, xEbene, yEbene, zEbene,color_array, winkel, rotation_achse, translation_punkt, CSV_name)
%CSV Datei erzeugen, für die die Transformation von einem Anfangspunkt zu
%einem Endpunkt durchgeführt wird.
%25 Frames pro Sekunde werden angenommen.
%Ausgangswert wird eine Sekunde für die Transformation. Kann später auch im
%Funktionskopf übergeben werden um eine individuelle Dauer festzulegen.
%Autor: Sophie-Charlotte Bolinski, Matrikelnummer: 545839, htw-berlin

%---------------------------------------------------------------------------
%Diese Größen später der Funktion übergeben!!
%frames und sekunden festlegen

%Testing
%frames = 25;
frames = 4;

%frames = 25;
sekunden = 1;

%Beschleunigung a= cm/sekunde.. einheiten/frame
%t = Zeit
%v = a · t + v0


%---------------------------------------------------------------------------

transform_frame = input_werte_matrix;

x = xEbene;
y = yEbene;
z = zEbene;

%gleichmäßig beschleunigt
a_rotate = winkel/(sekunden*frames)^2;
a_translate = translation_punkt/(sekunden*frames)^2;
%---------------------------------------------------------------------------
%3D-Daten erzeugen und in CSV schreiben

for s = 1:sekunden
    
    for f = 1:frames
        
        %alles Änderung pro Frame umrechnen
        %s = 1/2 * a · t^2, a = s/t = winkel/frame
        winkel_frame = 0.5 * a_rotate * (s*f)^2;
        translation_frame = 0.5 * a_translate * (s*f)^2;

        transformation_matrix_schritt = transformation_matrix_calc(winkel_frame,rotation_achse,translation_frame);
        
        

        transform_frame = transformData3D(transform_frame,transformation_matrix_schritt);
        [x,y,z] = transformEbene3D( x,y,z,transformation_matrix_schritt,color_array);

        %schreibe in CSV
        dlmwrite(CSV_name, transform_frame, '-append');
        
    end


end

%Speichern des letzen Ergebnisses für weitere Transformationen
Transform_save = transform_frame;

%Rundungsfehler bei Matrix-Multiplikation?
%transformation_matrix_gesamt = transformation_matrix_calc(winkel,rotation_achse,translation_punkt);
%[x,y,z] = transformEbene3D( x,y,z,transformation_matrix_gesamt);

end