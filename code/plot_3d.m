function plot_3d(points, R2, t2)
    figure;
    plot3(points(:,1),points(:,2), points(:,3),'R*');
    hold on
    
    C1=zeros(3,1);
    t1=zeros(3,1);
    R1=eye(3);
    C1=-t1'*R1';
    
    C2=-t2'*R2;
    plot3(C1(1), C1(2), C1(3), 'Bo')
    plot3(C2(1), C2(2), C2(3), 'Bo')
    hold off
end
