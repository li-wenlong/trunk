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

this = this.predict;

% Save to the buffers
%     this.predintbuffer =  [ this.predintbuffer, { this.predintensity }];
%     this.predcardbuffer = [ this.predcardbuffer, { this.predcard} ];
this.predintbuffer =  [  { this.predintensity }];
this.predcardbuffer = [ { this.predcard} ];

% Get the new born particles; the sum of the weights is needed in the update of persistent particle
this = this.nbpart( sensors, regs );

regflagshadow = this.regflag;
lhoods = [];
Zs = this.Z;
for i=1:length(sensors)
    sensor = sensors(i);
    this.Z = Zs(i);
    if i==1
      %  if length(sensors)>1
      %      this.regflag = 0;
      %  end
        [this, lhood] = this.update( sensor );
    else
        if i==length(sensors)
            this.regflag = regflagshadow;
        end
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
        
               
        [this, lhood] = this.update( sensor, regs(:, i-1) );
        
        % If after the update, the posterior is empty, hold the previous one
        
        if isempty(this.postintensity)
            this.postintensity = [];
            this.postcard = [1 0 0]';
            this.mupost = 0;
        end
        
        this.predintensity = predint;
        this.predcard = predcard;
        this.mupred = mupred;
        
    end
    lhoods = [lhoods, lhood];
end

this.Z = Zs;
this.parlhood = lhoods;


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
