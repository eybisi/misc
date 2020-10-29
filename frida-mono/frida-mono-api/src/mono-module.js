"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.default = void 0;
let monoModule = Process.findModuleByName('mono.dll');

if (!monoModule) {
  const monoThreadAttach = Module.findExportByName(null, 'mono_thread_attach');
  if (monoThreadAttach) monoModule = Process.findModuleByAddress(monoThreadAttach);
}

if (!monoModule) throw new Error('Cant find mono!');
var _default = monoModule;
exports.default = _default;