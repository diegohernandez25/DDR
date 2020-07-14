% Author: Diego Caldeira Hernandez & Ricardo Pousa
format shortG
%1.a
errorn = 1- (1-1e-7)^(64*8); %normal state for bit rate 10^-7 p = to 0 errors, 1-p having at least one error
errori = 1- (1-1e-3)^(64*8); %interference state
size = 64; %in bytes frame size going to be exchanged n frames
% false positive the link is in normal state but n consecutive frames had
% errors
% false negative the link is in interference state but at least one of the n 
% consecutive frames did not have errors
p = [0.99,0.999,0.9999,0.99999];

prob_de_erro = errorn.*p + errori.*(1-p);

%Answer :
prob_de_normal = ((errorn .* p)./prob_de_erro)*100
prob_de_interferencia = ((errori .* (1-p))./prob_de_erro)*100

%1.b

prob_de_erro = prob_de_erro';
i = 2;
prob = zeros(4,4);
prob_temp=0;
while  i < 6
    errortmpn =  errorn ^i;
    errortmpi =  errori ^i;
    i = i + 1 ;
    prob_de_errotmp = errortmpn.*p + errortmpi.*(1-p);
    erro(:,i-2) = prob_de_errotmp;
    prob_temp = ((errortmpn .* (p))./prob_de_errotmp);
    prob(:,i-2) = prob_temp;
end

erro;
%Answer:
prob1b = prob;
prob1b*100

%1.c

i=2;
while  i < 6
    errortmpn =  (1 - errorn ^i);
    errortmpi =  (1 - errori ^i);
    i = i + 1 ;
    prob_de_errotmp = errortmpn.*p + errortmpi.*(1-p);
    erro(:,i-2) = prob_de_errotmp;
    prob_temp = ((errortmpi .* (1-p))./prob_de_errotmp);
    prob(:,i-2) = prob_temp;
end

%Answer:
prob1c = prob;
prob1c*100
