function t_final = getTfinal(TrajType, toGoPt, ballVelocity)
    switch TrajType
        case 1 
            startPoint = [20 0 6];
            finalPoint = toGoPt;            
            distance = norm(startPoint - finalPoint);
            velocity = ballVelocity;
            t_final = distance/velocity;
        case 2   

    end
end