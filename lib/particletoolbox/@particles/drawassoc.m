function varargout = drawassoc(these, those, varargin )


plotOpt = {'''LineStyle'',''none'',''Marker'',''.'',''Color'',[0 0 1]'};
dims = [1,2];
scale  = 1;


assoc = [];

figureHandle = [];
axisHandle = [];

postcommands = '';
precommands = '';


nvarargin = length(varargin);
argnum = 1;
while argnum<=nvarargin
    if isa( varargin{argnum} , 'char')
        switch lower(varargin{argnum})
            case {'axis'}
                if argnum + 1 <= nvarargin
                    axisHandle = varargin{argnum+1};
                    argnum = argnum + 1;
                end
            case {'figure'}
                if argnum + 1 <= nvarargin
                    figureHandle = varargin{argnum+1};
                    argnum = argnum + 1;
                end
            case {'dims','dimensions'}
                if argnum + 1 <= nvarargin
                    dims = varargin{argnum+1}(:);
                    argnum = argnum + 1;
                end
                
            case {'postcommands'}
                if argnum + 1 <= nvarargin
                    postcommands = varargin{argnum+1};
                    argnum = argnum + 1;
                end
            case {'options'}
                if argnum + 1 <= nvarargin
                    plotOpt = varargin(argnum+1);
                    argnum = argnum + 1;
                end
            case {'precommands'}
                if argnum + 1 <= nvarargin
                    precommands = varargin{argnum+1};
                    argnum = argnum + 1;
                end
            case {'scale'}
                if argnum + 1 <= nvarargin
                    scale = varargin{argnum+1};
                    argnum = argnum + 1;
                end
             case {'assoc'}
                if argnum + 1 <= nvarargin
                    assoc = varargin{argnum+1};
                    argnum = argnum + 1;
                end
                
            otherwise
                error('Wrong input string');
        end
    end
    argnum = argnum + 1;   
end



if isempty(axisHandle)
    if isempty(figureHandle)
        figureHandle = figure;
    end
    axisHandle = gca;
end

if isempty(assoc)
    [evalthose, assoc] = these.evaluate( those.getstates );
end

%if isempty(assocP1)
%    [evals1, assocwP1] = s1.evaluate( s0.getstates );
%end




[d, Nc] = size(these.states);
nonzind = find(assoc>0 & assoc<=Nc );
if d>=2
    dstates_  = [these.states(dims,:); these.weights'*scale ];
    dstates2_= [those.states(dims,:); those.weights'*scale ];
    
    
    astatesx_ = [these.states(dims(1),assoc(nonzind));those.states(dims(1),nonzind)]; 
    astatesy_ = [these.states(dims(2),assoc(nonzind));those.states(dims(2),nonzind)];
    astatesz_ = [these.weights(assoc(nonzind))'*scale ;those.weights(nonzind)'*scale ];
else
    dstates_ = [these.states([1],:); zeros( 1, Nc); these.weights'*scale ];
    dstates2_ = [those.states([1],:); zeros( 1, Nc); those.weights'*scale ];
    
    astatesx_ = [these.states([1],assoc(nonzind));those.states([1],nonzind)];
    astatesy_ = [ zeros( 1, length(nonzind)); zeros( 1, length(nonzind))];
    astatesz_ = [these.weights(assoc(nonzind))*scale ;those.weights(nonzind)*scale ];
    
end
axes(axisHandle);
if ~isempty(precommands)
    eval(precommands);
end
hold on
grid on
eval(['plot3(dstates_(1,:), dstates_(2,:), dstates_(3,:),', plotOpt{1},');'] )
eval(['plot3(dstates2_(1,:), dstates2_(2,:), dstates2_(3,:),', plotOpt{1},',''Color'',[1 0 0]);'] )

eval(['plot3(astatesx_, astatesy_, astatesz_,','''Color'',[1 0 0]);'] )




if ~isempty(postcommands)
    eval( postcommands)
end
hold off

if nargout>=1
    varargout{1} = axisHandle;
end
if nargout>=2
    varargout{2} = figureHandle;
end


