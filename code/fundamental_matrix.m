function [F res_err] = fundamental_matrix(matches)
  image1mat = matches(:,1:2);
  image2mat = matches(:,3:4);
  
  M = mean(matches, 2);
  disp(M);
  S = std(matches, 1, 2);
  disp(S);
  %disp(image2mat);
end
