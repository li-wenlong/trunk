function G = lmrf(numRows, numCols )

if numRows<=0 || numCols<=0
    error('Must input positive integer for number of rows and columns!');
end

E = [1:numRows*numCols]';
V = zeros( 2*( (numCols-1)*numRows + (numRows-1)*numCols) ,2);

if length(V)==0
    G = {E,[]};
    return
end

edgeCnt = 1;
for i=1:length(E)
    rowNum = fix((i-1)/numCols)+1;
    colNum = mod(i,numCols);
    if colNum == 0
        colNum = numCols;
    end
    
    % Right neighbor
    neRowNum = rowNum;
    neColNum = colNum + 1;
    if neColNum <= numCols
        V(edgeCnt,:) = [i, E((neRowNum-1)*numCols +neColNum ) ];
        edgeCnt = edgeCnt + 1;
    end
    % Down neighbor
    neRowNum = rowNum +1;
    neColNum = colNum;
    if neRowNum <= numRows
        V(edgeCnt,:) = [i, E((neRowNum-1)*numCols +neColNum ) ];
        edgeCnt = edgeCnt + 1;
    end
   % Up neighbor
    neRowNum = rowNum - 1;
    neColNum = colNum;
    if neRowNum >= 1
         V(edgeCnt,:) = [i, E((neRowNum-1)*numCols +neColNum ) ];
        edgeCnt = edgeCnt + 1;
    end

    % Left neighbor
    neRowNum = rowNum;
    neColNum = colNum -1;
    if neColNum >= 1
         V(edgeCnt,:) = [i, E((neRowNum-1)*numCols +neColNum ) ];
        edgeCnt = edgeCnt + 1;
    end
    
end
if edgeCnt~= size(V,1)+1
    error('Missing edge during graph construction');
end
G = {E,V};
    