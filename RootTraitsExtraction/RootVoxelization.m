%Read the point cloud data
[x,y,z]=xyzread('D:\Experiment\matlab-pc\voxelization\test-rapeseed.xyz');
% pre-set size_vol as 0.006-0.002
size_vol=0.003;%either scalar or 3-length vector of cellsize along each coordinate
disk_value_whole=3;% erosion and dilation size


[BW_whole,L_whole]=rootpc2rootvox(x,y,z,size_vol,disk_value_whole);%converts the point clouds into voxels and fills the interior

%Show the filled voxels
figure(1),volumeViewer(BW_whole);%Rendering Editor - Volume Rendering- ct-mip

%Show the filled voxels
img_whole=BW_whole;
figure('Name','Whole Root');
col=[.7 .7 .8];
hiso = patch(isosurface(img_whole,0),'FaceColor',col,'EdgeColor','none');
axis equal;axis off;
lighting phong;
isonormals(img_whole,hiso);
alpha(0.4);
set(gca,'DataAspectRatio',[1 1 1])
camlight;
hold on;
