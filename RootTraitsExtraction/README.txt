3D root traits extraction pipeline

This pipeline can be used to extract global and local root traits automatically based on 3D point clouds of root systems for both tap root systems and fibrous root systems. 

Download root trait extraction pipeline.zip from (wuqiangithub/AutomatedRotatingImagingSystem).

Start MATLAB 2020a or newer and set the main path to the root folder, where RootVoxelization.m and roottraitsextraction.m are located.

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
1.Voxelization

Input: 3D root point clouds; size_vol; disk_value_whole

Key parameters: 
size_vol: either scalar or 3-length vector of cellsize along each coordinate, used in pnt2vox.m;
disk_value_whole: erosion and dilation size, used in fillvoxel.m; a closed loop is formed by erosion and dilation and then filled inside;

Open RootVoxelization.m

Change the input file (3D point clouds data) location and name in L2----[x,y,z]=xyzread('……'); 
Set the parameters of size_vol and disk_value_whole in L4-5;

Run RootVoxelization.m
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

2.Global root traits extraction

Input: 3D root point clouds, 3D root voxels;

3.Root segmentation 

Input: 3D root voxels; areaexpand_size; minareaexp_size;

Key parameters: 
areaexpand_size: the percentage of the amplified based on the area of the main root on the upper slice;
minareaexp_size: the minimun size of the amplified area;

4.Detail root traits extraction

Input: 3D root voxels of different root types;

Open roottraitsextraction.m/roottraitsextraction_maize.m 

Change the input file (3D point clouds data) location and name in L3---- [x,y,z]=xyzread('……'); 
Change the input file (3D root voxels data) location and name in L6----load("……"); 
Set the parameters of size_vol in L10, areaexpand_size in L36, minareaexp_size in L37;

Run roottraitsextraction.m/roottraitsextraction_maize.m 



