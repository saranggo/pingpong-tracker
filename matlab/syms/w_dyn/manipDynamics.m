clc;
clear all;
close all;
%global tau D C G 
syms th1 th2 th3 J1 J2 J3 g th1_dot th2_dot th3_dot th1_dotdot th2_dotdot th3_dotdot real
syms m1 m2 m3 l1 l2 l3 a
%m1 = 6; m2 = 6; m3 = 6; l1 =4; l2=4; l3 =4; a= 4;
%% 2
q = [th1; th2; th3];
T_01  = getTransform(0,a,l1,0); 
T_12  = getTransform(th1, 0, 0, 90);
T_23    = getTransform(th2, 0, l2 , 0);
T_34    = getTransform(th3, 0, l3 , 0);

T_02 = T_01*T_12;
T_03 = T_02*T_23;
T_04 = T_03*T_34;

z0 =[0 0 0]'; z1 =T_01(1:3,3); z2 = T_02(1:3,3); z3 = T_03(1:3,3);  z4 = T_04(1:3,3);
p0 = [0 0 0]'; p01 = [0 0 a]'; p1 = T_01(1:3,4); p2 = T_02(1:3,4); p3 = T_03(1:3,4);  p4 = T_04(1:3,4);

p =[p0, p01, p1, p2, p3, p4];
z =[z0, z1, z2, z3, z4];

J = getJacobian(p,z);
J_dot = diff(J,th1)+diff(J,th2)+diff(J,th3);
J = simple(J);

%% 3,4
Jwc1 = [J(4:6,1),zeros(3,1),zeros(3,1)];
Jwc2 = [J(4:6,1),J(4:6,2),zeros(3,1)];
Jwc3 = [J(4:6,1),J(4:6,2),J(4:6,3)];

Jvc1 = [0,0,0;
        0,0,0;
        0,0,0];

lc2=l2/2;                                               
Jvc2 = [ -sin(th1)*lc2*cos(th2), -cos(th1)*lc2*sin(th2), 0;
          cos(th1)*lc2*cos(th2), -sin(th1)*lc2*sin(th2), 0;
                             0,            lc2*cos(th2), 0];

lc3=l3/2;                         
Jvc3 = [ -sin(th1)*(l3*cos(th2 + th3) + l2*cos(th2)), -cos(th1)*(l3*sin(th2 + th3) + l2*sin(th2)), -l3*sin(th2 + th3)*cos(th1)
          cos(th1)*(l3*cos(th2 + th3) + l2*cos(th2)), -sin(th1)*(l3*sin(th2 + th3) + l2*sin(th2)), -l3*sin(th2 + th3)*sin(th1)
                                                   0,             l3*cos(th2 + th3) + l2*cos(th2),           l3*cos(th2 + th3)];    

J1 = m1*l1^2/4;
J2 = m2*l2^2/4;
J3 = m3*l3^2/4;

I1 = [J1 0   0;
      0 J1  0;
      0 0 J1];
I2 = [J2 0   0;
     0   J2  0;
     0   0  J2];
I3 = [J3 0   0;
     0   J3  0;
     0   0  J3]; 
 
R_01 = T_01(1:3,1:3); 
R_02 = T_02(1:3,1:3); 
R_03 = T_03(1:3,1:3);

q_dot = [th1_dot; th2_dot; th3_dot];

D1 = m1*Jvc1'*Jvc1 + Jwc1'*R_01*I1*R_01'*Jwc1;
D2 = m2*Jvc2'*Jvc2 + Jwc2'*R_02*I2*R_02'*Jwc2;
D3 = m3*Jvc3'*Jvc3 + Jwc3'*R_03*I3*R_03'*Jwc3;
D = simple(D1+D2+D3);

K1 = 0.5*q_dot'*D1*q_dot;
K2 = 0.5*q_dot'*D2*q_dot;
K3 = 0.5*q_dot'*D3*q_dot;
K = simple(K1+K2+K3);

P1 = g*a*m1;
P2 = g*m2*(a-lc2*sin(th2));
P3 = g*m3*(a-l2*sin(th2)-lc3*sin(th3+th2));
P = simple(P1+P2+P3);
%% 5 
L = K - P;

%% 6
q_dotdot = [th1_dotdot; th2_dotdot; th3_dotdot];
for k = 1:3
    for j=1:3
        for i=1:3
            if i == 1
                C(k,j) = 0.5*(diff(D(k,j),q(j))+diff(D(k,i),q(j))-diff(D(i,j),q(k)))*q_dot(i);
            else
                C(k,j) = C(k,j)+0.5*(diff(D(k,j),q(j))+diff(D(k,i),q(j))-diff(D(i,j),q(k)))*q_dot(i);
            end
        end    
    end
end

C = simple(C);

G = [diff(P,th1);
     diff(P,th2);
     diff(P,th3)]; 
G = simple(G);

tau = D*q_dotdot + C*q_dot + G;