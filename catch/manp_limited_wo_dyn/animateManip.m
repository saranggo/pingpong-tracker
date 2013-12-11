function EndEffPt = animateManip(jointAngles)
global a l1 l2 l3 table_height th1 th2 th3 joint_limits dh_table
for i=1:length(jointAngles)
    th1 = jointAngles(1,i);
    th2 = jointAngles(2,i);
    th3 = jointAngles(3,i);
    P0=[0 0 0];	
    P0_1=[0 0 a];
    Pk = P0_1 + [0 0 0.5];
    P1=[l1, 0, a];
    P2=[l1, 0, a];
    P3=[l1 + l2*cos(th1)*cos(th2), l2*cos(th2)*sin(th1), a + l2*sin(th2)];
    P4=[l1 + l2*cos(th1)*cos(th2) + l3*cos(th1)*cos(th2)*cos(th3) - l3*cos(th1)*sin(th2)*sin(th3),...
             l2*cos(th2)*sin(th1) + l3*cos(th2)*cos(th3)*sin(th1) - l3*sin(th1)*sin(th2)*sin(th3),...
                                    a + l2*sin(th2) + l3*cos(th2)*sin(th3) + l3*cos(th3)*sin(th2)];                                

    Ps=[P0' P0_1' P1' P2' P3' P4']';
    hold off;
    plot3(Ps(:,1),Ps(:,2),Ps(:,3),'-+');
    hold on;
    grid on;
    axis([-4 12 -8 8 -4 12]);
    drawnow;
end
EndEffPt = P4;
end