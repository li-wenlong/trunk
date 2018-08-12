function varargout = onestep(this, sensors, varargin)


% Not sure if the check below is neccessary
if ~isa(sensors,'linobs')
     error('Kalman Filter can only operate with a linear observation model!');
end


regs = zeros(4, length(sensors)-1 );
if nargin>=3
    regs = varargin{1};
end

% Get the new born particles; the sum of the weights is needed in the update of persistent particle
if isempty( this.post )
    if isempty( this.initstate )
        this = this.mlstate( sensors(1) );
        this.pred = this.initstate;
        
    else
        % initstate is defined, 
        this.pred = this.initstate;
    end      
else
    this = this.predict;

end

this.predbuffer =  [  { this.pred }];
[this, lhood] = this.update( sensors, regs);
this.parlhood = lhood;

% Save to the buffers
%     this.postintbuffer = [ this.postintbuffer, { this.postintensity} ];

this.postbuffer = [  { this.post} ];

if nargout == 0
    if ~isempty( inputname(1) )
        assignin('caller',inputname(1),this);
    else
        error('Could not overwrite the instance; make sure that the argument is not in an array!');
    end
else
    varargout{1} = this;
end
