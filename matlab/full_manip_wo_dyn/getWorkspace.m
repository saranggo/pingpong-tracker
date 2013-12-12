function [ellipsoidParams, workspace] = getWorkspace(joint_limits, beta)
global a l1 l2 l3 table_height th1 th2 th3 th4 th5 th6 th7
 i = 1;
for th1 = joint_limits(1,1):beta:joint_limits(2,1)
    for th2 = joint_limits(1,2):beta:joint_limits(2,2)
        for th3 = joint_limits(1,3):beta:joint_limits(2,3)
            for th4 = joint_limits(1,4):beta:joint_limits(2,4)
                th5=0;  th6=0;  th7=0;
                [p1 z1] = getPointsAndAxes();
                workspace(i,:)= p1(:,11)';
                i=i+1;
%                 Ps=[p(:,1) p(:,2) p(:,3) p(:,4) p(:,5) p(:,6) p(:,7) p(:,8) p(:,9) p(:,10) p(:,11)]';
%                 hold off;
%                 plot3(Ps(:,1),Ps(:,2),Ps(:,3),'-+');
%                 hold on;
%                 grid on;
%                 axis(workspace_limits);
%                 drawnow;
%                 pause(0.1);
            end
        end    
    end
end

maxX = max(workspace(:,1)); maxY = max(workspace(:,2)); maxZ = max(workspace(:,3));

minX = min(workspace(:,1)); minY = min(workspace(:,2)); minZ = min(workspace(:,3));

A = maxX - minX; B = maxY - minY; C = maxZ - minZ;

ellipsoidParams = [minX+A/2, minY+B/2, minZ+C/2, A, B, C];
end