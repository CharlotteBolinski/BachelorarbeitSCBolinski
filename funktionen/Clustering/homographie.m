%�bergeben werden projezierte Daten projektion_2D
%von einem zum n�chsten Frame

%homographie( punkte_start, punkte_ziel, anzahl_frames, frame_index)
%Es werden immer nur 2 Frames betrachtet! 
%Homographie muss pro vorgeclustertem K�rper berechnet werden!! NICHT auf
%alle Daten, sonst kommt eine falsche HGomographiesch�tzung heraus
%homographie( projektion_A, frame_index_start, frame_index_ziel)

%homographie( projektion_A', 4, 1, 2)---------------

%test
%homographie( rauschen_A, 4, 1, 2)
%homographie( rauschen_B, 4, 1, 2)
%homographie( projektion_A', 4, 1, 2)
%homographie( projektion_B', 4, 1, 2)
%Ergebnis: Fehler schwankt zwischen 0 und 1

%Affine Homographie kann u.U. robuster f�r die Fehlerberechnung sein

function [ homographie_matrix,  homographie_fehler] = homographie( projektion_gesamt, anzahl_frames, frame_index_start, frame_index_ziel)
%Berechnung der Homographie von einem Satz Eingangsdaten eines Frames zu
%den Ausgangsdaten eines anderen Frames
%Hier wird zun�chst von einer Berechnung zwischen 2 Frames ausgegangen
%
%INPUT:
%
%   projektion_gesamt   =   Werte der Projektion in den 2D Raum, Nx2 Matrix
%   anzahl_frames       =   Anzahl der Frames pro Sekunde
%   frame_index_start   =   von welchem Frame aus
%   frame_index_ziel    =   bis zu welchem Frame
%
%Autor: Sophie-Charlotte Bolinski, Matrikelnummer: 545839, htw-berlin

%Punkte pro Frame ermitteln
punkte_size = size(projektion_gesamt);
punkte_pro_frame = punkte_size(1)/anzahl_frames;

%Daten selektieren/vorbereiten
start = projektion_gesamt(frame_index_start:(frame_index_start+punkte_pro_frame), :); %andere Spaltenauswahl wenn andere Daten �bergeben
ziel = projektion_gesamt(frame_index_ziel:(frame_index_ziel+punkte_pro_frame), :);

%Gleichungssystem mit MATLAB Funktionalit�t l�sen
%Ausgegangen wird von 2D Daten mit [x y] als Spalten
for row = 1:punkte_pro_frame
    
    %Matrix eines Punktes
    Point1 = [start(row,1), start(row,2), 1, 0, 0, 0, -start(row,1)*ziel(row,1), -start(row,2)*ziel(row,1)];
    Point2 = [0, 0, 0, start(row,1), start(row,2), 1, -start(row,1)*ziel(row,2), -start(row,2)*ziel(row,2)];
    Point = [Point1; Point2];

    %Anh�ngen der Punktmatrik an Gleichungssystem-Matrix
    %Definieren der Zielmatrix
    if row == 1

        Punktmatrix = Point;
        Zielmatrix = [start(row,1); start(row,2)];

    else

        Punktmatrix = [Punktmatrix; Point];
        Zielmatrix = [Zielmatrix; start(row,1); start(row,2)];

    end

end

%Gleichungssystem l�sen 
homographie_parameter = Punktmatrix\Zielmatrix;

%Parameter zu Matrix zusammensetzen
homographie_matrix = [homographie_parameter(1:3)'; homographie_parameter(4:6)'; homographie_parameter(7:8)',1]

%Abbildungsfehler berechnen
%Fehler pro Punkt speichern, um Wahrscheinlichkeit zu berechnen, dass der
%Punkt zu dem Cluster geh�rt oder nicht (je nach Abweichung)

homographie_invers = inv(homographie_matrix);

for h = 1:punkte_pro_frame

    ziel_pkt = [ziel(h,:), 1]';
    start_pkt = [start(h,:), 1]';
    
    teil1(h,:) = abs(start_pkt - homographie_invers*ziel_pkt).^2; %richtig?
    teil2(h,:) = abs(ziel_pkt - homographie_matrix*start_pkt).^2;
    fehler = teil1 + teil2;
end

%Hp-q Homographie-Fehler f�r jeden Punkt!
disp(fehler);
for i = 1:punkte_pro_frame
    homographie_fehler(i) = sum(fehler(i,:)/3);
end
%disp(homographie_fehler); %schwankt im Wertebereich? Werte abziehen um Fehler zu bekommen???

%Fehler [x y z] f�r jede Komponente gesamt
%homographie_fehler = [sum(fehler(:,1))/punkte_pro_frame, sum(fehler(:,2))/punkte_pro_frame, sum(fehler(:,3))/punkte_pro_frame];

end
