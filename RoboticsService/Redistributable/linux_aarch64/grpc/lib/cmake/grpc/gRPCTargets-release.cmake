#----------------------------------------------------------------
# Generated CMake target import file for configuration "Release".
#----------------------------------------------------------------

# Commands may need to know the format version.
set(CMAKE_IMPORT_FILE_VERSION 1)

# Import target "gRPC::cares" for configuration "Release"
set_property(TARGET gRPC::cares APPEND PROPERTY IMPORTED_CONFIGURATIONS RELEASE)
set_target_properties(gRPC::cares PROPERTIES
  IMPORTED_LINK_INTERFACE_LANGUAGES_RELEASE "C"
  IMPORTED_LOCATION_RELEASE "${_IMPORT_PREFIX}/lib/libcares.a"
  )

list(APPEND _IMPORT_CHECK_TARGETS gRPC::cares )
list(APPEND _IMPORT_CHECK_FILES_FOR_gRPC::cares "${_IMPORT_PREFIX}/lib/libcares.a" )

# Import target "gRPC::re2" for configuration "Release"
set_property(TARGET gRPC::re2 APPEND PROPERTY IMPORTED_CONFIGURATIONS RELEASE)
set_target_properties(gRPC::re2 PROPERTIES
  IMPORTED_LINK_INTERFACE_LANGUAGES_RELEASE "CXX"
  IMPORTED_LOCATION_RELEASE "${_IMPORT_PREFIX}/lib/libre2.a"
  )

list(APPEND _IMPORT_CHECK_TARGETS gRPC::re2 )
list(APPEND _IMPORT_CHECK_FILES_FOR_gRPC::re2 "${_IMPORT_PREFIX}/lib/libre2.a" )

# Import target "gRPC::ssl" for configuration "Release"
set_property(TARGET gRPC::ssl APPEND PROPERTY IMPORTED_CONFIGURATIONS RELEASE)
set_target_properties(gRPC::ssl PROPERTIES
  IMPORTED_LINK_INTERFACE_LANGUAGES_RELEASE "CXX"
  IMPORTED_LOCATION_RELEASE "${_IMPORT_PREFIX}/lib/libssl.a"
  )

list(APPEND _IMPORT_CHECK_TARGETS gRPC::ssl )
list(APPEND _IMPORT_CHECK_FILES_FOR_gRPC::ssl "${_IMPORT_PREFIX}/lib/libssl.a" )

# Import target "gRPC::crypto" for configuration "Release"
set_property(TARGET gRPC::crypto APPEND PROPERTY IMPORTED_CONFIGURATIONS RELEASE)
set_target_properties(gRPC::crypto PROPERTIES
  IMPORTED_LINK_INTERFACE_LANGUAGES_RELEASE "ASM;C"
  IMPORTED_LOCATION_RELEASE "${_IMPORT_PREFIX}/lib/libcrypto.a"
  )

list(APPEND _IMPORT_CHECK_TARGETS gRPC::crypto )
list(APPEND _IMPORT_CHECK_FILES_FOR_gRPC::crypto "${_IMPORT_PREFIX}/lib/libcrypto.a" )

# Import target "gRPC::zlibstatic" for configuration "Release"
set_property(TARGET gRPC::zlibstatic APPEND PROPERTY IMPORTED_CONFIGURATIONS RELEASE)
set_target_properties(gRPC::zlibstatic PROPERTIES
  IMPORTED_LINK_INTERFACE_LANGUAGES_RELEASE "C"
  IMPORTED_LOCATION_RELEASE "${_IMPORT_PREFIX}/lib/libz.a"
  )

list(APPEND _IMPORT_CHECK_TARGETS gRPC::zlibstatic )
list(APPEND _IMPORT_CHECK_FILES_FOR_gRPC::zlibstatic "${_IMPORT_PREFIX}/lib/libz.a" )

