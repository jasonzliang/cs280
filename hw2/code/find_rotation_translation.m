function [R t] = find_rotation_translation(E)% <------------------------------------- You write this one!
    [U S V]=svd(E);
    
    t=cell(2,1);
    t{1}=U(:,end);
    t{2}=-U(:,end);
    %... various of t
    Ro=cell(4,1);
    Ro{1}=-U*[0 1 0; -1 0 0; 0 0 1]'*V';
    Ro{2}=-U*[0 -1 0; 1 0 0; 0 0 1]'*V';
    Ro{3}=U*[0 1 0; -1 0 0; 0 0 1]'*V';
    Ro{4}=U*[0 -1 0; 1 0 0; 0 0 1]'*V';
    
    k=1;
    for i=1:4
        if det(Ro{i})>0
            R{k}=Ro{i};
            k=k+1;
        end
    end
    
end