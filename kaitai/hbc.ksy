meta:
  id: hermes
  endian: le
  bit-endian: le
seq:
  - id: file_header
    type: file_header_t
  
  - id: function_header
    type: function_header_t
    repeat: expr
    repeat-expr: file_header.function_count
    
  - id: string_kinds
    type: u4
    repeat: expr
    repeat-expr: file_header.string_kind_count  
    
  - id: string_identifiers
    type: u4
    repeat: expr
    repeat-expr: file_header.identifier_count
    
  - id: string_tables
    type: string_table_entry
    repeat: expr
    repeat-expr: file_header.string_count
  
  - id: overflow_string_tables
    type: overflow_string_table_entry
    repeat: expr
    repeat-expr: file_header.overflow_string_count   
  - id: string_storage
    type: str
    encoding: ASCII
    size: file_header.string_storage_size
    
  - id: array_buffer
    type: str
    encoding: ASCII
    size: file_header.array_buffer_size
  
  - id: object_key_buffer
    type: str
    encoding: ASCII
    size: file_header.obj_key_buffer_size
  
  - id: object_value_buffer
    type: str
    encoding: ASCII
    size: file_header.obj_value_buffer_size

  - id: reg_exp_table
    type: reg_exp_table_entry
    repeat: expr
    repeat-expr: file_header.reg_exp_count  
  
  - id: reg_exp_storage
    type: str
    encoding: ASCII
    size: file_header.reg_exp_storage_size

  - id: cjd_module_table
    type:
      switch-on: file_header.options
      cases:
        1: static_builtins
        2: cjs_modules_statically_resolved

instances:
  debug_info_header: 
    type: debug_info
    pos: file_header.debug_info_offset
  
  
types:

  debug_info:
    seq:
      - id: debug_info_header
        type: debug_info_header
        size: 20
      - id: filename_table
        type: debug_string
        repeat: expr
        repeat-expr: debug_info_header.filename_count
      - id: filename_storage
        type: str
        size: debug_info_header.filename_storage_size
        encoding: ASCII 
      
      - id: debug_file_region_list
        type: debug_file_region
        repeat: expr
        repeat-expr: debug_info_header.file_region_count
    
  debug_info_header:
    seq:
      - id: filename_count
        type: u4
      - id: filename_storage_size
        type: u4
      - id: file_region_count
        type: u4
      - id: lexical_data_offset
        type: u4
      - id: debug_data_size
        type: u4
        
  debug_string:
    seq:
      - id: offset
        type: u4
      - id: length
        type: u4
  
  debug_file_region:
    seq:
      - id: from_offset
        type: u4
      - id: filename_id
        type: u4
      - id: source_mapping_url_id
        type: u4
  
  debug_offsets:
    seq:
      - id: source_locations # + function infoOffset
        type: u4
      - id: lexical_data
        type: u4
   
    instances:    # cant call io cuz its not fixed address
      debug_instance:
        io: _root._io
        pos: _root.file_header.debug_info_offset+source_locations
        type: debug_source_location
    
  debug_source_location:
    seq:
      - id: address
        type: u4
      - id: filename_id
        type: u4
      - id: line
        type: u4
      - id: column
        type: u4
      - id: statement
        type: u4
  
  static_builtins:
    seq:
      - id: module
        type: u8
        repeat: expr
        repeat-expr: _root.file_header.cjs_module_count       
  
  cjs_modules_statically_resolved:
    seq:
      - id: module
        type: u4
        repeat: expr
        repeat-expr: _root.file_header.cjs_module_count        
        
  file_header_t:
    seq:
      - id: magic
        contents: [0xc6, 0x1f, 0xbc, 0x03, 0xc1, 0x03, 0x19, 0x1f]
      - id: version
        type: u4
      - id: source_hash
        type: str
        size: 20
        encoding: ASCII
      - id: file_length
        type: u4
      - id: global_code_index
        type: u4
      - id: function_count
        type: u4
      - id: string_kind_count
        type: u4
      - id: identifier_count
        type: u4
      - id: string_count
        type: u4
      - id: overflow_string_count
        type: u4
      - id: string_storage_size
        type: u4
      - id: reg_exp_count
        type: u4
      - id: reg_exp_storage_size
        type: u4
      - id: array_buffer_size
        type: u4
      - id: obj_key_buffer_size
        type: u4
      - id: obj_value_buffer_size
        type: u4
      - id: cjs_module_offset
        type: u4
      - id: cjs_module_count
        type: u4
      - id: debug_info_offset
        type: u4
      - id: options
        type: u1
      - size: 31
      
  function_header_t:
    seq:
      - id: offset
        type: b25
      - id: paramcount
        type: b7
      - id: bytecode_size_in_bytes
        type: b15
      - id: function_name
        type: b17
      - id: info_offset
        type: b25
      - id: frame_size
        type: b7
      - id: environmentsize
        type: b8
      - id: highest_read_cache_index
        type: b8
      - id: highest_write_cache_index
        type: b8
      - id: function_header_flag
        type: function_header_info
        size: 1
        
    instances:
      function_bytecode:
        pos: offset
        size: bytecode_size_in_bytes
      
      function_exception_handler:
        pos: info_offset
        type: exception_handler_table_header
        if: function_header_flag.has_exception_handler
        
      function_debug_offsets: # pos changes if exception_handler present. else goes after info_offset[0]
        pos: info_offset+(12*function_header_flag.has_exception_handler.to_i) # 8 must be exception_handler_table_header.count*12
        type: debug_offsets
        size: 8
        if: function_header_flag.has_debug_info     
 
  function_header_info:
    seq:
      - id: is_prohibit_invoke
        type: b2
      - id: is_strict_mode
        type: b1
      - id: has_exception_handler
        type: b1
      - id: has_debug_info
        type: b1
      - id: overflowed
        type: b1
      - id: align
        type: b2
  
  exception_handler_table_header:
    seq:
      - id: count
        type: u4
      - id: exception_handlers
        repeat: expr
        type: exception_handler_info
        repeat-expr: count     
  
  exception_handler_info:
    seq:
      - id: start
        type: u4
      - id: end
        type: u4
      - id: target
        type: u4
        
  string_table_entry:
    seq:
      - id: is_utf16
        type: b1
      - id: offset
        type: b23
      - id: length
        type: b8
        
  
    instances:
      string_intance:
        pos: offset
        size: length
        
  overflow_string_table_entry:
    seq:
      - id: offset
        type: u4
      - id: length
        type: u4
  
    instances:
      overflow_string:
        pos: offset
        size: length
        
  reg_exp_table_entry:
    seq:
      - id: offset
        type: u4
      - id: length
        type: u4

        