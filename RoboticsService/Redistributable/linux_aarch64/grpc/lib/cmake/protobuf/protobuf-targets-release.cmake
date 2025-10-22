#----------------------------------------------------------------
# Generated CMake target import file for configuration "Release".
#----------------------------------------------------------------

# Commands may need to know the format version.
set(CMAKE_IMPORT_FILE_VERSION 1)

# Import target "protobuf::libprotobuf-lite" for configuration "Release"
set_property(TARGET protobuf::libprotobuf-lite APPEND PROPERTY IMPORTED_CONFIGURATIONS RELEASE)
set_target_properties(protobuf::libprotobuf-lite PROPERTIES
  IMPORTED_LINK_INTERFACE_LANGUAGES_RELEASE "CXX"
  IMPORTED_LOCATION_RELEASE "${_IMPORT_PREFIX}/lib/libprotobuf-lite.a"
  )

list(APPEND _IMPORT_CHECK_TARGETS protobuf::libprotobuf-lite )
list(APPEND _IMPORT_CHECK_FILES_FOR_protobuf::libprotobuf-lite "${_IMPORT_PREFIX}/lib/libprotobuf-lite.a" )

# Import target "protobuf::libprotobuf" for configuration "Release"
set_property(TARGET protobuf::libprotobuf APPEND PROPERTY IMPORTED_CONFIGURATIONS RELEASE)
set_target_properties(protobuf::libprotobuf PROPERTIES
  IMPORTED_LINK_INTERFACE_LANGUAGES_RELEASE "CXX"
  IMPORTED_LOCATION_RELEASE "${_IMPORT_PREFIX}/lib/libprotobuf.a"
  )

list(APPEND _IMPORT_CHECK_TARGETS protobuf::libprotobuf )
list(APPEND _IMPORT_CHECK_FILES_FOR_protobuf::libprotobuf "${_IMPORT_PREFIX}/lib/libprotobuf.a" )

# Import target "protobuf::libprotoc" for configuration "Release"
set_property(TARGET protobuf::libprotoc APPEND PROPERTY IMPORTED_CONFIGURATIONS RELEASE)
set_target_properties(protobuf::libprotoc PROPERTIES
  IMPORTED_LINK_INTERFACE_LANGUAGES_RELEASE "CXX"
  IMPORTED_LOCATION_RELEASE "${_IMPORT_PREFIX}/lib/libprotoc.a"
  )

list(APPEND _IMPORT_CHECK_TARGETS protobuf::libprotoc )
list(APPEND _IMPORT_CHECK_FILES_FOR_protobuf::libprotoc "${_IMPORT_PREFIX}/lib/libprotoc.a" )

# Import target "protobuf::libupb" for configuration "Release"
set_property(TARGET protobuf::libupb APPEND PROPERTY IMPORTED_CONFIGURATIONS RELEASE)
set_target_properties(protobuf::libupb PROPERTIES
  IMPORTED_LINK_INTERFACE_LANGUAGES_RELEASE "C"
  IMPORTED_LOCATION_RELEASE "${_IMPORT_PREFIX}/lib/libupb.a"
  )

list(APPEND _IMPORT_CHECK_TARGETS protobuf::libupb )
list(APPEND _IMPORT_CHECK_FILES_FOR_protobuf::libupb "${_IMPORT_PREFIX}/lib/libupb.a" )

# Import target "protobuf::protoc" for configuration "Release"
set_property(TARGET protobuf::protoc APPEND PROPERTY IMPORTED_CONFIGURATIONS RELEASE)
set_target_properties(protobuf::protoc PROPERTIES
  IMPORTED_LOCATION_RELEASE "${_IMPORT_PREFIX}/bin/protoc-27.2.0"
  )

list(APPEND _IMPORT_CHECK_TARGETS protobuf::protoc )
list(APPEND _IMPORT_CHECK_FILES_FOR_protobuf::protoc "${_IMPORT_PREFIX}/bin/protoc-27.2.0" )

# Import target "protobuf::protoc-gen-upb" for configuration "Release"
set_property(TARGET protobuf::protoc-gen-upb APPEND PROPERTY IMPORTED_CONFIGURATIONS RELEASE)
set_target_properties(protobuf::protoc-gen-upb PROPERTIES
  IMPORTED_LOCATION_RELEASE "${_IMPORT_PREFIX}/bin/protoc-gen-upb-27.2.0"
  )

list(APPEND _IMPORT_CHECK_TARGETS protobuf::protoc-gen-upb )
list(APPEND _IMPORT_CHECK_FILES_FOR_protobuf::protoc-gen-upb "${_IMPORT_PREFIX}/bin/protoc-gen-upb-27.2.0" )

# Import target "protobuf::protoc-gen-upbdefs" for configuration "Release"
set_property(TARGET protobuf::protoc-gen-upbdefs APPEND PROPERTY IMPORTED_CONFIGURATIONS RELEASE)
set_target_properties(protobuf::protoc-gen-upbdefs PROPERTIES
  IMPORTED_LOCATION_RELEASE "${_IMPORT_PREFIX}/bin/protoc-gen-upbdefs-27.2.0"
  )

list(APPEND _IMPORT_CHECK_TARGETS protobuf::protoc-gen-upbdefs )
list(APPEND _IMPORT_CHECK_FILES_FOR_protobuf::protoc-gen-upbdefs "${_IMPORT_PREFIX}/bin/protoc-gen-upbdefs-27.2.0" )

# Import target "protobuf::protoc-gen-upb_minitable" for configuration "Release"
set_property(TARGET protobuf::protoc-gen-upb_minitable APPEND PROPERTY IMPORTED_CONFIGURATIONS RELEASE)
set_target_properties(protobuf::protoc-gen-upb_minitable PROPERTIES
  IMPORTED_LOCATION_RELEASE "${_IMPORT_PREFIX}/bin/protoc-gen-upb_minitable-27.2.0"
  )

list(APPEND _IMPORT_CHECK_TARGETS protobuf::protoc-gen-upb_minitable )
list(APPEND _IMPORT_CHECK_FILES_FOR_protobuf::protoc-gen-upb_minitable "${_IMPORT_PREFIX}/bin/protoc-gen-upb_minitable-27.2.0" )

# Commands beyond this point should not need to know the version.
set(CMAKE_IMPORT_FILE_VERSION)
