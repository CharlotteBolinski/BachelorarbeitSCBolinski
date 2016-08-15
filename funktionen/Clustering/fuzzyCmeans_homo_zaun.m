function [ cluster1, cluster2, homo_fehler] = fuzzyCmeans_homo_zaun( cluster_input, vektor_input, numCluster)
    
    %Input Daten Größe
    input_size = size(cluster_input); %input = column Vektor
    rows = input_size(1);
    
    input_daten = [cluster_input, zeros(rows,1)]; %label, cluster_daten 1. Frame == Projektionsdaten 1. Frame, zeros = Fehlerwerte
    vektor_daten = vektor_input; 
    
    %Erste initialisierung Clustering--------------------------------------
    %homo_fehler1 = [zeros(rows,1)]; %label unnötig??
    %homo_fehler2 = [zeros(rows,1)]; %label unnötig??
    
    %gelenk_60_5
    %filter1 = 0.8; 
    %filter2 = 0.5;
    
    %gelenk_40_5_y
    filter1 = 2; 
    filter2 = 2;

    
    homo_fehler1_save = [];
    homo_fehler2_save = [];

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

        %1.Iteration: Alle Werte
        %folgende Iterationen: Fehler und Transformationsschätzung (Matrizen) ohne entnommene Daten
        [homographie_matrix1_tmp, homo_fehler1_init] = homographie_cluster(start1, ziel1); 
        [homographie_matrix2_tmp, homo_fehler2_init] = homographie_cluster(start2, ziel2);

        %AUSREIßER BESIMMEN UND AUSSORTIEREN NACH GUBBS--------------------
        %sortieren
       
        %Median insgesamt
        m1 = median(homo_fehler1_init);
        m2 = median(homo_fehler2_init);
       
        %Median obere und untere Hälfte
        m1_oben = homo_fehler1_init(homo_fehler1_init(:,1) > m1, :);
        m1_unten = homo_fehler1_init(homo_fehler1_init(:,1) < m1, :);
       
        m2_oben = homo_fehler2_init(homo_fehler2_init(:,1) > m2, :);
        m2_unten = homo_fehler2_init(homo_fehler2_init(:,1) < m2, :);
       
        median_m1oben = median(m1_oben);
        median_m1unten = median(m1_unten);
       
        median_m2oben = median(m2_oben);
        median_m2unten = median(m2_unten);
       
        %Interquartilsabstand
        d1 = median_m1oben - median_m1unten;
       
        d2 = median_m2oben - median_m2unten;

        %z1_oben_save = z1_oben;
        %z2_oben_save = z2_oben;

        %Zäune abkängig von den Filtern
        z1_oben = median_m1oben + d1*filter1
        %z1_unten = median_m1unten - d1*filter1
       
        z2_oben = median_m2oben + d2*filter2
        %z2_unten = median_m2unten - d2*filter2
       
        %Aussortieren, speichern in save Matrix----------------------------
        cluster1_daten = [input_daten(input_daten(:,1) == 1, 1:3), homo_fehler1_init]; %Fehler stellt 4. Spalte dar
        cluster2_daten = [input_daten(input_daten(:,1) == 2, 1:3), homo_fehler2_init];  
        
        vektor1_daten = vektor_daten(vektor_daten(:,1) == 1, :);
        vektor2_daten = vektor_daten(vektor_daten(:,1) == 2, :);
        
        size_cl1 = size(cluster1_daten);
        rows_cl1 = size_cl1(1);
        
        size_cl2 = size(cluster2_daten);
        rows_cl2 = size_cl2(1);
        
        for row = 1:rows_cl1  
           %Fehler Cluster 1 prüfen
           if cluster1_daten(row, 4) > z1_oben %andere Werte können durch einen Ausreißer hoch gezogen werden! Ab wann ist es ein Ausreißer??
               cluster1_daten(row, 1) = 3;
               vektor1_daten(row, 1) = 3;
           end
        end
           
        for row = 1:rows_cl2  
           %Fehler Cluster 1 prüfen
           if cluster2_daten(row, 4) > z2_oben %andere Werte können durch einen Ausreißer hoch gezogen werden! Ab wann ist es ein Ausreißer??
               cluster2_daten(row, 1) = 3;
               vektor2_daten(row, 1) = 3;
           end
        end
        
        input_daten = [cluster1_daten ; cluster2_daten]
        vektor_daten = [vektor1_daten; vektor2_daten]
        
        %{
        size_input = size(input_daten);
        rows_input = size_input(1);
        
         for row = 1:rows_input  
           %Fehler Cluster 1 prüfen
           if input_daten(row, 4) > z1_oben %andere Werte können durch einen Ausreißer hoch gezogen werden! Ab wann ist es ein Ausreißer??
               input_daten(row, 1) = 3;
               vektor_daten(row, 1) = 3;
           end

           %Fehler Cluster 2 prüfen
           if input_daten(row, 4) > z2_oben %andere Werte können durch einen Ausreißer hoch gezogen werden! Ab wann ist es ein Ausreißer??
               input_daten(row, 1) = 3;
               vektor_daten(row, 1) = 3;
           end
         end
        %}

         save_daten = input_daten(input_daten(:, 1) == 3, 1:3); %save Daten holen
         save_vektoren = vektor_daten(vektor_daten(:, 1) == 3, 1:3);
         
         input_daten(input_daten(:,1) == 3, :) = []; %save Daten entfernen
         vektor_daten(vektor_daten(:,1) == 3, :) = []; %save Daten entfernen
         
         cluster1_tmp = input_daten(input_daten(:,1) == 1, 1:3);
         cluster2_tmp = input_daten(input_daten(:,1) == 2, 1:3);
         
    %end
   
    %Optimierte Homographie Matrizen und Fehler----------------------------
    start1_optimiert = input_daten(input_daten(:,1) == 1, 2:3)
    start2_optimiert = input_daten(input_daten(:,1) == 2, 2:3) 

    vektoren1_optimiert = vektor_daten(vektor_daten(:,1) == 1, 2:3)
    vektoren2_optimiert = vektor_daten(vektor_daten(:,1) == 2, 2:3)

    ziel1_optimiert =  start1_optimiert + vektoren1_optimiert;
    ziel2_optimiert =  start2_optimiert + vektoren2_optimiert;
        
    [homographie_matrix1, homo_fehler1] = homographie_cluster(start1_optimiert, ziel1_optimiert); 
    [homographie_matrix2, homo_fehler2] = homographie_cluster(start2_optimiert, ziel2_optimiert);
    

    %{
    %Plot der HOMOGRAPHIE FEHLER pro Cluster-------------------------------
        size_f1 = size(homo_fehler1);
        rows_f1 = size_f1(1);
        rf1 = 1:rows_f1;
        
        size_f2 = size(homo_fehler2);
        rows_f2 = size_f2(1);
        rf2 = 1:rows_f2;

        [hf_cluster1_sort, index_hf1] = sortrows(homo_fehler1);
        [hf_cluster2_sort, index_hf2] = sortrows(homo_fehler2);

        figure('name', 'Homographie Fehler direkte Cluster 1+2');
        plot(rf1, hf_cluster1_sort, 'r');
        hold on
        %figure('name', 'Homographie Fehler Cluster 2');
        plot(rf2, hf_cluster2_sort, 'b');
        hold off
%}
    
    %Homographie Fehler und inv Matrizen der optimierten Input_daten
    %fehler1_optimal = homo_fehler1;
    %fehler2_optimal = homo_fehler2;
    size_save = size(save_daten)
    rows_save = size_save(1);
    
    if rows_save <= 4 %mind 4 Punkte für Homographie
        
         cluster1 = cluster1_daten;  %alle Zeilen, wo clustering_daten == 1
         cluster2 = cluster2_daten;
         
         hf = [homo_fehler1; homo_fehler2];
         homo_fehler = [input_daten(:,1), hf];
         
         %Plot der HOMOGRAPHIE FEHLER pro Cluster---------------------------
        %hf_cluster1 = homo_fehler(homo_fehler(:,1) == 1, 2);
        %hf_cluster2 = homo_fehler(homo_fehler(:,1) == 2, 2);
        
        hf_cluster1_sort = sortrows(homo_fehler1);
        hf_cluster2_sort = sortrows(homo_fehler2);
        
        size_f1 = size(hf_cluster1_sort);
        rows_f1 = size_f1(1);
        rf1 = 1:rows_f1;
        
        size_f2 = size(hf_cluster2_sort);
        rows_f2 = size_f2(1);
        rf2 = 1:rows_f2;

        figure('name', 'Homographie Fehler direkte Cluster 1+2');
        plot(rf1, hf_cluster1_sort, 'r');
        hold on
        %figure('name', 'Homographie Fehler Cluster 2');
        plot(rf2, hf_cluster2_sort, 'b');
        hold off
        
        title('Keine Entscheidung Nach Homoraphie-Fehler getroffen!!');
        xlabel('Daten sortiert nach Fehler, ursprünglich');
        ylabel('Abbildungsfehler, ursprünglich');
    %----------------------------------------------------------------------
        
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

            ziel_inv_1 = homographie_matrix1*start_pkt;
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
        fehler1_save = (fehler1(:,1) + fehler1(:,2))./2
        fehler2_save = (fehler2(:,1) + fehler2(:,2))./2
        
        %s_f1 = size(fehler1_save)
        %s_f2 = size(fehler1_save)
         
        %Plot der HOMOGRAPHIE FEHLER pro Cluster---------------------------
        %hf_cluster1 = homo_fehler(homo_fehler(:,1) == 1, 2);
        %hf_cluster2 = homo_fehler(homo_fehler(:,1) == 2, 2);
        
        hf_cluster1_sort = sortrows(fehler1_save);
        hf_cluster2_sort = sortrows(fehler2_save);
        
        size_f1 = size(hf_cluster1_sort);
        rows_f1 = size_f1(1);
        rf1 = 1:rows_f1;
        
        size_f2 = size(hf_cluster2_sort);
        rows_f2 = size_f2(1);
        rf2 = 1:rows_f2;

        figure('name', 'Homographie Fehler direkte Cluster 1+2');
        plot(rf1, hf_cluster1_sort, 'r');
        hold on
        %figure('name', 'Homographie Fehler Cluster 2');
        plot(rf2, hf_cluster2_sort, 'b');
        hold off
        
        title('Abbildungsfehler der aussortierten, gespeicherten Daten');
        xlabel('Daten sortiert nach Fehler');
        ylabel('Abbildungsfehler');
    %----------------------------------------------------------------------
        
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
    %size_tmp = size(cluster1_tmp)
    %size_cl1 = size(save_cluster1)
    %size_add1 = size(save_cluster1) + size(cluster1_tmp)
    
    cluster1 = [cluster1_tmp(:,1:3); save_cluster1];  %alle Zeilen, wo clustering_daten == 1
    cluster2 = [cluster2_tmp(:,1:3); save_cluster2];
    
    cluster_input = [cluster1; cluster2];
    input_daten = [cluster_input, zeros(rows,1)]; %label, cluster_daten 1. Frame == Projektionsdaten 1. Frame, zeros = Fehlerwerte
    
    
    %cl_input = size(cluster_input)
    %v_input = size(vektor_daten)
    %v1 = [vektoren1_optimiert; save_vektoren1]
    %v2 = [vektoren1_optimiert; save_vektoren2]
    %vektor_daten = [v1;v2];

    %homo Fehler der Save Cluster------------------------------------------
    start1_save = save_cluster1(:,2:3); 
    start2_save = save_cluster2(:,2:3); 

    s_start1 = size(start1_save)
    s_start2 = size(start2_save)
    %v_save = size(save_vektoren1)
    
    if s_start1 ~= 0
        ziel1_save =  start1_save + save_vektoren1(:,2:3);
        [homographie_matrix1_save, homo_fehler1_save] = homographie_cluster(start1_save, ziel1_save);
    end
    
    if s_start2 ~= 0
        ziel2_save =  start2_save + save_vektoren2(:,2:3);
        [homographie_matrix2_save, homo_fehler2_save] = homographie_cluster(start2_save, ziel2_save);
    end
    
    %{
    ziel1_save =  start1_save + save_vektoren1(:,2:3);
    ziel2_save =  start2_save + save_vektoren2(:,2:3);
        
    [homographie_matrix1_save, homo_fehler1_save] = homographie_cluster(start1_save, ziel1_save); 
    [homographie_matrix2_save, homo_fehler2_save] = homographie_cluster(start2_save, ziel2_save);
    %}
    
    hf1 = [homo_fehler1; homo_fehler1_save];
    hf2 = [homo_fehler2; homo_fehler2_save];
    
    hf = [hf1; hf2];
    label_alle = input_daten(:,1);
    
    %s_save = size(save_daten)
    %s_input = size(input_daten)
    %s_hf = size(hf)
    
    homo_fehler = [label_alle, hf];
    
    end
    %end
    
    %{
    %Plot der HOMOGRAPHIE FEHLER pro Cluster-------------------------------
        hf_cluster1 = homo_fehler(homo_fehler(:,1) == 1, 2);
        hf_cluster2 = homo_fehler(homo_fehler(:,1) == 2, 2);
        
        hf_cluster1_sort = sortrows(hf_cluster1);
        hf_cluster2_sort = sortrows(hf_cluster2);
        
        size_f1 = size(hf_cluster1);
        rows_f1 = size_f1(1);
        rf1 = 1:rows_f1;
        
        size_f2 = size(hf_cluster2);
        rows_f2 = size_f2(1);
        rf2 = 1:rows_f2;

        figure('name', 'Homographie Fehler direkte Cluster 1+2');
        plot(rf1, hf_cluster1_sort, 'r');
        hold on
        %figure('name', 'Homographie Fehler Cluster 2');
        plot(rf2, hf_cluster2_sort, 'b');
        hold off
        
        title('Homographie Fehler der einzelnen Cluster');
        xlabel('Daten sortiert nach Fehler');
        ylabel('Abbildungsfehler');
    %}
    
end

