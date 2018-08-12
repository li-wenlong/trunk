function dispactplats(this)

if ~isempty(this.actplatsbuffer)
    
    fprintf('time\t--Platforms');
    fprintf('\n');
    for i=1:length( this.actplatsbuffer)
        fprintf('%g:\t', this.actplatsbuffer(i).time)
        fprintf('%g\t',this.actplatsbuffer(i).actplats );
        fprintf('\n');
        
    end
end