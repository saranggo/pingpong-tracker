function toGoPt = getOptReachablePt(method, trajPTSin)
[r c] = size(trajPTSin); toGoPt=[0 0 0];
switch method
    case 'FirstPointIn'
        if r~=1
            toGoPt = trajPTSin(2,:);
        end
    case 'LeastJointMotion'        
end
end