function edges = ml_getImEdges(imH, imW, neighborType)
% edges = ml_getImEdges(imH, imW)
% Each image is a grid, the grid is composed of edges connecting neighboring pixels.
% This function find all of those edges. 
% Inputs:
%   imH, imW: height and width of the image.
%   neighborType: either '4NN' for 4 connectivity or '8NN' for eight connectivity, default: '4NN'.
% Outputs:
%   edges: a n*2 matrix, the i^th entry is a pair of indexes of two pixels of the corresponding edge.
%       The index of a pixel is the order of the pixel in the column vector after vectorizing using im(:).
% By: Minh Hoai Nguyen
% Date: 2 Aug 2007

if ~exist('neighborType', 'var') || isempty(neighborType)
    neighborType = '4NN';
end;

[X1, Y1] = meshgrid(1:imW-1, 1:imH);
[X2, Y2] = meshgrid(2:imW, 1:imH);
edges1 =  [sub2ind([imH, imW], Y1(:), X1(:)), ...
           sub2ind([imH, imW], Y2(:), X2(:))];

[X1, Y1] = meshgrid(1:imW, 1:imH-1);
[X2, Y2] = meshgrid(1:imW, 2:imH);
edges2 =  [sub2ind([imH, imW], Y1(:), X1(:)), ...
           sub2ind([imH, imW], Y2(:), X2(:))];

if strcmp(neighborType, '8NN')
    [X1, Y1] = meshgrid(1:imW-1, 1:imH-1);
    [X2, Y2] = meshgrid(2:imW, 2:imH);
    edges3 =  [sub2ind([imH, imW], Y1(:), X1(:)), ...
               sub2ind([imH, imW], Y2(:), X2(:))];
    
    [X1, Y1] = meshgrid(1:imW-1, 2:imH);
    [X2, Y2] = meshgrid(2:imW, 1:imH-1);
    edges4 =  [sub2ind([imH, imW], Y1(:), X1(:)), ...
               sub2ind([imH, imW], Y2(:), X2(:))];
    edges = [edges1; edges2; edges3; edges4];
else
    edges = [edges1; edges2];
end;
