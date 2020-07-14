function out = simulator2(par)

% Entry parameters 
Flows = par.r; % (throughput of flow 1, throughput of flow 2, throughput of flow 3, ...) bps
Paths = par.J; % (ordered link path of flow 1[], ordered link path of flow 2[], ordered link path of flow 3[], ...)
Links = par.C; % (capacity of link 1, capacity of link 2, ...) bps
par.f; % (queue size of link 1, queue size of link 2, ...) Bytes
par.S; % (Simulation time in seconds) s

%Events
Arrival = 0;
Departure = 1;
Terminate = 2;
Retransmit = 4;

%State variables
State =  repmat(0,1,length(Links)); % Vector with Link states, busy or not 0 = free 1 = busy
Clock = 0; %Current clock of the system
QueueOccupation = repmat(0,1,length(Links)); % Vector with Total number of bytes per link queue
Queue = cell(1,length(Links)); % Cell array with (arrival time,size,flow) of packet per link
                    %     [Link1]           [Link2]          [Link3] 
                    %        |                 |                |
                    %        ^                 ^                ^
                    % [Time,Size,Flow] [Time,Size,Flow] [Time,Size,Flow]
                    % [Time,Size,Flow] [Time,Size,Flow] [Time,Size,Flow]
                    % [Time,Size,Flow] [Time,Size,Flow] [Time,Size,Flow]
                    % [Time,Size,Flow] [Time,Size,Flow] [Time,Size,Flow]

%Statistical counters
TotalSize = repmat(0,1,length(Flows)); %Total bits transmitted 
TotalPackets = repmat(0,1,length(Flows)); %Total packets arrived to the first link of it's routing path
LostPackets = repmat(0,1,length(Flows)); %Total number of packets dropped per flow
Delays = repmat(0,1,length(Flows)); % Sum of all delays per flow on the last link of the packet path
TransmittedPackets = repmat(0,1,length(Flows)); %Total number of sent packets per flow on the last link of its path
TransmittedBytes = repmat(0,1,length(Flows)); %Total number of sent bytes per flow

%Aux variables
Instant = repmat(0,1,length(Links)); %Time of arrival the packet being transmitted per link
Syze = repmat(0,1,length(Links)); %Size of the packet being transmitted per link

% Return variables
out.AvgPacketLoss = repmat(0,1,length(Flows)); % per flow packet loss
out.AvgPacketDelay = repmat(0,1,length(Flows)); % per flow packet delay

                
Events = [];% Event list to process 
%(each event will have 4 fields Event = (time_instant type_of_event flow_ID link_ID ))

B = 64* 0.19 + 1518*0.48 + (1517+65)/2 *(1-0.19-0.48); %tamanho médio de pacotes
time = (par.r./8)./B;
a = (1./time);% a tempo medio de arrival, 
                %distribuição de acordo com o tempo médio entre pacotes
                
%next packet for each flow
for  i = 1:length(Flows)
    Events = [Events; exprnd(a(i)) Arrival i par.J{i}(1) 0 0 ];
