function workspace_limits = getWorkspaceLimits()
global a l1 l2 l3 table_height th1 th2 th3 th4 th5 th6 th7

%X_min
th1=pi/2; th2=0; th3=-pi/2; th4=pi/2;  th5=0;  th6=0;  th7=0;
[p z] = getPointsAndAxes();
% figure(1);
% plot3(p(1,:), p(2,:), p(3,:), '-+');
% xlabel('X'); ylabel('Y'); zlabel('Z');
% grid on;
% axis ([0 15 0 15 -1 5]);
X_min = p(1,10);

%X_max
th1=0; th2=0; th3=0; th4=0;  th5=0;  th6=0;  th7=0;
[p z] = getPointsAndAxes();
% figure(2);
% plot3(p(1,:), p(2,:), p(3,:), '-+');
% xlabel('X'); ylabel('Y'); zlabel('Z');
% grid on;
% axis ([0 15 0 15 -1 5]);
X_max = p(1,10);

%Z_min
th1=-pi/2; th2=0; th3=0; th4=0;  th5=0;  th6=0;  th7=0;
[p z] = getPointsAndAxes();
% figure(3);
% plot3(p(1,:), p(2,:), p(3,:), '-+');
% xlabel('X'); ylabel('Y'); zlabel('Z');
% grid on;
% axis ([0 15 0 15 -1 5]);
Z_min = p(3,10);

%Z_max
th1=pi/2; th2=0; th3=0; th4=0;  th5=0;  th6=0;  th7=0;
[p z] = getPointsAndAxes();
% figure(4);
% plot3(p(1,:), p(2,:), p(3,:), '-+');
% xlabel('X'); ylabel('Y'); zlabel('Z');
% grid on;
% axis ([0 15 0 15 -1 5]);
Z_max = p(3,10);

%Y_min
th1=0; th2=0; th3=-pi/2; th4=0;  th5=0;  th6=0;  th7=0;
[p z] = getPointsAndAxes();
% figure(5);
% plot3(p(1,:), p(2,:), p(3,:), '-+');
% xlabel('X'); ylabel('Y'); zlabel('Z');
% grid on;
% axis ([0 15 0 15 -1 5]);
Y_min = p(2,10);

%Y_min
th1=0; th2=0; th3=pi/2; th4=0;  th5=0;  th6=0;  th7=0;
[p z] = getPointsAndAxes();
% figure(6);
% plot3(p(1,:), p(2,:), p(3,:), '-+');
% xlabel('X'); ylabel('Y'); zlabel('Z');
% grid on;
%axis ([0 15 0 15 -1 5]);
Y_max = p(2,10);

workspace_limits = [X_min X_max Y_min Y_max Z_min Z_max];
end