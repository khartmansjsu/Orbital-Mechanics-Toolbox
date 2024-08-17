function [] = plotOrbits(dt,tf,Primary,Satellites)

% Satellites is a cell array containing all the massless orbiting bodies
% Primary    is the object which the satellites are orbiting
% dt         is the time step of the simulation in minutes
% tf         represents the duration of the simulation in seconds

% Check if there is enough information to do the simulation
for i = 1:length(Satellites)
    if isempty(Satellites{i}.trueAnomoly) && isempty(Satellites{i}.rMagnitude)
        disp('Not enough information to run simulation.')
        disp('Need initial values of either true anomoly or magnitude of distance vector')
        disp('for all satellites. Check that all satellites have initial positions defined.')
        return
    end
    if isempty(Satellites{i}.trueAnomoly) && ~isempty(Satellites{i}.rMagnitude)
        Satellites{i} = Satellites{i}.calculaterMagnitude;
    end
    if isempty(Satellites{i}.rMagnitude) && ~isempty(Satellites{i}.trueAnomoly)
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