function IsColesterolExist=findingColesterolRing(im, colorDiagnosis)
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

mask = uint8((xx.^2 + yy.^2)<(ci(3)/1.1)^2);
croppedImage = uint8(zeros(size(im2)));
croppedImage(:,:,1) = i(:,:,1).*mask;
croppedImage(:,:,2) = i(:,:,2).*mask;
croppedImage(:,:,3) = i(:,:,3).*mask;
out=croppedImage;
 
STEP1 =imcrop(out,[ci(2)-ci(3)/1.5, ci(1)-ci(3)/1.5,ci(2)+ci(3)/1.5-(ci(2)-ci(3)/1.5),ci(1)+ci(3)/1.5-(ci(1)-ci(3)/1.5)]);
mask3 = uint8((xx.^2 + yy.^2)>(ci(3)/1.3)^2);

croppedButtom = uint8(zeros(size(im2)));
croppedButtom(:,:,1) = out(:,:,1).*mask3;
croppedButtom(:,:,2) = out(:,:,2).*mask3;
croppedButtom(:,:,3) = out(:,:,3).*mask3;


FinalB=imcrop(croppedButtom,[ci(2)-ci(3), ci(1)-ci(3),ci(2)+ci(3)-(ci(2)-ci(3)),ci(1)+ci(3)-(ci(1)-ci(3))]);
I2=FinalB;
gry=rgb2gray(I2);

%%%%%If eye color is blue, use different parameter value%%%%%
if(colorDiagnosis==0)
    lowlimit=155;
else
    lowlimit=130;
end



[m , n]=size(gry);
if m>n
    smallest=n;
else
    smallest=m;
end
gry=gry(1:smallest, 1:smallest);
 for j=1:smallest
     for i=1:smallest
         if (gry(i,j)>lowlimit && gry(i,j)<200)
             gry(i,j)=255;
         else
             gry(i,j)=0;
         end
     end
 end
 BW= imbinarize(gry);
 BW1 = bwareaopen(BW, 100);

se = strel('disk',8);
closeBW = imclose(BW1,se);

[B,L] = bwboundaries(closeBW,'noholes');
if (length(B)>0)
    IsColesterolExist=true;
else
    IsColesterolExist=false;
end



%%%Code that shows the colesterol ring was found
%Fasurot=label2rgb(L,@jet,[.5 .5 .5]);
%imshow(label2rgb(L,@jet,[.5 .5 .5]))
%hold on
%stats = regionprops(L,'Area','Centroid');

%for k = 1:length(B)
%  boundary = B{k};
%  plot(boundary(:,2),boundary(:,1),'w','LineWidth',2)
%end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end