function [BW_main,BW_lat]=rootseg(BW_whole,areaexpand_size,minareaexp_size)

[~,~,h1]=size(BW_whole);
BW_main=[];BW_new=[];BW_lat=[];
BW_main(:,:,h1)=BW_whole(:,:,h1);

for i = h1-1:-1:1
    BW_limitedregion=[];BW_imdilate=[];BW_imcomplement=[];
    
    SE0=strel('disk',1);
    BW_imdilate=imdilate(BW_main(:,:,i+1),SE0);
    BW_imcomplement=imcomplement(BW_imdilate);
    BW_limitedregion= BW_whole(:,:,i)-BW_imcomplement;
    BW_limitedregion(BW_limitedregion==-1)=0;
    BW_new(:,:,i)=BW_limitedregion;
    
    if bwarea(BW_new(:,:,i))>500 
        size1=6;
        size2=4;
        size3=7;
        SE1=strel('disk',size1);
        BW1=imerode(BW_new(:,:,i),SE1);
        SE2=strel('disk',size2);
        BW2=imerode(BW1,SE2);
        
        SE3=strel('disk',size3);
        BW3=imdilate(BW2,SE2);
        BW4=imdilate(BW3,SE3);

    elseif bwarea(BW_new(:,:,i))>300 & bwarea(BW_new(:,:,i))<500  
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
        
    elseif bwarea(BW_new(:,:,i))>200 & bwarea(BW_new(:,:,i))<300  
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

    elseif bwarea(BW_new(:,:,i))<200 & bwarea(BW_new(:,:,i))>100  
        size1=2;
        SE1=strel('disk',size1);
        BW1=imerode(BW_new(:,:,i),SE1);
        BW3=imdilate(BW1,SE1);
        BW4=keepmaxarearegion(BW3);

    elseif bwarea(BW_new(:,:,i))<100
        size1=1;
        SE1=strel('disk',size1);
        BW1=imerode(BW_new(:,:,i),SE1);
        BW2=imdilate(BW1,SE1);
        BW4=keepmaxarearegion(BW2);
        if bwarea(BW4)<10
            BW4=BW_main(:,:,i+1);
        end
    end
   
        if bwarea(BW4)<bwarea(BW_main(:,:,i+1))/3 | bwarea(BW4)>3*bwarea(BW_main(:,:,h1))
            BW4=BW_main(:,:,i)-BW_main(:,:,i);
        end
  
    BW_main(:,:,i)=BW4;   
    BW_lat(:,:,i)=BW_whole(:,:,i)-BW4;

end
end