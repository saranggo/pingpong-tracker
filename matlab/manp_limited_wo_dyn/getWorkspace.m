function [ellipsoidParams, workspace, workspaceLimits] = getWorkspace(joint_limits, beta)
global a l1 l2 l3 table_height th1 th2 th3
 i = 1;
for th1 = joint_limits(1,1):beta:joint_limits(2,1)
    for th2 = joint_limits(1,2):beta:joint_limits(2,2)
        for th3 = joint_limits(1,3):beta:joint_limits(2,3)
                [p1 z1] = getPointsAndAxes();
                workspace(i,:)= p1(:,6)';
                i= i+1;
%     P0=[0 0 0];	
%     P0_1=[0 0 a];
%     P1=[l1, 0, a];
%     P2=[l1, 0, a];
%     P3=[l1 + l2*cos(th1)*cos(th2), l2*cos(th2)*sin(th1), a + l2*sin(th2)];
%     P4=[l1 + l2*cos(th1)*cos(th2) + l3*cos(th1)*cos(th2)*cos(th3) - l3*cos(th1)*sin(th2)*sin(th3),...
%              l2*cos(th2)*sin(th1) + l3*cos(th2)*cos(th3)*sin(th1) - l3*sin(th1)*sin(th2)*sin(th3),...
%                                     a + l2*sin(th2) + l3*cos(th2)*sin(th3) + l3*cos(th3)*sin(th2)];                                
% 
%     Ps=[P0' P0_1' P1' P2' P3' P4']';
%     hold off;
%     plot3(Ps(:,1),Ps(:,2),Ps(:,3),'-+');
%     hold on;
%     grid on;
%     axis([-4 12 -8 8 -4 12]);
%     drawnow;        
        end    
    end
end

maxX = max(workspace(:,1)); maxY = max(workspace(:,2)); maxZ = max(workspace(:,3));

minX = min(workspace(:,1)); minY = min(workspace(:,2)); minZ = min(workspace(:,3));

A = maxX - minX; B = maxY - minY; C = maxZ - minZ;

ellipsoidParams = [minX+A/2, minY+B/2, minZ+C/2, A, B, C];

workspaceLimits = [minX-1 maxX+1 minY-1 maxY+1 minZ-1 maxZ+1];
end