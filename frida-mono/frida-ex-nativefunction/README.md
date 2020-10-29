# frida-ex-nativefunction
This module provides you with an extended NativeFunction class.  
It is meant to be used inside of a frida script.  
See for example: [frida-compile](https://github.com/frida/frida-compile)



## Example
```
const ExNativeFunction = require('frida-ex-nativefunction')

const openAddr = Module.findExportByName('libc.so', 'open')
const open = new ExNativeFunction(openAddr, 'int', ['pointer', 'int'])

console.log(open.address)  // The provided openAddr
console.log(open.retType)  // The provided return type
console.log(open.argTypes) // The provided argument types
console.log(open.abi)      // The provided abi

// Shorthand for Interceptor.attach
const listener = open.intercept({
  onEnter: function() {},
  onLeave: function() {}
})
listener.detach() // You can use it like usual

// Shorthand for Interceptor.replace
open.replace((pathPtr, flags) => {
  return open(pathPtr, flags)
})
```
