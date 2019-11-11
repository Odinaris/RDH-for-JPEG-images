
function actable=fun_huff_actable(y)
%����DHT�Σ����AC��huffman�������run/size/length����

bit=y(6:21,1);
length2=sum(bit); 
huffval2=y(22:22+length2-1,1);

q=1;           
for l=1:16
    i =bit(l,1);
    while(i)>0
        i=i-1;
        huffsize2(q,1)=l;  %huffsize��¼�ֽڳ���size
        q=q+1;
    end
end
huffsize2(q,1) = 0;

code=0;
si=huffsize2(1,1);
p=1;
while(huffsize2(p,1))>0
    while(huffsize2(p,1))==si
        huffcode2(p,1)=code;  %huffcode��¼��Ӧsize�Ķ�����
        p=p+1;
        code=code+1;
    end
    code=bitshift(code,1);
    si=si+1;
end
huffsize2(q) = [];
for l=1:length2                       %accode����ת��Ϊ�����ƴ������accodebin
    for p=1:huffsize2(l,1)
        accodebin(l,p)=rem(huffcode2(l,1),2);
       huffcode2(l,1)=fix(huffcode2(l,1)/2);        
        p=p+1;
    end
    accodebin(l,:)=fliplr(accodebin(l,:));
    l=l+1;
end
acorder=[huffval2 huffsize2 accodebin];
acorder=sortrows(acorder,1);          %����ÿ�����ֵ�Ȩ������õ�run/size



run=floor(acorder(:,1)/16);
size=mod(acorder(:,1),16);
actable=[run size size+acorder(:,2) acorder(:,2:end)];
end
