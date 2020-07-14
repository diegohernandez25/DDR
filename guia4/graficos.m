format long;


%case	r   (bytes)	f (Bytes)	Avg. Packet Loss ()	90conf	Avg. Packet Delay (msec)	90conf	Transmitted Throughput (Mbps)	90%conf
A	= [6,	150000,	0.0,         0.000000,	1.623723,	0.002012,	6.003503,	0.004580];
B	= [8,	150000,	0.0,         0.000000,	2.985540,	0.009884,	8.002095,	0.005299];
C	= [9,	150000,	0.0,         0.000000,	5.766522,	0.036935,	9.005573,	0.005027];
D	= [9.5,	150000,	0.000008,	0.000014,	11.062033,	0.126032,	9.499063,	0.004383];
E	= [9.75,150000,	0.006458,	0.001976,	21.432391,	0.629102,	9.748045,	0.005000];
F	= [10.0,150000,	0.326935,	0.023662,	60.819711,	0.980454,	9.956237,	0.003440];
G	= [6,	15000,	0.001162,	0.000371,	1.623549,	0.003302,	6.003646,	0.004457];
H	= [8,	15000,	0.144837,	0.004065,	2.873813,	0.007381,	7.983578,	0.004967];
I	= [9,	15000,	0.868799,	0.014187,	4.308028,	0.013788,	8.889465,	0.004239];
J	= [9.5,	15000,	1.764129,	0.014714,	5.288708,	0.015927,	9.262063,	0.003944];
K	= [9.75,15000,	2.435815,	0.022297,	5.839905,	0.015624,	9.422661,	0.002479];
L	= [10,	15000,	3.215775,	0.019025,	6.366030,	0.009140,	9.553501,	0.002479];

q = [A.', B.', C.', D.', E.', F.', G.', H.', I.', J.', K.', L.'];
q = q.';
X_values = categorical(["(A,6(Mbps),150e3(Bytes))","(B,8(Mbps),150e3(Bytes))","(C,9(Mbps),150e3(Bytes))",...
                    "(D,9.5(Mbps),150e3(Bytes))","(E,9.75(Mbps),150e3(Bytes))","(F,10(Mbps),150e3(Bytes))",...
                    "(G,6(Mbps),15e3(Bytes))","(H,8(Mbps),15e3(Bytes))","(I,9(Mbps),15e3(Bytes))",...
                    "(J,9.5(Mbps),15e3(Bytes))","(K,9.75(Mbps),150e3(Bytes))","(L,10(Mbps),15e3(Bytes))"]);
X = categorical(["A","B","C","D","E","F","G","H","I","J","K","L"]);                
                
% X_values = reordercats(X_values,{"(A,6(Mbps),150e3(Bytes))","(B,8(Mbps),150e3(Bytes))","(C,9(Mbps),150e3(Bytes))",...
%                     "(D,9.5(Mbps),150e3(Bytes))","(E,9.75(Mbps),150e3(Bytes))","(F,10(Mbps),150e3(Bytes))",...
%                     "(G,6(Mbps),15e3(Bytes))","(H,8(Mbps),15e3(Bytes))","(I,9(Mbps),15e3(Bytes))",...
%                     "(J,9.5(Mbps),15e3(Bytes))","(K,9.75(Mbps),150e3(Bytes))","(L,10(Mbps),15e3(Bytes))"});

figure
ax = subplot(1,3,1);
yyaxis left
a = bar(X, q(:,3));
ylabel('PacketLoss per Case');
yyaxis right
plot(X, q(:,4),"x",'linewidth',4);
ylabel('90% confidence interval');
set(a,'FaceColor',[0.00 0.0 0.70]);
title('Average PacketLoss');
grid on

bx = subplot(1,3,2);
yyaxis left
b = bar(X, q(:,5));
ylabel('Delays per Case');
yyaxis right
plot(X,q(:,6),"x",'linewidth',4);
ylabel('90% confidence interval');
title('Average Delays');
set(b,'FaceColor',[0.000 0.780 0.00840]);
grid on

