set(proj OSSIM)

if(NOT __EXTERNAL_${proj}__)
set(__EXTERNAL_${proj}__ 1)

message(STATUS "Setup Ossim...")

# OSGeo4W provides an "ossim" package : use it otherwise if it is installed and not used by OTB
# we get conflicts (because OSGeo4W include dir is included for other dependencies
#if(WIN32)
#  set(DEFAULT_USE_SYSTEM_OSSIM  ON)
#endif()

ADD_SYSTEM_LOCATION(PROJECT ${proj} VARIABLES ${proj}_LIBRARY ${proj}_INCLUDE_DIR)

if(USE_SYSTEM_OSSIM)
  find_package ( Ossim )
  add_custom_target(${proj})
  message(STATUS "  Using OSSIM system version")
else()
  SETUP_SUPERBUILD(PROJECT ${proj})
  message(STATUS "  Using OSSIM SuperBuild version")
  
  # declare dependencies
  set(${proj}_DEPENDENCIES TIFF GEOTIFF GEOS JPEG OPENTHREADS)
  INCLUDE_SUPERBUILD_DEPENDENCIES(${${proj}_DEPENDENCIES})
  # set proj back to its original value
  set(proj OSSIM)
  
  ADD_SUPERBUILD_CMAKE_VAR(TIFF_INCLUDE_DIR)
  ADD_SUPERBUILD_CMAKE_VAR(TIFF_LIBRARY)
  ADD_SUPERBUILD_CMAKE_VAR(GEOTIFF_INCLUDE_DIR)
  ADD_SUPERBUILD_CMAKE_VAR(GEOTIFF_LIBRARY)
  ADD_SUPERBUILD_CMAKE_VAR(GEOS_INCLUDE_DIR)
  ADD_SUPERBUILD_CMAKE_VAR(GEOS_LIBRARY)
  ADD_SUPERBUILD_CMAKE_VAR(JPEG_INCLUDE_DIR)
  ADD_SUPERBUILD_CMAKE_VAR(JPEG_LIBRARY)
  ADD_SUPERBUILD_CMAKE_VAR(OPENTHREADS_INCLUDE_DIR)
  ADD_SUPERBUILD_CMAKE_VAR(OPENTHREADS_LIBRARY)

  ExternalProject_Add(ossim_cmakemodules
    PREFIX ${proj}/_cmakemodules
    SVN_REPOSITORY "http://svn.osgeo.org/ossim/trunk/ossim_package_support/cmake/CMakeModules"
    SVN_REVISION -r 23087
    CONFIGURE_COMMAND ""
    BUILD_COMMAND ""
    INSTALL_COMMAND "")
    
  list(APPEND ${proj}_DEPENDENCIES ossim_cmakemodules)

  set(OSSIM_CXX_FLAGS  -D__STDC_CONSTANT_MACROS)
  
  if(MSVC)
    set(OSSIM_CXX_FLAGS /EHsc)
  endif()
  
  ExternalProject_Add(${proj}
    PREFIX ${proj}
    SVN_REPOSITORY "http://svn.osgeo.org/ossim/trunk/ossim/"
    SVN_REVISION -r 23092
    BINARY_DIR ${OSSIM_SB_BUILD_DIR}
    INSTALL_DIR ${SB_INSTALL_PREFIX}
    CMAKE_CACHE_ARGS
      -DOSSIM_VERSION:STRING=1.8.18-1
      -DCMAKE_INSTALL_PREFIX:STRING=${SB_INSTALL_PREFIX}
      -DCMAKE_BUILD_TYPE:STRING=Release
      -DCMAKE_CXX_FLAGS:STRING=${OSSIM_CXX_FLAGS}
      -DBUILD_OSSIM_MPI_SUPPORT:BOOL=OFF
      -DBUILD_OSSIM_APPS:BOOL=OFF
      -DBUILD_OSSIM_FRAMEWORKS:BOOL=OFF
      -DCMAKE_PREFIX_PATH:STRING=${SB_INSTALL_PREFIX};${CMAKE_PREFIX_PATH}
      ${OSSIM_SB_CONFIG}
    DEPENDS ${${proj}_DEPENDENCIES}
    CMAKE_COMMAND ${SB_CMAKE_COMMAND}
    )
    
    ExternalProject_Add_Step(${proj} copy_CMakeModules
      COMMAND ${CMAKE_COMMAND} -E copy_directory
      ${CMAKE_BINARY_DIR}/${proj}/_cmakemodules/src/ossim_cmakemodules ${OSSIM_SB_SRC}/CMakeModules
      DEPENDEES patch update
      DEPENDERS configure
    )  
  
  set(_SB_${proj}_INCLUDE_DIR ${SB_INSTALL_PREFIX}/include)
  if(WIN32)
    set(_SB_${proj}_LIBRARY ${SB_INSTALL_PREFIX}/lib/ossim.lib)
  elseif(UNIX)
    set(_SB_${proj}_LIBRARY ${SB_INSTALL_PREFIX}/lib/libossim${CMAKE_SHARED_LIBRARY_SUFFIX})
  endif()
  
endif()

endif()