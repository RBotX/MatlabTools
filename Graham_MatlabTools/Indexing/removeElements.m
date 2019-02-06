function protoSigs = removeElements(protoSigs,varargin)
    for i = 1:numel(varargin)
        protoSigs(varargin{i}) = [];
    end
end

