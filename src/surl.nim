import asyncdispatch, db_sqlite, jester, os, prometheus, shorturl, strutils

const
  version = staticExec "git describe --tags"

include "./manifest.tmpl"
include "./index.tmpl"
include "./success.tmpl"

let
  dbPath = "DATABASE_PATH".getenv
  db = open(dbPath, "", "", "")
  domain = "DOMAIN".getenv
  theme = "THEME".getenv

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

var
  indexCounter = newCounter("index", "number of times the index page is rendered")
  errorCounter = newCounter("errors", "number of times an error happened")
  shortenHitCount = newCounter("shorten_hits", "number of times a shortened URL is hit")
  urlsSubmitted = newCounter("urls_submitted", "number of urls submitted")

routes:
  get "/metrics":
    let data = generateLatest()
    resp Http200, data, "text/plain"

  get "/":
    var urls: seq[string] = newSeq[string]()

    try:
      for x in db.fastRows(sql"select url from urls"):
        urls.add x[0]
    except:
      errorCounter.inc 1
      halt getCurrentExceptionMsg()

    indexCounter.inc 1
    resp genIndex(urls, version, theme)

  get "/manifest.json":
    resp Http200, genManifest(domain), "application/x-web-app-manifest+json; charset=UTF-8"

  get "/sw.js":
    const serviceWorker = staticRead "./sw.js"
    resp Http200, serviceWorker, "application/javascript"

  get "/@id":
    try:
      let url = db.getValue(sql"select url from urls where rowid=?", (@"id").decodeURLSimple())
      if not url.contains(":"):
        errorCounter.inc 1
        halt "URL not found"

      shortenHitCount.inc 1
      redirect url
    except:
      errorCounter.inc 1
      halt getCurrentExceptionMsg()

  post "/submit":
    let
      url = $(request.formData.getOrDefault "url").body
      id = db.tryInsertID(sql"insert into urls values (?)", url)

    if id == -1:
      errorCounter.inc 1
      halt "already exists"

    let to = "https://" & domain & "/" & (id.int).encodeURLSimple()

    if request.headers.getOrDefault("X-API-Options") == "bare" or @"options" == "bare":
      resp to
    else:
      resp genSuccess(url, to, theme)

runForever()
