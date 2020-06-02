function [fi,psnr_value,runtime] = RDH_Li (name_cover,secret,is_optimized)
t1 = clock;
%% Extract information
payload = numel(secret);
jpg_obj = jpeg_read(name_cover);
jpg_obj.optimize_coding = is_optimized;
jpg_dct = jpg_obj.coef_arrays{1, 1};
[row, col] = size(jpg_dct);
N = row * col / (8 * 8); % the total number of 8*8 DCT blocks.
blk_dct = mat2cell(jpg_dct,ones(row/8,1)*8,ones(col/8,1)*8);  % divide the quantized DCT matrix into 8*8 DCT blocks.
blk_zigzag = cellfun(@(x) zigzag(x), blk_dct,'UniformOutput',false);%将每块zigzag扫描并化为1*64向量
blk_zrv = cellfun(@(x) get_zrv(x), blk_zigzag,'UniformOutput',false);
blk_cap = cellfun(@(x) cal_capacity(x, 63), blk_zrv,'UniformOutput',false);
max_cap = round(sum(sum(cell2mat(blk_cap))));
if max_cap-1000<payload  %if max capacity is smaller than payload, return.
    [fi,psnr_value,runtime] = deal(0);
    disp('estimated capacity is smaller than the given payload!');
    return;
end
R_MIN = 0;
for i = 1:63
    blk_cap = cellfun(@(x) cal_capacity(x, i), blk_zrv,'UniformOutput',false);
    est_cap = round(sum(sum(cell2mat(blk_cap))));
    if est_cap >= payload
        R_MIN = i;
        break;
    end
end
num_zeroAC = cellfun(@(x) sum(sum(x(2:64)==0)), blk_dct); % the number of zero-AC coefficients in each block.
s_zeroac(:,1) = 1:1:N;
s_zeroac(:,2) = reshape(num_zeroAC,[N 1]);
s_zeroac = sortrows(s_zeroac,-2); % the descending sorted DCT blocks.
s_zeroac = s_zeroac(:,1);
R_MAX = 63;
FI = zeros(R_MAX-R_MIN+1,1);
PSNR = zeros(R_MAX-R_MIN+1,1);
for i = R_MIN:R_MAX
    pos = 0;
    s_ZRV = blk_zrv;
    for j = 1:N
        cur_zrv = blk_zrv{s_zeroac(j)};
        cur_nacp = get_NACP(cur_zrv, i);
        if ~isempty(cur_nacp)
            [s_nacp,pos] = embed_Li(cur_nacp,secret,pos);
            s_nacp = reshape(s_nacp',[],1);
            s_ZRV{s_zeroac(j)}(1:numel(s_nacp(:,1)),4) = s_nacp;
            if payload <= pos
                break;
            end
        end
    end
    s_Zigzag = cellfun(@(x) reverse_zrv(x), s_ZRV,'UniformOutput',false);
    for j = 1:N
        s_Zigzag{j}(1) = blk_zigzag{j}(1);
    end
    s_DCT = cellfun(@(x) reverse_zigzag(x), s_Zigzag,'UniformOutput',false);
    s_DCT = cell2mat(s_DCT);
    s_obj = jpg_obj;
    s_obj.coef_arrays{1,1} = s_DCT;
    stego_name = 'stego.jpg';
    jpeg_write(s_obj,stego_name);
    cover = imread(name_cover);
    stego = imread(stego_name);
    cover_file = imfinfo(name_cover);
    stego_file = imfinfo(stego_name);
    FI(i-R_MIN+1) = (stego_file.FileSize - cover_file.FileSize) * 8;
    PSNR(i-R_MIN+1) = double(compute_psnr(cover,stego));
end
%% Record the outputs.
[psnr_value,ind] = max(PSNR);
fi = FI(ind);
t2 = clock;
runtime = etime(t2,t1);
end

