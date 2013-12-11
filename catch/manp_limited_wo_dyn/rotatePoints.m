function RTP = rotatePoints(point,initpoint)
    alpha = acos(initpoint(1)/norm(initpoint-[0,0,0]));
    beta =  acos(initpoint(2)/norm(initpoint-[0,0,0]));
    gamma = acos(initpoint(3)/norm(initpoint-[0,0,0]));
    
    Rz = [cos(-alpha) -sin(-alpha) 0;
          sin(-alpha)  cos(-alpha) 0;
          0           0          1];
     
    Rx = [1 0           0         ;
          0 cos(gamma)  -sin(gamma);
          0 sin(gamma)   cos(gamma)];
      
    R0_1=Rz*Rx; 
    
    TP = (point'-initpoint')';
    RTP = R0_1'*TP';
end