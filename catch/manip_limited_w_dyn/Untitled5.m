clc; clear all;
global m1 m2 m3 l1 l2 l3 a g
m1=6; m2=6; m3=6; l1=4; l2=4; l3=4; a=4; g=9.81;

x=[0;0;0;0;0;0];
[D C G] = getDynamicsParams(x);
D = double(D)
C = double(C)
G = double(G)