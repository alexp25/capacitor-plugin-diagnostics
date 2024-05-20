import { WebPlugin } from '@capacitor/core';

import { PERMISSION, PERMISSION_STATUS, DiagnosticPlugin, LOCATION_AUTHORIZATION_MODE, RequestAuthorizationOptions } from './definitions';

export class DiagnosticWeb extends WebPlugin implements DiagnosticPlugin {
  permission = PERMISSION;
  permissionStatus = PERMISSION_STATUS;
  locationAuthorizationMode = LOCATION_AUTHORIZATION_MODE;

  async isFeatureAuthorized(_options: RequestAuthorizationOptions): Promise<{ authorized: boolean }> {
    throw new Error('Method not implemented.');
  }

  async requestAuthorization(_options: RequestAuthorizationOptions): Promise<void> {
    throw new Error('Method not implemented.');
  }

  async isGpsLocationEnabled(): Promise<{ enabled: boolean }> {
    throw new Error('Method not implemented.');
  }

  async getCurrentBatteryLevel(): Promise<{ level: number }> {
    throw new Error('Method not implemented.');
  }
}
