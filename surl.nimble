# Package

version       = "0.4.0"
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

task docker, "build and push docker image":
  const version = staticExec "git describe --tags"
  exec "docker build -t xena/surl:" & version & " ."
  exec "docker push xena/surl:" & version
