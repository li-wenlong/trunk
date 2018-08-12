function nums = parsnums( strs, varargin )
% function nums = parsnums( strs, 'prefix', pstr, 'suffix', sstr )
% returns the numbers in the strings stored in the cell array strs that has
% prefix pstr and suffix sstr.
%
% Murat Uney
%

prefix = '';
suffix = '';
isnum2str = 1;

if nargin < 1
    error('Insufficient number of inputs!');
else
    for i=1:length(varargin)
        if isa(varargin{i},'char') 
            switch lower(varargin{i})
                case 'prefix',
                    if i+1<= length(varargin)
                        prefix =  varargin{i+1};
                    else
                       error('insufficient arguments in the input!'); 
                    end
                case 'suffix',
                     if i+1<= length(varargin)
                        suffix =  varargin{i+1};
                    else
                       error('insufficient arguments in the input!'); 
                    end
                case 'num2str',
                    isnum2str = 1;
            end
        end
    end
end

lp = length( prefix );
ls = length( suffix );

nums = [];
cnt = 0;
for i=1:length(strs)
    strsel = strs{i};
    pind = strfind(strsel, prefix);
    sind = strfind(strsel, suffix );
    if ~isempty( pind ) && ~isempty(sind)
        M = repmat( sind(:),1, length(pind)  ) - repmat( pind(:)', length(sind),1 );
        M( find(M<= 0) ) = inf;
        [vals, rind] = min(M);
        [vals, cind] = min(vals);
        stind = pind( rind(cind) ) + lp;
        spind = sind( cind ) -1;
        
    elseif  isempty( pind ) && ~isempty(sind)
        stind = 1;
        spind = min(sind) - 1;
    elseif  isempty( pind ) && ~isempty(sind)
        stind = max(pind) + lp;
        spind = length(strsel);
    else
        stind = 1;
        spind = length(strsel);
    end
    num_ = str2num( strsel(stind:spind) );
    if ~isempty( num_ )
        cnt = cnt+1;
        nums(cnt) = num_;
    end
        
    
end