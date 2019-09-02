
function [F]=eye_right_function(im)
image1=im;
map=imread('eye_right.jpg');
[x,y]=size(image1);
im1=imresize(map, [x,y/3]);
im2=im2bw(im1, 0.7);
im2=uint8(im2);
F = image1 .* cat(3, im2, im2, im2);
end