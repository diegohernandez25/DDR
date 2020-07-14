% Author: Diego Caldeira Hernandez Ricardo Pousa
% Problem 2

clear all;
Matrices;
nPaths= 5;

%gets all bi directional links  and the number of links.
[row,col] = find(L ~= Inf);
Links = [row col];
Links = Links(Links(:,1)<Links(:,2),:);
numLinks=size(Links,1);

%worst link loads values
w = [0.7 0.75 0.80 0.85];
w_index = 2;

%removedd link storage
worst_link_load = w(w_index);
removed_links = [];

while( worst_link_load <= w(w_index))
    best_calculated_worst_link_load = Inf;
    best_energy_calculated_worst_link_load = Inf;
    linkIndex = -1;
    %determinar o best worst link load ao retirar o link
    for index = 1:numLinks %percorro todos os links disponiveis na rede
        %removes the link at the network
        [Temp_L, Temp_C, Temp_R] = remove_link(L, R, C, Links(index,1), Links(index,2));
        %calculates the best worst link load of network
        calculated_worst_link_load = compute_worst_link_load(T, Temp_L, Temp_R,nPaths); 
        
        energy_calculated_worst_link_load = calculated_worst_link_load./C(Links(index,1),Links(index,2));
        
        if(energy_calculated_worst_link_load < best_energy_calculated_worst_link_load && calculated_worst_link_load<=w(w_index))
           best_energy_calculated_worst_link_load = energy_calculated_worst_link_load;
           best_calculated_worst_link_load =  calculated_worst_link_load;
           linkIndex = index;
        end
    end
    if(best_calculated_worst_link_load > w(w_index))
       break; 
    end
    worst_link_load = best_calculated_worst_link_load;
    %removes permanently link
    tmpLink = Links(linkIndex, :);
    tmpLink
    %stores links from removed links matrix
    removed_links = [removed_links; tmpLink];
    Links(linkIndex,:) = [];
    numLinks=size(Links,1);
    [L, C, R] = remove_link(L, R, C, tmpLink(1,1), tmpLink(1,2));
    fprintf("Worst link load: %d\n",worst_link_load);
end
fprintf("final worst link load: %d\n",worst_link_load);
fprintf("final energy consumption: %d\n",sum(sum(C))/2);
removed_links


%removes desired link of the network
function [Temp_L,Temp_C, Temp_R] = remove_link(L,R,C,i,j)
   Temp_L = L; 
   Temp_R = R;
   Temp_C = C;
   Temp_C(i,j) = 0;
   Temp_C(j,i) = 0;
   Temp_R(i,j) = 0;
   Temp_R(j,i) = 0;
   Temp_L(i,j)= inf; 
   Temp_L(j,i)= inf; 
end

%computes worst link load of the network
function worstlinkload = compute_worst_link_load(T,L,R, nPaths)
    f= 0;
    nNodes= size(L,1);
    for i=1:nNodes
        for j= 1:nNodes
            if T(i,j)>0
                f= f+1;
                flowDemand(f) = T(i,j);
                [shortestPaths{f}, tc] = kShortestPath(L, i, j, nPaths);
                if isempty(tc)
                    worstlinkload = Inf;
                    return
                    %fprintf('Error: no connectivity\n');
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
        %[count best_worstlinkload]
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
