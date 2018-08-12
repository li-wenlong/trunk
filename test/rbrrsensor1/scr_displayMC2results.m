
load rbrrsensortestdata_1t2s_3.mat
% Experiment numbers
enums = [1:99];

expcnt = 0;


for ecnt = 1:length(enums)
    enum = enums( ecnt );
    mydatafilenum = enum;
    
    % Take the simulation file
    % filecontent = load( [cd, filesep, num2str( mydatafilenum ) ,filesep, ofnp, num2str(mydatafilenum), ofns ] );
    expdir = cd;
    expdir = expdir(1:max( strfind(expdir,filesep) )-1);
    
    
    filename = [ 'mc2try', num2str( mydatafilenum ) ,'.mat' ];
    if ~exist(filename)
        disp(sprintf('No file exists %s',filename));
        continue;
    end
    
    filecontent = load( filename );
    
      


    a = 500;
    b = 1;
    expcnt = expcnt + 1;
    
    [ospacombf1(expcnt,:), ospalocf1(expcnt,:), ospacardf1(expcnt,:)] = calcOSPAseries( Xt, filecontent.Xhs, a, b );
    [ospacombf2(expcnt,:), ospalocf2(expcnt,:), ospacardf2(expcnt,:)] = calcOSPAseries( Xt, filecontent.Xhs2, a, b  );
    
      
  
end

mospalocf1 = meanexzeros( ospalocf1 );
mospalocf2 = meanexzeros( ospalocf2 );



figure
grid on
hold on
plot( mospalocf1, 'k' )
plot( mospalocf2, 'b' )
ylabel('OSPA loc.')