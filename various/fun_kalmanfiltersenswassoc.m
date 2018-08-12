function [ localposteriors, varargout] = fun_kalmanfiltersens( sensors, filters, varargin )
% ps = fun_kalmanfiltersens( sens, fs )
% sens : Cell array of sensor objects
% fs : Cell array of filter objects
% ps : Cell array of posterior distributions
% this function uses the filters in the object array fs to process the 
% sensor report buffers
% [ps, upsij ] = fun_filtersens( sens, fs )
% returns ps as explained above and
% upsij: Update term for the s_ij, i.e., p(z_i^k|z^i_{1:k-1};\theta_i)

global DEBUG_MISC

isverbose = 0;
if nargin>=3
    isverbose = 1;
end

numsens = length( sensors );
numfilters = length( filters );

maxnumsteps = 0;
for snum=1:numsens
    maxnumsteps = max( maxnumsteps, length( sensors{snum}.srbuffer ) );
end


%%% First, do all the filtering as this is independent of the loopy bp
localposteriors = cell(maxnumsteps, numsens);
localpriors = cell(maxnumsteps, numsens);

sis = cell(maxnumsteps, numsens);
loglhoods = cell(maxnumsteps,numsens);

assocs = cell(maxnumsteps,numsens);
for snum = 1:numsens
    sensori = sensors{ snum };
    filteri = filters{ snum };
    
    numsteps = length( sensori.srbuffer );
    if isverbose
        disp(sprintf('Starting to filter the buffer of sensor #: %d', snum ));
        disp(sprintf('Time steps:'));
    end
    for stepcnt = 1:numsteps
        
        filteri.Z = sensori.srbuffer( stepcnt );
        [filteri, locassoc] = filteri.onestepwassoc( sensori );
        
        assocs{  stepcnt, snum  } = locassoc;
       
        loglhoods{ stepcnt, snum } = filteri.parloglhood;
        
        localposteriors{ stepcnt, snum } = filteri.post;
        localpriors{ stepcnt, snum  } = filteri.pred;
        
        
        if isverbose
            fprintf('%d',stepcnt);
            if mod(stepcnt,20)==0
                fprintf('\n');
            else
                fprintf(',');
            end
        end
    end
    if isverbose
        fprintf('\n');
    end
end

if nargout>=2
    varargout{1} = loglhoods;
end

if nargout>=3
    varargout{2} = sis;
end

if nargout>=4
    varargout{3} = localpriors;
end

if nargout>=5
    varargout{4} = assocs;
end
