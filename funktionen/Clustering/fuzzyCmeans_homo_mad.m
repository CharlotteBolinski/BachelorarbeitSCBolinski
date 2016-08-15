function [input_daten, cluster1, cluster2, homographie_sort, homographie_daten, homographie_init_index] = fuzzyCmeans_homo_mad( wahr_index, cluster_input, vektoren, numCluster)
    
    %Input Daten Größe
    input_size = size(cluster_input); %input = column Vektor
    rows = input_size(1);
    
    %cluster_input = label, wertx, werty
    input_daten = [cluster_input(:,1:3), vektoren(:,2:4), zeros(rows,1)]; %label, cluster_daten 1. Frame == Projektionsdaten 1. Frame, zeros = Indizes  

    anzahl_fehler = [];
    
    %Festes Setzen der Schwellwerte
    %schwellwert_mad1 = 100;
    %schwellwert_mad2 = 100;
        
    count = 0;
    
%while mean homographie > 0 -----------------------------------------------
for i = 1:2 %Test
%while mean_ohne(1) > 0.1 && mean_save(1) > 0.1 && mean_ohne(2) > 0.1 && mean_save(2) > 0.1

    %initiale Cluster------------------------------------------------------
    cluster1_daten = input_daten(input_daten(:,1) == 1, 1:6);
    cluster2_daten = input_daten(input_daten(:,1) == 2, 1:6);
    
    %Homographie Fehler initial--------------------------------------------
    start1 = input_daten(input_daten(:,1) == 1, 2:3); %Cluster1 Daten
    start2 = input_daten(input_daten(:,1) == 2, 2:3); %Cluster2 Daten

    vektoren1 = input_daten(input_daten(:,1) == 1 , 4:5);
    vektoren2 = input_daten(input_daten(:,1) == 2, 4:5);

    ziel1 =  start1 + vektoren1;
    ziel2 =  start2 + vektoren2;

    %initial zum direkten Cluster
    [homographie_matrix1, homo_fehler1] = homographie_cluster(start1, ziel1); 
    [homographie_matrix2, homo_fehler2] = homographie_cluster(start2, ziel2);
    
    %fehler zu jeweils anderem Cluster
    hf12_init = homographie_fehler(homographie_matrix2, start1, ziel1);
    hf22_init = homographie_fehler(homographie_matrix1, start2, ziel2);
    
    h1_init = [homo_fehler1, hf12_init];
    h2_init = [hf22_init, homo_fehler2];
    homographie_init = [h1_init; h2_init];
    homographie_init_index = [homographie_init, input_daten(:,6)];
    
    index_cluster1 = input_daten(input_daten(:,1) == 1 , 6);
    index_cluster2 = input_daten(input_daten(:,1) == 2 , 6);
    
    %Test------------------------------------------------------------------
    
    %init_test = homographie_init_index(homographie_init_index(:,2:3) > 15, :)

    %Median der Homographie Fehler, einzelne Cluster
    median_cl1 = median(homo_fehler1);
    median_cl2 = median(homo_fehler2);
    
    cl1_diff = abs(homo_fehler1 - median_cl1); %Median der Fehler soll berechnet werden!!
    cl2_diff = abs(homo_fehler2 - median_cl2);
    
    mad_cl1 = median(cl1_diff);
    mad_cl2 = median(cl2_diff);
    
    m_i_cl1 = abs(cl1_diff./mad_cl1);
    m_i_cl2 = abs(cl2_diff./mad_cl2);
   
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    mi1_sort = sortrows(m_i_cl1);
    mi2_sort = sortrows(m_i_cl2);
    
    %mi_test = [m_i_cl1; m_i_cl2];
    %init_index_mi = [homographie_init_index, mi_test]
    
    %{
    grenz1 = mi1_sort(50)
    grenz2 = mi2_sort(50)
    
    figure('name', 'mi');
    plot(sortrows(m_i_cl1), 'r');
    hold on
    plot(sortrows(m_i_cl2), 'b');
    hold off
    
    %grenz1 = m_i_cl1(10)
    %grenz2 = m_i_cl2(10)
    %}
    
    %Schwellwert für jedes Cluster dynamisch gesetzt
    %schwellwert_mad1 = mi1_sort(5)
    %schwellwert_mad2 = mi2_sort(5)
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Plot der HOMOGRAPHIE FEHLER pro Cluster aller Werte ohne Aussortieren
    %nur für 1. Iteration zeigen
    if count == 0
        homogFehlerPlot( homo_fehler1, homo_fehler2, 1, 1, 'Homographie Fehler, letztendliche Cluster ANFANG' );
        
        limit_init = axis
        
        %Fehler Grenze Plotten, ab der Aussortirt wird
        %Index der sortierten Fehlerwerte
        %{
        size_homo_init = size(homographie_init);
        rows_homo_init = size_homo_init(1);
        sort_index_homo = 1:rows_homo_init

        homo_sort1 = sortrows(homographie_init,1);
        homo_sort2 = sortrows(homographie_init,2);
        
        homo_init_index1 = [homo_sort1,sort_index_homo']
        homo_init_index2 = [homo_sort2,sort_index_homo']
        
        max_mi_schwellwert1 = max(mi_schwellwert1);
        x1_grenze = max_mi_schwellwert1(2);
        %}

        schwellwert_mad1 = median(mi1_sort);
        schwellwert_mad2 = median(mi2_sort);
                
        size_index_1 = size(cluster1_daten);
        rows_index_1 = size_index_1(1);
        sort_index_1 = 1:rows_index_1;
        
        size_index_2 = size(cluster2_daten);
        rows_index_2 = size_index_2(1);
        sort_index_2 = 1:rows_index_2;
        
        mi_homo_index1 = [mi1_sort, sort_index_1'] %nur x-Werte der Cluster
        mi_homo_index2 = [mi2_sort, sort_index_2'] %nur x-Werte der Cluster
        
        mi_schwellwert1 = mi_homo_index1(mi_homo_index1(:,1) < schwellwert_mad1, :);
        max_mi_schwellwert1 = max(mi_schwellwert1)
        x1_grenze = max_mi_schwellwert1(2);
        
        mi_schwellwert2 = mi_homo_index2(mi_homo_index2(:,1) < schwellwert_mad2, :);
        max_mi_schwellwert2 = max(mi_schwellwert2)
        x2_grenze = max_mi_schwellwert2(2);

        hold on
        l1 = line([x1_grenze x1_grenze],[0 limit_init(4)]);
        set(l1 ,'Color','r')
        
        l2 = line([x2_grenze x2_grenze],[0 limit_init(4)]);
        set(l2 ,'Color','b')
        hold off
        
        xlabel('Sortierte Fehlerwerte');
        ylabel('Abbildungsfehler');
        set(gca,'FontSize',18); 
        
    end
    
    count = count+1
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    
    cluster1_tmp = [cluster1_daten, m_i_cl1];
    cluster2_tmp = [cluster2_daten, m_i_cl2];
    
    %Cluster ohne Ausreißer------------------------------------------------
    cluster1_ohne = cluster1_tmp(cluster1_tmp(:,7) < schwellwert_mad1, 1:3); %vielleicht geht das nicht 
    cluster2_ohne = cluster2_tmp(cluster2_tmp(:,7) < schwellwert_mad2, 1:3);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Aussortierte Werte Plotten
    
    %figure('name', 'Plot Aussortierter Werte');
    %clusterPlot()
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %Homographie ohne Ausreißer--------------------------------------------
    size_cluster1_ohne = size(cluster1_ohne);
    size_cluster2_ohne = size(cluster2_ohne);
    
    if size_cluster1_ohne(1) > 4
        start1_ohne = cluster1_ohne(:, 2:3);
        vektoren1_ohne = cluster1_tmp(cluster1_tmp(:,7) < schwellwert_mad1, 4:5);
        ziel1_ohne =  start1_ohne + vektoren1_ohne;
        [homographie_matrix1_ohne, homo_fehler1_ohne] = homographie_cluster(start1_ohne, ziel1_ohne);
        
        %Fehler ohne Ausreißer mit Index zur Auswertung------------------------
        index1_ohne = cluster1_tmp(cluster1_tmp(:,7) < schwellwert_mad1, 6);
    else
        disp('Keine Werte für das 1. Cluster aussortiert');
        homographie_matrix1_ohne = homographie_matrix1;
    end
    
    if size_cluster2_ohne(1) > 4
        start2_ohne = cluster2_ohne(:, 2:3);
        vektoren2_ohne = cluster2_tmp(cluster2_tmp(:,7) < schwellwert_mad2, 4:5);
        ziel2_ohne =  start2_ohne + vektoren2_ohne;
        [homographie_matrix2_ohne, homo_fehler2_ohne] = homographie_cluster(start2_ohne, ziel2_ohne);

        %Fehler ohne Ausreißer mit Index zur Auswertung------------------------
        index2_ohne = cluster2_tmp(cluster2_tmp(:,7) < schwellwert_mad2, 6);

    else
        disp('Keine Werte für das 2. Cluster aussortiert');
        homographie_matrix2_ohne = homographie_matrix2; 
    end
    
    %Extra Fehler Berechnung, da Homographie Matrizen zuerst definiert sein müssen
    if size_cluster1_ohne(1) > 4
        %homographie_invers1 = inv(homographie_matrix1_ohne);
        fehler1_ohne = homographie_fehler(homographie_matrix2_ohne, start1_ohne, ziel1_ohne); %Cluster 1 zu Cluster 2 Schätzung
        fehler_gesamt_1_ohne = [ homo_fehler1_ohne , fehler1_ohne]; %Fehler cluster1, Fehler cluster2
        homo1_ohne = [fehler_gesamt_1_ohne, index1_ohne];
    else
        homo1_ohne = [];
    end
    
    if size_cluster2_ohne(1) > 4
        %homographie_invers2 = inv(homographie_matrix2_ohne);
        fehler2_ohne = homographie_fehler(homographie_matrix1_ohne, start2_ohne, ziel2_ohne); %Cluster 2 zu Cluster 1 Schätzung
        fehler_gesamt_2_ohne = [ fehler2_ohne , homo_fehler2_ohne]; %Fehler cluster1, Fehler cluster2
        homo2_ohne = [fehler_gesamt_2_ohne, index2_ohne];
    else
        homo2_ohne = [];
    end
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %show_h1ohne = homo1_ohne
    %show_h2ohne = homo2_ohne
    
    homo_ohne = [homo1_ohne; homo2_ohne];

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Homographie Fehler falsch zugeordneter Werte , bekannt durch ground truth 
    %{
    homo_f1_index = [homo_fehler1, cluster1_daten(:,6)];
    homo_f2_index = [homo_fehler2, cluster2_daten(:,6)];
    homo_index = [homo_f1_index; homo_f2_index];
    
    homo_werte_falsch = [];
    
    ff = size(fehler_fuzzy);
    rf = ff(1);
    
    for i=1:rf
        homo_werte_falsch(i,:) = homo_index(homo_index(:,2) == fehler_fuzzy(i,4),:);
    end
    
    fehler_falsch_zugeordnet = homo_werte_falsch;
    %}
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    %Berechnung des Homographie Fehlers der aussortierten Daten nach Schätzung der Homographie der nicht aussortierten Daten
    
    if ~isempty(homo1_ohne)
        save1 = cluster1_tmp(cluster1_tmp(:,7) >= schwellwert_mad1, 1:3);
        vektoren1_save = cluster1_tmp(cluster1_tmp(:,7) >= schwellwert_mad1, 4:5);
        index1_save = cluster1_tmp(cluster1_tmp(:,7) >= schwellwert_mad1, 6);
        
        save_start1 = save1(:,2:3);
        save_ziel1 = save_start1 + vektoren1_save;
        
        %Homographie Fehler gegenüber jeden Clusters berechnen-----------------
        hf11 = homographie_fehler(homographie_matrix1_ohne, save_start1, save_ziel1);
        hf12 = homographie_fehler(homographie_matrix2_ohne, save_start1, save_ziel1);      
        
        fehler1_save = [hf11 , hf12]; %Fehler cluster1, Fehler cluster2
        homo1_save = [fehler1_save, index1_save];
    
    else
        disp('Keine aussortierten Daten, Daten bleiben für 1. Cluster');
        index1_save = cluster1_tmp(:,6);
        homo1_save = [homo_fehler1, hf12_init, index1_save];
    end
    
    if ~isempty(homo2_ohne)
        save2 = cluster2_tmp(cluster2_tmp(:,7) >= schwellwert_mad2, 1:3);
        vektoren2_save = cluster2_tmp(cluster2_tmp(:,7) >= schwellwert_mad2, 4:5);
        index2_save = cluster2_tmp(cluster2_tmp(:,7) >= schwellwert_mad2, 6);
        
        save_start2 = save2(:,2:3);
        save_ziel2 = save_start2 + vektoren2_save;
        
        %Homographie Fehler gegenüber jeden Clusters berechnen-----------------
        hf21 = homographie_fehler(homographie_matrix1_ohne, save_start2, save_ziel2);
        hf22 = homographie_fehler(homographie_matrix2_ohne, save_start2, save_ziel2);
        
        fehler2_save = [hf21 , hf22]; %Fehler cluster1, Fehler cluster2
        homo2_save = [fehler2_save, index2_save];
        
    else
        disp('Keine aussortierten Daten, Daten bleiben für 2. Cluster');
        index2_save = cluster2_tmp(:,6);
        homo2_save = [hf22_init, homo_fehler2, index2_save];
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Fehler+Index für 1. Cluster
    cluster1_fehler_index = [homo1_ohne; homo1_save];
    
    %Fehler+Index für 2. Cluster
    cluster2_fehler_index = [homo2_ohne; homo2_save];
    
    homographie_fehler_index = [cluster1_fehler_index; cluster2_fehler_index];

    %Clusterlabel update für nächste Iteration-----------------------------
    update_index = homographie_fehler_index(:,3);
    
    size_save = size(homographie_fehler_index);
    rows_save = size_save(1);
    
    for h = 1:rows_save
        
        input_index = update_index(h);
        
        if homographie_fehler_index(h,1) < homographie_fehler_index(h,2)
            input_daten(input_daten(:,6) == input_index,1) = 1;
        else
            input_daten(input_daten(:,6) == input_index,1) = 2;
        end
        
    end
    
    %while Bedingung update------------------------------------------------
    mean_calc = mean(mean(homographie_fehler_index(:,1:2)))
    mean_init = mean(mean(homographie_init(:,1:2)))
    
    %Speichern Unterschied zu Ground Truth----------------------------------
    %Unterscheid berechnen, Plot unterdrückt
    [fehler_h, anzahl_fehler_h] = unterschiedPlot_homo(wahr_index, input_daten, homographie_init_index, zeros(2,2) , 'm', 'Homographie unterschied', 'Fehler falsch zugeordnet, Homographie', 'j');
    anzahl_fehler(count,:) = [count, anzahl_fehler_h];
    
%end while----------------------------------------------------------------- 
end 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Fehler mit Index zurück geben zur Auswertung für das Video Clustering
%homographie_fehler_index = [homo_ohne; homo_save];
%homographie_fehler_index(isnan(homographie_fehler_index)) = schwellwert_mad; %?

%homographie_init_index = [homographie_init, input_daten(:,6)];

%homographie_init_index_sort = sortrows(homographie_init_index,3);
%homographie_fehler_index_sort = sortrows(homographie_fehler_index,3);

%mean_calc = mean(homographie_init_index_sort)
%mean_init = mean(homographie_fehler_index_sort)

%diff_all = homographie_init_index_sort - homographie_fehler_index_sort;

homographie_sort = sortrows(homographie_fehler_index,3);
input_sortiert = sortrows(input_daten,6);
     
homographie_daten = input_sortiert(:, 2:3);
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Plot der HOMOGRAPHIE FEHLER pro Cluster für alle Werte
homo1_plot = cluster1_fehler_index;
homo2_plot = cluster2_fehler_index;
homogFehlerPlot( homo1_plot, homo2_plot, 1, 2, 'Homographie Fehler, letztendliche Cluster ENTSCHEIDUNG' );

axis(limit_init);

xlabel('Sortierte Fehlerwerte');
ylabel('Abbildungsfehler');
set(gca,'FontSize',18);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%      
anzahl_fehler_pro_Iteration = anzahl_fehler
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
cluster1 = [input_daten(input_daten(:,1) == 1, 1:3), input_daten(input_daten(:,1) == 1, 6)];
cluster2 = [input_daten(input_daten(:,1) == 2, 1:3), input_daten(input_daten(:,1) == 2, 6)];

end