cx = subplot(1,3,3);
yyaxis left
c = bar(X,q(:,7));
ylabel('Throughput per Case');
yyaxis right
plot(X, q(:,8),"x",'linewidth',4);
ylabel('90% confidence interval');
title('Average throughput');
set(c,'FaceColor',[0.9290 0.6940 0.1250]);
grid on

% X = categorical(["e) packet loss","e) packet delay","f) flow 1 packet loss","f) flow 1 packet delay","f) flow 2 packet loss","f) flow 2 packet delay",...
%                  "f) flow 3 packet loss","f) flow 3 packet delay","h) flow 1 packet loss", "h) flow 1 packet delay",...
%                  "h) flow 2 packet loss","h) flow 2 packet delay","h) flow 3 packet loss","h) flow 3 packet delay"]);         
% 
% 
% e_Average_Packet_Loss = [0.000000  0.000000];		
% e_Average_Packet_Delay = [7.012268  0.026511];		
% 		
% f_Average_Packet_Loss_1 = [0.001981  0.001123];		
% f_Average_Packet_Delay_1 = [18.164663 0.351195];		
% f_Average_Packet_Loss_2 = [0.001707  0.001212];	
% f_Average_Packet_Delay_2 = [44.406838 0.989540];		
% f_Average_Packet_Loss_3 = [0.000256 0.000422];		
% f_Average_Packet_Delay_3 = [26.212739  0.692119];		
% 		
% h_Average_Packet_Loss_1 = [ 5.346815 0.018608 ];	
% h_Average_Packet_Delay_1 = [ 3.198475  0.001634	];		
% h_Average_Packet_Loss_2 = [ 5.361737 0.028039 ];	
% h_Average_Packet_Delay_2 = [ 17.264694  0.244895 ];	
% h_Average_Packet_Loss_3 = [ 0.000000 0.000000 ];	
% h_Average_Packet_Delay_3 = [ 14.138825  0.239468 ];	
% 
% y = [e_Average_Packet_Loss.', e_Average_Packet_Delay.', f_Average_Packet_Loss_1.',...
%     f_Average_Packet_Delay_1.', f_Average_Packet_Loss_2.', f_Average_Packet_Delay_2.',...
%     f_Average_Packet_Loss_3.', f_Average_Packet_Delay_3.', h_Average_Packet_Loss_1.' , ...
%     h_Average_Packet_Delay_1.', h_Average_Packet_Loss_2.', h_Average_Packet_Delay_2.',...
%     h_Average_Packet_Loss_3.', h_Average_Packet_Delay_3.' ];
% 
% y = y.';
% 
% 
% yyaxis left
% a = bar(X, y(:,1));
% yyaxis right
% plot(X, y(:,2),"rs",'MarkerSize',10);
% ylabel('90% confidence interval');
% set(a,'FaceColor',[0.00 0.000 0.70]);
% title('E) F) H)');
% grid on

