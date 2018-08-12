function lrr = lrrange(domainAxis)

if isempty(domainAxis)
    lrr = [];
    return
end
numDecisions = 1;
dim = length(domainAxis);
bb = 0;
for i=1:dim
    dAxis1{i} =  domainAxis{i}(1:find(domainAxis{i}==0));
    dAxis2{i} =  domainAxis{i}(find(domainAxis{i}==0):end); 
end

lrr1 = cproduct( dAxis1 );
lrr2 = cproduct( dAxis2 );
lrr = [flipud(lrr1);lrr2(2:end,:)];

