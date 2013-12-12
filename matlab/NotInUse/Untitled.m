clc; clear all; close all;

a = importdata('world_points.txt');
max = 255; min =0; kinmin = 8; kinmax = 40; %in cm

T_bf = getTransform(0,4.5,0,0);
T_fk = getTransform(0,0,0,90);
R_bk = T_bf(1:3,1:3)*T_fk(1:3,1:3);

for i=1:length(a)
    %worldPt_kin(i,:) = [((-a(i,1)-min)/max)*(kinmax-kinmin) (-a(i,2)-min)/max*(kinmax-kinmin) (a(i,3)-min)/max*(kinmax-kinmin)];
    %worldPt_base(i,:) = (R_bk*worldPt_kin(i,:)'-[0 0 4.5]')/10;
    worldPt_base(i,:) = (R_bk*a(i,:)'.*[1 -1 -1]'-[0 0 4.5]')/10;
end
trajLimits = [];