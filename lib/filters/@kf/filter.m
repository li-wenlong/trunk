function varargout = filter( this, sensor )

% Not sure if the check below is neccessary
if ~isa(sensor,'rbsensor1') &&...
         ~isa(sensor,'linobs')
     error('Unidentified sensor type');
end

srbuffer_ = sensor.srbuffer;

figHandle = figure;
set( figHandle, 'DoubleBuffer','on');

figHandlePers = figure;
set( figHandlePers, 'DoubleBuffer','on');

disp(sprintf('Filtering the buffer of length %d :', length( srbuffer_ )));
for i=1:length( srbuffer_ );
    this.Z = srbuffer_(i);
    
    %this.predintensity = this.postintensity;
    %this.predcard = this.postcard;
    %if ~isempty( this.predintensity )
    %    this.predintensity = this.predintensity.replabel('nb','p');
    %end
    
    this = this.predict;
    
    % Save to the buffers
%     this.predintbuffer =  [ this.predintbuffer, { this.predintensity }];
%     this.predcardbuffer = [ this.predcardbuffer, { this.predcard} ];
    this.predintbuffer =  [  { this.predintensity }];
    this.predcardbuffer = [ { this.predcard} ];
    
    % Get the new born particles; the sum of the weights is needed in the
    this = this.nbpart( sensor );
    % update of persistent particle
    this = this.update( sensor );
    
    % Save to the buffers
%     this.postintbuffer = [ this.postintbuffer, { this.postintensity} ];
%     this.postcardbuffer = [ this.postcardbuffer, { this.postcard } ];
    this.postintbuffer = [  { this.postintensity} ];
    

    this.postcardbuffer = [this.postcardbuffer, {this.postcard }];
    
    this.displaybuffers('figure',figHandle);pause(0.01);
    this.displaypersposterior('figure', figHandlePers,'legend',1 );pause(0.01);
    fprintf('%d,',i);
    if mod(i,20)==0
        fprintf('\n');
    end
    
end
fprintf('\n');
     

if nargout == 0
    if ~isempty( inputname(1) )
        assignin('caller',inputname(1),this);
    else
        error('Could not overwrite the instance; make sure that the argument is not in an array!');
    end
else
    varargout{1} = this;
end
