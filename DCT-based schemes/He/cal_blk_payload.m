function payload = cal_blk_payload(zrv,freq)
payload = 0;
for i = 1:length(freq)
   ind = find(freq(i) == zrv(:,1), 1);
   if ~isempty(ind)
       if abs(zrv(ind,4)) == 1
           payload = payload + 1;
       end
   end
end
end

