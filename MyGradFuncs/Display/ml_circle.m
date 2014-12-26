function ml_circle(x, y, r, lineWidth, edgeColor, faceColor)
% draw a circle
% Inputs:
%   x, y, r: center and radisu of the circle.
% Outputs:
%   draw the circle in current figure.
% By Minh Hoai Nguyen (minhhoai@cmu.edu)
% Date: 5 Nov 08

if ~exist('lineWidth', 'var') || isempty(lineWidth)
    lineWidth = 2;
end;

if ~exist('edgeColor', 'var') || isempty(edgeColor)
    edgeColor = 'r';
end;

if ~exist('faceColor', 'var') || isempty(faceColor)
    rectangle('Position',[x- r, y - r,2*r,2*r],'Curvature',[1,1],...
        'EdgeColor', edgeColor, 'LineWidth', lineWidth);
else
    rectangle('Position',[x- r, y - r,2*r,2*r],'Curvature',[1,1],...
        'FaceColor', faceColor, 'EdgeColor', edgeColor, 'LineWidth', lineWidth);
end;