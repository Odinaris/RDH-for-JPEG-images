function num_ac = get_ac_num(Blockdct)
[m,n] = size(Blockdct); 

num_ac = zeros(63,2);
for count=1:63
%     ACnum(count,1) = sum(abs(Blockdct{:}(count+1)==1));
    for r=1:m
        for c=1:n
            if abs(Blockdct{r,c}(count+1))==1
                num_ac(count,1)=num_ac(count,1)+1;
            else
                if abs(Blockdct{r,c}(count+1))>1
                    num_ac(count,2)=num_ac(count,2)+1;
                end
            end
        end
    end
end
end