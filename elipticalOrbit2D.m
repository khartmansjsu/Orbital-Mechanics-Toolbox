%% Demo of eliptical orbit calculation in 2D
%  Going to use the NORAD25847 satellite as a demo system

load System.mat
primaryGM = NORAD25847.primaryGM;
rPeriapsis = NORAD25847.rPeriapsis;
rApoapsis = NORAD25847.rApoapsis;
semiMajorAxis = 0.5 * (rPeriapsis + rApoapsis);
e = NORAD25847.eccentricity;

%% Set up Earth geometry
% Define the curve of Earth's surface
th = 0:pi/50:2*pi;
xunit = Earth.Radius * cos(th) + 0; % Earth center at x equal to zero
yunit = Earth.Radius * sin(th) + 0; % Earth center at y equal to zero

%% Set up time marching parameters and initial conditions
tf = NORAD25847.period;
dt = tf/200;

t  = 0;

rMagnitude  = NORAD25847.rPeriapsis; % corresponds to true anomoly = 0
meanAnomoly = 0;                     % corresponds to true anomoly = 0
trueAnomoly = 0;

while t < tf
    t = t + dt;
    % Plot Earth
    plot(xunit, yunit,'b'); hold on; axis equal;

    % Plot satellite
    xloc = rMagnitude*cos(trueAnomoly);
    yloc = rMagnitude*sin(trueAnomoly);

    plot(xloc,yloc,'r-o'); % hold off;
    % exportgraphics(gca, "orbit.gif", Append=true);
    %% Update position and store x,y coord
    
    n  = sqrt ( primaryGM / ((semiMajorAxis*1000)^3) );
    meanAnomoly = meanAnomoly + n*(dt*60); % convert to seconds
    E = meanAnomoly; %initial guess
    error = meanAnomoly - (E - e*sin(E));
    while abs(error) > 1e-5
        E = E + error;
        error = meanAnomoly - (E - e*sin(E));
    end
    % val = (cos(E) - e) / (1 - e*cos(E))
    % trueAnomoly = acos( val );
    b = e / ( 1 + sqrt(1 - e*e) );
    trueAnomoly = E + 2*atan( b*sin(E) / (1 - b*cos(E)) );
    rMagnitude = semiMajorAxis*(1-e*e) / ...
        (1 + e*cos(trueAnomoly));


end