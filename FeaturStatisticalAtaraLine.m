function F=FeaturStatisticalAtaraLine(im)
im=imresize(im, [350, 350]);
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

out1=rgb2gray(out);
[m, n]=size(out1);
if m>n
    smallest=n;
else
    smallest=m;
end
out1=out1(1:smallest, 1:smallest);

centerPoint=round(smallest/2);
firstColor=0;
flag=0;
 for j=round(smallest/3):centerPoint
     if out1(centerPoint,j)==0 &&out1(centerPoint,j+3)==0
          firstColor=[out1(centerPoint,j-2), out1(centerPoint,j-4),out1(centerPoint,j-6),...
              out1(centerPoint,j-8),out1(centerPoint,j-10),out1(centerPoint,j-12)];
          flag=1;
          break;
     end
 end
 if flag==0
     firstColor=[out1(144,94), out1(144,96),out1(144,98)...
         ,out1(144,100),out1(144,102),out1(144,104)];
 end
 firstColor=sort(firstColor);
 color=(firstColor(3)+firstColor(4))/2;   
 UpperRange=1.1*color;
  LowerRange=0.9*color;
 for i=1:smallest
     for j=1:smallest
         if out1(i,j)==0
             out1(i,j)=0;
         elseif (out1(i,j)<=UpperRange && out1(i,j)>=LowerRange)
             out1(i,j)=255;
         else
             out1(i,j)=0;
         end
     end
 end
 
  BW= imbinarize(out1);
 BW1 = bwareaopen(BW, 100);

se = strel('disk',8);
closeBW = imclose(BW1,se);
 
 
[B,L] = bwboundaries(closeBW,'noholes');
%Fasurot=label2rgb(L,@jet,[.5 .5 .5]);
%imshow(label2rgb(L,@jet,[.5 .5 .5]))
%hold on
%stats = regionprops(L,'Area','Centroid');
len=[];
for k = 1:length(B)
  boundary = B{k};
  len=[len length(boundary)];
 % plot(boundary(:,2),boundary(:,1),'w','LineWidth',2)
end
if size(len,2)<1
    len=[0 0];
elseif size(len,2)<2
    len=[len 0];
end
meanGrayImage=(mean(mean(nonzeros(rgb2gray(out)))));
features=[meanGrayImage sum(sum(BW)) len(1) len(2)];
F=FeaturStatisticalAtaraModel(features);
end


