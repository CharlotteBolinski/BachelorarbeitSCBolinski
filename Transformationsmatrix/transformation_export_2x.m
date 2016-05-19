function [ Transform_save,Transform_save2, x,y,z, x2,y2,z2 ] = transformation_export_2x( input_werte_matrix,input_werte_matrix2, xEbene, yEbene, zEbene, xEbene2, yEbene2, zEbene2, winkel, winkel2,rotation_achse,rotation_achse2, translation_punkt, translation_punkt2, CSV_name, CSV_name2)
%CSV Datei erzeugen, für die die Transformation von einem Anfangspunkt zu
%einem Endpunkt durchgeführt wird.
%25 Frames pro Sekunde werden angenommen.
%Ausgangswert wird eine Sekunde für die Transformation. Kann später auch im
%Funktionskopf übergeben werden um eine individuelle Dauer festzulegen.

%---------------------------------------------------------------------------
%Diese Größen später der Funktion übergeben!!
%frames und sekunden festlegen
frames = 10;
sekunden = 1;

%---------------------------------------------------------------------------
%alles Änderung pro Frame umrechnen
winkel_frame = winkel/(sekunden*frames);
translation_frame = translation_punkt/(sekunden*frames);

winkel_frame2 = winkel2/(sekunden*frames);
translation_frame2 = translation_punkt2/(sekunden*frames);

transformation_matrix_schritt = transformation_matrix_calc(winkel_frame,rotation_achse,translation_frame);
transformation_matrix_schritt2 = transformation_matrix_calc(winkel_frame2,rotation_achse2,translation_frame2);

transform_frame = input_werte_matrix;
transform_frame2 = input_werte_matrix2;

x = xEbene;
y = yEbene;
z = zEbene;

x2 = xEbene2;
y2 = yEbene2;
z2 = zEbene2;


%---------------------------------------------------------------------------
%3D-Daten erzeugen und in CSV schreiben

for s = 1:sekunden
    
    for f = 1:frames

        transform_frame = transformData3D(transform_frame,transformation_matrix_schritt);
        [x,y,z] = transformEbene3D( x,y,z,transformation_matrix_schritt);
        
        transform_frame2 = transformData3D(transform_frame2,transformation_matrix_schritt2);
        [x2,y2,z2] = transformEbene3D( x2,y2,z2,transformation_matrix_schritt2);

        %schreibe in CSV
        dlmwrite(CSV_name, transform_frame, '-append');
        dlmwrite(CSV_name2, transform_frame2, '-append');
        
    end


end

%Speichern des letzen Ergebnisses für weitere Transformationen
Transform_save = transform_frame;
Transform_save2 = transform_frame2;

%Rundungsfehler bei Matrix-Multiplikation?
%transformation_matrix_gesamt = transformation_matrix_calc(winkel,rotation_achse,translation_punkt);
%transformation_matrix_gesamt2 = transformation_matrix_calc(winkel2,rotation_achse2,translation_punkt2);
%[x,y,z] = transformEbene3D( x,y,z,transformation_matrix_gesamt);
%[x2,y2,z2] = transformEbene3D( x2,y2,z2,transformation_matrix_gesamt2);

end