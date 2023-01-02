% Segmentation of different root types
function [BW_main,BW_lat]=rootseg(BW_whole,areaexpand_size,minareaexp_size)
% Input
% BW_whole: Root voxels
% areaexpand_size: the percentage of the amplified based on the area of the main root on the upper slice;
% minareaexp_size: the minimun size of the amplified area;

% Output
% BW_main: main root voxels
% BW_lat: lateral root voxels

[~,~,h1]=size(BW_whole);
BW_main=[];BW_new=[];BW_lat=[];
BW_main(:,:,h1)=BW_whole(:,:,h1);

for i = h1-1:-1:1
    BW_limitedregion=[];BW_imdilate=[];BW_imcomplement=[];
    size_exp=round(areaexpand_size*bwarea(BW_main(:,:,i+1)));
    
    if size_exp<minareaexp_size
        size_exp=minareaexp_size;
    end
    SE0=strel('disk',size_exp);
    BW_imdilate=imdilate(BW_main(:,:,i+1),SE0);
    
    BW_imcomplement=imcomplement(BW_imdilate);
    BW_limitedregion= BW_whole(:,:,i)-BW_imcomplement;
    BW_limitedregion(BW_limitedregion==-1)=0;
       
    
    BW_new(:,:,i)=keepmaxarearegion(BW_limitedregion);
    
    if bwarea(BW_new(:,:,i))>500 
        size1=5;
        size2=4;
        size3=6;
        SE1=strel('disk',size1);
        BW1=imerode(BW_new(:,:,i),SE1);
        SE2=strel('disk',size2);
        BW2=imerode(BW1,SE2);       
        SE3=strel('disk',size3);
        BW3=imdilate(BW2,SE2);
        BW4=imdilate(BW3,SE3);

    elseif bwarea(BW_new(:,:,i))>200 & bwarea(BW_new(:,:,i))<500  
        size1=4;
        size2=2;
        size3=5;
        SE1=strel('disk',size1);
        BW1=imerode(BW_new(:,:,i),SE1);
        SE2=strel('disk',size2);
        BW2=imerode(BW1,SE2);
        SE3=strel('disk',size3);
        BW3=imdilate(BW2,SE2);
        BW4=imdilate(BW3,SE3);

    elseif bwarea(BW_new(:,:,i))>100 & bwarea(BW_new(:,:,i))<200  
        size1=3;
        size2=1;
        size3=4;
        SE1=strel('disk',size1);
        BW1=imerode(BW_new(:,:,i),SE1);
        SE2=strel('disk',size2);
        BW2=imerode(BW1,SE2);       
        BW3=imdilate(BW2,SE2);
        SE3=strel('disk',size3);
        BW34=imdilate(BW3,SE3);
        BW4=keepmaxarearegion(BW34);

    elseif bwarea(BW_new(:,:,i))<100 & bwarea(BW_new(:,:,i))>50  
        size1=2;
        size2=3;
        SE1=strel('disk',size1);
        SE2=strel('disk',size2);
        BW1=imerode(BW_new(:,:,i),SE1);
        BW3=imdilate(BW1,SE2);
        BW4=keepmaxarearegion(BW3);

    elseif bwarea(BW_new(:,:,i))<50
        size1=1;
        size2=3;
        SE1=strel('disk',size1);
        SE2=strel('disk',size2);
        BW1=imerode(BW_new(:,:,i),SE1);
        BW2=imdilate(BW1,SE2);
        BW4=keepmaxarearegion(BW2);
    end
  
        if bwarea(BW4)<2
            BW4=BW_main(:,:,i+1);
        end
    
    BW_main(:,:,i)=BW4;
    BW_lat(:,:,i)=BW_whole(:,:,i)-BW4;
    
end
end