function [ n ] = noise( anzahl_punkte, von1, bis1, von2, bis2)
%Noise generation to test clustering algorithms

     xRandom = (bis1-von1).*rand(anzahl_punkte,1) + von1;
     yRandom = (bis2-von2).*rand(anzahl_punkte,1) + von2;
     zRandom = zeros(anzahl_punkte,1);
     
     n = [xRandom, yRandom, zRandom];
     
     %hold on
     %scatter(xRandom, yRandom);
     %hold off

end

