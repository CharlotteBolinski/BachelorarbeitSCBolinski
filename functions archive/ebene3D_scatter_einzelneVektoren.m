function [ x,y,z,xRandom,yRandom,zRandom,ebene_handle,punkte_handle] = ebene3D_scatter( von,bis,zeroKomponente,anzahlRandom)
%Funktion um Koordinaten einer Ebene im 3dimensionalen Raum festzulegen
%von: Anfangspunkt der Ebene
%bis: Endpunkt der Ebene
%Random Werte, die auf und in der Ebene liegen werden je nach Null-Komponente erzeugt
    
    if von < bis %bei negativ?

        if zeroKomponente == 'x'
            x = zeros(2,2);
            y = [von bis ; von bis];
            z = [von von ; bis bis];
            
            xRandom = zeros(anzahlRandom,1);
            yRandom = (bis-von).*rand(anzahlRandom,1) + von;
            zRandom = (bis-von).*rand(anzahlRandom,1) + von;
        end
        
        if zeroKomponente == 'y'
            x = [von bis ; von bis];
            y = zeros(2,2);
            z = [von von ; bis bis];
            
            xRandom = (bis-von).*rand(anzahlRandom,1) + von;
            yRandom = zeros(anzahlRandom,1);
            zRandom = (bis-von).*rand(anzahlRandom,1) + von;
        end
        
        if zeroKomponente == 'z'
            x = [von bis ; von bis];
            y = [von von ; bis bis];
            z = zeros(2,2);
            
            xRandom = (bis-von).*rand(anzahlRandom,1) + von;
            yRandom = (bis-von).*rand(anzahlRandom,1) + von;
            zRandom = zeros(anzahlRandom,1);
        end
        
    end
    
    ebene_handle = surf(x,y,z);
    alpha(.2);
    
    hold on
    
    punkte_handle = scatter3(xRandom, yRandom, zRandom);
    
    %hold off %beim zeichnen von mehreren Ebenen ein Problem
    
    xlabel('x');
    ylabel('y');
    zlabel('z');

end

