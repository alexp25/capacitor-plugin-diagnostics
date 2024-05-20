import { registerPlugin } from '@capacitor/core';

import type { DiagnosticPlugin } from './definitions';

const Diagnostic = registerPlugin<DiagnosticPlugin>('Diagnostic', {
  web: () => import('./web').then(m => new m.DiagnosticWeb()),
});

export * from './definitions';
export { Diagnostic };
