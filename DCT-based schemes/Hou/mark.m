function [ DCT ] = mark(M,dct)
%����M���ÿһ��dct�飬������Ǻ�ľ���DCT
[m,n]=size(dct);
m=m/8;
n=n/8;
DCT=dct;
 for i=1:m
    for j=1:n
        temp_1=dct(8*(i-1)+1:8*i,8*(j-1)+1:8*j);     %ѡ��8��8��dct��
         temp=M.*temp_1;                           %��Ǻ��8��8��
        DCT(8*(i-1)+1:8*i,8*(j-1)+1:8*j)=temp;
    end
end

