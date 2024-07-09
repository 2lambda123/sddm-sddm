# - Try to find utmps and its dependencies
# Once done this will define
# UTMPS_FOUND - system has utmps and dependencies
# UTMPS_INCLUDE_DIR - the utmps include dir
# UTMPS_LIBRARIES - libutmps, libskarnet library and sysdeps libraries

if (UTMPS_INCLUDE_DIR AND UTMPS_LIBRARIES)
    # Already cached
    set(UTMPS_FIND_SILENTLY TRUE)
endif (UTMPS_INCLUDE_DIR AND UTMPS_LIBRARIES)

find_path(UTMPS_INCLUDE_DIR NAMES utmps/utmpx.h)
find_library(UTMPS_LIBRARY utmps)
find_library(SKARNET_LIBRARY skarnet)

if (UTMPS_INCLUDE_DIR AND UTMPS_LIBRARY AND SKARNET_LIBRARY)
    set(UTMPS_FOUND TRUE)
    set(UTMPS_LIBRARIES ${UTMPS_LIBRARY} ${SKARNET_LIBRARY})
    find_library(SOCKET_LIBRARY NAMES socket nsl)
    if (SOCKET_LIBRARY)
        set(UTMPS_LIBRARIES ${UTMPS_LIBRARIES} ${SOCKET_LIBRARY})
    endif (SOCKET_LIBRARY)
    find_library(SYSCLOCK_LIBRARY rt)
    if (SYSCLOCK_LIBRARY)
        set(UTMPS_LIBRARIES ${UTMPS_LIBRARIES} ${SYSCLOCK_LIBRARY})
    endif (SYSCLOCK_LIBRARY)
endif (UTMPS_INCLUDE_DIR AND UTMPS_LIBRARY AND SKARNET_LIBRARY)

if (UTMPS_FOUND)
    if (NOT UTMPS_FIND_SILENTLY)
        message(STATUS "Found utmps: ${UTMPS_LIBRARIES}")
    endif (NOT UTMPS_FIND_SILENTLY)
else (UTMPS_FOUND)
    if (UTMPS_FIND_REQUIRED)
        message(FATAL_ERROR "utmps was not found")
    endif (UTMPS_FIND_REQUIRED)
endif (UTMPS_FOUND)

