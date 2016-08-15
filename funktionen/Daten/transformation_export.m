function [ Transform_save, x,y,z, ebene_save ] = transformation_export( input_werte_matrix, xEbene, yEbene, zEbene,color_array, winkel, rotation_achse, rotation_punkt, translation_punkt, CSV_name)
%CSV Datei erzeugen, für die die Transformation von einem Anfangspunkt zu
%einem Endpunkt durchgeführt wird.
%25 Frames pro Sekunde werden angenommen.
%Ausgangswert wird eine Sekunde für die Transformation. Kann später auch im
%Funktionskopf übergeben werden um eine individuelle Dauer festzulegen.
%
%INPUT:
%
%   input_werte_matrix      =   3xn Werte, Startwerte Random verteilt auf der Ebene 
%   xEbene                  =   Matrix der x-Koordinaten der Ebene
%   yEbene                  =   Matrix der y-Koordinaten der Ebene
%   zEbene                  =   Matrix der z-Koordinaten der Ebene
%   color_array             =   Farbarray der Form [R G B], Werte 0-1
%   rotation_achse          =   Rotationsachse, 3x1 Matrix
%   rotation_punkt          =   Rotationspunkt, 3x1 Matrix
%   translation_punkt       =   Punkt zu dem translatiert werden soll, 3x1 Matrix
%   CSV_name                =   Name der CSV Datei zum speichern der Werte
%
%OUTPUT:
%
%   Transform_save      =   Random Daten, Zwischenschritt der Transformation gespeichert
%   x                   =   Matrix der x-Koordinaten der Ebene, transformiert
%   y                   =   Matrix der y-Koordinaten der Ebene, transformiert
%   z                   =   Matrix der z-Koordinaten der Ebene, transformiert
%   ebene_save          =   Ebene, Zwischenschritt der Transformation gespeichert
%
%Autor: Sophie-Charlotte Bolinski, Matrikelnummer: 545839, htw-berlin

%---------------------------------------------------------------------------
%Diese Größen später der Funktion übergeben!!
%frames und sekunden festlegen

%Testing
%frames = 25;
frames = 5; %WEITERE Frames

sekunden = 1;

%---------------------------------------------------------------------------
%alles Änderung pro Frame umrechnen
winkel_frame = winkel/(sekunden*frames);
translation_frame = translation_punkt/(sekunden*frames);

%Transformation um eine Achse
transformation_matrix_schritt = transformation_matrix_calc(winkel_frame,rotation_achse,translation_frame);

%Transformation um einen Punkt
%transformation_matrix_schritt = rotation_translation_matrix_calc(winkel_frame,rotation_achse,rotation_punkt, translation_frame);

transform_frame = input_werte_matrix;

x = xEbene;
y = yEbene;
z = zEbene;
ebene_save = [];

%---------------------------------------------------------------------------
%3D-Daten erzeugen und in CSV schreiben

for s = 1:sekunden
    
    for f = 1:frames

        transform_frame = transformData3D(transform_frame,transformation_matrix_schritt);
        
        [x,y,z] = transformEbene3D( x,y,z,transformation_matrix_schritt,color_array);
        
        %schreibe in CSV
        dlmwrite(CSV_name, transform_frame, '-append');
        
        %speichern Ebenendaten in MATRIX
        ebene_aktuell = [x,y,z];
        ebene_save = [ebene_save; ebene_aktuell];
        
    end


end


%title('Bewegung 2er Ebenen, 5 Frames');
%Speichern des letzen Ergebnisses für weitere Transformationen
Transform_save = transform_frame;

%Rundungsfehler bei Matrix-Multiplikation?
%transformation_matrix_gesamt = transformation_matrix_calc(winkel,rotation_achse,translation_punkt);
%[x,y,z] = transformEbene3D( x,y,z,transformation_matrix_gesamt);

end