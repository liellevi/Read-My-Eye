function F=FeaturStatisticalStressRing(im)
im2Foraverage=rgb2gray(im);
i=imresize(im, 1);
center=size(im2Foraverage)/2+.5;
ci = [center(1), center(2), center(1)];

imageSize=size(im);
[xx,yy] = ndgrid((1:imageSize(1))-ci(1),(1:imageSize(2))-ci(2));
maskB = uint8((xx.^2 + yy.^2)<ci(3)^2);
croppedForAverage = uint8(zeros(size(im2Foraverage)));
croppedForAverage(:,:,1) = im(:,:,1).*maskB;
croppedForAverage(:,:,2) = im(:,:,2).*maskB;
croppedForAverage(:,:,3) = im(:,:,3).*maskB;
outForAverage=croppedForAverage;

MainB=imcrop(outForAverage,[ci(2)-ci(3), ci(1)-ci(3),ci(2)+ci(3)-(ci(2)-ci(3)),ci(1)+ci(3)-(ci(1)-ci(3))]);

maskB = uint8((xx.^2 + yy.^2)<(ci(3)/1.1)^2);
croppedForAverage = uint8(zeros(size(im2Foraverage)));
croppedForAverage(:,:,1) = i(:,:,1).*maskB;
croppedForAverage(:,:,2) = i(:,:,2).*maskB;
croppedForAverage(:,:,3) = i(:,:,3).*maskB;
outForAverage=croppedForAverage;
 
STEP1ForAverage =imcrop(outForAverage,[ci(2)-ci(3)/1.5, ci(1)-ci(3)/1.5,ci(2)+ci(3)/1.5-(ci(2)-ci(3)/1.5),ci(1)+ci(3)/1.5-(ci(1)-ci(3)/1.5)]);
maskBForAverage = uint8((xx.^2 + yy.^2)>(ci(3)/2)^2);

croppedBForAvaerage = uint8(zeros(size(im2Foraverage)));
croppedBForAvaerage(:,:,1) = outForAverage(:,:,1).*maskBForAverage;
croppedBForAvaerage(:,:,2) = outForAverage(:,:,2).*maskBForAverage;
croppedBForAvaerage(:,:,3) = outForAverage(:,:,3).*maskBForAverage;


FinalForAvarage=imcrop(croppedBForAvaerage,[ci(2)-ci(3), ci(1)-ci(3),ci(2)+ci(3)-(ci(2)-ci(3)),ci(1)+ci(3)-(ci(1)-ci(3))]);
rB=FinalForAvarage(:,:,1);
gB=FinalForAvarage(:,:,2);
bB=FinalForAvarage(:,:,3);
meanrB=mean(mean(nonzeros(rB)));
meangB=mean(mean(nonzeros(gB)));
meanbB=mean(mean(nonzeros(bB)));
averagSumRGB=meanrB+meangB+meanbB;
%%
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
mask3 = uint8((xx.^2 + yy.^2)>(ci(3)/1.7)^2);

croppedButtom = uint8(zeros(size(im2)));
croppedButtom(:,:,1) = out(:,:,1).*mask3;
croppedButtom(:,:,2) = out(:,:,2).*mask3;
croppedButtom(:,:,3) = out(:,:,3).*mask3;

FinalB=imcrop(croppedButtom,[ci(2)-ci(3), ci(1)-ci(3),ci(2)+ci(3)-(ci(2)-ci(3)),ci(1)+ci(3)-(ci(1)-ci(3))]);

RGBsum=sum(FinalB,3);
NewImage = zeros(size(FinalB));
[row,column,depth]=size(FinalB);
 White_pix=0;
 Black_pix=0;
black=0;
 for d=1:depth
    for r=1:row 
        for c=1:column
            if RGBsum(r,c)==0 
                black=black+1;
            end
           if ( RGBsum(r,c) >= (averagSumRGB+60) && RGBsum(r,c)~=0)
               NewImage(r,c,d)=255;
                Black_pix=Black_pix+1;
           else
               NewImage(r,c,d)=0;
                White_pix=White_pix+1;

           end
        end 
    end
 end
rB=FinalB(:,:,1);
gB=FinalB(:,:,2);
bB=FinalB(:,:,3);
meanrB=mean(mean(nonzeros(rB)));
meangB=mean(mean(nonzeros(gB)));
meanbB=mean(mean(nonzeros(bB)));
 total= numel(FinalB);
 total=total-black;

features=[White_pix/total Black_pix/total meanrB meangB meanbB];
F= FeaturStatisticalStressModel(features);
end
