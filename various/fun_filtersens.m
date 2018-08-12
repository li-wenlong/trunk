function [ localposteriors, varargout] = fun_filtersens( sensors, filters, varargin )
% ps = fun_filtersens( sens, fs )
% sens : Cell array of sensor objects
% fs : Cell array of filter objects
% ps : Cell array of posterior distributions
% this function uses the filters in the object array fs to process the 
% sensor report buffers
% [ps, ll ] = fun_filtersens( sens, fs )
% returns ps as explained above and
% ll: log likelihoods of measurements

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
confpredictions = cell(maxnumsteps, numsens);
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
        if ~isempty( filteri.parloglhood )
            
            loglhoods( stepcnt, snum ) = filteri.parloglhood;
        end
        if ~isempty( filteri.postintensity )
            localposteriors{ stepcnt, snum } = filteri.postintensity;
        end
        if ~isempty( filteri.confintensity )
            confpredictions{ stepcnt, snum } = filteri.confintensity;
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
    varargout{2} = confpredictions;
end
