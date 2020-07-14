function out = sim2(par)
   %Events
   Arrival      = 0;
   Departure    = 1;
   Terminate    = 2;
   Retransmit   = 3;
   
   %Link State
   FREE = 0;
   OCCUPIED = 1;

   path             = par.J;
   capacityLinks    = par.C;
   queueLinkSize    = par.f;
   numLinks         = length(par.C);
   numFlows         = length(par.r);
  
   Events       = [];
   AvgPktSize   = 64* 0.19 + 1518*0.48 + (1517+65)/2 *(1-0.19-0.48);
   time         = (par.r./8)./AvgPktSize;
   a            = (1./time);
   
   linkState        = zeros(1,numLinks);
   QueueOccupation  = linkState;
   Queue            = cell(1,numLinks);
   
   totalSize    = zeros(1,numFlows);
   totalPackets = totalSize;
   lostPackets  = totalSize;
   delays       = totalSize;
   transmittedBytes = totalSize;
   transmittedPackets  = totalSize;
   
   instant = linkState; %arrival instant oof the packet that is being 
                        %transmitted on link
   Size    = linkState;  %Size of the packet that is being transmitted 
                        %on link
   
   out.AvgPacketLoss = totalSize;
   out.AvgPacketDelay = totalSize;
   
   for i = 1:numFlows
       Events = [Events; Arrival exprnd(a(i)) i path{i}(1) ];
   end
   
   Events = sortrows([Events; Terminate par.S 0 0]);
   
   while(Events(1,2) <= par.S)
       event     = Events(1,1);
       Clock     = Events(1,2);
       Flow      = Events(1,3);
       Link      = Events(1,4);
       Events(1,:) = [];
       if(event == Arrival)
            packetSize = pktSize();
            totalPackets(Flow)  = totalPackets(Flow) + 1;
            totalSize(Flow)     = totalSize(Flow) + packetSize;
            if(linkState(Link) == FREE)
               linkState(Link) = OCCUPIED;
               instant(Link)   = Clock;
               Size(Link)      = packetSize;
               timeToNextPacket = Clock + (packetSize*8)/capacityLinks(Link);
               currentPath = path{Flow};
               if(currentPath(end) == Link)
                  Events = [Events; Departure timeToNextPacket Flow Link];
               else
                  nextLink = currentPath(find(currentPath == Link) + 1);
                  Events = [Events; Retransmit timeToNextPacket Flow nextLink]; 
               end
               
            elseif(QueueOccupation(Link) + packetSize <= queueLinkSize(Link))
                Queue{Link} = [Queue{Link}; Clock packetSize Flow];
                QueueOccupation(Link) = QueueOccupation(Link) + packetSize;
            else
                lostPackets(Flow) = lostPackets(Flow) + 1;
            end
            Events = sortrows([ Events; Arrival (exprnd(a(Flow)) + Clock) Flow Link],2);
            
       elseif(event == Retransmit)
       	   currentPath 		= path{Flow};
           pastLink = currentPath(find(currentPath == Link) -1);
           tmp_linkInstant  = instant(pastLink);
           tmp_linkSize     = Size(pastLink);
           if(QueueOccupation(pastLink) >0)
               q_instant        = Queue{pastLink}(1,1);
               q_syze           = Queue{pastLink}(1,2);
               q_flow           = Queue{pastLink}(1,3);
               q_path           = path{q_flow};
               instant(pastLink) = q_instant;
               Size(pastLink)    = q_syze;
               timeToNextPacket = Clock + (q_syze*8)/capacityLinks(pastLink);
               if(q_path(end) == pastLink)
                   Events = sortrows([Events; Departure timeToNextPacket q_flow pastLink],2);
               else
                   nextLink = q_path(find(q_path == pastLink) + 1);
                   Events   = sortrows([Events; Retransmit timeToNextPacket q_flow nextLink],2);
               end
               Queue{pastLink}(1,:) = [];
               QueueOccupation(pastLink) = QueueOccupation(pastLink) - q_syze;
           else
               linkState(pastLink) = FREE;
           end
           %Tratar do retransmit do link
           if(linkState(Link) == FREE)
               linkState(Link) = OCCUPIED;
               instant(Link) = tmp_linkInstant;
               Size(Link) = tmp_linkSize;
               timeToNextDeparture = Clock + (tmp_linkSize*8)/capacityLinks(Link);
               if(currentPath(end) == Link)
                   Events = sortrows([ Events; Departure  timeToNextDeparture  Flow Link],2);
               else
                   next_link = currentPath(find(currentPath == Link) + 1);
                   Events = sortrows([Events; Retransmit timeToNextDeparture Flow next_link],2);
               end
           elseif(QueueOccupation(Link) + tmp_linkSize <= queueLinkSize(Link))
               Queue{Link} = [Queue{Link}; tmp_linkInstant tmp_linkSize Flow];
               QueueOccupation(Link) = QueueOccupation(Link) + tmp_linkSize;
           else
               lostPackets(Flow) = lostPackets(Flow) + 1;
           end
           
       elseif(event == Departure)
           delays(Flow) = delays(Flow) + (Clock - instant(Link));
           transmittedBytes(Flow) = transmittedBytes(Flow) + Size(Link);
           transmittedPackets(Flow) = transmittedPackets(Flow) + 1;
           if(QueueOccupation(Link) > 0)
               q_instant    = Queue{Link}(1,1);
               q_size       = Queue{Link}(1,2);
               q_flow       = Queue{Link}(1,3);
               q_path       = path{q_flow};
               instant(Link) = q_instant;
               Size(Link)    = q_size;
               timeToNextPacket = Clock + (q_size*8)/capacityLinks(Link);
               if(q_path(end) == Link)
                   Events = sortrows([Events; Departure timeToNextPacket q_flow Link],2);
               else
                   nextLink = q_path(find(q_path == Link) + 1);
                   Events   = sortrows([Events; Retransmit timeToNextPacket q_flow nextLink],2);
               end
               Queue{Link}(1,:) = [];
               QueueOccupation(Link) = QueueOccupation(Link) - q_size;
           else
               linkState(Link) = FREE;
           end
       else
           out.AvgPacketLoss = 100 * (lostPackets./totalPackets);
           out.AvgPacketDelay = delays./transmittedPackets * 1000;%ms
       end 
   end 
   
  % fprintf("LostPackets per flow %d %d %d, TotalPackets %d %d %d\n",lostPackets(1),lostPackets(2),lostPackets(3),totalPackets(1),totalPackets(2),totalPackets(3));
   %fprintf("Packet Delay per flow %d %d %d, TransmittedPackets %d %d %d\n",delays(1),delays(2),delays(3),transmittedPackets(1),transmittedPackets(2),transmittedPackets(3));
   %fprintf("Transmitted bytes %d %d %d, Total Bytes %d %d %d\n", transmittedBytes(1),transmittedBytes(2),transmittedBytes(3),totalSize(1),totalSize(2),totalSize(3));
   % fprintf("c'est fini \n");

end

function PacketSize = pktSize()
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
