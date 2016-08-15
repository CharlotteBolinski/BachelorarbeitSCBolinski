function [ x,y,z,Random_werte] = ebene3D_scatter( von1, bis1, von2, bis2, zeroKomponente, anzahlRandom,color_array)
%Funktion um Koordinaten einer Ebene im 3dimensionalen Raum festzulegen
%
%INPUT:
%
%   von1         =   Anfangspunkt der Ebene1
%   bis1         =   Endpunkt der Ebene1
%   von2         =   Anfangspunkt der Ebene1
%   bis2         =   Endpunkt der Ebene1
%   ebene_z         =   Matrix der z-Koordinaten der Ebene
%   fx              =   Brennweite in x-Richtung
%   fy              =   Brennweite in y-Richtung
%   principal_point =   Bildmittelpunkt
%
%OUTPUT:
%
%   projektion   = projezierte Punkte der Ebene
%
%Autor: Sophie-Charlotte Bolinski, Matrikelnummer: 545839, htw-berlin
    
    %if von < bis %bei negativ?
    %if von > bis
        %Vorzeichen umkehren?
    %end

        if zeroKomponente == 'x'
            x = zeros(2,2);
            y = [von1 bis1 ; von1 bis1];
            z = [von2 von2 ; bis2 bis2];
            %Ebene_werte = [zeros(4,1); von bis von bis; von von bis bis];
            
            xRandom = zeros(anzahlRandom,1);
            yRandom = (bis1-von1).*rand(anzahlRandom,1) + von1;
            zRandom = (bis2-von2).*rand(anzahlRandom,1) + von2;
            Random_werte = [xRandom, yRandom, zRandom];
        end
        
        if zeroKomponente == 'y'
            x = [von1 bis1 ; von1 bis1];
            y = zeros(2,2);
            z = [von2 von2 ; bis2 bis2];
            %Ebene_werte = [von bis von bis; zeros(4,1); von von bis bis];
            
            xRandom = (bis1-von1).*rand(anzahlRandom,1) + von1;
            yRandom = zeros(anzahlRandom,1);
            zRandom = (bis2-von2).*rand(anzahlRandom,1) + von2;
            Random_werte = [xRandom, yRandom, zRandom];
        end
        
        if zeroKomponente == 'z'
            x = [von1 bis1 ; von1 bis1];
            y = [von2 von2 ; bis2 bis2];
            z = zeros(2,2);
            %Ebene_werte = [von bis von bis; von von bis bis; zeros(4,1)];
            
            xRandom = (bis1-von1).*rand(anzahlRandom,1) + von1;
            yRandom = (bis2-von2).*rand(anzahlRandom,1) + von2;
            zRandom = zeros(anzahlRandom,1);
            Random_werte = [xRandom, yRandom, zRandom];
        end
        
    %end
    
    surface = surf(x,y,z);
    set(surface,'FaceColor',color_array,'FaceAlpha',0.2);
    
    hold on
    
    scatter3(xRandom, yRandom, zRandom);
    
    %hold off %beim zeichnen von mehreren Ebenen ein Problem
    
    xlabel('x');
    ylabel('y');
    zlabel('z');
    
end

