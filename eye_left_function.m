
function [F]=eye_left_function(im)

image1=im;
im=imread('eye_left.jpg');
[x,y]=size(image1);
im1=imresize(im, [x,y/3]);
im2=im2bw(im1, 0.7);
im2=uint8(im2);
F = image1 .* cat(3, im2, im2, im2);
end