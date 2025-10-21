function [lat,long,alt,rssi] = provide_4_diff_coords(sheet_data,rec_gw)
% the function returns four vectors of size 4 each,
% or return 0 in case the coordinates couldn't be found

%% extracting the useful data from the input data
latitudine = sheet_data.Latitude;
longitudine = sheet_data.Longitude;
altitudine = sheet_data.Altitude;
gateway = char(sheet_data.GatewayID);
RSSI = sheet_data.RSSI;

%% initializing the output variables
lat(1) = -1;
long(1) = -1;
alt(1) = -1;
rssi(1) = 0;

lat(2) = -1;
long(2) = -1;
alt(2) = -1;
rssi(2) = 0;

lat(3) = -1;
long(3) = -1;
alt(3) = -1;
rssi(3) = 0;

lat(4) = -1;
long(4) = -1;
alt(4) = -1;
rssi(4) = 0;

coords_found = 0;

%% interating through input data for finding the coordinates
for i = 1 : size(gateway,1)
    if gateway(i,:) == rec_gw
        if lat(1) == -1 && coords_found == 0 && latitudine(i) ~= 0 
            lat(1) = latitudine(i);
            long(1) = longitudine(i);
            alt(1) = altitudine(i);
            rssi(1) = RSSI(i);
            coords_found = 1;
            
        elseif lat(2) == -1 && coords_found == 1 && latitudine(i) ~= 0 
            if  distance(lat(1),long(1),latitudine(i),longitudine(i),wgs84Ellipsoid('meter')) >= 50
                lat(2) = latitudine(i);
                long(2) = longitudine(i);
                alt(2) = altitudine(i);
                rssi(2) = RSSI(i);
                coords_found = 2;
                
            end
        elseif lat(3) == -1 && coords_found == 2 && latitudine(i) ~= 0  
            if ( distance(lat(1),long(1),latitudine(i),longitudine(i),wgs84Ellipsoid('meter')) >= 50 &&  ...
                    distance(lat(2),long(2),latitudine(i),longitudine(i),wgs84Ellipsoid('meter')) >= 50 )
                lat(3) = latitudine(i);
                long(3) = longitudine(i);
                alt(3) = altitudine(i);
                rssi(3) = RSSI(i);
                coords_found = 3;
                
            end
        elseif lat(4) == -1 && coords_found == 3 && latitudine(i) ~= 0  
            if ( distance(lat(1),long(1),latitudine(i),longitudine(i),wgs84Ellipsoid('meter')) >= 50 &&  ...
                    distance(lat(2),long(2),latitudine(i),longitudine(i),wgs84Ellipsoid('meter')) >= 50 && ...
                    distance(lat(3),long(3),latitudine(i),longitudine(i),wgs84Ellipsoid('meter')) >= 50 )
                lat(4) = latitudine(i);
                long(4) = longitudine(i);
                alt(4) = altitudine(i);
                rssi(4) = RSSI(i);
                  
                return;
            end

        end
    end
end


%% it have not been found four different coordinates
if coords_found < 4
    lat = 0;
    long = 0;
    alt = 0;
    rssi = 0;
end

end
