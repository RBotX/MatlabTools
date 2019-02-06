%GRAHAM: I made some changes to add functionality to this like opening already saved figs, zooming on one fig and having it zoom to the same place in the other figs too
%Only meant to work with multiple figs that all have the same x and y axes
function varargout = figs2tabs(figHandles)
    % Creates a tabbed window with a figure contained in each tab.
    % 
    % No tab workarounds necessary - MATLAB's built-in but undocumented tab
    % features are used for smooth graphics handling and a clean interface.
    %
    % Input parameters:
    %   figHandles: an array of handles to currently valid, visible figures.
    %   These figures can be GUIDE based.
    %
    % Output parameters:
    %   (optional): The handle to the tabbed figure is output if desired.
    %
    % Example: 
    %     f1 = figure('Name','Sin Wave');
    %     plot(sin(1:100));
    %     f2 = figure('Name','Random Points');
    %     plot(magic(5))
    %     f3 = msgbox('A message box');
    %     tabbedFig = figs2tabs([f1,f2,f3])
    % 
    % Warning:
    %    This code heavily relies on undocumented Matlab functionality.
    %    It has only been tested on Matlab 2012a. Use at your own risk.
    %
    % Known limitations: 
    %   *uimenu's are not preserved
    %   *figure-wide callback functions are not preserved, i.e. KeyPressFcn,
    %   CloseRequestFcn.
    %
    % Known issues: 
    %   *Not compatible with older versions of Matlab, though it could be with
    %   some slight modifications to this function. Compatibility fixes to this
    %   function are welcome from those with older versions.
    %
    % See also uitab, uitabgroup, setappdata, getappdata, guidata

    % License to use and modify this code is granted freely to all interested, as long as the original author is
    % referenced and attributed as such. The original author maintains the right to be solely associated with this work.

    % Programmed and Copyright by Chad Smith 

%     warning('off','MATLAB:uitabgroup:OldVersion')
%     if nargin < 1
%         error('An array of figure handles must be input')
%     end

    if nargin < 1
        figHandles = [];
    end

    % create figure and tab group
    [tabbedFig,tabGroupH] = init_figure;
    hManager = uigetmodemanager(tabbedFig);
    set(hManager.WindowListenerHandles,'Enable','off');
    addlistener(tabbedFig,'KeyPressFcn','PostSet',@resetKeypress);
    set(tabbedFig, 'KeyPressFcn', @keyPress)    
    openFig = findall(tabbedFig,'Tag','Standard.FileOpen');
    saveFig = findall(tabbedFig,'Tag','Standard.SaveFigure');
    newFig = findall(tabbedFig,'Tag','Standard.NewFigure');
    set(openFig,'ClickedCallback',@openFigFun)
    set(saveFig,'Visible','off')
    set(newFig,'Visible','off')
    
    % create tab for each figure
    for tabNum=1:numel(figHandles)
       figHandle = figHandles(tabNum);
       add_tab(tabbedFig, tabGroupH, figHandle, tabNum);
    end

    %set the first tab as active and update to ensure the right guidata, windowsize, etc.
    if numel(figHandles) > 0
        initialize_tab_group(tabbedFig, tabGroupH);    
        resizeTabContent(tabbedFig)  
    end
        
    %set output
    if nargout == 1
        varargout{1} = tabbedFig;
    end
end

function resetKeypress(prop,eventdata)
    eventdata.AffectedObject.KeyPressFcn = @keyPress;
end

function keyPress(hObject,eventdata)
    tabGroup = findall(hObject,'Type','uitabgroup');
    tabs = get(tabGroup,'Children');
    selectedTab = get(tabGroup,'SelectedIndex');
    if strcmp(eventdata.Key,'rightarrow')==1 && selectedTab < numel(tabs)
        set(tabGroup,'SelectedTab',tabs(selectedTab+1));
    elseif strcmp(eventdata.Key,'leftarrow')==1 && selectedTab > 1
        set(tabGroup,'SelectedTab',tabs(selectedTab-1))
    end
end

