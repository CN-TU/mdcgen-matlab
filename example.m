warning on                                                         
warning('backtrace', 'off');                                     

addpath(genpath('config_build/src/'));                             
addpath(genpath('mdcgen/src'));                                  

parameters.nDatapoints = 2000;                                     
parameters.nDimensions = 2;                                        
parameters.nClusters = 4;                                          
parameters.nOutliers = 50;     
parameters.pointsPerCluster = [700 700 300 300];
parameters.distribution = [3 1 2 2];                               

config = createMDCGenConfiguration(parameters);                    
[ result ] = mdcgen( config );                                   

scatter(result.dataPoints(:,1),result.dataPoints(:,2),10,result.label,'fill');  
axis([0 1 0 1])  

x_aux1=result.dataPoints(result.label==1,:);
x_aux3=result.dataPoints(result.label==3,:);
x_aux2=result.dataPoints(result.label==2,:);
x_aux4=result.dataPoints(result.label==4,:);
x_aux0=result.dataPoints(result.label==0,:);

X_train=[x_aux1(1:500,:);x_aux2(1:500,:)];
l1=length(x_aux1);
l2=length(x_aux2);
y_train=[ones(500,1);2*ones(500,1)];
X_test=[x_aux1(501:l1,:);x_aux2(501:l2,:);x_aux3;x_aux4;x_aux0];
l3=length(x_aux3);
l4=length(x_aux4);
y_test=[ones(l1-500,1);2*ones(l2-500,1);3*ones(l3,1);4*ones(l4,1);zeros(50,1)];

a=randperm(length(X_train));
b=randperm(length(X_test));
X_train=X_train(a,:);
y_train=y_train(a);
X_test=X_test(b,:);
y_test=y_test(b);