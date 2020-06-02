function [fi, psnr,runtime] = RDH_Qian(name_cover,secret,is_optimized)
%paper:Reversible Data Hiding in JPEG Images Using Ordered Embedding
t1 = clock;
%% Extract information
jpg_obj = jpeg_read(name_cover);
jpg_obj.optimize_coding = is_optimized;
dct = jpg_obj.coef_arrays{1, 1};
payload = numel(secret);
[m,n] = size(dct);
%% Embed
blk_dct = mat2cell(dct,ones(m/8,1)*8,ones(n/8,1)*8);%��DCT����ֿ�
A = cellfun(@(x) sum(sum(x(2:64)~=0)), blk_dct);%ÿ���DCϵ���ⲻΪ0�ĸ���
B = cellfun(@(x) sum(sum(x(2:64)==1|x(2:64)==-1)), blk_dct);%ÿ���DCϵ����ֵΪ����1�ĸ������غɣ�
%����������̬����������������С��T
capacity = 0;
for i=1:64
    if capacity < payload
        stBlkInd = find(A<=i);
        capacity = sum(B(stBlkInd));
    end
end
S = blk_dct(stBlkInd);

%��ÿ��zigzagɨ�貢��Ϊ1*64����
C = cellfun(@(x) zigzag(x), S,'UniformOutput',false);

%��zigzagɨ��������ת����ZRV����ʽ
D = cellfun(@(x) get_zrv(x), C,'UniformOutput',false);

%����ZRV���м�¼ÿ��R������
E = cellfun(@(x) get_run_num(x), D,'UniformOutput',false);

F = [E{:}];

embedNum = 0;   %��ǰ��Ƕ��������
for i = 1 : 16
    m = max(F(i,:));
    for j = 1:m
        loc = find(F(i,:)==j);%��ȡֻ����j��ZRV��RΪi-1�Ŀ�����
        for k = 1:numel(loc)
            [D{loc(k)},embedNum] = embed_Qian(D{loc(k)},i-1,secret,embedNum);%��������ϢǶ�뵱ǰѡ�п�
        end
    end
end
%��Dת����һά���к��ٷ�zigzagɨ��ת����8*8�������滻ԭ��λ�õ�8*8���󣬷����µ�����DCT����
rev_zrv = cellfun(@(x) reverse_zrv(x), D,'UniformOutput',false);%��ZRV��任Ϊzigzag����
rev_zigzag = cellfun(@(x) reverse_zigzag(x), rev_zrv,'UniformOutput',false);%��zigzag������任Ϊ8*8����
stego_dct = blk_dct;
for i = 1:numel(rev_zigzag)
    rev_zigzag{i}(1) = blk_dct{stBlkInd(i)}(1);
    stego_dct{stBlkInd(i)} = rev_zigzag{i};
end
stego_dct = cell2mat(stego_dct);
stego_jpg_obj = jpg_obj;
stego_jpg_obj.coef_arrays{1,1} = stego_dct;
%% Generate the marked JPEG bitstream
name_stego = 'stego.jpg';
jpeg_write(stego_jpg_obj, name_stego);
%% Perfomance analysis
stego = imread(name_stego);
cover = imread(name_cover);
cover_file = imfinfo(name_cover);
stego_file = imfinfo(name_stego);
fi = (stego_file.FileSize - cover_file.FileSize) * 8;
psnr = compute_psnr(stego, cover);
t2 = clock;
runtime = etime(t2,t1);
end


