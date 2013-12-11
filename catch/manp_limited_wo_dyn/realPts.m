function [worldPt_base planeEq trajLimits convPts] = realPts(filename)
a = importdata(filename);
Dmax = 255; Dmin =0; kinmin = 05; kinmax = 35; %in cm
%velocity(1,:) =  

T_bf = getTransform(0,4.5,0,0);
T_fk = getTransform(90,0,0,90);
R_bk = T_bf(1:3,1:3)*T_fk(1:3,1:3);

fps = 30;
dt = 1/30;
for i=1:length(a)
    worldPt_kin(i,:) =  [a(i,1) a(i,2) (a(i,3)-Dmin)/Dmax*(kinmax-kinmin)];
    worldPt_base(i,:) = (R_bk*worldPt_kin(i,:)')/10.*[1 1 -1]'+[8 0 3]';
    convPts(i,:) = rotatePoints(worldPt_base(i,:),worldPt_base(1,:));
%     if i~=1
%         velocity(i,:) = worldPt_base(i,:)-worldPt_base(i-1,:)/dt;
%     end    
    %worldPt_base(i,:) = (R_bk*a(i,:)'.*[1 -1 -1]'-[0 0 4.5]')/10;
end

worldPt_base = fliplr(worldPt_base')';
minX = min(worldPt_base(:,1)); minY = min(worldPt_base(:,2)); minZ = min(worldPt_base(:,3));
maxX = max(worldPt_base(:,1)); maxY = max(worldPt_base(:,2)); maxZ = max(worldPt_base(:,3));
trajLimits = [minX-1 maxX+1 minY-1 maxY+1 minZ-1 maxZ+1];

%traj = fit([worldPt_base(:,1), worldPt_base(:,2)], worldPt_base(:,3), 'poly2');
% p = worldPt_base(1,:); q = worldPt_base(2,:); r = worldPt_base(3,:); t = worldPt_base(4,:);
% pq = q-p; pr=r-p;
% pqr=cross(pq,pr);
% d=dot(pqr,p);
% planeEq = [pqr d];
planeEq = [];
% worldPt_base = fliplr(worldPt_base')';
% figure(1);
% plot3(a(:,1), a(:,2), a(:,3), 'b.-');
% grid on;
% axis('ij');
% 
% 
% % figure(2);
% % plot3(0,0,0, 'c*')
% % hold on;
% % plot3(worldPt_kin(:,1), worldPt_kin(:,2), worldPt_kin(:,3), 'r.-');
% % grid on;
% % axis('ij');
% % 
% figure(2);
% plot3(0,0,4.5, 'k*')
% hold on;
% plot3(worldPt_base(:,1), worldPt_base(:,2), worldPt_base(:,3), 'k.-');
% grid on;
% axis('ij');
end