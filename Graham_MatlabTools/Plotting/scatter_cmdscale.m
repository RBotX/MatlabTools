%data should be cell array, each cell is an nxd matrix of features.
function varargout = scatter_cmdscale(data,varargin)

    if numel(varargin)>0
        names = varargin{1};
    else
        for i = 1:numel(data)
            names{i} = ['set' num2str(i)];
        end
    end
    
    if numel(varargin)>1
        scatterSize = varargin{2};
    else
        scatterSize = cell(numel(data),1);
    end

    groups = numel(data);

    D = pdist(vertcat(data{:}));
    D = squareform(D);
    D = D.^2;
    
    Y = cmdscale(D);
    
    currentInd = 0;
    hold on
    colors = hsv(groups);
    symbols = {'+','s','*','.'};
%     colors = {'b','g','r','k'};
    allInds = zeros(groups,1);    
    for i = 1:groups
        
        if isempty(scatterSize{i})
            thisSize = 60;
        else
            thisSize = scatterSize{i};
        end
        
        lastInd = currentInd;
        dataSize = size(data{i},1);
        currentInd = lastInd+dataSize;
        scatter(Y(lastInd+1:currentInd,1),...
                Y(lastInd+1:currentInd,2),...
                thisSize,...
                repmat(colors(i,:),dataSize,1),'filled');...;                
%                 symbols{i},...                
%                 colors{i});                           
        allInds(i) = lastInd+1;
    end 
    legend(gca,names);  
    hold off
    
    if nargout == 2
        varargout{1} = Y(:,1);
        varargout{2} = Y(:,2);
    end
    
end

