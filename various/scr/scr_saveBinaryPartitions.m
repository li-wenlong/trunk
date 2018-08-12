% This script is to create binary partitions for two sets of varying sizes
% and saving these partitions

N1max = 10;
N2max = 10;

for i=2:N1max
    for j=i:N2max
        disp(sprintf('Computing binary partitions for sizes %d and %d',i,j));
        
        P = genbinpart(i,j);
        
        fname = ['binaryPartition_',num2str(i),'_',num2str(j),'.mat'];
        save(fname,'P');
    end
end
        
        
        
        