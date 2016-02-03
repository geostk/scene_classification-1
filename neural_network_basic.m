%   data - input data.
%   index - target data.

x = data;
t = index;

% Create a Pattern Recognition Network
hiddenLayerSize = 81;
net = patternnet(hiddenLayerSize);


% Setup Division of Data for Training, Validation, Testing
net.divideParam.trainRatio = 75/100;
net.divideParam.valRatio = 10/100;
net.divideParam.testRatio = 15/100;


% Train the Network
[net,tr] = train(net,x,t);

% Test the Network
y = net(x);
e = gsubtract(t,y);
tind = vec2ind(t);
yind = vec2ind(y);
percentErrors = sum(tind ~= yind)/numel(tind);
performance = perform(net,t,y)

% View the Network
view(net)


%figure, plotconfusion(t,y)

