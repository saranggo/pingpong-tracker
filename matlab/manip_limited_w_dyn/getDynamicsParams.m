function [D C G] = getDynamicsParams(x)

global m1 m2 m3 l1 l2 l3 a g

D = getInertiaMatrix();
D = subs(D,'th1',x(1));
D = subs(D,'th2',x(3));
D = subs(D,'th3',x(5));
D = subs(D,'th1_dot',x(2));
D = subs(D,'th2_dot',x(4));
D = subs(D,'th3_dot',x(6));
D = subs(D,'m1',m1);
D = subs(D,'m2',m2);
D = subs(D,'m3',m3);
D = subs(D,'l1',l1);
D = subs(D,'l2',l2);
D = subs(D,'l3',l3);
D = subs(D,'a',a);

C = getChristoffelSymbols();
C = subs(C,'th1',x(1));
C = subs(C,'th2',x(3));
C = subs(C,'th3',x(5));
C = subs(C,'th1_dot',x(2));
C = subs(C,'th2_dot',x(4));
C = subs(C,'th3_dot',x(6));
C = subs(C,'m1',m1);
C = subs(C,'m2',m2);
C = subs(C,'m3',m3);
C = subs(C,'l1',l1);
C = subs(C,'l2',l2);
C = subs(C,'l3',l3);
C = subs(C,'a',a);

G = getGravityMatrix();
G = subs(G,'th1',x(1));
G = subs(G,'th2',x(3));
G = subs(G,'th3',x(5));
G = subs(G,'m1',m1);
G = subs(G,'m2',m2);
G = subs(G,'m3',m3);
G = subs(G,'l1',l1);
G = subs(G,'l2',l2);
G = subs(G,'l3',l3);
G = subs(G,'a',a);
G = subs(G,'g',g);
end