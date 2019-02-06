%DESCRIPTION: Returns the distance of the kth closest prototype per prototype.
% These values can be used as sigma (for label propagation) where each prototype has its
% own sigma

%INPUT: 
%---------------------------------------------------------------
% prototypes: (NxD) trained representative prototypes
% k: (scalar)

%OUTPUT:
%---------------------------------------------------------------
% sigma: (Nx1) distance of kth nearest prototype for each prototype

function sigma = getOneSigmaPerProt(prototypes,k)

    if size(prototypes,1) < 2
        sigma = 1;
        return;
    end

    P = pdist(prototypes,'euclidean');    
    P=squareform(P);
    P=P.^2;    
    P = sort(P,2);
    sigma = P(:,k);

end