function lrr = cproduct( domainAxis )


numDecisions = 1;
dim = length(domainAxis);
bb = 0;
for i=1:dim
    numDecisions = numDecisions*length(domainAxis{i});
    bb = bb+ (length(domainAxis{i})-1)*length(domainAxis{i})^(i-1);
    rdomainAxis{i} = sort(domainAxis{i} );
    domainAxis{i} = [length(domainAxis{i})-1:-1:0]';
end
bb = bb+1;

lrr = ones( numDecisions, dim );
if isempty(lrr)
    return;
end

indxs = ones( length(domainAxis), 1);
% Count upwards or downwards
indxsdir = ones( length(domainAxis), 1);
% for j=2:dim
%     indxs(j) = length(domainAxis{j});
%     indxsdir(j) = -1;
% end

for i = 1:numDecisions
    lrr(i,1) = domainAxis{1}(indxs(1));
    for j=2:dim
        lrr(i,j) = domainAxis{j}( indxs(j) );
    end
    if i == numDecisions
        break;
    end
    
    indxs(1) =  indxs(1)+1;
    for k=1:dim
        if indxs(k)> length( domainAxis{k} )
            indxs(k)= 1;
            indxs(k+1) = indxs(k+1) + 1;
        end
    end 
end

[slrr, indxs] =  sort( sum(bb.^lrr,2));
lrr = lrr(indxs,:);
for i=1:dim
    lrr(:,i) = rdomainAxis{i}(lrr(:,i)+1);
end
% order = [1:numDecisions]';
% for i=2:numDecisions
%     k = i-1;
%     dummy() = 
%     

