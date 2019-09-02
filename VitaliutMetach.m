im=imread('3.jpg');
im2=rgb2gray(im);
i=imresize(im, 1);
center=size(im2)/2+.5;
ci = [center(1), center(2), center(1)];

imageSize=size(im);
[xx,yy] = ndgrid((1:imageSize(1))-ci(1),(1:imageSize(2))-ci(2));
mask = uint8((xx.^2 + yy.^2)<ci(3)^2);
croppedImage = uint8(zeros(size(im2)));
croppedImage(:,:,1) = im(:,:,1).*mask;
croppedImage(:,:,2) = im(:,:,2).*mask;
croppedImage(:,:,3) = im(:,:,3).*mask;
out=croppedImage;

Main=imcrop(out,[ci(2)-ci(3), ci(1)-ci(3),ci(2)+ci(3)-(ci(2)-ci(3)),ci(1)+ci(3)-(ci(1)-ci(3))]);

mask = uint8((xx.^2 + yy.^2)<(ci(3)/1.2)^2);
croppedImage = uint8(zeros(size(im2)));
croppedImage(:,:,1) = i(:,:,1).*mask;
croppedImage(:,:,2) = i(:,:,2).*mask;
croppedImage(:,:,3) = i(:,:,3).*mask;
out=croppedImage;
 
STEP1 =imcrop(out,[ci(2)-ci(3)/1.5, ci(1)-ci(3)/1.5,ci(2)+ci(3)/1.5-(ci(2)-ci(3)/1.5),ci(1)+ci(3)/1.5-(ci(1)-ci(3)/1.5)]);
mask3 = uint8((xx.^2 + yy.^2)>(ci(3)/1.6)^2);

croppedButtom = uint8(zeros(size(im2)));
croppedButtom(:,:,1) = out(:,:,1).*mask3;
croppedButtom(:,:,2) = out(:,:,2).*mask3;
croppedButtom(:,:,3) = out(:,:,3).*mask3;


FinalB=imcrop(croppedButtom,[ci(2)-ci(3), ci(1)-ci(3),ci(2)+ci(3)-(ci(2)-ci(3)),ci(1)+ci(3)-(ci(1)-ci(3))]);
imagesc(Main);
figure, imagesc(FinalB);