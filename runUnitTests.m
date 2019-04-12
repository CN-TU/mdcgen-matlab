import matlab.unittest.TestSuite


if(~isdeployed)
  cd(fileparts(which('runUnitTests.m')));
end

clear

resultsConfig = run(TestSuite.fromFolder('config_build/test'));
resultsMdcGen = run(TestSuite.fromFolder('mdcgen/test'));

results = [resultsConfig, resultsMdcGen];
disp(results);


