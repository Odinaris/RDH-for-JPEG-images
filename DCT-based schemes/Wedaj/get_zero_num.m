function [zeronum]=get_zero_num(Blockdct)
[m,n] = size(Blockdct); 
zeronum=zeros(m*n/64,3);
count=1;
for r=1:m
    for c=1:n
        zeronum(count,1)=r;
        zeronum(count,2)=c;
        zeronum(count,3)=sum(Blockdct{r,c}(:)==0);
        count=count+1;
    end
end
zeronum=sortrows(zeronum,-3);
end