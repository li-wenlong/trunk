function [varargout] = pwpot( pwpotparams, xi, qj, mij )
% function [m] = pwpot( pwpotparams, xi, qj, mij )
% Returns a set of particles in m representing the message of node j to
% node i (after resampling with replacement).
% [m, w] =  pwpot( pwpotparams, xi, qj, mij ) returns particles m and
% weights w (before resamling).
% The inputs are
% pwpotparams: a structure accommodating the joint distribution p(xi, xj)
% and marginals p(xi) and p(xj) in its fields 
% pwpotparams.jointdist
% pwpotparams.localmarg
% pwpotparams.neimarg
% xi: state of the neighbour (either particles or kde object) before
% messaging has started.
% qj: Local state (either particles or kde object) 
% mij: Message received from the neighbour in the previous round (either [],
% particles or kde object) 

% Murat Uney 05.02.2014

isResample = 1;
if nargout>=2
    isResample = 0;
end

if isa(qj,'particles')
    qj = kde( qj.getstates, 'rot', qj.getweights', 'g' );
end

% Divide the state by the previous incoming message
% i.e., sample from q(x_j)/mij(x_j)
if ~isempty( mij )
    wm = evaluate( mij , getPoints(qj) ); %  Get equally weighted points of the message 
    % and evaluate at q(x_j)
else
    wm = ones(1, getNpts( qj) );
end

wphi = pwpotparams.localmarg.evaluate( getPoints(qj) );

nw = exp( log(getWeights( qj )) + log(wphi) - log (wm) );

%% Below, we sample from the edge potential after resampling equally weighted
%% particules from phij(x_j)q(x_j)/mij(x_j)
xj = kde( getPoints( qj) ,'rot', nw, getType(qj) );
xj = resample( xj );

% Now, sample from phij(x_i, x_j)/phij(x_j)

% First, find the conditional distribution, 
[C_pGq, mu_pGq, a, B ] = gausscond( pwpotparams.jointdist.C,...
    [1:pwpotparams.localmarg.getdims], pwpotparams.jointdist.m );

dummy = gk( C_pGq,  zeros(size(C_pGq,1),1) );
p = dummy.gensamples( getNpts( xj) ) +  a + B*getPoints(xj); % Generate from the conditional distribution
w = ones(size(nw));

% %% Below, we sample from the edge potential without resampling phij(x_j)q(x_j)/mij(x_j)
% % First, find the conditional distribution, 
% [C_pGq, mu_pGq, a, B ] = gausscond( pwpotparams.jointdist.C,...
%     [1:pwpotparams.localmarg.getdims], pwpotparams.jointdist.m );
% 
% dummy = gk( C_pGq,  zeros(size(C_pGq,1),1) );
% 
% p = dummy.gensamples( getNpts( qj) ) +  a + B*getPoints(qj); % Generate from the conditional distribution
% w = nw/sum(nw);

if isResample
    varargout{1} = resample(p, w); % m;
else
    varargout{1} = p; % m;
    varargout{2} = w;
end

