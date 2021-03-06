function [ cluster1, cluster2, vektoren1, vektoren2, cluster_zentrum, p_fuzzy] = fuzzyCmeans_self( input_daten, vektoren, numCluster )
%Eigene Implementierung des Fuzzy C-means
%
%INPUT:
%
%   input_daten         =   projezierte Daten, 2xn Matrix
%   vektoren            =   Vektoren, 2xn MAtrix
%   numCluster          =   Anzahl der Cluster, noch nicht implementiert
%
%OUTPUT:
%
%   cluster1            =   Werte und Label 1. Cluster
%   cluster2            =   Werte und Label 1. Cluster
%   vektoren1           =   Vektoren und Label 1. Cluster
%   vektoren2           =   Vektoren und Label 2. Cluster
%   cluster_zentrum     =   berechnetes Clusterzentrum am Ende des Algorithmus
%   p_fuzzy             =   Wahrscheinlichkeiten der Punkte gegen�ber der jeweiligen Cluster
%
%Autor: Sophie-Charlotte Bolinski, Matrikelnummer: 545839, htw-berlin

    %Input Daten Gr��e
    input_size = size(input_daten); %input = column Vektor
    rows = input_size(1);
    
    %inputtt = input_daten
    
    vektor_daten = [zeros(rows,1), vektoren];
    
    %Erste initialisierung Clustering--------------------------------------
    %speichern der Clusterdaten: [label, indices , Abst�nde zu Cluster 1 , Abst�nde zu Cluster 2];
    r = 1:rows;
    distances = [zeros(rows,1), r', zeros(rows,1) , zeros(rows,1)];
    
    %Erste initialisierung Wahrscheinlichkeit
    rng('default');
    rng(7);
    p = rand(rows, 2); %2=Anzahl Cluster, hier random...
    p_save = zeros(rows,2); %2=Anzahl Cluster
    m = 2.0; %fuzzy Parameter/ Gewichtung.. fuzzyness Parameter, Standard 2
    
    %START DES CLUSTERINGS-------------------------------------------------
    %so lange, bis sich das Clusterzentrum nicht mehr �ndert...
    %...keine Datenpunkte mehr dazu kommen und daher keien Neuberechnung
    while abs(max(sum(p-p_save))) > 0.01 %Differenz Wahrscheinlichkeiten kleiner als epsilon
    %for i = 1:30
    
    %p_diff = abs(max(sum(p-p_save)))
    
    %Cluster update berechnen----------------------------------
    %cluster_zentrum_save = cluster_zentrum_neu;
    
    sum_p1 = sum(p(:,1).^m); %Wahrscheinlichkeiten Cluster 1
    sum_p2 = sum(p(:,2).^m); %Wahrscheinlichkeiten Cluster 2
    
    zentrum1 = [sum(input_daten(:,1).*(p(:,1).^m))/sum_p1 , sum(input_daten(:,2).*(p(:,1).^m))/sum_p1];
    zentrum2 = [sum(input_daten(:,1).*(p(:,2).^m))/sum_p2 , sum(input_daten(:,2).*(p(:,2).^m))/sum_p2];
    
    cluster_zentrum = [zentrum1; zentrum2];   
    
    %Abstand aller Datenpunkte zu Clusterzentren---------------------------
    %clusterzentrum auf 2 hard gecoded, sonst weitere loop
    for row = 1:rows
        
       %Abst�nde zu Clusterzentren berechnen 
       distances(row, 3) = sum((input_daten(row,1:2) - cluster_zentrum(1, :)).^2); %Euklidischer Abstand zu Zentrum 1, gewichtet
       distances(row, 4) = sum((input_daten(row,1:2) - cluster_zentrum(2, :)).^2); %Euklidischer Abstand zu Zentrum 2, gewichtet
       
       %Zuweisen eines Cluster Label
       if (p(row, 1).^m) * distances(row, 3) < (p(row, 2).^m) * distances(row, 4) 
           distances(row, 1) = 1;
       else
           distances(row, 1) = 2;
       end
            
    end
    %disp(distances);
    
    %Daten holen und Clusterzentren neu berechnen--------------------------
    %clustering_daten = [distances(:, 1), input_daten];
    clustering_daten = [distances(:, 1), input_daten]; %Ausgangsdaten (Vektoren) mit index
    
    cluster1 = clustering_daten(clustering_daten(:,1) == 1,:); %alle Zeilen, wo clustering_daten == 1
    cluster2 = clustering_daten(clustering_daten(:,1) == 2,:);
    
    %vektoren mit clustern
    vektor_daten = [distances(:, 1), vektoren];
    
    vektoren1 = vektor_daten(vektor_daten(:,1) == 1,:);
    vektoren2 = vektor_daten(vektor_daten(:,1) == 2,:);
    %######################################################################
    %Cluster Wahrscheinlichkeit berechnen----------------------------------
    
    %uij wird f�r JEDEN Datenpunkt f�r JEDES Cluster definiert. 
    %Identifiziert, wie stark der Punkt zu dem einen oder anderen Cluster
    %geh�rt.
    
    %size_clust1 = size(cluster1);
    %size_clust2 = size(cluster2);
    %member1_fuzzy = size_clust1(1)
    %member2_fuzzy = size_clust2(1)
    
    dist_cluster1 = distances(:,3);
    dist_cluster2 = distances(:,4);
    
    %Wahrscheilichkeiten f�r jeden Punkt und jedes Cluster
    ones_p = ones(rows,1);
    dist_p1 = ones_p./((dist_cluster1./dist_cluster1).^(2/(m-1)) + (dist_cluster1./dist_cluster2).^(2/(m-1)));
    dist_p2 = ones_p./((dist_cluster2./dist_cluster1).^(2/(m-1)) + (dist_cluster2./dist_cluster2).^(2/(m-1)));

    %homo_p1
    %homo_p2
    
    p_save = p;
    p = [dist_p1 dist_p2];

    end
    
    %Outputs
    p_fuzzy = p;
    
    %distances(:, 1) == Label
    % p enth�lt wahrscheinlichkeit f�r [cluster1 , cluster2]
    %clustering_daten_out = [distances(:, 1), input_daten, p];
    
    %label, index, vektoren_x, vektoren_y, wahrscheinlichkeiten
    %clustering_daten_out = [distances, input_daten, p];
    
end

