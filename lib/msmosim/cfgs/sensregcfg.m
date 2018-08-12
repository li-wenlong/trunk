classdef sensregcfg
    properties
        numparticles = 60;
        x0bnd = 500; % -x0bnd<= x_0 <= x0bnd
        y0bnd = 500; % -y0bnd<= y_0 <= y0bnd
        psi0bnd = 10*pi/180; % -psi0bnd<= psi_0 <= psi0bnd
        mt = 'uniform'; % Markov Transition
        xtrbnd = 50;
        ytrbnd = 50;
        psitrbnd = 2*pi/180;
    end
end
