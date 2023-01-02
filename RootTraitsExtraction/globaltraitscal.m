% global root traits extraction
function [height,width,ConvexVolume,SurfaceArea_whole,Volume_whole,Solidity_whole,Totallength_whole,skel_whole]=globaltraitscal(x,y,z,BW_whole,size_vol)
% INPUT
% x,y,z:the coordinates of the point clouds
% BW_whole: the voxelized model
% size_vol：either scalar or 3-length vector of cellsize along each coordinate

% OUTPUT
% height,width,ConvexVolume,SurfaceArea,Volume,Solidity,Totallength,root skeleton;

width2=max(y)-min(y);width1=max(x)-min(x);width=max(width2,width1);
height=max(z)-min(z);
[K,ConvexVolume] =convhull(x,y,z);
BW_whole = bwmorph3(BW_whole,'majority'); 
s = regionprops3(BW_whole,'Solidity','SurfaceArea','Volume');
SurfaceArea_whole=sum(s.SurfaceArea)*size_vol*size_vol;
Volume_whole=sum(s.Volume)*size_vol*size_vol*size_vol;
Solidity_whole=Volume_whole/ConvexVolume;
skel_whole = bwskel(BW_whole);
Totallength_whole = sum(skel_whole(:))*size_vol;
end
