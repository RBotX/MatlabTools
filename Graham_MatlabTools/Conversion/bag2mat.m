%DESCRIPTION: take a N1xN2xN3 3 dimensional matrix representing bags of instances and convert it to
% an (N1xN2)xN3 2 dimensional matrix of instances
% dimensions:
% N1: #bags
% N2: #instance/bag
% N3: #features/instance

%INPUT:
%---------------------------------------------------------------
% bag: (N1xN2xN3) 3 dimensional matrix

%OUTPUT:
%---------------------------------------------------------------
% mat: (N1xN2)xN3 2 dimensional matrix

function mat = bag2mat(bag)
    mat = cat(1,bag{:});
    mat = permute(mat,[3 2 1]);
    mat = reshape(mat,[size(mat,1) size(mat,2)*size(mat,3)]);
    mat = permute(mat,[2 1]);
end