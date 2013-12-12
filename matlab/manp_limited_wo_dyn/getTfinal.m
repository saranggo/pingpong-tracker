function t_final = getTfinal(TrajType, toGoPt, ballVelocity)
    switch TrajType
        case 'StLine' 
            startPoint = [20 0 6];
            finalPoint = toGoPt;            
            distance = norm(startPoint - finalPoint);
            velocity = ballVelocity;
            t_final = distance/velocity;
        case 'Parabola'   
            startPoint = [20 0 0];
            finalPoint = toGoPt;            
            distance = norm(startPoint - finalPoint);
            velocity = ballVelocity;
            t_final = distance/velocity;
    end
end