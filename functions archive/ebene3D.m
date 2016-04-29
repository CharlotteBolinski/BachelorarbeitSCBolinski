function [ x,y,z,ebene_handle] = ebene3D( von,bis,zeroKomponente)
%Funktion um Koordinaten einer Ebene im 3dimensionalen Raum festzulegen
%von: Anfangspunkt der Ebene
%bis: Endpunkt der Ebene
%Random Werte, die auf und in der Ebene liegen werden je nach Null-Komponente erzeugt
    
    if von < bis
        
        if zeroKomponente == 'x'
            x = zeros(2,2);
            y = [von bis ; von bis];
            z = [von von ; bis bis];
        end
        
        if zeroKomponente == 'y'
            x = [von bis ; von bis];
            y = zeros(2,2);
            z = [von von ; bis bis];
        end
        
        if zeroKomponente == 'z'
            x = [von bis ; von bis];
            y = [von von ; bis bis];
            z = zeros(2,2);
        end
        
    end
    
    ebene_handle = surf(x,y,z);
    alpha(.2);
    
    xlabel('x');
    ylabel('y');
    zlabel('z');

end

