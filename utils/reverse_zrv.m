function [zigzag] = reverse_zrv(ZRVs)
%REVZRVS ��ZRV����ת����һάzigzag���������
zigzag = zeros(1,64);
for i = 1:numel(ZRVs(:,1))
    zigzag(ZRVs(i,1)+1) = ZRVs(i,4);
end
end

