function [ ebene_matrix ] = ebene2matrix( xEbene,yEbene,zEbene )
%Transformiert Matrizen für surface-Plot in Werte-Matrix (x;y;z;1),
%homogene Koordinaten

    %Ebene in einzelne Matrix überführen, homogene Koordinaten
    ebene_x = [xEbene(1,:) , xEbene(2,:)];
    ebene_y = [yEbene(1,:) , yEbene(2,:)];
    ebene_z = [zEbene(1,:) , zEbene(2,:)];
    ebene_1 = ones(1,4);
    ebene_matrix = [ebene_x; ebene_y; ebene_z; ebene_1];

end

