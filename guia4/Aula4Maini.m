par.r= [2e6 6e6 10e6 16e6 50e6 10e6 2e6 50e6 20e6 2e6 10e6 20e6]; %bps

par.J{1}= [5]; %routing path of flow Internet to Datacenter
par.J{2}= [5 2]; %routing path of flow Internet to LAN A
par.J{3}= [5 4]; %routing path of flow Internet to LAN B
par.J{4}= [6]; %routing path of flow Datacenter to Internet
par.J{5}= [2]; %routing path of flow Datacenter to LAN A
par.J{6}= [4]; %routing path of flow Datacenter to LAN B
par.J{7}= [1 6]; %routing path of flow LAN A to Internet
par.J{8}= [1]; %routing path of flow LAN A to Datacenter
par.J{9}= [1 4]; %routing path of flow LAN A to LAN B
par.J{10}= [3 6]; %routing path of flow LAN B to Internet
par.J{11}= [3]; %routing path of flow LAN B to Datacenter
par.J{12}= [3 2]; %routing path of flow LAN B to LAN A
x = 10e6;
par.C= [100e6 100e6 100e6 100e6 x x]; %bps
par.f= [150e3 150e3 150e3 150e3 150e3 150e3]; %Bytes
par.S= 200; %seconds
AvgPacketLoss = [];
AvgPacketDelay = [];
flags = [];

Avg_Of_All_Loss = 0;
Avg_Of_All_Delay = 0;

poolobj = gcp;
addAttachedFiles(poolobj,{'sim2.m'});
y = true;
while (y)

    parfor j = 1:10
        out = sim2(par);
        AvgPacketLoss(j,:) =   out.AvgPacketLoss;
        AvgPacketDelay(j,:) =  out.AvgPacketDelay;
    end
    fprintf("For X == %f \n",x);
    for a= 1:length(par.r)
    APL = mean(AvgPacketLoss(:,a));
    APD = mean(AvgPacketDelay(:,a));
    fprintf("Average Packet Loss (%%)= %f +- %f\n",APL,norminv(1-0.1/2)*sqrt(var(AvgPacketLoss(:,a))/10));
    fprintf("Average Packet Delay (ms)= %f +- %f\n",APD,norminv(1-0.1/2)*sqrt(var(AvgPacketDelay(:,a))/10));
      if(APD < 1 && APL <= 0.0001)
        flags(a) = 1;
      end
    end
    if(sum(flags) == length(par.r))
        y = false;
    end    

    x = x + 10e6;
    par.C= [100e6 100e6 100e6 100e6 x x]; %bps
    AvgPacketLoss = [];
    AvgPacketDelay = [];
end
