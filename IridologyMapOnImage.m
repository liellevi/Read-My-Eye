[fname path]=uigetfile('*.*','Open an eye ad input for Training');
fname=strcat(path, fname);
im=imread(fname);

[x,y]=size(image1);
im1=imresize(im, [x,y/3]);
im2=im2bw(im1, 0.7);
im2=uint8(im2);
result = image1 .* cat(3, im2, im2, im2);
imagesc(result);