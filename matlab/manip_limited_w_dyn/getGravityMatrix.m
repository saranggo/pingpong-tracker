function G = getGravityMatrix()
syms th1 th2 th3 J1 J2 J3 g th1_dot th2_dot th3_dot th1_dotdot th2_dotdot th3_dotdot real
syms m1 m2 m3 l1 l2 l3 a g
lc2=l2/2; lc3=l3/2;
P1 = g*a*m1;
P2 = g*m2*(a-lc2*sin(th2));
P3 = g*m3*(a-l2*sin(th2)-lc3*sin(th3+th2));
P = P1+P2+P3;

G = [diff(P,th1);
     diff(P,th2);
     diff(P,th3)]; 
end