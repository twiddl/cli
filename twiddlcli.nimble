# Package

version       = "0.1.0"
author        = "joachimschmidt557"
description   = "The twiddl CLI"
license       = "MIT"
srcDir        = "src"
bin           = @["twiddlcli"]



# Dependencies

requires "nim >= 0.20.0"
requires "argparse >= 0.8.3"
requires "terminaltables"
requires "https://github.com/twiddl/twiddl#master"
