import asyncdispatch, db_sqlite, jester, os, shorturl, strutils

const
  version = staticExec "git describe --tags"

include "./manifest.tmpl"
include "./index.tmpl"
include "./success.tmpl"

let
  dbPath = "DATABASE_PATH".getenv
  db = open(dbPath, "", "", "")
  domain = "DOMAIN".getenv

try:
  db.exec sql"""
    CREATE TABLE IF NOT EXISTS urls
      ( url TEXT    UNIQUE
      );
"""
except:
  quit getCurrentExceptionMsg()

settings:
  port = getEnv("PORT").parseInt().Port
  bindAddr = "0.0.0.0"

routes:
  get "/":
    var urls: seq[string] = newSeq[string]()

    for x in db.fastRows(sql"select url from urls"):
      urls.add x[0]

    resp genIndex(urls, version)

  get "/manifest.json":
    resp Http200, genManifest(domain), "application/json"

  get "/sw.js":
    const serviceWorker = staticRead "./sw.js"
    resp Http200, serviceWorker, "application/javascript"

  get "/@id":
    try:
      let url = db.getValue(sql"select url from urls where rowid=?", (@"id").decodeURLSimple())
      if not url.contains(":"):
        halt "URL not found"

      redirect url
    except: halt getCurrentExceptionMsg()

  post "/submit":
    let
      url = $(request.formData.getOrDefault "url").body
      id = db.tryInsertID(sql"insert into urls values (?)", url)

    if id == -1:
      halt "already exists"

    let to = "https://" & domain & "/" & (id.int).encodeURLSimple()

    if request.headers.getOrDefault("X-API-Options") == "bare" or @"options" == "bare":
      resp to
    else:
      resp genSuccess(url, to)

runForever()
