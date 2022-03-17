set(proj IGSIO)

set(${proj}_DEPENDS
  )

# Include dependent projects if any
ExternalProject_Include_Dependencies(${proj} PROJECT_VAR proj)

if(${CMAKE_PROJECT_NAME}_USE_SYSTEM_${proj})
  message(FATAL_ERROR "Enabling ${CMAKE_PROJECT_NAME}_USE_SYSTEM_${proj} is not supported !")
endif()

# Sanity checks
if(DEFINED ${proj}_DIR AND NOT EXISTS ${${proj}_DIR})
  message(FATAL_ERROR "${proj}_DIR variable is defined but corresponds to nonexistent directory")
endif()

if(NOT DEFINED ${proj}_DIR AND NOT ${CMAKE_PROJECT_NAME}_USE_SYSTEM_${proj})
  ExternalProject_SetIfNotDefined(
    ${CMAKE_PROJECT_NAME}_${proj}_GIT_REPOSITORY
    "${EP_GIT_PROTOCOL}://github.com/IGSIO/IGSIO.git"
    QUIET
    )

  ExternalProject_SetIfNotDefined(
    ${CMAKE_PROJECT_NAME}_${proj}_GIT_TAG
    "master"
    QUIET
    )

  set(EP_SOURCE_DIR ${CMAKE_BINARY_DIR}/${proj})
  set(EP_BINARY_DIR ${CMAKE_BINARY_DIR}/${proj}-build)

  set(IGSIO_USE_3DSlicer ON)
  if (DEFINED Slicer_EXTENSION_SOURCE_DIRS) # Custom build
    set(IGSIO_USE_3DSlicer OFF)
    list(APPEND ${proj}_DEPENDS
      VTK
      ITK
      )
  endif()

  set(BUILD_OPTIONS
    -DVTK_DIR:PATH=${VTK_DIR}
    -DITK_DIR:PATH=${ITK_DIR}
    -DUSE_SYSTEM_ZLIB:BOOL=ON
    -DZLIB_INCLUDE_DIR:PATH=${ZLIB_INCLUDE_DIR}
    -DZLIB_LIBRARY:PATH=${ZLIB_LIBRARY}
    -DZLIB_ROOT:PATH=${ZLIB_ROOT}

    -DIGSIO_SUPERBUILD:BOOL=ON
    -DIGSIO_USE_3DSlicer:BOOL=${IGSIO_USE_3DSlicer}
    -DIGSIO_BUILD_VOLUMERECONSTRUCTION:BOOL=ON
    -DIGSIO_BUILD_SEQUENCEIO:BOOL=ON
    -DIGSIO_SEQUENCEIO_ENABLE_MKV:BOOL=ON
    -DIGSIO_USE_VP9:BOOL=${SlicerIGSIO_USE_VP9}

    -DSlicer_DIR:PATH=${Slicer_DIR}
    -DBUILD_TESTING:BOOL=OFF
    )

  if (IGSIO_USE_3DSlicer)
    list(APPEND BUILD_OPTIONS
      -DSlicer_DIR:PATH=${Slicer_DIR}
      -DvtkAddon_DIR:PATH=${Slicer_DIR}/Libs/vtkAddon
      )
  endif()

  if (SlicerIGSIO_USE_VP9)
    list(APPEND ${proj}_DEPENDS
      VP9
      )
    list(APPEND BUILD_OPTIONS
      -DVP9_DIR:PATH=${VP9_DIR}
      )

