function m_testMpieFaceReg()
    imFile = 'W:\face\multipi\session01\multipie_png\001\01\05_1\001_01_01_051_07.png';
    lmFile = 'V:\Data\multipie\lm\001_01_01_051_05_lm.mat';
    
    im = double(rgb2gray(imread(imFile)));
    load(lmFile, 'pts');

    
    [face, XI, YI] = ml_mpieFaceReg(size(im), pts, 'face');
    ZI = interp2(im,XI,YI);
    im2 = zeros(size(im));
    im2(face) = ZI;
    imshow(uint8(im2));