# Import target "gRPC::address_sorting" for configuration "Release"
set_property(TARGET gRPC::address_sorting APPEND PROPERTY IMPORTED_CONFIGURATIONS RELEASE)
set_target_properties(gRPC::address_sorting PROPERTIES
  IMPORTED_LINK_INTERFACE_LANGUAGES_RELEASE "C"
  IMPORTED_LOCATION_RELEASE "${_IMPORT_PREFIX}/lib/libaddress_sorting.a"
  )

list(APPEND _IMPORT_CHECK_TARGETS gRPC::address_sorting )
list(APPEND _IMPORT_CHECK_FILES_FOR_gRPC::address_sorting "${_IMPORT_PREFIX}/lib/libaddress_sorting.a" )

# Import target "gRPC::gpr" for configuration "Release"
set_property(TARGET gRPC::gpr APPEND PROPERTY IMPORTED_CONFIGURATIONS RELEASE)
set_target_properties(gRPC::gpr PROPERTIES
  IMPORTED_LINK_INTERFACE_LANGUAGES_RELEASE "CXX"
  IMPORTED_LOCATION_RELEASE "${_IMPORT_PREFIX}/lib/libgpr.a"
  )

list(APPEND _IMPORT_CHECK_TARGETS gRPC::gpr )
list(APPEND _IMPORT_CHECK_FILES_FOR_gRPC::gpr "${_IMPORT_PREFIX}/lib/libgpr.a" )

# Import target "gRPC::grpc" for configuration "Release"
set_property(TARGET gRPC::grpc APPEND PROPERTY IMPORTED_CONFIGURATIONS RELEASE)
set_target_properties(gRPC::grpc PROPERTIES
  IMPORTED_LINK_INTERFACE_LANGUAGES_RELEASE "C;CXX"
  IMPORTED_LOCATION_RELEASE "${_IMPORT_PREFIX}/lib/libgrpc.a"
  )

list(APPEND _IMPORT_CHECK_TARGETS gRPC::grpc )
list(APPEND _IMPORT_CHECK_FILES_FOR_gRPC::grpc "${_IMPORT_PREFIX}/lib/libgrpc.a" )

# Import target "gRPC::grpc_unsecure" for configuration "Release"
set_property(TARGET gRPC::grpc_unsecure APPEND PROPERTY IMPORTED_CONFIGURATIONS RELEASE)
set_target_properties(gRPC::grpc_unsecure PROPERTIES
  IMPORTED_LINK_INTERFACE_LANGUAGES_RELEASE "C;CXX"
  IMPORTED_LOCATION_RELEASE "${_IMPORT_PREFIX}/lib/libgrpc_unsecure.a"
  )

list(APPEND _IMPORT_CHECK_TARGETS gRPC::grpc_unsecure )
list(APPEND _IMPORT_CHECK_FILES_FOR_gRPC::grpc_unsecure "${_IMPORT_PREFIX}/lib/libgrpc_unsecure.a" )

# Import target "gRPC::upb_base_lib" for configuration "Release"
set_property(TARGET gRPC::upb_base_lib APPEND PROPERTY IMPORTED_CONFIGURATIONS RELEASE)
set_target_properties(gRPC::upb_base_lib PROPERTIES
  IMPORTED_LINK_INTERFACE_LANGUAGES_RELEASE "C"
  IMPORTED_LOCATION_RELEASE "${_IMPORT_PREFIX}/lib/libupb_base_lib.a"
  )

list(APPEND _IMPORT_CHECK_TARGETS gRPC::upb_base_lib )
list(APPEND _IMPORT_CHECK_FILES_FOR_gRPC::upb_base_lib "${_IMPORT_PREFIX}/lib/libupb_base_lib.a" )

# Import target "gRPC::upb_json_lib" for configuration "Release"
set_property(TARGET gRPC::upb_json_lib APPEND PROPERTY IMPORTED_CONFIGURATIONS RELEASE)
set_target_properties(gRPC::upb_json_lib PROPERTIES
  IMPORTED_LINK_INTERFACE_LANGUAGES_RELEASE "C"
  IMPORTED_LOCATION_RELEASE "${_IMPORT_PREFIX}/lib/libupb_json_lib.a"
  )

