function [ZRVs,index] = embed(ZRVs, R, data,index)
loc = find(ZRVs(:,2) == R);
if ~isempty(loc)
    for i = 1:numel(loc(:,1))
        if index == numel(data)
            break;
        end
        v = ZRVs(loc(i),4);
        if abs(v) == 1 && index < numel(data)
            ZRVs(loc(i),4) = v + sign(v) * data(index+1);
            index = index + 1;
        elseif abs(v) > 1
            ZRVs(loc(i),4) = v + sign(v);
            
        end
    end
end

