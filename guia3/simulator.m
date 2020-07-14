% Author: Diego Caldeira Hernandez & Ricard Pousa
close all;
clear all;
format shortG

NODES = [60,90,120,150];
RANGE = [40,60,80];
CASES = ['A','B','C','D','E','F','G','H','I','J','K','L'];
AverageMatrix = zeros(12,2);
MinimumMatrix = zeros(12,2);
%Parameters initialization:
      
par.delta= 1;    % Time slot (in seconds)
%par.AP = [200 150];   % Coordinates of each AP
%par.AP = [100 150;300 150];   % Coordinates of each AP
%par.AP = [100 150;200 150;300 150];   % Coordinates of each AP
%par.AP = [100 100;300 100;100 200;300 200];   % Coordinates of each AP1
%f) 
par.AP = [50 250;350 250;...  80 range 99 minimum
          200 150;...
          50 50;350 50];
% par.AP = [50 250;370 250;... 60 range rework 99 minimum
%           175 150;370 150;...
%           50 50;370 50];    

% par.AP = [ 50 300; 150 300; 250 300; 350 300;... 40 range 99 minimum
%            00 265;100 265;200 265;300 265;400 265;...
%            50 225;150 225;250 225;350 225;... 
%            00 185; 100 185; 200 185; 300 185;400 185;...
%            50 150;150 150;250 150;350 150; ...
%            00 115;100 115 ;200 115;300 115;400 115;
%            50 65;150 65;250 65;350 65; ...
%            00 35;100 35; 200 35; 300 35; 400 35;...
%            50 00;150 00;250 00;350 00; 
%            ];                    
      
size(par.AP)       

          
%own coordinates e)      
%par.AP = [100 225;300 75]; % Best of 2
%par.AP = [100 75;200 225;300 75];      %Best for 3 APs    
%par.AP = [75 50;325 50;75 250;325 250];   % Best for 4 APs

par.nAP = size(par.AP,1);  %Number of APs

T= 3600;     % No. of time slots of the simulation

plotar = 0; % if plotar = 0, there is no visualization
            % if plotar = 1, node movement is visualized
            % if plotar = 2, node movement and connectivity are visualized
%h= waitbar(0,'Running simulation...');    
alfa = 0.1; % 90%
N = 20;
tic;
% Simulation cycles:

