import asyncdispatch, db_sqlite, jester, os, shorturl, strutils

const
  version = "indev"

let
  db = open("/home/xena/.local/within/surl/surl.db", nil, nil, nil)

try:
  db.exec sql"""
    create table if not exists urls
    ( id INTEGER PRIMARY KEY
    , url TEXT UNIQUE
    , hits INTEGER
    );
"""
except:
  quit getCurrentExceptionMsg()

settings:
  port = getEnv("PORT").parseInt().Port
  bindAddr = "0.0.0.0"

routes:
  get "/@id":
    try:
      let url = db.getValue(sql"select url from urls where id=?", (@"id").decodeURLSimple())
      if not url.contains(":"):
        halt "URL not found"

      redirect url
    except: halt getCurrentExceptionMsg()

runForever()
