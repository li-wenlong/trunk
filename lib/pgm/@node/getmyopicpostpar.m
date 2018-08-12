function mp = getmyopicpostpar( this, varargin )
% function mp = @node.myopicpostpar
% returns the myopic posterior mp as a particle set @particles object given the
% measurement value @node.y and prior stored in @node.state as a @partciles object.
% mp = @node.myopicpost( y) computes the posterior for y.

% Murat Uney 01.2014

if nargin>=2
    y_vect = varargin{1};
else
    y_vect = this.y;
end

if ~isempty( this.y )
    wmeas = this.noisedist.evaluate( this.y - this.C*this.initstate.states );
else
    wmeas = ones(size(this.initstate.weights))';
end

mp = particles( 'states', this.initstate.states, 'weights',...
    (this.initstate.weights.*wmeas' ) );
mp.findkdebws;
