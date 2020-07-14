% Author: Diego Caldeira Hernandez
format long;

% Problem 2

% a.
% What is the average percentage of time the link 
% is on each of the five possible states?


%
lambdas = [1 5 10 10];
u = [195 40 20 5];
div = lambdas ./u;
myprod = myProduction(div);
div = (1 + sum(myprod));

P0 = 1/div;
P = zeros(1,length(lambdas));
for i= 1:length(lambdas)
    P(i) = myprod(i) / div;
end
%result
P = [P0 P]; 



% b.
% What is the average time duration (in minutes) that the link is on each of the five
% possible states?
% Note: transitions per hour

T0 = (1/1) * 60;
T1 = (1/(195+5)) * 60;
T2 = (1/(40+10)) * 60;
T3 = (1/(20+10)) * 60;
T4 = (1/5) * 60;

disp(T0);
disp(T1);
disp(T2);
disp(T3);
disp(T4);

% c.
% What is the probability of the link being in interference state?
% Note: Consider that the link is in interference state when its bit error rate is 10-3
% or higher.

%res = sum([P(4) P(5)]);
res = P(4)+P(5);
disp(res);

% d.
% What is the average bit error rate of the link when it is in the interference state?
res_mean = (P(4).*(1e-3) + P(5).*(1e-2))/res; 

%e
% What is the average time duration (in minutes) of the interference state?
P3_2 = 20/(20 + 10);
P3_4 = 10/(20 + 10);

total_iter = 15;
sum_p = 0;
for i=0:14
    i_tmp = (((P3_4).^i)*P3_2).*(T3 +(T3+T4).*i);
    disp(i_tmp)
    sum_p = sum_p + i_tmp;
end
disp(sum_p); %tempo medio total 
