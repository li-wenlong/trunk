function [Xt, varargout] = getmostates(this, varargin )

excl  = [];
if nargin>=2
    excl = varargin{1};
end

Xt = {};
numXt = [];

platlist = setdiff( [1:length(this.platforms)], excl );

if ~isempty( platlist )
    
    % Find the time instances for each platform at which they produced a
    % state report
    numplats = length( platlist );
    for i=1:numplats
        tarrs{i} = cell2mat({this.platforms{ platlist(i) }.track.treps.time})';
    end
    
    % Merge the time sequences to find the overall time seq.
    ts = [];
    for i=1:numplats
        ts = unique( union( tarrs{i}, ts ) );
    end
    ts = sort(ts); %
    
    ss = {};
    buffptr = {};
    ns = [];
    % Find how many platforms at each time step and which ones:
    for i=1:length(ts)
        ss{i} = [];
        buffptr{i} = [];
        for j=1:numplats
            ind = find(tarrs{j}==ts(i));
            if ~isempty( ind )
                ss{i} = [ss{i}, platlist(j) ];
                buffptr{i} =  [buffptr{i}, ind(1)] ;
            end
        end
        ns = [ns, length(ss{i})];
    end
    
    % Having found the schedule of the platforms, find Xt:
    Xt = {};
    numXt = [];
    
    for i=1:length(ts)
        Xtt = [];
        for j=1:length(ss{i})
             Xtt = [Xtt, ...
                 this.platforms{ ss{i}(j) }.track.treps(  buffptr{i}(j) ).state.getstate({'x','y','vx','vy'})];
            
        
        end
        Xt = [Xt,{Xtt}];
        numXt = [numXt, size(Xtt, 2)];
        
    end
        
        
end
    
    
%     
%     
%     
% for i=1:length(platforms)
%     tlist
% 
% 
% if ~isempty(this.actplatsbuffer)
%     inittime = this.cfg.tstart;
%     
%     treptrs = ones(1, length(this.platforms));
%     acttreptrs = 1;
%     % Start from the initial time
%     while( inittime < this.cfg.tstop )
%         crrnttime = inittime + this.deltat;
%         
%         isactplatsbuffer = 0;
%         for i=acttreptrs:length(this.actplatsbuffer)
%             if this.actplatsbuffer(i).time == inittime
%                 isactplatsbuffer = 1;
%                 acttreptrs = i + 1;
%                 break;
%             end
%         end
%         
%         if isactplatsbuffer == 0
%             warning('No entry in the active platforms buffer at time =  %g', crrnttime);
%             break;
%         end
%         % this.actplatsbuffer(acttreptrs-1).time
%         trplats = setdiff( this.actplatsbuffer(acttreptrs-1).actplats, excl );
%         
%         
%         Xtt = [];
%         for j=1:length(trplats)
%             % Find the track report for the time stamp
%             istime= 0;
%             timeind = 1;
%             
%             crrnttrack = this.platforms{trplats(j)}.track;
%             numtreps = length(crrnttrack.treps);
%             
%             trtimes = cell2mat({crrnttrack.treps(:).time});
%             tind = find(trtimes == crrnttime );
%             if ~isempty(tind)
%                 istime = 1;
%                 timeind = tind;
%               %  treptrs(trplats(j)) = k + 1;
%                 
%             end
%             
%             if istime
%                 Xtt = [Xtt, ...
%                     this.platforms{trplats(j)}.track.treps(timeind).state.getstate({'x','y','vx','vy'}) ];
%             end
%         end
%         Xt = [Xt,{Xtt}];
%         numXt = [numXt, size(Xtt, 2)];
%         inittime = crrnttime;
%         %  size(Xt)
%     end% Until the final time
%     
%     
% end

if nargout>=2
    varargout{1} = numXt;
end

if nargout>=3
    varargout{2} = ss;
end


