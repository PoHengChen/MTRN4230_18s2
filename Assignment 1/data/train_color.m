% Convolutional neural network training
% COLOR 
digitDatasetPath = fullfile('C:\Users\z5014\Documents\GitHub\Robotics-UNSW-MTRN4230\Assignment 1\data\Resized_data\color');
imds = imageDatastore(digitDatasetPath, ...
    'IncludeSubfolders',true, ...
    'LabelSource','foldernames');


layers = [ ...
    imageInputLayer([50 50 3])
    convolution2dLayer(5,20)
    maxPooling2dLayer(2,'Stride',2)
    reluLayer
    convolution2dLayer(5,20)
    maxPooling2dLayer(2,'Stride',2)
    reluLayer
    fullyConnectedLayer(7)
    softmaxLayer
    classificationLayer];

options = trainingOptions('sgdm', ...
    'MaxEpochs',80,...
    'InitialLearnRate',1e-4, ...
    'Verbose',0, ...
    'Plots','training-progress');

COLOR = trainNetwork(imds,layers,options);

% YPred = classify(net,imdsTest);
% YTest = imdsTest.Labels;
% 
% accuracy = sum(YPred == YTest)/numel(YTest)

