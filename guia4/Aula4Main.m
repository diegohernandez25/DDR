R = [6e6,8e6,9e6,9.5e6,9.75e6,10.0e6,...
        6e6,8e6,9e6,9.5e6,9.75e6,10.0e6]; %bps
F = [15e4,15e4,15e4,15e4,15e4,15e4,...
        15e3,15e3,15e3,15e3,15e3,15e3]; %Bytes
par.S = 1000; %seconds

Cases = ['A','B','C','D','E','F','G','H','I','J','K','L'];


for i = 1:12
    par.r = R(i);
    par.f = F(i);
    parfor j = 1:10 
        out = simulator1(par);
        AVGPACKETLOSS(j) = out.AvgPacketLoss;
        AVGPACKETDELAY(j) = out.AvgPacketDelay;
        AVGTRANSTHPUT(j) = out.TransThroughput;
    end
    fprintf("%d %c %d %d \n",i,Cases(i),par.r,par.f)
    fprintf("Average Packet Loss (%%)= %f +- %f \n",mean(AVGPACKETLOSS),norminv(1-0.1/2)*sqrt(var(AVGPACKETLOSS)/10));
    fprintf("Average Packet Delay (ms)= %f +- %f \n",mean(AVGPACKETDELAY),norminv(1-0.1/2)*sqrt(var(AVGPACKETDELAY)/10));
    fprintf("Transmitted Throughput (Mbps)= %f +- %f \n",mean(AVGTRANSTHPUT),norminv(1-0.1/2)*sqrt(var(AVGTRANSTHPUT)/10));
end
