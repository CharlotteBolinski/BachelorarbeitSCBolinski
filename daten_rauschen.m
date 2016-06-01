function [ daten_rauschen ] = daten_rauschen( input_daten, von, bis )
%Funktion erzeugt Rauschen/ Varianz auf den Datenwerten
%Autor: Sophie-Charlotte Bolinski, Matrikelnummer: 545839, htw-berlin

%input_daten = csvread(projektion_csv);
input_size = size(input_daten);

rows = input_size(1)
columns = input_size(2);

%Parameter für random übergeben!!
rauschen = (bis-von).*rand(rows,columns) + von;

%Rauschen anwenden
daten_rauschen = input_daten + rauschen;

%dlmwrite(rauschen_csv, daten_rauschen , '-append');

end

