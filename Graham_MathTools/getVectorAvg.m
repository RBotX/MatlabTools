%****DEPRECATED****
% I left this here because several of my old classifiers use it. Use topAvgVector instead
function vect = getAvgVector(vect,topN,direction)

    if strcmp(direction,'ascend')==1
        vect = sort(vect,'ascend');   
    else
        vect = sort(vect,'descend');
    end

    if numel(vect)<topN
        for i = numel(vect)+1:topN
            vect(i) = 0;
        end
    end
    
    vect = vect(1:topN,:);
    vect = mean(vect);
end