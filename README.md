# leveldb.nim

A self-contained LevelDB wrapper for Nim in a Nim friendly way. Uses git-submodule and nimterop so that no external libraries have to be installed or linked.

Original nim LevelDB wrapper: [HERE](https://github.com/zielmicha/leveldb.nim)

Replacing of system library dependency with self-contained C/CPP interoperability by (Codex.Storage)[https://codex.storage]

## Usage

Create a database:
```Nim
   import leveldbstatic
   import options

   var db = leveldb.open("/tmp/mydata")
```

Read or modify the database content:
```Nim
   assert db.getOrDefault("nothing", "") == ""

   db.put("hello", "world")
   db.put("bin", "GIF89a\1\0")
   echo db.get("hello")
   assert db.get("hello").isSome()

   var key, val = ""
   for key, val in db.iter():
     echo key, ": ", repr(val)

   db.delete("hello")
   assert db.get("hello").isNone()
```

Batch writes:
```Nim
   let batch = newBatch()
   for i in 1..10:
     batch.put("key" & $i, $i)
   batch.delete("bin")
   db.write(batch)
```

Iterate over subset of database content:
```Nim
   for key, val in db.iterPrefix(prefix = "key1"):
     echo key, ": ", val
   for key, val in db.iter(seek = "key3", reverse = true):
     echo key, ": ", val

   db.close()
```

## Compiling with optimizations

This library can be compiled with the following optimization options. By default these are disabled. Provide the following nim compiler flags to enable them:
 - fdatasync from <unistd.h> `--passC:-DHAVE_FDATASYNC=1`
 - F_FULLSYNC from <fcntl.h> `--passC:-DHAVE_FULLFSYNC=1`
 - O_CLOEXEC from <fcntl.h> `--passC:-DHAVE_O_CLOEXEC=1`
 - crc32c from <crc32c/crc32c.h> `--passC:-DHAVE_CRC32C=1`
 - snappy from <snappy.h> `--passC:-DHAVE_SNAPPY=1`
 - zstd from <zstd.h> `--passC:-DHAVE_ZSTD=1`
