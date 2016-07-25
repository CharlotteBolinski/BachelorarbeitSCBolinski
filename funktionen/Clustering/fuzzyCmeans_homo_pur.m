function [ cluster1, cluster2, homo_fehler] = fuzzyCmeans_homo_pur( cluster_input, vektoren, numCluster)
    
    %Input Daten Größe
    input_size = size(cluster_input); %input = column Vektor
    rows = input_size(1);
    
    input_daten = [cluster_input, zeros(rows,1)]; %label, cluster_daten 1. Frame == Projektionsdaten 1. Frame, zeros = Fehlerwerte
    vektor_daten = [cluster_input(:,1), vektoren]; %label unnötig??
    
    %Erste initialisierung Clustering--------------------------------------
    %speichern der Clusterdaten: [label, Fehler Homographie zu Cluster 1 , Fehler Homographie zu Cluster 2];
    homo_fehler = [zeros(rows,1), zeros(rows,1) , zeros(rows,1)]; %label unnötig??
    
    filter1 = 5;
    filter2 = 5;
    
    z1_oben = 1;
    z2_oben = 1;
    z1_oben_save = 0;
    z2_oben_save = 0;
   

    %START DES CLUSTERINGS-------------------------------------------------
    %so lange, bis sich das Clusterzentrum nicht mehr ändert...
    %...keine Datenpunkte mehr dazu kommen und daher keien Neuberechnung
    while filter1 && filter2 > 1 %Differenz Wahrscheinlichkeiten kleiner als epsilon
    %for i = 1:300
    
    %fehler_diff =     
        
        %Homographie Schätzung einzelne Cluster-------------------------------- 
        start1 = input_daten(input_daten(:,1) == 1, 2:3); %Cluster1 Daten
        start2 = input_daten(input_daten(:,1) == 2, 2:3); %Cluster2 Daten

        vektoren1 = vektor_daten(vektor_daten(:,1) == 1, 2:3);
        vektoren2 = vektor_daten(vektor_daten(:,1) == 2, 2:3);

        ziel1 =  start1 + vektoren1;
        ziel2 =  start2 + vektoren2;

        [homographie_matrix1, homo_fehler1] = homographie_cluster(start1, ziel1); 
        [homographie_matrix2, homo_fehler2] = homographie_cluster(start2, ziel2);

        cluster1_daten = [input_daten(input_daten(:,1) == 1, 1:3), homo_fehler1];
        cluster2_daten = [input_daten(input_daten(:,1) == 2, 1:3), homo_fehler2];        

        input_daten = [cluster1_daten; cluster2_daten];


        %Plot der HOMOGRAPHIE FEHLER pro Cluster
        %{
        size_f1 = size(homo_fehler1);
        rows_f1 = size_f1(1);
        rf1 = 1:rows_f1;

        size_f2 = size(homo_fehler2);
        rows_f2 = size_f2(1);
        rf2 = 1:rows_f2;

        figure('name', 'Homographie Fehler direkte Cluster 1+2');
        plot(rf1, homo_fehler1, 'r');
        hold on
        %figure('name', 'Homographie Fehler Cluster 2');
        plot(rf2, homo_fehler2, 'b');
        hold off
        %}

    
    %Homographie Fehler alle Cluster---------------------------------------
    
        homographie_invers1 = inv(homographie_matrix1);
        homographie_invers2 = inv(homographie_matrix2);

        %anstatt 20 = Werte pro Block, damit dynamisch
        start = input_daten(:,2:3);
        ziel = start+vektoren;

        for h = 1:rows

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
    
        %Fehler nach Verbesserung der Cluster
        homo_fehler(:,2) = (fehler1(:,1) + fehler1(:,2))./2; %FÜR ALLE
        homo_fehler(:,3) = (fehler2(:,1) + fehler2(:,2))./2;

        %Zuweisen eines Cluster Label------------------------------------------
    
        %AUSREIßER BESIMMEN UND AUSSORTIEREN NACH GUBBS---------------------
        %sortieren
        fehler1 = homo_fehler1; %Optimierung der Fehler der einzelnen Cluster
        fehler2 = homo_fehler2;
       
        %Median insgesamt
        m1 = median(fehler1);
        m2 = median(fehler2);
       
        %Median obere und untere Hälfte
        m1_oben = fehler1(fehler1(:,1) > m1, :);
        m1_unten = fehler1(fehler1(:,1) < m1, :);
       
        m2_oben = fehler2(fehler2(:,1) > m2, :);
        m2_unten = fehler2(fehler2(:,1) < m2, :);
       
        median_m1oben = median(m1_oben);
        median_m1unten = median(m1_unten);
       
        median_m2oben = median(m2_oben);
        median_m2unten = median(m2_unten);
       
        %Interquartilsabstand
        d1 = median_m1oben - median_m1unten;
       
        d2 = median_m2oben - median_m2unten;
       
        %Innere Zäune
        %{
        z1_obeni = median_m1oben + d1*1.5
        z1_unteni = median_m1unten - d1*1.5
       
        z2_obeni = median_m2oben + d2*1.5
        z2_unteni = median_m2unten - d2*1.5
        %}
       
        z1_oben_save = z1_oben;
        z2_oben_save = z2_oben;

        %äußere Zäune
        z1_oben = median_m1oben + d1*filter1
        %z1_unten = median_m1unten - d1*3
       
        z2_oben = median_m2oben + d2*filter2
        %z2_unten = median_m2unten - d2*3
       

         %Anders als initiale Clustereinteilung! 
         for row = 1:rows   
           %Für Cluster 1
           if input_daten(row, 4) > z1_oben %andere Werte können durch einen Ausreißer hoch gezogen werden! Ab wann ist es ein Ausreißer??
               input_daten(row, 1) = 2;
           end

           %Für Cluster 2
           if input_daten(row, 4) > z2_oben %andere Werte können durch einen Ausreißer hoch gezogen werden! Ab wann ist es ein Ausreißer??
               input_daten(row, 1) = 1;
           end

         end
    
        %homof = homo_fehler
        %input_daten(:,1) = homo_fehler(:, 1);
        homo_fehler(:, 1) = input_daten(:, 1); 
        vektor_daten(:,1) = input_daten(:, 1); 

        %Bedingung, dass der Fehler durchschnittlich größer als bestimmter
        %Wert

        %Wenn sich z1_oben nicht mehr ändert, f anpassen
        %wenn sich z2_oben nicht ändert, dann auch!
        %unterschiedliche Anpassung?
        if z1_oben == z1_oben_save && filter1>1
            filter1 = filter1- 0.05;
        end

        if z2_oben == z2_oben_save && filter2>1
            filter2 = filter2- 0.05;
        end
    
    
    end
    
    clustering_daten = input_daten; %Ausgangsdaten (Vektoren) mit index
    
    cluster1 = clustering_daten(clustering_daten(:,1) == 1, :); %alle Zeilen, wo clustering_daten == 1
    cluster2 = clustering_daten(clustering_daten(:,1) == 2, :);
    
end

