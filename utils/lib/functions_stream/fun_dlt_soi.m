function [a, m]= fun_dlt_soi(a)
%����yΪsos�γ���ǵ�δ�����ͼƬ����ѹ������
%���yΪȥ��255֮��SOI��ͼƬ����ѹ������
s = [1;0;1;0; 1;1;1;1;1;1;1;1; 1;1;0;1; 1;0;0;1];
for i = 1:length(a)-19
    if(a(i:i+19)==s)
        m = i + 4;
        for k = i+4:length(a)-16
            a(k) = a(k+16);
        end
        break;
    end
end
a = a(1:length(a)-16);
end