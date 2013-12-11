function [trajPTS, trajLimits] = getTrajectoryPts(type, gamma)
k =1;
%GETTING ALL TRAJECTORY POINTS    
switch type
        case 'StLine'
            for i=20:-gamma:gamma
                trajPTS(k,:)=[i, 0, 6];
                k= k+1;
            end
        case 'Parabola'
            gamma = 0.4*gamma;
            beta = gamma*2*pi;
            startPt = [20 0 0]; ellipseCenter = [10 0 0]; endPt=[0 0 0]; majAx = 10; minAx=5;
            trajPTS(k,:)=startPt; k=k+1;
            for i=startPt(1):-gamma:0
                    trajPTS(k,:)=[ellipseCenter(1)+majAx*cos(-beta*i), ellipseCenter(2), ellipseCenter(3)+minAx*sin(-beta*i)];
                    k = k+1; 
            end    
end
minaX = min(trajPTS(:,1)); minaY = min(trajPTS(:,2)); minaZ = min(trajPTS(:,3));
maxaX = max(trajPTS(:,1)); maxaY = max(trajPTS(:,2)); maxaZ = max(trajPTS(:,3));

trajLimits = [minaX-1 maxaX+1 minaY-1 maxaY+1 minaZ-1 maxaZ+1];
end