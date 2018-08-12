function k = getkstate(this, varargin)

alabels = [ this.locationlabels, this.velocitylabels, this.accelerationlabels, ...
    this.orientationlabels, this.angularvelocitylabels, this.angularmomentlabels, ...
    this.velearthlabels, this.accelearthlabels];

% Create a kstate object
k = kstate;
k = k.setstatelabels( alabels );

ns = this.catstate( alabels ); % Get the state from this
k = k.substate(  ns  ); % Set in the k object
k.catstate;