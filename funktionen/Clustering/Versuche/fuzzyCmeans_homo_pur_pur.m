function [ cluster1, cluster2, cluster_zentrum, p] = fuzzyCmeans_homo_pur_pur( input, vektoren, numCluster )
%Kombination aus Fuzzy C-means und Homographie, Versuch
%Nutzen nur von Homographie Information für das Clustering
%Autor: Sophie-Charlotte Bolinski, Matrikelnummer: 545839, htw-berlin

    %Input Daten Größe
    input_size = size(input); %input = column Vektor
    rows = input_size(1);
    
    %mixen der Daten um authentisches Ergebnis zu bekommen
    %matrix=matrix(randsample(1:length(matrix),length(matrix)),:);
    %shuffledArray = orderedArray(randperm(size(orderedArray,1)),:);
    inputt = input(randperm(size(input,1)),:);
    
    input_daten = [zeros(rows,1), inputt];
    vektor_daten = [zeros(rows,1), vektoren];
    prozent50 = rows/2;
    
    %Erste initialisierung Clustering--------------------------------------
    %speichern der Clusterdaten: [label, Fehler Homographie zu Cluster 1 , Fehler Homographie zu Cluster 2];
    homo_fehler = [zeros(rows,1), zeros(rows,1) , zeros(rows,1)];
    
    %Erste initialisierung Wahrscheinlichkeit
    %setze seed um immer gleiche random Zahlen zu erhalten
    %rng('default');
    %rng(4);
    p = rand(rows, 2); %2=Anzahl Cluster, hier random...
    p_save = zeros(rows,2); %2=Anzahl Cluster
    m = 2.0; %fuzzy Parameter/ Gewichtung.. fuzzyness Parameter, Standard 2
    
    %START DES CLUSTERINGS-------------------------------------------------
    %so lange, bis sich das Clusterzentrum nicht mehr ändert...
    %...keine Datenpunkte mehr dazu kommen und daher keien Neuberechnung
    %while abs(max(sum(p-p_save))) > 0.01 %Differenz Wahrscheinlichkeiten kleiner als epsilon
    for i = 1:1
    
    p_diff = abs(max(sum(p-p_save)))
    
    %Cluster update berechnen----------------------------------
    %cluster_zentrum_save = cluster_zentrum_neu;
    
    sum_p1 = sum(p(:,1).^m); %Wahrscheinlichkeiten Cluster 1
    sum_p2 = sum(p(:,2).^m); %Wahrscheinlichkeiten Cluster 2
    
    zentrum1 = [sum(input_daten(:,2).*(p(:,1).^m))/sum_p1 , sum(input_daten(:,3).*(p(:,1).^m))/sum_p1];
    zentrum2 = [sum(input_daten(:,2).*(p(:,2).^m))/sum_p2 , sum(input_daten(:,3).*(p(:,2).^m))/sum_p2];
    
    cluster_zentrum = [zentrum1; zentrum2]   
    
    %Homographie Schätzung einzelne Cluster--------------------------------
    if input_daten(1,1) == 0 %noch kein Cluster vorhanden
        start1 = input_daten(1:prozent50, 2:3);
        start2 = input_daten((prozent50+1):rows, 2:3);
        
        %{
        s1 = size(start1)
        s2 = size(start2)
        v1 = size((vektor_daten(1:prozent50, :)))
        
        r = rows
        p = prozent50
        v = size(vektor_daten)
        
        v2 = size((vektor_daten(prozent50+1:30, :)))
        %}
        
        vektoren1 = vektor_daten(1:prozent50, 2:3);
        vektoren2 = vektor_daten((prozent50+1):rows, 2:3);
        
        
        ziel1 =  start1 + vektoren1;
        ziel2 =  start2 + vektoren2;
        
        
    else   
        start1 = input_daten(input_daten(:,1) == 1, 2:3) %Cluster vorhanden
        start2 = input_daten(input_daten(:,1) == 2, 2:3)
        
        vektoren1 = vektor_daten(vektor_daten(:,1) == 1, 2:3)
        vektoren2 = vektor_daten(vektor_daten(:,1) == 2, 2:3)
        
        ziel1 =  start1 + vektoren1;
        ziel2 =  start2 + vektoren2;
    end
    
    [homographie_matrix1, homo_fehler1] = homographie_cluster(start1, ziel1); %fehler wird nicht benötigt
    [homographie_matrix2, homo_fehler2] = homographie_cluster(start2, ziel2);
    
    %matrix1 = homographie_matrix1
    %matrix2 = homographie_matrix2
    
    %Homographie Fehler alle Cluster---------------------------------------
    homographie_invers1 = inv(homographie_matrix1);
    homographie_invers2 = inv(homographie_matrix2);
    
    start = input;
    ziel = input+vektoren;

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
    
    allep1 = p(:,1)
    allep2 = p(:,2)
    
    
    %Zuweisen eines Cluster Label------------------------------------------
    for row = 1:rows 
       
       %pf1 = (p(row, 1).^m) * homo_fehler(row, 2)
       %pf2 = (p(row, 2).^m) * homo_fehler(row, 3)
       
       if (p(row, 1).^m) * homo_fehler(row, 2) < (p(row, 2).^m) * homo_fehler(row, 3) 
           homo_fehler(row, 1) = 1;
       else
           homo_fehler(row, 1) = 2;
       end
        
    end
    
    homof = homo_fehler
    input_daten(:,1) = homo_fehler(:, 1);
    vektor_daten(:,1) = homo_fehler(:, 1);

    %Daten holen und Clusterzentren neu berechnen--------------------------
    %clustering_daten = [distances(:, 1), input_daten];
    clustering_daten = input_daten; %Ausgangsdaten (Vektoren) mit index
    
    cluster1 = clustering_daten(clustering_daten(:,1) == 1, :); %alle Zeilen, wo clustering_daten == 1
    cluster2 = clustering_daten(clustering_daten(:,1) == 2, :);
       
    %######################################################################
    %Cluster Wahrscheinlichkeit berechnen----------------------------------
    
    ones_p = ones(rows,1);
    %Wahrscheilichkeiten für jeden Punkt und jedes Cluster -- Homographie
    homo_cluster1 = homo_fehler(:,2);
    homo_cluster2 = homo_fehler(:,3);
    
    homo_p1 = ones_p./((homo_cluster1./homo_cluster1).^(2/(m-1)) + (homo_cluster1./homo_cluster2).^(2/(m-1)));
    homo_p2 = ones_p./((homo_cluster2./homo_cluster1).^(2/(m-1)) + (homo_cluster2./homo_cluster2).^(2/(m-1)));
    
    p_save = p;
    p = [homo_p1 homo_p2];

    end
    
    %distances(:, 1) == Label
    % p enthält wahrscheinlichkeit für [cluster1 , cluster2]
    %clustering_daten_out = [distances(:, 1), input_daten, p];
    
    %label, index, vektoren_x, vektoren_y, wahrscheinlichkeiten
    %clustering_daten_out = [distances, input_daten, p];
    
end

