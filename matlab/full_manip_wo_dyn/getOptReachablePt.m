function toGoPt = getOptReachablePt(method, trajPTSin)
switch method
    case 'FirstPointIn'
        toGoPt = trajPTSin(2,:);        
        
    case 'LeastJointMotion'        
end
end