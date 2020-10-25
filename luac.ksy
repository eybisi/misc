meta:
  id: luac
  file-extension: luac
  endian: le

seq:
  - id: file_header
    type: header
  - id: top_level_function
    type: function
  
types:
  header:
    seq:
      - id: magic
        type: u4
      - id: version
        type: u1
      - id: format_version
        type: u1
      - id: endianness
        type: u1
      - id: size_of_int
        type: u1
      - id: size_of_size_t
        type: u1
      - id: size_of_instruction
        type: u1
      - id: size_of_luanumber
        type: u1
      - id: integral_flag
        type: u1
        
  function:
    seq:
      - id: source_file_name
        type: lua_string
      - id: line_defined
        type: u4
      - id : last_line_defined
        type: u4
      - id : number_of_upvalues
        type: u1
      - id:  number_of_params
        type: u1
      - id : is_vararg_flag
        type: u1
      - id : maximum_stack_size
        type: b4
      - id: instructions
        type: instruction_list
      - id: constants
        type: constant_list
      - id: other_functions
        type: function_prototype_list
      - id: source_lines
        type: source_line_list
      - id: local_variables
        type: local_list
      - id: upvalues
        type: upvalue_list
      
  lua_string:
    seq:
      - id: size_str
        type: u4
      - id: real_str
        size: size_str
        encoding: ASCII
        type: str
    -webide-representation: "{real_str}"   
        
  instruction_list:
    seq:
      - id: size_of_code
        type: u4
      - id: instructions
        type: instruction
        repeat: expr
        repeat-expr: size_of_code
  
  instruction:

    seq:
      - id: opcode
        type: b6
        enum: op_code_names
      - id: args
        type: b26
            
    -webide-representation: "{opcode}"
    enums:
      op_code_names:
            0: move
            1: loadk
            2: loadbool
            3: loadnil
            4: getupval
            5: getglobal
            6: gettable
            7: setglobal
            8: setupval
            9: settable
            10: newtable
            11: self
            12: add
            13: sub
            14: mul
            15: div
            16: mod
            17: pow
            18: unm
            19: not
            20: len
            21: concat
            22: jmp
            23: eq
            24: lt
            25: le
            26: test
            27: testset
            28: call
            29: tailcall
            30: return
            31: forloop
            32: tforloop
            33: forprep
            34: setlist
            35: close
            36: closure
            37: vararg

        
  constant_list:
    seq:
      - id: size_of_constant
        type: u4
      - id: constants
        type: constant
        repeat: expr
        repeat-expr: size_of_constant
        
  function_prototype_list:
    seq:
      - id: size_of_function_prototypes
        type: u4
      - id: function
        type: function
        repeat: expr
        repeat-expr: size_of_function_prototypes

  source_line_list:
    seq:
      - id: source_lines_of_instructions
        type: u4
      - id: lines
        type: u4
        repeat: expr
        repeat-expr: source_lines_of_instructions
  local_list:
    seq:
      - id: list_size
        type: u4
      - id: local_variable
        type: u4
        repeat: expr
        repeat-expr: list_size 
  
  upvalue_list:
    seq:
      - id: upvalue_size
        type: u4
      - id: upvalue_str
        type: str
        encoding: ASCII
        terminator: 0
        repeat: expr
        repeat-expr: upvalue_size 
        
  local_variable:
    seq:
      - id: varname
        type: str
        encoding: ASCII
        terminator: 0
      - id: startpc
        type: u4
      - id: endpc
        type: u4
        
  constant:
    seq:
      - id: constant_type
        type: u1
      - id: constant
        type:
          switch-on: constant_type
          cases:
            4: lua_string
            3: f8
            1: u1
    -webide-representation: "{constant}"

        