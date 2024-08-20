function [] = plotOrbits(Primary,Satellites,tf,dt)
% PLOTORBITS plot the orbits of some massless bodies about a primary
%   PLOTORBITS(X1,X2,X3,X4) generates a plot of orbital paths of bodie(s) X2
%   about body X1 for time X3 with time interval X4.
%
%   X1: object of type Primary
%   X2: cell array of object(s) of type Satellite (add Primary support later)
%   X3: [minutes]
%   X4: [minutes]
%
%   Class support for inputs X3,X4:
%      float: double, single
%
%   Class support for inputs X1:
%      Primary
%   Class support for inputs X2:
%      Cell array of Primary or Satellite
%
%   See also Primary, Satellite, elipticalOrbit2D.

% Check if there is enough information to do the simulation
for i = 1:length(Satellites)
    if isempty(Satellites{i}.trueAnomoly)
        disp('Not enough information to run simulation.')
        disp('Need initial value of true anomoly for all satellites.')
        disp('Check that all satellites have initial positions defined.')
        return
    end
    if isempty(Satellites{i}.rMagnitude) && ~isempty(Satellites{i}.trueAnomoly)
        disp('Initial value of satellite radius not provided. Computing now.')
        Satellites{i} = Satellites{i}.calculaterMagnitude;
    end
end

t  = 0;

[X,Y,Z] = sphere(20);
while t <= tf
    % Plot primary
    surf(Primary.Radius*X,Primary.Radius*Y,Primary.Radius*Z,...
        FaceColor="c"); axis equal;
    hold on
    
    % Update the positions of every satellite and plot their position in
    % space
    for i = 1:length(Satellites)
        % temporarily store the satellite as a separate variable
        % Kinda doing this because it looks cleaner, but I don't know if
        % this is better for optimization. Should I explore handle classes
        % here?
        sat = Satellites{i};
        % Convert to cartesian coordinates
        [xloc,yloc,zloc] = orbital2global(sat.longOfAscendingNode,sat.inclination,...
                                          sat.argumentOfPeriapsis,sat.trueAnomoly,...
                                          sat.rMagnitude);
        % Plot current satellite
        plot3(xloc,yloc,zloc,'k-o');

        % Update position of current satellite
        sat = sat.updatePosition(dt);
        
        % update actual satellite
        Satellites{i} = sat;
    end
    % xlim([-8e3,8e3]); ylim([-8e3,8e3]); zlim([-8e3,8e3]);
    xlabel('Vernal Equinox');
    title(['Time (minutes): ',num2str(t)],'FontSize',20)
    % hold off
    exportgraphics(gca, "orbits.gif", Append=true);

    t = t + dt;
end

end