function UT_make_gt()
global droot;
global dpath;
dlist =dir(droot);
isdirlist =zeros(size(dlist));
for i=1:length(dlist)
    isdirlist(i) = isdir([droot,dlist(i).name]);
end

dlist= dlist(logical(isdirlist));
dlist= dlist(3:end);
cnt =0;
nVideolist = zeros(length(dlist),1);

for c =1 : length(dlist)
    cname = dlist(c).name;
    cpath = [droot,cname,'/'];
    vlist = [dir([cpath,'*.avi'])];
    fid = fopen([cpath, cname,'_GT.txt']);
    gt = textscan(fid,'%d%d%d');
    fclose(fid);
    nVideolist(c) = length(vlist);
    for v = 1: length(vlist)
        cnt=cnt+1;
        vname =vlist(v).name;
        vpath = [cpath, vname];
        fprintf('%s \n',vname);
        vobj = VideoReader(vpath);
        nFrames =vobj.NumberOfFrames;
        video = read(vobj);
        clear vobj;
        
        gtlist =find(gt{1}==v);
        gt_start = zeros(length(gtlist),1);
        gt_end = gt_start;
        for gg =1: length(gtlist)
            gt_start(gg)=gt{2}(gtlist(gg));
            gt_end(gg)=gt{3}(gtlist(gg));    
        end
        
        
        UT_annotation{cnt}.name = vname(1:end-4);
        UT_annotation{cnt}.label = cname;
        UT_annotation{cnt}.vname = vname;
        UT_annotation{cnt}.nFrames = nFrames;
        
        UT_annotation{cnt}.gt_start= gt_start;
        UT_annotation{cnt}.gt_end= gt_end;
        save([dpath 'UT_annotation.mat'],'UT_annotation');
        save([dpath 'UT_nVideos.mat'], 'nVideolist');
    end
end