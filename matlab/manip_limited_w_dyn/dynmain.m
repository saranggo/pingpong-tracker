clc; clear all; close all;

global t_prev q_prev
%m1=6; m2=6; m3=6; l1=4; l2=4; l3=4; a=4; g=9.81;

x1=pi;
x2=pi/2;
x3=pi/2;
q_prev = [x1 x2 x3]';

xdot1=0;
xdot2=0;
xdot3=0;

x0=[x1,xdot1,x2,xdot2,x3,xdot3]';

tstart=0; tfinal=10; t_prev = 0;

[TT,XX]=ode45('dynderiv',[tstart tfinal],x0);

figure(1); 
plot(TT,XX(:,1),'+-',TT,XX(:,2),'*-',TT,XX(:,3),'s-',TT,XX(:,4),'.-',TT,XX(:,5),'o-',TT,XX(:,6),'o-'); figure(gcf);  
xlabel('time'); ylabel('state'); title('Without Torque and Damping with all masses hanging down');
legend('theta1','theta1dot','theta2','theta2dot', 'theta3','theta3dot');
l1=4; l2=4; l3=4; a=4; g=9.81;
X = [0,0,0];
figure(2); title('animation of the Euler results');
 for i=1:length(TT)
    th1 = XX(i,1);
    th2 = XX(i,3);
    th3 = XX(i,5);
    
    P0=[0 0 0];	
    P0_1=[0 0 a];
    P1=[l1, 0, a];
    P2=[l1, 0, a];
    P3=[l1 + l2*cos(th1)*cos(th2), l2*cos(th2)*sin(th1), a + l2*sin(th2)];
    P4=[l1 + l2*cos(th1)*cos(th2) + l3*cos(th1)*cos(th2)*cos(th3) - l3*cos(th1)*sin(th2)*sin(th3),...
             l2*cos(th2)*sin(th1) + l3*cos(th2)*cos(th3)*sin(th1) - l3*sin(th1)*sin(th2)*sin(th3),...
                                    a + l2*sin(th2) + l3*cos(th2)*sin(th3) + l3*cos(th3)*sin(th2)];
    Ps=[P0' P0_1' P1' P2' P3' P4']';                            
    X(i,:) = P4;
    hold off;
    plot3(Ps(:,1),Ps(:,2),Ps(:,3),'-+');
    hold on;
    plot3((Ps(1,1)+Ps(2,1))/2,(Ps(1,2)+Ps(2,2))/2,(Ps(1,3)+Ps(2,3))/2,'o');
    plot3((Ps(2,1)+Ps(3,1))/2,(Ps(2,2)+Ps(3,2))/2,(Ps(2,3)+Ps(3,3))/2,'o');
    plot3((Ps(3,1)+Ps(4,1))/2,(Ps(3,2)+Ps(4,2))/2,(Ps(3,3)+Ps(4,3))/2,'o');
    plot3((Ps(4,1)+Ps(5,1))/2,(Ps(4,2)+Ps(5,2))/2,(Ps(4,3)+Ps(5,3))/2,'o');
    plot3((Ps(5,1)+Ps(6,1))/2,(Ps(5,2)+Ps(6,2))/2,(Ps(5,3)+Ps(6,3))/2,'o');
    grid on;
    axis([-5 12  -8 8 -17 17]);
    drawnow;
    pause(0.1);%for MATLAB to draw to screen each iteration
end

figure(3);
plot3(X(:,1)',X(:,2)',X(:,3)','b-.')
hold on;
% red mark on initial position
plot3(X(1,1)',X(1,2)',X(1,3)','r*');
axis('equal'); 
axis('ij');
X(1,:)
hold on;
% red mark on initial position
plot3(X(length(X),1)',X(length(X),2)',X(length(X),3)','k*');
axis('equal'); 
axis('ij'); 
X(length(X),:)
grid on;