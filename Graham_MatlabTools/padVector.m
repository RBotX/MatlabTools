function paddedVector = padVector(blnVector,maxSize)

    crossings = find(blnVector);

    ind = 1;
    paddedVector = zeros(1,numel(blnVector));
    while ind <= numel(crossings)
        c = crossings(ind);
        neighbors = [];
        neighbors = crossings<c+maxSize;
        farthest = max(crossings(neighbors));
        if farthest==c
            ind = ind+1;
        else
            paddedVector(c:farthest)=1;
            ind = find(neighbors,1,'last');
        end
    end

end

