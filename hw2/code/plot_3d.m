function plot_3d(points, P1, P2)
    figure;
    plot3(points(:,1),points(:,2), points(:,3),'R.');
    hold on
    
    plot3(P1(1,4), P1(2,4), P1(3,4), 'Bo');
    plot3(P2(1,4), P2(2,4), P2(3,4), 'Bo');

    xlin= linspace(max(points(:,1)),min(points(:,1)),100);
    ylin= linspace(max(points(:,2)),min(points(:,2)),100);
    [X,Y] = meshgrid(xlin,ylin);
    f=TriScatteredInterp(points(:,1),points(:,2), points(:,3));
    Z=f(X,Y);
%     surf(X,Y,Z);
    
    hold off
    
    
end
