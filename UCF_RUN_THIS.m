function UCF_RUN_THIS(len)
nodesize =10;
classlist =[1:11];%:12;%11:12;%6%[1,2,3,4,7];
len= nodesize*3;
% len= nodesize*20;
load('./data/UT_nVideos.mat');%nVideolist
% sum(nVideolist(1:(class-1)))+1
load('./data/UT_annotation.mat');%'UT_annotation'
% cpath ='./data/UT_feat/';
hpath='./data/UT_hist/';
spath ='./data/UT_seg_hists/';
dpath ='./data/UT_density_map/';
npath ='./data/UT_L1NORM_seg_hists/';
% matlabpool(3);

% nCenters =[50,125,250,500,1000,2000,4000];
nCenters =4000;
% nc=;
NC =7;
cumacc = zeros(1001,1);
close all;
global Vidlist;
global tempconst;
global mname;
%  if matlabpool('size') ==0
%      parpool(4);
%  end
mname ='PR';
for tc =1%[ 2 3 4 5]
    tempconst = tc;
    fprintf('\n\n%f\n',tempconst);
    % Threshold=0.3;
    for nc=7
        for class =1:11%classlist
            close all;
            nVideos = nVideolist(class);
%             Vidlist = [1:12];
            lname =UT_annotation{sum(nVideolist(1:(class-1)))+1}.label;
            fprintf('%s ',lname);
            
%             UT_L1Normalization_SEGHISTS(nodesize, class, len,2,NC) % flag =1 ofd flag =2 org
%             UT_L1Normalization_SEGHISTS_fast(nodesize, class, len,2,NC) % flag =1 ofd flag =2 org
            load([npath,lname,'_nodesize_',num2str(nodesize), '_DATA_UT_',num2str(len),'L1Norm_org.mat']); %NDATA
            
            if strcmp(mname,'PR')
                density = UT_PR(TDATA{nc}, HOGDATA{nc},HOFDATA{nc},MBHxDATA{nc},MBHyDATA{nc},class,len,nodesize,NDATA,nCenters) ;
            else
                density= UT_AMC(TDATA{nc}, HOGDATA{nc},HOFDATA{nc},MBHxDATA{nc},MBHyDATA{nc},class,len,nodesize,NDATA,nCenters) ;
            end
            %%%%%%%%%%%%%%
            density_map= UT_make_weight_map_org(nodesize, class, len,density,nCenters);
            Threshold=UT_plot_denstiy_map(density_map,nVideos, class);
%             UT_plot_denstiy_map_org(density_map,nodesize, class, len,nCenters,Threshold);
            %%%%%%%%%%%%%%
            
            
            %             Threshold=UT_plot_denstiy_map_Mean(density_map,nVideos, class);
%             
%             UT_plot_denstiy_map_org(density_map,nodesize, class, len,nCenters,Threshold);
            %                 UT_evaluate_per_frame_org(nodesize, class, len,nCenters);
            
            %             end
            %                 UT_video_write(nodesize,class,len,nCenters,Threshold);
            
            fprintf('\n');
        end
    end
end

