clc; clear all; close all;

global a l1 l2 l3 table_height th1 th2 th3 joint_limits dh_table
config;             
haveActuralPoints = 'yes';

%DRAWING REST STATE
[p z] = getPointsAndAxes();
figure(1); title('MANIPULATOR, WORKSPACE AND OBJECT TRAJECTORY');
plot3(p(1,:), p(2,:), p(3,:), '-+','LineWidth',2);
grid on;
axis ([-4 12 -8 8 -4 12]);

%GETTING WORKSPACE
WSresolution = 0.2;
[ellipsoidParams, workspace, workspaceLimits] = getWorkspace(joint_limits, WSresolution);
hold on;
plot3(workspace(:,1),workspace(:,2),workspace(:,3),'r.');
axis(workspaceLimits);
resetManipulator();

%GETTING TRAJECTORY POINTS CLASSIFIED
[position_base velocity_base accleration_base trajLimits] = realPts('pos_vel_acc.txt');

for i=1:length(position_base)
currentParams = [position_base(i,:); velocity_base(i,:); accleration_base(i,:)];
estimatedPoints = estimateTrajectory(currentParams,50);
hold off;
figure(5);
plot3(estimatedPoints(:,1),estimatedPoints(:,2),estimatedPoints(:,3),'o-');
[trajPTSin trajPTSout trajPTSon] = classifyTrajectory(estimatedPoints, ellipsoidParams);
hold on;
plot3(trajPTSin(:,1),trajPTSin(:,2),trajPTSin(:,3),'bo','LineWidth',2);
plot3(trajPTSout(:,1),trajPTSout(:,2),trajPTSout(:,3),'go','LineWidth',2);
plot3(trajPTSon(:,1),trajPTSon(:,2),trajPTSon(:,3),'ko','LineWidth',2);
axis([min(workspaceLimits(1),trajLimits(1)),max(workspaceLimits(2),trajLimits(2))...
      min(workspaceLimits(3),trajLimits(3)),max(workspaceLimits(4),trajLimits(4))...
      min(workspaceLimits(5),trajLimits(5)),max(workspaceLimits(6),trajLimits(6))]);
 
%FINDING THE OPTIMAL REACHABLE POINT AND CATCH TYPE
if size(trajPTSin) ~= 1
    toGoPt = getOptReachablePt('FirstPointIn', trajPTSin); %TODO: other reachable point types
    plot3(toGoPt(:,1),toGoPt(:,2),toGoPt(:,3),'ko','LineWidth',3);

    %INVERSE KINEMATICS
    trajType = 'StLine';
    trajResolution = 0.5;
    ballVelocity = 2;%getVelocity('projectile'); %m/s
    t_start = 0;
    t_final = getTfinal(trajType, toGoPt, ballVelocity);
    tSpan = t_final-t_start ;
    th1 = 0; th2=0; th3=0.0001*pi/180;
    currentJointAngles = [th1 th2 th3]';
    [jointAngles norm_error] = inverseKinematics('StLine', currentJointAngles, toGoPt, tSpan, trajResolution, ballVelocity);

    %ANIMATION OF GETTING TO THE POINT
    figure(2); title('CATCHING THE BALL');
    EndEffPt = animateManip(jointAngles);
    disp(toGoPt); disp(EndEffPt); disp(norm(toGoPt-EndEffPt));
else
    disp('No Trajectory Points inside the Workspace');
end
end