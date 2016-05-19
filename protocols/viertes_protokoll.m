%Transformation mehrerer Objekte, arbeiten mit handles

%---------------------------------------------------------------------------
%simultan
%... vieeele For-Loops
%kombi_Random = [Random_werte Random_werte2]
%kombi_Ebene = [x y z x2 y2 z2]

%doppeltes an Inputwerten
%Ebenen sollten gleichzeitig geändert werden
%Ist egal wenn beide ebenen eh in eine andere CSV geschrieben werden!!
%Einfach Funktion 2x aufrufen
%[Random_werte Random_werte2 x y z x2 y2 z2] = transformation_export_2x(Random_werte,Random_werte2, x, y, z, x2, y2, z2, 0, 0, [1 0 0], [1 0 0] ,[0 5 0] ,[0 -5 0], '1Sekunde.csv', '1Sekunde_2.csv')