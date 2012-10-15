function runRawPixel
  rawtraindata = load('../data/train_small.mat');
  errorRate = zeros(1,7);
  trainingset = [100, 200, 500, 1000, 2000, 5000, 10000];
  
  y=load('../data/test.mat');
  images = y.test(1).images;
  ylabels = y.test(1).labels;
  testMatrix = createMatrix(images);
  for i = 1:7
    images = rawtraindata.train{i}.images;
    labels = rawtraindata.train{i}.labels;
    trainmatrix = createMatrix(images);
    model=train(labels, sparse(trainmatrix));
    [l,a]=predict(ylabels, sparse(testMatrix), model);
    errorRate(i) = 100 - a(1);
  end
  
  figure; 
  title('Raw Pixels As Features');
  ylabel('Error Rate %');
  xlabel('# of Training Examples');
  hold on;
  plot(trainingset,errorRate); 
  plot(trainingset,errorRate,'r*'); 
  for i=1:7
    text(trainingset(i),errorRate(i),num2str(errorRate(i)),'VerticalAlignment','bottom');
  end
  hold off;
  
end

function trainmatrix = createMatrix(images)
  [d1, d2, d3] = size(images);
  trainmatrix = zeros(d3, d1*d2);
  for i = 1:d3
    trainmatrix(i, :) = reshape(images(:,:,i),1,d1*d2);
  end
end