end    
Events = sortrows([Events; par.S Terminate 0 0 0 0 ]);

    while(Events(1,1) <= par.S)  
        Clock = Events(1,1);
        event = Events(1,2);
        Flow = Events(1,3);
        Link = Events(1,4);
        Packet_time = Events(1,5);
        Packet_size = Events(1,6);
        Events(1,:) = [];
        
        if(event == Arrival)  %
     
            PacketSize = packetsize();
            TotalPackets(Flow) = TotalPackets(Flow) +1;
            TotalSize(Flow) = TotalSize(Flow) + PacketSize;
            time_to_next_packet = exprnd(a(Flow)) + Clock;    
            if(State(Link) == 0)
                State(Link) = 1;
                Instant(Link) = Clock;
                Syze(Link) = PacketSize;
                time_to_next_departure = Instant(Link) + (PacketSize*8)/Links(Link);
                Current_path = Paths{Flow};
                if(Current_path(end) == Link)
                   Events = [ Events; time_to_next_departure Departure Flow Link Instant(Link) PacketSize];
                else
                   next_link = Current_path(find(Current_path == Link)+1);
                   Events = [ Events; time_to_next_departure Retransmit Flow next_link Instant(Link) PacketSize];
                end    
                
            elseif(QueueOccupation(Link) + PacketSize <= par.f(Link))
                Queue{Link} = [Queue{Link}; Clock PacketSize Flow];
                QueueOccupation(Link) = QueueOccupation(Link) + PacketSize;
            else
                LostPackets(Flow) = LostPackets(Flow) +1;
            end
            Events = sortrows([ Events; time_to_next_packet Arrival Flow Link 0 0]);
            
        elseif(event == Departure)
            Delays(Flow) = Delays(Flow) + (Clock-Packet_time);
            TransmittedBytes(Flow) =  TransmittedBytes(Flow) + Packet_size;
            TransmittedPackets(Flow) = TransmittedPackets(Flow) +1;
            
            if (QueueOccupation(Link) > 0)
                Instant(Link) = Queue{Link}(1,1);
                Syze(Link) = Queue{Link}(1,2);
                Dep_Flow = Queue{Link}(1,3);
                Current_path = Paths{Dep_Flow};
                time_to_next_departure = Instant(Link) + (Packet_size*8)/Links(Link);
                if(Current_path(end) == Link)
                   Events = [ Events; time_to_next_departure Departure Dep_Flow Link Instant(Link) Syze(Link)];
                else 
                   next_link = Current_path(find(Current_path == Link)+1);
                   Events = [ Events; time_to_next_departure Retransmit Dep_Flow next_link Instant(Link) Syze(Link)];
                end    
                Events =  sortrows(Events);
                Queue{Link}(1,:) = [];
                QueueOccupation(Link) = QueueOccupation(Link) - Syze(Link);
            else
                State(Link) = 0;
            end
            
        elseif(event == Retransmit)
            
            Current_path = Paths{Flow};
            Last_Link = Current_path(find(Current_path == Link)-1);
             if (QueueOccupation(Last_Link) > 0)
                Instant(Last_Link) = Queue{Last_Link}(1,1);
                Syze(Last_Link) = Queue{Last_Link}(1,2);
                Dep_Flow = Queue{Last_Link}(1,3);
                Last_path = Paths{Dep_Flow};
                time_to_next_departure = Instant(Last_Link) + (PacketSize*8)/Links(Last_Link);
                if(Last_path(end) == Last_Link)
                   Events = [ Events; time_to_next_departure Departure Dep_Flow Last_Link Instant(Last_Link) Syze(Last_Link)];
                else 
                   next_link = Last_path(find(Last_path == Last_Link)+1);
                   Events = [ Events; time_to_next_departure Retransmit Dep_Flow next_link Instant(Last_Link) Syze(Last_Link)];
                end    
                Events =  sortrows(Events);
                Queue{Last_Link}(1,:) = [];
                QueueOccupation(Last_Link) = QueueOccupation(Last_Link) - Syze(Last_Link);
             else
                 State(Last_Link) = 0;
             end    
            
            if(State(Link) == 0)
                State(Link) = 1;
                Instant(Link) = Packet_time;
                Syze(Link) = Packet_size;
                time_to_next_departure = Instant(Link) + (Syze(Link)*8)/Links(Link);
                
                if(Current_path(end) == Link)
                   Events = [ Events; time_to_next_departure Departure Flow Link Packet_time Packet_size];
                else
                   next_link = Current_path(find(Current_path == Link)+1)
                   Events = [ Events; time_to_next_departure Retransmit Flow next_link Packet_time Packet_size ];
                end    
                
            elseif(QueueOccupation(Link) + Packet_size <= par.f(Link))
                Queue{Link} = [Queue{Link}; Clock Packet_size Flow];
                QueueOccupation(Link) = QueueOccupation(Link) + Packet_size;
                if(QueueOccupation(Link) >0.75*par.f(Link)*8)
                fprintf("QueueOccupation of link %f at 75 \n",Link)
                end    
            else
                LostPackets(Flow) = LostPackets(Flow) +1;
            end
            
        else% (event == Terminate)
            out.AvgPacketLoss = 100 * (LostPackets./TotalPackets);
            out.AvgPacketDelay = Delays./TransmittedPackets * 1000;%ms
        end
    end
     fprintf("LostPackets per flow %d %d %d, TotalPackets %d %d %d\n",LostPackets(1),LostPackets(2),LostPackets(3),TotalPackets(1),TotalPackets(2),TotalPackets(3));
     fprintf("Packet Delay per flow %d %d %d, TransmittedPackets %d %d %d\n",Delays(1),Delays(2),Delays(3),TransmittedPackets(1),TransmittedPackets(2),TransmittedPackets(3));
     fprintf("Transmitted bytes %d %d %d, Total Bytes %d %d %d\n", TransmittedBytes(1),TransmittedBytes(2),TransmittedBytes(3),TotalSize(1),TotalSize(2),TotalSize(3));
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
PacketSize = randi([65 1517]);end

    
