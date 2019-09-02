
clear all;
close all;
%0-NO, 1-YES
syntheticDir   = fullfile(toolboxdir('vision'), 'visiondata','hetro');
trainingSet = imageDatastore(syntheticDir,   'IncludeSubfolders', true, 'LabelSource', 'foldernames');
numImages = numel(trainingSet.Files);
trainingFeatures=zeros(numImages);
for i = 1:numImages
    image1 = readimage(trainingSet, i);
    F=FeaturStatisticalHTCRM(image1);%compare with database
    label=double(trainingSet.Labels(i))-1;
    F(10)=label;
try load HTCRM.mat
F=[F];
    HTCRM= [HTCRM;F];
    save HTCRM.mat HTCRM
    catch
  HTCRM=[F]; % 10 12%
  %db= [db;F];
    save HTCRM.mat HTCRM
 end    
 
end
trainingLabels = trainingSet.Labels;




function [F]=FeaturStatisticalHTCRM(im)
%[x,y]=size(im);
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


mask2 = uint8((xx.^2 + yy.^2)>(ci(3)/1.5)^2);

croppedUpper = uint8(zeros(size(im2)));
croppedUpper(:,:,1) = out(:,:,1).*mask2;
croppedUpper(:,:,2) = out(:,:,2).*mask2;
croppedUpper(:,:,3) = out(:,:,3).*mask2;


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

meanr=meanrU/meanrB;
meang=meangU/meangB;
meanb=meanbU/meanbB;

F=[meanr meang meanb meanrU meangU meanbU meanrB meangB meanbB];
end