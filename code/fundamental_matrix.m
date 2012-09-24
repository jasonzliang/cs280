function [F res_err] = fundamental_matrix(Matrix)
    
% %     T_mean=mean(Matrix,1);
% % 
% %     x1=Matrix(:,1:2);
% %     x2=Matrix(:,3:4);
% %     
% %     T_scale1=sqrt(sum(var(x1,1)));
% %     T_scale2=sqrt(sum(var(x2,1)));
% %     
% %     for i=1:2
% %         x1(:,i)=(x1(:,i)-T_mean(i))./(T_scale1);
% %         x2(:,i)=(x2(:,i)-T_mean(i))./(T_scale2);
% %     end
        
    %% Homogeneious Coordinate
    X1=[Matrix(:,1) Matrix(:,2) ones(size(Matrix(:,1)))]';
    X2=[Matrix(:,3) Matrix(:,4) ones(size(Matrix(:,3)))]';
    
    
    %% Inverse of T1 & T2
    T_mean=mean(Matrix,1);
    T_var=var(Matrix,1);
    T_std1=sqrt(sum(T_var(1:2)));
    T_std2=sqrt(sum(T_var(3:4)));
    T1=diag(1./[T_std1 T_std1])*[eye(2) -T_mean(1:2)']; %translate, then scale
    %T1=[T1; 0 0 1];
    T2=diag(1./[T_std2 T_std2])*[eye(2) -T_mean(3:4)'];
    %T2=[T2; 0 0 1];
            
    x1=T1*X1; %normalized x1 x2
    x2=T2*X2;
    x1=x1'; x2=x2';
    
   %% construct A, ??? 
    A=[x1(:,1).*x2(:,1) x1(:,2).*x2(:,1) x2(:,1) x1(:,1).*x2(:,2) x1(:,2).*x2(:,2) x2(:,2) x1(:,1) x1(:,2) ones(size(x1(:,1)))];
    
     %% equation 6&7
    [U1 S1 V1]=svd(A);
    
    %% formulate F*, ??? check if it should be col or row vectors in reconstruct
    F=V1(end,:);
    F=[F(1:3);F(4:6);F(7:9)];
    
    %% Equation 8
    [U2 S2 V2]=svd(F);
    S2(end,end)=0;
    F=U2*S2*V2';
    
    %% T1 & T2
    
    T1_=[eye(2) T_mean(1:2)']*(diag([T_std1 T_std1 1]));
    T1_=[T1_;0 0 1];
    T2_=[eye(2) T_mean(3:4)']*(diag([T_std2 T_std2 1]));
    T2_=[T2_;0 0 1];
    
    
    %% un-normalize ???check transpose ...
    F=T2_'*F*T1_;
    
    %% residual, calculation
    Square=(X1-X2).^2;
    res_err=mean(Square(:,1)+Square(:,2),1);
end
    
    
    
    

       

    
        