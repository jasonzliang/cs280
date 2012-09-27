function [F res_err] = fundamental_matrix(Matrix)
    %% Homogeneious Coordinate
    X1=[Matrix(:,1) Matrix(:,2) ones(size(Matrix(:,1)))]';
    X2=[Matrix(:,3) Matrix(:,4) ones(size(Matrix(:,3)))]';
    
    
    %%  T1 & T2
    T_mean=mean(Matrix,1);
    T_var=var(Matrix,1);
    T_scale1=sqrt(2/sum(T_var(1:2)));
    T_scale2=sqrt(2/sum(T_var(3:4)));
    T1=T_scale1.*[eye(2) -T_mean(1:2)']; %translate, then scale
    T1=[T1; 0 0 1];
    T2=T_scale2.*[eye(2) -T_mean(3:4)'];
    T2=[T2; 0 0 1];
            
    x1=T1*X1; %normalized x1 x2
    x2=T2*X2;
    x1=x1'; x2=x2';
    
   %% construct A, ??? 
    A=[x1(:,1).*x2(:,1) x1(:,2).*x2(:,1) x2(:,1) x1(:,1).*x2(:,2) x1(:,2).*x2(:,2) x2(:,2) x1(:,1) x1(:,2) ones(size(x1(:,1)))];
    
     %% equation 6&7
    [U1 S1 V1]=svd(A,0);
    
    %% formulate F*, ??? check if it should be col or row vectors in reconstruct
    F=V1(:,end);
    F=[F(1:3)';F(4:6)';F(7:9)'];
    
    %% Equation 8
    [U2 S2 V2]=svd(F);
    S2(end,end)=0;
    F=U2*S2*V2';
    
    
    %% un-normalize ???check transpose ...
    F=T2'*F*T1;
    
    %% residual, calculation
    ELine=X2'*F;
    res_err=sum((sum(ELine.*X1',2)./sqrt(sum(ELine(:,1:2).^2,2))).^2);
end
    
    
    
    

       

    
        