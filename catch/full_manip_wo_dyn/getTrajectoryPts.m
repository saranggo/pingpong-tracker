function [trajPTS trajPTSin trajPTSout trajPTSon] = getTrajectoryPts(type, gamma, ellipsoidParams)
k =1;
%GETTING ALL TRAJECTORY POINTS    
switch type
        case 1
            for i=20:-gamma:gamma
                trajPTS(k,:)=[i, 0, 6];
                k= k+1;
            end
end

%CLASSIFYING THE POINTS
p=1; q=1; r=1;
trajPTSin(1,:) = [0, 0, 0]; trajPTSout(1,:) = [0, 0, 0]; trajPTSon(1,:) = [0, 0, 0]; 
for i=1:length(trajPTS)
    check = ((trajPTS(i,1)-ellipsoidParams(1))^2/ellipsoidParams(4)^2) + ... 
            ((trajPTS(i,2)-ellipsoidParams(2))^2/ellipsoidParams(5)^2) + ...
            ((trajPTS(i,3)-ellipsoidParams(3))^2/ellipsoidParams(6)^2);
    %[trajPTS(i,1), check]    
    check = check +0.73;
    
    if(check<1)
        trajPTSin(p,:) = trajPTS(i,:);
        p = p+1;
    elseif(check>1)
        trajPTSout(q,:) = trajPTS(i,:);
        q = q+1;
    else
        trajPTSon(r,:) = trajPTS(i,:);
        r = r+1;
    end    
end
end