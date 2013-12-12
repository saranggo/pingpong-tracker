function [jointAngles norm_error] = inverseKinematics(trajType, currentJointAngles, toGoPt, span, gamma,ballVelocity)
global a l1 l2 l3 table_height th1 th2 th3 joint_limits dh_table

q(:,1) = currentJointAngles;
q_dot(:,1)=[0;0;0]; 
t=0; 
Kp=5; Kd=20;
e = [0; 0; 0]; ed = [0; 0; 0];
e1(:,1) =[0; 0; 0];

the1= q(1,1); the2 = q(2,1); the3= q(3,1); 
x0 = [ l1 + l2*cos(the1)*cos(the2) + l3*cos(the1)*cos(the2)*cos(the3) - l3*cos(the1)*sin(the2)*sin(the3),...
                                                          sin(the1)*(l3*cos(the2 + the3) + l2*cos(the2)),...
                                                                 a + l3*sin(the2 + the3) + l2*sin(the2)];
 

directionCosines = [(toGoPt(1)-x0(1))/span (toGoPt(2)-x0(2))/span (toGoPt(3)-x0(3))/span];
dt = span/200; N=200;
%dt = span*ballVelocity/200;
%N = round(200/ballVelocity);
for j=1:N
    t=t+dt;
    
    %Desired points on trajectory
    switch trajType
        case 'StLine'
            xd(j,:)=[x0(1)+directionCosines(1)*t, x0(2)+directionCosines(2)*t, x0(3)+directionCosines(3)*t]
            xd_dot = [directionCosines(1), 0 ,directionCosines(3)];
        case 'Parabola'
            gamma = 0.4*gamma;
            beta = gamma*2*pi;
            startPt = [20 0 0]; ellipseCenter = [10 0 0]; endPt=[0 0 0]; majAx = 10; minAx=5;
            trajPTS(k,:)=startPt; k=k+1;
            xd(j,:)=[ellipseCenter(1)+majAx*cos(-beta*j), ellipseCenter(2), ellipseCenter(3)+minAx*sin(-beta*j)];
            xd_dot(j,:) = [-sin(-beta*j)*-beta*majAx, 0, cos(-beta*j)*-beta*minAx];
    end        
    
    %Getting Jacobian
    th1= q(1,j); th2 = q(2,j); th3 = q(3,j);  
    [p z] = getPointsAndAxes(); 
    J_G = getJacobian(p,z);

    %The feedback control system to minimize the error in q
    Jinv =  inv(J_G(1:3,:));
    %Jinv = inv((J_G(1:3,:)'*J_G(1:3,:)))*J_G(1:3,:)';
    q_dot = Jinv * (xd_dot(j,:)' + Kp*e + Kd*ed);
    q(:,j+1)=q(:,j) + q_dot*dt;

    %Forward Kinematics
    the1= q(1,j); the2= q(2,j); the3= q(3,j); 
    x_fow = l1 + l2*cos(the1)*cos(the2) + l3*cos(the1)*cos(the2)*cos(the3) - l3*cos(the1)*sin(the2)*sin(the3);
    y_fow =  sin(the1)*(l3*cos(the2 + the3) + l2*cos(the2));
    z_fow = a + l3*sin(the2 + the3) + l2*sin(the2);
    xd_fow = 4*sin(the1)*sin(the2)*sin(the3) - 4*cos(the2)*sin(the1) - 4*cos(the1)*sin(the2) - 8*cos(the1)*cos(the2)*sin(the3) - 8*cos(the1)*cos(the3)*sin(the2) - 4*cos(the2)*cos(the3)*sin(the1);
    yd_fow = cos(the1)*(4*cos(the2 + the3) + 4*cos(the2)) - sin(the1)*(4*sin(the2 + the3) + 4*sin(the2)) - 4*sin(the2 + the3)*sin(the1);
    zd_fow = 8*cos(the2 + the3) + 4*cos(the2);
    k_fow(j,:)=[x_fow y_fow z_fow];
    kd_fow(j,:) = [xd_fow yd_fow zd_fow];
    
    %Error between current and desired positions
    e = xd(j,:)' - k_fow(j,:)';
    ed = xd_dot(j,:)' - kd_fow(j,:)';
    e1(:,j+1) = e;
end
norm_error = norm(e1);
jointAngles = q;
end