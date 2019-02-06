%DESCRIPTION: This function performs any of several variations of label
%propagation. It is designed to work specifically with binary / fuzzy binary
%classification

%INPUT: 
%---------------------------------------------------------------
% LabeledData: Nxd, where N: #instances, d: dimensionality of features
%---------------------------------------------------------------
% UnlabeledData: (optional) (same format as LabeledData)
%---------------------------------------------------------------
% TestData: (same format as LabeledData)
%---------------------------------------------------------------
% Labels NxL, where N is the same number as N from LabeledData. L: #labels assigned to each labeled point
%---------------------------------------------------------------
% varargin{1}: 
%  settings: structure whose properties dictate how LP should be run (all of these properties are optional, and have defaults)
%----------------------------
%   settings.METHOD: Which algorithm do you want to use:
%    1: Iterative, clamps labeled points' labels, 
%    2: Iterative, allows labeled points' labels to change 
%    3: Iterative, uses label spreading via laplacian. Allows labeled points' labels to change
%    4: Zhu, non-iterative, *current best*
%----------------------------
%  settings.GRAPH: Which graph method. *SOMETIMES SIGMA WORKS BETTER, AND SOMETIMES KNN WORKS BETTER*
%   'SIGMA': fully connected graph with edges weighted using a value for SIGMA
%   'KNN': use a KNN tree, where each edge has equal weighted
%----------------------------
%  settings.SIGMA: If using SIGMA graph, provide value of sigma
%   0: learn value of SIGMA using Mimimum Spanning Trees
%----------------------------
%  settings.K: If using KNN tree, provide value of k
%  settings.iter: If using iterative method (1-3), how many iterations to allow algorithm to go before converging

%OUTPUT:
%---------------------------------------------------------------
% varargout{1}: confidence values of test points
%----------------------------
% varargout{2}: confidence values of unlabeled data
%----------------------------
% varargout{3}: (learned) value of sigma
function varargout = LabelPropAll(LabeledData,UnlabeledData,TestData,Labels,varargin)

	%%INITIALIZE PARAMETERS
	if numel(varargin) == 1
		settings = varargin{1};
	else
		settings = struct;
	end

    defaults.METHOD = 1;
    defaults.GRAPH = 'SIGMA';
    defaults.SIGMA = 0;
    defaults.K = 10;
    defaults.iter = 100;
    
    settings = set_defaults(settings,defaults);
    
	METHOD = settings.METHOD;
	GRAPH = settings.GRAPH;
	SIGMA = settings.SIGMA;
	K = settings.K;
	ITER = settings.iter;
	
	%% CONSTRUCT GRAPH AND CALCULATE LABELS
	
	%build initial graph and intiialize labels of unlabeled data
    P = pdist([LabeledData;UnlabeledData;TestData],'euclidean');    
    P=squareform(P);
%     P=P.^2;    
    W=P;
    Y0 = [Labels;0.5.*zeros(size(UnlabeledData,1)+size(TestData,1),size(Labels,2))];    
    
	%Build either KNN or fully connected graph
    if strcmp(GRAPH,'KNN')==1
        W = build_KNNTree([LabeledData;UnlabeledData;TestData],settings.K);
    else
	
		%learn sigma using MST
%         if SIGMA == 0
%             SIGMA = learn_sigma(LabeledData,Labels);            
%         end    
        
		%normalize graph using sigma
%         W = exp(-(P)./SIGMA);
%         W = (1./(max(0, (P-settings.all_a))./(settings.all_b/2)+1));
            m = 2;
            W = (1./((max(0, (P-settings.all_a))./(settings.all_b/2).^(1/(m-1)))+1));
            
            %keep only 10 closest edges to test point
%             [NN,D] = knnsearch(LabeledData,TestData,'K',10);
%             W2 = W;
%             W2(end,:) = zeros(1,size(W,2));
%             W2(end,NN) = W(end,NN);
%             W = W2;
            
    end
    
%     W = W.*(1./(max(0, (P-settings.all_a))./(settings.all_b/2)+1));
    
    switch settings.METHOD
        %LabelProp Algorithm 1
        case 1
            D = repmat(sum(W,2),1,size(W,2));
            D = D.*eye(size(D));              
            func = @(Y) (D\W)*[Y0(1:size(LabeledData,1),:);Y(size(LabeledData,1)+1:size(W,1),:)];
            
        %LabelProp Algorithm 2
        case 2
            W(logical(eye(size(W))))=0;
            D = repmat(sum(W,2),1,size(W,2));
            D = D.*eye(size(D));              
            alph = 0.05;
            myu = alph/(1-alph);

            I = eye(size(W));
            I(size(LabeledData,1)+1:size(W,1),size(LabeledData,1)+1:size(W,1)) = 0;

            A = I+(myu.*D)+(myu*eps);  
            A = A.*eye(size(A));
            
            func = @(Y) A\(((myu.*W)*Y)+Y0);
        %LabelProp 3: Label Spreading
        case 3
            W(logical(eye(size(W))))=0;
            D = repmat(sum(W,2),1,size(W,2));
            D = D.*eye(size(D));
            alph = 0.95;

            I = eye(size(W));
            I(size(LabeledData,1)+1:size(W,1),size(LabeledData,1)+1:size(W,1)) = 0;

            Dinv = sqrt(D);
            Dinv(logical(eye(size(D)))) = 1./Dinv(logical(eye(size(D))));
            L = Dinv*W*Dinv;  
            
            func = @(Y) (alph.*L*[Y0(1:size(LabeledData,1),:);Y(size(LabeledData,1)+1:size(W,1),:)])+((1-alph)*Y0);
            
        %Label Prop (Zhu) with row/col normalization
        case 4
            for j=1:size(W,2)
				T(:,j)=W(:,j)./max(eps,sum(W(:,j)));
            end
            
            Tp=T';

            for t=1:size(T,1)
				TNorm(:,t)=Tp(:,t)./max(eps,sum(Tp(:,t)));
            end
			TNorm=TNorm';
