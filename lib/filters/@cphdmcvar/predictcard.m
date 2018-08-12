function varargout = predictcard( this )

this.predcard = zeros(length(this.postcard),1);

rho_cdn  = zeros(length(this.postcard),1);
for j=0:length( rho_cdn )-1
    jh = j+1;
    for l=j:length( rho_cdn )-1
        lh = l + 1;
        rho_cdn(jh) = rho_cdn(jh) + exp( this.logCcoef(lh,jh)  )*...
            (this.probsurvive^j)*( (1-this.probsurvive)^(l-j))*...
            this.postcard(lh);
    end
end

for n=0:length(this.predcard)-1
    nh = n+1;
    for j=0:n
        jh = j+1;
        this.predcard(nh) = this.predcard(nh) + rho_cdn(jh)*this.cardnb(n-j+1);
    end
end
    
if nargout == 0
    if ~isempty( inputname(1) )
        assignin('caller',inputname(1),this);
    else
        error('Could not overwrite the instance; make sure that the argument is not in an array!');
    end
else
    varargout{1} = this;
end
