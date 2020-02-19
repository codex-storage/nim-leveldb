# Package

version       = "0.3.0"
author        = "Michał Zieliński"
description   = "LevelDB wrapper for Nim"
license       = "MIT"
srcDir        = "src"
installExt    = @["nim"]
binDir        = "bin"
bin           = @["leveldb"]

# Dependencies

requires "nim >= 0.18.0"