endif()


  if (APPLE)
    list(APPEND BUILD_OPTIONS
      -DCMAKE_OSX_ARCHITECTURES:STRING=${CMAKE_OSX_ARCHITECTURES}
      -DCMAKE_OSX_DEPLOYMENT_TARGET:STRING=${CMAKE_OSX_DEPLOYMENT_TARGET}
      -DCMAKE_OSX_SYSROOT:STRING=${CMAKE_OSX_SYSROOT}
    )
  endif()

  IF (SlicerIGSIO_USE_GPU)
    list(APPEND BUILD_OPTIONS
      -DIGSIO_USE_GPU:BOOL=ON
      )
  ENDIF()

  IF (NOT vtkAddon_CMAKE_RUNTIME_OUTPUT_DIRECTORY)
    set(vtkAddon_CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_RUNTIME_OUTPUT_DIRECTORY})
  ENDIF()

  IF (NOT vtkAddon_CMAKE_LIBRARY_OUTPUT_DIRECTORY)
    set(vtkAddon_CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_LIBRARY_OUTPUT_DIRECTORY})
  ENDIF()

  ExternalProject_Add(${proj}
    ${${proj}_EP_ARGS}
    GIT_REPOSITORY "${${CMAKE_PROJECT_NAME}_${proj}_GIT_REPOSITORY}"
    GIT_TAG "${${CMAKE_PROJECT_NAME}_${proj}_GIT_TAG}"
    SOURCE_DIR ${EP_SOURCE_DIR}
    BINARY_DIR ${EP_BINARY_DIR}
    CMAKE_CACHE_ARGS
      # Compiler settings
      -DCMAKE_C_COMPILER:FILEPATH=${CMAKE_C_COMPILER}
      -DCMAKE_C_FLAGS:STRING=${ep_common_c_flags}
      -DCMAKE_CXX_COMPILER:FILEPATH=${CMAKE_CXX_COMPILER}
      -DCMAKE_CXX_FLAGS:STRING=${ep_common_cxx_flags}
      -DCMAKE_CXX_STANDARD:STRING=${CMAKE_CXX_STANDARD}
      -DCMAKE_CXX_STANDARD_REQUIRED:BOOL=${CMAKE_CXX_STANDARD_REQUIRED}
      -DCMAKE_CXX_EXTENSIONS:BOOL=${CMAKE_CXX_EXTENSIONS}
      -DCMAKE_POSITION_INDEPENDENT_CODE:BOOL=ON
      -DCMAKE_MACOSX_RPATH:BOOL=OFF
      -DCMAKE_C_USE_RESPONSE_FILE_FOR_OBJECTS:BOOL=${CMAKE_C_USE_RESPONSE_FILE_FOR_OBJECTS}
      -DCMAKE_C_USE_RESPONSE_FILE_FOR_LIBRARIES:BOOL=${CMAKE_C_USE_RESPONSE_FILE_FOR_LIBRARIES}
      -DCMAKE_CXX_USE_RESPONSE_FILE_FOR_OBJECTS:BOOL=${CMAKE_CXX_USE_RESPONSE_FILE_FOR_OBJECTS}
      -DCMAKE_CXX_USE_RESPONSE_FILE_FOR_LIBRARIES:BOOL=${CMAKE_CXX_USE_RESPONSE_FILE_FOR_LIBRARIES}
      # Output directories
      -DCMAKE_RUNTIME_OUTPUT_DIRECTORY:PATH=${CMAKE_BINARY_DIR}/${Slicer_THIRDPARTY_BIN_DIR}
      -DCMAKE_LIBRARY_OUTPUT_DIRECTORY:PATH=${CMAKE_BINARY_DIR}/${Slicer_THIRDPARTY_LIB_DIR}
      -DCMAKE_ARCHIVE_OUTPUT_DIRECTORY:PATH=${CMAKE_BINARY_DIR}/${Slicer_THIRDPARTY_LIB_DIR}
      -DIGSIO_INSTALL_BIN_DIR:PATH=${Slicer_THIRDPARTY_BIN_DIR}
      -DIGSIO_INSTALL_LIB_DIR:PATH=${Slicer_THIRDPARTY_LIB_DIR}
      -DvtkAddon_CMAKE_RUNTIME_OUTPUT_DIRECTORY:PATH=${vtkAddon_CMAKE_RUNTIME_OUTPUT_DIRECTORY}
      -DvtkAddon_CMAKE_LIBRARY_OUTPUT_DIRECTORY:PATH=${vtkAddon_CMAKE_LIBRARY_OUTPUT_DIRECTORY}
      # Install directories
      # NA
      # Options
      ${BUILD_OPTIONS}
    INSTALL_COMMAND ""
    DEPENDS
      ${${proj}_DEPENDS}
    )
  set(${proj}_DIR ${EP_BINARY_DIR}/inner-build)

else()
  ExternalProject_Add_Empty(${proj} DEPENDS ${${proj}_DEPENDS})
endif()

mark_as_superbuild(${proj}_DIR:PATH)
