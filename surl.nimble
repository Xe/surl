# Package

version       = "0.1.0"
author        = "Cadey Dodrill"
description   = "Exceptionally dumb URL shortener/forwarder"
license       = "MIT"
srcDir        = "src"
bin           = @["surl", "shorten"]

# Dependencies

requires "nim", "jester", "shorturl"
