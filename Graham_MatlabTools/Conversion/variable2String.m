%DESCRIPTION: Takes any number of variables and outputs their names in string form -- 
%good for dynamic programming.

%INPUT:
%------------------------------------------------------------
% varargin: (Nx1) all variables for which you want to return their names as strings

%OUTPUT:
%------------------------------------------------------------
% names: (Nx1 cell array of strings) names of variables passed in, in string form
% isEmpty: (Nx1 boolean) 1 if variable had values in it, 0 otherwise
function [names,isEmpty] = variable2String(varargin)
    names = cell(nargin,1);
    isEmpty = zeros(nargin,1);
    for i = 1:nargin
        names{i} = inputname(i);
        if isempty(varargin{i})
            isEmpty(i) = 1;
        end
    end
end