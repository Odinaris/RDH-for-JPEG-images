function [height, width] = fun_read_sof_wh(a,z)
%��ȡSOF(Start Of Frame)������ȡͼ��ĳ���
b=find(z(a+1)==192);
b=b(length(b),1);
c=a(b,1); %255���������
height = z(c+5:c+6, 1);
width = z(c+7:c+8, 1);
end
