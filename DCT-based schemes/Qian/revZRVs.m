function [zigzag] = revZRV(ZRVs)
%REVZRVS ��ZRV����ת����һάzigzag���������
zigzag = zeros(1,64);
flag = 1;
for i = 1:numel(ZRVs(:,1))
    flag = flag + ZRVs(i,2)+1;
    zigzag(flag) = ZRVs(i,2);
end
end

