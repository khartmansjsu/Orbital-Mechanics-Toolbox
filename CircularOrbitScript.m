%% Circular Orbit Plotter

% Primary: Earth
% Sattelite: negligible mass
% Altitude: 200 km AGL

%% Params

Re = 6378.14 * 1000;         % Radius of Earth [ m ]
GM = 3.986005e14;            % GM of Earth   [ m3/s2 ]
r  = Re + (460 * 1000);      % radius of orbit [ m ]
e  = 0;                      % eccentricity is zero because the orbit is cirular
n  = sqrt ( GM/r/r/r );      % mean motion, used to compute satellite position

%% Setup time and space

t0 = 0;
p = sqrt ( 4 * pi*pi * r*r*r / GM ); % period of orbit in seconds
tf = 0.25*p; % set time to two and a half periods of a circular orbit at given altitude
dt = tf/100;

%% Plot the Earth

% Define the curve of Earth's surface
th = 0:pi/50:2*pi;
xunit = Re * cos(th) + 0; % Earth center at x equal to zero
yunit = Re * sin(th) + 0; % Earth center at y equal to zero

%% Time sequence
% Satellite's initial position - call this the perigee
sx0 = r;
sy0 = 0;
% mean anomoly: the fraction of the orbital period which has elapsed
% since perigee
M0 = 0; % mean anomoly at initial condition i.e. orbit starts at perigee
M  = M0;
t  = 0;
t_ = t0;

while t <= tf
    t = t_ + dt;
    % Plot Earth
    plot(xunit, yunit); hold on; axis equal;

    M = M + n*(t - t_);
    v = M + 2*e*sin(M) + 1.25*e*e*sin(2*M);
    sx = r*cos(v); % satellite x position
    sy = r*sin(v); % satellite y position
    plot(sx,sy,'r-o'); hold off;
    exportgraphics(gca, "orbit.gif", Append=true);

    t_ = t;
end
