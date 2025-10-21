clc; clear all;

%% Extracting four different coordinates of the end-devices and the specific RSSIs from the Google Spreadsheet

ID = '1N9xYSNLLxFOW4JdT0HmyA89dAOLgWfWVIlHAA4i-hZ4';
sheet_name = 'Sheet1';
url_name = sprintf('https://docs.google.com/spreadsheets/d/%s/gviz/tq?tqx=out:csv&sheet=%s', ID, sheet_name);

% all the data extracted in a table
sheet_data = webread(url_name);

latitudine = sheet_data.Latitude;
longitudine = sheet_data.Longitude;
altitudine = sheet_data.Longitude;
gateway = char(sheet_data.GatewayID);
gateway_eui = char(sheet_data.EUI);
RSSI = sheet_data.RSSI;

output_data = table([],[],[],[],[],'VariableNames',{'gw_latitude','gw_longitude','gw_altitude','gw_ID','gw_EUI'});
coord_data = table([],[],[],[],'VariableNames',{'m_lat','m_long','m_alt','m_rssi'});
j = 1;
[n,m] = size(gateway);
result = char('                    ');
cell_gateway = cellstr(gateway);
cell_result = cellstr(result);

%iterate through the list of gateways
for i = 1 : size(gateway,1)
    %check if the gateway is on the resulted list
    if ~(ismember(cell_gateway(i,:),cell_result))

        % find four different coordinates for each different gateway

        [lat,long,alt,rssi] = provide_4_diff_coords(sheet_data,gateway(i,:));

        if(lat ~= 0) % if it's equal to 0, it means that it could not be found 4 diff coords

            %find the gateway coordinates
            [gw_latitude,gw_longitude,gw_altitude] = find_gateway_coords(lat,long,alt,rssi);
            
            %save measured coords.
            for k = 1:4
                m_lat = lat(k);
                m_long = long(k);
                m_alt = alt(k);
                m_rssi = rssi(k);

                data2 = table(m_lat,m_long, m_alt, m_rssi);
                coord_data = [coord_data;data2];
            end

            %% todo . insert gw data to a CSV file
            gw_ID = convertCharsToStrings(gateway(i,:));
            gw_EUI = convertCharsToStrings(gateway_eui(i,:));
            data = table(gw_latitude,gw_longitude, gw_altitude, gw_ID, gw_EUI);
            output_data = [output_data;data];

        end
        cell_result(j,:) = cellstr(gateway(i,:));
        j = j + 1;
    end
end

writetable(output_data,'indentified_gws.csv');
writetable(coord_data,'coord_data.csv');

