function y= fun_dlt_zero(y)
%����yΪsos�γ���ǵ�δ�����ͼƬ����ѹ������
%���yΪȥ��255֮�����ͼƬ����ѹ������
a=find(y==255);
b=find(y(a+1,1)==0);
[m,n]=size(a);
i=0;
for j=1:m
       y(a(j,1)+1-i)=[];    
          i=i+1; 
end
  
end

