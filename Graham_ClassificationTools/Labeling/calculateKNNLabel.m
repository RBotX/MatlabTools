%DESCRIPTION: Calculates fuzzy label for prototypes by using the average distance 
% of the k nearest training points per prototype

%INPUT: 
%---------------------------------------------------------------
% cent1: (N1xD) prototypes belonging to first class label
% cent2: (N2xD) prototypes belonging to second class label
% train1: (N3xD) all training points belonging to first class label
% train2: (N4xD) all training points belonging to second class label
% k: (scalar)

%OUTPUT:
%---------------------------------------------------------------
% Labels1: (N1x1) Calculated fuzzy labels for each observation in cent1
% Labels2: (N2x1) Calculated fuzzy labels for each observation in cent2

function [Labels1,Labels2] = calculateKNNLabel(cent1,cent2,train1,train2,k)

	%purity of prototypes in first class label
    [idx1] = knnsearch([train1;train2],train1,'K',k);  
    train1_labels = sum(idx1<=size(train1,1),2)./k;
    
	%purity of prototypes in second class label
    [idx2] = knnsearch([train1;train2],train2,'K',k);   
    train2_labels = sum(idx2<=size(train1,1),2)./k;
    
    %[closest_cent1,closest_cent1_ind] = knnsearch(cent1,train1,'K',1);
    %for i = 1:size(cent1,1)
    %    Labels1(i) = mean(train1_labels(closest_cent1==i));
    %    myu(i) = mean(closest_cent1_ind(closest_cent1==i));
    %    sigma(i) = std(closest_cent1_ind(closest_cent1==i));
    %end
    %Labels1(isnan(Labels1))=0;    
    
    %[closest_cent2,closest_cent2_ind] = knnsearch(cent2,train2,'K',1);
    %for i = 1:size(cent1,1)
    %    Labels2(i) = mean(train2_labels(closest_cent2==i));
    %    myu(numel(Labels1)+i) = mean(closest_cent2_ind(closest_cent2==i));
    %    sigma(numel(Labels1)+i) = std(closest_cent2_ind(closest_cent2==i));
    %end        
    %Labels2(isnan(Labels2))=0;    

end