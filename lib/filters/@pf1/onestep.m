function varargout = onestep(this, sensors, varargin)


% Not sure if the check below is neccessary
if ~isa(sensors,'rbsensor1') &&...
         ~isa(sensors,'linobs') &&...
         ~isa(sensors,'rbsensor2') &&...
         ~isa(sensors,'rbsensor2b') &&...
         ~isa(sensors,'extsensor') && ...
         ~isa(sensors,'extsensor2') && ...
         ~isa(sensors,'bearingsensor1')
     error('Unidentified sensor type');
end


regs = zeros(4, length(sensors)-1 );
if nargin>=3
    regs = varargin{1};
end

% Get the new born particles; the sum of the weights is needed in the update of persistent particle
this = this.nbpart( sensors(1) );

this = this.predict;

% Save to the buffers
%     this.predintbuffer =  [ this.predintbuffer, { this.predintensity }];
%     this.predcardbuffer = [ this.predcardbuffer, { this.predcard} ];
this.predintbuffer =  [  { this.pred }];

[this, lhood] = this.update( sensors, regs);
    
this.parlhood = lhood;


% Save to the buffers
%     this.postintbuffer = [ this.postintbuffer, { this.postintensity} ];

this.postintbuffer = [  { this.post} ];

if nargout == 0
    if ~isempty( inputname(1) )
        assignin('caller',inputname(1),this);
    else
        error('Could not overwrite the instance; make sure that the argument is not in an array!');
    end
else
    varargout{1} = this;
end