list(APPEND _IMPORT_CHECK_TARGETS gRPC::upb_json_lib )
list(APPEND _IMPORT_CHECK_FILES_FOR_gRPC::upb_json_lib "${_IMPORT_PREFIX}/lib/libupb_json_lib.a" )

# Import target "gRPC::upb_mem_lib" for configuration "Release"
set_property(TARGET gRPC::upb_mem_lib APPEND PROPERTY IMPORTED_CONFIGURATIONS RELEASE)
set_target_properties(gRPC::upb_mem_lib PROPERTIES
  IMPORTED_LINK_INTERFACE_LANGUAGES_RELEASE "C"
  IMPORTED_LOCATION_RELEASE "${_IMPORT_PREFIX}/lib/libupb_mem_lib.a"
  )

list(APPEND _IMPORT_CHECK_TARGETS gRPC::upb_mem_lib )
list(APPEND _IMPORT_CHECK_FILES_FOR_gRPC::upb_mem_lib "${_IMPORT_PREFIX}/lib/libupb_mem_lib.a" )

# Import target "gRPC::upb_message_lib" for configuration "Release"
set_property(TARGET gRPC::upb_message_lib APPEND PROPERTY IMPORTED_CONFIGURATIONS RELEASE)
set_target_properties(gRPC::upb_message_lib PROPERTIES
  IMPORTED_LINK_INTERFACE_LANGUAGES_RELEASE "C"
  IMPORTED_LOCATION_RELEASE "${_IMPORT_PREFIX}/lib/libupb_message_lib.a"
  )

list(APPEND _IMPORT_CHECK_TARGETS gRPC::upb_message_lib )
list(APPEND _IMPORT_CHECK_FILES_FOR_gRPC::upb_message_lib "${_IMPORT_PREFIX}/lib/libupb_message_lib.a" )

# Import target "gRPC::upb_mini_descriptor_lib" for configuration "Release"
set_property(TARGET gRPC::upb_mini_descriptor_lib APPEND PROPERTY IMPORTED_CONFIGURATIONS RELEASE)
set_target_properties(gRPC::upb_mini_descriptor_lib PROPERTIES
  IMPORTED_LINK_INTERFACE_LANGUAGES_RELEASE "C"
  IMPORTED_LOCATION_RELEASE "${_IMPORT_PREFIX}/lib/libupb_mini_descriptor_lib.a"
  )

list(APPEND _IMPORT_CHECK_TARGETS gRPC::upb_mini_descriptor_lib )
list(APPEND _IMPORT_CHECK_FILES_FOR_gRPC::upb_mini_descriptor_lib "${_IMPORT_PREFIX}/lib/libupb_mini_descriptor_lib.a" )

# Import target "gRPC::upb_textformat_lib" for configuration "Release"
set_property(TARGET gRPC::upb_textformat_lib APPEND PROPERTY IMPORTED_CONFIGURATIONS RELEASE)
set_target_properties(gRPC::upb_textformat_lib PROPERTIES
  IMPORTED_LINK_INTERFACE_LANGUAGES_RELEASE "C"
  IMPORTED_LOCATION_RELEASE "${_IMPORT_PREFIX}/lib/libupb_textformat_lib.a"
  )

list(APPEND _IMPORT_CHECK_TARGETS gRPC::upb_textformat_lib )
list(APPEND _IMPORT_CHECK_FILES_FOR_gRPC::upb_textformat_lib "${_IMPORT_PREFIX}/lib/libupb_textformat_lib.a" )

