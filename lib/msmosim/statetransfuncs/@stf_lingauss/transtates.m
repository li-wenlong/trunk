function outpar =  transtates(this, inpar )

outpar = [];
if isempty(inpar)
    return;
elseif isa( inpar,'particle' )
    instates = catstates( inpar );
    
elseif isa( inpar, 'particles')
    
    
elseif isa( inpar, 'numeric' )
    instates = inpar;
    
end



if  isa( inpar, 'particles')
    % This line will be used :
    outpar = inpar.lgtrans( this.F, this.Q );
elseif isa( inpar, 'gk' )
    outpar = inpar.lgtrans( this.F, this.Q );
elseif isa( inpar, 'gmm' )
    outpar = inpar.lgtrans( this.F, this.Q );
else
    outstates = this.F*instates + sqrtm( this.Q )*randn( size(instates) );
end

if norm(imag(this.state))>eps
    error('State transition led a complex vector. Possibly non-square rooted covariance matrix!');
end

if isa( inpar,'particle' ) 
    outpar = substates(inpar, outstates );
elseif isa( inpar, 'numeric' )
    outpar = outstates;
    
end
