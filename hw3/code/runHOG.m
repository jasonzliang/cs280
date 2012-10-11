function runHOG
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
  title('PHOGs As Features');
  ylabel('Error Rate %');
  xlabel('# of Training Examples');
  hold on;
  plot(trainingset,errorRate); 
  plot(trainingset,errorRate,'r*'); 
  hold off;
  
end

function trainmatrix = createMatrix(images)
  [d1, d2, d3] = size(images);
  for i = 1:d3
    gmat = createGradientMatrix(images(:,:,i));
    cellfeatures1 = PHOG(gmat, 4);
    cellfeatures2 = PHOG(gmat, 7);
    features = [cellfeatures1, cellfeatures2];
    if i == 1
      trainmatrix = zeros(d3, size(features, 2));
    end
    trainmatrix(i,:) = features;
  end
end

function features = PHOG(gmat, c)
  [d1, d2] = size(gmat);
  features = [];
  for i = 1:c:d1
    for j = 1:c:d2
      if (i <= d1-c+1) && (j <= d2-c+1)
        submatrix = gmat(i:i+c-1, j:j+c-1);
      else
        submatrix = gmat(i:d1, j:d2);
      end
      histogram = countHistograms(submatrix, 1);
      features = [features histogram];
    end
  end
end

function histogram = countHistograms(submatrix, normalize)
  [d1, d2] = size(submatrix);
  histogram = zeros(1,9);
  for i = 1:d1
    for j = 1:d2
      index = submatrix(i,j) + 1;
      histogram(index) = histogram(index) + 1;
    end
  end
  if normalize == 1
    histogram = histogram/norm(histogram);
  end
end

function gmat = createGradientMatrix(image)
  [d1, d2] = size(image);
  gmat = zeros(d1, d2);
  for i = 2:d1-1
    for j = 2:d2-1
      ygrad = cast(image(i-1,j)-image(i+1,j), 'double');
      xgrad = cast(image(i,j-1)-image(i,j+1), 'double');
      if xgrad == 0
        angle = 90;
      else
        angle = atand(ygrad/xgrad);
      end
      gmat(i,j) = mod(round(angle/40), 9);
    end
  end
end
