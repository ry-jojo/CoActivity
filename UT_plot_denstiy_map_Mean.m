function dth =UT_plot_denstiy_map_Mean(density_map,nVideos, class)
% if ~exist(pdfpath,'dir')
%     mkdir(pdfpath);
% end
load('./data/UT_nVideos.mat');%nVideolist

% sum(nVideolist(1:(class-1)))
load('./data/UT_annotation.mat');
pos_frames= cell(nVideos, 1);
neg_frames = cell(nVideos,1);

dth = zeros(1,nVideos);
GMModel = cell(nVideos,1);
 lname =UT_annotation{sum(nVideolist(1:(class-1)))+1}.label;
PFpath = './data/UT_ALL_POS_Frames/';
if ~exist(PFpath,'dir')
    mkdir(PFpath);
end
PFcpath = [PFpath lname '/'];
if ~exist(PFcpath,'dir')
    mkdir(PFcpath);
end
% figure(10);
for v=1:nVideos
    frames = 1: length(density_map{v});
    idx =ones(length(density_map{v}),1);
    inith= mean(density_map{v});
    idx(density_map{v}<=inith)=2;
  
        pos_frames{v} = frames(idx==1);
        neg_frames{v} = frames(idx==2);
        dth(v) = inith;%max(density_map{v}(idx==2));
%         fprintf('init th %f mu1 %f, mu2 %f new th %f \n',inith, GMModel{v}.mu(1), GMModel{v}.mu(2), dth(v));
    
end


% for v=1:nVideos
%     frames = 1: length(density_map{v});
%     pos_frames{v} = frames(density_map{v}>dth(v));
%     neg_frames{v} =frames(density_map{v}<=dth(v));
% end
% load([rpath,'co_action_result_',num2str(class),'_nodesize_',num2str(nodesize),'_Dim_',num2str(Dim),'_org.mat']);%'pos_frames','neg_frames');

gt_start= cell(nVideos,1);
gt_end= cell(nVideos,1);
gt_cen= cell(nVideos,1);
v_start= zeros(nVideos,1);
v_end= zeros(nVideos,1);

sumco =0;
sumuni=0;
sumco2 =0;
sumuni2=0;

precisiondenorm=0;
recalldenorm =0;
precisiondenorm2=0;
recalldenorm2 =0;
tp=0;
tp2=0;
for v=1:nVideos
    aidx =sum(nVideolist(1:(class-1)))+v;
    
    v_start(v)=1;
    v_end(v)= sum(UT_annotation{aidx}.nFrames);
    
 
    gt_start{v} = UT_annotation{aidx}.gt_start;
    gt_end{v}= UT_annotation{aidx}.gt_end;
         
    tmp =zeros(v_end(v),1);
    
    gt_cen{v} = (gt_start{v}+gt_end{v})/2;
    for gg= 1: length(gt_start{v})
        tmp(gt_start{v}(gg):gt_end{v}(gg))=1;
    end
    tmp2=zeros(v_end(v),1);
    pos_frames{v}=pos_frames{v}(pos_frames{v}<v_end(v));
    tmp2(pos_frames{v})=1;
    tp = tp+sum((tmp.*tmp2));
    precisiondenorm =precisiondenorm +sum(tmp2);
    recalldenorm = recalldenorm+sum(tmp);
    
    tmp2=zeros(v_end(v),1);
    neg_frames{v}=neg_frames{v}(neg_frames{v}<v_end(v));
    tmp2(neg_frames{v})=1;
    tp2 = tp2+sum((tmp.*tmp2));
    precisiondenorm2 =precisiondenorm2 +sum(tmp2);
    recalldenorm2 = recalldenorm2+sum(tmp);
end
precision = tp/precisiondenorm;
recall= tp/recalldenorm;

precision2 = tp2/precisiondenorm2;
recall2= tp2/recalldenorm2;

fmeasure = (1+1^2)*(precision*recall)/((1^2)*precision+recall);
fmeasure2=-1;
if fmeasure>fmeasure2
    fprintf(' %.2f  %.2f  %.2f ',precision, recall,fmeasure);
else 
    fprintf(' %.2f  %.2f  %.2f ',precision2, recall2,fmeasure2);
end

% gt_cen = (gt_start+gt_end)/2;
v_cen = (v_start+v_end)/2;
h=figure;
lname =UT_annotation{sum(nVideolist(1:(class-1)))+1}.label;
title([lname ':' sprintf('%.2f',max(fmeasure,fmeasure2));]);
hold on;
errorbar((1:nVideos), v_cen,v_cen-v_start,v_end-v_cen,'k.');

save([PFcpath,'PR.mat'],'pos_frames');


for v= (1: nVideos)
    for gg= 1: length(gt_start{v})
        errorbar(v,gt_cen{v}(gg),gt_cen{v}(gg)-gt_start{v}(gg),gt_end{v}(gg)-gt_cen{v}(gg),'b.','LineWidth',2);
    end
    if fmeasure>fmeasure2
        if ~isempty(pos_frames{v})
            plot(v+0.5, pos_frames{v},'r.');
        end
    else
        if ~isempty(neg_frames{v})
            plot(v+ 0.5,neg_frames{v},'r.');
        end
    end

end

hold off;
drawnow();