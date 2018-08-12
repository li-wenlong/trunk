function [Xhf, varargout] = fusedmosest( par0, par1 , assocwP0, assocwP1 )

% assocwP0 is a mapping from par1 to par0
% assocwP1 is a mapping from par0 to par1

% see using the below:
%par0.drawassoc( par1, 'assoc', assocwP0 );
%par1.drawassoc( par0, 'assoc', assocwP1 );

numP0 = size( par0.states, 2);
numP1 = size( par1.states, 2);

Xhf = [];
Cs = [];

if nargin<=2




% Evaluat s_0(x) for P0 and P1
sig_ = 1; % This is the noise covariance to use during regularisation
s0 = par0.regwkde(sig_);
s1 = par1.regwkde(sig_);


%[evalthose, assoc] = these.evaluate( those.getstates );
[evalpar1at0, assocwP0 ] = s0.evaluate( s1.getstates );
[evalpar0at1, assocwP1 ] = s1.evaluate( s0.getstates );

par0.sublabels( par0.extlabelswblab );
par1.sublabels( par1.extlabelswblab );
end


[assocList, indxs, scores] = genassoc( par0.labels, par1.labels, assocwP0, assocwP1 );
% Display the clusters using the lines below:
% figure;
% rgbobj = rgb;
% rgbobj.getcol;
% for cnt = 1:size(indxs,1)
%     col = rgbobj.getcol;
%     optstr = ['''Color'',[', num2str(col),'],''linestyle'',''none'',''marker'',''<'''];
%     par0.getel(indxs{cnt,1}).draw('options',optstr,'axis',gca);
%     optstr = ['''Color'',[', num2str(col),'],''linestyle'',''none'',''marker'',''>'''];
%     par1.getel(indxs{cnt,2}).draw('options',optstr,'axis',gca);
% end

%[sscores, sptr] = sort( scores(:,1), 'descend' );
disc = [];
for i=1:size(assocList, 1)
    if assocList(i,1)==0 && assocList(i,2)==0
        disc = [disc, i];
    end
    %assocnum = sptr(i);
    
    %assocscore = sscores( assocnum );
    assocnum = i;
    
    pars = [par0.states(:, indxs{assocnum,1}), par1.states(:,  indxs{assocnum,2} ) ];
    Xhfe = mean( pars, 2 );
    Cse = cov( pars');
    Xhf = [Xhf,Xhfe];
    Cs = [Cs,{Cse}];
end

if ~isempty(Xhf)
    remind = setdiff( [1:size(Xhf,2)] , disc);
    Xhf = Xhf(:,remind);
    Cs = Cs(remind);
    indxs = indxs(remind,:);
    scores = scores(remind,:);
end

if nargout >= 2
    varargout{1} = Cs;
end

if nargout >= 3
    varargout{2} = indxs;    
end
if nargout >= 4
    if ~isempty(scores)
        varargout{3} = scores(:,1);
    else
        varargout{3} = [];
    end
end

