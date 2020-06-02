function [run,stego_DCT] = embed_He(freq, secret, zigzag, lst_blk, order, ZRV)
flag = 0;
run = 0;
stego_Zigzag = zigzag;
while run <= 62
    for i = 1:lst_blk
        cur_blk = order(i);
        zrv = ZRV{cur_blk};
        for j = 1:length(freq)
            f = freq(j);
            ind = find(zrv(:,1) == f);
            if ~isempty(ind)
                run_cur = zrv(ind,2);
                if run_cur == run
                    v = stego_Zigzag{cur_blk}(freq(j)+1);
                    if abs(v) == 1
                        flag = flag + 1;
                        stego_Zigzag{cur_blk}(freq(j)+1) = v + sign(v) * secret(flag);
                        if flag == length(secret)
                            stego_DCT = cellfun(@(x) reverse_zigzag(x), stego_Zigzag,'UniformOutput',false);%将每块zigzag扫描并化为1*64向量
                            stego_DCT = cell2mat(stego_DCT);
                            return;
                        end
                    elseif abs(v) > 1
                        stego_Zigzag{cur_blk}(freq(j)+1) = v + sign(v);
                    end
                end
            end
        end
    end
    run = run + 1;
end
end