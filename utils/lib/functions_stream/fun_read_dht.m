function y= fun_read_dht( a,z,f,num )
%��ȡ�ļ�ͷ�е�DHT��
b=find(z(a+1,1)==196);    %�����a����������
b=b(num,1);  %���������a������
c=a(b,1);  %255���������
d=z((c+2),1)*16*16+z((c+3),1);  %������ֽڳ���
status=fseek(f,c-1,'bof');
y=fread(f,d+2,'uint8');
end

