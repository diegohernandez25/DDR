function out = simulator1(par)

%Events
Arrival = 0;
Departure = 1;
Terminate = 2;

%State variables
State = 0; %Link is busy or not 0 = free 1 = busy
Clock = 0; %Current clock of the system
QueueOccupation = 0; %Total number of bytes on queue
Queue = []; % Structure with arrival time and size of packet per entry 2 columns

%Statistical counters
TotalPackets = 0; %Total packets arrived to the system
LostPackets = 0; %Total number of packets dropped by the system
Delays = 0; % Sum of all delays
TransmittedPackets = 0; %Total number of sent packets 
TransmittedBytes = 0; %Total number of sent bytes

%Aux variables
Instant = 0; %Time of arrival the packet being transmitted
Syze = 0; %Size of the packet being transmitted

out.AvgPacketLoss = -1;
out.AvgPacketDelay = -1;
out.TransThroughput = -1 ;  
 
B = 64* 0.19 + 1518*0.48 + (1517+65)/2 *(1-0.19-0.48); %tamanho médio de pacotes
a = (par.r/8)/B;
time_to_next_packet = exprnd(1/a);% a tempo medio de arrival, 
                %distribuição de acordo com o tempo médio entre pacotes

Events = [time_to_next_packet Arrival;par.S Terminate];

           
    
    while(Events(1,1) <= par.S)  
        event = Events(1,2);
        Clock = Events(1,1);
        Events(1,:) = [];
        
        if(event == Arrival)  %
     
            PacketSize = packetsize();
            TotalPackets = TotalPackets +1;
            time_to_next_packet = exprnd(1/a) + Clock;
            if(State == 0)
                State = 1;
                Instant = Clock;
                Syze = PacketSize;
                time_to_next_departure = Instant + (PacketSize*8)/1e7;
                Events = [ Events; time_to_next_departure Departure ];

            elseif(QueueOccupation + PacketSize < par.f)
                Queue = [Queue; Clock PacketSize];
                QueueOccupation = QueueOccupation + PacketSize;
            else
                LostPackets = LostPackets +1;
            end
            Events = sortrows([ Events; time_to_next_packet Arrival ]);
            
        elseif(event == Departure)
            Delays = Delays + (Clock-Instant);
            TransmittedBytes =  TransmittedBytes + Syze;
            TransmittedPackets = TransmittedPackets +1;
            if (QueueOccupation > 0)
                Instant= Queue(1,1);
                Syze = Queue(1,2);
                time_to_next_departure = Clock + (Syze*8)/1e7;
                Events =  sortrows([ Events; time_to_next_departure Departure ]);
                Queue(1,:) = [];
                QueueOccupation= QueueOccupation - Syze;
            else
                State = 0;
            end
        else% (event == Terminate)
            out.AvgPacketLoss = 100 * (LostPackets/TotalPackets);
            out.AvgPacketDelay = Delays/TransmittedPackets * 1000;%ms
            out.TransThroughput = (8 * TransmittedBytes)/(par.S * 1e6) ;   
        end
    end
%     fprintf("LostPackets %f, TotalPackets %f\n",LostPackets,TotalPackets);
%     fprintf("Average Packet Delay %f\n",Delays/TransmittedPackets);
%     fprintf("Throughput %f\n", TransmittedBytes * 1e6/ par.S);
%     Events
   
end


    
function PacketSize = packetsize()
r = rand();
if(r < 0.19)
    PacketSize = 64;
    return 
end
if(r > 0.52)
    PacketSize = 1518;
    return
end
PacketSize = randi([65 1517]);
end
    
