function [ x,y,z,Random_werte] = ebene3D_scatter( von,bis,zeroKomponente,anzahlRandom)
%Funktion um Koordinaten einer Ebene im 3dimensionalen Raum festzulegen
%von: Anfangspunkt der Ebene
%bis: Endpunkt der Ebene
%Random Werte, die auf und in der Ebene liegen werden je nach Null-Komponente erzeugt
    
    if von < bis %bei negativ?

        if zeroKomponente == 'x'
            x = zeros(2,2);
            y = [von bis ; von bis];
            z = [von von ; bis bis];
            %Ebene_werte = [zeros(4,1); von bis von bis; von von bis bis];
            
            xRandom = zeros(anzahlRandom,1);
            yRandom = (bis-von).*rand(anzahlRandom,1) + von;
            zRandom = (bis-von).*rand(anzahlRandom,1) + von;
            Random_werte = [xRandom, yRandom, zRandom];
        end
        
        if zeroKomponente == 'y'
            x = [von bis ; von bis];
            y = zeros(2,2);
            z = [von von ; bis bis];
            %Ebene_werte = [von bis von bis; zeros(4,1); von von bis bis];
            
            xRandom = (bis-von).*rand(anzahlRandom,1) + von;
            yRandom = zeros(anzahlRandom,1);
            zRandom = (bis-von).*rand(anzahlRandom,1) + von;
            Random_werte = [xRandom, yRandom, zRandom];
        end
        
        if zeroKomponente == 'z'
            x = [von bis ; von bis];
            y = [von von ; bis bis];
            z = zeros(2,2);
            %Ebene_werte = [von bis von bis; von von bis bis; zeros(4,1)];
            
            xRandom = (bis-von).*rand(anzahlRandom,1) + von;
            yRandom = (bis-von).*rand(anzahlRandom,1) + von;
            zRandom = zeros(anzahlRandom,1);
            Random_werte = [xRandom, yRandom, zRandom];
        end
        
    end
    
    surf(x,y,z);
    alpha(.2);
    
    hold on
    
    scatter3(xRandom, yRandom, zRandom);
    
    hold off %beim zeichnen von mehreren Ebenen ein Problem
    
    xlabel('x');
    ylabel('y');
    zlabel('z');

    %lim übergeben?
    %xlim([0 10])
    %ylim([0 10])
    %zlim([0 10])
end

