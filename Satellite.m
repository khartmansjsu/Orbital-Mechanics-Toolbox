classdef Satellite
    properties
        primaryGM               % m3/s2
        rPeriapsis              % km
        rApoapsis               % km
        longOfAscendingNode     % radians
        argumentOfPeriapsis     % radians
        inclination             % radians
        eccentricity            % non-dim
        period                  % minutes
        semiMajorAxis           % km
        meanAnomoly             % radians
        trueAnomoly             % radians
        rMagnitude              % km
    end
    methods
        function obj = Satellite
            obj.eccentricity = 0; % circular orbit by default
            obj.meanAnomoly  = 0; % at periapsis by default
            obj.primaryGM    = 3.986005e14; % Earth by default [m3/s2]
            disp('Reminder: Mean of Earth is 6,378.14 km...')
        end
        function obj = calculatePeriod(obj)
            if isempty(obj.semiMajorAxis) % if this param has not been defined
                disp('Semi major axis not yet defined. Checking if it can')
                disp('be defined by apoapsis and periapsis radii...')
                if (obj.rApoapsis && obj.rPeriapsis)
                    disp('Periapsis and apoapsis are defined! Using these to')
                    disp('compute semi major axis.')
                    obj.semiMajorAxis = 0.5 * (obj.rApoapsis + obj.rPeriapsis);
                end
            end
            a = obj.semiMajorAxis * 1000; % convert to m
            obj.period = sqrt( 4 * pi*pi * a*a*a / obj.primaryGM ) / 60;
        end
        function obj = updatePosition(obj,dt)
            e = obj.eccentricity;
            if e < 0.1    % approximate method...not sure if 0.1 is a good metric, error is e^3
                n  = sqrt ( obj.primaryGM / ((obj.semiMajorAxis*1000)^3) );
                obj.meanAnomoly = obj.meanAnomoly + n*(dt*60); % convert to seconds
                obj.trueAnomoly = obj.meanAnomoly ...
                    + 2*e*sin(obj.meanAnomoly) ...
                    + 1.25*e*e*sin(2*obj.meanAnomoly);
                obj.rMagnitude = obj.semiMajorAxis*(1-e*e) / ...
                    (1 + e*cos(obj.trueAnomoly));
            else          % more accurate iterative method
                n  = sqrt ( obj.primaryGM / ((obj.semiMajorAxis*1000)^3) );
                obj.meanAnomoly = obj.meanAnomoly + n*(dt*60); % convert to seconds
                E = obj.meanAnomoly; %initial guess
                error = E - (E - e*sin(E));
                while abs(error) > 1e-5
                    E = E + error;
                    error = obj.meanAnomoly - (E - e*sin(E));
                end
                b = e / ( 1 + sqrt(1 - e*e) );
                obj.trueAnomoly = E + 2*atan( b*sin(E) / (1 - b*cos(E)) );
                % obj.trueAnomoly = acos( (cos(E) - e) / (1 - e*cos(E)) );
                obj.rMagnitude = obj.semiMajorAxis*(1-e*e) / ...
                    (1 + e*cos(obj.trueAnomoly));
            end
        end
        function obj = calculateEccentricity(obj)
            GM = obj.primaryGM;  % re-define for neatness
            disp('Updating semi-major axis...')
            obj.semiMajorAxis = 0.5 * (obj.rApoapsis + obj.rPeriapsis);
            Vp = sqrt( GM*obj.rApoapsis/ obj.rPeriapsis / obj.semiMajorAxis / 1000);
            obj.eccentricity = obj.rPeriapsis*1000*Vp^2/GM - 1;
        end
    end
end