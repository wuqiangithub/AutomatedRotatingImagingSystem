%% Input
%  Read 3D point cloud data
[x,y,z]=xyzread('D:\Experiment\matlab-pc\RootTraitsExtraction\test-rapeseed.xyz');

% Load the voxelized data
load("testdata.mat");
BW_whole=BW_new_whole;

% either scalar or 3-length vector of cellsize along each coordinate
size_vol=0.004; 
%% global root traits extraction

[height,width,ConvexVolume,SurfaceArea_whole,Volume_whole,Solidity_whole,Totallength_whole,skel_whole]=globaltraitscal(x,y,z,BW_whole,size_vol);

% Visualization
img_whole=BW_whole;
figure('Name','Whole Root');
hiso = patch(isosurface(img_whole,0),'FaceColor','yellow','EdgeColor','none');
axis equal;axis off;
lighting phong;
isonormals(img_whole,hiso);
alpha(0.6);
set(gca,'DataAspectRatio',[1 1 1])
camlight;
hold on;
% Drawing skeleton
w=size(skel_whole,1);
l=size(skel_whole,2);
h=size(skel_whole,3);
[x,y,z]=ind2sub([w,l,h],find(skel_whole(:)));
plot3(y,x,z,'square','Markersize',2,'MarkerFaceColor','b','Color','b');
set(gcf,'Color','white');
view(140,80);

%% Root segmentation
areaexpand_size=0.1;% the percentage of the amplified based on the area of the main root on the upper slice;
minareaexp_size=4;% the minimun size of the amplified area;
[BW_main,BW_lat]=rootseg(BW_whole,areaexpand_size,minareaexp_size);
%  img_lat=BW_lat;
% Visualization of root segmentation
[~,~,h1]=size(BW_main);
for i = h1-1:-1:1
    img_lat(:,:,i)=BW_whole(:,:,i)-BW_main(:,:,i);
end
img_lat(find(img_lat<0))=0;


img_main=BW_main;
figure('Name','Primary and Lateral root voxel');
col=[.7 .7 .8];
hiso = patch(isosurface(img_lat,0),'FaceColor',col,'EdgeColor','none');
% hiso2 = patch(isocaps(img_lat,0),'FaceColor',col,'EdgeColor','none');
axis equal;axis off;
lighting phong;
isonormals(img_lat,hiso);
alpha(0.5);
hiso2 = patch(isosurface(img_main,0),'FaceColor','blue','EdgeColor','none');
isonormals(img_main,hiso2);
alpha(0.6);
set(gca,'DataAspectRatio',[1 1 1])
camlight;
hold on;

%% Detail root traits extraction

% Extract the skeleton of the main root and lateral roots
% Lateral roots
[skel_lat,Totallength_lat,SurfaceArea_lat,Volume_lat,avgDiam_lat]=detailtraitscal(img_lat,size_vol);
% Main root
[midpoint_x,midpoint_y,midpoint_z,mainrootlength,SurfaceArea_main,Volume_main,avgDiam_main]=mainroottraits(BW_main,size_vol);
% Main root skeleton coordinates
midlinepoints=[midpoint_x,midpoint_y,midpoint_z];

% Draw the skeleton of the lateral root segments and the main root
[Txyz,Tcol,labelnum,T_deleteXYZ,T_deletecol]=skelseglat(skel_lat);
figure('Name','Lateral Root color');
col=[.7 .7 .8];
hiso = patch(isosurface(img_lat,0),'FaceColor',col,'EdgeColor','none');% lateral roots voxels
hiso2 = patch(isocaps(img_lat,0),'FaceColor',col,'EdgeColor','none');
axis equal;axis off;
lighting phong;
isonormals(img_lat,hiso);
alpha(0.3);
set(gca,'DataAspectRatio',[1 1 1]);
hold on;
scatter3(Txyz.Y,Txyz.X,Txyz.Z,20,Tcol,'filled');% lateral roots skeleton
hold on;
hiso2 = patch(isosurface(img_main,0),'FaceColor','blue','EdgeColor','none');% main root voxels
axis equal;axis off;
lighting phong;
isonormals(img_main,hiso2);
alpha(0.4);
set(gca,'DataAspectRatio',[1 1 1]);
camlight;
hold on;
scatter3(midpoint_x,midpoint_y,midpoint_z,15,'black','filled');% main root skeleton

% Drawing the root segments skeleton with voxels greater than 10
figure('Name','Lateral Root delete short label');
col=[.7 .7 .8];
hiso = patch(isosurface(img_lat,0),'FaceColor',col,'EdgeColor','none');
axis equal;axis off;
lighting phong;
isonormals(img_lat,hiso);
alpha(0.3);
hiso2 = patch(isosurface(img_main,0),'FaceColor','blue','EdgeColor','none');
axis equal;axis off;
lighting phong;
isonormals(img_main,hiso2);
alpha(0.4);
set(gca,'DataAspectRatio',[1 1 1]);
camlight;
hold on;
scatter3(T_deleteXYZ.Y,T_deleteXYZ.X,T_deleteXYZ.Z,15,T_deletecol,'filled');
hold on;
scatter3(midpoint_x,midpoint_y,midpoint_z,15,'black','filled');

% Root Angle calculation
[minlabel2middist,startpoints,endpoints]=rootanglecal(labelnum,T_deleteXYZ,midlinepoints);

% Drawing root angles
figure('Name','Lateral Root angle');
col=[.7 .7 .8];
hiso = patch(isosurface(img_lat,0),'FaceColor',col,'EdgeColor','none');% lateral roots voxels
axis equal;axis off;
lighting phong;
isonormals(img_lat,hiso);
alpha(0.3);
hiso2 = patch(isosurface(img_main,0),'FaceColor','blue','EdgeColor','none');% main root voxels
axis equal;axis off;
lighting phong;
isonormals(img_main,hiso2);
alpha(0.4);
set(gca,'DataAspectRatio',[1 1 1]);
camlight;
hold on;

%main root skeleton
scatter3(midpoint_x,midpoint_y,midpoint_z,15,'black','filled');
hold on;
% start points
scatter3(minlabel2middist(:,3),minlabel2middist(:,2),minlabel2middist(:,4),80,'r','filled');
hold on;
%end points
scatter3(endpoints(:,2),endpoints(:,1),endpoints(:,3),80,'b','filled');
hold on;
[k,j]=size(endpoints);
for i=1:k
    plot3([startpoints(i,2),endpoints(i,2)],[startpoints(i,1),endpoints(i,1)],[startpoints(i,3),endpoints(i,3)],'g','LineWidth',8);
    hold on;
end

DATAFRAME_G=[height,width,ConvexVolume,SurfaceArea_whole,Volume_whole,Solidity_whole,Totallength_whole];
DATAFRAME_L=[SurfaceArea_lat,Volume_lat,Totallength_lat,avgDiam_lat,mainrootlength,SurfaceArea_main,Volume_main,avgDiam_main];
xlswrite('D:\Experiment\matlab-pc\RootTraitsExtraction\Globalroottraits_rapeseed.xlsx',DATAFRAME_G,'Sheet1');
xlswrite('D:\Experiment\matlab-pc\RootTraitsExtraction\Localroottraits_rapeseed.xlsx',DATAFRAME_L,'Sheet1');
xlswrite('D:\Experiment\matlab-pc\RootTraitsExtraction\Rootangle_rapeseed.xlsx',minlabel2middist(:,2:5),'Sheet1');



