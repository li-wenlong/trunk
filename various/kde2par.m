function [ pss ] = kde2par(these )

for i=1:length(these)
ps = particles('states',getPoints( these(1)), 'weights',getWeights(these(1)),'labels',i);
ps.findkdebws; % Find the bandwidhts
% ps.regwkde; % Resample using the kde keeping the weights same.
% ps.resample; % Resample with repetition and generate equally weighted samples.
pss(i) = ps;
end