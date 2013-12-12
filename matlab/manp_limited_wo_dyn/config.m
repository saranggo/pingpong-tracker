global a l1 l2 l3 table_height th1 th2 th3 joint_limits dh_table

a = 4; l1 =4; l2 =4; l3 =4; table_height = 4;
th1=0; th2=0; th3=0;

joint_limits = [-pi/2, -pi/2, -pi/2;
                 pi/2,  pi/2,  pi/2];

dh_table = [0, a, l1 , 0;
            th1, 0, 0, 90;
            th2, 0, l2,0
            th3, 0, l3 ,0;];