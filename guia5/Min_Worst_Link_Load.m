function [solution]=  Min_Worst_Link_Load(paths,flowDemand,r,shortest_paths,all,link_load,consumption);

Number_of_Flows = size(flowDemand);

tmp_flow_demand = zeros(Number_of_Flows,2);
tmp_flow_demand(:,1)= flowDemand;
tmp_flow_demand(:,2)= 1:1:Number_of_Flows;
tmp_flow_demand = sortrows(tmp_flow_demand,1,'descend');
    
    worstlinkload = 0;
    
    while worstlinkload < link_load
    Links = Direct_Links(r,all);
    for f = 1:Number_of_Flows
        tmp_flow = tmp_flow_demand(f,2);
        tmp_demand = tmp_flow_demand(f,1);
        tmp_path = shortest_paths(tmp_flow);
        for i = 1:(size(tmp_path)-1)
            Links{3}(tmp_path(i),tmp_path(i+1))= Links{3}(tmp_path(i),tmp_path(i+1))+tmp_demand; 
            Links{4}(tmp_path(i),tmp_path(i+1))= Links{4}(tmp_path(i),tmp_path(i+1))+1;
            Links{5}(tmp_path(i),tmp_path(i+1))= 1;
            Links{5}(tmp_path(i+1),tmp_path(i))= 1;
        end        
    end
    end
    Consumption = Consumption_compute(Links,consumption);
    worstlinkload= maxLoad(paths,shortest_paths,flowDemand,r);
    
    max(paths)
    
end


function Consumption = Consumption_compute(Links,consumption)
    Consumption = 0;
    number_of_nodes = size(Links{1},1);
    for y = 1:number_of_nodes
        for j = 1:y
        Consumption = Links{5}(y,j)*consumption(y,j);    
        end    
    end
end


% % Links
%    {1}        {2}         {3}         {4}          {5}
% Link pair   capacity      load   amount of flows  on/off

function Links = Direct_Links(r,all)
Links = cell(1,5);

    for I =1:size(all,2)
        for j =1:size(all,2)
            if(r(I,j)~= 0)
                Links{1}{I,j}= [I,j];
                Links{2}{I,j}= r(I,j);
            end 
            Links{3}{I,j}= 0;
            Links{4}{I,j}= 0;
            Links{5}{I,j}= 0;
        end
    end
end