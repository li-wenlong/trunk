function [varargout] = pwpotsampler( pwpotparams, xj, qj, mij , mkjs)
% function [m] = pwpotsampler( pwpotparams, xi, qj, mij, mkjs )
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
% xj: local prior samples (dsxN array) before messaging has started.
% qj: Local state (either particles or kde object) 
% mij: Message received from the neighbour in the previous round (either [],
% particles or kde object) 
% mkjs: Messages received from nodes other than the jth.

% Murat Uney 25.02.2014

isResample = 1;
if nargout>=2
    isResample = 0;
end

if isa(qj,'particles')
    npts = qj.getnumpoints;
    ds = qj.getstatedims;
    pnts = qj.getstates;
    qj = kde( qj.getstates, 'rot', qj.getweights', 'g' );
else
    npts = getNpts(qj);
    ds = getDim(qj);
    pnts = getPoints( qj );    
end

parr = {qj};

if ~isempty( mij )
   % xj = pwpotparams.localmarg.gensamples(npts); % p(x_j)
    wj = evaluate( mij, xj);
    % This is a mixture representing p(x_j)/\tilde m_ij(x_j)
    parr{end+1} = kde( xj, 'rot', 1./wj, 'g' ); 
end

% Now, sample from the product q(x_j) p(x_j) / \tilde mij(x_j)
st = kde(randn(ds,npts), 'rot', ones(1, npts), 'g' );
st = productApprox( st, parr, {},{}, 'epsilon', 1.0e-4 ) ;
%st = productApprox( st, parr, {},{}, 'exact' ) ;
%sc = pwpotparams.localmarg.evaluate( getPoints(st) );

% First, find the conditional distribution, 
[C_pGq, mu_pGq, a, B ] = gausscond( pwpotparams.jointdist.C,...
    [1:pwpotparams.localmarg.getdims], pwpotparams.jointdist.m );

dummy = gk( C_pGq,  zeros(size(C_pGq,1),1) );
p = dummy.gensamples( getNpts( st ) ) +  a + B*getPoints(st); % Generate from the conditional distribution
%wnei = pwpotparams.neimarg.evaluate( p );
w = getWeights( st );%./wnei;

if isResample
    varargout{1} = resample(p, w); % m;
else
    varargout{1} = p; % m;
    varargout{2} = w;
end

