function warpShp = ml_cmpMpieShp(shpParam, mShp, ShpBasis)


if ~isempty(ShpBasis*shpParam(7:end))
    mShp2 = mShp + ShpBasis*shpParam(7:end);
else
    mShp2 = mShp;
end;

A = shpParam(1:6);
M = [A(1), A(2), A(3); A(4), A(5), A(6); 0 0 1]; 
warpShp = [reshape(mShp2, 68, 2), ones(68,1)]*M';
warpShp = warpShp(:,1:2);


