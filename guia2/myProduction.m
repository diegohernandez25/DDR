%Author: Diego Caldeira Hernandez & Ricardo Pousa

function [result] = myProduction(vec)
%MyProduction: implements the product for elements between a range. Returns
%the vector of the results
    result = zeros(1,length(vec));
    for i = 1:length(vec)
        result(i) = prod(vec(1:i));
    end
end

