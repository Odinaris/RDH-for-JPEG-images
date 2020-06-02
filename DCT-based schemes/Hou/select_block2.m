function [ order,vd_distor] = select_block2(simulate_dct,dct,table,counter_1)    %����̰���㷨����Ƕ������
%�����Ĺ���Ϊ����̰��׼�����һ�����ʵ�Ƕ������
[m,n]=size(dct);
m=m/8;
n=n/8;
distor=zeros(1,m*n);  %һ����m*n������Ҫ����ʧ��
vd_distor=zeros(1,m*n);  %����VDʧ��
%bd_distor=zeros(1,m*n);  %����BDʧ��
k=0;
for i=1:m
    for j=1:n
        temp_1=dct(8*(i-1)+1:8*i,8*(j-1)+1:8*j);     %ѡ��8��8��dct��
        temp_2=simulate_dct(8*(i-1)+1:8*i,8*(j-1)+1:8*j); %ѡ��ģ���8*8�Ŀ�
        temp=table.*(temp_2-temp_1);            %�����������ϵ����
        pixel_d=IDCT(temp);                    %���任���򡪡����ز�
         k=k+1;                                    %��ǰΪ���ſ������
        distor(k)=sum(sum(pixel_d.^2));    %���㵱ǰ��ʧ��
       vd_distor(k)=distor(k);%./counter_1(k);           %����VDʧ��/����
%        bd_distor(k)=counter_0(k)/counter_1(k);
    end
end
          
        
       
 %%%%%%%%%%%%%%%%%��distor��������,��Ƕ����Ϣ����¼������%%%%%%%%%%%%%%
 [vd_distor,order]=sort(vd_distor);            %Ƕ������
% order=fliplr(order);                          %��ת����ɽ���
 




        
        
        
        
      
        
    
end

