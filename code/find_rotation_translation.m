function [R t] = find_rotation_translation(E)% <------------------------------------- You write this one!
    [U X V]=svd(E);
    S = U;
    Z = [1 0 0; 0 1 0; 0 0 0];
    R_90 = [0 -1 0; 1 0 0; 0 0 1];
    t_ = S*Z*R_90*S';
    R_ = (V*inv(R_90')*inv(S))';
    t = {t_ ,-t_};
    R = {R_, -R_};
end
