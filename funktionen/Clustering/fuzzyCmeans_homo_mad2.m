function [ cluster1, cluster2, homo_fehler] = fuzzyCmeans_homo_zaun2( cluster_input, vektoren, numCluster)
    
    %Input Daten Größe
    input_size = size(cluster_input); %input = column Vektor
    rows = input_size(1);
    
    input_daten = [cluster_input, zeros(rows,1)]; %label, cluster_daten 1. Frame == Projektionsdaten 1. Frame, zeros = Fehlerwerte
    vektor_daten = [cluster_input(:,1), vektoren]; %label unnötig??
    
    %Erste initialisierung Clustering--------------------------------------
    %homo_fehler1 = [zeros(rows,1)]; %label unnötig??
    %homo_fehler2 = [zeros(rows,1)]; %label unnötig??
    
    filter1 = 0.0;
    filter2 = 0.0;

    %START DES CLUSTERINGS-------------------------------------------------
    %so lange, bis sich das Clusterzentrum nicht mehr ändert...
    %...keine Datenpunkte mehr dazu kommen und daher keien Neuberechnung
    %while filter1 > 1 && filter2 > 1 && ~isnan(z1_oben) && ~isnan(z2_oben)%Differenz Wahrscheinlichkeiten kleiner als epsilon
    %for i = 1:2
        
        %Homographie Schätzung, wie die Input Daten übergeben werden-------------------------------- 
        start1 = input_daten(input_daten(:,1) == 1, 2:3); %Cluster1 Daten
        start2 = input_daten(input_daten(:,1) == 2, 2:3); %Cluster2 Daten

        vektoren1 = vektor_daten(vektor_daten(:,1) == 1, 2:3);
        vektoren2 = vektor_daten(vektor_daten(:,1) == 2, 2:3);

        ziel1 =  start1 + vektoren1;
        ziel2 =  start2 + vektoren2;

        [homographie_matrix1_tmp, homo_fehler1_init] = homographie_cluster(start1, ziel1); 
        [homographie_matrix2_tmp, homo_fehler2_init] = homographie_cluster(start2, ziel2);

        cluster1_daten = [input_daten(input_daten(:,1) == 1, 1:3), homo_fehler1_init]; %Fehler stellt 4. Spalte dar
        cluster2_daten = [input_daten(input_daten(:,1) == 2, 1:3), homo_fehler2_init];  
        
        input_daten = [cluster1_daten ; cluster2_daten];
        
        %AUSREIßER BESIMMEN UND AUSSORTIEREN NACH GUBBS--------------------
        %sortieren
       
        %Median der Homographie Fehler
        median_cl1 = median(homo_fehler1_init);
        median_cl2 = median(homo_fehler2_init);
    
        cl1_diff = homo_fehler1_init - median_cl1; %Median der Fehler soll berechnet werden!!
        cl2_diff = homo_fehler2_init - median_cl2;
    
        %Ohne Null
        cl1_diff_n = cl1_diff(cl1_diff(:,1) ~= 0, :);
        cl2_diff_n = cl2_diff(cl2_diff(:,1) ~= 0, :);
    
        mad_cl1 = median(cl1_diff_n); %Was wenn Median Null ist??
        mad_cl2 = median(cl2_diff_n);
    
        m_i_cl1 = abs(cl1_diff./mad_cl1)
        m_i_cl2 = abs(cl2_diff./mad_cl2)
    
        m_i_cl = [m_i_cl1; m_i_cl2];
       
        %Aussortieren, speichern in save Matrix----------------------------
        size_input = size(input_daten);
        rows_input = size_input(1);
        
         for row = 1:rows_input  
           %Fehler Cluster 1 prüfen
           if m_i_cl(row,1) > 100 %andere Werte können durch einen Ausreißer hoch gezogen werden! Ab wann ist es ein Ausreißer??
               input_daten(row, 1) = 3;
               vektor_daten(row, 1) = 3;
           end

           %Fehler Cluster 2 prüfen
           if m_i_cl(row,1) > 100 %andere Werte können durch einen Ausreißer hoch gezogen werden! Ab wann ist es ein Ausreißer??
               input_daten(row, 1) = 3;
               vektor_daten(row, 1) = 3;
           end
         end
    
         show_input = input_daten
         
         save_daten = input_daten(input_daten(:, 1) == 3, 1:3); %save Daten holen
         save_vektoren = vektor_daten(vektor_daten(:, 1) == 3, 1:3);
         
         
         size_safe = size(save_daten);
         
         input_daten(input_daten(:,1) == 3, :) = []; %save Daten entfernen
         vektor_daten(vektor_daten(:,1) == 3, :) = []; %save Daten entfernen
         
         cluster1_tmp = input_daten(input_daten(:,1) == 1, 1:3);
         cluster2_tmp = input_daten(input_daten(:,1) == 2, 1:3);
         
    %end
   
    %Optimierte Homographie Matrizen und Fehler----------------------------
    start1_optimiert = input_daten(input_daten(:,1) == 1, 2:3); 
    start2_optimiert = input_daten(input_daten(:,1) == 2, 2:3); 

    vektoren1_optimiert = vektor_daten(vektor_daten(:,1) == 1, 2:3);
    vektoren2_optimiert = vektor_daten(vektor_daten(:,1) == 2, 2:3);

    ziel1_optimiert =  start1_optimiert + vektoren1_optimiert;
    ziel2_optimiert =  start2_optimiert + vektoren2_optimiert;
        
    [homographie_matrix1, homo_fehler1] = homographie_cluster(start1_optimiert, ziel1_optimiert); 
    [homographie_matrix2, homo_fehler2] = homographie_cluster(start2_optimiert, ziel2_optimiert);
    

    %Homographie Fehler und inv Matrizen der optimierten Input_daten
    %fehler1_optimal = homo_fehler1;
    %fehler2_optimal = homo_fehler2;
    size_save = size(save_daten)
    rows_save = size_save(1);
    
    if rows_save <= 0
        
         cluster1 = cluster1_tmp;  %alle Zeilen, wo clustering_daten == 1
         cluster2 = cluster2_tmp;
         
         hf = [homo_fehler1; homo_fehler2];
         homo_fehler = [input_daten(:,1), hf]
        
    else
        
    homographie_invers1 = inv(homographie_matrix1);
    homographie_invers2 = inv(homographie_matrix2);
    
    %Berechnung der Feher für alle Save Daten, die neu zugeordnet werden sollen

        
        start = save_daten(:,2:3);
        ziel = start+save_vektoren(:,2:3);
        
        for h = 1:rows_save

            start_pkt = [start(h,:), 1]';
            ziel_pkt = [ziel(h,:), 1]';
    
            start_inv_1 = homographie_invers1*ziel_pkt;
            start_inv_pkt_1 = start_inv_1(1:2)./start_inv_1(3);

            start_inv_2 = homographie_invers2*ziel_pkt;
            start_inv_pkt_2 = start_inv_2(1:2)./start_inv_2(3);

            ziel_inv_1 = homographie_matrix1_tmp*start_pkt;
            ziel_inv_pkt_1 = ziel_inv_1(1:2)./ziel_inv_1(3);

            ziel_inv_2 = homographie_matrix2*start_pkt;
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
    
        %Fehler der optimierten Schätzungen der Transformationen
        fehler1_save = (fehler1(:,1) + fehler1(:,2))./2; 
        fehler2_save = (fehler2(:,1) + fehler2(:,2))./2;
         
        
    %Zuordnung von Clusterlabeln für die save_daten 
    for row = 1:rows_save 
        
       if fehler1_save(row, 1) > fehler2_save(row, 1) %andere Werte können durch einen Ausreißer hoch gezogen werden! Ab wann ist es ein Ausreißer??
           save_daten(row, 1) = 2;
           save_vektoren(row, 1) = 2;
       else
           save_daten(row, 1) = 1;
           save_vektoren(row, 1) = 1;
       end
       
    end
    
    save_cluster1 = save_daten(save_daten(:,1) == 1, :);
    save_cluster2 = save_daten(save_daten(:,1) == 2, :);
    
    save_vektoren1 = save_vektoren(save_vektoren(:,1) == 1, :);
    save_vektoren2 = save_vektoren(save_vektoren(:,1) == 2, :);
    
    %s_save = size(save_cluster1) + size(save_cluster2)
    %s_daten = size(cluster1_tmp) + size(cluster2_tmp)
    
    %Neue Cluster durch hinzufügen der save Daten
    cluster1 = [cluster1_tmp(:,1:3); save_cluster1];  %alle Zeilen, wo clustering_daten == 1
    cluster2 = [cluster2_tmp(:,1:3); save_cluster2];
   
    %homo Fehler der Save Cluster------------------------------------------
    start1_save = save_cluster1(:,2:3); 
    start2_save = save_cluster2(:,2:3); 

    %s_start = size(start1_save)
    %v_save = size(save_vektoren1)
    
    ziel1_save =  start1_save + save_vektoren1(:,2:3);
    ziel2_save =  start2_save + save_vektoren2(:,2:3);
        
    [homographie_matrix1_save, homo_fehler1_save] = homographie_cluster(start1_save, ziel1_save); 
    [homographie_matrix2_save, homo_fehler2_save] = homographie_cluster(start2_save, ziel2_save);
    
    hf1 = [homo_fehler1; homo_fehler1_save];
    hf2 = [homo_fehler2; homo_fehler2_save];
    
    hf = [hf1; hf2];
    label_alle = [input_daten(:,1); save_daten(:,1)];
    
    %s_input = size(label_alle)
    %s_hf = size(hf)
    
    homo_fehler = [label_alle, hf];
    
    end

    
%{
    %Plot der HOMOGRAPHIE FEHLER pro Cluster-------------------------------
        size_f = size(homo_fehler);
        rows_f = size_f(1);
        rf = 1:rows_f;

        [hf_cluster1_sort, index_hf1] = sortrows(homo_fehler(:,1));
        [hf_cluster2_sort, index_hf2] = sortrows(homo_fehler(:,2));

        figure('name', 'Homographie Fehler direkte Cluster 1+2');
        plot(rf, hf_cluster1_sort, 'r');
        hold on
        %figure('name', 'Homographie Fehler Cluster 2');
        plot(rf, hf_cluster2_sort, 'b');
        hold off
%}
    
end

