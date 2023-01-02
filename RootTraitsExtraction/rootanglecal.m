% Root angle calculation
function [minlabel2middist,startpoints,endpoints]=rootanglecal(labelnum,T_deleteXYZ,midlinepoints)
% Input
% labelnum: number of lateral roots segments
% T_deleteXYZ：lateral roots segments
% midlinepoints: main root skeleton points

% Output
% minlabel2middist: root segments angle
% startpoints,endpoints: start and end points of root angle calculation

minlabel2middist=[0,0,0,0];
[midlinepointnum,~]=size(midlinepoints);k=0;
for i=1:length(labelnum)
    L=[];LX=[];LY=[];LZ=[];
    Label_COR=[];pointsdist=[];minpointsdist=[];
    L=find(T_deleteXYZ.label==labelnum(i));
    LX=T_deleteXYZ.X(L);LY=T_deleteXYZ.Y(L);LZ=T_deleteXYZ.Z(L);
    Label_COR=[LX,LY,LZ];
    Label_COR=sortrows (Label_COR,3,'descend');
    [labelpointnum,~]=size(Label_COR);
    
    for m=1:labelpointnum 
        for n=1: midlinepointnum 
            pointsdist (n)=sqrt(((Label_COR(m,1)-midlinepoints(n,1))^2 + (Label_COR(m,2)-midlinepoints(n,2))^2 + (Label_COR(m,3)-midlinepoints(n,3))^2));
        end
        minpointsdist(m)=min(pointsdist);
        Label_COR(m,4)= minpointsdist(m);
    end
    
    if min(minpointsdist)<=28.2 && min(LZ)>170
        k=k+1;
        minlabel2middist(k,1)=min(minpointsdist);
        posi=find(Label_COR(:,4)==min(minpointsdist));
        minlabel2middist(k,2:4)=Label_COR(posi(1),1:3);
        
        labelpointinternaldist=[];
        for m=1:labelpointnum
            labelpointinternaldist(m,1)=sqrt(((Label_COR(m,1)-minlabel2middist(k,2))^2 + (Label_COR(m,2)-minlabel2middist(k,3))^2 + (Label_COR(m,3)-minlabel2middist(k,4))^2));
            labelpointinternaldist(m,2:4)=Label_COR(m,1:3);
        end
        labelpointinternaldist=sortrows (labelpointinternaldist,1);
        
        O=labelpointinternaldist(1,2:4);
        A=labelpointinternaldist(15,2:4);
        B=[labelpointinternaldist(1,2),labelpointinternaldist(1,3),labelpointinternaldist(15,4)];
        a=[A(1)-O(1),A(2)-O(2),A(3)-O(3)];b=[B(1)-O(1),B(2)-O(2),B(3)-O(3)];
        CosTheta = max(min(dot(a,b)/(norm(a)*norm(b)),1),-1);
        ThetaInDegrees = real(acosd(CosTheta));
        minlabel2middist(k,5)=ThetaInDegrees;        
        endpoints(k,:)=A;
        startpoints(k,:)=O;  
    end
end