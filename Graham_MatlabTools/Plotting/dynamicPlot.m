%HELPER FUNCTION
%dynamicPlot(images,settings)
%
%settings parameters:
%mode: 'plot','image', or 'stairs' (histogram)
%titles: cell array of titles that you want to go above each plot
%
%DESCRIPTION: Creates grid of subplots in current figure and plots each
%cell in "images" in one of the subplots
%
%example:
%settings.mode = 'image';
%settings.titles = {'title 1','title 2','title 3'};
%images = [ones(1920,1080);ones(1920,1080)]
%figure(1)
%dynamicPlot(images(1:3),settings)
%
%NOTES:
%data should be a cell array of your data (ie for images, one image per cell)
%second parameter should be a structure with all of your settings
function dynamicPlot(data,varargin)
    
    if numel(varargin) > 2
        disp('too many arguments')
        return
    end
    
    n = numel(data);
    [rows,cols] = calculateSubplots(n);    
    
    if numel(varargin) < 1
        settings = struct;
    else
        settings = varargin{1};        
    end
    
    defaults.mode = 'image';
    defaults.titles = repmat({''},numel(data),1);
    defaults.legendContent = [];
    defaults.scale = [-inf inf -inf inf];
    defaults.colors = {};
    defaults.rows = rows;
    defaults.cols = cols;
    
    settings = set_defaults(settings,defaults);
    
    mode = settings.mode;
    titles = settings.titles;
    legendContent = settings.legendContent;
    scale = settings.scale;
    color = settings.colors;
    rows = defaults.rows;
    cols = defaults.cols;

    if strcmp(mode,'image')==1 && numel(scale)~=2
        scale = [-inf inf];
    end
    
    if rows == 1
        cols = n;
    end
    
    if cols == 1
        rows = n;
    end
    
    if rows > 5
        blnHideAxes = 1;
    else
        blnHideAxes = 0;
    end
    
    for i=1:n
        subplot(rows,cols,i)
        if strcmp(mode,'image') == 1
            imagesc(data{i})
            caxis([scale])
        elseif strcmp(mode,'plot') == 1
            h=plot(data{i}');
            axis(scale)
            if ~isempty(legendContent)
                legend(legendContent{i});
            end
            if ~isempty(color)
                set(h,'Color',color{i});
            end
        elseif strcmp(mode,'stairs') == 1
            [freq,centers] = hist(data{i},numel(unique(data{i})));
            stairs(centers,freq,'LineWidth', 4);
            axis(scale)
            legend(legendContent{i})
        end
        title(sprintf(titles{i}))
        
        if blnHideAxes
            axis off
        end
        
    end
end