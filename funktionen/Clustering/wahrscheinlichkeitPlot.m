function [ ] = wahrscheinlichkeitPlot( p, x_name, y_name, titel1, titel2 )
%Plot der Wahrscheinlichkeiten für jeden Punkt zu einem Cluster zu gehören
%Betrachtet wird nur das Endresultat

size_p = size(p);
rows_p = size_p(1);
r_p = 1:rows_p;

%{
%einzeln
figure('name', titel1);
plot(r_p, p(:,2), 'b');
title(titel1);
xlabel(x_name);
ylabel(y_name);

figure('name', titel2);
plot(r_p, p(:,1), 'r');
title(titel2);
xlabel(x_name);
ylabel(y_name);
%}

%zusammen
figure('name', 'Wahrscheinlichkeiten zusammen');
plot(r_p, p(:,1), 'r', r_p, p(:,2), 'b');
title('Wahrscheinlichkeit Fuzzy C-means')


end

