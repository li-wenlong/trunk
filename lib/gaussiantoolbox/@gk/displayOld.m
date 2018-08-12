function display(X)

disp(X);

numItems = prod(size(X));
if numItems == 1
    get( X );
else
    disp(sprintf('%d items in %s', numItems, inputname(1) ));
    for i=1:numItems
        display(X(i));
    end
end

    