# Package

version       = "0.1.6"
author        = "leveldbstatic authors"
description   = "Statically linked LevelDB wrapper for Nim"
license       = "MIT"
bin           = @["leveldbtool"]
installDirs   = @["build", "leveldbstatic", "vendor"]
installFiles  = @["leveldbstatic.nim"]

# Dependencies
requires "nim >= 1.4.0"
