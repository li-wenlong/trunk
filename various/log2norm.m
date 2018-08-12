function [epots] = log2norm( logepots , varargin )

global DEBUG_MISC

isverbose = 0;
if ~isempty( DEBUG_MISC )
    if nargin>=2 || DEBUG_MISC
        isverbose = 1;
    end
end
epots = cell(size(logepots));

%% Convert the log lhoods
for i=1:size(logepots,1)
    for j=1:size(logepots,2)
        if isempty(logepots{i,j})
            continue;
        end
        
        epots{i,j} = exp( logepots{i,j} - max(logepots{i,j}(:)) );
        epots{i,j} = epots{i,j}/sum(epots{i,j}(:)); 
        if sum( epots{i,j}(:) )<=eps
            % all zeros
            epots{i,j} = ones(size(epots{i,j}));
            if isverbose
               disp(sprintf('All zero likelihoods on the edge from %d, to %d',i,j)); 
            end
        elseif ~isempty( find( isnan( epots{i,j}(:) )==1) )
            % on NaN
            epots{i,j} = ones(size(epots{i,j}));
             if isverbose
               disp(sprintf('NaN valued likelihoods on the edge from %d, to %d',i,j)); 
             end    
        end
        if isverbose
            var_ = var( epots{i,j}(:) );
            if  var_<= eps
                disp(sprintf('The likelihood values on the edge from %d, to %d are almost the same (var. = %g)',i,j,var_));
            end
        end
        
        
    end
end


