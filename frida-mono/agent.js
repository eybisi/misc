"use strict";

function _interopRequireDefault(obj) {
    return obj && obj.__esModule ? obj : { default: obj };
  }

var _fridaMonoApi = require("frida-mono-api");
var _enumerator = _interopRequireDefault(require("./enumerator.js"));
var Enumerator = _enumerator.default
var MonoApiHelper = _fridaMonoApi.MonoApiHelper


var pc2 = Enumerator.enumerateClass('Game'); //console.log(pc2.fields.cash)

// print it out
console.log("starting")

//var earn = new NativeFunction(ptr(0x19d4106f560), ['void'], ['pointer', 'pointer']);

// _enumerator.default.prettyPrint(pc2);

// Interceptor.attach(ptr(0x19d4106f560), {
//   onEnter: function (args) {

//     console.log(args[0]);
//     earn(args[0], ptr(100000));
//   }
// });
MonoApiHelper.Intercept(pc2.address, 'IncrementDay', {
  onEnter: function (args) {
    console.log("IncrementDay");
    this.instance = args[0];
  },
  onLeave: function (retval) {}
});
MonoApiHelper.Intercept(pc2.address, 'Pay', {
  onEnter: function (args) {
    console.log("[-] Pay", args[1]);
    console.log(pc2.getValue(args[0], 'cash'));
    this.instance = args[0];
  },
  onLeave: function (retval) {}
});
MonoApiHelper.Intercept(pc2.address, 'Earn', {
  onEnter: function (args) {
    console.log("[+] Earn", args[1]);
    args[1] = ptr(0x50000)
    this.instance = args[0];
  },
  onLeave: function (retval) {}
});