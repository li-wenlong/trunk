function varargout = getcomms( this, stepcnts )

% nvarargin = length(varargin);
% argnum = 1;
% lmap = [];
% numlabels = 1;
% while argnum<=nvarargin
%     if isa( lower(varargin{argnum}), 'char')
%         switch lower(varargin{argnum})
%             case {'labelmap'}
%                 if argnum + 1 <= nvarargin
%                     lmap = varargin{argnum+1}(:);
%                 end
%             case {'numlabels'}
%                 if argnum + 1 <= nvarargin
%                     numlabels = varargin{argnum+1}(1);
%                     argnum = argnum + 1;
%                 end
%                 
%             case {''}
%                
%                 
%             otherwise
%                 error('Wrong input string');
%         end
%     end
%      argnum = argnum + 1;
% end


if length(stepcnts) == 1
    stepcnt = stepcnts(1);
    compat = {};
    if stepcnt >= this.initime
        rowindx = mod( stepcnt - this.initime , length(this.pattern) ) + 1;
        if rowindx<=length(this.pattern)
            compat = this.pattern{rowindx};
        end
        if this.firstcall == 0
            this.counter =  1;
            this.firstcall = 1;
        else
            this.counter =  this.counter + 1;
        end
    end
else
    for i=1:length(stepcnts)
        stepcnt = stepcnts(i);
        compat{i} = this.getcomms( stepcnt );
    end
end


if nargout <=1
    if ~isempty( inputname(1) )
        assignin('caller',inputname(1),this);
    else
        error('Could not overwrite the instance; make sure that the argument is not in an array!');
    end
    varargout{1} = compat;
else
    varargout{2} = this;
    varargout{1} = compat;
end