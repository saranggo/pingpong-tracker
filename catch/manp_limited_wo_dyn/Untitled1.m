syms the1 the2 the3
x_fow = l1 + l2*cos(the1)*cos(the2) + l3*cos(the1)*cos(the2)*cos(the3) - l3*cos(the1)*sin(the2)*sin(the3);
y_fow =  sin(the1)*(l3*cos(the2 + the3) + l2*cos(the2));
z_fow = a + l3*sin(the2 + the3) + l2*sin(the2);

m=sin(the1)*cos(the2);
md = diff(m,the1)+diff(m,the2);
xd_fow = diff(x_fow,the1)+diff(x_fow,the2)+diff(x_fow,the3);
yd_fow = diff(y_fow,the1)+diff(y_fow,the2)+diff(y_fow,the3);
zd_fow = diff(z_fow,the1)+diff(z_fow,the2)+diff(z_fow,the3);