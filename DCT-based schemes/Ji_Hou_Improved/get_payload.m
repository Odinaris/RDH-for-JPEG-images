 function payload = get_payload(S)
 [m,n] = size(S);
 payload=zeros(m,n);
 for i=1:m
    for j=1:n
        payload(i,j)=sum(sum(S{i,j}==1))+sum(sum(S{i,j}==-1)); %�˿���Ϊ1��-1�ĸ���
    end
 end
        