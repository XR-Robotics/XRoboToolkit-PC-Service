# Generated from RoboticsServiceProcess.pro.

cmake_minimum_required(VERSION 3.16)

project(RoboticsServiceProcess VERSION ${BUILD_VERION_NUM} LANGUAGES CXX)

# Set company information
set(SUIT_COMPANY_NAME "PICO")
set(SUIT_COPYRIGHT "Copyright (c) 2024 PICO")

set(CMAKE_CXX_STANDARD 17)

set(CMAKE_INCLUDE_CURRENT_DIR ON)

set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

set(INSTALL_DIR  ${PROJECT_SOURCE_DIR}/../bin)

if(NOT EXISTS ${INSTALL_DIR})
    file(MAKE_DIRECTORY ${INSTALL_DIR})
endif()


set(EXECUTABLE_OUTPUT_PATH ${INSTALL_DIR})


find_package(Qt6 REQUIRED COMPONENTS Core Network)
find_package(Qt6 REQUIRED COMPONENTS Core5Compat)

set(SOURCES main.cpp singleapplication.cpp singleapplication.h)

# Configure the resource file
configure_file(
    ${CMAKE_CURRENT_SOURCE_DIR}/RoboticsServiceProcess_resource.rc.in
    ${CMAKE_CURRENT_BINARY_DIR}/RoboticsServiceProcess_resource.rc
    @ONLY
)

qt_add_executable(RoboticsServiceProcess
    ${SOURCES}
    ${CMAKE_CURRENT_BINARY_DIR}/RoboticsServiceProcess_resource.rc
)


add_definitions(-DAPPVERSION=${BUILD_VERION_NUM})
target_compile_definitions(RoboticsServiceProcess PUBLIC
    QT_DEPRECATED_WARNINGS
    QT_MESSAGELOGCONTEXT
)


target_link_libraries(RoboticsServiceProcess PRIVATE Qt6::Core5Compat)


target_link_libraries(RoboticsServiceProcess PUBLIC
    Qt::Core
    Qt::Network
)




target_link_directories(RoboticsServiceProcess PUBLIC ${INSTALL_DIR})

target_include_directories(RoboticsServiceProcess PUBLIC
    ../Business
    ../CommonUtils
    ../DeviceConnectionManager
)

