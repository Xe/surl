# Package

version       = "0.1.4"
author        = "Christine Dodrill"
description   = "Exceptionally dumb URL shortener/forwarder"
license       = "MIT"
srcDir        = "src"
bin           = @["shorten", "surl"]

# Dependencies

requires "nim", "jester", "shorturl"
