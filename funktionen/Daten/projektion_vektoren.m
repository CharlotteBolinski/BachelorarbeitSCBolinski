%projektion_vektoren_test(projektion_A, 6)
%frames +1 weil startwert mit gespeichert wird

function [ vektoren ] = projektion_vektoren(input_daten, frames)
%Funktion erzeugt Bewegungsvektoren durch Diffrenzbildung
%Autor: Sophie-Charlotte Bolinski, Matrikelnummer: 545839, htw-berlin

    %input_daten = csvread(projektion_csv);
    input = input_daten;
    input_size = size(input)

    rows = input_size(1);

    werte_pro_block = rows/frames %20
    
    %vektoren matrix initialisieren
    vektoren = zeros(rows-werte_pro_block, 2);
    
    %Frames == Anzahl blöcke
    for f = 0:(frames-2)
        
        block1 = input(f*werte_pro_block+1:(f+1)*werte_pro_block, :);
        block2 = input((f+1)*werte_pro_block+1:(f+2)*werte_pro_block, :);
        
        size_block1 = size(block1)
        size_block2 = size(block2)
        
        i1 = f*werte_pro_block+1
        i2 = (f+1)*werte_pro_block
        i3 = (f+1)*werte_pro_block+1
        i4 = (f+2)*werte_pro_block
        
        vektoren(f*werte_pro_block+1:(f+1)*werte_pro_block, :) = block2-block1;
        
    end

end

