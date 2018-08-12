function g = groupClusters( p1, ci1,w1, p2, ci2, w2, varargin )

if nargin >= 5
    threshold = varargin{1}(1);
else
    threshold = 3;
end

[dummy_1 dummy_2] = size(p1);
if dummy_1>dummy_2
    p1 = p1';
end

[dummy_1 dummy_2] = size(p2);
if dummy_1>dummy_2
    p2 = p2';
end

[d N1] = size(p1);
[d N2] = size(p2);

cn1 = sort( unique( ci1 ) );
cn2 = sort( unique( ci2 ) );

cn1notzero = setdiff( cn1, 0 );
cn2notzero = setdiff( cn2, 0 );

p4f1.particles = p1;
p4f1.clusterIndx = ci1;
p4f1.ent = sum(w1);

p4f2.particles = p2;
p4f2.clusterIndx = ci2;
p4f2.ent = sum(w2);

[Xh1, indxs1 ] = hackstateestimates(p4f1);
[Xh2, indxs2 ] = hackstateestimates(p4f2);

numme1 = size(Xh1,2);
numme2 = size(Xh2,2);


if ~isempty(Xh1)
    if ~isempty(Xh2)
        for i=1:numme1
            for j=1:numme2
                A(i,j) = norm(Xh1(:,i)-Xh2(:,j));
            end
        end
        % For having the Hungarian work, take out the outliers 
        out1 = [];    
        rAcnt = 1;
        rA = [];
        for i=1:numme1
            if isempty( find( A(i,:)< threshold ))
                out1 = [out1,i];
            else
                rA(rAcnt,:) = A(i,:);
                rAcnt = rAcnt + 1;
            end
        end
        out2 = [];
        rAcnt = 1;
        rrA = [];
        if ~isempty(rA)
            for j=1:numme2
                if isempty( find(rA(:,j))< threshold )
                    out2 = [out2, j];
                else
                    rrA(:, rAcnt) = rA(:,j);
                    rAcnt = rAcnt + 1;
                end
            end
        else
            % All classes fromt the second set of particles are outliers
            out2 = [1:numme2];
        end
        
        nout1 = setdiff( [1:numme1], out1); % Non-outliers 
        nout2 = setdiff( [1:numme2], out2); % Non-outliers
        
        M = rrA;
        if ~isempty(rrA)
            % Get the Hungarian solution for the non outliers
            [M, costs] = Hungarian(rrA);
        end
              
        % Check if there is any unresolved assignment - i.e. inf in M
        if sum(sum(isinf(M)))~=0
            disp(sprintf('Unmatched sets of particles labeled by the observations'))
            fprintf('1--\t 2--\n')
            for i=1:size(infind,1)
                mind = find( isinf(M(i,:)) ==1 ); % Check the ithe row of M
                if ~isempty(mind)
                    % This corresponds to the following from the 1st set
                    umobs1 = Xh1(:,nout1(i));
                    for j=1:length(mind)
                        % The below from the second set result with Inf in
                        % M
                        umobs1 = [umobs1,Xh2( :, nout2(mind(j) ))];
                    end
                    % Display
                    for j=1:size(umobs1)
                        fprintf('%f\t',umobs1(j,:));
                        fprintf('\n');
                    end
                end
            end
        end
        
        numgroups = 0;
        for i=1:size(M,1)
            mind = find( M(i,:)==1);
            if ~isempty(mind)
                numgroups = numgroups + 1;
                g{numgroups} = { indxs1{ nout1(i)}, indxs2{ nout2(mind(1))}  };
            else
                numgroups = numgroups + 1;
                g{numgroups} = {indxs1{nout1(i)}, []};
            end
        end
        if exist('g')
        numgroups = length(g);
        end
        for j=1:size(M,2)
            mind = find( M(:,j)==1);
            if isempty(mind)
                numgroups = numgroups + 1;
                g{numgroups} = {[], indxs2{nout2(j)}};
            end
        end
        % Add the outliers from the first set
        for i=1:length(out1)
            numgroups = numgroups + 1;
            g{numgroups} = { indxs1{ out1(i) }, [] };
        end
        for j=1:length(out2)
            numgroups = numgroups + 1;
            g{numgroups} = {[], indxs2{out2(j)} };
        end
        
    else
        for j=1:numme1
            g{j} = {indxs1{j},[]};
        end
    end
else
    if ~isempty(Xh2)
        for j=1:size(Xh2)
            g{j} = {[],indxs2{j}};
        end
    else
        g = {[],[]};
    end
end
