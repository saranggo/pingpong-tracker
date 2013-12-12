function nextPose = estimateTrajectory(currentParams, nPts)
fps = 30; dt=1/fps; t=0;

% initPose = initParams(1,:);
% initVel = initParams(2,:);
% initAcc = initParams(3,:);

currPose = currentParams(1,:);
currVel = currentParams(2,:);
currAcc = currentParams(3,:)

nextPose(1,:) = currPose;

for i=1:nPts
    t = t+dt;  
    nextPose(i+1,:) = currPose + currVel*t + 0.5*currAcc*t^2;% - [0 0 0.5*9.81*dt^2];    
    currPose = nextPose(i+1,:)
    %currVel = currVel + currAcc*dt;% - [0 0 9.81*dt^2];
end
end