var SHEET_NAME = "Sheet1";

var SCRIPT_PROP = PropertiesService.getScriptProperties(); // new property service

function doGet(e) {
  return handleResponse(e);
}
function doPost(e) {
  return handleResponse(e);
}
function handleResponse(e) {
  var sheet = SpreadsheetApp.getActiveSpreadsheet().getActiveSheet();
  var data = JSON.parse(e.postData.contents); 

  if (sheet.getLastRow() === 0) {
    sheet.appendRow([
      'Device ID',
      'Application ID',
      'Device EUI',
      'Device Address',
      'Received At',
      'Port',
      'Count',
      'Payload',
      'Alarm Status',
      'Altitude',
      'BatV',
      'FW',
      'HDOP',
      'LON',
      'Latitude',
      'Longitude',
      'MD',
      'Pitch',
      'Roll',
      'Gateway ID',
      'EUI',
      'RSSI'
    ]);
  }

  var rowData = [];

  rowData.push(data.end_device_ids.device_id);
  rowData.push(data.end_device_ids.application_ids.application_id);
  rowData.push(data.end_device_ids.dev_eui);
  rowData.push(data.end_device_ids.dev_addr);
  rowData.push(data.received_at);
  rowData.push(data.uplink_message.f_port);
  rowData.push(data.uplink_message.f_cnt);
  rowData.push(data.uplink_message.frm_payload);
  
  // Push each decoded payload field
  rowData.push(data.uplink_message.decoded_payload.ALARM_status);
  rowData.push(data.uplink_message.decoded_payload.Altitude);
  rowData.push(data.uplink_message.decoded_payload.BatV);
  rowData.push(data.uplink_message.decoded_payload.FW);
  rowData.push(data.uplink_message.decoded_payload.HDOP);
  rowData.push(data.uplink_message.decoded_payload.LON);
  rowData.push(data.uplink_message.decoded_payload.Latitude);
  rowData.push(data.uplink_message.decoded_payload.Longitude);
  rowData.push(data.uplink_message.decoded_payload.MD);
  rowData.push(data.uplink_message.decoded_payload.Pitch);
  rowData.push(data.uplink_message.decoded_payload.Roll);

  // For each gateway in rx_metadata, add a row with that gateway's data
  for (var i = 0; i < data.uplink_message.rx_metadata.length; i++) {
    var gateway = data.uplink_message.rx_metadata[i];
    var newRowData = rowData.slice();  // Make a copy of the base rowData

    newRowData.push(gateway.gateway_ids.gateway_id);
    newRowData.push(gateway.gateway_ids.eui);
    newRowData.push(gateway.rssi);
    
    sheet.appendRow(newRowData);  // Write the new row of data
  }
}

function setup() {
  var doc = SpreadsheetApp.getActiveSpreadsheet();
  SCRIPT_PROP.setProperty("key", doc.getId());
}
