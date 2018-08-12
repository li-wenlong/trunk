function [regparticles, regweights_b1, regIests_, varargout ] = kdecic( p1, ci1, w1, p2, ci2, w2, omegaList, model  )


% Associate the clusters
g = groupclusters2( p1([1,3],:), ci1,w1, p2([1,3],:), ci2,w2,100);

% Prune the clusters
dim = size(p1, 1);
prunCnt = 0;
for cnt = 1:length(g)
    indx1 = g{cnt}{1};
    indx2 = g{cnt}{2};
    len1 = length(indx1);
    len2 = length(indx2);
    
    if len1 == 0 && len2 == 0
        warning('Empty pair removed from assignments!');
        
    elseif len1<dim && len1~=0 &&len2> dim
        if rank(cov(p2(:,indx2)'))==dim
            prunCnt = prunCnt + 1;
            gprun{prunCnt} = {[], indx2};
            warning('Degenerate cluster of set 1 removed from assignments!');
        else
            warning('Low rank cluter of set 2 is removed!')
        end
      
    elseif len1>dim && len2< dim && len2 ~=0
        if rank(cov(p1(:,indx1)'))==dim
            prunCnt = prunCnt + 1;
            gprun{prunCnt} = {indx1, []};
            warning('Degenerate cluster of set 2 removed from assignments!');
        else
            warning('Low rank cluter of set 1 is removed!')
        end
    elseif len1<dim && len1~=0 && len2< dim && len2 ~=0
        warning('Degenerate clusters of both set 1 and 2 remove from assignments!')
    else
        if len2~=0
            rankCP2 = rank(cov(p2(:,indx2)'));
        end
        if len1~=0
            rankCP1 = rank(cov(p1(:,indx1)'));
        end
        if len1~=0 && len2 ~=0
            if rankCP1 == dim && rankCP2 == dim
                prunCnt = prunCnt + 1;
                gprun{prunCnt} = {indx1, indx2};
            end
        elseif len1 == 0 && len2 ~= 0
            if rankCP2 == dim
                prunCnt = prunCnt + 1;
                gprun{prunCnt} = {[], indx2};
            end
        elseif len1 ~=0 && len2 == 0
            if rankCP1 == dim
                 prunCnt = prunCnt + 1;
                gprun{prunCnt} = {indx1, []};
            end
        end
    end
end
 
g = gprun;
        
clusterIndx = [];

regparticles = cell( length(omegaList), 1);
regweights_b1 = cell( length(omegaList), 1 ) ;
regIests_ =  cell( length(g), 1 ) ;
infomeas_ =  cell( length(g), 1 ) ;
for cnt = 1:length(g)
    %regParticles1 = regularise(particles1,model);
    %regParticles2 = regularise(particles2,model);
    % Regularise particles cluster by cluster
    regParticles1 = [];
    
    indx1 = g{cnt}{1};
    indx2 = g{cnt}{2};
    clusterIndx = [clusterIndx, cnt*ones(1, length(indx1)+length(indx2))];
   
    
    if isempty( indx1 ) && ~isempty( indx2 )
       for cnt2 = 1:length(omegaList)
           regparticles{cnt2} = [regparticles{cnt2}, p2(:,indx2 ) ];
           regweights_b1{cnt2} = [regweights_b1{cnt2}; w2(indx2) ];
       end
       continue;
    end
    if isempty( indx2 ) && ~isempty( indx1 )
       for cnt2 = 1:length(omegaList)
           regparticles{cnt2} = [regparticles{cnt2}, p1(:,indx1 ) ];
           regweights_b1{cnt2} = [regweights_b1{cnt2}; w1(indx1) ];
       end
       continue;
    end
    
    regParticles1 = regularise( p1(:, indx1), model );
    regParticles2 = regularise( p2(:, indx2), model );
    fprintf( 'Sizes of particle sets entering %dX%d and %dX%d\n',size(regParticles1,1),size(regParticles1,2),...
        size(regParticles2,1),size(regParticles2,2));
    ent1 = sum( w1(indx1) );
    ent2 = sum( w2(indx2) );
    
    [ regparticles_CI , regweights_CI_br, regIests, infomeas ] = kdeci_kde( regParticles1,  w1( indx1  )/ent1, ...
        regParticles2, w2( indx2 )/ent2, omegaList);
    
    for cnt2 = 1:length(omegaList)
        regparticles{cnt2} = [regparticles{cnt2}, regparticles_CI{cnt2} ];
        regweights_b1{cnt2} = [regweights_b1{cnt2}; regweights_CI_br{cnt2}(:) ];
    end
    regIests_{cnt} = [ regIests ];
    infomeas_{cnt} = [infomeas];
end


if nargout >= 4
    varargout{1} = clusterIndx;
end
if nargout >= 5
    varargout{2} = infomeas_;
end
if nargout >= 6
    varargout{3} = g;
end



    
