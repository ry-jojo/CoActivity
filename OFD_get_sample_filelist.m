fid = fopen('./filelist.txt','w');

fpath = 'D:/Share_with_linux/DenseTrajectory_OFD/sample_feature/';
dirlist =dir(fpath);
dirlist = dirlist(3:end);
perm = randperm(length(dirlist));
for idx=1:length(dirlist)
    i = perm(idx);
    s =[fpath,dirlist(i).name];
    fprintf(fid,'%s\n',s);
end
fclose(fid);