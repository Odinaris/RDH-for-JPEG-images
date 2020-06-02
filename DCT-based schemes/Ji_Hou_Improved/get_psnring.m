function [ add,vd_distor] = get_psnring(simulate_dct,dct,jpeg_info)    %����̰���㷨����Ƕ������
%�����Ĺ���Ϊ����̰��׼�����һ�����ʵ�Ƕ������
table = jpeg_info.quant_tables{1};
[m,n]=size(dct);
add=zeros(m,n);
distor=zeros(m,n);  %һ����m*n������Ҫ����ʧ��
vd_distor=zeros(m,n);  %����VDʧ��
for i=1:m
    for j=1:n
        temp_1=dct{i,j};     %ѡ��8��8��dct��
        temp_2=simulate_dct{i,j}; %ѡ��ģ���8*8�Ŀ�
        temp=table.*(temp_2-temp_1);            %�����������ϵ����
        pixel_d=IDCT(temp);                    %���任���򡪡����ز�
        distor(i,j)=sum(sum(pixel_d.^2));    %���㵱ǰ��ʧ��
       vd_distor(i,j)=distor(i,j);%./counter_1(k);           %����VDʧ��/����
       %�ļ����Ͷȼ���
     	size2 = getcodelength( temp_1,jpeg_info );        
        size1 = getcodelength( temp_2,jpeg_info );
        if size2 == 0
        else
            add(i,j) = (size1 - size2);
        end
    end
end 
end

