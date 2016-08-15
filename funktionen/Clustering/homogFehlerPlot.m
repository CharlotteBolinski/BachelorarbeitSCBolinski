function [ output_args ] = homogFehlerPlot( fehler_cluster1, fehler_cluster2, sort_column1, sort_column2, name )
%Plot der HOMOGRAPHIE FEHLER pro Cluster für alle Werte
%Fehler sind in einer 2xn Matrix: [Fehler zu Cluster1, Fehler zu Cluster 2]


        size_f1 = size(fehler_cluster1);
        rows_f1 = size_f1(1);
        rf1 = 1:rows_f1;

        size_f2 = size(fehler_cluster2);
        rows_f2 = size_f2(1);
        rf2 = 1:rows_f2;

        figure('name', name);
        if ~isempty(fehler_cluster1)
            [hf_cluster1_sort, index_hf1] = sortrows(fehler_cluster1,sort_column1);
            plot(rf1, hf_cluster1_sort(:,sort_column1), 'r');
        end
        
        hold on
        %figure('name', 'Homographie Fehler Cluster 2');
        
        if ~isempty(fehler_cluster2)
            [hf_cluster2_sort, index_hf2] = sortrows(fehler_cluster2,sort_column2);
            plot(rf2, hf_cluster2_sort(:,sort_column2), 'b');
        end

        set(gca,'FontSize',18); 
        xlabel('Sortierte Fehlerwerte');
        ylabel('Fehler');

        hold off

end

