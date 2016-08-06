function [ cluster1, cluster2, homo_sort_fehler] = fuzzyCmeans_homo_sort( cluster_input, vektoren, numCluster)
    
    %Input Daten Größe
    input_size = size(cluster_input); %input = column Vektor
    rows = input_size(1);
    
    input_daten = [cluster_input, zeros(rows,1)]; %label, cluster_daten 1. Frame == Projektionsdaten 1. Frame, zeros = Fehlerwerte
    vektor_daten = [cluster_input(:,1), vektoren]; %label unnötig??
    
    %Speichert die Daten mit hohem Homographie Fehler   
        
    %Speichert die Daten mit hohem Homographie Fehler
    save_daten = [zeros(rows,1), zeros(rows,1), zeros(rows,1)];
    save_vektoren = [zeros(rows,1), zeros(rows,1), zeros(rows,1)];
    save_index = 1;
    
    homo_fehler1 = 100; %wachsen pro Cluster
    homo_fehler2 = 100;    
        
    while max(homo_fehler1)>0.05 && max(homo_fehler1)>0.05%Differenz Wahrscheinlichkeiten kleiner als epsilon
    %maybe 0.06
    %for i = 1:20
    
    %fehler_diff =     
        
        %Homographie Schätzung einzelne Cluster-------------------------------- 
        start1 = input_daten(input_daten(:,1) == 1, 2:3); %Cluster1 Daten
        start2 = input_daten(input_daten(:,1) == 2, 2:3); %Cluster2 Daten

        vektoren1 = vektor_daten(vektor_daten(:,1) == 1, 2:3);
        vektoren2 = vektor_daten(vektor_daten(:,1) == 2, 2:3);

        ziel1 =  start1 + vektoren1;
        ziel2 =  start2 + vektoren2;
        
        %neue Fehlerberechnung ohne Werte, die vorher entfernt wurden
        [homographie_matrix1, homo_fehler1] = homographie_cluster(start1, ziel1); 
        [homographie_matrix2, homo_fehler2] = homographie_cluster(start2, ziel2);

        cluster1_daten_tmp = [input_daten(input_daten(:,1) == 1, 1:3), homo_fehler1];
        cluster2_daten_tmp = [input_daten(input_daten(:,1) == 2, 1:3), homo_fehler2];       

        %Wenn mean Fehler größer als 0 oder geg. Wert
        %if max(homo_fehler1)>0.1e-8 && max(homo_fehler1)>0.1e-8
            
        %Finden und speichern der Daten mit hohem Homographie Fehler
        [max_fehler1, index1] = max(homo_fehler1);
        [max_fehler2, index2] = max(homo_fehler2);

        %Speichern der Daten, die aussortiert wurden/Maximalen Fehler haben
        save_daten(save_index,:) = cluster1_daten_tmp(index1, 1:3); 
        save_daten(save_index+1,:) = cluster2_daten_tmp(index2, 1:3);
            
        %Entfernen der Daten mit hohem Homographie Fehler
        %Löschen einer Zeile: A(i,:)=[] oder a = a(a~="BELIEBIGES ELEMENT")
        cluster1_daten = cluster1_daten_tmp(cluster1_daten_tmp(:,4) ~= max_fehler1, :);
        cluster2_daten = cluster2_daten_tmp(cluster2_daten_tmp(:,4) ~= max_fehler2, :);
        
        %Input neu definieren mit entfernten Werten die hohen Fehler hatten
        input_daten = [cluster1_daten; cluster2_daten];

        %Vektordaten anpassen, Werte mit hohem Fehler an max Index löschen
        save_vektoren(save_index,2:3) = vektoren1(index1, :); %Speichern der Vektoren, die aussortiert wurden
        save_vektoren(save_index+1,2:3) = vektoren2(index2, :);
        
        vektoren1(index1, :) = [];
        vektoren2(index2, :) = [];
        vektor_daten_tmp = [vektoren1; vektoren2]; %geht das immer gut?
        vektor_daten = [input_daten(:,1), vektor_daten_tmp];
        
        %Zwei Datensätzen wurden hinzugefügt
        save_index = save_index+2;
        
    end
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %Plot der HOMOGRAPHIE FEHLER pro Cluster, Zwischenergebnis
        size_f1 = size(homo_fehler1);
        rows_f1 = size_f1(1);
        rf1 = 1:rows_f1;

        size_f2 = size(homo_fehler2);
        rows_f2 = size_f2(1);
        rf2 = 1:rows_f2;

        [hf_cluster1_sort, index_hf1] = sortrows(homo_fehler1);
        [hf_cluster2_sort, index_hf2] = sortrows(homo_fehler2);

        figure('name', 'Homographie Fehler, Zwischenergebnis nach Aussorieren');
        plot(rf1, hf_cluster1_sort, 'r');
        hold on
        %figure('name', 'Homographie Fehler Cluster 2');
        plot(rf2, hf_cluster2_sort, 'b');
        hold off
        
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
    %Berechnung des Homographie Fehlers der aussortierten Daten-------
    %Gegenüber den beiden Clustern
        
    %Minimum wird hinzugefügt und wenn der Fehler der Homographie
    %gleich bleibt oder besser wird wird mit den restlichen der save
    %Daten mit der neuen Schätzung gleich verfahren, bis keine save
    %Daten mehr übrig sind.
    
    
    if max_fehler1>0 && max_fehler1>0
        
    %Nullen löschen
    save_daten = save_daten(save_daten(:,2) ~= 0, :); %Bedingung so ändern, dass beide Werte null sein müssen
    save_vektoren = save_vektoren(save_vektoren(:,2) ~= 0, :);
        
    %while bis keine Punkte in save mehr sind
    for outer = 1:3
        
    size_save = size(save_daten)
    rows_save = size_save(1);
     
    for inner = 1:rows_save  
        
        %Fehler der aussorierten Daten:
        homographie_invers1 = inv(homographie_matrix1);
        homographie_invers2 = inv(homographie_matrix2);

        start = save_daten(:,2:3);
        ziel = start+save_vektoren(:,2:3);
        
        size_sort = size(save_daten);
        rows_sort = size_sort(1);
        
        for h = 1:rows_sort
            
            start_pkt = [start(h,:), 1]';
            ziel_pkt = [ziel(h,:), 1]';
    
            start_inv_1 = homographie_invers1*ziel_pkt;
            start_inv_pkt_1 = start_inv_1(1:2)./start_inv_1(3); %normieren

            start_inv_2 = homographie_invers2*ziel_pkt;
            start_inv_pkt_2 = start_inv_2(1:2)./start_inv_2(3); 

            ziel_inv_1 = homographie_matrix1*start_pkt;
            ziel_inv_pkt_1 = ziel_inv_1(1:2)./ziel_inv_1(3);

            ziel_inv_2 = homographie_matrix2*start_pkt;
            ziel_inv_pkt_2 = ziel_inv_2(1:2)./ziel_inv_2(3);

            s = start(h,:)';
            z = ziel(h,:)';

            teil1_1 = (s - start_inv_pkt_1).^2; %richtig?
            teil2_1 = (z - ziel_inv_pkt_1).^2;
            fehler1 = sqrt(teil1_1 + teil2_1);

            teil1_2 = (s - start_inv_pkt_2).^2; %richtig?
            teil2_2 = (z - ziel_inv_pkt_2).^2;
            fehler2 = sqrt(teil1_2 + teil2_2);
            
            hf1(h) = (fehler1(1) + fehler1(2))./2
            hf2(h) = (fehler2(1) + fehler2(2))./2
        
        end
        
        %hf1 = (fehler1(1) + fehler1(2))./2;
        %hf2 = (fehler2(1) + fehler2(2))./2;
        
        
        homo_sort_fehler = [hf1 , hf2];
        shs = size(homo_sort_fehler)
        
        hf1_s = size(hf1)
        hf2_s = size(hf2)
        
        save_vektoren(1,:) = [];
        save_daten(1,:) = [];
        
        
        %{
        [min_sort, index_min] = min(homo_sort_fehler);
        min1 = index_min(1)
        min2 = index_min(2);
        
        [min_sort1, index_min1] = min(hf1);
        min11 = index_min1(1)

        [min_sort1, index_min2] = min(hf2);
        min12 = index_min2(1)
        
        
        hs = size(homo_sort_fehler)
        sd = size(save_daten)
      
        cluster1_besser_tmp = [cluster1_daten(:,1:3); save_daten(min11, :)];
        cluster2_besser_tmp = [cluster2_daten(:,1:3); save_daten(min12, :)];

        vektoren1_besser_tmp = [vektoren1; save_vektoren(min11, 2:3)];
        vektoren2_besser_tmp = [vektoren2; save_vektoren(min12, 2:3)];
        
        start1_besser = cluster1_besser_tmp(:,2:3);
        ziel1_besser = start1_besser + vektoren1_besser_tmp;
        
        start2_besser = cluster2_besser_tmp(:,2:3);
        ziel2_besser = start2_besser + vektoren2_besser_tmp;
        
        [homographie_matrix1_besser, homo_fehler1_besser] = homographie_cluster(start1_besser, ziel1_besser); 
        [homographie_matrix2_besser, homo_fehler2_besser] = homographie_cluster(start2_besser, ziel2_besser);
        
        %Wenn Fehler im Durchschnitt kleiner wird oder gleich bleibt dem
        %Cluster den Wert hinzufügen und aus save Daten lösen, wenn nicht,
        %dann nix tun
        if mean(homo_fehler1_besser) <= mean(hf1)
            
            cluster1_daten = cluster1_besser_tmp;
            vektoren1 = vektoren1_besser_tmp;

            save_vektoren(min1,:) = [];
            save_daten(min1,:) = [];
            
            min1 = min1-1;
            min2 = min2-1;
            
            min11 = min1-1;
            min12 = min2-1;
            
        end
        
        if mean(homo_fehler2_besser) <= mean(hf2)
            
            cluster2_daten = cluster2_besser_tmp;
            vektoren2 = vektoren2_besser_tmp;

            save_vektoren(min2,:) = []; %Verschiebung um 1 durch Löschen eines Index davor
            save_daten(min2,:) = [];
            
            min1 = min1-1;
            min2 = min2-1;
            
            min11 = min1-1;
            min12 = min2-1;
            
        end
        %}
        

    
    end
    end
        
    
    
end


        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %Plot der HOMOGRAPHIE FEHLER pro Cluster
%{
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
end

