function [points_3d errs] = find_3d_points(P1,P2, matches) %<---------------------- You write this one!
    if nargout>=1
        
        A=zeros(4,4);
        points_3d=zeros(4, size(matches',2));
        
        
        for i=1:size(matches,1)
            A=[matches(i,1).*P1(3,:)-P1(1,:);...
                matches(i,2).*P1(3,:)-P1(2,:);...
                matches(i,3).*P2(3,:)-P2(1,:);...
                matches(i,4).*P2(3,:)-P2(2,:)];
            [U S V]=svd(A,0);
            points_3d(:,i)=V(:,end)./V(end,end);
        end
        X_3D=points_3d;
        points_3d=points_3d(1:3,:);
        points_3d=points_3d';
    end
    
    if nargout>1
        X1_2D=P1*X_3D;
        X2_2D=P2*X_3D;
        
        for i=1:size(X_3D,2)
            X1_2D(:,i)=X1_2D(:,i)./X1_2D(3,i);
            X2_2D(:,i)=X2_2D(:,i)./X2_2D(3,i);
        end
        
        errs=(sum(sqrt(sum((X1_2D(1:2,:)-matches(:,1:2)').^2,2)))+sum(sqrt(sum((X2_2D(1:2,:)-matches(:,3:4)').^2,2))))./(2*size(matches,1));
    end 
    
end
    