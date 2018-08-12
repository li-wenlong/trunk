function o = multwcond( w1, varargin )
% o = mutlwcond( w1, w2, w3 [,... ] )
% multiply particle weights with conditioning
%

lwp = condlog( log( w1 ) );
for i=1:length(varargin)
    lwi = condlog( log( varargin{i}(:) ) );
    lwp = lwp + lwi;
end
o = exp( lwp - max(lwp) );
o = o/sum(o);
end
function l = condlog(inp)
% This function conditions log values so that we don't have any -Inf
ind = find( inp ~= -Inf );
minval = min( inp( ind ) );
if isempty( minval )
    % all are -Inf
    l = zeros( size( inp ) );
else
    ind = find( inp == -Inf );
    inp(ind) = minval-100;
    l = inp;
end
end