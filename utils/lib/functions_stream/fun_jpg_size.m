function [m,n,blkm,blkn]=fun_jpg_size(z,a)
%mnͼ���С
%blkm,blkn�ж��ٿ�8*8���ڻҶ�ͼ
b=find(z(a+1,1)==192);
c=a(b,1); %255���������
m=z((c+5),1)*16*16+z((c+6),1);  %m nΪͼƬ�ĸߺͿ�
n=z((c+7),1)*16*16+z((c+8),1);
blkm=ceil(m/8); blkn=ceil(n/8); %����8�ı��������ٷָ�
end