if(WIN32)
    set_target_properties(RoboticsServiceProcess PROPERTIES
        WIN32_EXECUTABLE TRUE
    )

    target_include_directories(RoboticsServiceProcess PUBLIC
        ../PXREAGRPCServer
        ../PXREAService
        ../GrpcSDK/include
        ../CommonUtils
        ../DeviceConnectionManager
    )

    target_compile_definitions(RoboticsServiceProcess PUBLIC
        WINDOWS_x86
    )

    target_link_libraries(RoboticsServiceProcess PUBLIC
        # Remove: L../bin
        PXREAGRPCServer.dll
    )

    add_compile_options("$<$<C_COMPILER_ID:MSVC>:/utf-8>")
    add_compile_options("$<$<CXX_COMPILER_ID:MSVC>:/utf-8>")

    target_link_libraries(RoboticsServiceProcess PUBLIC
        # Remove: L${CMAKE_CURRENT_SOURCE_DIR}/../bin/
        # Remove: L${CMAKE_CURRENT_SOURCE_DIR}/../bin/ByteRTC/
        Business.dll
        CommonUtils.dll
        DeviceConnectionManager.dll
    )


    add_custom_command(TARGET RoboticsServiceProcess
        POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy "${PROJECT_SOURCE_DIR}/../Redistributable/win/install.bat" ${INSTALL_DIR}
        COMMAND ${CMAKE_COMMAND} -E copy "${PROJECT_SOURCE_DIR}/../Redistributable/win/key-setting.ini" ${INSTALL_DIR}
        COMMAND ${CMAKE_COMMAND} -E copy "${PROJECT_SOURCE_DIR}/../Redistributable/win/icon.ico" ${INSTALL_DIR}
        COMMAND ${CMAKE_COMMAND} -E copy "${PROJECT_SOURCE_DIR}/../Redistributable/win/setting.ini" ${INSTALL_DIR}
        COMMAND ${CMAKE_COMMAND} -E copy "${PROJECT_SOURCE_DIR}/../Redistributable/win/icon.ico" ${INSTALL_DIR}
        COMMAND ${CMAKE_COMMAND} -E copy "${PROJECT_SOURCE_DIR}/../Redistributable/win/PXREASetting.ini" ${INSTALL_DIR}
    )



    if(CMAKE_BUILD_TYPE STREQUAL "RelWithDebInfo")
        set(DEPLOY_TARGET ${INSTALL_DIR}/RoboticsServiceProcess.exe)

        add_custom_command(TARGET RoboticsServiceProcess
             POST_BUILD
             COMMAND ${WINDEPLOYQT_EXECUTABLE} --qmldir ${INSTALL_DIR} --plugindir ${INSTALL_DIR} --release ${DEPLOY_TARGET}
             COMMAND ${CMAKE_COMMAND} -E copy "${PROJECT_SOURCE_DIR}/../Redistributable/win/RobotDemoQt.exe" ${INSTALL_DIR}
             COMMAND ${WINDEPLOYQT_EXECUTABLE} --qmldir ${INSTALL_DIR} --plugindir ${INSTALL_DIR} --release "${INSTALL_DIR}/RobotDemoQt.exe"
             COMMAND ${CMAKE_COMMAND} -E copy "${PROJECT_SOURCE_DIR}/../Redistributable/win/VC_redist.x64.exe" ${INSTALL_DIR}
             COMMAND ${CMAKE_COMMAND} -E copy "${PROJECT_SOURCE_DIR}/../Redistributable/win/VC_redist.x86.exe" ${INSTALL_DIR}
             COMMAND ${CMAKE_COMMAND} -E copy "${PROJECT_SOURCE_DIR}/../Redistributable/win/uninstallScript.bat" ${INSTALL_DIR}
             COMMAND ${CMAKE_COMMAND} -E copy "${PROJECT_SOURCE_DIR}/../Redistributable/win/run3D.bat" ${INSTALL_DIR}
             COMMAND ${CMAKE_COMMAND} -E copy "${PROJECT_SOURCE_DIR}/../Redistributable/win/run3D.exe" ${INSTALL_DIR}
             COMMAND ${CMAKE_COMMAND} -E copy "${PROJECT_SOURCE_DIR}/../Redistributable/win/runService.bat" ${INSTALL_DIR}
             COMMAND ${CMAKE_COMMAND} -E copy_directory "${PROJECT_SOURCE_DIR}/../SDKDemo/UnityBin/RobotWinDemo" "${INSTALL_DIR}/SDKDemo/RobotUnityDemo"
             COMMAND ${CMAKE_COMMAND} -E copy_directory "${PROJECT_SOURCE_DIR}/../SDKDemo/CppSrc" "${INSTALL_DIR}/SDKDemo/CppSrc"
             COMMAND ${CMAKE_COMMAND} -E copy_directory "${PROJECT_SOURCE_DIR}/../SDK/include" "${INSTALL_DIR}/SDK/include"
             COMMAND ${CMAKE_COMMAND} -E copy_directory "${PROJECT_SOURCE_DIR}/../SDK/win/64" "${INSTALL_DIR}/SDK/x64"
         )
    endif()

endif()



