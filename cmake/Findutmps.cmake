# - Try to find utmps and its dependencies
# Once done this will define
# UTMPS_FOUND - system has utmps and dependencies
# UTMPS_INCLUDE_DIR - the utmps include dir
# UTMPS_LIBRARIES - libutmps

if (UTMPS_INCLUDE_DIR AND UTMPS_LIBRARIES)
    # Already cached
    set(UTMPS_FIND_SILENTLY TRUE)
endif (UTMPS_INCLUDE_DIR AND UTMPS_LIBRARIES)

find_path(UTMPS_INCLUDE_DIR NAMES utmps/utmpx.h)
find_library(UTMPS_LIBRARY utmps)

if (UTMPS_INCLUDE_DIR AND UTMPS_LIBRARY)
    set(UTMPS_FOUND TRUE)
    set(UTMPS_LIBRARIES ${UTMPS_LIBRARY})
endif (UTMPS_INCLUDE_DIR AND UTMPS_LIBRARY)

if (UTMPS_FOUND)
    if (NOT UTMPS_FIND_SILENTLY)
        message(STATUS "Found utmps: ${UTMPS_LIBRARIES}")
    endif (NOT UTMPS_FIND_SILENTLY)
else (UTMPS_FOUND)
    if (UTMPS_FIND_REQUIRED)
        message(FATAL_ERROR "utmps was not found")
    endif (UTMPS_FIND_REQUIRED)
endif (UTMPS_FOUND)

