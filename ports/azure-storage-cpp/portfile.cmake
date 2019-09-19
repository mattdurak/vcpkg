if(VCPKG_CMAKE_SYSTEM_NAME STREQUAL "WindowsStore")
    message(FATAL_ERROR "${PORT} does not currently support UWP")
endif()

include(vcpkg_common_functions)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO JinmingHu-MSFT/azure-storage-cpp
    REF 775c36936bb37d1964a827930e593be3f4cb5764
    SHA512 e3c2d813733e7cc9092b850a785372b63deb27ac72e0df0263ba81009bb7ee69bc6f3d8287015e17714bbe1d87eca0295626803c8a029ce02841d68d7904b2d1
    HEAD_REF dev
    PATCHES
        # on osx use the uuid.h that is part of the osx sdk
        builtin-uuid-osx.patch
        remove-gcov-dependency.patch
)

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}/Microsoft.WindowsAzure.Storage
    PREFER_NINJA
    OPTIONS
        -DCMAKE_FIND_FRAMEWORK=LAST
        -DBUILD_TESTS=OFF
        -DBUILD_SAMPLES=OFF
        -DGETTEXT_LIB_DIR=${CURRENT_INSTALLED_DIR}/include
)

vcpkg_install_cmake()

file(INSTALL
    ${SOURCE_PATH}/LICENSE.txt
    DESTINATION ${CURRENT_PACKAGES_DIR}/share/azure-storage-cpp RENAME copyright)
file(REMOVE_RECURSE
    ${CURRENT_PACKAGES_DIR}/debug/include)

vcpkg_copy_pdbs()

