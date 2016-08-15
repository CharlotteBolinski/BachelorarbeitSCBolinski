function [ cluster1, cluster2, cluster_zentrum, p_homo, p_abstand] = fuzzyCmeans_homo_abstand( cluster_input, vektoren, clusterZentrum, p_fuzzy, numCluster)
%Kombination aus Fuzzy C-means und Homographie, Versuch
%Kombination aus Abstand Optimierung und Homographie Optimierung in einem Algorithmus
%cluster_input, vektoren_2D,fuzzy_clusterZentrum1frame, p_fuzzy, 2
%Autor: Sophie-Charlotte Bolinski, Matrikelnummer: 545839, htw-berlin

    %projektion_start := label, x_vektoren, y_vektoren
    vektor_daten = [cluster_input(:,1),vektoren]; %Datenwerte der zu clusternden Vektoren
    
    %projektion_start := label, projektion_daten_x, projektion_daten_y
    projektion = [cluster_input(:,1), cluster_input(:,2:3)];
    
    %Input Daten Größe
    input_size = size(vektor_daten); %input = column Vektor
    rows = input_size(1);

    %Erste initialisierung Clustering--------------------------------------
    cluster_zentrum = clusterZentrum; 
        
    %speichern der Clusterdaten: [label, indices , Abstände zu Cluster 1 , Abstände zu Cluster 2, Homographie Fehler 1, Homographie Fehler 2];
    r = 1:rows;
    parameter = [zeros(rows,1), r', zeros(rows,1) , zeros(rows,1), zeros(rows,1) , zeros(rows,1)];
    
    %abstand:= label, abstand_cluster1, abstand_cluster2
    %abstand = [vorclustering_komplett(:,1), vorclustering_komplett(:,2:3)];
    
    %abstand:= fehler_cluster1, fehler_cluster2
    homo_fehler = [cluster_input(:,1), zeros(rows,1) , zeros(rows,1)];
    
    %Erste initialisierung Wahrscheinlichkeiten
    %Wahrscheinlichkeit für die Abstände wird initial aus dem Vorclustering entnommen
    p_abstand = p_fuzzy; %p_abstand_cluster1, p_abstand_cluster2
    p_abstand_save = zeros(rows,2); %2=Anzahl Cluster
    
    p_homo = rand(rows, 2); %2=Anzahl Cluster, hier random...
    p_homo_save = zeros(rows,2); %2=Anzahl Cluster

    %fuzzy Parameter/ Gewichtung.. fuzzyness Parameter, Standard 2
    m_abstand = 1.8; 
    m_homo = 2.0; 
    
    %START DES CLUSTERINGS-------------------------------------------------
    %so lange, bis sich das Clusterzentrum nicht mehr ändert...
    %...keine Datenpunkte mehr dazu kommen und daher keien Neuberechnung
    %while abs(max(sum(p_abstand-p_abstand_save))) > 0.01 %Differenz Wahrscheinlichkeiten kleiner als epsilon
    for i = 1:4
    
    p_diff_abstand = abs(max(sum(p_abstand-p_abstand_save)))
    p_diff_homo = abs(max(sum(p_homo-p_homo_save)))
    
    %CLUSTER UPDATE ZUM SCHLUSS BERECHNEN... INITIAL WIRD EIN
    %CLUSTERZENTRUM ÜBERGEBEN-- sosnts doppelt?!
    %Cluster update berechnen----------------------------------------------
    %cluster_zentrum_save = cluster_zentrum_neu;
    
    %Mittlere Wahrscheinlichkeit???????
    %aus wahrscheinlichkeit für Abstand und Homographie
    %2=Anzahl der Parameter, die einfließen
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Beim Plot oder der Berechnung etwas falsch?!
    %p1 = (p_abstand(:,1).^m_abstand + p_homo(:,1).^m_homo)./2;
    %p2 = (p_abstand(:,2).^m_abstand + p_homo(:,2).^m_homo)./2;

    
    %Ereignisse können auch gleichzeitig eintreten
    %p1 = (p_abstand(:,1).^m_abstand + p_homo(:,1).^m_homo) - (p_abstand(:,1).^m_abstand .* p_homo(:,1).^m_homo);
    %p2 =  (p_abstand(:,2).^m_abstand + p_homo(:,2).^m_homo) - (p_abstand(:,2).^m_abstand .* p_homo(:,2).^m_homo);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %Abstand aller Datenpunkte zu Clusterzentren---------------------------
    %clusterzentrum auf 2 hard gecoded, sonst weitere loop
    
    for row = 1:rows
        %Abstände zu Clusterzentren berechnen (Vektoren)
        abstand(row, 2) = sum((projektion(row,2:3) - cluster_zentrum(1, :)).^2); %Euklidischer Abstand zu Zentrum 1, gewichtet
        abstand(row, 3) = sum((projektion(row,2:3) - cluster_zentrum(2, :)).^2); %Euklidischer Abstand zu Zentrum 2, gewichtet
        
    end

    %Homographie-Fehler der Cluster----------------------------------------
    
    %Homographie-Matrizen und Fehler der jeweiligen Cluster einzeln
    %Fehlerwerte nur für direkten Cluster/jedes Cluster einzeln
    start1 = projektion(projektion(:,1) == 1, 2:3);
    start2 = projektion(projektion(:,1) == 2, 2:3);
    
    vektoren1 = vektor_daten(vektor_daten(:,1) == 1, 2:3);
    vektoren2 = vektor_daten(vektor_daten(:,1) == 2, 2:3);
    
    ziel1 = start1 + vektoren1;
    ziel2 = start2 + vektoren2;
    
    %size(start1)
    %size(vektoren1)
    %size(ziel1)
    
    [homographie_matrix1, homo_fehler1] = homographie_cluster(start1, ziel1);
    [homographie_matrix2, homo_fehler2] = homographie_cluster(start2, ziel2);

    %Homographie-Fehler aller Werte gegenüber den jeweiligen
    %Homographie-Matrizen um herauszufinden, welche Abschätzung besser ist
    %Berechnung der Abschätzung für jeweils alle Werte
    homographie_invers1 = inv(homographie_matrix1);
    homographie_invers2 = inv(homographie_matrix2);
    
    start = projektion(:,2:3);
    ziel = start + vektor_daten(:,2:3);
    
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
    %Dehomogenisieren??
    %disp(fehler);
    for hf = 1:rows
         homo_fehler(hf,2) = sum(fehler1(hf,:)/3);
         homo_fehler(hf,3) = sum(fehler2(hf,:)/3);
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %fehler1_test = fehler1; %Warum eine 3xN Matrix?! -> Homogene Koordinaten!
    %fehler2_test = fehler2;
    %homo_fehler_test = homo_fehler;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %Daten einem Clusterzuordnen-------------------------------------------
    for row = 1:rows
        
       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
       %Zuweisen eines Cluster Label
       p_abstand1 = (p_abstand(row, 1).^m_abstand) * abstand(row, 2); %Optimierung Abstand
       p_abstand2 = (p_abstand(row, 2).^m_abstand) * abstand(row, 3);
       
       p_homo1 = (p_homo(row, 1).^m_homo) * homo_fehler(row, 2); %Optimierung Homographie-Fehler, min 0
       p_homo2 = (p_homo(row, 2).^m_homo) * homo_fehler(row, 3);
       
       if p_abstand1 < p_abstand2
       %if (p_abstand1 + p_homo1) < (p_abstand2 + p_homo2)
           parameter(row, 1) = 1;
       else
           parameter(row, 1) = 2;
       end
       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       
    end
    %disp(distances);
    
    
    %Daten holen und Clusterzentren neu berechnen--------------------------
    %distances(:, 1) == Label
    clustering_daten = [parameter(:, 1), projektion(:,2:3)];
    
    cluster1 = clustering_daten(clustering_daten(:,1) == 1,:); %alle Zeilen, wo clustering_daten == 1
    cluster2 = clustering_daten(clustering_daten(:,1) == 2,:);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %UPDATE CLUSTER-LABEL -- MUSS?!
    vektor_daten(:,1) = parameter(:, 1);
    projektion(:,1) = parameter(:, 1);
    abstand(:,1) = parameter(:, 1);
    homo_fehler(:,1) = parameter(:, 1);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %######################################################################
    %Cluster Wahrscheinlichkeit berechnen----------------------------------
    
    %uij wird für JEDEN Datenpunkt für JEDES Cluster definiert. 
    %Identifiziert, wie stark der Punkt zu dem einen oder anderen Cluster
    %gehört.
    
    %size_clust1 = size(cluster1);
    %size_clust2 = size(cluster2);
    %member1_fuzzy = size_clust1(1)
    %member2_fuzzy = size_clust2(1)
    
    dist_cluster1 = abstand(:,2);
    dist_cluster2 = abstand(:,3);
    
    ones_p = ones(rows,1);
    %Wahrscheilichkeiten für jeden Punkt und jedes Cluster -- Abstände
    dist_p1 = ones_p./((dist_cluster1./dist_cluster1).^(2/(m_abstand-1)) + (dist_cluster1./dist_cluster2).^(2/(m_abstand-1)));
    dist_p2 = ones_p./((dist_cluster2./dist_cluster1).^(2/(m_abstand-1)) + (dist_cluster2./dist_cluster2).^(2/(m_abstand-1)));

    %Wahrscheilichkeiten für jeden Punkt und jedes Cluster -- Homographie
    homo_cluster1 = homo_fehler(:,2);
    homo_cluster2 = homo_fehler(:,3);
    
    homo_p1 = ones_p./((homo_cluster1./homo_cluster1).^(2/(m_homo-1)) + (homo_cluster1./homo_cluster2).^(2/(m_homo-1)));
    homo_p2 = ones_p./((homo_cluster2./homo_cluster1).^(2/(m_homo-1)) + (homo_cluster2./homo_cluster2).^(2/(m_homo-1)));
    
    p_abstand_save = p_abstand;
    p_homo_save = p_homo;

    p_abstand = [dist_p1 dist_p2];
    p_homo = [homo_p1 homo_p2]
    
    %Clusterzentrum neu berechnen
    
    %Unabhängige Ereignisse
    p1 = p_abstand(:,1).^m_abstand + p_homo(:,1).^m_homo;
    p2 = p_abstand(:,2).^m_abstand + p_homo(:,2).^m_homo;  
    %p1 = p_abstand(:,1).^m_abstand;
    %p2 = p_abstand(:,2).^m_abstand;

    sum_p1 = sum(p1); %Wahrscheinlichkeiten Cluster 1
    sum_p2 = sum(p2); %Wahrscheinlichkeiten Cluster 2
    
    zentrum1 = [sum(projektion(:,2).*p1)/sum_p1 , sum(projektion(:,3).*p1)/sum_p1];
    zentrum2 = [sum(projektion(:,2).*p2)/sum_p2 , sum(projektion(:,3).*p2)/sum_p2];
    
    cluster_zentrum = [zentrum1; zentrum2]  

    end
    
    %distances(:, 1) == Label
    % p enthält wahrscheinlichkeit für [cluster1 , cluster2]
    %clustering_daten_out = [distances(:, 1), input_daten, p];
    %INPUT DATEN NICHT ÜBERSCHREIBEN!!
    %clustering_daten_out = vektor_daten;
    
end

