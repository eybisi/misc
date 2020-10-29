"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.default = void 0;

var _monoApi = _interopRequireDefault(require("./mono-api"));

function _interopRequireDefault(obj) {
  return obj && obj.__esModule ? obj : { default: obj };
}

function ownKeys(object, enumerableOnly) {
  var keys = Object.keys(object);
  if (Object.getOwnPropertySymbols) {
    var symbols = Object.getOwnPropertySymbols(object);
    if (enumerableOnly)
      symbols = symbols.filter(function (sym) {
        return Object.getOwnPropertyDescriptor(object, sym).enumerable;
      });
    keys.push.apply(keys, symbols);
  }
  return keys;
}

function _objectSpread(target) {
  for (var i = 1; i < arguments.length; i++) {
    var source = arguments[i] != null ? arguments[i] : {};
    if (i % 2) {
      ownKeys(Object(source), true).forEach(function (key) {
        _defineProperty(target, key, source[key]);
      });
    } else if (Object.getOwnPropertyDescriptors) {
      Object.defineProperties(target, Object.getOwnPropertyDescriptors(source));
    } else {
      ownKeys(Object(source)).forEach(function (key) {
        Object.defineProperty(
          target,
          key,
          Object.getOwnPropertyDescriptor(source, key)
        );
      });
    }
  }
  return target;
}

function _defineProperty(obj, key, value) {
  if (key in obj) {
    Object.defineProperty(obj, key, {
      value: value,
      enumerable: true,
      configurable: true,
      writable: true
    });
  } else {
    obj[key] = value;
  }
  return obj;
}

const rootDomain = _monoApi.default.mono_get_root_domain();

