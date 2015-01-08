function ml_drawSqr(corners, lineWidth, color)
% Inputs:
%   corners: [x1; y1; x2; y2] for 2 opposite corners of a square.
% Outputs:
%   Draw a square on the current figure.
% 

center = (corners(1:2) + corners(3:4))/2;

corner2a = rotateVec(corners(1:2) - center, 90) + center;
corner2b = rotateVec(corners(1:2) - center, -90) + center;


X = [corners(1); corner2a(1); corners(3); corner2b(1); corners(1)];
Y = [corners(2); corner2a(2); corners(4); corner2b(2); corners(2)];
line(X,Y, 'LineWidth', lineWidth, 'Color', color);

function vec = rotateVec(vec, angle)
    angle = angle*pi/180;
    a = cos(angle);
    b = sin(angle);
    vec = [a -b; b a]*vec;