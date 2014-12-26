classdef ML_HASH < handle
    % A simple hash class
    % By Minh Hoai Nguyen (minhhoai@robots.ox.ac.uk)    
    % Date: 5 Aug 2012
    
    properties
        size = 1000;
        map = cell(1, 1000);
        nKey = 0;
    end
    
    methods
        function obj = ML_HASH(sz)
            obj.size = sz;
            obj.map = cell(1, sz);
        end;
        
        % Add a pair of key-value
        % key: must be a string
        function add(obj, key, value)
            hashKey = obj.key2hashKey(key);
            k = length(obj.map{hashKey});
            isExist = 0;
            for i=1:k
                if strcmp(obj.map{hashKey}{i}.key, key)
                    obj.map{hashKey}{i}.value = value;
                    isExist = 1;
                    break;
                end;
            end;

            if ~isExist
                obj.map{hashKey}{k+1}.key = key;
                obj.map{hashKey}{k+1}.value = value;
                obj.nKey = obj.nKey + 1;
            end;            
        end;
                        
        % retrieve value for a key
        % key: must be a string
        function value = get(obj, key)
            hashKey = obj.key2hashKey(key);
            k = length(obj.map{hashKey});
            for i=1:k
                if strcmp(obj.map{hashKey}{i}.key, key)
                    value = obj.map{hashKey}{i}.value;
                    return;
                end;
            end;
            value = [];            
        end;
        
        % remove the key-value pair that corresponds to key
        function remove(obj, key)
            hashKey = obj.key2hashKey(key);
            k = length(obj.map{hashKey});
            for i=1:k
                if strcmp(obj.map{hashKey}{i}.key, key)
                    obj.map{hashKey}(i) = [];
                    obj.nKey = obj.nKey - 1;
                    return;
                end;
            end;
        end;
        
        % Get all keys
        function keys = getKeys(obj)
            keys = cell(1, obj.nKey);
            cnt = 0;
            for i=1:obj.size
                for j=1:length(obj.map{i})
                    cnt = cnt + 1;
                    keys{cnt} = obj.map{i}{j}.key;
                end;                
            end;            
        end;
    end
    
    methods (Access = private)
        function hashKey = key2hashKey(obj, key)
            w = lower(strtrim(key));
            hashKey=mod(sum(w.*(1:length(w))), obj.size)+1;
        end
    end;
    
end


