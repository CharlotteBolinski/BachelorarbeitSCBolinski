function [ translation_matrix ] = translation_matrix_calc( translation )
%Matrix für Starrkörpertransformation berechnen um diese Matrix flexibler
%Einsetzbar zu machen

    %translationsmatrix
    translation_matrix = [1 0 0 translation(1); 0 1 0 translation(2); 0 0 1 translation(3); 0 0 0 1];
    
end

