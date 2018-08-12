function varargout = fun_draw_debug_pmrf_carray( varargin)
global DEBUG_PMRF_CARRAY

varargout = {};
if isempty( DEBUG_PMRF_CARRAY )
    return;
end

strt =1;
stp = length( DEBUG_PMRF_CARRAY );

if nargin>=1
    strt = varargin{1};
end
if nargin>=2
    stp = varargin{2};
end
if stp-strt<0
    error('The inputs should be the beginning and end indices in the array');
end

mygraph = DEBUG_PMRF_CARRAY{1};
numnodes = length( mygraph.nodes );



 xpnts = [-6:0.01:6];
for cnt3 = strt:stp
    fhandle3  = figure;
    for i=1:numnodes
        ax(i) = subplot(numnodes*100 + 10 + i);
        hold on;
        grid on;
    end

    mygraph = DEBUG_PMRF_CARRAY{cnt3};
    
    for i=1:numnodes
         mynode = mygraph.nodes(i);
         myopicpost = mynode.getmyopicpostpar; % store the myopic posteriors
        
         [ahandle, fighandle, lprior] = mynode.initstate.draw('axis', ax(i), 'eval', xpnts, 'options', '''r'', ''LineStyle'',''-''' );
    
          [ahandle, fighandle, lmp] = myopicpost.draw('axis', gca, 'eval', xpnts, 'options',  '''c'',''LineStyle'',''-''' );
   
          [ahandle, fighandle, lpost_bp] = mynode.state.draw('axis', gca, 'eval', xpnts, 'options',  '''b'',''LineStyle'',''-''' );
    end
end