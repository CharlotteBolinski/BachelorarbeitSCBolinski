function [ fehler_homographie ] = homographie_fehler( homographie_matrix, start, ziel )

start_s = size(start);
daten_punkte = start_s(1);

homographie_invers = inv(homographie_matrix);

if daten_punkte ~= 0

for h = 1:daten_punkte
    start_pkt = [start(h,:), 1]';
    ziel_pkt = [ziel(h,:), 1]';
    
    %homo_start = homographie_invers*ziel_pkt;
    %homo_ziel = homographie_matrix*start_pkt;
    %homo_start = start_pkt - homographie_invers*ziel_pkt
    %homo_ziel = ziel_pkt - homographie_matrix*start_pkt
    
    start_inv = homographie_invers*ziel_pkt;
    start_inv_pkt = start_inv(1:2)./start_inv(3);
    
    ziel_inv = homographie_matrix*start_pkt;
    ziel_inv_pkt = ziel_inv(1:2)./ziel_inv(3);
    
    s = start(h,:)';
    z = ziel(h,:)';
    
    teil1(h,:) = (s - start_inv_pkt).^2; %richtig?
    teil2(h,:) = (z - ziel_inv_pkt).^2;
    fehler_tmp = sqrt(teil1 + teil2);
end

%fehler normieren, Werte werden Null, wenn Abweichung erst bei 0.1e-10 anfängt
 fehler_homographie = (fehler_tmp(:,1) + fehler_tmp(:,2))./2;
%fehler(fehler<0.1e-10) = 0;

else
    disp('Keine Werte zur Fehlerberechnung!');
    fehler_homographie = [];
end


end

