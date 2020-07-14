Matrices;
nNodes= size(L,1);
nPaths= 30;
f= 0;
tc = cell(1,nNodes);
shortestPaths = cell(1,nNodes);
for i=1:nNodes
    for j= 1:nNodes
        if T(i,j)>0
            f= f+1;
            flowDemand(f) = T(i,j);
            [shortestPaths{f}, tc{i}{j,2}] = kShortestPath(L, i, j, nPaths);
            %[shortestPaths{f}, tc{i}(j,:)] = kShortestPath(L, i, j, nPaths);
            tc{i}{j,1}= shortestPaths{f};
            tc{i}{j,3} =  f;
            if isempty(tc)
                fprintf('Error: no connectivity\n');
            end
        end
    end
end
nFlows= length(flowDemand);
%solution that considers the first candidate path for all flows:
solution= ones(1,nFlows);
link_load = 0.7;
%link_load ma
[tmp_solution] = Min_Worst_Link_Load(solution,flowDemand,R,shortest_Paths,tc,link_load,C);

worstlinkload= maxLoad(solution,shortestPaths,flowDemand,R);
display(tc);

