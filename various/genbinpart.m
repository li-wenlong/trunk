function P = genbinpart(N,M)
% P = genbinpart(N,M)
% returns "binary partitions" of two sets of cardinality N and M in the
% cell array P, as defined in Mahler's multi-sensor PHD article.
% The procedure followed has the worst possible run time as it prunes from
% all possible partitions, those that satisfy the definition. A
% constructive procedure might be more useful.
% These terms are used to sum over the sensor contributions in the update
% formula. For M-sensors M-ary partitions that could be defined similarly,
% would be required.
%
% Murat Uney 17/01/2015

Ps = nchoosek([1:N+1+M+1],2); % all pairs
% find those (ordered) pairs with elements from the first set in the
% second field
indx_finsec = find( Ps(:,2) <=N+1);
% find those (ordered) pairs with elements from the second set in the
% first field
indx_sinfirst = find( Ps(:,1)>N+1);

% leave out these rows and get a prunned Ps
Psp = Ps( setdiff([1:size(Ps,1)] ,[indx_finsec;indx_sinfirst]),:);

% Now put zero for the 1 entry on the left and N+1+1 entry on the right
Psp(find(Psp(:)==1)) = 0;
Psp(find(Psp(:)==1+N+1)) = 0;
% leave out the (0,0) element
rindx = find( Psp(:,1) == 0 );
rrindx = find( Psp(rindx,2) == 0 );
Psp = Psp( setdiff([1:size(Psp,1)] ,rindx(rrindx)),:);
% Now modify the coding to have 0:N on the left side and 0:M on the
% right
indx = find( Psp(:,1) > 0 );
Psp(indx, 1 ) = Psp(indx, 1 )-1;
% Now modify to have 0:M on the right hand side
indx = find( Psp(:,2) > 0 );
Psp(indx, 2 ) = Psp(indx, 2 )-(N+2);

% Now, find all the subsets and the partitions: we are after are the ones
% that span [1:N+M] as defined in Mahler's multi-sensor PHD article

numPs = size(Psp,1);
P = {};
for i=1:numPs
    Pcands = nchoosek( [1:numPs], i); % These subsets are partition candidates
    for j=1:size(Pcands,1);
        % Check if all elements of the first set is contained
        elone = Psp( Pcands(j,:), 1);
        
         % discard zero
        indx = find(elone==0);
        if ~isempty(indx)
            elone = elone(setdiff([1:length(elone)],indx));
        end
        
        % if any recurring element, then reject
        if length(elone) ~= length(unique(elone,'legacy'))
            continue;
        end
        
        if ~isempty( setdiff( [1:N], elone ) )
            % not covered
            continue;
        end
        % check if all elements of the second set is contained
        eltwo = Psp( Pcands(j,:), 2);
        
        % discard zero
        indx = find(eltwo==0);
        if ~isempty(indx)
            eltwo = eltwo(setdiff([1:length(eltwo)],indx));
        end
        % discard zero
        % if any recurring element, then reject
        if length(eltwo) ~= length(unique(eltwo,'legacy'))
            continue;
        end
        if ~isempty( setdiff([1:M], eltwo ) )
            % not covered
            continue;
        end
        P{end+1} = Psp( Pcands(j,:), :);   
    end
end
