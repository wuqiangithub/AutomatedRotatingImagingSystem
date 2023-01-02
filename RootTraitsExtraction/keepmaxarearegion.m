function bw=keepmaxarearegion(orgbw)
imlabel=bwlabel(orgbw);
stats=regionprops(imlabel,'Area');
[b,index]=sort([stats.Area],'descend');
if length(stats)<1
    bw=imlabel;
else
    bw=ismember(imlabel,index(1));
end