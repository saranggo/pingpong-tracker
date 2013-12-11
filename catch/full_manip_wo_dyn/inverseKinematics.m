function jointAngles = inverseKinematics(trajType, currentJointAngles, toGoPt, span, beta)
global a l1 l2 l3 table_height th1 th2 th3 th4 th5 th6 th7 joint_limits dh_table

q(:,1) = currentJointAngles;
q_dot(:,1)=[0;0;0;0;0]; 
t=0; 
k=5;
e = [0; 0; 0];

the1= q(1,1); the2 = 0; the3= q(3,1); the4= q(5,1); 
x0 = [ l1 + l2*(cos(the1)*cos(the3) - sin(the1)*sin(the2)*sin(the3)) + l3*cos(the4)*(cos(the1)*cos(the3) - sin(the1)*sin(the2)*sin(the3)) - l3*cos(the2)*sin(the1)*sin(the4),...
                                                                             l2*cos(the2)*sin(the3) - l3*sin(the2)*sin(the4) + l3*cos(the2)*cos(the4)*sin(the3),...
        a + l2*(cos(the3)*sin(the1) + cos(the1)*sin(the2)*sin(the3)) + l3*cos(the4)*(cos(the3)*sin(the1) + cos(the1)*sin(the2)*sin(the3)) + l3*cos(the1)*cos(the2)*sin(the4)]

directionCosines = [(toGoPt(1)-x0(1))/span (toGoPt(2)-x0(2))/span (toGoPt(3)-x0(3))/span];

dt = span/10;

for j=1:10
    t=t+dt;
    
    %Desired points on trajectory
    switch trajType
        case 1
            xd(j,:)=[x0(1)+directionCosines(1)*t, x0(2)+directionCosines(2)*t, x0(3)+directionCosines(3)*t]
            xd_dot = [directionCosines(1), 0 ,directionCosines(3)];
        case 2
    end        
    
    %Getting Jacobian
    th1= q(1,j); th2 = 0; th3 = q(3,j); th4= q(5,j);             
    J_G = getJacobian(getPointsAndAxes());
    
    %Gain times the error
    k_e = k*e;
      
    %Correction factor to be multiplied with Inverse jacobian
    e_factor = xd_dot' + k_e; 
    
    %The feedback control system to minimize the error in q 
    J_sword = J_G(1:3,:)'/(J_G(1:3,:)*J_G(1:3,:)'); 
    q_dot = J_sword * e_factor;
    q(:,j+1)=q(:,j) + q_dot*dt;
    
    the1= q(1,j); the2 = 0; the3= q(3,j); the4= q(5,j);
    %Forward Kinematics
    x_fow = l1 + l2*(cos(the1)*cos(the3) - sin(the1)*sin(the2)*sin(the3)) + l3*cos(the4)*(cos(the1)*cos(the3) - sin(the1)*sin(the2)*sin(the3)) - l3*cos(the2)*sin(the1)*sin(the4);
    y_fow =  l2*cos(the2)*sin(the3) - l3*sin(the2)*sin(the4) + l3*cos(the2)*cos(the4)*sin(the3);
    z_fow = a + l2*(cos(the3)*sin(the1) + cos(the1)*sin(the2)*sin(the3)) + l3*cos(the4)*(cos(the3)*sin(the1) + cos(the1)*sin(the2)*sin(the3)) + l3*cos(the1)*cos(the2)*sin(the4);
    k_fow(j,:)=[x_fow y_fow z_fow]

    %Error between current and desired positions
    e = xd(j,:)' - k_fow(j,:)';
end
jointAngles =q;
end