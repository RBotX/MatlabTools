%DESCRIPTION: Given two ROCs (tpr/fpr/threshold values), find the false positive
% rate for which the true positive rate of the first ROC minus the second's is largest,
% and return the thresholds for both ROCs that correspond to this false positive rate 

%INPUT: 
%---------------------------------------------------------------
% tpr1: (N1x1) true positive rate for first ROC
% tpr2: (N2x1) true positive rate for second ROC
% fpr1: (N1x1) false positive rate for first ROC
% fpr1: (N2x1) false positive rate for second ROC
% thresholds1: (N1x1) thresholds for first ROC
% thresholds2: (N1x1) thresholds for second ROC

%OUTPUT:
%---------------------------------------------------------------
% thr1: threshold value of first ROC corresponding to greatest difference in ROC tpr
% thr2: threshold value of second ROC corresponding to greatest difference in ROC tpr

function [thr1,thr2] = getMaxTPRDiffThresholds(tpr1,tpr2,fpr1,fpr2,thresholds1,thresholds2)

	%find maximum (farthest to the right) tpr for each fpr for first ROC
    grps1 = grp2idx(fpr1);
    blah = grpstats(tpr1,grps1,{'max'});
    map1 = [unique(fpr1)' blah];
    
	%same but for second ROC
    grps2 = grp2idx(fpr2);
    blah = grpstats(tpr2,grps2,{'max'});
    map2 = [unique(fpr2)' blah];
    
	%match up fpr (x-axis)
    mapMatchup = knnsearch(map1(:,1),map2(:,1),'K',1);
	
	%find greatest tpr difference for each unique fpr
    fprDiff = map1(mapMatchup,2)-map2(:,2);   
    [~,largestDiff] = max(fprDiff);
	
	%go back to original set of data and find thresholds corresponding to greatest
	%tpr difference
    map1_lookup = mapMatchup(largestDiff);
    idx1 = find(grps1==map1_lookup,1,'last');
    idx2 = find(grps2==largestDiff,1,'last');
    thr1 = thresholds1(idx1);
    thr2 = thresholds2(idx2);    

end