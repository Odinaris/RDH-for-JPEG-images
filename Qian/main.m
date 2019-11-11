clear;clc;
dbstop if error
addpath(genpath('D:\Odinaris\RDH for JPEG\utils\'));
img_name = 'Baboon_70.jpg';
stego_name = strcat('Stego-', img_name);
opt_name = strcat('Opt-', img_name);
%% Read and parse JPEG image.
jpeg_obj = jpeg_read(img_name);
jpeg_obj.optimize_coding = 1;   % use the optimized Huffman table or not.
jpeg_write(jpeg_obj, opt_name);
jpeg_dct = jpeg_obj.coef_arrays{1, 1};
[row, col] = size(jpeg_dct);
% divide the quantized DCT matrix into 8*8 DCT blocks.
blk_dct = mat2cell(jpeg_dct,ones(row/8,1)*8,ones(col/8,1)*8); 
% the number of zero-AC coefficients in each block.
num_zeroAC = cellfun(@(x) sum(sum(x(2:64)==0)), blk_dct);
% the capacity of each block (the number of the coefficients of value -1 and 1.)
blk_capacity = cellfun(@(x) sum(sum(x(2:64)==1|x(2:64)==-1)), blk_dct); 
N = row * col / (8 * 8);	% the number of 8*8 blocks.
%% Embed data and generate the stego JPEG image.
len_message = 7000;
rng(0,'twister');
secret = round(rand(1,len_message)*1);  % generate binary bits randomly.
capacity = 0;
for i=1:64
    if capacity < len_message
        blk_ind = find(num_zeroAC <= i); 
        capacity = sum(blk_capacity(blk_ind));
    end 
end
S = blk_dct(blk_ind);
C = cellfun(@(x) zigzag(x), S,'UniformOutput',false);
D = cellfun(@(x) getZRV(x), C,'UniformOutput',false);
E = cellfun(@(x) getRunNum(x), D,'UniformOutput',false);
F = [E{:}];
index_embedded = 0; % the index of current embedded bits.
for i = 1 : 16
    m = max(F(i,:));
    for j = 1:m
        loc = find(F(i,:) == j);
        for k = 1:numel(loc)
            [D{loc(k)},index_embedded] = embed(D{loc(k)},i-1,secret,index_embedded);         
        end
    end
end
revZRV = cellfun(@(x) revZRVs(x), D,'UniformOutput',false);
de_zigzag = cellfun(@(x) deZigzag(x), revZRV,'UniformOutput',false);
stego_dct = blk_dct;
for i = 1:numel(de_zigzag)
    de_zigzag{i}(1) = blk_dct{blk_ind(i)}(1);
    stego_dct{blk_ind(i)} = de_zigzag{i};
end
stego_jpg_obj = jpeg_obj;
stego_dct = cell2mat(stego_dct);
stego_jpg_obj.coef_arrays{1,1} = stego_dct;  
jpeg_write(stego_jpg_obj, stego_name);
%% Compute the PSNR value and file size increments.
cover = imread(img_name);
stego = imread(stego_name);
PSNR = psnr(cover, stego);
cover_file = imfinfo(opt_name);
stego_file = imfinfo(stego_name);
IncSize = (stego_file.FileSize - cover_file.FileSize) * 8;
disp(PSNR);
disp(IncSize);

