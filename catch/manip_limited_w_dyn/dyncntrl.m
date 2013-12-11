function u=dyncntrl(t,x)
%global tau D C G g m1 m2 m3 l1 l2 l3 a
u = [0; 0; 0];

% global t_prev q_prev l1 l2 l3 a %beta grav_comp err_q f m1 m2 m3 l1 l2 l3 a
%     Kp = 5000;
%     Kd = 500;
%     K = 5;
%     
%     dt = t - t_prev; 
%     
%     th1 = x(1); th2 = x(3); th3 = x(5);    
% 
%     xd =[12 0 6];
%     xd_dot = [0; 0; 0];
%     
%     xk = [ l1 + l2*cos(th1)*cos(th2) + l3*cos(th1)*cos(th2)*cos(th3) - l3*cos(th1)*sin(th2)*sin(th3),...
%                                                           sin(th1)*(l3*cos(th2 + th3) + l2*cos(th2)),...
%                                                                  a + l3*sin(th2 + th3) + l2*sin(th2)];
%  
%     x_error = xd - xk;
%     
%     J =  [ -4*sin(th1)*(cos(th2 + th3) + cos(th2)), -4*cos(th1)*(sin(th2 + th3) + sin(th2)), -4*sin(th2 + th3)*cos(th1);
%             4*cos(th1)*(cos(th2 + th3) + cos(th2)), -4*sin(th1)*(sin(th2 + th3) + sin(th2)), -4*sin(th2 + th3)*sin(th1);
%                                                  0,           4*cos(th2 + th3) + 4*cos(th2),           4*cos(th2 + th3);
%                                                  0,                                       0,                   sin(th1);
%                                                  0,                                       0,                  -cos(th1);
%                                                  1,                                       1,                          0];
%     
%     %The feedback control system to minimize the error in q 
%     q_dot = inv(J(1:3,:)) * (xd_dot + (K*x_error)');
%     q = q_prev + q_dot*dt;
%     eq = q - [x(1); x(3); x(5)];
% 
%     t_prev = t;
%     q_prev = q;
%     u = Kp*eq - Kd*x([2,4,6]);
end