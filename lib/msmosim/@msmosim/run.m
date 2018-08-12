function varargout = run(this)



disp(sprintf('Starting simulation t_0 = %g \n  Proceeded to time: \n', this.time));

this.itercnt = 0;
while( this.time < this.cfg.tstop )
   
    this.itercnt = this.itercnt + 1;
    % Find the step size deltat for this iteration
    if( this.itercnt <= length( this.deltats ) )
        this.deltat = min( this.deltats( this.itercnt ), this.cfg.tstop - this.time  );
    else
        this.deltat = min( this.deltats( end ), this.cfg.tstop - this.time );
    end

    % One step of the simulation
    this.onestep;
    
    % Save this instance over the calling instance from the upper layer
    if ~isempty( inputname(1) )
        assignin('caller',inputname(1),this);
    else
        error('Could not overwrite the instance; make sure that the argument is not in an array!');
    end
    
   if mod( this.itercnt, 20 ) == 0
        fprintf('\n');
    end
    fprintf('%g,', this.time);    
end
fprintf('\n');


if nargout == 0
    if ~isempty( inputname(1) )
        assignin('caller',inputname(1),this);
    else
        error('Could not overwrite the instance; make sure that the argument is not in an array!');
    end
else
    varargout{1} = this;
end