%for o = 2:13 
for o = 2:4 
    %full sim 
    %par.N= NODES(rem((o+2),4)+1); %Number of nodes
    %par.W= RANGE(int16(o/4));
    par.N = 150;
    par.W= RANGE(o-1); % Radio range (in meters)
    
    parfor n = 1:N
       map= InitializeState(par);% Initialization of mobile node positions and auxiliary matrices:
       counter= InitializeCounter(par,N); % Initialization of statistical counters
       L= [];
       C= [];
        for iter= 1:T
            %waitbar(((n-1)*T+iter)/(N*T),h,sprintf('Running sim: %10.d  of %8.d',(n-1)*T+iter, T*N ));
            % Update of  mobile node positions and auxiliary matrices:
            map= UpdateState(par,map);

            % Compute L with the node pairs with direct wireless links:
            L= ConnectedList(par,map);
            % Compute C with the nodes with Internet access:
            C= ConnectedNodes(par,L);
            % Update of statistical counters:
            counter= UpdateCounter(counter,C,n);
            % Visualization of the simulation:
            if plotar>0        
                visualize(par,map,L,C.',plotar);
            end

        end    
        % Compute the final result: 
        size(C);
        size(counter);

        [AverageAvailability(n), MinimumAvailability(n)]= results(T,counter);
    end
    
    %delete(h);
    toprint = fprintf("Simulating case %s where N = %i and W = %i ",CASES(o-1),par.N,par.W);
    disp(toprint);
    AverageMatrix(o-1,1) = mean(AverageAvailability);
    AverageMatrix(o-1,2) = norminv(1-alfa/2)*sqrt(var(AverageAvailability)/N);
    MinimumMatrix(o-1,1) = mean(MinimumAvailability);
    MinimumMatrix(o-1,2) = norminv(1-alfa/2)*sqrt(var(MinimumAvailability)/N);
    toprint = fprintf("Average,90ConfAverafe,Minimum,90ConfMinimum  %1.8f  %1.8f %1.8f %1.8f"...
            ,AverageMatrix(o-1,1), AverageMatrix(o-1,2),MinimumMatrix(o-1,1),MinimumMatrix(o-1,2));
    disp(toprint);
    
end
toc;

function map= InitializeState(par)
    N= par.N;
    X= 400;
    Y= 300;
    pos= [50*randi([0 floor(Y/50)],N/2,1) Y*rand(N/2,1)];
    pos= [pos; X*rand(N/2,1) 50*randi([0 floor(X/50)],N/2,1)];
    vel_abs= 2*rand(N,1);
    vel_cont= randi(100,N,1);
    vel_angle= pi*randi([0 1],N/2,1) - pi/2;
    vel_angle= [vel_angle; pi*randi([0 1],N/2,1)];
    vel= [vel_abs.*cos(vel_angle) vel_abs.*sin(vel_angle)];
    map.pos= pos;
    map.vel= vel;
    map.vel_cont= vel_cont;
end

function counter= InitializeCounter(par,N)
% counter - an array with par.N values (one for each mobile node) to count
%           the number of time slots each node has Internet access
% This function creates the array 'counter' and initializes it with zeros
% in all positions. 
counter = zeros(1,par.N);
end

function map= UpdateState(par,map)
    X= 400;
    Y= 300;
    N= par.N;
    pos= map.pos;
    vel= map.vel;
    vel_cont= map.vel_cont;
    delta= par.delta;    
    max_pos= [X*ones(N,1) Y*ones(N,1)];
    continuar= [vel_cont>0 vel_cont>0];
    pos= pos + delta*continuar.*vel;
    vel(pos<=0)= -vel(pos<=0);
    pos(pos<0)= 0;
    vel(pos>=max_pos)= -vel(pos>=max_pos);
    pos(pos>max_pos)= max_pos(pos>max_pos);
    map.pos= pos;
    map.vel= vel;
    aux= zeros(N,1);
    for j=find(vel_cont==1)
        aux(j)= -randi(40);
    end
    for j=find(vel_cont==-1)
        aux(j)= randi(100);
    end
    aux(vel_cont>1)= vel_cont(vel_cont>1)-1;
    aux(vel_cont<-1)= vel_cont(vel_cont<-1)+1;
    map.vel_cont= aux;
end

function counter= UpdateCounter(counter,C,n)
% This function increments the values of array 'counter' for mobile nodes
% that have Internet access.
   counter = counter + C;
end

function L= ConnectedList(par,map)
% map.pos - a matrix with par.N rows and 2 columns; each row identifies the (x,y)
%           coordinates of each mobile node
% L -       a matrix with 2 columns; each row identifies a pair of nodes (mobile
%           nodes and AP nodes) with direct wireless links between them
% This function computes matrix 'L' based on matrix map.pos.
assist = [map.pos; par.AP];
dist = pdist2(assist, assist);
Lbool = dist < par.W & dist ~= 0;
[I,J] = find(triu(Lbool,1));
L = [I,J];
end

function C= ConnectedNodes(par,L)
% C - an array with N values (one for each mobile node) that is 1 in 
%     position i if mobile node i has Internet access
% This function computes array 'C' based on matrix 'L' with the node pairs
% that have direct wireless links.
%

% NOTE: To develop this function, check MATLAB function 'distances' that
%       computes shortest path distances of a graph.
x = par.N +par.nAP+1;
L_temp = L;
for n = 1:par.nAP
    L_temp = [ L_temp ; x (par.N+n)];
end
G = graph(L_temp(:,1),L_temp(:,2)); % plot(G);
C = distances(G,1:par.N,x).';
C = C < Inf; 
end

function [AverageAvailability, MinimumAvailability]= results(T,counter)
% This function computes the average and the minimum availability (values
% between 0 and 1) based on array 'counter' and on the total number of
% time slots T.


AverageAvailability =  mean(counter)/T;
MinimumAvailability = min(counter)/T;
end

function visualize(par,map,L,C,plotar)
    N= par.N;
    X= 400;
    Y= 300;
    pos= map.pos;
    AP= par.AP;
    nAP= par.nAP;
    plot(AP(1:nAP,1),AP(1:nAP,2),'s','MarkerEdgeColor','k','MarkerFaceColor','k','MarkerSize',12)
    hold on
    plot(pos(1:N,1),pos(1:N,2),'o','MarkerEdgeColor','r','MarkerFaceColor','r','MarkerSize',5)
    hold on
    %rad = ones(par.N,1).*par.W;
    %viscircles(pos,rad)
    
    if plotar==2
        pos=[pos;AP];
        for i=1:size(L,1)
            plot([pos(L(i,1),1) pos(L(i,2),1)],[pos(L(i,1),2) pos(L(i,2),2)],'b')
        end
        plot(pos(C,1),pos(C,2),'o','MarkerEdgeColor','b','MarkerFaceColor','b')
    end
    axis([-20 X+20 -20 Y+20])
    grid on
    set(gca,'xtick',0:50:X)
    set(gca,'ytick',0:50:Y)
    drawnow
    hold off
end

function h = circle(x,y,r)
hold on
th = 0:pi/50:2*pi;
xunit = r * cos(th) + x;
yunit = r * sin(th) + y;
h = [xunit,yunit];
end