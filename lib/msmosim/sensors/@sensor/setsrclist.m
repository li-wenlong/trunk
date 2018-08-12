function varargout = setsrclist(this, src, time, varargin )

if ~isa( src, 'cell' )
    error('The input should be a cell array.');    
else
    for i=1:length(src)
       if ~isa( src{i} , 'source' )
          error('The entries of the cell array should be of type source.'); 
       end
    end
end 

if ~isa(time, 'numeric' ) || length(time)~=1
    error('The time to proceed is a scalar!');
end
time = time(1);

ps = kstate({'x','y','z','psi','theta','phi','vx','vy','vz'},[0 0 0 0 0 0 0 0 0]');
if nargin==4
    if ~isa( varargin{1}, 'kstate')
        error('The last argument should be the kinematic state of the parent');
    end
    ps = varargin{1};
end

R_xb = dcm(this.orientation); % Body to Sensor transform
R_be = dcm( ps.orientation ); % Earth to Body transform

xxE = ps.location + R_be'*this.location; % Sensor location in Earth
angsensE = idcm( R_xb*R_be ) ; % Sensor orientation wrt ECS
R_xe = R_xb*R_be;

% Convert the sources to earth coordinate system
% NO IT IS DONE IN THE MEASURE METHOD
for i=1:length(src)
   src_ = src{i};
  % src_.location = R_xe*src_.location; % location in SCS
  % R_se = dcm( src_.orientation );
  % src_.orientation = idcm( R_se*R_xe' ); % Orientation from SCS
  % src_.velocity = R_xe*src_.velearth;   
   
   src{i} = src_;
end
s = srclist(src, time);
this.srcbuffer = [this.srcbuffer,s];

if nargout == 0
    if ~isempty( inputname(1) )
        assignin('caller',inputname(1),this);
    else
        error('Could not overwrite the instance; make sure that the argument is not in an array!');
    end
else
    varargout{1} = this;
end
