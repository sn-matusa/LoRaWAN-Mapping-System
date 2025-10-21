 %% Calculate geoid coordinates of the gateway

function [gw_lat,gw_lon,gw_alt] = find_gateway_coords(lat,long,alt,rssi)

%% fixed constants

% attenuation of signal - can be modified, depending on the local area
n = 3.6667;
% RSSI of the unit distance (1 meter) - need to be measured in advanced
A = -29;

%% Reference ellipsoid for World Geodetic System 1984
wgs84 = wgs84Ellipsoid('meter');

%% First end-device coordinates

p(1).lat = lat(1);
p(1).long = long(1);
p(1).altitude = alt(1);

% convert the coordinates from World Geodetic System to Earth-centered, Earth-fixed coordinate system
[p(1).x,p(1).y,p(1).z] = geodetic2ecef(wgs84,p(1).lat,p(1).long,p(1).altitude);

%calculate the distance between the first end-node and the gateway based on RSSI
dist1 = 10.^((A-rssi(1))/(10*n));

%% Second end-device coordinates
p(2).lat = lat(2);
p(2).long = long(2);
p(2).altitude = alt(2);

% convert the coordinates from World Geodetic System to Earth-centered, Earth-fixed coordinate system
[p(2).x,p(2).y,p(2).z] = geodetic2ecef(wgs84,p(2).lat,p(2).long,p(2).altitude);

% calculate the distance between second end-device and the gateway based on the RSSI
dist2 = 10.^((A-rssi(2))/(10*n));

%% Third end-device coordinates
p(3).lat = lat(3);
p(3).long = long(3);
p(3).altitude = alt(3);

% convert the coordinates from World Geodetic System to Earth-centered, Earth-fixed coordinate system
[p(3).x,p(3).y,p(3).z] = geodetic2ecef(wgs84,p(3).lat,p(3).long,p(3).altitude);

% calculate the distance between the second end-device and the gateway based on the RSSI
dist3 = 10.^((A-rssi(3))/(10*n));

%% Fourth end-device coordinates
p(4).lat = lat(4);
p(4).long = long(4);
p(4).altitude = alt(4);

% convert the coordinates from World Geodetic System to Earth-centered, Earth-fixed coordinate system
[p(4).x,p(4).y,p(4).z] = geodetic2ecef(wgs84,p(4).lat,p(4).long,p(4).altitude);

% calculate the distance between the fourth end-device and the gateway based on the RSSI
dist4 = 10.^((A-rssi(4))/(10*n));

%% Finding gateway coordinates

% calculate the initial Guess for GPS equations
x0 = (p(1).x + p(2).x + p(3).x + p(4).x) / 4;
y0 = (p(1).y + p(2).y + p(3).y + p(4).y) / 4;
z0 = (p(1).z + p(2).z + p(3).z + p(4).z) / 4;
Guess = [x0,y0,z0];

% matrix form - the coordinates of the four end-devices and distances btw them and gw
A = [p(1).x , p(2).x , p(3).x, p(4).x];
B = [p(1).y , p(2).y , p(3).y, p(4).y];
C = [p(1).z , p(2).z , p(3).z, p(4).z];
D = [dist1 , dist2 , dist3, dist4];

% vector A length
LA = length(A);

% solving GPS equations
% Result vector contains the ECEF coordinates of the gateway
[Result,~,~] = MVNewtonsInputs(Guess,A,B,C,D,LA);

% Convert the gateway coordinates from Earth-centered, Earth-fixed
% coordinate system to World Geodetic System 1984
[gw_lat,gw_lon,gw_alt] = ecef2geodetic(wgs84,Result(1),Result(2),Result(3));

% Earth Gravitational Model EGM96
% N_egm96 = egm96geoid(gw_lat,gw_lon);

% Earth Gravitational Model EGM2008 
% N_egm2008 = geoidheight(gw_lat,gw_lon,'egm2008');

end
