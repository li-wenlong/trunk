function drawlmrf(G, numRows, numCols, varargin )

figure
hold on

U = zeros(size( G{2},1 ),1 );
V = zeros(size( G{2},1 ),1 );

X = zeros(size( G{2},1 ),1 );
Y = zeros(size( G{2},1 ),1 );




for i = 1:size( G{2},1 )
    
    rowNum = fix((G{2}(i,1)-1)/numCols)+1;
    colNum = mod(G{2}(i,1),numCols);
    if colNum == 0
        colNum = numCols;
    end
    X(i) = colNum;
    Y(i) = rowNum;
    
     
    neRowNum = fix((G{2}(i,2)-1)/numCols)+1;
    neColNum = mod(G{2}(i,2), numCols);
    if neColNum == 0
        neColNum = numCols;
    end
    
    V(i) = neRowNum - rowNum;
    U(i) = neColNum - colNum;

end
 
quiver( X , Y , U, V, 0,'LineWidth',2,'MarkerSize',2);
       
for i=1:size( G{1},1)
    
    rowNum = fix((i-1)/numCols)+1;
    colNum = mod(i,numCols);
    if colNum == 0
        colNum = numCols;
    end
    
      
    plot(colNum,rowNum,'ob','MarkerSize',5,'LineWidth',2);
    text( colNum + 0.1,rowNum + 0.1, num2str(G{1}(i)) )
end

