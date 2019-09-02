function [ Main] =thresh(im)
[x,y]=size(im);
if ((x>1400)||(y>4500))
    i=imresize(im, 0.2);
elseif ((x<500)||(y<500))
        i=imresize(im, 1.4);
else
    i=imresize(im, 0.3);
end


I=rgb2gray(i);
rmin=40;
rmax=400;
%out=thresh(i,im,40,400);
scale=1;
%Libor Masek's idea that reduces complexity
%significantly by scaling down all images to a constant image size 
%to speed up the whole process
rmin=rmin*scale;
rmax=rmax*scale;
%scales all the parameters to the required scale
I=im2double(I);

%arithmetic operations are not defined on uint8
%hence the image is converted to double
pimage=I;
%stores the image for display
I=imresize(I,scale);
I=imcomplement(imfill(imcomplement(I),'holes'));
%this process removes specular reflections by using the morphological operation 'imfill'
%I=nbdavg(I);
%blurs the sharp image formed as a result of using imfill
rows=size(I,1);
cols=size(I,2);
[X,Y]=find(I<0.5);
%Generates a column vector of the image elements
%that have been selected by tresholding;one for x coordinate and one for y
s=size(X,1);
for k=1:s %
    if (X(k)>rmin)&(Y(k)>rmin)&(X(k)<=(rows-rmin))&(Y(k)<(cols-rmin))
            A=I((X(k)-1):(X(k)+1),(Y(k)-1):(Y(k)+1));
            M=min(min(A));
            %this process scans the neighbourhood of the selected pixel
            %to check if it is a local minimum
           if I(X(k),Y(k))~=M
              X(k)=NaN;
              Y(k)=NaN;
           end
    end
end
v=find(isnan(X));
X(v)=[];
Y(v)=[];
%deletes all pixels that are NOT local minima(that have been set to NaN)
index=find((X<=rmin)|(Y<=rmin)|(X>(rows-rmin))|(Y>(cols-rmin)));
X(index)=[];
Y(index)=[];  
%This process deletes all pixels that are so close to the border 
%that they could not possibly be the centre coordinates.
N=size(X,1);
%recompute the size after deleting unnecessary elements
maxb=zeros(rows,cols);
maxrad=zeros(rows,cols);
%defines two arrays maxb and maxrad to store the maximum value of blur
%for each of the selected centre points and the corresponding radius
for j=1:N
    [b,r,blur]=partiald(I,[X(j),Y(j)],rmin,rmax,'inf',600,'iris');%coarse search
    maxb(X(j),Y(j))=b;
    maxrad(X(j),Y(j))=r;
end
[x,y]=find(maxb==max(max(maxb)));
ci=search(I,rmin,rmax,x,y,'iris');%fine search
%finds the maximum value of blur by scanning all the centre coordinates
ci=ci/scale;

%the function search searches for the centre of the pupil and its radius
%by scanning a 10*10 window around the iris centre for establishing 
%the pupil's centre and hence its radius
%cp=search(I,round(0.1*r),round(0.8*r),ci(1)*scale,ci(2)*scale,'pupil');%Ref:Daugman's paper that sets biological limits on the relative sizes of the iris and pupil
%cp=cp/scale;
%displaying the segmented image
imageSize = size(i);
ci = [ci(1), ci(2), ci(3)];     % center and radius of circle ([c_row, c_col, r])
   % center and radius of circle ([c_row, c_col, r])
 

%%find pupil%%
cp=search(I,round(0.1*r),round(0.8*r),ci(1)*scale,ci(2)*scale,'pupil');%Ref:Daugman's paper that sets biological limits on the relative sizes of the iris and pupil
cp=cp/scale;
cp=[cp(1), cp(2), cp(3)];   
[xp,yp] = ndgrid((1:imageSize(1))-cp(1),(1:imageSize(2))-cp(2));
pupilMask = uint8((xp.^2 + yp.^2)<cp(3)^2);
%%find pupil%%

   
[xx,yy] = ndgrid((1:imageSize(1))-ci(1),(1:imageSize(2))-ci(2));
mask = uint8((xx.^2 + yy.^2)<ci(3)^2);
croppedImage = uint8(zeros(size(I)));
[x,y]=size(im);
croppedImage2=imresize(croppedImage,[x,y/3]);
croppedImage3=croppedImage2;
mask2=imresize(mask,[x,y/3]);

pupilMask2=imresize(pupilMask,[x,y/3]);
pupilMask3=pupilMask2;
pupilMask2(pupilMask3==1) = 0;
pupilMask2(pupilMask3==0) = 1;


if ((x>1400)||(y>4500))
    ci(1)=ci(1)*5;
    ci(2)=ci(2)*5;
    ci(3)=ci(3)*5;
    cp(1)=cp(1)*5;
    cp(2)=cp(2)*5;
    cp(3)=cp(3)*5;
elseif ((x<500)||(y<500))
    ci(1)=ci(1)*(1/1.4);
    ci(2)=ci(2)*(1/1.4);
    ci(3)=ci(3)*(1/1.4);
     cp(1)=cp(1)*(1/1.4);
    cp(2)=cp(2)*(1/1.4);
    cp(3)=cp(3)*(1/1.4);
else
    ci(1)=ci(1)*(1/0.3);
    ci(2)=ci(2)*(1/0.3);
    ci(3)=ci(3)*(1/0.3);
    cp(1)=cp(1)*(1/0.3);
    cp(2)=cp(2)*(1/0.3);
    cp(3)=cp(3)*(1/0.3);
end



croppedImage2(:,:,1) = im(:,:,1).*mask2;
croppedImage2(:,:,2) = im(:,:,2).*mask2;
croppedImage2(:,:,3) = im(:,:,3).*mask2;

croppedImage3(:,:,1) = croppedImage2(:,:,1).*pupilMask2;
croppedImage3(:,:,2) = croppedImage2(:,:,2).*pupilMask2;
croppedImage3(:,:,3) = croppedImage2(:,:,3).*pupilMask2;

out=croppedImage3;

Main=imcrop(out,[ci(2)-ci(3), ci(1)-ci(3),ci(2)+ci(3)-(ci(2)-ci(3)),ci(1)+ci(3)-(ci(1)-ci(3))]);


end