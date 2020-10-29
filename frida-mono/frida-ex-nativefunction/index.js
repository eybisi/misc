"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.default = void 0;

class ExNativeFunction {
  constructor(address, retType = 'void', argTypes = [], abi = 'default') {
    const native = new NativeFunction(address, retType, argTypes, abi);
    native.address = address;
    native.retType = retType;
    native.argTypes = argTypes;
    native.abi = abi;

    native.nativeCallback = callback => {
      return new NativeCallback(callback, retType, argTypes, abi);
    };

    native.intercept = (options = {}) => {
      return Interceptor.attach(address, options);
    };

    native.replace = callback => {
      return Interceptor.replace(address, native.nativeCallback(callback));
    };

    return native;
  }

}

global.ExNativeFunction = ExNativeFunction;
var _default = ExNativeFunction;
exports.default = _default;