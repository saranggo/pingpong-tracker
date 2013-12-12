%dynderiv.m
function xdot=dynderiv(t,x)
global m1 m2 m3 l1 l2 l3 a g
m1=6; m2=6; m3=6; l1=4; l2=4; l3=4; a=4; g=9.81;
tau1=dyncntrl(t,x);

th1 = x(1); th2 = x(3); th3 = x(5);
th1_dot = x(2); th2_dot = x(4); th3_dot = x(6);

% [M C G] = getDynamicsParams(x);
% M = double(M);
% C = double(C);
% G = double(G);

 M = [ 6*(2*cos(th2 + th3) + 4*cos(th2))^2 + 48,                     24*sin(th2)^2,                0;
                                  24*sin(th2)^2, 96*cos(th3) + 24*sin(th2)^2 + 144, 48*cos(th3) + 24;
                                              0,                  48*cos(th3) + 24,               48];

 
 C = [                                                                                            0, 24*th2_dot*sin(2*th2) - 36*th1_dot*sin(2*th2) + 12*th3_dot*sin(2*th2) - 12*th1_dot*sin(2*th2 + 2*th3) - 48*th1_dot*sin(2*th2 + th3), -24*th1_dot*sin(th2 + th3)*(cos(th2 + th3) + 2*cos(th2));
       6*th1_dot*(8*sin(2*th2 + th3) + 8*sin(2*th2) + 2*sin(2*th2 + 2*th3)) - 12*th2_dot*sin(2*th2),                                                                                         12*sin(2*th2)*(th1_dot + th2_dot + th3_dot),           -24*sin(th3)*(th1_dot + 3*th2_dot + 2*th3_dot);
                                            24*th1_dot*sin(th2 + th3)*(cos(th2 + th3) + 2*cos(th2)),                                                                                                   24*sin(th3)*(2*th2_dot + th3_dot),                                                        0];
 
C_mult = C*x([2,4,6]);

G =  [                                         0;
 - (2943*cos(th2 + th3))/25 - (8829*cos(th2))/25;
                       -(2943*cos(th2 + th3))/25];
            
C_mult = C*x([2,4,6]);

xdottemp = M\(tau1-G-C_mult);

xdot([1,3,5])=x([2,4,6]);%+Kp*eq;

xdot([2,4,6])=xdottemp(:);%+Kd*edq;

xdot = xdot';
