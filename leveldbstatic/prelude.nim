import os

const
  root = currentSourcePath.parentDir.parentDir
  envWindows = root/"vendor"/"util"/"env_windows.cc"
  envPosix = root/"vendor"/"util"/"env_posix.cc"

  LevelDbCMakeFlags {.strdefine.} =
    when defined(macosx):
      "-DCMAKE_BUILD_TYPE=Release"
    elif defined(windows):
      "-G\"MSYS Makefiles\" -DCMAKE_BUILD_TYPE=Release"
    else:
      "-DCMAKE_BUILD_TYPE=Release"
  
  LevelDbDir {.strdefine.} = $(root/"vendor")
  buildDir = $(root/"build")

static:
  echo "Initializing submodule..."
  discard gorge "git submodule deinit -f \"" & root & "\""
  discard gorge "git submodule update --init --recursive --checkout \"" & root & "\""

  echo "\nClean dir: \"" & buildDir & "\""
  discard gorge "rm -rf " & buildDir
  discard gorge "mkdir -p " & buildDir

  let cmd = "cmake -S \"" & LevelDbDir & "\" -B \"" & buildDir & "\" " & LevelDbCmakeFlags
  echo "\nBuilding LevelDB: " & cmd
  let (output, exitCode) = gorgeEx cmd
  if exitCode != 0:
    discard gorge "rm -rf " & buildDir
    echo output
    raise (ref Defect)(msg: "Failed to build LevelDB")

when defined(windows):
  {.compile: envWindows.}
  {.passc: "-DLEVELDB_PLATFORM_WINDOWS".}
  {.passc: "-D_UNICODE".}
  {.passc: "-DUNICODE".}

when defined(posix):
  {.compile: envPosix.}
  {.passc: "-DLEVELDB_PLATFORM_POSIX".}
