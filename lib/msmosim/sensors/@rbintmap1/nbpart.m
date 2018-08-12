function [nbstates_, varargout] = nbpart( this, obs, numpartnewborn )

Zs = obs.Z;

pstate = obs.pstate;
sstate = obs.sstate;

if this.insensorframe == 0
    plocE = pstate.getstate({'x','y','z'});
    angBE = pstate.getstate({'psi','theta','phi'});
    R_BE = dcm(angBE);
    
    slocB = sstate.getstate({'x','y','z'});
    angSB = sstate.getstate({'psi','theta','phi'});
    R_SB = dcm( angSB );
else
    % The incoming particles locationE_ are already in sensor coordinate
    % system
    plocE = [0 0 0]';
    angBE = [0 0 0]';
    R_BE = eye(3);
    
    slocB = [0 0 0]';
    angSB = [0 0 0]';
    R_SB = eye(3);
end



% Now, find a meshgrid template that will be shifted into each of the MxN cells
numpnts = round(sqrt(numpartnewborn) );
numpartnewborn = numpnts^2; % Correct the number of particles new born as the square of the numpnts

sigma_bearing = this.deltabearing/numpnts;
sigma_range = this.deltarange/numpnts;

[mtheta, mrange] = meshgrid( this.deltabearing/2- [sigma_bearing/2:sigma_bearing:this.deltabearing-sigma_bearing/2],...
    this.deltarange/2-[sigma_range/2:sigma_range:this.deltarange-sigma_range/2]);

% The mesh above will be used in the below cell centres
[nbtheta,nbrange] = meshgrid( this.colcentres, this.rowcentres );

mtheta = repmat(mtheta, [1,1, this.numcols*this.numrows] );
mrange = repmat( mrange, [1,1, this.numrows*this.numcols] );

mtheta = shiftdim(mtheta,2); 
mrange = shiftdim(mrange,2); 


nbtheta = repmat( nbtheta(:), numpartnewborn, 1 );
nbrange = repmat( nbrange(:), numpartnewborn, 1 );

bearings = nbtheta(:) + mtheta(:);
ranges = nbrange(:) + mrange(:);
   
% polar( bearings, ranges,'.')

% The measurements are in the SCS, find them in ECS
losS = [ranges.*cos(bearings), ranges.*sin(bearings), zeros(numpartnewborn*this.numrows*this.numcols,1 )]';
targsE = repmat(plocE,1,numpartnewborn*this.numrows*this.numcols )...
    + R_BE'*(R_SB'*losS + repmat(slocB,1,numpartnewborn*this.numrows*this.numcols ) );

nbstates_ = targsE;
labels = repmat([1:this.numrows*this.numcols], [1, numpartnewborn] );
% The labels above are same with counting the rows and columns as follows:
% first cell is row=1, col=1 (bottom right), second cell is row=2, col = 1
% (the cell above bottom right) etc.
% In other words, the above labelling is identical to
% pix = findpixels(this, bearings, ranges);
% labels = pix(:,1) + (pix(:,2)-1)*this.numrows;

if nargout>1
    varargout{1} = labels;
end
