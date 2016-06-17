function [ clustering_daten,cluster_zentrum_neu ] = kmeans_proto2( input_daten, numCluster )

    %Input Daten Größe
    input_size = size(input_daten); %input = column Vektor
    rows = input_size(1);
    columns = input_size(2);
    
    %Erste initialisierung Clustering--------------------------------------
    max_data = max(input_daten); %größter Datensatz
    min_data = min(input_daten); %kleinster Datensatz
    
    %cluster_start = [(max_data-min_data) ; (max_data-min_data)].*rand(rows,numCluster) + [min_data; min_data];
    %cluster_start = [max_data ; min_data];
    cluster_zentrum_neu = [max_data ; min_data];
    cluster_zentrum_save = zeros(2,2);
    
    %Abstand aller Datenpunkte zu Clusterzentren---------------------------
    %clusterzentrum auf 2 hard gecoded, sonst weitere loop
    
    %so lange, bis sich das Clusterzentrum nicht mehr ändert...
    %...keine Datenpunkte mehr dazu kommen und daher keien Neuberechnung
    while isequal(cluster_zentrum_save,cluster_zentrum_neu) == 0
    %for i = 1:3
        
    %diff1_sum = zeros(rows, columns);
    %diff2_sum = zeros(rows, columns);
    for row = 1:rows
        
       diff1_sum(row, :) = sum((input_daten(row,:) - cluster_zentrum_neu(1, :)).^2);
       diff2_sum(row, :) = sum((input_daten(row,:) - cluster_zentrum_neu(2, :)).^2);
            
    end
  
    %sum(A,dim)
    r = 1:rows;
    %distances = [zeros(rows,1), r', sqrt(diff1_sum), sqrt(diff2_sum)]
    distances = [zeros(rows,1), r', diff1_sum, diff2_sum];
    
    %Cluster Label zuweisen------------------------------------------------
    %indexing vorher, loops zusammen legen??
    for row = 1:rows
        
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
    
    cluster1 = clustering_daten(clustering_daten(:,1) == 1,:) %alle Zeilen, wo clustering_daten == 1
    cluster2 = clustering_daten(clustering_daten(:,1) == 2,:)

    cluster_zentrum_save = cluster_zentrum_neu;
    cluster_zentrum_neu = [mean(cluster1(:, 2:3));mean(cluster2(:, 2:3))]

end

end

