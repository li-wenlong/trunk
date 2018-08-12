function varargout = sym2fun( fname, s )
% sym2fun( fname, s)
% produces an .m function of name fname that evaluates the symbolic
% expression s.
% check = piecewisesyms2mcode( fname, s)
% returns check = 1 if successfull and 0 otherwise

if nargin ~= 2
    error( 'Wrong number of inputs expected!');
end
if ~isstr( fname )
    error('Incorrect file name');
end
if nargout >1
    error('Wrong number of outputs expected!');
else
    varargout{1} = false;
end

if ~strcmp(fname(end-1:end),'.m')
    fname = [ fname, '.m'];
end

symstring = char(s);
inargstring = findsym(s);

if ~isempty(inargstring)
    inargsym = sym(inargstring);
    substring = [''];
    inargstringt = [''];
    for i=1:length( inargsym )
        substring = [substring,'''',char(inargsym(i)),''','];
        inargstringt = [inargstringt,char(inargsym(i)),'t,'];
    end
    substring = substring(1:end-1);
    inargstringt = inargstringt(1:end-1);
    
end

fid=fopen(fname,'wt');
if fid==-1
	error('Could not open file %s!',fname);
else
	[pth,name]=fileparts(fname);
    fprintf(fid,'function p_ = %s(%s)\n', fname(1:end-2), inargstringt );
    fprintf(fid,'%%  p_ = %s(%s)\n', fname(1:end-2), inargstringt );
    %fprintf(fid,'%% Generated automatically by the .m function piecewisesyms2mcode() \n', mfile_name(end-1:end) );
    %fprintf(fid,'%% %s',datestr(clock));
    for i=1:length( inargsym )
        if i==1
            fprintf(fid,'syms ');
        end
        fprintf(fid, char( inargsym(i)) );
    end
    fprintf(fid, '\n');
    fprintf( fid, 'p_ = subs( %s, {%s},{%s});', symstring, substring, inargstringt );
    

	ok=true;
	fclose(fid);
end

if nargout
	varargout{1}=ok;
end
