function [R t] = find_rotation_translation(E)% <------------------------------------- You write this one!
    [U S V]=svd(E);
    
    t=cell(2,1);
    t{1}=U(end,:);
    t{2}=-U(end,:);
    %... various of t
    R=cell(4,1);
    R(1)=U*[0 1 0; -1 0 0; 0 0 1]'*V';
    R(2)=U*[0 -1 0; 1 0 0; 0 0 1]'*V';
    R(3)=-U*[0 1 0; -1 0 0; 0 0 1]'*V';
    R(4)=-U*[0 -1 0; 1 0 0; 0 0 1]'*V';
    
end