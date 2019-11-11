function [zigzag] = revZRVs(ZRVs)
%REVZRVS convert the ZRV pairs into one 1*64 zigzag-scanned vector.
zigzag = zeros(1,64);
flag = 1;
for i = 1:numel(ZRVs(:,1))
    flag = flag + ZRVs(i,2) + 1;
    zigzag(flag) = ZRVs(i,4);
end
end

