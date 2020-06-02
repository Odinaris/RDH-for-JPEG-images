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
blk_dct = mat2cell(dct,ones(m/8,1)*8,ones(n/8,1)*8);%将DCT矩阵分块
A = cellfun(@(x) sum(sum(x(2:64)~=0)), blk_dct);%每块除DC系数外不为0的个数
B = cellfun(@(x) sum(sum(x(2:64)==1|x(2:64)==-1)), blk_dct);%每块除DC系数外值为正负1的个数（载荷）
%根据容量动态计算满足容量下最小的T
capacity = 0;
for i=1:64
    if capacity < payload
        stBlkInd = find(A<=i);
        capacity = sum(B(stBlkInd));
    end
end
S = blk_dct(stBlkInd);

%将每块zigzag扫描并化为1*64向量
C = cellfun(@(x) zigzag(x), S,'UniformOutput',false);

%将zigzag扫描后的序列转换成ZRV对形式
D = cellfun(@(x) get_zrv(x), C,'UniformOutput',false);

%将从ZRV对中记录每组R的数量
E = cellfun(@(x) get_run_num(x), D,'UniformOutput',false);

F = [E{:}];

embedNum = 0;   %当前已嵌入数据量
for i = 1 : 16
    m = max(F(i,:));
    for j = 1:m
        loc = find(F(i,:)==j);%获取只含有j个ZRV的R为i-1的块索引
        for k = 1:numel(loc)
            [D{loc(k)},embedNum] = embed_Qian(D{loc(k)},i-1,secret,embedNum);%将秘密信息嵌入当前选中块
        end
    end
end
%将D转换成一维序列后再反zigzag扫描转换成8*8矩阵，再替换原来位置的8*8矩阵，返回新的载密DCT矩阵
rev_zrv = cellfun(@(x) reverse_zrv(x), D,'UniformOutput',false);%将ZRV逆变换为zigzag序列
rev_zigzag = cellfun(@(x) reverse_zigzag(x), rev_zrv,'UniformOutput',false);%将zigzag序列逆变换为8*8矩阵
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


