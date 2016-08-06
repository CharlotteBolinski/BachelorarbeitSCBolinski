function [ cluster1, cluster2, homo_sort_fehler] = fuzzyCmeans_homo_mad( cluster_input, vektoren, fehler_fuzzy, numCluster)
    
    %Input Daten Größe
    input_size = size(cluster_input); %input = column Vektor
    rows = input_size(1);
    
    %cluster_input = label, wertx, werty
    %Vektoren= wertx, werty
    input_daten = [cluster_input(:,1:3), vektoren(:,2:4)] %label, cluster_daten 1. Frame == Projektionsdaten 1. Frame, zeros = Fehlerwerte
    %vektor_daten = [cluster_input(:,1), vektoren]; %label unnötig??   
    
    %schwellwert_mad = 3.5;
    schwellwert_mad = 0.3;
        
    %ALLE Werte, die über MAD = median of absolute deviations erkannt werden aussortieren  
    cluster1_daten = input_daten(input_daten(:,1) == 1, 1:6);
    cluster2_daten = input_daten(input_daten(:,1) == 2, 1:6);
    
    %Homographie Fehler initial
    start1 = input_daten(input_daten(:,1) == 1, 2:3); %Cluster1 Daten
    start2 = input_daten(input_daten(:,1) == 2, 2:3); %Cluster2 Daten

    vektoren1 = input_daten(input_daten(:,1) == 1 , 4:5);
    vektoren2 = input_daten(input_daten(:,1) == 2, 4:5);

    ziel1 =  start1 + vektoren1;
    ziel2 =  start2 + vektoren2;

    [homographie_matrix1, homo_fehler1] = homographie_cluster(start1, ziel1); 
    [homographie_matrix2, homo_fehler2] = homographie_cluster(start2, ziel2);
    
    %Median der Homographie Fehler
    median_cl1 = median(homo_fehler1);
    median_cl2 = median(homo_fehler2);
    
    cl1_diff = abs(homo_fehler1 - median_cl1); %Median der Fehler soll berechnet werden!!
    cl2_diff = abs(homo_fehler2 - median_cl2);
    
    %Ohne Null
    %cl1_diff_n = cl1_diff(cl1_diff(:,1) ~= 0, :);
    %cl2_diff_n = cl2_diff(cl2_diff(:,1) ~= 0, :);
    
    mad_cl1 = median(cl1_diff); %Was wenn Median Null ist??
    mad_cl2 = median(cl2_diff);
    
    m_i_cl1 = abs(cl1_diff./mad_cl1);
    m_i_cl2 = abs(cl2_diff./mad_cl2);
    
    figure('name', 'mi1');
    plot(sortrows(m_i_cl1), 'r');
    figure('name', 'mi2');
    plot(sortrows(m_i_cl2), 'b');
    
    %grenz1 = m_i_cl1(10)
    %grenz2 = m_i_cl2(10)
    
    cluster1_tmp = [cluster1_daten, m_i_cl1]
    cluster2_tmp = [cluster2_daten, m_i_cl2]
    
    %Standardabweichung ist 3.5
    cluster1_ohne = cluster1_tmp(cluster1_tmp(:,7) < schwellwert_mad, 1:3); %vielleicht geht das nicht 
    cluster2_ohne = cluster2_tmp(cluster2_tmp(:,7) < schwellwert_mad, 1:3);
    
    vektoren1_ohne = cluster1_tmp(cluster1_tmp(:,7) < schwellwert_mad, 4:5);
    vektoren2_ohne = cluster2_tmp(cluster2_tmp(:,7) < schwellwert_mad, 4:5);
    
    %Neue Schätzung der Homographie nach Aussortierung...
    %Homographie ohne Ausreißer
    start1_ohne = cluster1_ohne(:, 2:3); 
    start2_ohne = cluster2_ohne(:, 2:3); 

    ziel1_ohne =  start1_ohne + vektoren1_ohne;
    ziel2_ohne =  start2_ohne + vektoren2_ohne;
    
    [homographie_matrix1_ohne, homo_fehler1_ohne] = homographie_cluster(start1_ohne, ziel1_ohne); 
    [homographie_matrix2_ohne, homo_fehler2_ohne] = homographie_cluster(start2_ohne, ziel2_ohne);
    
    homographie_invers1 = inv(homographie_matrix1_ohne)
    homographie_invers2 = inv(homographie_matrix2_ohne)
   
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %Plot der HOMOGRAPHIE FEHLER pro Cluster

        size_f1 = size(homo_fehler1_ohne);
        rows_f1 = size_f1(1);
        rf1 = 1:rows_f1;

        size_f2 = size(homo_fehler2_ohne);
        rows_f2 = size_f2(1);
        rf2 = 1:rows_f2;

        [hf_cluster1_sort, index_hf1] = sortrows(homo_fehler1_ohne);
        [hf_cluster2_sort, index_hf2] = sortrows(homo_fehler2_ohne);

        figure('name', 'Homographie Fehler MAD, Grundlage Schätzung');
        plot(rf1, hf_cluster1_sort, 'r');
        hold on
        %figure('name', 'Homographie Fehler Cluster 2');
        plot(rf2, hf_cluster2_sort, 'b');
        hold off
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Homographie Fehler falscher Werte
    %{
    input_sort = sortrows(input_daten,6);
    start_fuzzy = [];
    
    ff = size(fehler_fuzzy);
    rf = ff(1);
    
    for i=1:rf
        start_fuzzy(i,:) = input_sort(fehler_fuzzy(i,4),:);
    end
    %}
    
    homo_f1_index = [homo_fehler1, cluster1_daten(:,6)];
    homo_f2_index = [homo_fehler2, cluster2_daten(:,6)];
    homo_index = [homo_f1_index; homo_f2_index]
    
    homo_werte_falsch = [];
    
    ff = size(fehler_fuzzy);
    rf = ff(1);
    
    for i=1:rf
        homo_werte_falsch(i,:) = homo_index(homo_index(:,2) == fehler_fuzzy(i,4),:);
    end
    
    fehler_falsch_zugeordnet = homo_werte_falsch
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %Berechnung des Homographie Fehlers der aussortierten Daten nach Schätzung der Homographie der nicht aussortierten Daten
    save1 = cluster1_tmp(cluster1_tmp(:,6) > schwellwert_mad, 1:3);
    save2 = cluster2_tmp(cluster2_tmp(:,6) > schwellwert_mad, 1:3);
    save_daten = [save1; save2];
    
    %safe = size(save_daten)
    
    vektoren1_save = cluster1_tmp(cluster1_tmp(:,6) > schwellwert_mad, 4:5);
    vektoren2_save = cluster2_tmp(cluster2_tmp(:,6) > schwellwert_mad, 4:5);
    save_vektoren = [vektoren1_save; vektoren2_save];
    
    start_save = save_daten(:,2:3);
    ziel_save = start_save + save_vektoren;
    
    size_sort = size(save_daten);
    rows_sort = size_sort(1);
        
        for h = 1:rows_sort
            
            start_pkt = [start_save(h,:), 1]';
            ziel_pkt = [ziel_save(h,:), 1]';
    
            start_inv_1 = homographie_invers1*ziel_pkt;
            start_inv_pkt_1 = start_inv_1(1:2)./start_inv_1(3); %normieren

            start_inv_2 = homographie_invers2*ziel_pkt;
            start_inv_pkt_2 = start_inv_2(1:2)./start_inv_2(3); 

            ziel_inv_1 = homographie_matrix1*start_pkt;
            ziel_inv_pkt_1 = ziel_inv_1(1:2)./ziel_inv_1(3);

            ziel_inv_2 = homographie_matrix2*start_pkt;
            ziel_inv_pkt_2 = ziel_inv_2(1:2)./ziel_inv_2(3);

            s = start_save(h,:)';
            z = ziel_save(h,:)';

            teil1_1(h,:) = (s - start_inv_pkt_1).^2; %richtig?
            teil2_1(h,:) = (z - ziel_inv_pkt_1).^2;
            fehler1 = sqrt(teil1_1 + teil2_1);

            teil1_2(h,:) = (s - start_inv_pkt_2).^2; %richtig?
            teil2_2(h,:) = (z - ziel_inv_pkt_2).^2;
            fehler2 = sqrt(teil1_2 + teil2_2);

        end
        
        hf1 = (fehler1(:,1) + fehler1(:,2))./2;
        hf2 = (fehler2(:,1) + fehler2(:,2))./2;
        
        homo_sort_fehler = [hf1 , hf2];
   
    
    for h = 1:rows_sort
        
        if homo_sort_fehler(h,1) < homo_sort_fehler(h,2)
            input_daten(h,1) = 1;
        else
            input_daten(h,1) = 2;
        end
        
    end
    
    cluster1 = input_daten(input_daten(:,1) == 1, 1:4);
    cluster2 = input_daten(input_daten(:,1) == 2, 1:4);
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %Plot der HOMOGRAPHIE FEHLER pro Cluster

        size_f1 = size(hf1);
        rows_f1 = size_f1(1);
        rf1 = 1:rows_f1;

        size_f2 = size(hf2);
        rows_f2 = size_f2(1);
        rf2 = 1:rows_f2;

        [hf_cluster1_sort, index_hf1] = sortrows(hf1);
        [hf_cluster2_sort, index_hf2] = sortrows(hf2);

        figure('name', 'Homographie Fehler MAD, letztendliche Cluster');
        plot(rf1, hf_cluster1_sort, 'r');
        hold on
        %figure('name', 'Homographie Fehler Cluster 2');
        plot(rf2, hf_cluster2_sort, 'b');
        hold off
   
end

