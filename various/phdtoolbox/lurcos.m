function c = lurcos( domainLabels, domainAxis)

if isempty(domainAxis)
    c = [];
    return;
end

if length(domainAxis)>1
    eString = ['rangePoints = zeros('];
    for i=1:length(domainAxis)
        eString = [ eString, num2str(length(domainAxis{i})),','];
    end
    eString = [eString(1:end-1),');'];
    eval(eString);
else
    rangePoints = zeros( length(domainAxis{1}),1);
end


c = functs( domainLabels, domainAxis, rangePoints );

lrr = countCartesianProduct(domainAxis );

numChannels = size(lrr,2);
for i=1:size(lrr,1)
    val = numChannels - length( find(lrr(i,:)==0));
    c = setval( c,  val, domainLabels, lrr(i,:) );
end