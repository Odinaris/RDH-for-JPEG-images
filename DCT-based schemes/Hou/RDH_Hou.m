function [fi, psnr,runtime] = RDH_Hou(name_cover, secret, is_optimized)
t1 = clock;
jpg_obj = jpeg_read(name_cover);
jpg_obj.optimize_coding = is_optimized;
dct = jpg_obj.coef_arrays{1,1};
stego_jpg_obj = jpg_obj;
payload = numel(secret);
Q_table=jpg_obj.quant_tables{1};
%% Ԥ����
PSNR=zeros(1,64);
INCRE=zeros(1,64);
%���������ÿ�����ӷ��ص������п��������ز�����Ӱ��
Q_cost=costFun(Q_table);      
%���г��ÿ��DCT����ijλ�õ�ϵ��Ϊһ�У���ͬλ��Ϊһ���γɾ���
bin63 = get63bin(dct);          
[outbin,capacity,unitDistortion] = getuintcost63bin(bin63,Q_cost);
[unitDistortion,sortIndex] = sort(unitDistortion);        %��ʧ�������������õĿ�ϵ����sort_index
for selectNum = 12:3:3*floor(length(sortIndex)/3)                %%��������selectNum������psnrѰ����ѵĿ�Ƕ������K
    sel_index = sortIndex(1:selectNum);
    M = matrix_index(sel_index);                 %������Ǿ���M
    DCT = mark(M,dct);                          %û���⣬����ѡ��ϵ�����DCT��
    % ģ���޸�ͼƬ����Ƕ������
    simulate_dct = simulate(DCT);         %ģ���޸ĺ��ͼƬ������simulate_dct
    counter_1 = computeCapacity(DCT,1);
    counter_0 = computeCapacity(DCT,0);
    [counter_0,sort_0] = sort(counter_0);
    table = Q_table;
    [order,vd_distor] = select_block2(simulate_dct,DCT,table,counter_1);   %����ģ���޸ĵķ���̰���㷨��ʧ���С������һ��Ƕ��ͼƬ������,��������ʧ������
    % ����Ƕ�����У�����ϢǶ��ͼƬ
    for r = 1:length(order)                                    %Ѱ��Ƕ���ٽ�ֵ
        if (sum(counter_1(order(1:r)))>=payload)            %��ÿ������1����Ŀ
            order = order(1:r);
            sort_0 = sort_0(1:r);
            break;
        end
    end
    [stegoDct,tag] = generate_stego(order,DCT,secret,payload);       %����Ƕ���DCTϵ��
    if tag==1
        continue;
    end
    stego_dct = recoverstego(dct,stegoDct,sel_index);         %�ָ�����ϵ��
    stego_jpg_obj.coef_arrays{1} = stego_dct;                     %�޸ķ���
    name_stego = strcat('stego.jpg');
    jpeg_write(stego_jpg_obj,name_stego);
    %% ����ʧ�����������
    stego = imread(name_stego);
    cover = imread(name_cover);
    psnr_goad = compute_psnr(stego,cover);
    file_cover = imfinfo(name_cover);
    file_stego = imfinfo(name_stego);
    fs_stego = file_stego.FileSize * 8;
    fs_cover = file_cover.FileSize * 8;
    incre_bit = fs_stego - fs_cover;
    PSNR(selectNum) = psnr_goad;
    INCRE(selectNum) = incre_bit;
end
[psnr,index] = max(PSNR);	%����psnr
fi = INCRE(index);	%�����ļ�����
t2 = clock;
runtime = etime(t2,t1);
end