const MonoApiHelper = {
  AssemblyForeach: (cb) => {
    return _monoApi.default.mono_assembly_foreach(
      _monoApi.default.mono_assembly_foreach.nativeCallback(cb),
      NULL
    );
  },
  AssemblyLoadFromFull: (mono_image, filename, openStatusPtr, refonly) => {
    return _monoApi.default.mono_assembly_load_from_full(
      mono_image,
      Memory.allocUtf8String(filename),
      openStatusPtr,
      refonly
    );
  },
  ClassEnumBasetype: _monoApi.default.mono_class_enum_basetype,
  ClassFromMonoType: _monoApi.default.mono_class_from_mono_type,
  ClassFromName: (mono_image, name) => {
    const resolved = resolveClassName(name);
    return _monoApi.default.mono_class_from_name(
      mono_image,
      Memory.allocUtf8String(resolved.namespace),
      Memory.allocUtf8String(resolved.className)
    );
  },
  ClassGetFieldFromName: (mono_class, name) => {
    return _monoApi.default.mono_class_get_field_from_name(
      mono_class,
      Memory.allocUtf8String(name)
    );
  },
  ClassGetFields: (mono_class) => {
    const fields = [];
    const iter = Memory.alloc(Process.pointerSize);
    let field;

    while (
      !(field = _monoApi.default.mono_class_get_fields(
        mono_class,
        iter
      )).isNull()
    ) {
      fields.push(field);
    }

    return fields;
  },
  ClassGetMethodFromName: (mono_class, name, argCnt = -1) => {
    return _monoApi.default.mono_class_get_method_from_name(
      mono_class,
      Memory.allocUtf8String(name),
      argCnt
    );
  },
  ClassGetMethods: (mono_class) => {
    const methods = [];
    const iter = Memory.alloc(Process.pointerSize);
    let method;

    while (
      !(method = _monoApi.default.mono_class_get_methods(
        mono_class,
        iter
      )).isNull()
    ) {
      methods.push(method);
    }

    return methods;
  },
  ClassGetName: (mono_class) => {
    return Memory.readUtf8String(
      _monoApi.default.mono_class_get_name(mono_class)
    );
  },
  ClassGetType: _monoApi.default.mono_class_get_type,
  ClassIsEnum: (mono_class) =>
    _monoApi.default.mono_class_is_enum(mono_class) === 1,
  CompileMethod: _monoApi.default.mono_compile_method,
  DomainGet: _monoApi.default.mono_domain_get,
  FieldGetFlags: _monoApi.default.mono_field_get_flags,
  FieldGetName: (mono_field) =>
    Memory.readUtf8String(_monoApi.default.mono_field_get_name(mono_field)),
  FieldGetValueObject: (mono_field, mono_object, domain = rootDomain) => {
    return _monoApi.default.mono_field_get_value_object(
      domain,
      mono_field,
      mono_object
    );
  },
  GetBooleanClass: _monoApi.default.mono_get_boolean_class,
  GetInt32Class: _monoApi.default.mono_get_int32_class,
  GetSingleClass: _monoApi.default.mono_get_single_class,
  GetStringClass: _monoApi.default.mono_get_string_class,
  GetUInt32Class: _monoApi.default.mono_get_uint32_class,
  ImageLoaded: (name) =>
    _monoApi.default.mono_image_loaded(Memory.allocUtf8String(name)),
  MethodGetFlags: (mono_method, iflags = 0) =>
    _monoApi.default.mono_method_get_flags(mono_method, iflags),
  MethodGetName: (mono_method) =>
    Memory.readUtf8String(_monoApi.default.mono_method_get_name(mono_method)),
  MethodSignature: _monoApi.default.mono_method_signature,
  ObjectGetClass: _monoApi.default.mono_object_get_class,
  ObjectGetVirtualMethod: _monoApi.default.mono_object_get_virtual_method,
  ObjectNew: (mono_class, domain = rootDomain) =>
    _monoApi.default.mono_object_new(domain, mono_class),
  ObjectUnbox: (mono_object) => _monoApi.default.mono_object_unbox(mono_object),
  RuntimeInvoke: (mono_method, instance = NULL, args = NULL) => {
    const exception = NULL;

    const result = _monoApi.default.mono_runtime_invoke(
      mono_method,
      instance,
      args,
      exception
    );

    if (!exception.isNull()) throw new Error("Unknown exception happened.");
    return result;
  },
  SignatureGetParamCount: _monoApi.default.mono_signature_get_param_count,
  SignatureGetParams: (signature) => {
    let params = [];
    let iter = Memory.alloc(Process.pointerSize);
    let type;

    while (
      !(type = _monoApi.default.mono_signature_get_params(
        signature,
        iter
      )).isNull()
    ) {
      params.push(type);
    }

    return params;
  },
  StringNew: (str, domain = rootDomain) =>
    _monoApi.default.mono_string_new(domain, Memory.allocUtf8String(str)),
  StringToUtf8: (mono_string) =>
    Memory.readUtf8String(_monoApi.default.mono_string_to_utf8(mono_string)),
  TypeGetClass: _monoApi.default.mono_type_get_class,
  TypeGetName: (mono_type) =>
    Memory.readUtf8String(_monoApi.default.mono_type_get_name(mono_type)),
  TypeGetType: _monoApi.default.mono_type_get_type,
  TypeGetUnderlyingType: _monoApi.default.mono_type_get_underlying_type,
  ValueBox: (mono_class, valuePtr, domain = rootDomain) =>
    _monoApi.default.mono_value_box(domain, mono_class, valuePtr),
  Intercept: hookManagedMethod
};

function hookManagedMethod(klass, methodName, callbacks) {
  if (!callbacks) throw new Error("callbacks must be an object!");
  if (!callbacks.onEnter && !callbacks.onLeave)
    throw new Error("At least one callback is required!");
  let md = MonoApiHelper.ClassGetMethodFromName(klass, methodName);
  if (!md) throw new Error("Method not found!");

  let impl = _monoApi.default.mono_compile_method(md);

  Interceptor.attach(impl, _objectSpread({}, callbacks));
}

function resolveClassName(className) {
  return {
    className: className.substring(className.lastIndexOf(".") + 1),
    namespace: className.substring(0, className.lastIndexOf("."))
  };
}

var _default = MonoApiHelper;
exports.default = _default;