# Import target "gRPC::upb_wire_lib" for configuration "Release"
set_property(TARGET gRPC::upb_wire_lib APPEND PROPERTY IMPORTED_CONFIGURATIONS RELEASE)
set_target_properties(gRPC::upb_wire_lib PROPERTIES
  IMPORTED_LINK_INTERFACE_LANGUAGES_RELEASE "C"
  IMPORTED_LOCATION_RELEASE "${_IMPORT_PREFIX}/lib/libupb_wire_lib.a"
  )

list(APPEND _IMPORT_CHECK_TARGETS gRPC::upb_wire_lib )
list(APPEND _IMPORT_CHECK_FILES_FOR_gRPC::upb_wire_lib "${_IMPORT_PREFIX}/lib/libupb_wire_lib.a" )

# Import target "gRPC::utf8_range_lib" for configuration "Release"
set_property(TARGET gRPC::utf8_range_lib APPEND PROPERTY IMPORTED_CONFIGURATIONS RELEASE)
set_target_properties(gRPC::utf8_range_lib PROPERTIES
  IMPORTED_LINK_INTERFACE_LANGUAGES_RELEASE "C"
  IMPORTED_LOCATION_RELEASE "${_IMPORT_PREFIX}/lib/libutf8_range_lib.a"
  )

list(APPEND _IMPORT_CHECK_TARGETS gRPC::utf8_range_lib )
list(APPEND _IMPORT_CHECK_FILES_FOR_gRPC::utf8_range_lib "${_IMPORT_PREFIX}/lib/libutf8_range_lib.a" )

# Import target "gRPC::grpc++" for configuration "Release"
set_property(TARGET gRPC::grpc++ APPEND PROPERTY IMPORTED_CONFIGURATIONS RELEASE)
set_target_properties(gRPC::grpc++ PROPERTIES
  IMPORTED_LINK_INTERFACE_LANGUAGES_RELEASE "CXX"
  IMPORTED_LOCATION_RELEASE "${_IMPORT_PREFIX}/lib/libgrpc++.a"
  )

list(APPEND _IMPORT_CHECK_TARGETS gRPC::grpc++ )
list(APPEND _IMPORT_CHECK_FILES_FOR_gRPC::grpc++ "${_IMPORT_PREFIX}/lib/libgrpc++.a" )

# Import target "gRPC::grpc++_alts" for configuration "Release"
set_property(TARGET gRPC::grpc++_alts APPEND PROPERTY IMPORTED_CONFIGURATIONS RELEASE)
set_target_properties(gRPC::grpc++_alts PROPERTIES
  IMPORTED_LINK_INTERFACE_LANGUAGES_RELEASE "CXX"
  IMPORTED_LOCATION_RELEASE "${_IMPORT_PREFIX}/lib/libgrpc++_alts.a"
  )

list(APPEND _IMPORT_CHECK_TARGETS gRPC::grpc++_alts )
list(APPEND _IMPORT_CHECK_FILES_FOR_gRPC::grpc++_alts "${_IMPORT_PREFIX}/lib/libgrpc++_alts.a" )

# Import target "gRPC::grpc++_error_details" for configuration "Release"
set_property(TARGET gRPC::grpc++_error_details APPEND PROPERTY IMPORTED_CONFIGURATIONS RELEASE)
set_target_properties(gRPC::grpc++_error_details PROPERTIES
  IMPORTED_LINK_INTERFACE_LANGUAGES_RELEASE "CXX"
  IMPORTED_LOCATION_RELEASE "${_IMPORT_PREFIX}/lib/libgrpc++_error_details.a"
  )

list(APPEND _IMPORT_CHECK_TARGETS gRPC::grpc++_error_details )
list(APPEND _IMPORT_CHECK_FILES_FOR_gRPC::grpc++_error_details "${_IMPORT_PREFIX}/lib/libgrpc++_error_details.a" )

