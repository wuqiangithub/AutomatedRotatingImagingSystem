function [IM]=fillvoxel(BW,disk_value)
% A closed loop is formed by erosion and dilation and then filled inside in each xyz-slice 
% INPUT
% BW: 3D voxels;
% disk_value: erosion and dilation size;
[len,wid,hig]=size(BW);
for i =1:hig
im=BW(:,:,i);
se=strel('disk',disk_value);%create a flat disk structure element with a radius of disk_value
imf=imdilate(im,se);%dilation
imfs=imerode(imf,se);%erosion
BW(:,:,i)=imfill(imfs,'holes');
end

for j =1:len
im=BW(j,:,:);
se=strel('disk',disk_value);%create a flat disk structure element with a radius of disk_value
imf=imdilate(im,se);%dilation
imfs=imerode(imf,se);%erosion 
BW(j,:,:)=imfill(imfs,'holes');
end

for k =1:wid
im=BW(:,k,:);
se=strel('disk',disk_value);%create a flat disk structure element with a radius of disk_value
imf=imdilate(im,se);%dilation
imfs=imerode(imf,se);%erosion
BW(:,k,:)=imfill(imfs,'holes');
end

IM=imfill(BW,'holes');