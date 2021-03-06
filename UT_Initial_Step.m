addpath(genpath('./Codes/'));

global droot;
global dpath;
global fpath;

%% Parameters
% Video path.
droot ='D:\Coactivity\AddDataset\';
% Path to store various mat files
dpath ='./../data/';
if ~exist(dpath,'dir')
    mkdir(dpath);
end
% Path of features.
fpath='F:\CoActivity\Youtubefeatures\';
stepsize=10;


%% Initializations
UT_make_gt() % new annotation
UT_feats2mat(); %feat file to mat 
UT_step_hist(stepsize); % histogram of every "stepsize(10)" frames.