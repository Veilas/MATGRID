 function [sys, se] = evaluation_pmuse(data, dat, sys, se)

%--------------------------------------------------------------------------
% Computes different metrics used to measure the accuracy of the state
% estimation with PMUs only.
%
% The function computes the root mean squared error (RMSE), mean absolute
% error (MAE) and weighted residual sum of squares (WRSS) between estimated
% values and: i) corresponding measurement values; ii) corresponding exact
% values
%--------------------------------------------------------------------------
%  Inputs:
%	- data: input power system data with measurements
%	- dat: data corresponding with active phasor measurements
%	- sys: power system data
%	- se: state estimation data
%
%  Outputs:
%	- se.estimate with additional columns:
%	  (1)measurement values; (2)measurement variances
%	  (3)estimated measurement values; (5)exact values
%	- se.error.mae1, se.error.rmse1, se.error.wrss1: errors between
%	  estimated values and corresponding measurement values
%	- se.error.mae2, se.error.rmse2, se.error.wrss2: errors between
%	  estimated values and corresponding exact values
%	- se.error.mae3, se.error.rmse3: errors between estimated state
%	  variables and corresponding exact values
%   - sys.exact: flag for exact values
%--------------------------------------------------------------------------
% Created by Mirsad Cosovic on 2019-03-05
% Last revision by Mirsad Cosovic on 2019-03-27
% MATGRID is released under MIT License.
%--------------------------------------------------------------------------


%--------------------Measurement Values and Variances----------------------
 C = [se.branch(:,1);  se.branch(:,2)];

 xV = dat.pmu.voltage(:,14);
 xC = dat.pmu.current(:,15);

 se.estimate = [data.pmu.voltage(xV,2); data.pmu.voltage(xV,5); data.pmu.current(xC,3); data.pmu.current(xC,6)];
 se.estimate(:,2) = [data.pmu.voltage(xV,3); data.pmu.voltage(xV,6); data.pmu.current(xC,4); data.pmu.current(xC,7)];
%--------------------------------------------------------------------------


%----------------------------Estimated Values------------------------------
 V = abs(se.bus(:,1));
 T = angle(se.bus(:,1));

 se.estimate(:,3) = [V(xV); T(xV); abs(C(xC)); angle(C(xC))];
%--------------------------------------------------------------------------


%------------------------------Exact Values--------------------------------
 try
  sys.exact = 1;
  se.estimate(:,5) = [data.pmu.voltage(xV,8); data.pmu.voltage(xV,9); data.pmu.current(xC,9); data.pmu.current(xC,10)];
  sv_true = [data.pmu.voltage(:,8); data.pmu.voltage(:,9)];
  sv_esti = [V; T];
 catch
  sys.exact = 0;
 end
%--------------------------------------------------------------------------


%-----------------Estimated Values to Measurement Values-------------------
 d1 = se.estimate(:,3) - se.estimate(:,1);

 se.error.mae1  = sum(abs(d1)) / sys.Ntot;
 se.error.rmse1 = ((sum(d1.^2)) / sys.Ntot)^(1/2);
 se.error.wrss1 =  sum(((d1.^2)) ./ se.estimate(:,2));
%--------------------------------------------------------------------------


%--------------------Estimated Values to Exact Values----------------------
 if sys.exact == 1
	d2 = se.estimate(:,3) - se.estimate(:,5);
	d3 = sv_esti - sv_true;

	se.error.mae2 = sum(abs(d2)) / sys.Ntot;
	se.error.mae3 = sum(abs(d3)) / (2 * sys.Nbu);

	se.error.rmse2 = ((sum(d2).^2) / sys.Ntot)^(1/2);
	se.error.rmse3 = ((sum(d3).^2)/ (2 * sys.Nbu))^(1/2);

	se.error.wrss2 =  sum(((d2).^2) ./ se.estimate(:,2));
 end
%--------------------------------------------------------------------------