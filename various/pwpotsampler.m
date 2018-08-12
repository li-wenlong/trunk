function [varargout] = pwpotsampler( pwpotparams, xj, qj, mij , mkjs)
% function [m] = pwpotsampler( pwpotparams, xj, qj, mij, mkjs )
% Returns a set of particles in m representing the message of node j to
% node i (after resampling with replacement).
% [m, w] =  pwpot( pwpotparams, xi, qj, mij, mkjs) returns particles m and
% weights w (before resamling).
% The inputs are
% pwpotparams: a structure accommodating the joint distribution p(xi, xj)
% and marginals p(xi) and p(xj) in its fields 
% pwpotparams.jointdist
% pwpotparams.localmarg
% pwpotparams.neimarg
% xj: local state samples (dsxN array) before messaging has started.
% qj: Local state (either particles or kde object) 
% mij: Message received from the neighbour in the previous round (either [],
% particles or kde object) 
% mkjs: Messages received from nodes other than the jth.

% Murat Uney 10.02.2014
% Murat Uney 25.02.2014

isResample = 1;
if nargout>=2
    isResample = 0;
end

if isa(qj,'particles')
    qj = kde( qj.getstates, 'rot', qj.getweights', 'g' );
end

npts = getNpts(qj);
ds = getDim(qj);
phij =  kde( pwpotparams.localmarg.gensamples(npts), 'rot', ones(1,npts)/npts, 'g' );

% qj(x_j) and phi(x_j) in the product array
% NO!! pkij(x_j) already in q_j, 
% parr = {qj, phij };
parr = {qj };
numfacts = 1;
if ~isempty( mij )
    % Add mkjs to the product cell array
    if ~isempty( mkjs )
        for i=1:length( mkjs )
            parr{end+1} = mkjs(i);
            numfacts = numfacts + 1;
        end
    end   
end


% Now, sample from the product phij(x_j)q(x_j) \prod_{k \in ne(j)/i} mkj(x_j)
st = kde(randn(ds,npts), 'rot', ones(1, npts), 'g' );
%st = productApprox( st, parr, {},{}, 'epsilon', 0.5e-2 ) ;
%st = productApprox( st, parr, {},{}, 'exact' ) ;
st = productApprox( st, parr , {},{}, 'import', ...
                               numfacts ) ;

sc = pwpotparams.localmarg.evaluate( getPoints(st) );


% First, find the conditional distribution, 
[C_pGq, mu_pGq, a, B ] = gausscond( pwpotparams.jointdist.C,...
    [1:pwpotparams.localmarg.getdims], pwpotparams.jointdist.m );

dummy = gk( C_pGq,  zeros(size(C_pGq,1),1) );
p = dummy.gensamples( getNpts( st ) ) +  a + B*getPoints(st); % Generate from the conditional distribution
wnei = pwpotparams.neimarg.evaluate( p );
w = getWeights( st )./wnei;

if isResample
    varargout{1} = resample(p, w); % m;
else
    varargout{1} = p; % m;
    varargout{2} = w;
end

