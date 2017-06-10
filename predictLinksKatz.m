function lpScores = predictLinksKatz(adj,weight,maxDist)
%predictLinksKatz Katz link predictor
%   predictLinksKatz(adj,weight,maxDist) returns a matrix of the same size
%   as adj where entry (i,j) denotes the link prediction score for node pair
%   (i,j), where higher score denotes more likely to form an edge. weight
%   denotes the exponential decay weight applied to paths at distance > 1,
%   and maxDist denotes the maximum distance for which paths are
%   considered.

% Authors: Ruthwik R. Junuthula and Kevin S. Xu, 2016

n = size(adj,1);
lpScores = zeros(n);
adjPow = adj;
for dist = 1:maxDist
    disp(['Processing distance d = ' int2str(dist)])
    adjPow = adjPow * adj;
    lpScores = lpScores + weight^dist*adjPow;
end
lpScores(diag(true(n,1))) = 0;

end

