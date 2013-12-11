syms a l1 l2 l3 
syms th1 th2 th3
syms th1_dot th2_dot th3_dot


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

J_G = getJacobian(p,z);