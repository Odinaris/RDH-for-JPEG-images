function [ counter ] = count( dct,x )
%����ÿ��8��8���Ƕ������
[m,n]=size(dct);
m=m/8;
n=n/8;
counter=zeros(1,m*n);  %���㵱ǰ���Ƕ������
k=0;
for i=1:m
    for j=1:n
    temp=dct(8*(i-1)+1:8*i,8*(j-1)+1:8*j);
    k=k+1;
    counter(k)=length(find(abs(temp)==x));
    end
end
end

