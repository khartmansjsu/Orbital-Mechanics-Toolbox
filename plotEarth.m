function [] = plotEarth()

EarthRadius = 6.37814e+03;
[X,Y,Z] = sphere(20);
surf(EarthRadius*X,EarthRadius*Y,EarthRadius*Z,...
    FaceColor="c"); axis equal;
hold on

end