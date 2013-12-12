a = importdata('world_points.txt');
Dmax = 255; Dmin =0; kinmin = 05; kinmax = 35; %in cm

T_bf = getTransform(0,4.5,0,0);
T_fk = getTransform(90,0,0,90);
R_bk = T_bf(1:3,1:3)*T_fk(1:3,1:3);

for i=1:length(a)
    worldPt_kin(i,:) =  [a(i,1) a(i,2) (a(i,3)-Dmin)/Dmax*(kinmax-kinmin)];
    worldPt_base(i,:) = (R_bk*worldPt_kin(i,:)')/10.*[1 1 -1]'+[8 0 3]';
    %worldPt_base(i,:) = (R_bk*a(i,:)'.*[1 -1 -1]'-[0 0 4.5]')/10;
end

worldPt_base = fliplr(worldPt_base')';
minX = min(worldPt_base(:,1)); minY = min(worldPt_base(:,2)); minZ = min(worldPt_base(:,3));
maxX = max(worldPt_base(:,1)); maxY = max(worldPt_base(:,2)); maxZ = max(worldPt_base(:,3));
trajLimits = [minX-1 maxX+1 minY-1 maxY+1 minZ-1 maxZ+1];

p = worldPt_base(1,:); q = worldPt_base(2,:); r = worldPt_base(3,:); t = worldPt_base(4,:);
pq = q-p; pr=r-p;
pqr=cross(pq,pr);
d=dot(pqr,p);
planeEq = [pqr d];

traj = fit(, 'poly2');
