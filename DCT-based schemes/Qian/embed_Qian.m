function [ZRVs,embedNum] = embed_Qian(ZRVs,R,secret,embedNum)
%EMBEDHS ��8*8�ľ��������ϢǶ��,����ZRV���У����ݵ�ǰRֵѡ���Ӧ��ZRV��������Ƕ��;
loc = find(ZRVs(:,2) == R);%run = R��ZRV�Ե����λ��
if ~isempty(loc)
    for i=1:numel(loc(:,1))
        if abs(ZRVs(loc(i),4)) == 1 && embedNum < numel(secret)
            v = ZRVs(loc(i),4);
            ZRVs(loc(i),4) = v + sign(v)*secret(embedNum+1);%Ƕ��1bit
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

