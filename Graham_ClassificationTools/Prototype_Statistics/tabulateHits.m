%DESCRIPTION: Counts how many times each observation (row) in trainData is a kth nearest neighbor
% of testData (in other words, measures relevance of training data)

%INPUT: 
%---------------------------------------------------------------
% trainData: (N1xD1) training prototypes
% testData: (N2xD1) test points
% k: (scalar)

%OUTPUT:
%---------------------------------------------------------------
% hits: (N1x1) vector counting the number of times each observation in trainData was a kth
%  nearest neighbor of testData.
function hits = tabulateHits(trainData,testData,k)

    idx = knnsearch(trainData,testData,'K',k);
    idx = idx(:);
    for i = 1:size(trainData,1)
        hits(i) = sum(idx==i);
    end

end