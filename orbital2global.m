function [xloc,yloc,zloc] = orbital2global(Omeg,i,w,v,radius)

g2Omeg = [cos(Omeg) -sin(Omeg) 0;
          sin(Omeg)  cos(Omeg) 0;
              0          0     1];

Omeg2i = [1     0       0;
          0 cos(i) -sin(i);
          0 sin(i) cos(i)];

Omeg2omeg = [cos(w) -sin(w) 0;
             sin(w)  cos(w) 0;
                 0       0  1];

omeg2True = [cos(v) -sin(v) 0;
             sin(v)  cos(v) 0;
                 0       0  1];

coords = g2Omeg*Omeg2i*Omeg2omeg*omeg2True*[radius;0;0];

xloc = coords(1); yloc = coords(2); zloc = coords(3);
end
