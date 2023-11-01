cmake_minimum_required(VERSION 3.24.0)
cmake_policy(VERSION 3.24.0)
include(ExternalProject)

project(playdate-lua LANGUAGES C VERSION 5.4.0)

ExternalProject_Add(lua
  URL "https://www.lua.org/ftp/lua-5.4.0.tar.gz"
  URL_HASH "SHA256=eac0836eb7219e421a96b7ee3692b93f0629e4cdb0c788432e3d10ce9ed47e28"
  CONFIGURE_COMMAND ""
  PATCH_COMMAND patch -p1 -d src < ${CMAKE_CURRENT_LIST_DIR}/patch/scratchminer_lua54.diff
  BUILD_COMMAND make generic
  BUILD_ALWAYS true
  BUILD_IN_SOURCE true
  INSTALL_COMMAND ""
)
