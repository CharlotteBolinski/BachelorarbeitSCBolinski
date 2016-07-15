function [ cluster1, cluster2, cluster_zentrum] = fuzzyCmeans_homo( vorclustering_komplett, numCluster)
    
    vektor_daten = [vorclustering_komplett(:,1),vorclustering_komplett(:,5:6)]
    size(vektor_daten)
    
    %projektion_start = [vorclustering_komplett(:,1), vorclustering_komplett(:,9:10)];
    projektion_frames = [vorclustering_komplett(:,1), vorclustering_komplett(:,9:10)];
    
    %Input Daten Größe
    input_size = size(vektor_daten); %input = column Vektor
    rows = input_size(1);

    %Erste initialisierung Clustering--------------------------------------
    cluster_zentrum = zeros(2,2); 
        
    %speichern der Clusterdaten: [label, indices , Abstände zu Cluster 1 , Abstände zu Cluster 2, Homographie Fehler 1, Homographie Fehler 2];
    r = 1:rows;
    parameter = [zeros(rows,1), r', zeros(rows,1) , zeros(rows,1), zeros(rows,1) , zeros(rows,1)];
    homo_fehler = [vorclustering_komplett(:,1), zeros(rows,1) , zeros(rows,1)];
    
    %Erste initialisierung Wahrscheinlichkeiten    
    p_homo = rand(rows, 2); %2=Anzahl Cluster, hier random...
    p_homo_save = zeros(rows,2); %2=Anzahl Cluster

    %fuzzy Parameter/ Gewichtung.. fuzzyness Parameter, Standard 2
    m_homo = 2; 
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %START DES CLUSTERINGS-------------------------------------------------
    %while abs(max(sum(p_homo-p_homo_save))) > 1.5 %Differenz Wahrscheinlichkeiten kleiner als epsilon
    for i = 1:2
        
    p_diff_homo = abs(max(sum(p_homo-p_homo_save)))
    
    %Cluster update berechnen----------------------------------------------
    sum_p1 = sum(p_homo(:,1).^m_homo); %Wahrscheinlichkeiten Cluster 1
    sum_p2 = sum(p_homo(:,2).^m_homo); %Wahrscheinlichkeiten Cluster 2
    
    %Clustering Vektoren
    %zentrum1 = [sum(vektor_daten(:,2).*(p_homo(:,1).^m_homo))/sum_p1 , sum(vektor_daten(:,3).*(p_homo(:,1).^m_homo))/sum_p1];
    %zentrum2 = [sum(vektor_daten(:,2).*(p_homo(:,2).^m_homo))/sum_p2 , sum(vektor_daten(:,3).*(p_homo(:,2).^m_homo))/sum_p2];
    
    %Clustering Positionen
    zentrum1 = [sum(projektion_frames(:,2).*(p_homo(:,1).^m_homo))/sum_p1 , sum(projektion_frames(:,3).*(p_homo(:,1).^m_homo))/sum_p1];
    zentrum2 = [sum(projektion_frames(:,2).*(p_homo(:,2).^m_homo))/sum_p2 , sum(projektion_frames(:,3).*(p_homo(:,2).^m_homo))/sum_p2];
    
    cluster_zentrum = [zentrum1; zentrum2]   
    
    %Homographie-Fehler der Cluster----------------------------------------
    
    %Homographie-Matrizen und Fehler der jeweiligen Cluster einzeln
    %Fehlerwerte nur für direkten Cluster/jedes Cluster einzeln
    start1 = projektion_frames(projektion_frames(:,1) == 1, 2:3);
    start2 = projektion_frames(projektion_frames(:,1) == 2, 2:3);
    
    vektoren1 = vektor_daten(vektor_daten(:,1) == 1, 2:3);
    vektoren2 = vektor_daten(vektor_daten(:,1) == 2, 2:3);
    
    ziel1 = start1 + vektoren1;
    ziel2 = start2 + vektoren2;
    
    [homographie_matrix1, homo_fehler1] = homographie_cluster(start1, ziel1); %fehler wird nicht benötigt
    [homographie_matrix2, homo_fehler2] = homographie_cluster(start2, ziel2);

    %Homographie-Fehler aller Werte gegenüber den jeweiligen
    %Homographie-Matrizen um herauszufinden, welche Abschätzung besser ist
    homographie_invers1 = inv(homographie_matrix1);
    homographie_invers2 = inv(homographie_matrix2);
    
    %start = projektion_start(:,1:2)
    start = projektion_frames(:,1:2)
    
    ziel = start + vektor_daten(:,2:3)
    %ziel = start + vektoren_2D;
    
    for h = 1:rows
        start_pkt = [start(h,:),1]'; %homogene koordinaten des aktuellen Punktes
        ziel_pkt = [ziel(h,:),1]';
        
        teil1_1(h,:) = abs(start_pkt - homographie_invers1*ziel_pkt).^2;
        teil2_1(h,:) = abs(ziel_pkt - homographie_matrix1*start_pkt).^2;
        fehler1 = teil1_1 + teil2_1;
        
        teil1_2(h,:) = abs(start_pkt - homographie_invers2*ziel_pkt).^2;
        teil2_2(h,:) = abs(ziel_pkt - homographie_matrix2*start_pkt).^2;
        fehler2 = teil1_2 + teil2_2;
        
    end

    %Hp-q Homographie-Fehler für jeden Punkt!
    for hf = 1:rows
         homo_fehler(hf,2) = sum(fehler1(hf,:)/3);
         homo_fehler(hf,3) = sum(fehler2(hf,:)/3);
    end
    
    %Daten einem Clusterzuordnen-------------------------------------------
    for row = 1:rows

       %Zuweisen eines Cluster Label
       p_homo1 = (p_homo(row, 1).^m_homo) * homo_fehler(row, 2); %Optimierung Homographie-Fehler, min 0
       p_homo2 = (p_homo(row, 2).^m_homo) * homo_fehler(row, 3);
       
       if p_homo1 < p_homo2
           parameter(row, 1) = 1;
       else
           parameter(row, 1) = 2;
       end
       
    end
    
    %Daten holen und Clusterzentren neu berechnen--------------------------
    %distances(:, 1) == Label
    clustering_daten = [parameter(:, 1), projektion_frames(:,2:3)];
    
    cluster1 = clustering_daten(clustering_daten(:,1) == 1,:); %alle Zeilen, wo clustering_daten == 1
    cluster2 = clustering_daten(clustering_daten(:,1) == 2,:);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %UPDATE CLUSTER-LABEL -- MUSS?!
    vektor_daten(:,1) = parameter(:, 1);
    projektion_frames(:,1) = parameter(:, 1);
    homo_fehler(:,1) = parameter(:, 1);
    
    %Cluster Wahrscheinlichkeit berechnen----------------------------------
    
    ones_p = ones(rows,1);
    %Wahrscheilichkeiten für jeden Punkt und jedes Cluster -- Homographie
    homo_cluster1 = homo_fehler(:,2);
    homo_cluster2 = homo_fehler(:,3);
    
    homo_p1 = ones_p./((homo_cluster1./homo_cluster1).^(2/(m_homo-1)) + (homo_cluster1./homo_cluster2).^(2/(m_homo-1)));
    homo_p2 = ones_p./((homo_cluster2./homo_cluster1).^(2/(m_homo-1)) + (homo_cluster2./homo_cluster2).^(2/(m_homo-1)));
    
    p_homo_save = p_homo;
    p_homo = [homo_p1 homo_p2];

    end
    
end

