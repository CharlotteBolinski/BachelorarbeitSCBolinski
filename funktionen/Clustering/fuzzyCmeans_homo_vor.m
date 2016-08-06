function [ cluster1, cluster2, homo_fehler] = fuzzyCmeans_homo_vor( p_fuzzy, cluster_input, vektoren, numCluster)
    
    %Input Daten Größe
    input_size = size(cluster_input); %input = column Vektor
    rows = input_size(1);
    
    input_daten = [cluster_input, zeros(rows,1), zeros(rows,1)]; %label, cluster_daten 1. Frame == Projektionsdaten 1. Frame, zeros = Fehlerwerte Homographie, index
    vektor_daten = [cluster_input(:,1), vektoren]; %label unnötig??
    
    grenzwert_p = 0.999;
    
    %Die Besten Mitglieder der jeweiligen Cluster holen--------------------
    %Aus Vorclustering, über die Wahrscheinlichkeit
    [p_fuzzy_sort, index_sort_fuzzy] = sortrows(p_fuzzy,1);
    p_fuzzy_sort_index = [index_sort_fuzzy, p_fuzzy_sort];

    %Alle Werte mit den besten Wahrscheinlichkeiten
    cluster1_best_p = p_fuzzy_sort_index(p_fuzzy_sort_index(:,2) >= grenzwert_p, :); %0.99 gibt mehr Daten
    cluster2_best_p = p_fuzzy_sort_index(p_fuzzy_sort_index(:,3) >= grenzwert_p, :);
    
    %einsen und zweien hinzufügen
    s_cl1 = size(cluster1_best_p);
    r_cl1 = s_cl1(1);
    eins = ones(r_cl1,1);
    
    s_cl2 = size(cluster2_best_p);
    r_cl2 = s_cl2(1);
    zwei = ones(r_cl2,1).*2;
    
    cluster1_best = input_daten(cluster1_best_p(:,1), :);
    cluster2_best = input_daten(cluster2_best_p(:,1), :);
    
    cluster1_best(:,1) = eins;
    cluster2_best(:,1) = zwei;
    
    %Indizes der aussortierten Cluster------------------------------------- 
    cluster1_best(:, 5) = cluster1_best_p(:,1);
    cluster2_best(:, 5) = cluster2_best_p(:,1);
    
    %Homographie der ermittelten Werte berechnen---------------------------
    start1_best =  cluster1_best(:,2:3);
    start2_best =  cluster2_best(:,2:3);
    
    vektoren1_best = vektor_daten(cluster1_best(:,5), 2:3)
    vektoren2_best = vektor_daten(cluster2_best(:,5), 2:3)
    
    ziel1_best = start1_best + vektoren1_best;
    ziel2_best = start2_best + vektoren2_best;
    
    [homographie_matrix1_best, homo_fehler1_best] = homographie_cluster(start1_best, ziel1_best); 
    [homographie_matrix2_best, homo_fehler2_best] = homographie_cluster(start2_best, ziel2_best);
    
    cluster1_best(:, 4) = homo_fehler1_best
    cluster2_best(:, 4) = homo_fehler2_best
   
    %Plot der HOMOGRAPHIE FEHLER pro Cluster-------------------------------
    %{
        size_f1 = size(homo_fehler1_best);
        rows_f1 = size_f1(1);
        rf1 = 1:rows_f1;
        
        size_f2 = size(homo_fehler2_best);
        rows_f2 = size_f2(1);
        rf2 = 1:rows_f2;

        hf_cluster1_sort = sortrows(homo_fehler1_best);
        hf_cluster2_sort = sortrows(homo_fehler2_best);

        figure('name', 'Homographie Fehler aus Vorclustering');
        plot(rf1, hf_cluster1_sort, 'r');
        hold on
        %figure('name', 'Homographie Fehler Cluster 2');
        plot(rf2, hf_cluster2_sort, 'b');
        hold off
    %}
    
    %Homographie Fehler der verblibenen Werte------------------------------
    start1_rest = input_daten(p_fuzzy_sort_index(:,2) < grenzwert_p, 2:3);
    start2_rest = input_daten(p_fuzzy_sort_index(:,3) < grenzwert_p, 2:3);
    start = [start1_rest; start2_rest];

    vektoren1_rest = vektor_daten(p_fuzzy_sort_index(:,2) < grenzwert_p, 2:3);
    vektoren2_rest = vektor_daten(p_fuzzy_sort_index(:,3) < grenzwert_p, 2:3);
    
    ziel1_rest = start1_rest + vektoren1_rest;
    ziel2_rest = start2_rest + vektoren2_rest;
    ziel = [ziel1_rest; ziel2_rest];

    %Indizes der restlichen Werte------------------------------------------
    cluster1_rest_index = p_fuzzy_sort_index(p_fuzzy_sort_index(:,2) < grenzwert_p, 1); %0.99 gibt mehr Daten
    cluster2_rest_index = p_fuzzy_sort_index(p_fuzzy_sort_index(:,3) < grenzwert_p, 1);
    index_rest = [cluster1_rest_index; cluster2_rest_index];
    
    %Abbildungsfehler mit Schätzung des Vorclusterings berechnen-----------
    homographie_invers1 = inv(homographie_matrix1_best);
    homographie_invers2 = inv(homographie_matrix2_best);
    
    size_s = size(start);
    rows_s = size_s(1);
    
     for h = 1:rows_s

            start_pkt = [start(h,:), 1]';
            ziel_pkt = [ziel(h,:), 1]';
    
            start_inv_1 = homographie_invers1*ziel_pkt;
            start_inv_pkt_1 = start_inv_1(1:2)./start_inv_1(3);

            start_inv_2 = homographie_invers2*ziel_pkt;
            start_inv_pkt_2 = start_inv_2(1:2)./start_inv_2(3);

            ziel_inv_1 = homographie_matrix1_best*start_pkt;
            ziel_inv_pkt_1 = ziel_inv_1(1:2)./ziel_inv_1(3);

            ziel_inv_2 = homographie_matrix2_best*start_pkt;
            ziel_inv_pkt_2 = ziel_inv_2(1:2)./ziel_inv_2(3);

            s = start(h,:)';
            z = ziel(h,:)';

            teil1_1(h,:) = (s - start_inv_pkt_1).^2; %richtig?
            teil2_1(h,:) = (z - ziel_inv_pkt_1).^2;
            fehler1 = sqrt(teil1_1 + teil2_1);

            teil1_2(h,:) = (s - start_inv_pkt_2).^2; %richtig?
            teil2_2(h,:) = (z - ziel_inv_pkt_2).^2;
            fehler2 = sqrt(teil1_2 + teil2_2);

     end
    
     fehler1_rest = (fehler1(:,1) + fehler1(:,2))./2; %Fehler gegenüber Schätzung für Cluster1
     fehler2_rest = (fehler2(:,1) + fehler2(:,2))./2; %Fehler gegenüber Schätzung für Cluster2
     
     fehler_rest = [fehler1_rest, fehler2_rest];

     fehler_mit_index = [index_rest, fehler_rest]
     
    %Zurdnung in neue Cluster----------------------------------------------
    for h = 1:rows_s
        
        input_index = fehler_mit_index(h,1);
        
        if fehler_mit_index(h,2) < fehler_mit_index(h,3)
           
            input_daten(input_index,1) = 1;
            input_daten(input_index,4) = fehler_mit_index(h,2);
            input_daten(input_index,5) = input_index;

        else

            input_daten(input_index,1) = 2;
            input_daten(input_index,4) = fehler_mit_index(h,3);
            input_daten(input_index,5) = input_index;
            
        end
              
    end
    
    cluster1_rest = input_daten(input_daten(:,1) == 1, :);
    cluster2_rest = input_daten(input_daten(:,1) == 2, :);
    
    %show_input = input_daten
    %show_cluster1_best = cluster1_best
    %show_cluster2_best = cluster2_best
    %show_cluster1_rest = cluster1_rest
    %show_cluster2_rest = cluster2_rest
    
    
    %Zusammensetzen der Gesamten Cluster-----------------------------------

    cluster1 = [cluster1_best; cluster1_rest]
    cluster2 = [cluster2_best; cluster2_rest]  
    
    %best_fehler = [cluster1_best(:, 4) , cluster2_best(:, 4)];
    %homo_fehler = [best_fehler ; fehler_rest];
    homo_fehler = zeros(2,2);
  
end

