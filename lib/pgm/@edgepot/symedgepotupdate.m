function [this, thisrev ] = symedgepotupdate( this, thisrev, nodei, nodej )
% symedgepotupdate method of the class @edgepot
% 1) updates the domain of the edgepot object
% 2) evaluates the edge potential at the newly found points
% 3) Updates the kde representation of the edgepotential with these points

% Murat Uney 31.05.2017


global DEBUG_PMRF

if DEBUG_PMRF
disp(sprintf('Inside update function for the edge (%d,%d) ', this.e )); 
end

tstart = tic;
this.potobj = this.potobj;
telapsed = toc(tstart);


this.updatecount = this.updatecount + 1;
this.tupdate = [this.tupdate; telapsed];

thisrev.updatecount = thisrev.updatecount +1;
thisrev.tupdate =[thisrev.tupdate; telapsed]; 

if nargout == 0
    if ~isempty( inputname(1) )
        assignin('caller',inputname(1),this);
    else
        error('Could not overwrite the instance; make sure that the argument is not in an array!');
    end
else
    varargout{1} = this;
end


