function varargout = onestep(this, sensors, varargin)


% Check if the sensor type is registered
if ~isa(sensors,'linobs')
     error('Gaussian mixture PHD filter can only operate with a linear observation model!');
end

regs = zeros(4, length(sensors)-1 );
if nargin>=3
    regs = varargin{1};
end

% Predict
this = this.predict;

% Save to the buffers
%     this.predintbuffer =  [ this.predintbuffer, { this.predintensity }];
%     this.predcardbuffer = [ this.predcardbuffer, { this.predcard} ];
this.predintbuffer =  [  { this.predintensity }];
this.predcardbuffer = [ { this.predcard} ];

% Get the GMM for the new born bit; the sum of the weights is needed in the update of persistent particle
this = this.nbcomp( sensors , regs );
% update of persistent particles

proddenums = [];
Zs = this.Z;
for i=1:length(sensors)
    
    sensor = sensors(i);
    this.Z = Zs(i);
    if i==1
        [this, proddenum] = this.update( sensor );
    else
         
        
            
        predint = this.predintensity;
        predcard = this.predcard;
        mupred = this.mupred;
        
        
        postint = this.postintensity;
        postcard = this.postcard;
        mupost = this.mupost;
        if ~isempty( this.postintensity )
            this.predintensity = this.postintensity;
            this.predcard = this.postcard;
            this.mupost = this.mupred;
        end
        
        [this, proddenum] = this.update( sensor, regs(:, i-1) );
            
        % If after the update, the posterior is empty, hold the previous one
        
        if isempty(this.postintensity)
            this.postintensity = postint;
            this.postcard = postcard;
            this.mupost = mupost;
        end
        
        this.predintensity = predint;
        this.predcard = predcard;
        this.mupred = mupred;
         
    end
   proddenums = [proddenums, proddenum]; 
end

this.Z = Zs;
this.proddenum = proddenums;

% this = this.findparlhood(sensor); % Find parent likelihood

% Save to the buffers
%     this.postintbuffer = [ this.postintbuffer, { this.postintensity} ];

this.postintbuffer = [  { this.postintensity} ];
this.postcardbuffer = [ this.postcardbuffer, { this.postcard } ];

if nargout == 0
    if ~isempty( inputname(1) )
        assignin('caller',inputname(1),this);
    else
        error('Could not overwrite the instance; make sure that the argument is not in an array!');
    end
else
    varargout{1} = this;
end
