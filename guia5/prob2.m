% Author: Diego Caldeira Hernandez Ricardo Pousa
% Problem 2

clear all;
Matrices;

%k= 5, 10, 15, 20, 25 and 30
nPaths= 30;
%counting number of links

[row,col] = find(L ~= Inf);
Links = [row col];
Links = Links(Links(:,1)<Links(:,2),:);
numLinks=size(Links,1);

fid = fopen('tmpMatrix.txt','wt');
T_L = L;
T_C = C;
worst_link_load = 1;
improved = 1;
changed = 0;
Temporary_L = L;
while (improved)
    T_L = Temporary_L;
    for u = 1:numLinks
        [Temp_L,Temp_C] = Link_to_bed(T_C,T_L,Links(u,1),Links(u,2));
        link = [Links(u,1),Links(u,2)];
        [shortestPaths,worstlinkload,solution] = Compute_worst_link_load(T,Temp_L, nPaths,R);
        [Consumption,Links_used] = Consumption_compute(shortestPaths, solution ,C);
        disp(Links_used);
        disp(Links);
        fprintf("Not used links:");
        Not_used_Links = setdiff(Links,Links_used);
        Not_used_Links = setdiff(Not_used_Links,link); 
        disp(Not_used_Links);
        Energy_consumed = sum(sum(Temp_C))/2;
        fprintf("   ")
        fprintf("link: %d, %d wll: %d energy_comsumption: %d time:%d \n possible links to disable:",Links(u,1),Links(u,2),worstlinkload,Energy_consumed,toc)
        for i = 1:size(Not_used_Links,1)
            fprintf("link %d %d",Not_used_Links(i,1),Not_used_Links(i,2));
        end    
        fprintf("Possible Consumption: %d ",Consumption);
        fprintf(fid,'%g\t',[Links(u,1) Links(u,2) worstlinkload Energy_consumed toc]);
        fprintf(fid,'\n');
        fprintf("toc: %f\n",toc)
        if(worstlinkload < worst_link_load)
            Temporary_L = Temp_L;
        end    
    end
    
    
end
function [Consumption,Links_used] = Consumption_compute(shortest_paths, solution ,C)
    Consumption = 0;
    Links_used = [-1 -1];
    for i = 1:size(solution,2)
        for I = 1:(size(shortest_paths{i}{solution(i)},2)-1) 
            link = [shortest_paths{i}{solution(i)}(I),shortest_paths{i}{solution(i)}(I+1)];
            used = ismember(Links_used,link,'rows');
               if(used == 0)
                  Links_used(end+1,:) =[link] ; 
                  Consumption = Consumption +  C(link(1),link(2));  
               end
        end    
    end
end

function [Temp_L,Temp_C] = Link_to_bed(C,L,i,j)
   Temp_L = L;
   Temp_C = C;
   Temp_C(i,j)= 0;
   Temp_C(j,i)= 0;
   Temp_L(i,j)= inf;
   Temp_L(j,i)= inf;
end

function [shortestPaths,worstlinkload,solution] = Compute_worst_link_load(T,L, nPaths,R)
f= 0;
nNodes= size(L,1);
    tic
    for i=1:nNodes
        for j= 1:nNodes
            if T(i,j)>0
                f= f+1;
                flowDemand(f) = T(i,j);
                [shortestPaths{f}, tc] = kShortestPath(L, i, j, nPaths);
                if isempty(tc)
                    fprintf('Error: no connectivity\n');
                end
            end
        end
    end
    
    nFlows= length(flowDemand);
    solution= ones(1,nFlows);
    worstlinkload= maxLoad(solution,shortestPaths,flowDemand,R);
    improved = true;
    count = 0;
    best_solution = ones(1,nFlows);
    best_worstlinkload = worstlinkload;
    
    while improved 
        count = count + 1;
        [count best_worstlinkload];
        for f = 1:nFlows
            for p = 1:length(shortestPaths{f})
                if solution(f) ~= p
                   tmp_solution = solution;
                   tmp_solution(f) = p;
                   tmp_worstlinkload = maxLoad(tmp_solution, shortestPaths, flowDemand, R);
                   if(best_worstlinkload > tmp_worstlinkload) 
                       best_worstlinkload = tmp_worstlinkload;
                       best_solution = tmp_solution;
                   end
                end
            end
        end

        if(worstlinkload > best_worstlinkload)
           worstlinkload = best_worstlinkload;
           solution = best_solution;
        else
           improved = false;
        end
    end
end