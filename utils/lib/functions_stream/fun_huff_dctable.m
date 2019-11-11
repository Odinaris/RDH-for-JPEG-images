function [dctable,dctablegui]=fun_huff_dctable(y)
%�����ļ�ͷ��DHT�Σ����dc��huffman�������cat����
bit=y(6:21,1);
dchuffnum=sum(bit);       %dchuffnum������������
dccat=y(22:22+dchuffnum-1,1);

q=1;           
for l=1:16
    i =bit(l,1);
    while(i)>0
        i=i-1;
        dccl(q,1)=l;      %dcclΪdc��code length��¼ÿ��huffman���ֵĳ���
        q=q+1;
    end
end
dccl(q,1) = 0;

code=0;
si=dccl(1,1);
p=1;

 while(dccl(p,1))>0 
    while(dccl(p,1))==si
       dccode(p,1)=code;  %dccode��¼��Ӧsize�Ķ�����
        p=p+1;
        code=code+1;
    end
    code=bitshift(code,1);
    si=si+1;
 end
 dccl(q) = [];

for l=1:dchuffnum                        %ת��Ϊ�����ƴ������dctable
    for p=1:dccl(l,1)
        dctable(l,p)=rem(dccode(l,1),2);
        dccode(l,1)=fix(dccode(l,1)/2);        
        p=p+1;
    end
    dctable(l,:)=fliplr(dctable(l,:));
    l=l+1;
end
dctable=[dccat dccl dctable];
dctable=sortrows(dctable,1); 
dctablegui=dctable;
dctable(:,1)=[];
end

  


    
    


