function [ cluster1, cluster2, cluster_zentrum_neu ] = kmeans_self( input_daten, numCluster )

    %Input Daten Größe
    input_size = size(input_daten); %input = column Vektor
    rows = input_size(1);
    
    %Erste initialisierung Clustering--------------------------------------
    max_data = max(input_daten); %größter Datensatz
    min_data = min(input_daten); %kleinster Datensatz
    
    %cluster_zentrum_neu = [(max_data-min_data) ; (max_data-min_data)].*rand(numCluster,dimension_data=columns) + [min_data; min_data];
    %cluster_zentrum_neu = [(max_data-min_data)*rand(2,2) + min_data; (max_data-min_data)*rand(2,2) + min_data]
    cluster_zentrum_neu = [max_data ; min_data];
    cluster_zentrum_save = zeros(2,2);
    
    %speichern der Clusterdaten: [label, indices , Abstände zu Cluster 1 , Abstände zu Cluster 2];
    r = 1:rows;
    distances = [zeros(rows,1), r', zeros(rows,1) , zeros(rows,1)];
    
    %Abstand aller Datenpunkte zu Clusterzentren---------------------------
    %clusterzentrum auf 2 hard gecoded, sonst weitere loop
    
    %so lange, bis sich das Clusterzentrum nicht mehr ändert...
    %...keine Datenpunkte mehr dazu kommen und daher keien Neuberechnung
    while isequal(cluster_zentrum_save,cluster_zentrum_neu) == 0
    %for i = 1:3
        
    %diff1_sum = zeros(rows, columns);
    %diff2_sum = zeros(rows, columns);
    for row = 1:rows
        
       distances(row, 3) = sum((input_daten(row,:) - cluster_zentrum_neu(1, :)).^2);
       distances(row, 4) = sum((input_daten(row,:) - cluster_zentrum_neu(2, :)).^2);
       
       %Zuweisen eines Cluster Label
       if distances(row, 3) < distances(row, 4)
           distances(row, 1) = 1;
       else
           distances(row, 1) = 2;
       end
            
    end
    %disp(distances);
    
    %Daten holen und Clusterzentren neu berechnen--------------------------
    %loops zusammen legen??
    clustering_daten = [distances(:, 1), input_daten];
    
    cluster1 = clustering_daten(clustering_daten(:,1) == 1,:); %alle Zeilen, wo clustering_daten == 1
    cluster2 = clustering_daten(clustering_daten(:,1) == 2,:);
    
    size_clust1 = size(cluster1);
    size_clust2 = size(cluster2);
    member1_kmeans = size_clust1(1)
    member2_kmeans = size_clust2(1)

    cluster_zentrum_save = cluster_zentrum_neu;
    cluster_zentrum_neu = [mean(cluster1(:, 2:3));mean(cluster2(:, 2:3))]

end

end

