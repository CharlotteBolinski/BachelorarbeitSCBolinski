function [ xEbene,yEbene,zEbene ] = matrix2ebene( ebene_matrix )
%Ebene wieder in einzelne Matrizen überführen für surface Plot

    xEbene = [Ebene(1,1) Ebene(1,2) ; Ebene(1,3) Ebene(1,4)];
    yEbene = [Ebene(2,1) Ebene(2,2) ; Ebene(2,3) Ebene(2,4)];
    zEbene = [Ebene(3,1) Ebene(3,2) ; Ebene(3,3) Ebene(3,4)];

end

