%DESCRIPTION: Adds a vector of values to a structure array under a provided fieldname,
%even if that field doesn't exist in the structure array.

%INPUT:
%------------------------------------------------------------
% struc: structure array
% fieldname: name of new or existing field into which values will be put
% toConvert: array of values to put into the elements in struc. 
%**toConvert Must have same number of elements as struc

%OUTPUT:
%------------------------------------------------------------
% struc: updated structure with new field
function struc = mat2field(struc,fieldname,toConvert)
    if iscell(toConvert)
        blnIsCell = 1;
    else
        blnIsCell = 0;
    end
    if ~isfield(struc,fieldname)
        struc(1).(fieldname) = [];
    end
    if blnIsCell
        for k = 1:numel(struc)
            struc(k) = setfield(struc(k),fieldname,toConvert{k});
        end
    else
        for k = 1:numel(struc)
            struc(k) = setfield(struc(k),fieldname,toConvert(k));
        end
    end
end