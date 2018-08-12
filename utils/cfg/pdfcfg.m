classdef pdfcfg
    properties
        kerneltype = 'G'; % Kernel selection for the kde toolbox
        % 'G' for Gauss, 'E' for 'Epanetchnikov' , 'L' for 'Laplacian'
        bwselection = 'rot'; % BW selection for the kde toolbox
        % 'rot' , 'lcv', or 'Hall'
        particles
        gmm  = [];
    end
    methods
        function d = pdfcfg()
           % d.gmm = gmm; 
        end
    end
end
