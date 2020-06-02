function [outbin63,capacity63,unitdistortion63]=getuintcost63bin(bin63,Q_cost)
outbin63=zeros(63,1);
capacity63=zeros(63,1);
unitdistortion63=zeros(63,1);
id=0;
    for i=1:8
        for j=1:8
            if ((i+j)~=2)
                id=id+1;
                temp=bin63(id,:);
                capacity63(id)=length(find(abs(temp)==1));  %�ҵ�λ��������Ϊ1������
                outbin63(id)=length(find(abs(temp)>1));      %�ҵ�λֵ�����д���1������ 
                cost=sum(sum( Q_cost(:,:,id).^2 ));
                 cost=sqrt(cost/64);
                  distortion=(0.25*capacity63(id)+outbin63(id))*cost;         %ÿ��λ��ϵ��������ʧ��
%                  distortion=cost;  
                if capacity63(id)==0
                unitdistortion63(id)=10000000;
                else
                unitdistortion63(id)=distortion /(capacity63(id));
                end
%                  unitdistortion63(id)=Q_cost(i,j);
            end
        end
    end

end