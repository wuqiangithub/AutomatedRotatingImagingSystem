% Main roots traits extraction
function [midpoint_x,midpoint_y,midpoint_z,mainrootlength,SurfaceArea_main,Volume_main,avgDiam_main]=mainroottraits(BW_main,size_vol);

% Input
% BW_main: main root voxels
% size_vol：either scalar or 3-length vector of cellsize along each coordinate

% Output
% midpoint_x,midpoint_y,midpoint_z: main root skeleton
% mainrootlength,SurfaceArea_main,Volume_main,avgDiam_main: Length,SurfaceArea,Volume,Diameter of main roots

 BW_main = bwmorph3(BW_main,'majority');

% [~,~,hig]=size(BW_main);

% midpoint_x=[];midpoint_y=[];midpoint_z=[];k=1; 
% for i =1:hig
%     A =BW_main(:,:,i);
%     s = regionprops(A,"Centroid");
%     midpoint_x(k)=s.Centroid(1);midpoint_y(k)=s.Centroid(2);midpoint_z(k)=i;
%     k=k+1;
% end
skel_main = bwskel(BW_main);

w=size(skel_main,1);
l=size(skel_main,2);
h=size(skel_main,3);
[midpoint_y,midpoint_x,midpoint_z]=ind2sub([w,l,h],find(skel_main(:)));

midlinepoints=[midpoint_x,midpoint_y,midpoint_z];

mainrootlength = length(midpoint_x)*size_vol;
s = regionprops3(BW_main,'Solidity','SurfaceArea','Volume');
SurfaceArea_main=sum(s.SurfaceArea)*size_vol*size_vol;
Volume_main=sum(s.Volume)*size_vol*size_vol*size_vol;
D1=sqrt(Volume_main/(3.1415926*mainrootlength))*2*size_vol;
D2=SurfaceArea_main/(2*3.1415926*mainrootlength)*2*size_vol;
avgDiam_main=(D1+D2)/2;