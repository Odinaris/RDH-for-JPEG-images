function side = get_side(payload,positions)
side=zeros(1,81);
b = num2bin(quantizer([18 0]),payload);
b = strcat(char(b)','');
b = str2num(b(:));
side(1:18) = b;
len = length(positions);
for i=1:len
    side(positions(i)+18) = 1;
end
end