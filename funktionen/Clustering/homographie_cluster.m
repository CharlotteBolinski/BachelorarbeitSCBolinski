%Übergeben werden projezierte Daten projektion_2D
%von einem zum nächsten Frame

%homographie( punkte_start, punkte_ziel, anzahl_frames, frame_index)
%Es werden immer nur 2 Frames betrachtet! 
%Homographie muss pro vorgeclustertem Körper berechnet werden!! NICHT auf
%alle Daten, sonst kommt eine falsche HGomographieschätzung heraus
%homographie( projektion_A, frame_index_start, frame_index_ziel)

%homographie( projektion_A', 4, 1, 2)---------------

%test
%homographie( rauschen_A, 4, 1, 2)
%homographie( rauschen_B, 4, 1, 2)
%homographie( projektion_A', 4, 1, 2)
%homographie( projektion_B', 4, 1, 2)
%Ergebnis: Fehler schwankt zwischen 0 und 1

%Affine Homographie kann u.U. robuster für die Fehlerberechnung sein

function [ homographie_matrix,  homographie_fehler] = homographie_cluster( start, ziel)
%Eingang ist eine Projektion von Daten für 2 Frames
%Hier wird zunächst von einer Berechnung zwischen 2 Frames ausgegangen
%
%INPUT:
%
%   projektion_gesamt   =   Werte der Projektion in den 2D Raum, Nx2 Matrix
%   anzahl_frames       =   Anzahl der Frames pro Sekunde
%   frame_index_start   =   von welchem Frame aus
%   frame_index_ziel    =   bis zu welchem Frame
%
%OUTPUT:
%   
%   homographie_matrix  =   Geschätzte Transformationsmatrix
%   homographie_fehler  =   Fehler für jeden Punkt der Homographie-Schätzung
%
%Autor: Sophie-Charlotte Bolinski, Matrikelnummer: 545839, htw-berlin

%Punkte pro Frame ermitteln
%punkte_size = size(projektion_gesamt);
%punkte_pro_frame = punkte_size(1)/anzahl_frames;

%Initialisierung
start_s = size(start);
%ziel_s = size(ziel)
daten_punkte = start_s(1);

Punktmatrix = zeros(daten_punkte, 8);

%homographie_fehler_tmp = zeros(daten_punkte,1);
%Zielmatrix = zeros(daten_punkte*2,1);
%Punktmatrix = zeros(daten_punkte*2,8)

%Gleichungssystem mit MATLAB Funktionalität lösen
%Ausgegangen wird von 2D Daten mit [x y] als Spalten
for row = 1:daten_punkte
    
    %Matrix eines Punktes
    Point1 = [start(row,1), start(row,2), 1, 0, 0, 0, -start(row,1)*ziel(row,1), -start(row,2)*ziel(row,1)];
    Point2 = [0, 0, 0, start(row,1), start(row,2), 1, -start(row,1)*ziel(row,2), -start(row,2)*ziel(row,2)];
    Point = [Point1; Point2];

    %Definieren der Zielmatrix
    if row == 1

        Punktmatrix = Point;
        Zielmatrix = [ziel(row,1); ziel(row,2)]; %x'y'x'y'x'y'..

    else

        Punktmatrix = [Punktmatrix; Point];
        Zielmatrix = [Zielmatrix; ziel(row,1); ziel(row,2)];

    end
    
end

%Gleichungssystem lösen 
homographie_parameter = Punktmatrix\Zielmatrix;

%Parameter zu Matrix zusammensetzen
homographie_matrix = [homographie_parameter(1:3)'; homographie_parameter(4:6)'; homographie_parameter(7:8)', 1];

%Abbildungsfehler berechnen
%Fehler pro Punkt speichern, um Wahrscheinlichkeit zu berechnen, dass der
%Punkt zu dem Cluster gehört oder nicht (je nach Abweichung)

homographie_invers = inv(homographie_matrix);

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
fehler = (fehler_tmp(:,1) + fehler_tmp(:,2))./2;
%fehler(fehler<0.1e-10) = 0;


%{
size_f = size(fehler);
rows_f = size_f(1);
rf = 1:rows_f;
figure('name','test plot homo fehler');
plot(rf, fehler(:,1), 'r', rf, fehler(:,2), 'b');
%}

%Hp-q Homographie-Fehler für jeden Punkt!
%disp(fehler);
%for i = 1:daten_punkte
%    homographie_fehler_tmp(i) = sum(fehler(i,:)/3);
%end

homographie_fehler = fehler;

end

