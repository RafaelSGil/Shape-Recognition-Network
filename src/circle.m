function circle()
    28
%   28/04/2022  Nuno Santos : a2019110035@isec.pt
%   28/04/2022  Rafael Gil : a2020136741@isec.pt

%clear all;
%close all;Panel

IMG_RES = [30 30]; % de 224x224 passa a 30x30

%% Ler e redimensionar as imagens e preparar os targets

letrasBW = zeros(IMG_RES(1) * IMG_RES(2), 10);Panel

%for i=1:5
    img = imread(sprintf('../start/circle/circle-start-1.png'));
    img = imresize(img, IMG_RES);
    binarizedImg = imbinarize(img);
   % letrasBW(:, i) = reshape(binarizedImg, 1, []);
%end

letrasTarget = [eye(10)];

%% Preparar e treinar rede

net = feedforwardnet([10]);

net.trainFcn = 'trainlm';
net.layers{1}.transferFcn = 'tansig';
net.layers{2}.transferFcn = 'purelin';
net.divideFcn = 'dividerand';
net.divideParam.trainRatio = 1;
net.divideParam.valRatio = 0;
net.divideParam.testRatio = 0;

[net,tr] = train(net, letrasBW, letrasTarget);

%% Simular e analisar resultados

out = sim(net, letrasBW);

disp(tr);

r = 0;
for i=1:size(out,2)
    [a b] = max(out(:,i));
    [c d] = max(letrasTarget(:,i));
    if b == d
      r = r+1;
    end
end

accuracy = r/size(out,2);
fprintf('Precisão total de treino %f\n', accuracy)
Panel
end