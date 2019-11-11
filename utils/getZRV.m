function ZRVs = getZRV(Z)
%genZRV Convert the 1*64 zigzag-scanned vector into the form of ZRV pairs.
Z = Z(2:64);    % Remove the DC coefficient.
num = sum(sum(Z~=0));
ZRVs = zeros(num,4);
index = find(Z~=0);
for i = 1:num
    value = Z(index(i));
    size = length(dec2bin(abs(value)));
    if i == 1
        run = index(i)-1;
        ZRVs(i,:) = [index(i),run,size,value];
    else
        run = index(i)-index(i-1)-1;
        ZRVs(i,:) = [index(i),run,size,value];
    end
end 
end