if(UNIX)
         if(ISA_NAME STREQUAL "aarch64")
             target_compile_definitions(RoboticsServiceProcess PUBLIC
                     LINUX_aarch64
             )
             target_link_libraries(RoboticsServiceProcess PUBLIC
                 # Remove: L${CMAKE_CURRENT_SOURCE_DIR}/../bin/
                 Business
                 CommonUtils
                 DeviceConnectionManager
                 PXREAGRPCServer
             )
              target_include_directories(RoboticsServiceProcess PUBLIC
                  ../PXREAGRPCServer
              )


                 add_custom_command(TARGET RoboticsServiceProcess
                     PRE_BUILD
                     COMMAND ${CMAKE_COMMAND} -E copy "${PROJECT_SOURCE_DIR}/../Redistributable/linux_aarch64/openssl/libcrypto.so" ${INSTALL_DIR}
                     COMMAND ${CMAKE_COMMAND} -E copy "${PROJECT_SOURCE_DIR}/../Redistributable/linux_aarch64/openssl/libcrypto.so.3" ${INSTALL_DIR}
                     COMMAND ${CMAKE_COMMAND} -E copy "${PROJECT_SOURCE_DIR}/../Redistributable/linux_aarch64/openssl/libssl.so" ${INSTALL_DIR}
                     COMMAND ${CMAKE_COMMAND} -E copy "${PROJECT_SOURCE_DIR}/../Redistributable/linux_aarch64/openssl/libssl.so.3" ${INSTALL_DIR}
                     COMMAND ${CMAKE_COMMAND} -E copy "${PROJECT_SOURCE_DIR}/../Redistributable/linux_aarch64/setting.ini" ${INSTALL_DIR}
                     COMMAND ${CMAKE_COMMAND} -E copy_directory "${PROJECT_SOURCE_DIR}/../SDKDemo/CppSrc" "${INSTALL_DIR}/SDKDemo/CppSrc"
                     COMMAND ${CMAKE_COMMAND} -E copy_directory "${PROJECT_SOURCE_DIR}/../SDK/include" "${INSTALL_DIR}/SDK/include"
                     COMMAND ${CMAKE_COMMAND} -E copy_directory "${PROJECT_SOURCE_DIR}/../SDK/linux_aarch64/64" "${INSTALL_DIR}/SDK/arm64"

                 )

                 add_custom_command(TARGET RoboticsServiceProcess
                     POST_BUILD
                     COMMAND ${CMAKE_COMMAND} -E copy "${PROJECT_SOURCE_DIR}/../Redistributable/linux_aarch64/ConsoleDemo" ${INSTALL_DIR}
                     COMMAND ${CMAKE_COMMAND} -E copy "${PROJECT_SOURCE_DIR}/../Redistributable/linux_aarch64/RobotDataRecorder" ${INSTALL_DIR}
                     COMMAND ${CMAKE_COMMAND} -E copy "${PROJECT_SOURCE_DIR}/../Redistributable/linux_aarch64/RobotDemoQt" ${INSTALL_DIR}
                 )


                 if(CMAKE_BUILD_TYPE STREQUAL "RelWithDebInfo")

                     add_custom_command(TARGET RoboticsServiceProcess
                          POST_BUILD


                          COMMAND ${CMAKE_COMMAND} -E make_directory "${INSTALL_DIR}/lib"
                          COMMAND ${CMAKE_COMMAND} -E copy "${CMAKE_PREFIX_PATH}/lib/libQt6Core.so" "${INSTALL_DIR}/lib"
                          COMMAND ${CMAKE_COMMAND} -E copy "${CMAKE_PREFIX_PATH}/lib/libQt6Core.so.6" "${INSTALL_DIR}/lib"
                          COMMAND ${CMAKE_COMMAND} -E copy "${CMAKE_PREFIX_PATH}/lib/libQt6Core.so.6.7.3" "${INSTALL_DIR}/lib"


                          COMMAND ${CMAKE_COMMAND} -E copy "${CMAKE_PREFIX_PATH}/lib/libQt6Core5Compat.so" "${INSTALL_DIR}/lib"
                          COMMAND ${CMAKE_COMMAND} -E copy "${CMAKE_PREFIX_PATH}/lib/libQt6Core5Compat.so.6" "${INSTALL_DIR}/lib"
                          COMMAND ${CMAKE_COMMAND} -E copy "${CMAKE_PREFIX_PATH}/lib/libQt6Core5Compat.so.6.7.3" "${INSTALL_DIR}/lib"



                          COMMAND ${CMAKE_COMMAND} -E copy "${CMAKE_PREFIX_PATH}/lib/libQt6DBus.so" "${INSTALL_DIR}/lib"
                          COMMAND ${CMAKE_COMMAND} -E copy "${CMAKE_PREFIX_PATH}/lib/libQt6DBus.so.6" "${INSTALL_DIR}/lib"
                          COMMAND ${CMAKE_COMMAND} -E copy "${CMAKE_PREFIX_PATH}/lib/libQt6DBus.so.6.7.3" "${INSTALL_DIR}/lib"



                          COMMAND ${CMAKE_COMMAND} -E copy "${CMAKE_PREFIX_PATH}/lib/libQt6Network.so" "${INSTALL_DIR}/lib"
                          COMMAND ${CMAKE_COMMAND} -E copy "${CMAKE_PREFIX_PATH}/lib/libQt6Network.so.6" "${INSTALL_DIR}/lib"
                          COMMAND ${CMAKE_COMMAND} -E copy "${CMAKE_PREFIX_PATH}/lib/libQt6Network.so.6.7.3" "${INSTALL_DIR}/lib"



                          COMMAND ${CMAKE_COMMAND} -E copy "${CMAKE_PREFIX_PATH}/lib/libQt6Sql.so" "${INSTALL_DIR}/lib"
                          COMMAND ${CMAKE_COMMAND} -E copy "${CMAKE_PREFIX_PATH}/lib/libQt6Sql.so.6" "${INSTALL_DIR}/lib"
                          COMMAND ${CMAKE_COMMAND} -E copy "${CMAKE_PREFIX_PATH}/lib/libQt6Sql.so.6.7.3" "${INSTALL_DIR}/lib"


                          COMMAND ${CMAKE_COMMAND} -E make_directory "${INSTALL_DIR}/translations"
                          COMMAND ${CMAKE_COMMAND} -E copy_directory "${CMAKE_PREFIX_PATH}/translations" "${INSTALL_DIR}/translations"

                          COMMAND ${CMAKE_COMMAND} -E make_directory "${INSTALL_DIR}/plugins"
                          COMMAND ${CMAKE_COMMAND} -E make_directory "${INSTALL_DIR}/plugins/generic"
                          COMMAND ${CMAKE_COMMAND} -E copy "${CMAKE_PREFIX_PATH}/plugins/generic/libqtuiotouchplugin.so" "${INSTALL_DIR}/plugins/generic"

                          COMMAND ${CMAKE_COMMAND} -E make_directory "${INSTALL_DIR}/plugins/networkinformation"
                          COMMAND ${CMAKE_COMMAND} -E copy_directory "${CMAKE_PREFIX_PATH}/plugins/networkinformation" "${INSTALL_DIR}/plugins/networkinformation"
                          COMMAND ${CMAKE_COMMAND} -E make_directory "${INSTALL_DIR}/plugins/platforminputcontexts"
                          COMMAND ${CMAKE_COMMAND} -E copy "${CMAKE_PREFIX_PATH}/plugins/platforminputcontexts/libqtvirtualkeyboardplugin.so" "${INSTALL_DIR}/plugins/platforminputcontexts"
                          COMMAND ${CMAKE_COMMAND} -E make_directory "${INSTALL_DIR}/plugins/platforms"
                          COMMAND ${CMAKE_COMMAND} -E copy_directory "${CMAKE_PREFIX_PATH}/plugins/platforms" "${INSTALL_DIR}/plugins/platforms"
                          COMMAND ${CMAKE_COMMAND} -E make_directory "${INSTALL_DIR}/plugins/sqldrivers"
                          COMMAND ${CMAKE_COMMAND} -E copy_directory "${CMAKE_PREFIX_PATH}/plugins/sqldrivers" "${INSTALL_DIR}/plugins/sqldrivers"
                          COMMAND ${CMAKE_COMMAND} -E make_directory "${INSTALL_DIR}/plugins/tls"
                          COMMAND ${CMAKE_COMMAND} -E copy_directory "${CMAKE_PREFIX_PATH}/plugins/tls" "${INSTALL_DIR}/plugins/tls"

                      )
                 endif()

             else()
                 target_compile_definitions(RoboticsServiceProcess PUBLIC
                 LINUX_x86
             )
             target_link_directories(PXREAGRPCServer PUBLIC ${PROJECT_SOURCE_DIR}/../Redistributable/linux/grpc/lib)
             target_include_directories(RoboticsServiceProcess PUBLIC
                 ../PXREAGRPCServer
             )

             target_link_libraries(PXREAGRPCServer PUBLIC
                 # Remove: L${CMAKE_CURRENT_SOURCE_DIR}/../bin/
                 # Remove: L${CMAKE_CURRENT_SOURCE_DIR}/../bin/ByteRTC/
                 libabsl_bad_any_cast_impl.a
                 libabsl_bad_optional_access.a
                 libabsl_bad_variant_access.a
                 libabsl_base.a
                 libabsl_city.a
                 libabsl_civil_time.a
                 libabsl_cord.a
                 libabsl_cord_internal.a
                 libabsl_cordz_functions.a
                 libabsl_cordz_handle.a
                 libabsl_cordz_info.a
                 libabsl_cordz_sample_token.a
                 libabsl_crc32c.a
                 libabsl_crc_cord_state.a
                 libabsl_crc_cpu_detect.a
                 libabsl_crc_internal.a
                 libabsl_debugging_internal.a
                 libabsl_demangle_internal.a
                 libabsl_die_if_null.a
                 libabsl_examine_stack.a
                 libabsl_exponential_biased.a
                 libabsl_failure_signal_handler.a
                 libabsl_flags_commandlineflag.a
                 libabsl_flags_commandlineflag_internal.a
                 libabsl_flags_config.a
                 libabsl_flags_internal.a
                 libabsl_flags_marshalling.a
                 libabsl_flags_parse.a
                 libabsl_flags_private_handle_accessor.a
                 libabsl_flags_program_name.a
                 libabsl_flags_reflection.a
                 libabsl_flags_usage.a
                 libabsl_flags_usage_internal.a
                 libabsl_graphcycles_internal.a
                 libabsl_hash.a
                 libabsl_hashtablez_sampler.a
                 libabsl_int128.a
                 libabsl_kernel_timeout_internal.a
                 libabsl_leak_check.a
                 libabsl_log_entry.a
                 libabsl_log_flags.a
                 libabsl_log_globals.a
                 libabsl_log_initialize.a
                 libabsl_log_internal_check_op.a
                 libabsl_log_internal_conditions.a
                 libabsl_log_internal_fnmatch.a
                 libabsl_log_internal_format.a
                 libabsl_log_internal_globals.a
                 libabsl_log_internal_log_sink_set.a
                 libabsl_log_internal_message.a
                 libabsl_log_internal_nullguard.a
                 libabsl_log_internal_proto.a
                 libabsl_log_severity.a
                 libabsl_log_sink.a
                 libabsl_low_level_hash.a
                 libabsl_malloc_internal.a
                 libabsl_periodic_sampler.a
                 libabsl_random_distributions.a
                 libabsl_random_internal_distribution_test_util.a
                 libabsl_random_internal_platform.a
                 libabsl_random_internal_pool_urbg.a
                 libabsl_random_internal_randen.a
                 libabsl_random_internal_randen_hwaes.a
                 libabsl_random_internal_randen_hwaes_impl.a
                 libabsl_random_internal_randen_slow.a
                 libabsl_random_internal_seed_material.a
                 libabsl_random_seed_gen_exception.a
                 libabsl_random_seed_sequences.a
                 libabsl_raw_hash_set.a
                 libabsl_raw_logging_internal.a
                 libabsl_scoped_set_env.a
                 libabsl_spinlock_wait.a
                 libabsl_stacktrace.a
                 libabsl_status.a
                 libabsl_statusor.a
                 libabsl_strerror.a
                 libabsl_str_format_internal.a
                 libabsl_strings.a
                 libabsl_strings_internal.a
                 libabsl_string_view.a
                 libabsl_symbolize.a
                 libabsl_synchronization.a
                 libabsl_throw_delegate.a
                 libabsl_time.a
                 libabsl_time_zone.a
                 libabsl_vlog_config_internal.a
                 libaddress_sorting.a
                 libcares.a
                 libcrypto.a
                 libgpr.a
                 libgrpc++.a
                 libgrpc.a
                 libgrpc++_alts.a
                 libgrpc_authorization_provider.a
                 libgrpc++_error_details.a
                 libgrpc_plugin_support.a
                 libgrpcpp_channelz.a
                 libgrpc++_reflection.a
                 libgrpc++_unsecure.a
                 libgrpc_unsecure.a
                 libprotobuf.a
                 libprotobuf-lite.a
                 libprotoc.a
                 libre2.a
                 libssl.a
                 libupb.a
                 libutf8_range.a
                 libutf8_validity.a
                 libz.a

             )


             target_include_directories(RoboticsServiceProcess PUBLIC
                 ../Redistributable/linux/grpc/include
                 ../PXREAService/linux_x86
             )
             set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -Wl,--copy-dt-needed-entries")
             target_link_libraries(RoboticsServiceProcess PUBLIC
                 # Remove: L${CMAKE_CURRENT_SOURCE_DIR}/../bin/
                 Business
                 PXREAGRPCServer
                 CommonUtils
                 DeviceConnectionManager
             )


             add_custom_command(TARGET RoboticsServiceProcess
                 PRE_BUILD
                 COMMAND ${CMAKE_COMMAND} -E copy "${PROJECT_SOURCE_DIR}/../Redistributable/linux/openssl/libcrypto.so" ${INSTALL_DIR}
                 COMMAND ${CMAKE_COMMAND} -E copy "${PROJECT_SOURCE_DIR}/../Redistributable/linux/openssl/libcrypto.so.3" ${INSTALL_DIR}
                 COMMAND ${CMAKE_COMMAND} -E copy "${PROJECT_SOURCE_DIR}/../Redistributable/linux/openssl/libssl.so" ${INSTALL_DIR}
                 COMMAND ${CMAKE_COMMAND} -E copy "${PROJECT_SOURCE_DIR}/../Redistributable/linux/openssl/libssl.so.3" ${INSTALL_DIR}
                 COMMAND ${CMAKE_COMMAND} -E copy "${PROJECT_SOURCE_DIR}/../Redistributable/linux/setting.ini" ${INSTALL_DIR}

             )


             if(CMAKE_BUILD_TYPE STREQUAL "RelWithDebInfo")

                 add_custom_command(TARGET RoboticsServiceProcess
                      POST_BUILD
                      COMMAND ${CMAKE_COMMAND} -E copy "${PROJECT_SOURCE_DIR}/../Redistributable/linux/roboticsservice.svg" ${INSTALL_DIR}

                      COMMAND ${CMAKE_COMMAND} -E copy "${PROJECT_SOURCE_DIR}/../Redistributable/linux/libz.so" ${INSTALL_DIR}
                      COMMAND ${CMAKE_COMMAND} -E copy "${PROJECT_SOURCE_DIR}/../Redistributable/linux/libz.so.1" ${INSTALL_DIR}
                      COMMAND ${CMAKE_COMMAND} -E copy "${PROJECT_SOURCE_DIR}/../Redistributable/linux/libz.so.1.2.12" ${INSTALL_DIR}
                      COMMAND ${CMAKE_COMMAND} -E copy "${PROJECT_SOURCE_DIR}/../Redistributable/linux/libxcb-cursor.so" ${INSTALL_DIR}
                      COMMAND ${CMAKE_COMMAND} -E copy "${PROJECT_SOURCE_DIR}/../Redistributable/linux/libxcb-cursor.so.0" ${INSTALL_DIR}
                      COMMAND ${CMAKE_COMMAND} -E copy "${PROJECT_SOURCE_DIR}/../Redistributable/linux/libxcb-cursor.so.0.0.0" ${INSTALL_DIR}
                      COMMAND ${CMAKE_COMMAND} -E copy "${PROJECT_SOURCE_DIR}/../Redistributable/linux/libapplogrs.so" ${INSTALL_DIR}
                      COMMAND ${CMAKE_COMMAND} -E copy "${PROJECT_SOURCE_DIR}/../Redistributable/linux/libapplogrs.d" ${INSTALL_DIR}


                      COMMAND ${CMAKE_COMMAND} -E copy "${PROJECT_SOURCE_DIR}/../Redistributable/linux/RobotDataRecorder" ${INSTALL_DIR}
                      COMMAND ${CMAKE_COMMAND} -E copy "${PROJECT_SOURCE_DIR}/../Redistributable/linux/RobotDemoQt" ${INSTALL_DIR}
                      COMMAND ${CMAKE_COMMAND} -E copy "${PROJECT_SOURCE_DIR}/../Redistributable/linux/ConsoleDemo" ${INSTALL_DIR}


                      COMMAND ${CMAKE_COMMAND} -E copy_directory "${PROJECT_SOURCE_DIR}/../SDKDemo/UnityBin/RobotLinuxDemo" "${INSTALL_DIR}/SDKDemo/RobotUnityDemo"
                      COMMAND ${CMAKE_COMMAND} -E copy_directory "${PROJECT_SOURCE_DIR}/../SDKDemo/CppSrc" "${INSTALL_DIR}/SDKDemo/CppSrc"
                      COMMAND ${CMAKE_COMMAND} -E copy_directory "${PROJECT_SOURCE_DIR}/../SDK/include" "${INSTALL_DIR}/SDK/include"
                      COMMAND ${CMAKE_COMMAND} -E copy_directory "${PROJECT_SOURCE_DIR}/../SDK/linux/64" "${INSTALL_DIR}/SDK/x64"

                      COMMAND ${CMAKE_COMMAND} -E make_directory "${INSTALL_DIR}/lib"
                      COMMAND ${CMAKE_COMMAND} -E copy "${CMAKE_PREFIX_PATH}/lib/libQt6Core.so" "${INSTALL_DIR}/lib"
                      COMMAND ${CMAKE_COMMAND} -E copy "${CMAKE_PREFIX_PATH}/lib/libQt6Core.so.6" "${INSTALL_DIR}/lib"
                      COMMAND ${CMAKE_COMMAND} -E copy "${CMAKE_PREFIX_PATH}/lib/libQt6Core.so.6.7.3" "${INSTALL_DIR}/lib"
                      COMMAND ${CMAKE_COMMAND} -E copy "${CMAKE_PREFIX_PATH}/lib/libicui18n.so" "${INSTALL_DIR}/lib"
                      COMMAND ${CMAKE_COMMAND} -E copy "${CMAKE_PREFIX_PATH}/lib/libicui18n.so.56" "${INSTALL_DIR}/lib"
                      COMMAND ${CMAKE_COMMAND} -E copy "${CMAKE_PREFIX_PATH}/lib/libicui18n.so.56.1" "${INSTALL_DIR}/lib"
                      COMMAND ${CMAKE_COMMAND} -E copy "${CMAKE_PREFIX_PATH}/lib/libicuuc.so" "${INSTALL_DIR}/lib"
                      COMMAND ${CMAKE_COMMAND} -E copy "${CMAKE_PREFIX_PATH}/lib/libicuuc.so.56" "${INSTALL_DIR}/lib"
                      COMMAND ${CMAKE_COMMAND} -E copy "${CMAKE_PREFIX_PATH}/lib/libicuuc.so.56.1" "${INSTALL_DIR}/lib"
                      COMMAND ${CMAKE_COMMAND} -E copy "${CMAKE_PREFIX_PATH}/lib/libicudata.so" "${INSTALL_DIR}/lib"
                      COMMAND ${CMAKE_COMMAND} -E copy "${CMAKE_PREFIX_PATH}/lib/libicudata.so.56" "${INSTALL_DIR}/lib"
                      COMMAND ${CMAKE_COMMAND} -E copy "${CMAKE_PREFIX_PATH}/lib/libicudata.so.56.1" "${INSTALL_DIR}/lib"


                      COMMAND ${CMAKE_COMMAND} -E copy "${CMAKE_PREFIX_PATH}/lib/libQt6Core5Compat.so" "${INSTALL_DIR}/lib"
                      COMMAND ${CMAKE_COMMAND} -E copy "${CMAKE_PREFIX_PATH}/lib/libQt6Core5Compat.so.6" "${INSTALL_DIR}/lib"
                      COMMAND ${CMAKE_COMMAND} -E copy "${CMAKE_PREFIX_PATH}/lib/libQt6Core5Compat.so.6.7.3" "${INSTALL_DIR}/lib"

                      COMMAND ${CMAKE_COMMAND} -E copy "${CMAKE_PREFIX_PATH}/lib/libQt6DBus.so" "${INSTALL_DIR}/lib"
                      COMMAND ${CMAKE_COMMAND} -E copy "${CMAKE_PREFIX_PATH}/lib/libQt6DBus.so.6" "${INSTALL_DIR}/lib"
                      COMMAND ${CMAKE_COMMAND} -E copy "${CMAKE_PREFIX_PATH}/lib/libQt6DBus.so.6.7.3" "${INSTALL_DIR}/lib"



                      COMMAND ${CMAKE_COMMAND} -E copy "${CMAKE_PREFIX_PATH}/lib/libQt6Network.so" "${INSTALL_DIR}/lib"
                      COMMAND ${CMAKE_COMMAND} -E copy "${CMAKE_PREFIX_PATH}/lib/libQt6Network.so.6" "${INSTALL_DIR}/lib"
                      COMMAND ${CMAKE_COMMAND} -E copy "${CMAKE_PREFIX_PATH}/lib/libQt6Network.so.6.7.3" "${INSTALL_DIR}/lib"

                      COMMAND ${CMAKE_COMMAND} -E copy "${CMAKE_PREFIX_PATH}/lib/libQt6Sql.so" "${INSTALL_DIR}/lib"
                      COMMAND ${CMAKE_COMMAND} -E copy "${CMAKE_PREFIX_PATH}/lib/libQt6Sql.so.6" "${INSTALL_DIR}/lib"
                      COMMAND ${CMAKE_COMMAND} -E copy "${CMAKE_PREFIX_PATH}/lib/libQt6Sql.so.6.7.3" "${INSTALL_DIR}/lib"
                      COMMAND ${CMAKE_COMMAND} -E copy "${CMAKE_PREFIX_PATH}/lib/libQt6Xml.so" "${INSTALL_DIR}/lib"
                      COMMAND ${CMAKE_COMMAND} -E copy "${CMAKE_PREFIX_PATH}/lib/libQt6Xml.so.6" "${INSTALL_DIR}/lib"
                      COMMAND ${CMAKE_COMMAND} -E copy "${CMAKE_PREFIX_PATH}/lib/libQt6Xml.so.6.7.3" "${INSTALL_DIR}/lib"

                      COMMAND ${CMAKE_COMMAND} -E make_directory "${INSTALL_DIR}/qml/QtCore"
                      COMMAND ${CMAKE_COMMAND} -E copy_directory "${CMAKE_PREFIX_PATH}/qml/QtCore" "${INSTALL_DIR}/qml/QtCore"


                      COMMAND ${CMAKE_COMMAND} -E make_directory "${INSTALL_DIR}/translations"
                      COMMAND ${CMAKE_COMMAND} -E copy_directory "${CMAKE_PREFIX_PATH}/translations" "${INSTALL_DIR}/translations"

                      COMMAND ${CMAKE_COMMAND} -E make_directory "${INSTALL_DIR}/plugins"
                      COMMAND ${CMAKE_COMMAND} -E make_directory "${INSTALL_DIR}/plugins/generic"
                      COMMAND ${CMAKE_COMMAND} -E copy "${CMAKE_PREFIX_PATH}/plugins/generic/libqtuiotouchplugin.so" "${INSTALL_DIR}/plugins/generic"
                      COMMAND ${CMAKE_COMMAND} -E make_directory "${INSTALL_DIR}/plugins/networkinformation"
                      COMMAND ${CMAKE_COMMAND} -E copy_directory "${CMAKE_PREFIX_PATH}/plugins/networkinformation" "${INSTALL_DIR}/plugins/networkinformation"
                      COMMAND ${CMAKE_COMMAND} -E make_directory "${INSTALL_DIR}/plugins/platforminputcontexts"
                      COMMAND ${CMAKE_COMMAND} -E copy "${CMAKE_PREFIX_PATH}/plugins/platforminputcontexts/libqtvirtualkeyboardplugin.so" "${INSTALL_DIR}/plugins/platforminputcontexts"
                      COMMAND ${CMAKE_COMMAND} -E make_directory "${INSTALL_DIR}/plugins/platforms"
                      COMMAND ${CMAKE_COMMAND} -E copy_directory "${CMAKE_PREFIX_PATH}/plugins/platforms" "${INSTALL_DIR}/plugins/platforms"
                      COMMAND ${CMAKE_COMMAND} -E make_directory "${INSTALL_DIR}/plugins/sqldrivers"
                      COMMAND ${CMAKE_COMMAND} -E copy_directory "${CMAKE_PREFIX_PATH}/plugins/sqldrivers" "${INSTALL_DIR}/plugins/sqldrivers"
                      COMMAND ${CMAKE_COMMAND} -E make_directory "${INSTALL_DIR}/plugins/tls"
                      COMMAND ${CMAKE_COMMAND} -E copy_directory "${CMAKE_PREFIX_PATH}/plugins/tls" "${INSTALL_DIR}/plugins/tls"



                      COMMAND ${CMAKE_COMMAND} -E make_directory "${INSTALL_DIR}/libexec"
                      COMMAND ${CMAKE_COMMAND} -E make_directory "${INSTALL_DIR}/resources"
                      COMMAND ${CMAKE_COMMAND} -E copy_directory "${CMAKE_PREFIX_PATH}/resources" "${INSTALL_DIR}/resources"
                  )
             endif()
endif()
endif()



