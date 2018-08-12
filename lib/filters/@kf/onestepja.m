function varargout = onestepwassoc(this, sensors, varargin)

assigns = [];
% Not sure if the check below is neccessary
if ~isa(sensors,'linobs')
     error('Kalman Filter can only operate with a linear observation model!');
end


regs = zeros(4, length(sensors)-1 );
if nargin>=3
    regs = varargin{1};
end

isPred = 1;
isUpdate = 1;
% Get the new born particles; the sum of the weights is needed in the update of persistent particle
if isempty( this.post )
    if isempty( this.initstate )
        this = this.mlstate( sensors(1) );
        this.pred = this.initstate;
        this.post = this.pred;
        assigns = [1:length(this.pred)]';
        isPred = 0;
        isUpdate = 0;
    else
        % initstate is defined,
        this.pred = this.initstate;
        this.predbuffer =  [  { this.pred }];
        assigns = [1:length(this.pred)]';
         
        isUpdate = 1;
        isPred = 0;
    end
end


if isPred
    this = this.predict;
    % Save to the buffers
    %     this.predbuffer =  [ this.predintbuffer, { this.predintensity }];
    
    this.predbuffer =  [  { this.pred }];
end

if isUpdate
    
    if length(sensors) == 1
        % If a single sensor, go with an assignment approach
        [parloglhoods, parlhoods, posts, condpzs] = this.evalpairs( sensors, regs );
        
        % Form the association matrix
        N = length( this.pred );
        
        % Below, col number is the track number and row number is the
        % measurement number
        A = reshape(parloglhoods , N, N) - min( parloglhoods ) +abs(max(parloglhoods)); % Make it positive
        [assignments] = assignmentProblemAuctionAlgorithm( A' );
        % assignments arrays has the ith element (row) assigned to its value in
        % the array, i.e., row i of A is assigned to assignments(i)
        
        els = ([1:N]' -1)*N + (assignments) ; % elements in the array
        assigns = assignments;
        this.condpz = condpzs(els);
        this.post = posts(els);
        
        this.parlhood = parlhoods(els);
        this.parloglhood = parloglhoods(els);
    else
        % more than 1 sensor, go with a 2-D relaxation to the multi-D
        % assignment
        if sensors(1).insensorframe == 0
            % Predictions are in earth coordinate frame
            
            % clone another filter object
            that = this;
            
            N = length( this.pred );
            assigns = [];
            for scnt = 1:length( sensors )
                sensori = sensors(scnt);
                sensori.insensorframe = 0;
                that.Z = this.Z(scnt);
                [parloglhoods, parlhoods, posts, condpzs] = that.evalpairs( sensori, [] );
                
                A = reshape(parloglhoods , N, N) - min( parloglhoods ) +abs(max(parloglhoods)); % Make it positive
                [assignments] = assignmentProblemAuctionAlgorithm( A' );
                % assignments arrays has the ith element (row) assigned to its value in
                % the array, i.e., row i of A is assigned to assignments(i)
                
                assigns(:,scnt) =  assignments; 
            end
            
            % Now, for each assignment, do multi-sensor kf 
            posts_ = gk;
            condpzs_ = gk;
            parloglhoods_ = [];
            parlhoods_ = [];
                
            
            for ecnt = 1:size(assigns,1)
                % Clone a filter object
                that = this;
            
                that.pred = this.pred( ecnt );
                
                that.Z(1).Z = this.Z(1).Z( assigns(ecnt,1) );
                
                for scnt = 2:length(sensors)
                    that.Z(scnt).Z = this.Z(scnt).Z( assigns(ecnt,scnt) );
                end
                that.update( sensors, regs );
                
                posts_(ecnt) = that.post;
                condpzs_(ecnt) = that.condpz;
                
                parloglhoods_(ecnt) = that.parloglhood;
                parlhoods_(ecnt) = that.parlhood;
                
            end
            
            this.post = posts_;
            this.condpz = condpzs_;
            this.parloglhood = parloglhoods_;
            this.parlhood = parlhoods_;
        else
            % Now, we need to do the 2-D associations after making sure
            % that the predictions are in the appropriate sensor coordinate
            % system ; For now, only locations will be taken into account
            
            error('This condition is not implemented')
            
        end
    end
end




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
    if nargout>=2
        varargout{2} = assigns;
    end
end
