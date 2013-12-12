function J_G = getJacobian(p,z);

ze =[0 0 0]';

z0 = z(:,1); z1 = z(:,2); z2 = z(:,3); z3 = z(:,4); z4 = z(:,5);
p0 = p(:,1); p1 = p(:,3); p2 = p(:,4); p3 = p(:,5); p4 = p(:,6); 

J_G = [cross(z1,(p4-p1)), cross(z2,(p4-p2)), cross(z3,(p4-p3)); 
       z1               , z1               , z3];   

end