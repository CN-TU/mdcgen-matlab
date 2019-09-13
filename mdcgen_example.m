warning on                                                         
warning('backtrace', 'off');                                     

addpath(genpath('config_build/src/'));                             
addpath(genpath('mdcgen/src'));                                  

config.seed = 15;
config.nDatapoints = 2000;                                         
config.nDimensions = 2;                                            
config.nClusters = 3;                                              
config.nOutliers = 10;                                              
config.distribution = [6 1 2];                                   

[ result ] = mdcgen( config );                                   

scatter(result.dataPoints(:,1),result.dataPoints(:,2),5,result.label,'fill');  
axis([0 1 0 1])           