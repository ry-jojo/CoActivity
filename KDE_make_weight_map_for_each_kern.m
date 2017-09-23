function KDE_make_weight_map_for_each_kern(nodesize, classlist, len,density_all)
load('./data/KDE_ucf50_annotation.mat');%'ucf_annotation'
dpath ='./data/KDE_density_map/';
if ~exist(dpath,'dir')
    mkdir(dpath);
end

nVideos=50;

for d=1:6
    density = density_all(d,:);
    maxdensity = 0;
    for class =classlist
        
        nnodes = zeros(nVideos,1);
        for v=1:nVideos
            aidx =(class-1)*nVideos+v;
            nnodes(v) =(ceil(sum(ucf_annotation{aidx}.nFrames)/nodesize)*nodesize - len)/nodesize +1;
        end
        
        hidx =1;
        density_map=cell(nVideos,1);
        for v=1:nVideos
            aidx =(class-1)*nVideos+v;
            density_per_vid = zeros(1, sum(ucf_annotation{aidx}.nFrames));
            for n = 1: nnodes(v)
                n_start = n;
                n_end = n+(len/nodesize)-1;
                fpos = (n_start-1)*nodesize+1:min(n_end*nodesize,length(density_per_vid));
                %             fpos = (n-1)*nodesize+len/2;
                density_per_vid(fpos) = density_per_vid(fpos)+ density(hidx);
                hidx=hidx+1;
            end
            
            density_map{v}= density_per_vid;
            if max(density_per_vid)>maxdensity
                maxdensity=max(density_per_vid);
            end
        end
        for v=1:nVideos
            density_map{v}=  density_map{v}/ maxdensity;
        end
        dpath2 = [dpath, ucf_annotation{aidx}.label,'/',ucf_annotation{aidx}.label,'_nodesize_',num2str(nodesize), '_DENSITY_MAP_KDE_',num2str(len),'/'];
        if ~exist(dpath2,'dir')
            mkdir(dpath2)
        end
        save([dpath2,num2str(d),'.mat'],'density_map');
    end
end