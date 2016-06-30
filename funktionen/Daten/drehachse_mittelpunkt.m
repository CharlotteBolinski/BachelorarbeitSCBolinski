function [ drehachse ] = drehachse_mittelpunkt( ebene_x, ebene_y, ebene_z )
%Berechnung der Drehachse durch den Ebenenmittelpunkt.
%
%INPUT:
%
%   x   =   x-Matrix der Ebene für surface plot
%   y   =   y-Matrix der Ebene für surface plot
%   z   =   z-Matrix der Ebene für surface plot
%
%OUTPUT:
%
%   drehachse   = Drehachse in Form eines Vektors 3x1

%Komponentenberechnung je nach Orientierung der Ebene anders????
x1 = ebene_x(1,1)
x2 = ebene_x(1,2)

y1 = ebene_y(1,1)
y2 = ebene_y(2,1)

z1 = ebene_z(1,1) %??
z2 = ebene_z(1,2)

x_vektor = [x2-x1 ; 0 ; 0]
y_vektor = [0 ; y2-y1 ; 0]
z_vektor = [0 ; 0 ; z2-z1]

%Kreuzprodukt
kreuzprodukt = cross(x_vektor, y_vektor)

%verschieben des Kreuzproduktes in den Mittelpunkt der Ebene
drehachse = kreuzprodukt + [x_vektor(1); y_vektor(2); z_vektor(3)]

end

