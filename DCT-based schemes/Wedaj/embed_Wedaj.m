function [dct,pos] = embed_Wedaj(dct,Data,pos,positions,row,col)
for i=1:length(positions)
    v = dct{row,col}(positions(i)+1);
    if abs(v) == 1
        dct{row,col}(positions(i)+1) = v + sign(v)*Data(pos);
        if pos==length(Data)
            break;
        end
        pos=pos+1;
    elseif abs(v)>1
        dct{row,col}(positions(i)+1) = v + sign(v);
    end
end
end