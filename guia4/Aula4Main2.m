% par.r= [1e6 3e6 6e6]; %bps
% par.J{1}= [1]; %routing path of flow 1
% par.J{2}= [1 2]; %routing path of flow 2
% par.J{3}= [2]; %routing path of flow 3
% par.C= [5e6 10e6]; %bps
par.f= [150e3 150e3]; %Bytes
par.S= 1000; %seconds
AvgPacketLoss = [];
AvgPacketDelay = [];
cases = ["e" ,"f", "h", "i"];
poolobj = gcp;
addAttachedFiles(poolobj,{'sim2.m'});
for y = 1:3
    if (y == 1) %e)
        par.C= [5e6 10e6]; %bps
        par.f= [150e3 150e3]; %Bytes
        par.r= [4e6]; %bps
        par.J{1}= [1 2];
    end
    if (y == 2) %f)
        par.C= [10e6 5e6]; %bps
        par.f= [150e3 150e3]; %Bytes
        par.r= [7.4e6 2.3e6 2.5e6]; %bps
        par.J{1}= [1]; par.J{2}= [1 2]; par.J{3}= [2];
    end
    if (y == 3) %h)
        par.C= [10e6 5e6]; %bps
        par.f= [7.5e3 150e3]; %Bytes
        par.r= [7.4e6 2.3e6 2.5e6]; %bps
        par.J{1}= [1]; par.J{2}= [1 2]; par.J{3}= [2];
    end
    parfor j = 1:10
        out = sim2(par);
        AvgPacketLoss(j,:) =   out.AvgPacketLoss;
        AvgPacketDelay(j,:) =  out.AvgPacketDelay;
    end

     fprintf("%s \n",cases(y))
    for a= 1:length(par.r)
     fprintf("Average Packet Loss (%%)= %f +- %f\n",mean(AvgPacketLoss(:,a)),norminv(1-0.1/2)*sqrt(var(AvgPacketLoss(:,a))/10));
     fprintf("Average Packet Delay (ms)= %f +- %f\n",mean(AvgPacketDelay(:,a)),norminv(1-0.1/2)*sqrt(var(AvgPacketDelay(:,a))/10));
    end
    AvgPacketLoss = [];
    AvgPacketDelay = [];
end
