function [ ] = wahrscheinlichkeitPlot( p, x_name, y_name, titel1, titel2 )
%Plot der Wahrscheinlichkeiten f�r jeden Punkt zu einem Cluster zu geh�ren
%Betrachtet wird nur das Endresultat
%
%INPUT:
%
%   p              =   Wahrscheinlichkeiten des Fuzzy C-means
%   x_name         =   Name der x-Achse , bei einzelner Darstellung
%   y_name         =   Name der y-Achse, bei einzelner Darstellung
%   titel1         =   Titel 1. Darstellung, bei einzelner Darstellung 
%   titel2         =   Titel 2. Darstellung, bei einzelner Darstellung 
%
%OUTPUT:
%
%   []
%
%Autor: Sophie-Charlotte Bolinski, Matrikelnummer: 545839, htw-berlin

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
set(gca,'FontSize',18); 

xlabel('Werte sortiert nach Wahrescheinlichkeit')
ylabel('Wahrescheinlichkeit')
%title('Wahrscheinlichkeit Fuzzy C-means')


end

