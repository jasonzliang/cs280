function [F res_err] = fundamental_matrix(Matrix)
          
    %% Homogeneious Coordinate
    X1=[Matrix(:,1) Matrix(:,2) ones(size(Matrix(:,1)))]';
    X2=[Matrix(:,3) Matrix(:,4) ones(size(Matrix(:,3)))]';
    
    %% Inverse of T1 & T2
    T_mean=mean(Matrix,1);
    T_var=var(Matrix,1);
    T_std1=sqrt(sum(T_var(1:2)));
    T_std2=sqrt(sum(T_var(3:4)));
    T1=diag(1./[T_std1 T_std1])*[eye(2) -T_mean(1:2)']; %translate, then scale
    
    T2=diag(1./[T_std2 T_std2])*[eye(2) -T_mean(3:4)'];
            
    x1=T1*X1; %normalized x1 x2
    x2=T2*X2;
    x1=x1';
    x2=x2';
    
    %% construct A, ??? 
    A=[x1(:,1).*x2(:,1) x1(:,2).*x2(:,1) x2(:,1) x1(:,1).*x2(:,2) x1(:,2).*x2(:,2) x2(:,2) x1(:,1) x1(:,2) ones(size(x1(:,1)))];
    
    
    %% equation 6&7
    [U1 S1 V1]=svd(A);
    
    sumS1 = sum(S1, 1);
    
    minvalue = Inf;
    minindex = -1;

    for i = 1:size(sumS1, 2)
        if (sumS1(i) < minvalue) && (sumS1(i) ~= 0)
            minvalue = sumS1(i);
            minindex = i;
        end
    end
            
    %% formulate F*, ??? check if it should be col or row vectors in reconstruct
    F=V1(:,minindex)';
    F=[F(1:3);F(4:6);F(7:9)];
    
    %% Equation 8
    [U2 S2 V2]=svd(F);
    S2(end,end)=0;
    F=U2*S2*V2';
    
    %% T1 & T2    
    T1_=[T1; 0 0 1];
    T2_=[T2; 0 0 1];
    %% un-normalize ???check transpose ...
    F=T2_'*F*T1_;
    %~ p1 = [2.1107700e+002,  1.1559400e+002, 1];
    %~ p2 = [2.2890350e+002,  1.1349550e+002, 1]';
    %~ p1 * F * p2 
    %~ F2 = estimateFundamentalMatrix(Matrix(:,1:2), Matrix(:,3:4), 'Method', 'Norm8Point');
    %~ p1 * F * p2 
    
    %% residual, calculation
    lines = zeros(size(Matrix,1), 3);
    for i = 1:size(Matrix,1)
        lines(i,:) = F*[Matrix(i,1), Matrix(i,2), 1]';
    end
    
    totaldistsquared = 0;
    for i = 1:size(lines, 1)
        a = lines(i,1);
        b = lines(i,2);
        c = lines(i,3);
        p1 = [c/a, 0]';
        p2 = [0, c/b]';
        p = Matrix(i,1:2)';
        dist = segment_point_dist_2d (p1, p2, p);
        totaldistsquared = dist*dist + totaldistsquared;
    end
    
    res_err = totaldistsquared/size(lines,1);
        
    function dist = segment_point_dist_2d ( p1, p2, p )
      if ( p1(1:2,1) == p2(1:2,1) )
        t = 0.0;
      else
        bot = sum ( ( p2(1:2,1) - p1(1:2,1) ).^2 );
        t = ( p(1:2,1) - p1(1:2,1) )' * ( p2(1:2,1) - p1(1:2,1) ) / bot;
        t = max ( t, 0.0 );
        t = min ( t, 1.0 );
      end
      pn(1:2,1) = p1(1:2,1) + t * ( p2(1:2,1) - p1(1:2,1) );
      dist = sqrt ( sum ( ( pn(1:2,1) - p(1:2,1) ).^2 ) );
      return
    end
end
    
    
    
    

       

    
        
