function [ stego_dct] = recoverstego(dct,stego1_dct,sel_index)
%����stego1_dct������dct�������յ�stego_dct
[m,n]=size(dct);
m=m/8;
n=n/8;
stego_dct=dct;
for i=1:m
    for j=1:n
        temp1=stego_dct(8*(i-1)+1:8*i,8*(j-1)+1:8*j);
        temp2=stego1_dct(8*(i-1)+1:8*i,8*(j-1)+1:8*j);         %ѡ��
           for p=1:length(sel_index)                         %�Կ��Ƕ��λ�����޸�
                 row=ceil((sel_index(p)+1)/8);
                 col=mod(sel_index(p),8)+1;
                 temp1(row,col)=temp2(row,col);
           end
          stego_dct(8*(i-1)+1:8*i,8*(j-1)+1:8*j)=temp1;
    end
end
                           
end

