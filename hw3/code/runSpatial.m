function runSpatial
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
  title('Spatial Pyramids As Features');
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
    cellfeatures1 = spatialPyramid(images(:,:,i), 4);
    cellfeatures2 = spatialPyramid(images(:,:,i), 7);
    features = [int16(reshape(images(:,:,i),1,d1*d2)), cellfeatures1, cellfeatures2];
    if i == 1
      trainmatrix = zeros(d3, size(features, 2));
    end
    trainmatrix(i,:) = features;
  end
end

function cellfeatures = spatialPyramid(image, c)
  [d1, d2] = size(image);
  cellfeatures = [];
  for i = 1:c:d1
    for j = 1:c:d2
      if (i <= d1-c+1) && (j <= d2-c+1)
        submatrix = image(i:i+c-1, j:j+c-1);
      else
        submatrix = image(i:d1, j:d2);
      end
      cellfeatures = [cellfeatures sum(submatrix(:))];
    end
  end
  %~ 
  %~ for i = 1:c:d1
    %~ for j = floor(c/2):c:d2
      %~ if (i <= d1-c+1) && (j <= d2-c+1)
        %~ submatrix = image(i:i+c-1, j:j+c-1);
      %~ else
        %~ submatrix = image(i:d1, j:d2);
      %~ end
      %~ cellfeatures = [cellfeatures sum(submatrix(:))];
    %~ end
  %~ end
  %~ 
  %~ for i = floor(c/2):c:d1
    %~ for j = 1:c:d2
      %~ if (i <= d1-c+1) && (j <= d2-c+1)
        %~ submatrix = image(i:i+c-1, j:j+c-1);
      %~ else
        %~ submatrix = image(i:d1, j:d2);
      %~ end
      %~ cellfeatures = [cellfeatures sum(submatrix(:))];
    %~ end
  %~ end
  
  for i = floor(c/2):c:d1
    for j = floor(c/2):c:d2
      if (i <= d1-c+1) && (j <= d2-c+1)
        submatrix = image(i:i+c-1, j:j+c-1);
      else
        submatrix = image(i:d1, j:d2);
      end
      cellfeatures = [cellfeatures sum(submatrix(:))];
    end
  end
end

