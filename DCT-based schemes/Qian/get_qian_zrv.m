function [ZRVs] = get_qian_zrv(Z)
%genZRVs ��zigzagɨ��������ת����ZRV����ʽ, Z:1*64
Z = Z(2:64);%ȥ��DCϵ��
num = sum(sum(Z~=0));
ZRVs = zeros(num,2);
index = find(Z~=0);
for i = 1:num
    if i == 1
        ZRVs(i,:) = [index(i)-1,Z(index(i))];
    else
        ZRVs(i,:) = [index(i)-index(i-1)-1,Z(index(i))];
    end
end
end

