
cmake_minimum_required(VERSION 3.23)

project(LMLM
    VERSION 0.1.0
    DESCRIPTION "Large Multifunctional Local Model Runtime"
    LANGUAGES C CXX
)

option(LMLM_BUILD_TESTS "Build LMLM tests" ON)
option(LMLM_BUILD_SHARED "Build shared runtime" OFF)
option(LMLM_ENABLE_CUDA "Enable CUDA backend" OFF)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

if(LMLM_BUILD_SHARED)
    set(LMLM_LIBRARY_TYPE SHARED)
else()
    set(LMLM_LIBRARY_TYPE STATIC)
endif()

add_library(lmlm_options INTERFACE)

target_compile_features(lmlm_options
    INTERFACE cxx_std_20
)

target_compile_definitions(lmlm_options
    INTERFACE LMLM_NATIVE_RUNTIME
)

add_library(lmlm_tensor STATIC
    src/core/tensor.cpp
)

target_link_libraries(lmlm_tensor
    PUBLIC lmlm_options
)

add_library(lmlm_memory STATIC
    src/memory/allocator.cpp
    src/memory/manager.cpp
)

target_link_libraries(lmlm_memory
    PUBLIC lmlm_options
)

add_library(lmlm_core ${LMLM_LIBRARY_TYPE}
    src/core/engine.cpp
    src/core/execution.cpp
    src/core/scheduler.cpp
)

target_include_directories(lmlm_core
    PUBLIC
        $<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}/include>
        $<INSTALL_INTERFACE:include>
)

target_link_libraries(lmlm_core
    PUBLIC lmlm_tensor
    PRIVATE lmlm_memory
    PUBLIC lmlm_options
)

add_library(LMLM::Core ALIAS lmlm_core)

add_executable(lmlm
    apps/cli/main.cpp
)

target_link_libraries(lmlm
    PRIVATE LMLM::Core
)

if(LMLM_ENABLE_CUDA)
    enable_language(CUDA)

    add_library(lmlm_cuda MODULE
        src/backends/cuda/backend.cu
    )

    target_link_libraries(lmlm_cuda
        PRIVATE LMLM::Core
    )
endif()

if(LMLM_BUILD_TESTS)
    enable_testing()

    add_executable(lmlm_tests
        tests/runtime_tests.cpp
    )

    target_link_libraries(lmlm_tests
        PRIVATE LMLM::Core
    )

    add_test(
        NAME lmlm_runtime_tests
        COMMAND lmlm_tests
    )
endif()

include(GNUInstallDirs)

install(TARGETS
    lmlm_core
    lmlm_tensor
    lmlm_memory
    EXPORT LMLMTargets
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)

install(TARGETS lmlm
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)

install(DIRECTORY include/
    DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
)

install(EXPORT LMLMTargets
    FILE LMLMTargets.cmake
    NAMESPACE LMLM::
    DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/LMLM
)
