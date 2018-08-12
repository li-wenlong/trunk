function varargout = filters( these, sensors, varargin )

% Not sure if the check below is neccessary
if ~isa(sensors,'rbsensor1') &&...
         ~isa(sensors,'linobs')
     error('Unidentified sensor type');
end

if nargin >= 3
    fusionobj = varargin{1};
    if ~isa( fusionobj, 'gci' )
        error('Unidentified fusion object');
    end
end

numsteps = length( sensors(1).srbuffer );
for i=2:length(sensors)
    numsteps = min( numsteps, length( sensors(i).srbuffer ) );
end


% axisHandles = these(i).displaybuffers;
% if exist('fusionobj')
%     axisHandlePerf = fusionobj.drawperf;
% end

disp(sprintf('Filtering the buffer of length %d :', numsteps));

for stepcnt = 1:numsteps
    for i = 1:length(sensors)
        this = these(i);

        sensorObj = sensors(i);
        this.Z = sensorObj.srbuffer( stepcnt );

        this = this.predict;

        % Save to the buffers
        %     this.predintbuffer =  [ this.predintbuffer, { this.predintensity }];
        %     this.predcardbuffer = [ this.predcardbuffer, { this.predcard} ];
        this.predintbuffer =  [  { this.predintensity }];
        this.predcardbuffer = [ { this.predcard} ];

        % Get the new born particles; the sum of the weights is needed in the
        this = this.nbpart( sensorObj );
        % update of persistent particle
        this = this.update( sensorObj );

        % Save to the buffers
        %     this.postintbuffer = [ this.postintbuffer, { this.postintensity} ];
        %     this.postcardbuffer = [ this.postcardbuffer, { this.postcard } ];
        this.postintbuffer = [  { this.postintensity} ];
        
         
    this.postcardbuffer = [this.postcardbuffer, {this.postcard} ];

        
        these(i) = this;

%         if i==1
%             this.displaybuffers('axis',axisHandles,'cla',1);pause(0.001);
%         elseif i==2
%             this.displaybuffers('axis',axisHandles,'options',...
%                 {'''Marker'',''v'',''Color'',''y''',...
%                 '''Color'',''r''',...
%                 '''Color'',''r''',...
%                 '''Marker'',''v'',''Color'',''b'''});pause(0.001);
%         else
%             this.displaybuffers('axis',axisHandles,'cla',1)
%         end

    end % for filter-sensor pair
    
    if exist('fusionobj')
        indx1 = these(1).postintensity.getindx( 'p' );
        indx2 = these(2).postintensity.getindx( 'p' );
        fusionobj.setinputs( these(1).postintensity(indx1), these(2).postintensity(indx2) );
        fusionobj.fuse;
%         fusionobj.drawoutp( 'axis',axisHandles(3) );pause(0.001);
%         fusionobj.drawperf( 'axis', axisHandlePerf );pause(0.001);
    end
    

    fprintf('%d,',stepcnt);
    if mod(stepcnt,20)==0
        fprintf('\n');
    end

end % for step cnt
fprintf('\n');
     

if nargout == 0
    if ~isempty( inputname(1) )
        assignin('caller',inputname(1),this);
    else
        error('Could not overwrite the instance; make sure that the argument is not in an array!');
    end
else
    varargout{1} = these;
    if nargin>=2
        varargout{2} = fusionobj;
    end
end
