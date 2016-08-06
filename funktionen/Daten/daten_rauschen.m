function [ daten_rauschen ] = daten_rauschen( input_daten, von, bis )
%Berechnung der Drehachse durch den Ebenenmittelpunkt.
%
%INPUT:
%
%   input_daten     =   2D Input Daten, 2xn Matrix
%   von             =   obere Grenze der Verrauschung
%   bis             =   untere Grenze der Verrauschung
%
%OUTPUT:
%
%   daten_rauschen   = verrauschte Daten, 2xn
%
%Autor: Sophie-Charlotte Bolinski, Matrikelnummer: 545839, htw-berlin

input_size = size(input_daten);

rows = input_size(1);
columns = input_size(2);

%Parameter für random übergeben!!
rauschen = (bis-von).*rand(rows,columns) + von;

%Rauschen anwenden
daten_rauschen = input_daten + rauschen;

end

