function [fi, psnr,runtime] = RDH_Hou(name_cover, secret, is_optimized)
t1 = clock;
jpg_obj = jpeg_read(name_cover);
jpg_obj.optimize_coding = is_optimized;
dct = jpg_obj.coef_arrays{1,1};
stego_jpg_obj = jpg_obj;
payload = numel(secret);
Q_table=jpg_obj.quant_tables{1};
%% 预处理
PSNR=zeros(1,64);
INCRE=zeros(1,64);
%将量化表的每个因子返回到空域中看它对像素产生的影响
Q_cost=costFun(Q_table);      
%按列抽出每个DCT块中ij位置的系数为一行，相同位置为一行形成矩阵
bin63 = get63bin(dct);          
[outbin,capacity,unitDistortion] = getuintcost63bin(bin63,Q_cost);
[unitDistortion,sortIndex] = sort(unitDistortion);        %对失真进行排序，排序好的块系数在sort_index
for selectNum = 12:3:3*floor(length(sortIndex)/3)                %%遍历所有selectNum，根据psnr寻找最佳的块嵌入数量K
    sel_index = sortIndex(1:selectNum);
    M = matrix_index(sel_index);                 %产生标记矩阵M
    DCT = mark(M,dct);                          %没问题，产生选择系数后的DCT块
    % 模拟修改图片产生嵌入序列
    simulate_dct = simulate(DCT);         %模拟修改后的图片存贮在simulate_dct
    counter_1 = computeCapacity(DCT,1);
    counter_0 = computeCapacity(DCT,0);
    [counter_0,sort_0] = sort(counter_0);
    table = Q_table;
    [order,vd_distor] = select_block2(simulate_dct,DCT,table,counter_1);   %根据模拟修改的方案贪心算法（失真大小）产生一个嵌入图片的序列,产生码流失真序列
    % 按照嵌入序列，将信息嵌入图片
    for r = 1:length(order)                                    %寻找嵌入临界值
        if (sum(counter_1(order(1:r)))>=payload)            %按每个块中1的数目
            order = order(1:r);
            sort_0 = sort_0(1:r);
            break;
        end
    end
    [stegoDct,tag] = generate_stego(order,DCT,secret,payload);       %产生嵌入的DCT系数
    if tag==1
        continue;
    end
    stego_dct = recoverstego(dct,stegoDct,sel_index);         %恢复其他系数
    stego_jpg_obj.coef_arrays{1} = stego_dct;                     %修改方案
    name_stego = strcat('stego.jpg');
    jpeg_write(stego_jpg_obj,name_stego);
    %% 计算失真和码流扩张
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
[psnr,index] = max(PSNR);	%最优psnr
fi = INCRE(index);	%最优文件膨胀
t2 = clock;
runtime = etime(t2,t1);
end

