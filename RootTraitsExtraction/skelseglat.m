function [Txyz,Tcol,labelnum,T_deleteXYZ,T_deletecol]=skelseglat(skel_lat)
% segmentation of lateral roots

% Input
% skel_lat: lateral roots skeleton

% Output
% Txyz: coordinate of lateral root segments
% Tcol: color of lateral root segments
% labelnum,: number of lateral root segments
% T_deleteXYZ: coordinate of lateral root segments without short segments
% T_deletecol: color of lateral root segments without short segments


% BP = branchpoints3(skel_lat);

skel_lat=bwmorph3(skel_lat,'clean');
BP =bwmorph3(skel_lat,'branchpoints');
lateralrootsegment=skel_lat-BP;
lateralrootsegment=bwmorph3(lateralrootsegment,'clean');
skel_label=bwlabeln(lateralrootsegment);

xsize = size(skel_lat,1);ysize = size(skel_lat,2);zsize = size(skel_lat,3);
cor = find(skel_label);
[a,b,value] = find(skel_label);
[cor1,cor2,cor3] = ind2sub([xsize ysize zsize],cor); % find nonzero component

colorvalue=[];
for i =1:7:max(value)
    colorvalue(i,1)=i; colorvalue(i,2:4)=[0 0.4470 0.7410];
    colorvalue(i+1,1)=i+1; colorvalue(i+1,2:4)=[0.8500 0.3250 0.0980];
    colorvalue(i+2,1)=i+2; colorvalue(i+2,2:4)=[0.9290 0.6940 0.1250];
    colorvalue(i+3,1)=i+3; colorvalue(i+3,2:4)=[0.4940 0.1840 0.5560];
    colorvalue(i+4,1)=i+4; colorvalue(i+4,2:4)=[0.4660 0.6740 0.1880];
    colorvalue(i+5,1)=i+5; colorvalue(i+5,2:4)=[0.3010 0.7450 0.9330];
    colorvalue(i+6,1)=i+6; colorvalue(i+6,2:4)=[0.6350 0.0780 0.1840];
end
colorvalue=colorvalue(1:max(value),:);

Txyz = table(value,cor1,cor2,cor3,'VariableNames',{'label','X','Y','Z'});

Tvalue = table(value,'VariableNames',{'label'});
Tcolvalue = table(colorvalue(:,1),colorvalue(:,2),colorvalue(:,3),colorvalue(:,4),...
    'VariableNames',{'label','R','G','B'});
T_COL = join(Tvalue,Tcolvalue);
Tcol=[T_COL.R,T_COL.G,T_COL.B];
label_number=tabulate(T_COL.label);


T_deleteXYZ=Txyz;
T_deleteCOL=T_COL;
labelnum=[];j=1;
for i =1:max(value)
    if label_number(i,2)<15 
        T_deleteXYZ(T_deleteXYZ.label==label_number(i,1),:)=[];
        T_deleteCOL(T_deleteCOL.label==label_number(i,1),:)=[];
    else
        labelnum(j)=label_number(i,1);
        j=j+1;
    end
end
T_deletecol=[T_deleteCOL.R,T_deleteCOL.G,T_deleteCOL.B];

