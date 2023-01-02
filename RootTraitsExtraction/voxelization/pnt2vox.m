function [XI,YI,ZI,V] = pnt2vox(XYZ,cellsiz)
% PNT2VOX - Point cloud to 3-d voxel array
%
% V = PNT2VOX(XYZ,CELLSIZ)
% [X,Y,Z,V] = PNT2VOX(XYZ,CELLSIZ)
%
% Inputs:
%   XYZ - NP-by-3 array with point cloud coordinates
%   CELLSIZ - either scalar or 3-length vector of cellsize along each
%   coordinate.
% 
% Outputs: 

if length(cellsiz) == 1, cellsiz = cellsiz([1 1 1]); end

lims = minmax(XYZ');
[XI,YI,ZI] = meshgrid(lims(1,1):cellsiz(1):lims(1,2),...
                      lims(2,1):cellsiz(2):lims(2,2),...
                      lims(3,1):cellsiz(3):lims(3,2));
% translate coordinates to raster indices
zsiz = size(ZI);
i = round((XYZ(:,1)-lims(1,1))/cellsiz(1)+1);
j = round((XYZ(:,2)-lims(2,1))/cellsiz(2)+1);  
k = round((XYZ(:,3)-lims(3,1))/cellsiz(3)+1);  
i(i > zsiz(1)) = zsiz(1); i(i < 1) = 1;
j(j > zsiz(2)) = zsiz(2); j(j < 1) = 1;  
k(k > zsiz(3)) = zsiz(3); k(k < 1) = 1;  

[ijk,l] = unique(sortrows([i,j,k]),'rows');
n = sub2ind(zsiz,ijk(:,1),ijk(:,2),ijk(:,3));
V = zeros(zsiz);
V(n) = diff([0;l]);
if nargout == 1,
  XI = V;
end
    