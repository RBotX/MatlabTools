%HELPER FUNCTION
%****************
%DESCRIPTION: Returns a vertically concatenated vector of values for each
%"field" value in structure array. 
%
%INPUT:
%---------------------------------------------------------------
% structure: any structure or structure array
% field: string to field name from structure

%NOTE ABOUT INPUT: If "structure" is m by n (instead of 1 by n / n by 1),
%you will need to reshape the output.
%
%NOTE ABOUT FIELD TYPES:
%SCALAR: will cause this function to return a vector
%VECTOR: will cause this function to return a matrix
%MATRIX: will cause this function to return a cell array of matrices
function results = field2mat(structure,field)

    if numel(structure) == 0
        error('structure is empty')
    end

    inds = num2cell(1:numel(structure));
    results = [];
    try
        protCell = cellfun(@(x) getfield(structure(x),field),inds,'UniformOutput',0)';    
        if ischar(protCell{1})
            results = protCell;  
            return;
        end
        
        try
            matr = vertcat(protCell{:});
            if size(matr,1) > numel(inds)
                results = protCell;        
            else
                results = matr;
            end
        catch
            warning('vector lengths not identical between structure elements -- returning as cell array instead.')
            results = protCell;
        end
    catch err
        error(err.message)
    end
end