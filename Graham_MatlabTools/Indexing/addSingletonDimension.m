%DESCRIPTION: Adds singleton dimension to data along dimension "dim"
%example:
%INPUT: data = zeros(2,2); %data = [2x2] double
%data = addSingletonDimension(data,1);
%OUTPUT: data %data = [1x2x2] double
%------------------------------------------
%NOTE: Matlab automatically removes trailing singleton dimensions
%(ie you can't have a 2x2x1)
function data = addSingletonDimension(data,dim)
   
    numberOfDims = numel(size(data));
    
    permuteOrder = [1:dim-1,numberOfDims+1,dim:numberOfDims];        
    data = permute(data,permuteOrder);
    
end

