export interface DiagnosticPlugin {

  // generic
  isFeatureAuthorized(options: RequestAuthorizationOptions): Promise<RequestAuthorizationStatus>; 
  requestAuthorization(options: RequestAuthorizationOptions): Promise<void>;

  // specific
  isGpsLocationEnabled(): Promise<{ enabled: boolean }>;
  getCurrentBatteryLevel(): Promise<{ level: number }>;

  // Constants for permissions
  permission: { [key: string]: string };
  permissionStatus: { [key: string]: string };
  locationAuthorizationMode: { [key: string]: string };
}

export interface RequestAuthorizationOptions {
  feature: string;
  mode?: string;
}

export interface RequestAuthorizationStatus {
  authorized: boolean;
  state?: string;
}

// Export the constant values
export const PERMISSION_STATUS = {
  GRANTED: "granted",
  GRANTED_WHEN_IN_USE: "authorized_when_in_use",
  DENIED_ONCE: "denied_once",
  DENIED_ALWAYS: "denied_always",
  NOT_REQUESTED: "not_requested",
  PROMPT: "prompt"
};

export const LOCATION_AUTHORIZATION_MODE = {
  ALWAYS: 'always',
  WHEN_IN_USE: 'when_in_use'
};

// Export the constant values
export const PERMISSION = {
  ACCEPT_HANDOVER: "ACCEPT_HANDOVER",
  ACCESS_BACKGROUND_LOCATION: "ACCESS_BACKGROUND_LOCATION",
  ACCESS_COARSE_LOCATION: "ACCESS_COARSE_LOCATION",
  ACCESS_FINE_LOCATION: "ACCESS_FINE_LOCATION",
  ACCESS_MEDIA_LOCATION: "ACCESS_MEDIA_LOCATION",
  ACTIVITY_RECOGNITION: "ACTIVITY_RECOGNITION",
  ADD_VOICEMAIL: "ADD_VOICEMAIL",
  ANSWER_PHONE_CALLS: "ANSWER_PHONE_CALLS",
  BLUETOOTH_ADVERTISE: "BLUETOOTH_ADVERTISE",
  BLUETOOTH_CONNECT: "BLUETOOTH_CONNECT",
  BLUETOOTH_SCAN: "BLUETOOTH_SCAN",
  BODY_SENSORS: "BODY_SENSORS",
  BODY_SENSORS_BACKGROUND: "BODY_SENSORS_BACKGROUND",
  CALL_PHONE: "CALL_PHONE",
  CAMERA: "CAMERA",
  GET_ACCOUNTS: "GET_ACCOUNTS",
  NEARBY_WIFI_DEVICES: "NEARBY_WIFI_DEVICES",
  POST_NOTIFICATIONS: "POST_NOTIFICATIONS",
  PROCESS_OUTGOING_CALLS: "PROCESS_OUTGOING_CALLS",
  READ_CALENDAR: "READ_CALENDAR",
  READ_CALL_LOG: "READ_CALL_LOG",
  READ_CONTACTS: "READ_CONTACTS",
  READ_EXTERNAL_STORAGE: "READ_EXTERNAL_STORAGE",
  READ_MEDIA_AUDIO: "READ_MEDIA_AUDIO",
  READ_MEDIA_IMAGES: "READ_MEDIA_IMAGES",
  READ_MEDIA_VIDEO: "READ_MEDIA_VIDEO",
  READ_PHONE_NUMBERS: "READ_PHONE_NUMBERS",
  READ_PHONE_STATE: "READ_PHONE_STATE",
  READ_SMS: "READ_SMS",
  RECEIVE_MMS: "RECEIVE_MMS",
  RECEIVE_SMS: "RECEIVE_SMS",
  RECEIVE_WAP_PUSH: "RECEIVE_WAP_PUSH",
  RECORD_AUDIO: "RECORD_AUDIO",
  SEND_SMS: "SEND_SMS",
  USE_SIP: "USE_SIP",
  UWB_RANGING: "UWB_RANGING",
  WRITE_CALENDAR: "WRITE_CALENDAR",
  WRITE_CALL_LOG: "WRITE_CALL_LOG",
  WRITE_CONTACTS: "WRITE_CONTACTS",
  WRITE_EXTERNAL_STORAGE: "WRITE_EXTERNAL_STORAGE"
};