%For X == 10000000.000000		
% X_10_Average_Packet_Loss_1 = [ 32.622797   0.089153 ];		
% X_10_Average_Packet_Delay_1 = [ 119.420224   0.006440 ];		
% X_10_Average_Packet_Loss_2 = [ 32.677163   0.088397 ];	
% X_10_Average_Packet_Delay_2 = [ 119.634618   0.005283 ];	
% X_10_Average_Packet_Loss_3 = [ 32.612435   0.053897 ];	
% X_10_Average_Packet_Delay_3 = [ 119.523856   0.004315 ];	
% X_10_Average_Packet_Loss_4 = [ 36.811020   0.048816 ];	
% X_10_Average_Packet_Delay_4 = [ 119.566005   0.003490 ];	
% X_10_Average_Packet_Loss_5 = [ 0.000000   0.000000 ];	
% X_10_Average_Packet_Delay_5 = [ 0.226452   0.000452 ];	
% X_10_Average_Packet_Loss_6 = [ 0.000000   0.000000 ];	
% X_10_Average_Packet_Delay_6 = [ 0.107003   0.000110 ];	
% X_10_Average_Packet_Loss_7 = [ 36.781449   0.107887 ];	
% X_10_Average_Packet_Delay_7 = [ 119.776369   0.005767 ];	
% X_10_Average_Packet_Loss_8 = [ 0.000000   0.000000 ];	
% X_10_Average_Packet_Delay_8 = [ 0.220742   0.000427 ];	
% X_10_Average_Packet_Loss_9 = [ 0.000000   0.000000 ];	
% X_10_Average_Packet_Delay_9 = [ 0.324954   0.000360 ];	
% X_10_Average_Packet_Loss_10 = [ 36.796820   0.089147 ];	
% X_10_Average_Packet_Delay_10 = [ 119.663485   0.006516 ];	
% X_10_Average_Packet_Loss_11 = [ 0.000000   0.000000 ];	
% X_10_Average_Packet_Delay_11 = [ 0.105952   0.000122 ];	
% X_10_Average_Packet_Loss_12 = [ 0.000000   0.000000 ];	
% X_10_Average_Packet_Delay_12 = [ 0.335290   0.000455 ];	
% 		
% %For X == 20000000.000000		
% X_20_Average_Packet_Loss_1 = [ 0.000000   0.000000 ];		
% X_20_Average_Packet_Delay_1 = [ 2.864723   0.037099 ];		
% X_20_Average_Packet_Loss_2 = [ 0.000000   0.000000 ];	
% X_20_Average_Packet_Delay_2 = [ 3.100683   0.036277 ];	
% X_20_Average_Packet_Loss_3 = [ 0.000000   0.000000 ];	
% X_20_Average_Packet_Delay_3 = [ 2.972467   0.038195 ];	
% X_20_Average_Packet_Loss_4 = [ 0.270360   0.028385 ];	
% X_20_Average_Packet_Delay_4 = [ 28.342042   0.876177 ];	
% X_20_Average_Packet_Loss_5 = [ 0.000000   0.000000 ];	
% X_20_Average_Packet_Delay_5 = [ 0.248304   0.000474 ];	
% X_20_Average_Packet_Loss_6 = [ 0.000000   0.000000 ];	
% X_20_Average_Packet_Delay_6 = [ 0.112083   0.000083 ];	
% X_20_Average_Packet_Loss_7 = [ 0.281564   0.026982 ];	
% X_20_Average_Packet_Delay_7 = [ 28.550897   0.881639 ];	
% X_20_Average_Packet_Loss_8 = [ 0.000000   0.000000 ];	
% X_20_Average_Packet_Delay_8 = [ 0.221040   0.000243 ];	
% X_20_Average_Packet_Loss_9 = [ 0.000000   0.000000 ];	
% X_20_Average_Packet_Delay_9 = [ 0.330524   0.000304 ];	
% X_20_Average_Packet_Loss_10 = [ 0.259422   0.029931 ];	
% X_20_Average_Packet_Delay_10 = [ 28.438654   0.866987 ];	
% X_20_Average_Packet_Loss_11 = [ 0.000000   0.000000 ];	
% X_20_Average_Packet_Delay_11 = [ 0.106019   0.000071 ];	
% X_20_Average_Packet_Loss_12 = [ 0.000000   0.000000 ];	
% X_20_Average_Packet_Delay_12 = [ 0.357303   0.000476	];	
% 		
% %For X == 30000000.000000		
% X_30_Average_Packet_Loss_1 = [ 0.000000   0.000000 ];	
% X_30_Average_Packet_Delay_1 = [ 0.540714   0.001470 ];	
% X_30_Average_Packet_Loss_2 = [ 0.000000   0.000000 ];	
% X_30_Average_Packet_Delay_2 = [ 0.790797   0.001225 ];	
% X_30_Average_Packet_Loss_3 = [ 0.000000   0.000000 ];	
% X_30_Average_Packet_Delay_3 = [ 0.652989   0.001098 ];	
% X_30_Average_Packet_Loss_4 = [ 0.000000   0.000000 ];	
% X_30_Average_Packet_Delay_4 = [ 0.630998   0.001111 ];	
% X_30_Average_Packet_Loss_5 = [ 0.000000   0.000000 ];	
% X_30_Average_Packet_Delay_5 = [ 0.249377   0.000671 ];	
% X_30_Average_Packet_Loss_6 = [ 0.000000   0.000000 ];	
% X_30_Average_Packet_Delay_6 = [ 0.112382   0.000093 ];	
% X_30_Average_Packet_Loss_7 = [ 0.000000   0.000000 ];	
% X_30_Average_Packet_Delay_7 = [ 0.851666   0.001495 ];	
% X_30_Average_Packet_Loss_8 = [ 0.000000   0.000000 ];	
% X_30_Average_Packet_Delay_8 = [ 0.221121   0.000266 ];	
% X_30_Average_Packet_Loss_9 = [ 0.000000   0.000000 ];	
% X_30_Average_Packet_Delay_9 = [ 0.330753   0.000282 ];	
% X_30_Average_Packet_Loss_10 = [ 0.000000   0.000000 ];	
% X_30_Average_Packet_Delay_10 = [ 0.739606   0.001809 ];	
% X_30_Average_Packet_Loss_11 = [ 0.000000   0.000000 ];	
% X_30_Average_Packet_Delay_11 = [ 0.105905   0.000083 ];	
% X_30_Average_Packet_Loss_12 = [ 0.000000   0.000000 ];	
% X_30_Average_Packet_Delay_12 = [ 0.358658   0.000765 ];	
% 
% X_1_L = [X_10_Average_Packet_Loss_1.',X_10_Average_Packet_Loss_2.',...
%     X_10_Average_Packet_Loss_3.', X_10_Average_Packet_Loss_4.',...
%     X_10_Average_Packet_Loss_5.', X_10_Average_Packet_Loss_6.',...
%     X_10_Average_Packet_Loss_7.', X_10_Average_Packet_Loss_8.',...
%     X_10_Average_Packet_Loss_9.', X_10_Average_Packet_Loss_10.',...
%     X_10_Average_Packet_Loss_11.',X_10_Average_Packet_Loss_12.'];
% 
% X_1_D = [X_10_Average_Packet_Delay_1.',X_10_Average_Packet_Delay_2.',...
%     X_10_Average_Packet_Delay_3.', X_10_Average_Packet_Delay_4.',...
%     X_10_Average_Packet_Delay_5.', X_10_Average_Packet_Delay_6.',...
%     X_10_Average_Packet_Delay_7.', X_10_Average_Packet_Delay_8.',...
%     X_10_Average_Packet_Delay_9.', X_10_Average_Packet_Delay_10.',...
%     X_10_Average_Packet_Delay_11.',X_10_Average_Packet_Delay_12.'];
% 
% X_2_L = [X_20_Average_Packet_Loss_1.',X_20_Average_Packet_Loss_2.',...
%     X_20_Average_Packet_Loss_3.', X_20_Average_Packet_Loss_4.',...
%     X_20_Average_Packet_Loss_5.', X_20_Average_Packet_Loss_6.',...
%     X_20_Average_Packet_Loss_7.', X_20_Average_Packet_Loss_8.',...
%     X_20_Average_Packet_Loss_9.', X_20_Average_Packet_Loss_10.',...
%     X_20_Average_Packet_Loss_11.',X_20_Average_Packet_Loss_12.'];
% 
% X_2_D = [X_20_Average_Packet_Delay_1.',X_20_Average_Packet_Delay_2.',...
%     X_20_Average_Packet_Delay_3.', X_20_Average_Packet_Delay_4.',...
%     X_20_Average_Packet_Delay_5.', X_20_Average_Packet_Delay_6.',...
%     X_20_Average_Packet_Delay_7.', X_20_Average_Packet_Delay_8.',...
%     X_20_Average_Packet_Delay_9.', X_20_Average_Packet_Delay_10.',...
%     X_20_Average_Packet_Delay_11.',X_20_Average_Packet_Delay_12.'];
% 
% X_3_L = [X_30_Average_Packet_Loss_1.',X_30_Average_Packet_Loss_2.',...
%     X_30_Average_Packet_Loss_3.', X_30_Average_Packet_Loss_4.',...
%     X_30_Average_Packet_Loss_5.', X_30_Average_Packet_Loss_6.',...
%     X_30_Average_Packet_Loss_7.', X_30_Average_Packet_Loss_8.',...
%     X_30_Average_Packet_Loss_9.', X_30_Average_Packet_Loss_10.',...
%     X_30_Average_Packet_Loss_11.',X_30_Average_Packet_Loss_12.'];
% 
% X_3_D = [X_30_Average_Packet_Delay_1.',X_30_Average_Packet_Delay_2.',...
%     X_30_Average_Packet_Delay_3.', X_30_Average_Packet_Delay_4.',...
%     X_30_Average_Packet_Delay_5.', X_30_Average_Packet_Delay_6.',...
%     X_30_Average_Packet_Delay_7.', X_30_Average_Packet_Delay_8.',...
%     X_30_Average_Packet_Delay_9.', X_30_Average_Packet_Delay_10.',...
%     X_30_Average_Packet_Delay_11.',X_30_Average_Packet_Delay_12.'];
%     
% 
% X = [X_1_L.',X_1_D.', X_2_L.', X_2_D.', X_3_L.' , X_3_D.'];
% 
% Legend = categorical(["1 FLow","2 FLow ","3 FLow","4 FLow","5 FLow","6 FLow","7 FLow","8 FLow","9 FLow","10 FLows","11 FLows","12 FLows"]);
% Legend = reordercats(Legend,["1 FLow","2 FLow ","3 FLow","4 FLow","5 FLow","6 FLow","7 FLow","8 FLow","9 FLow","10 FLows","11 FLows","12 FLows"] );
% 
% ax = subplot(3,2,1);
% yyaxis left
% a = bar(Legend, X(:,1));
% ylabel('PacketLoss per FLow');
% yyaxis right
% plot(Legend, X(:,2),"x",'linewidth',4);
% ylabel('90% confidence interval');
% set(a,'FaceColor',[0.00 0.0 0.70]);
% title('10 Mbps Loss');
% grid on
% 
% bx = subplot(3,2,2);
% yyaxis left
% b = bar(Legend, X(:,3));
% ylabel('Delays per Case');
% yyaxis right
% plot(Legend,X(:,4),"x",'linewidth',4);
% ylabel('90% confidence interval');
% title('10 Mbps Delays');
% set(b,'FaceColor',[0.000 0.780 0.00840]);
% grid on
% 
% cx = subplot(3,2,3);
% yyaxis left
% c = bar(Legend,X(:,5));
% ylabel('PacketLoss per FLow');
% yyaxis right
% plot(Legend, X(:,6),"x",'linewidth',4);
% ylabel('90% confidence interval');
% title('20 Mbps Loss');
% set(c,'FaceColor',[0.9290 0.6940 0.1250]);
% grid on  
% 
% a_x = subplot(3,2,4);
% yyaxis left
% a_1 = bar(Legend, X(:,7));
% ylabel('Delays per FLow');
% yyaxis right
% plot(Legend, X(:,8),"x",'linewidth',4);
% ylabel('90% confidence interval');
% set(a,'FaceColor',[0.00 0.0 0.70]);
% title('20 Mbps Delays');
% grid on
% 
% b_x = subplot(3,2,5);
% yyaxis left
% b_2 = bar(Legend, X(:,9));
% ylabel('PacketLoss per Flow');
% yyaxis right
% plot(Legend,X(:,10),"x",'linewidth',4);
% ylabel('90% confidence interval');
% title('30 Mbps Loss');
% set(b,'FaceColor',[0.000 0.780 0.00840]);
% grid on
% 
% c_x = subplot(3,2,6);
% yyaxis left
% c_2 = bar(Legend,X(:,11));
% ylabel('Delays per FLow');
% yyaxis right
% plot(Legend, X(:,12),"x",'linewidth',4);
% ylabel('90% confidence interval');
% title('30 Mbps Delays');
% set(c,'FaceColor',[0.9290 0.6940 0.1250]);
% grid on  