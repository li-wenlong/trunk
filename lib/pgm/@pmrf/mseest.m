function e = mseest( this )
% mean squared error estimate of the multi-dimensional parameter with
% respect to the pairwise MRF model; each field is the empirical mean of
% the particle densities of the associated node.

e = this.nodes(1).state.mean;
for i=2:this.N
    e = [e; this.nodes(i).state.mean];
end
