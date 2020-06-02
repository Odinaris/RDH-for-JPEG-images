function [s_nacp, pos] = embed_Li(nacp,data,pos)
s_nacp = nacp;
l_data = numel(data);
for i = 1:numel(nacp(:,1))
    if l_data <= pos
        break;
    end
    if abs(nacp(i,1))==1 && abs(nacp(i,2))==1
        if pos == l_data - 1
            data = [data,0];
        end
        if data(pos+1) == 1 && data(pos+2) == 1
            s_nacp(i,2) = s_nacp(i,2) + sign(s_nacp(i,2));
            pos = pos + 2;
        elseif data(pos+1) == 1 && data(pos+2) == 0
            s_nacp(i,1) = s_nacp(i,1) + sign(s_nacp(i,1));
            pos = pos + 2;
        elseif data(pos+1) == 0
            pos = pos + 1;
        end
    elseif abs(nacp(i,1))==1
        if data(pos+1) == 0
            s_nacp(i,2) = s_nacp(i,2) + sign(s_nacp(i,2));
            pos = pos + 1;
        elseif data(pos+1) == 1
            s_nacp(i,1) = s_nacp(i,1) + sign(s_nacp(i,1));
            s_nacp(i,2) = s_nacp(i,2) + sign(s_nacp(i,2));
            pos = pos + 1;
        end
    elseif abs(nacp(i,2))==1
        if data(pos+1) == 0
            s_nacp(i,1) = s_nacp(i,1) + sign(s_nacp(i,1));
            pos = pos + 1;
        elseif data(pos+1) == 1
            s_nacp(i,1) = s_nacp(i,1) + sign(s_nacp(i,1));
            s_nacp(i,2) = s_nacp(i,2) + sign(s_nacp(i,2));
            pos = pos + 1;
        end
    elseif abs(nacp(i,1))==2 && abs(nacp(i,2))==2
        if data(pos+1) == 0
            pos = pos + 1;
        elseif data(pos+1) == 1
            s_nacp(i,1) = s_nacp(i,1) + sign(s_nacp(i,1));
            s_nacp(i,2) = s_nacp(i,2) + sign(s_nacp(i,2));
            pos = pos + 1;
        end
    else
        s_nacp(i,1) = s_nacp(i,1) + sign(s_nacp(i,1));
        s_nacp(i,2) = s_nacp(i,2) + sign(s_nacp(i,2));
    end
end
end