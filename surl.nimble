# Package

version       = "0.1.6"
author        = "Christine Dodrill"
description   = "Exceptionally dumb URL shortener/forwarder"
license       = "MIT"
srcDir        = "src"
bin           = @["shorten", "surl"]

# Dependencies

requires "nim", "jester", "shorturl"

task release, "release a new version of surl":
  exec "autotag"
  exec "git push"
  exec "git push --tags"
  exec "docker build -t xena/surl:$(git describe --tags)"
  exec "docker push xena/surl:$(git describe --tags)"
