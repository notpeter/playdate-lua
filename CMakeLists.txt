cmake_minimum_required(VERSION 3.24.0)
cmake_policy(VERSION 3.24.0)
include(ExternalProject)

project(playdate-lua LANGUAGES C VERSION 5.4.3)

ExternalProject_Add(lua
  URL "https://www.lua.org/ftp/lua-5.4.3.tar.gz"
  URL_HASH "SHA256=f8612276169e3bfcbcfb8f226195bfc6e466fe13042f1076cbde92b7ec96bbfb"
  CONFIGURE_COMMAND ""
  PATCH_COMMAND /bin/sh ${CMAKE_CURRENT_LIST_DIR}/patch/apply-patches.sh <SOURCE_DIR>/src
  BUILD_COMMAND make generic
  BUILD_ALWAYS true
  BUILD_IN_SOURCE true
  INSTALL_COMMAND ""
)
