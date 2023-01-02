function [BW_whole,L_whole]=rootpc2rootvox(x,y,z,size_vol,disk_value_whole)
% 3D points to 3D voxels%%%%%%%%%%%%
% INPUT
% x,y,z: the coordinates of the point clouds
% size_vol：either scalar or 3-length vector of cellsize along each coordinate
% disk_value_whole：erosion and dilation size,Rapeseed 3，Maize 1；

Z_whole =[x,y,z];
[V_whole] = pnt2vox(Z_whole,size_vol);
L_whole = logical(V_whole);%conversion to logical matrix
BW_whole=L_whole;
% a closed loop is formed by erosion and dilation and then filled inside in each xyz-slice 
BW_whole=fillvoxel(BW_whole,disk_value_whole);

end
