data = importdata('pos_vel_acc.txt');
b=1;
for i=10:3:length(data)
    position_kin(b,:) = data(i,:);
    velocity_kin(b,:) = data(i+1,:);
    accleration_kin(b,:) = data(i+2,:);
    b = b+1;
end

Dmax = 255; Dmin =0; kinmin = 05; kinmax = 35; %in cm

T_bf = getTransform(0,4.5,0,0);
T_fk = getTransform(90,0,0,90);
R_bk = T_bf(1:3,1:3)*T_fk(1:3,1:3);

fps = 30;
dt = 1/30;
for i=1:b-1
    worldPt_kin(i,:) =  [position_kin(i,1) position_kin(i,2) (position_kin(i,3)-Dmin)/Dmax*(kinmax-kinmin)];
    position_base(i,:) = (R_bk*worldPt_kin(i,:)')/10.*[1 1 -1]'+[8 0 3]';
    velocity_base(i,:) = R_bk*velocity_kin(i,:)';
    accleration_base(i,:) = R_bk*accleration_kin(i,:)';
end

position_base = fliplr(position_base')';
velocity_base = fliplr(velocity_base')';
accleration_base = fliplr(accleration_base')';

minX = min(position_base(:,1)); minY = min(position_base(:,2)); minZ = min(position_base(:,3));
maxX = max(position_base(:,1)); maxY = max(position_base(:,2)); maxZ = max(position_base(:,3));
trajLimits = [minX-1 maxX+1 minY-1 maxY+1 minZ-1 maxZ+1];

figure(1);
plot3(position_base(:,1),position_base(:,2),position_base(:,3),'k.-');
grid on;
axis('ij');

figure(2);
plot3(velocity_base(:,1),velocity_base(:,2),velocity_base(:,3),'k.-');
grid on;
axis('ij');

figure(3);
plot3(accleration_base(:,1),accleration_base(:,2),accleration_base(:,3),'k.-');
grid on;
axis('ij');