function openFigFun(hObject,eventdata)
    [FileName,PathName] = uigetfile('*.fig','MultiSelect','on');
    if PathName==0
        return
    end
    if ~iscell(FileName)
        FileName = {FileName};
    end
    for i = 1:numel(FileName)
        f(i) = openfig([PathName FileName{i}],'new','invisible');
    end
    figs2tabs(f);
    fclose('all');    
end

function [tabbedFig,tabGroupH] = init_figure
    %create tabbed figure
    tabbedFig = figure('Name','MATLAB Tabbed GUI', ... %title bar text
        'Tag','tabbedWindow',... 
        'NumberTitle','off', ... %hide figure number in title
        'MenuBar','none',...
        'ToolBar','figure',...
        'IntegerHandle','off',... %use number like 360.0027 instead of 1,2, or 3
        'Resize','on'); %allow user to resize, TODO make contents normalized to allow for proportional resizing
    %create a tab group
    tabGroupH = uitabgroup; 
    set(tabGroupH,'SelectionChangeCallback',@update_guidata_and_resize)       
    set(tabbedFig,'ResizeFcn',@resizeHandler)
    set(tabGroupH,'Parent',tabbedFig)
    drawnow
end

function resizeHandler(hObject,eventdata)
    resizeTabContent(hObject);
end

function resizeTabContent(parentFigure)
    toResize=findall(parentFigure,'Type','axes');
    if isempty(toResize)
        return;
    end
    toResize = toResize(strcmp(get(toResize,'Tag'),'legend')==0);
    newPos = get(parentFigure,'Position');
    newPos = [60 60 newPos(3)-150 newPos(4)-125];
    set(toResize,'Position',newPos)
end

function initialize_tab_group(tabbedFig, tabGroupH)
    %set the first tab as active and update position
    curTabNum = 1;
    set(tabGroupH,'SelectedIndex',curTabNum)
    set(tabGroupH,'Parent',tabbedFig)
    toLink = findall(tabbedFig,'Type','axes');
    toLink = toLink(strcmp(get(toLink,'Tag'),'legend')==0);    
    for i = 2:numel(toLink)
        if sum(get(toLink(i),'Xlim') - get(toLink(i-1),'Xlim'))==0 && ...
           sum(get(toLink(i),'Ylim') - get(toLink(i-1),'Ylim'))==0
            linkaxes(toLink)
        end
    end
end

function add_tab(tabbedFig, tabGroupH, figHandle, tabNum)
    %get all children a standalone figure
    allChildren = get(figHandle,'Children');

    %isolate type "uimenu"
    %determine types of children
    types = get(allChildren,'Type');
    types = confirm_cell(types);
    uiMenuIndxsBool = cregexp(types,'uimenu');

    %add all children except those of type "uimenu"
    validChildren = allChildren(~uiMenuIndxsBool);
    set(figHandle,'Units','Pixels');
    set(validChildren,'Units','Pixels');

    % get name of the standalone figure
    figName = get(figHandle,'fileName');
    figName = char(regexp(figName, 'sample[1-9].*channel_[1-9]', 'match'));
    if isempty(figName) || strcmp(figName,' ')
        figName = ['tab ' num2str(tabNum)];
    end

    % create a tab
    thisTabH = uitab(tabGroupH, ...
        'Title', figName, ...
        'UserData',tabNum, ...
        'Tag',get(figHandle,'Tag'), ... %make the original tabbedFig's tag this tab's tag
        'DeleteFcn',get(figHandle,'DeleteFcn'));%make the original tabbedFig's DeleteFcn this tab's DeleteFcn

    % move objects from standalone figure to tab
    set(validChildren,'Parent',thisTabH);
    set(thisTabH,'UserData',get(figHandle,'UserData'))
    % close standalone figure since it has been "gutted" and placed onto a tab
    delete(figHandle);
end

function update_guidata_and_resize(varargin)

    resizeTabContent(gcf);       
    
    %force redraw
    pause(0.01)
    drawnow
end

function outCell = confirm_cell(inArg)
    if ~iscell(inArg)
        outCell = {inArg};
    else
        outCell = inArg;
    end
end

function bool=cregexp(cellStrArray,pat)
    %returns boolean array true at indices where pat is found in cellStrArray
    cellStrArray = confirm_cell(cellStrArray);
    bool = ~cellfun(@isempty,regexp(cellStrArray,pat));
end