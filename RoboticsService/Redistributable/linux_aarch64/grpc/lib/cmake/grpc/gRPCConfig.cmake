# Module path
list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_LIST_DIR}/modules)

# Depend packages




if(NOT TARGET absl::strings)
  find_package(absl CONFIG)
endif()



# Targets
include(${CMAKE_CURRENT_LIST_DIR}/gRPCTargets.cmake)
if(NOT CMAKE_CROSSCOMPILING)
  include(${CMAKE_CURRENT_LIST_DIR}/gRPCPluginTargets.cmake)
endif()
