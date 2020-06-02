function [fi,psnr,runtime] = RDH_Ji(name_cover, secret)
t1 = clock;
jpg_obj = jpeg_read(name_cover);
dct = jpg_obj.coef_arrays{1};
qt = jpg_obj.quant_tables{1};
img_cover = imread(name_cover);
payload = numel(secret);
PSNR=zeros(1,64);
INCRE=zeros(1,64);
Q_cost=costFun(qt);            %将量化表的每个因子返回到空域中看它对像素产生的影响
bin63=get63bin(dct);          %按列抽出每个DCT块中ij位置的系数为一行，相同位置为一行形成矩阵
[~,~,unitdistortion63]=getuintcost63bin(bin63,Q_cost);
[~,sort_index]=sort(unitdistortion63);        %对失真进行排序，排序好的块系数在sort_index
for selnum=12:3:3*floor(length(sort_index)/3)                %%遍历所有selnum，根据psnr寻找最佳的块嵌入数量K
    sel_index=sort_index(1:selnum);
    M=matrix_index(sel_index);                 %产生标记矩阵M
    DCT=mark(M,dct);                          %没问题，产生选择系数后的DCT块%%%
    sum_R = sum_payload(DCT);
    if sum_R < payload
        continue;
    end
    simulate_dct=simulate(DCT);         %模拟修改后的图片存贮在simulate_dct
    counter_1=countDCT(DCT,1);
    table=jpg_obj.quant_tables{1};
    [order,~]=select_block2(simulate_dct,DCT,table,counter_1);   %根据模拟修改的方案贪心算法（失真大小）产生一个嵌入图片的序列,产生码流失真序列
    for r=1:length(order)                                    %寻找嵌入临界值
        if (sum(counter_1(order(1:r)))>=payload)            %按每个块中1的数目
            order=order(1:r);
            break;
        end
    end
    [stego1_dct,tag]=generate_stego(order,DCT,secret,payload);       %产生嵌入的DCT系数
    if tag==1
        continue;
    end
    stego_dct=recoverstego(dct,stego1_dct,sel_index);         %恢复其他系数
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
end %找到最优K
[~,index]=max(PSNR);                            %找到最好的psnr
%% 上述步骤已找到最优K
sel_index=sort_index(1:index);
M=matrix_index(sel_index);                 %产生标记矩阵M
DCT=mark(M,dct);                          %此时频率位置确定之后的DCT块为载体信号%%%
simulate_dct=simulate(DCT);         %模拟修改后的图片存贮在simulate_dct
[M,N] = size(DCT);
ori_Blockdct = mat2cell(DCT,8 * ones(1,M/8),8 * ones(1,N/8));%把原来的图像矩阵分割成N个8*8的Block
simulate_dct = mat2cell(simulate_dct,8 * ones(1,M/8),8 * ones(1,N/8));%把模拟嵌入的图像矩阵分割成N个8*8的Block
dct_block = mat2cell(dct,8 * ones(1,M/8),8 * ones(1,N/8));
[ simulate_dct ] = stego( simulate_dct,dct_block,sel_index ); %恢复其他系数
[add,psnring]=get_psnring(simulate_dct,dct_block,jpg_obj);   %获取嵌入代价
R=get_payload(ori_Blockdct);
[M,N] = size(ori_Blockdct);
%%
E1=reshape(add,M*N,1);
D1=reshape(psnring,M*N,1);
E = E1'; %转置为一行。
E = mapminmax(E, 0, 1); % 归一化。
E = reshape(E, size(E1)); %
D = D1'; %转置为一行。
D = mapminmax(D, 0, 1); % 归一化。
D = reshape(D, size(D1)); %
R=reshape(R,M*N,1);
C=payload;
options = optimoptions('intlinprog','MaxTime',120,'Display','off');
[~,g1] = intlinprog(E',1:M*N,-R',-C,[],[],zeros(M*N,1),ones(M*N,1),options);%求出最优FSE
A = [-R';E'];
alpha = 1;  %权重值
g = g1 + abs(alpha*g1);
b = [-C;g];
x=intlinprog(D',1:M*N,A,b,[],[],zeros(M*N,1),ones(M*N,1),options); %单目标计算块决策变量，在满足FSE时的最优PSNR对应的决策变量
%x为选中哪些块能满足条件
x=uint8(reshape(x,M,N));
[stego1_dct] = jpeg_emdding(secret,ori_Blockdct,x);       %产生嵌入的DCT系数
[M,N] = size(dct);
dct_block = mat2cell(dct,8 * ones(1,M/8),8 * ones(1,N/8));
[ stego_dct ] = stego( stego1_dct,dct_block,sel_index ); %恢复其他系数
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

