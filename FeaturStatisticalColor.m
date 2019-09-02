function [F]=FeaturStatisticalColor(im)
%im = repmat(all(im>170,3),[1 1 3]); %mask values less than 20 in RGB- turn all the white spots to black
im2=rgb2gray(im);
i=im;
center=size(im2)/2+.5;%center pixel of im
ci = [center(1), center(2), center(1)];%[x,y] of center pixel & Radiud

imageSize=size(im);
[xx,yy] = ndgrid((1:imageSize(1))-ci(1),(1:imageSize(2))-ci(2));
out=im; %creat mask of 
mask2 = uint8((xx.^2 + yy.^2)>(ci(3)/1.5)^2);

croppedUpper = uint8(zeros(size(im2)));
croppedUpper(:,:,1) = out(:,:,1).*mask2;
croppedUpper(:,:,2) = out(:,:,2).*mask2;
croppedUpper(:,:,3) = out(:,:,3).*mask2;

%mask on upper 2/3 image
FinalU=imcrop(croppedUpper,[ci(2)-ci(3), ci(1)-ci(3),ci(2)+ci(3)-(ci(2)-ci(3)),ci(1)+ci(3)-(ci(1)-ci(3))]);

mask = uint8((xx.^2 + yy.^2)<(ci(3)/1.5)^2);
croppedImage = uint8(zeros(size(im2)));
croppedImage(:,:,1) = i(:,:,1).*mask;
croppedImage(:,:,2) = i(:,:,2).*mask;
croppedImage(:,:,3) = i(:,:,3).*mask;
out=croppedImage;
 
STEP1 =imcrop(out,[ci(2)-ci(3)/1.5, ci(1)-ci(3)/1.5,ci(2)+ci(3)/1.5-(ci(2)-ci(3)/1.5),ci(1)+ci(3)/1.5-(ci(1)-ci(3)/1.5)]);
mask3 = uint8((xx.^2 + yy.^2)>(ci(3)/4)^2);

croppedButtom = uint8(zeros(size(im2)));
croppedButtom(:,:,1) = out(:,:,1).*mask3;
croppedButtom(:,:,2) = out(:,:,2).*mask3;
croppedButtom(:,:,3) = out(:,:,3).*mask3;

%mask on lower 1/3 image
FinalB=imcrop(croppedButtom,[ci(2)-ci(3), ci(1)-ci(3),ci(2)+ci(3)-(ci(2)-ci(3)),ci(1)+ci(3)-(ci(1)-ci(3))]);

I=FinalU;
M = repmat(all(I>150,3),[1 1 3]); %mask values less than 20 in RGB
I(M)=0;
im=double(I);
rU=im(:,:,1);
gU=im(:,:,2);
bU=im(:,:,3);
I2=FinalB;
M2=repmat(all(I>150,3),[1 1 3]);
I2(M2)=0;
im1=double(I2);
rB=im1(:,:,1);
gB=im1(:,:,2);
bB=im1(:,:,3);
stdrB=std(std(nonzeros(rB)));
stdgB=std(std(nonzeros(gB)));
stdbB=std(std(nonzeros(bB)));
stdrU=std(std(nonzeros(rU)));
stdgU=std(std(nonzeros(gU)));
stdbU=std(std(nonzeros(bU)));

meanrU=mean(mean(nonzeros(rU)));
meangU=mean(mean(nonzeros(gU)));
meanbU=mean(mean(nonzeros(bU)));

meanrB=mean(mean(nonzeros(rB)));
meangB=mean(mean(nonzeros(gB)));
meanbB=mean(mean(nonzeros(bB)));

F=[meanrB meangB meanbB meanrU meangU meanbU];
end