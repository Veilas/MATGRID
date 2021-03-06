 function [pf] = newton_raphson(user, sys)

%--------------------------------------------------------------------------
% Solves the AC power flow problem and computes the bus complex voltages.
%
% The function uses the Newton-Raphson algorithm to solve the AC power flow
% problem. Also, the preprocessing time is over, and the convergence time
% is obtained here, while the postprocessing time is initialized.
%--------------------------------------------------------------------------
%  Inputs:
%	- user: user data
%	- sys: power system data
%
%  Outputs:
%	- pf.bus with columns:
%	  (1)bus complex voltages; (6) bus where the minimum limits violated;
%	  (7)bus where the maximum limits violated;
%	- pf.method: method name
%	- pf.grid: name of the analyzed power system
%	- pf.time.pre: preprocessing time
%	- pf.time.con: convergence time
%	- pf.iteration: number of iterations
%--------------------------------------------------------------------------
% Created by Mirsad Cosovic on 2019-02-21
% Last revision by Mirsad Cosovic on 2019-03-27
% MATGRID is released under MIT License.
%--------------------------------------------------------------------------


%------------------------Algorithm Initialization--------------------------
 pf.method = 'AC Power Flow using Newton-Raphson Algorithm';
 pf.bus = zeros(sys.Nbu,7);

 V  = sys.bus(:,3);
 T  = sys.bus(:,4);
 No = 0;
%--------------------------------------------------------------------------


%----------------------Limits, Indexes and Parameters----------------------
 [sys] = qv_limits(user, sys);
 [alg, idx] = idx_par1(sys);
 [alg, idx] = idx_par2(sys, alg, idx);
%--------------------------------------------------------------------------


%------------------------Algorithm Initialization--------------------------
 Vini = V .* exp(1i * T);
 Pgl  = sys.bus(:,11) - sys.bus(:,5);
 Qgl  = sys.bus(:,12) - sys.bus(:,6);

 DelS  = Vini .* conj(sys.Ybu * Vini) - (Pgl + 1i * Qgl);
 DelPQ = [real(DelS(alg.ii)); imag(DelS(alg.pq))];
%--------------------------------------------------------------------------


%---------------------------Preprocessing Time-----------------------------
 pf.time.pre = toc; tic
%--------------------------------------------------------------------------


%========================Newton-Raphson Algorithm==========================
 while max(abs(DelPQ)) > sys.stop && No < user.maxIter
 No = No + 1;


%--------------------Check Reactive Power Constraints----------------------
 if ismember('reactive', user.list)
	[sys, alg, idx, pf, V, T, Qgl, DelPQ] = cq(sys, alg, idx, pf, V, T, Qgl, Pgl, DelPQ);
 end
%--------------------------------------------------------------------------


%-------------------Check Voltage Magnitude Constraints--------------------
 if ismember('voltage', user.list)
	[sys, alg, idx, pf, DelPQ, V, T] = cv(sys, alg, idx, pf, DelPQ, V, T, Pgl, Qgl);
 end
%--------------------------------------------------------------------------


%-----------------------------Jacobian Matrix------------------------------
 [alg] = data_jacobian(T, V, alg, sys.Nbu);
 [J11] = jacobian11(V, alg, idx.j11, sys.Nbu);
 [J12] = jacobian12(V, alg, idx.j12, sys.Nbu);
 [J21] = jacobian21(alg, idx.j21, sys.Nbu);
 [J22] = jacobian22(V, alg, idx.j22);

 J = [J11 J12; J21 J22];
%--------------------------------------------------------------------------


%------------------------------Compute Step--------------------------------
 dTV = -(J \ DelPQ);
%--------------------------------------------------------------------------


%---------------------------Update State Vector----------------------------
 ins = @(a, y, n) cat(1, y(1:n), a, y(n+1:end));
 dTV = ins(0, dTV, sys.sck(1) - 1);

 TV = [T; V(alg.pq)] + dTV;
%--------------------------------------------------------------------------


%---------------------Voltage and Angle for all Buses----------------------
 T = TV(1:sys.Nbu);
 V(alg.pq) = TV(sys.Nbu + 1:end);
%--------------------------------------------------------------------------


%------------------------------New Mismatch--------------------------------
 Vc    = V .* exp(1i * T);
 DelS  = Vc .* conj(sys.Ybu * Vc) - (Pgl + 1i * Qgl);
 DelPQ = [real(DelS(alg.ii)); imag(DelS(alg.pq))];
%--------------------------------------------------------------------------

 end
%==========================================================================


%--------------------------------Save Data---------------------------------
 pf.time.con  = toc; tic
 pf.bus(:,1)  = Vc;
 pf.iteration = No;
%--------------------------------------------------------------------------