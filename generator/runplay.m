 function [data] = runplay(user, data, sys)

%--------------------------------------------------------------------------
% Builds measurement data from exact values.

% The function corrupts the exact solutions by the additive white Gaussian
% noises according to defined variances. Further, the function forms
% measurement set according to predefined inputs.
%--------------------------------------------------------------------------
%  Inputs:
%	- user: user inputs
%	- data: input power system data
%	- sys: power system data
%
%  Outputs:
%	- data.legacy.flow with changed columns:
%	  (3)active power flow measurements;
%	  (4)active power flow measurement variances;
%	  (5)active power flow measurements turn on/off;
%	  (6)reactive power flow measurements;
%	  (7)reactive power flow measurement variances;
%	  (8)reactive power flow measurement turn on/off;
%	- data.legacy.current with changed columns:
%	  (3)line current magnitude measurements;
%	  (4)line current magnitude measurement variances;
%	  (5)line current magnitude measurement turn on/off;
%	- data.legacy.injection with changed columns:
%	  (3)active power injection measurement variances;
%	  (4)active power injection measurements turn on/off;
%	  (5)reactive power injection measurements;
%	  (6)reactive power injection measurement variances;
%	  (7)reactive power injection measurements turn on/off;
%	- data.legacy.voltage with changed columns:
%	  (2)bus voltage magnitude measurements;
%	  (3)bus voltage magnitude measurement variances;
%	  (4)bus voltage magnitude measurements turn on/off;
%	- data.pmu.current with changed columns:
%	  (3)line current magnitude measurements;
%	  (4)line current magnitude measurement variances;
%	  (5)line current magnitude measurements turn on/off;
%	  (6)line current angle measurements;
%	  (7)line current angle measurement variances;
%	  (8)line current angle measurements turn on/off;
%	- data.pmu.voltage with changed columns:
%	  (2)bus voltage magnitude measurements;
%	  (3)bus voltage magnitude measurement variances;
%	  (4)bus voltage magnitude measurements turn on/off;
%	  (5)bus voltage angle measurements;
%	  (6)bus voltage angle measurement variances;
%	  (7)bus voltage angle measurements turn on/off;
%--------------------------------------------------------------------------
% Created by Mirsad Cosovic on 2019-02-24
% Last revision by Mirsad Cosovic on 2019-03-27
% MATGRID is released under MIT License.
%--------------------------------------------------------------------------


%-------------------------Measurement Statistics---------------------------
 [msr] = variable_device(sys);
%--------------------------------------------------------------------------


%----------------------------Measurement Sets------------------------------
 if any(ismember({'pmuRedundancy', 'pmuDevice', 'pmuOptimal', 'legRedundancy', 'legDevice'}, user.list))
 	[user]      = check_measurement_set(user, msr);
 	[user, msr] = set_produce(user, msr, sys);
 	[data]      = play_set(user, data, sys, msr);
 end
%--------------------------------------------------------------------------


%--------------------------Measurement Variances---------------------------
 if any(ismember({'pmuUnique', 'pmuRandom', 'pmuType', 'legUnique', 'legRandom', 'legType'}, user.list))
	[user] = check_measurement_variance(user);
 	[msr]  = variance_produce(user, msr);
 	[data] = play_variance(user, data, sys, msr);
 end
%--------------------------------------------------------------------------


%----------------------------Export Info Data------------------------------
 [data] = export_info(data, user, msr);
%--------------------------------------------------------------------------