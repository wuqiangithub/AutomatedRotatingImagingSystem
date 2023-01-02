% lateral roots traits calculation
function [skel_lat,Totallength_lat,SurfaceArea_lat,Volume_lat,avgDiam_lat]=detailtraitscal(img_lat,size_vol)

% Input
% BW_lat_cut: lateral roots voxels
% size_vol：either scalar or 3-length vector of cellsize along each coordinate

% Output
% skel_lat: lateral roots skeleton
% Totallength_lat,SurfaceArea_lat,Volume_lat,avgDiam_lat: total length,SurfaceArea,Volume,average diameter of main roots

img_lat = logical(img_lat);


%提取骨架
% skel_lat = Skeleton3D(img_lat);
skel_lat = bwskel(img_lat);


Totallength_lat = sum(skel_lat(:))*size_vol
s = regionprops3(img_lat,'Solidity','SurfaceArea','Volume');
SurfaceArea_lat=sum(s.SurfaceArea)*size_vol*size_vol
Volume_lat=sum(s.Volume)*size_vol*size_vol*size_vol
D1=sqrt(Volume_lat/(3.1415926*Totallength_lat))*2*size_vol;
D2=SurfaceArea_lat/(2*3.1415926*Totallength_lat)*2*size_vol;
avgDiam_lat=(D1+D2)/2
skel_lat=bwmorph3(skel_lat,'clean');
end