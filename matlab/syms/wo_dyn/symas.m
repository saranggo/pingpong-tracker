syms a l1 l2 l3 
syms th1 th2 th3 th4 th5 th6 th7 
syms th1_dot th2_dot th3_dot th4_dot th5_dot th6_dot


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