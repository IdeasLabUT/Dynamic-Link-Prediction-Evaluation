function lpScores = predictLinksAA(adj)
%predictLinksAA Adamic-Adar link predictor
%   predictLinksAA(adj) returns a matrix of the same size as adj where
%   entry (i,j) denotes the link prediction score for node pair (i,j),
%   where higher score denotes more likely to form an edge.

% Authors: Ruthwik R. Junuthula and Kevin S. Xu, 2016

% Force graph to be undirected because Adamic-Adar applies only to
% undirected graphs
if ~isequal(adj,adj')
    warning('Graph appears to be directed. Converting to undirected graph.')
    adj = max(adj,adj');
end

n = size(adj,1);
deg = sum(adj,2);

lpScores = zeros(n);
for i = 1:n
    if mod(i,100) == 0
        disp(['Processing node ' int2str(i)])
    end
    
    for j = i+1:n
        commonNeighbors = (adj(i,:) & adj(j,:));
        lpScores(i,j) = sum(1./log10(deg(commonNeighbors)));
        lpScores(j,i) = lpScores(i,j);
    end
end

end

