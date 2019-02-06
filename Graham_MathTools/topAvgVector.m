%DESCRIPTION: Sorts matrix and then gets average of top N windows along that dimension

%INPUT:
%---------------------------------------------------------------
% matr: (NxW) matrix of values (confidences) (number)
% dim: (scalar) dimension along which to sort and average (int)
% topN: (scalar) how many windows to average over per row/column (int)
% direction: (string) sort in descending or ascending order ('descend'/'ascend')

%OUTPUT:
%---------------------------------------------------------------
% vect: (Nx1) vector of confidences
function vect = topAvgVector(matr,dim,topN,direction)

    if strcmp(direction,'ascend')==1
        matr = sort(matr,dim,'ascend');   
    else
        matr = sort(matr,dim,'descend');
    end
    
    otherDim = 1:numel(size(matr));
    otherDim = otherDim(~ismember(1:2,dim));
    matr = permute(matr,[dim otherDim]);
    
    matr = matr(1:topN,:);
    vect = mean(matr);
    
    vect = permute(vect,[dim,otherDim]);
    
end