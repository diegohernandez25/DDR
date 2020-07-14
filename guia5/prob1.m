clear all;
Matrices;
nNodes= size(L,1);
%k= 5, 10, 15, 20, 25 and 30
nPaths= 30;
f= 0;
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
tic
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

fprintf("worst link load: %d  \n",worstlinkload)
fprintf("toc: %f\n",toc)
