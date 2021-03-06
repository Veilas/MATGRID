 function [data] = produce_Abv(data, sys, se, user)

%--------------------------------------------------------------------------
% Exports the system in the matrix and vector forms, for the linear state
% estimation cases.
%
% The function exports the matrix and vector forms for the DC and PMU state
% estimation. Export of data is possible to do without slack bus
% (estimate.linear = 1), or with slack bus (estimate.linear = 2).
%--------------------------------------------------------------------------
%  Input:
%	- data: input power system data with measurements
%	- sys: power system data
%	- se: state estimation data
%
%  Outputs:
%	- data.A: Jacobian matrix
%	- data.b: vector of observations;
%	- data.v: variances vector
%--------------------------------------------------------------------------
% Created by Mirsad Cosovic on 2019-03-04
% Last revision by Mirsad Cosovic on 2019-03-27
% MATGRID is released under MIT License.
%--------------------------------------------------------------------------


%-------------------------------Export System------------------------------
 if ismember('export', user) && any(ismember({'dc', 'pmu'}, user))
    data.extras.A = sys.H;
    data.extras.b = sys.b;
    data.extras.v = se.estimate(:,2);
 end
 
 if ismember('exportSlack', user) && ismember('dc', user)
	h = sparse(1, sys.Nbu);
	h(sys.sck(1)) = 1;
 
    data.extras.As = [sys.H; h];
    data.extras.bs = [sys.b; sys.sck(2)];
    data.extras.vs = [se.estimate(:,2); 10^-30];
 end
%--------------------------------------------------------------------------