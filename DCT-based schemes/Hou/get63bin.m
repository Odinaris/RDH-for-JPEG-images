function bin63=get63bin(DCT)
[m,n]=size(DCT);
id=0;
bin63=zeros(63,m*n/64);
for i=1:8
    for j=1:8
        if ((i+j)~=2)
            pos=zeros(8,8);
            pos(i,j)=1;
            pos=logical(pos);
            pos=repmat(pos,m/8,n/8);     %��A��������m/8��n/8��
            temp=DCT(pos);               %��ÿһ��dct���е�ij��λ�õ�DCTϵ��������γ�����
            id=id+1;
            bin63(id,:)=temp(:);  
            
        end
    end
end

end
