function [fi,psnr,runtime] = RDH_Ji(name_cover, secret)
t1 = clock;
jpg_obj = jpeg_read(name_cover);
dct = jpg_obj.coef_arrays{1};
qt = jpg_obj.quant_tables{1};
img_cover = imread(name_cover);
payload = numel(secret);
PSNR=zeros(1,64);
INCRE=zeros(1,64);
Q_cost=costFun(qt);            %���������ÿ�����ӷ��ص������п��������ز�����Ӱ��
bin63=get63bin(dct);          %���г��ÿ��DCT����ijλ�õ�ϵ��Ϊһ�У���ͬλ��Ϊһ���γɾ���
[~,~,unitdistortion63]=getuintcost63bin(bin63,Q_cost);
[~,sort_index]=sort(unitdistortion63);        %��ʧ�������������õĿ�ϵ����sort_index
for selnum=12:3:3*floor(length(sort_index)/3)                %%��������selnum������psnrѰ����ѵĿ�Ƕ������K
    sel_index=sort_index(1:selnum);
    M=matrix_index(sel_index);                 %������Ǿ���M
    DCT=mark(M,dct);                          %û���⣬����ѡ��ϵ�����DCT��%%%
    sum_R = sum_payload(DCT);
    if sum_R < payload
        continue;
    end
    simulate_dct=simulate(DCT);         %ģ���޸ĺ��ͼƬ������simulate_dct
    counter_1=countDCT(DCT,1);
    table=jpg_obj.quant_tables{1};
    [order,~]=select_block2(simulate_dct,DCT,table,counter_1);   %����ģ���޸ĵķ���̰���㷨��ʧ���С������һ��Ƕ��ͼƬ������,��������ʧ������
    for r=1:length(order)                                    %Ѱ��Ƕ���ٽ�ֵ
        if (sum(counter_1(order(1:r)))>=payload)            %��ÿ������1����Ŀ
            order=order(1:r);
            break;
        end
    end
    [stego1_dct,tag]=generate_stego(order,DCT,secret,payload);       %����Ƕ���DCTϵ��
    if tag==1
        continue;
    end
    stego_dct=recoverstego(dct,stego1_dct,sel_index);         %�ָ�����ϵ��
    jpg_obj.coef_arrays{1} = stego_dct;
    name_stego = 'stego.jpg';
    jpeg_write(jpg_obj,name_stego);
    img_stego = imread(name_stego);
    psnr=compute_psnr(img_stego,img_cover);
    cover_file = imfinfo(name_cover);
    stego_file = imfinfo(name_stego);
    incre_bit = (stego_file.FileSize - cover_file.FileSize) * 8;
    
    PSNR(selnum)=psnr;
    INCRE(selnum)=incre_bit;
end %�ҵ�����K
[~,index]=max(PSNR);                            %�ҵ���õ�psnr
%% �����������ҵ�����K
sel_index=sort_index(1:index);
M=matrix_index(sel_index);                 %������Ǿ���M
DCT=mark(M,dct);                          %��ʱƵ��λ��ȷ��֮���DCT��Ϊ�����ź�%%%
simulate_dct=simulate(DCT);         %ģ���޸ĺ��ͼƬ������simulate_dct
[M,N] = size(DCT);
ori_Blockdct = mat2cell(DCT,8 * ones(1,M/8),8 * ones(1,N/8));%��ԭ����ͼ�����ָ��N��8*8��Block
simulate_dct = mat2cell(simulate_dct,8 * ones(1,M/8),8 * ones(1,N/8));%��ģ��Ƕ���ͼ�����ָ��N��8*8��Block
dct_block = mat2cell(dct,8 * ones(1,M/8),8 * ones(1,N/8));
[ simulate_dct ] = stego( simulate_dct,dct_block,sel_index ); %�ָ�����ϵ��
[add,psnring]=get_psnring(simulate_dct,dct_block,jpg_obj);   %��ȡǶ�����
R=get_payload(ori_Blockdct);
[M,N] = size(ori_Blockdct);
%%
E1=reshape(add,M*N,1);
D1=reshape(psnring,M*N,1);
E = E1'; %ת��Ϊһ�С�
E = mapminmax(E, 0, 1); % ��һ����
E = reshape(E, size(E1)); %
D = D1'; %ת��Ϊһ�С�
D = mapminmax(D, 0, 1); % ��һ����
D = reshape(D, size(D1)); %
R=reshape(R,M*N,1);
C=payload;
options = optimoptions('intlinprog','MaxTime',120,'Display','off');
[~,g1] = intlinprog(E',1:M*N,-R',-C,[],[],zeros(M*N,1),ones(M*N,1),options);%�������FSE
A = [-R';E'];
alpha = 1;  %Ȩ��ֵ
g = g1 + abs(alpha*g1);
b = [-C;g];
x=intlinprog(D',1:M*N,A,b,[],[],zeros(M*N,1),ones(M*N,1),options); %��Ŀ��������߱�����������FSEʱ������PSNR��Ӧ�ľ��߱���
%xΪѡ����Щ������������
x=uint8(reshape(x,M,N));
[stego1_dct] = jpeg_emdding(secret,ori_Blockdct,x);       %����Ƕ���DCTϵ��
[M,N] = size(dct);
dct_block = mat2cell(dct,8 * ones(1,M/8),8 * ones(1,N/8));
[ stego_dct ] = stego( stego1_dct,dct_block,sel_index ); %�ָ�����ϵ��
jpg_obj.coef_arrays{1} = cell2mat(stego_dct);
jpeg_write(jpg_obj,name_stego);
img_stego = imread(name_stego);
cover_file = imfinfo(name_cover);
stego_file = imfinfo(name_stego);
fi = (stego_file.FileSize - cover_file.FileSize) * 8;
psnr = compute_psnr(img_stego, img_cover);
%%
poolobj = gcp('nocreate');
delete(poolobj);
t2 = clock;
runtime = etime(t2,t1);
end

