function [img, F]=FeaturStatistical(im)
im=rgb2gray(im);
im_bw=im2bw(im,0.3);
im_range=rangefilt(im);
im_edge=edge(im,'Canny', 0.05);
%F=im_edge;
stdbw=std(std(im_bw));
stdrange=std(std(double(im_range)));
%stdedge=std(std(im_edge));
meanbw=mean(mean(im_bw));
meanrange=mean(mean(double(im_range)));
%meanedge=mean(mean(im_edge));
F=[stdbw meanbw stdrange meanrange];
img=im_edge;
end