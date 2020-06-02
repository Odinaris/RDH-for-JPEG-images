function R = get_R(quant_tables,num_ac)
R=zeros(63,2);
for count=1:63
    R(count,1) = count;
    R(count,2) = sum(num_ac(count,1)/(num_ac(count,1)/2+num_ac(count,2))/quant_tables(count+1)^2);
end
R=sortrows(R,-2);
end