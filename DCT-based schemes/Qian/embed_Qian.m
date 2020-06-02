function [ZRVs,embedNum] = embed_Qian(ZRVs,R,secret,embedNum)
%EMBEDHS 对8*8的矩阵进行信息嵌入,输入ZRV序列，根据当前R值选择对应的ZRV用于数据嵌入;
loc = find(ZRVs(:,2) == R);%run = R的ZRV对的相对位置
if ~isempty(loc)
    for i=1:numel(loc(:,1))
        if abs(ZRVs(loc(i),4)) == 1 && embedNum < numel(secret)
            v = ZRVs(loc(i),4);
            ZRVs(loc(i),4) = v + sign(v)*secret(embedNum+1);%嵌入1bit
            embedNum = embedNum + 1;
        elseif abs(ZRVs(loc(i),4)) > 1 && embedNum < numel(secret)
            v = ZRVs(loc(i),4);
            ZRVs(loc(i),4) = v + sign(v);
        elseif embedNum == numel(secret)
            break;      
        end
    end
end
end

