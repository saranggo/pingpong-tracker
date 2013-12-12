function C = getChristoffelSymbols()
syms th1 th2 th3 J1 J2 J3 g th1_dot th2_dot th3_dot th1_dotdot th2_dotdot th3_dotdot real
syms m1 m2 m3 l1 l2 l3 a
[D D1 D2 D3] = getInertiaMatrix();

q = [th1; th2; th3];
q_dot = [th1_dot; th2_dot; th3_dot];

K1 = 0.5*q_dot'*D1*q_dot;
K2 = 0.5*q_dot'*D2*q_dot;
K3 = 0.5*q_dot'*D3*q_dot;
K = K1+K2+K3;

lc2=l2/2; lc3=l3/2;
P1 = g*a*m1;
P2 = g*m2*(a-lc2*sin(th2));
P3 = g*m3*(a-l2*sin(th2)-lc3*sin(th3+th2));
P = P1+P2+P3;
 
L = K - P;

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
end