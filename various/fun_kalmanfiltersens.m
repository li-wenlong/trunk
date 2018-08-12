function [ localposteriors, varargout] = fun_kalmanfiltersens( sensors, filters, varargin )
% ps = fun_kalmanfiltersens( sens, fs )
% sens : Cell array of sensor objects
% fs : Cell array of filter objects
% ps : Cell array of posterior distributions
% this function uses the filters in the object array fs to process the 
% sensor report buffers
% [ps, lsi ] = fun_filtersens( sens, fs )
% returns ps as explained above and
% lsi: Log of the update term s_i, i.e., p(z_i^k|z^i_{1:k-1})
% [ps, lsi, si, pri ] = fun_filtersens( sens, fs )
% returns, in addition to ps and lsi
% si: the absolute evaluation of the update term explained above
% pri: the prediction densities used to find the posteriors in ps

global DEBUG_MISC

isverbose = 0;
if ~isempty ( DEBUG_MISC )
    if DEBUG_MISC 
        isverbose = 1;
    end
end
if nargin>=3 % this condition is for backward compatibility
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
loglhoods = zeros(maxnumsteps,numsens);
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
        filteri.onestep( sensori );
        localposteriors{ stepcnt, snum } = filteri.post;
        localpriors{ stepcnt, snum  } = filteri.pred;
        sis{ stepcnt, snum } = filteri.condpz;
        
        if ~isempty( filteri.parloglhood )
            loglhoods( stepcnt, snum ) = filteri.parloglhood;
        else
            loglhoods( stepcnt, snum ) = NaN;
        end
        
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

if nargout>=3
    varargout{3} = localpriors;
end

