function [p z] = getPointsAndAxes();
%syms a l1 l2 l3 
%syms th1 th2 th3 th4 th5 th6 th7 
%syms th1_dot th2_dot th3_dot th4_dot th5_dot th6_dot
global a l1 l2 l3 table_height th1 th2 th3 th4 th5 th6 th7 dh_table


T_01  = getTransform(0, a, 0 , 90); 
T_12  = getTransform(0, 0, l1, 0);
T_23    = getTransform(th1+pi/2, 0, 0 , 90);
T_34    = getTransform(th2+pi/2, 0, 0 , 90);
T_45  = getTransform(th3+pi/2, 0, 0 , 90);
T_56  = getTransform(0, 0, l2, 0);
T_67    = getTransform(th4, 0, l3, 0);
T_78    = getTransform(th5+pi/2, 0, 0 , 90);
T_89    = getTransform(th6+pi/2, 0, 0 , 90);
T_910    = getTransform(th7, 0, 0 , 0);

T_02 = T_01*T_12;
T_03 = T_02*T_23;
T_04 = T_03*T_34;
T_05 = T_04*T_45;
T_06 = T_05*T_56;
T_07 = T_06*T_67;
T_08 = T_07*T_78;
T_09 = T_08*T_89;
T_010 = T_09*T_910;

z0 =[0 0 0]'; z1 =[0 0 0]'; z2 = T_02(1:3,3); z3 = T_03(1:3,3); 
z4 = T_04(1:3,3); z5 =T_05(1:3,3); z6 = T_06(1:3,3); z7 = T_07(1:3,3); 
z8 = T_08(1:3,3); z9 = T_09(1:3,3); z10 = T_010(1:3,3);

p0 = [0 0 0]'; p1 = T_01(1:3,4); p2 = T_02(1:3,4); p3 = T_03(1:3,4); 
p4 = T_04(1:3,4); p5 = T_05(1:3,4); p8 = T_08(1:3,4); p6 = T_06(1:3,4); 
p7 = T_07(1:3,4); p9 = T_09(1:3,4); p10 = T_010(1:3,4); 

p =[p0, p1, p2, p3, p4, p5, p6, p7, p8, p9, p10];
z =[z0, z1, z2, z3, z4, z5, z6, z7, z8, z9, z10];
end