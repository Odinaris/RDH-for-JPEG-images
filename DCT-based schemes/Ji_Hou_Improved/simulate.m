function [ shift_block] = simulate(dct_block )
[m,n]=size(dct_block);
m=m/8;
n=n/8;
shift_block=dct_block;
for i=1:m
    for j=1:n
     temp=dct_block(8*(i-1)+1:8*i,8*(j-1)+1:8*j);    
        for ii=1:8           %ֻ�޸�һ����
             for jj=1:8
                     if (ii+jj>2)   %ֻ�޸�ACλ
                            if abs(temp(ii,jj))>1    %��ǰ��һλ����1
                                temp(ii,jj)=temp(ii,jj)+sign(temp(ii,jj));  %�������޸�  
                            end
                            if abs(temp(ii,jj))==1               %��ǰ��һλΪ1����-1
                                temp(ii,jj)=temp(ii,jj)+sign(temp(ii,jj));    %��1����Ƕ��
                            end
                            
                     end
             end
        end
         shift_block(8*(i-1)+1:8*i,8*(j-1)+1:8*j)=temp;
    end
end







        


end

