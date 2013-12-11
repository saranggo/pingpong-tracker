clc; clear all; close all;

global a l1 l2 l3 table_height th1 th2 th3 th4 th5 th6 th7 joint_limits dh_table
config;             

%DRAWING REST STATE
[p z] = getPointsAndAxes();
figure(1);
plot3(p(1,:), p(2,:), p(3,:), '-+','LineWidth',2);
grid on;
axis ([-4 12 -8 8 -4 12]);

%GETTING THE GEOMETRIC JACOBIAN
J_G = getJacobian(p,z); %TODO: Extend it to full manipulator

%GETTING WORKSPACE
WSresolution = 0.5;
[ellipsoidParams, workspace] = getWorkspace(joint_limits, WSresolution);
hold on;
plot3(workspace(:,1),workspace(:,2),workspace(:,3),'r.');
th1=0; th2=0; th3=0; th4=0;  th5=0;  th6=0;  th7=0;

%GETTING TRAJECTORY POINTS CLASSIFIED
trajType = 1; %st. line on X-Z plane  
TJresolution = 0.5;
[trajPTS trajPTSin trajPTSout trajPTSon] = getTrajectoryPts(trajType, TJresolution, ellipsoidParams); %TODO: other trajectory types
hold on;
plot3(trajPTSin(:,1),trajPTSin(:,2),trajPTSin(:,3),'bo','LineWidth',2);
plot3(trajPTSout(:,1),trajPTSout(:,2),trajPTSout(:,3),'go','LineWidth',2);
plot3(trajPTSon(:,1),trajPTSon(:,2),trajPTSon(:,3),'ko','LineWidth',2);

%FINDING THE OPTIMAL REACHABLE POINT AND CATCH TYPE
toGoPt = getOptReachablePt('FirstPointIn', trajPTSin); %TODO: other reachable point types
plot3(toGoPt(:,1),toGoPt(:,2),toGoPt(:,3),'bo','LineWidth',3);

%INVERSE KINEMATICS
ballVelocity = 1; %m/s
t_start = 0; beta = 0.2;
t_final = getTfinal(trajType, toGoPt, ballVelocity); %for trajectory type '1'(st. line)
tSpan = t_final-t_start ;
currentJointAngles = [th1 0 th3 0 th4]';
jointAngles = inverseKinematics(trajType, currentJointAngles, toGoPt, tSpan, beta);