%DESCRIPTION: Use simple prescreener condition on 16 dimensional EHD feature as
% seen in handheld EHDprescreener

%INPUT: 
%---------------------------------------------------------------
% points: (Nx16) dimensional feature EHD feature vector (1:4 = horizontal, vertical, diagonal, anti-diagonal, etc)

%OUTPUT: 
%---------------------------------------------------------------
% sums: (Nx1) prescreener assigned confidence
function sums = calculatePrescreenCondition(points)

    for i = 1:size(points,1)
        if ((points(i,3)<points(i,4)) + (points(i,7)<points(i,8)) + (points(i,12)<points(i,11)) + (points(i,16)<points(i,15)) )>2
            sums(i) = 0;
        else
            sums(i) = (points(i,3)+points(i,7))*(points(i,12)+points(i,16));
        end
%         sums(i) = (points(i,3)+points(i,8))*(points(i,14)+points(i,19));        
    end
    
end