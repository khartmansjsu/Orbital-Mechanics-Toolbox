Earth = Primary;
Earth.Radius = 6378.14 * 1000;         % Radius of Earth [ m ]
Earth.GM     = 3.986005e14;            % GM of Earth   [ m3/s2 ]

sat1 = Satellite; sat2 = Satellite;
sat1.eccentricity = 0;
sat2.eccentricity = 0;

sat1.semiMajorAxis = Earth.Radius + (460 * 1000);  % radius of orbit 1 [ m ]
sat2.semiMajorAxis = Earth.Radius + (1000 * 1000); % radius of orbit 2 [ m ]

%% setup time, space, and initial conditions
t0 = 0;
sat1 = sat1.calculatePeriod(Earth.GM);
sat2 = sat2.calculatePeriod(Earth.GM);
tf = 2.5*sat1.period; % set time to two and a half periods of a circular orbit at given altitude
dt = tf/100;

sat1.meanAnomoly = 0;
sat2.meanAnomoly = 0;

% Satellites' initial position - call this the perigee
sat1.position = [sat1.semiMajorAxis, 0]; % circular orbits, so this holds
sat2.position = [sat2.semiMajorAxis, 0];
%% Define the Earth's curve

% Define the curve of Earth's surface
th = 0:pi/50:2*pi;
xunit = Earth.Radius * cos(th) + 0; % Earth center at x equal to zero
yunit = Earth.Radius * sin(th) + 0; % Earth center at y equal to zero

%% Run sim


% mean anomoly: the fraction of the orbital period which has elapsed
% since perigee

t  = 0;
t_ = 0;

while t <= tf
    t = t_ + dt;
    % Plot Earth
    plot(xunit, yunit); hold on; axis equal;

    sat1 = sat1.updatePosition(Earth.GM,dt);
    sat2 = sat2.updatePosition(Earth.GM,dt);

    plot(sat1.position(1),sat1.position(2),'r-o');
    plot(sat2.position(1),sat2.position(2),'r-o'); hold off;
    xlim([-8e6,8e6]); ylim([-8e6,8e6]);
    exportgraphics(gca, "orbits.gif", Append=true);

    t_ = t;
end