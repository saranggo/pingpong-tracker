function J_G1 = getJacobian(p,z);
%syms a l1 l2 l3 
%syms th1 th2 th3 th4 th5 th6 th7 
%syms th1_dot th2_dot th3_dot th4_dot th5_dot th6_dot
global a l1 l2 l3 table_height th1 th2 th3 th4 th5 th6 th7 

[z p] = getPointsAndAxes();

ze =[0 0 0]';

z2 = z(:,3); z3 = z(:,4); z4 = z(:,5); z6 = z(:,7); 
z7 = z(:,8); z8 = z(:,9); z9 = z(:,10);

p2 = p(:,3); p3 = p(:,4); p4 = p(:,5); p6 = p(:,7); 
p7 = p(:,8); p8 = p(:,9); p9 = z(:,10); p10 = z(:,11);

J_G = [ze, ze, cross(z2,(p10-p2)), cross(z3,(p10-p3)), cross(z4,(p10-p4)), ze, cross(z6,(p10-p6)), cross(z7,(p10-p7)), cross(z8,(p10-p8)), cross(z9,(p10-p9)); 
       ze, ze, z2                , z3                , z4                , ze, z6                , z7                , z8                , z9                 ];   
J_G1 = [J_G(:,3) J_G(:,4) J_G(:,5) J_G(:,6) J_G(:,7)];
end