# Import target "gRPC::grpc++_reflection" for configuration "Release"
set_property(TARGET gRPC::grpc++_reflection APPEND PROPERTY IMPORTED_CONFIGURATIONS RELEASE)
set_target_properties(gRPC::grpc++_reflection PROPERTIES
  IMPORTED_LINK_INTERFACE_LANGUAGES_RELEASE "CXX"
  IMPORTED_LOCATION_RELEASE "${_IMPORT_PREFIX}/lib/libgrpc++_reflection.a"
  )

list(APPEND _IMPORT_CHECK_TARGETS gRPC::grpc++_reflection )
list(APPEND _IMPORT_CHECK_FILES_FOR_gRPC::grpc++_reflection "${_IMPORT_PREFIX}/lib/libgrpc++_reflection.a" )

# Import target "gRPC::grpc++_unsecure" for configuration "Release"
set_property(TARGET gRPC::grpc++_unsecure APPEND PROPERTY IMPORTED_CONFIGURATIONS RELEASE)
set_target_properties(gRPC::grpc++_unsecure PROPERTIES
  IMPORTED_LINK_INTERFACE_LANGUAGES_RELEASE "CXX"
  IMPORTED_LOCATION_RELEASE "${_IMPORT_PREFIX}/lib/libgrpc++_unsecure.a"
  )

list(APPEND _IMPORT_CHECK_TARGETS gRPC::grpc++_unsecure )
list(APPEND _IMPORT_CHECK_FILES_FOR_gRPC::grpc++_unsecure "${_IMPORT_PREFIX}/lib/libgrpc++_unsecure.a" )

# Import target "gRPC::grpc_authorization_provider" for configuration "Release"
set_property(TARGET gRPC::grpc_authorization_provider APPEND PROPERTY IMPORTED_CONFIGURATIONS RELEASE)
set_target_properties(gRPC::grpc_authorization_provider PROPERTIES
  IMPORTED_LINK_INTERFACE_LANGUAGES_RELEASE "C;CXX"
  IMPORTED_LOCATION_RELEASE "${_IMPORT_PREFIX}/lib/libgrpc_authorization_provider.a"
  )

list(APPEND _IMPORT_CHECK_TARGETS gRPC::grpc_authorization_provider )
list(APPEND _IMPORT_CHECK_FILES_FOR_gRPC::grpc_authorization_provider "${_IMPORT_PREFIX}/lib/libgrpc_authorization_provider.a" )

# Import target "gRPC::grpc_plugin_support" for configuration "Release"
set_property(TARGET gRPC::grpc_plugin_support APPEND PROPERTY IMPORTED_CONFIGURATIONS RELEASE)
set_target_properties(gRPC::grpc_plugin_support PROPERTIES
  IMPORTED_LINK_INTERFACE_LANGUAGES_RELEASE "CXX"
  IMPORTED_LOCATION_RELEASE "${_IMPORT_PREFIX}/lib/libgrpc_plugin_support.a"
  )

list(APPEND _IMPORT_CHECK_TARGETS gRPC::grpc_plugin_support )
list(APPEND _IMPORT_CHECK_FILES_FOR_gRPC::grpc_plugin_support "${_IMPORT_PREFIX}/lib/libgrpc_plugin_support.a" )

# Import target "gRPC::grpcpp_channelz" for configuration "Release"
set_property(TARGET gRPC::grpcpp_channelz APPEND PROPERTY IMPORTED_CONFIGURATIONS RELEASE)
set_target_properties(gRPC::grpcpp_channelz PROPERTIES
  IMPORTED_LINK_INTERFACE_LANGUAGES_RELEASE "CXX"
  IMPORTED_LOCATION_RELEASE "${_IMPORT_PREFIX}/lib/libgrpcpp_channelz.a"
  )

list(APPEND _IMPORT_CHECK_TARGETS gRPC::grpcpp_channelz )
list(APPEND _IMPORT_CHECK_FILES_FOR_gRPC::grpcpp_channelz "${_IMPORT_PREFIX}/lib/libgrpcpp_channelz.a" )

# Commands beyond this point should not need to know the version.
set(CMAKE_IMPORT_FILE_VERSION)