% % %             
            TUU=TNorm(size(LabeledData,1)+1:end,size(LabeledData,1)+1:end);
            TUL=TNorm(size(LabeledData,1)+1:end,1:size(LabeledData,1));
%             TUU = Tp(end,size(LabeledData,1)+1:end);            
%             TUL = Tp(end,1:size(LabeledData,1));
			
            func = @()(eye(size(TUU))-TUU)\TUL*Y0(1:size(LabeledData,1),:);			
        %error
        otherwise
            warning('Invalid method choice')
            func = @()Y0;
    end
    
	%YHist shows how labels are changing between iterations
%     YHist = cell(ITER,1);
    if METHOD==4
        Y = func();
    else
        Y = Y0;
%         YHist(1,:) = Y;
        for i = 1:ITER
            YNext = func(Y);
            delta = sum(abs(YNext(size(LabeledData,1)+1:end)-Y(size(LabeledData,1)+1:end)));            
            Y = YNext;
			%uncomment if want algorithm to stop after converging to an epsilon
%             if delta < 0.01
%                break
%             end
%             YHist(i+1,:) = Y;
        end
    end
% 	%Doesn't currently work -- need to change this to account for YHist
% 	being a cell array
%     if 0
%         figure(1);subplot(2,1,1);plot(YHist(:,end-9:end));
%         legend(cellstr(num2str([1:10]')))
%         subplot(2,1,2);plot(YHist(2,:)-YHist(1,:));
%     end
    
	%suppress singularity warning (happens when sigma is very small)
    [msg id] = lastwarn;
    if ~isempty(id)
        warning('off',id)    
    end       
    
    Result=Y(end-size(TestData,1)+1:end,:);
    
    varargout{1} = Result;
	
	%output labels of unlabeled data
    if nargout > 1
        varargout{2} = Y(end-size(TestData,1)-size(UnlabeledData,1)+1:end-size(TestData,1));
    end    
	%output new value of sigma (only useful if learning sigma with MST)
    if nargout > 2
        varargout{3} = SIGMA;
    end        

end

%Set default properties for user-provided settings structure
function settings = set_defaults(settings,defaults)

    allFields = fieldnames(defaults);
    providedFields = fieldnames(settings);
    unsetFields = allFields(~ismember(allFields,providedFields));
    
    function dynamicFieldSet(field)
        settings.(field) = defaults.(field);
    end
    cellfun(@(field) dynamicFieldSet(field), unsetFields);
end

%use MST to find a good value of sigma, method explained in Zhu's paper
%NOTE: does not know which points belong to which classes, instead relies on binary split
%between Labels to discren which points likely belong to one class or the other
function sigma = learn_sigma(LabeledData,Labels)
    Labels = Labels(:,1);
    sigma = 0;
	%first tries and splits data based on label
	%starts by splitting the data based on percentiles using the value of their labels
	%first iteration will contain only the highest and lowest confidence points
    for i = 1:50
		%identify points with relatively weak and strong labels
        weak = prctile(Labels,i);
        strong = prctile(Labels,100-i);
		
		%construct graph over all data
        DP = pdist(LabeledData, 'euclidean');
        D=squareform(DP);
        D=D.^2;  
		
		%build minimum spanning tree over all data
        X = 1-eye(size(D,1));
        [~, ~, X_st] = kruskal(X,D);
        weightedTree = D.*X_st;
        s = sparse(weightedTree);
		
		%iterate over edges and try to find one that connects the two groups of points (weak and strong).
		%If no such edge is found, it means that there aren't enough points in one of the two groups
        [smallestWeights,smallestEdges] = sort(weightedTree(:),'ascend');
        for j = 1:numel(smallestEdges)
            [row,col] = ind2sub(size(D),smallestEdges(j));
            if smallestWeights(j) ~= 0 && ...
               (Labels(row) >= strong && Labels(col) <= weak || ...
               Labels(row) <= weak && Labels(col) >= strong)
                sigma = smallestWeights(j)/3;
                break;
            end
        end
        if sigma ~= 0
            break;
        end
    end
end

function W = build_KNNTree(data,k)
    NearestNg = knnsearch(data,data,'K',k);
    NearestNg = NearestNg(:,2:end);
    W = zeros(size(data,1),size(data,1));
    for ii =1:size(NearestNg,1)
        currentNN = NearestNg(ii,:);
        W(ii,currentNN) = 1;
        W(currentNN,ii) = 1;
    end
end
