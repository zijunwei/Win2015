function [stdShp, AlgnParams, AlgnLmPts] = ml_procrustes(LmPts, lmPtIdxs)
% function [AlgnParams, AlgnLmPts] = ml_procrustes(LmPts, stdShp)
% Perform procrustes analysis.
% Inputs:
%   LmPts: 2k*n matrix for positions of k 2D-landmark points of n shapes.
%       For each column, the first k entries are X coordinates, 
%       and the last are Y coords.    
%   lmPtIdxs: indexes of landmark points used for alignment.
% Outputs:
%   stdShp: standardized/normalized shape computed using ml_cmpStdShp.
%   AlgnParams: affine alignment parameters.
%   AlgnLmPts: warped shapes.
% By: Minh Hoai Nguyen
% Date: 28 Sep 2008

if ~exist('lmPtIdxs', 'var') 
    lmPtIdxs = [];
end;

stdShp = ml_cmpStdShp(LmPts);
[AlgnParams, AlgnLmPts] = ml_procrustes_helper(LmPts, stdShp, lmPtIdxs);




% FAILED ATTEMPTS. It might be more reliable to compute 
% the stdardized shape using smth like ml_cmpStdShp rather than
% jointly optimize for the standardized shape and the alignment parameters
% The following are two pieces of code that do not work.

% % This does not seem to work
% function [stdShp, AlgnParams, AlgnLmPts] = procrustes1(LmPts)
%     [d, n] = size(LmPts);
%     k = d/2;
% 
%     cvx_begin
%         variable cvx_stdShp(d);
%         variable cvx_AlgnParams(6, n);
%         variable t(n);
%         minimize sum(t(:));
%         subject to
%             for j=1:n
%                 t(j) >= norm([cvx_stdShp(1:k), cvx_stdShp(k+1:d)] -  ...
%                     [LmPts(1:k,j), LmPts(k+1:d,j), ones(k,1)]*...
%                     [cvx_AlgnParams(1:3,j), cvx_AlgnParams(4:6,j)],2);            
%             end
%             sum(cvx_stdShp(:)) == 1000;
%     cvx_end
% 
%     stdShp = cvx_stdShp;
%     AlgnParams = cvx_AlgnParams;
%     AlgnLmPts = [];
% 
% % This does not seem to work/be stable    
% function procrustes2(LmPts)
%     
% scl = max(abs(LmPts(:)));
% LmPts = LmPts/scl;
% 
% [d, n] = size(LmPts);
% k = d/2;
% A = sparse(d*n, d+ 6*n);
% 
% for l=1:n
%    for i=1:k
%        r = d*(l-1)+2*(i-1)+1; 
%        c = d + 6*(l-1);
%        A(r, i) = -1;
%        A(r, c+1:c+3) = [LmPts(i,l); LmPts(i+k,l); 1];
%        A(r+1, k+i) = -1;
%        A(r+1, c+4:c+6) = [LmPts(i,l); LmPts(i+k,l); 1];
%    end;    
% end
% A = A'*A;
% [V, D] = eigs(A,1, 'sm');

