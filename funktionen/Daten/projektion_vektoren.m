function [ bewegung ] = projektion_vektoren(input_daten, werte_pro_block)
%Funktion erzeugt Bewegungsvektoren durch Diffrenzbildung
%Autor: Sophie-Charlotte Bolinski, Matrikelnummer: 545839, htw-berlin

    %input_daten = csvread(projektion_csv);
    input = input_daten';
    input_size = size(input);

    rows = input_size(1);
    %columns = input_size(2);

    for b = 1:werte_pro_block-1:rows

        if  b+2*werte_pro_block-1 <= rows

            %{
            disp('b');
            disp(b);
            disp('b+werte_pro_block-1');
            disp(b+werte_pro_block-1);
            disp('b+2*werte_pro_block-1');
            disp(b+2*werte_pro_block-1);
            %}

            block_aktuell = input(b:b+werte_pro_block-1,:); %random-1
            %size(block_aktuell)

            block_nachfolger = input(b+werte_pro_block:b+2*werte_pro_block-1,:); %random, random*2-1
            %size(block_nachfolger)

            bewegung = block_nachfolger-block_aktuell;
            %size(bewegung)

        end

    end

end

