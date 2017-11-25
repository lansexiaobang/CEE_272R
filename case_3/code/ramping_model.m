function [results]=ramping_model(CL,RR,PGu,PGl,Pstart,dt,dp)
% CL: MC for each generator (n,1)
% RR: Ramping rate for each generator (n,1)
% PGu: maximum generation for each generator (n,1)
% PGl: min generation for each generator (n,1)
% dt: duration of each ramp
% dp: ramp magnitude for each ramp
% Pstart: starting generation for each generator (n, 1), output from dcopf fxn
% n: number of generators
% k: number of events 
n = length(RR);
cvx_begin
   variable RC(n);
   varialbe Pend(n);
   minimize(sum(PG.* CL)) % objective function
   subject to
   sum(RC) >= dp/dt; % sum of ramping capacity has to exceed the ramping need(ramp slope)
   RC <= RR; % for each generator, ramping capacity is limited by its ramping rate
   RC <= (PGu-Pstart)./dt
   Pend == Pstart + RC.*dt
cvx_end
results.cost = cvx_optval
results.RC = RC;
results.Pend = Pend;



   
   