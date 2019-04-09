import httpclient, os

for i in 1.countup(paramCount()):
  let client = newHttpClient()
  client.headers = newHttpHeaders({ "X-API-Options": "bare" })

  var data = newMultipartData()
  data["url"] = i.paramStr()

  try:
    echo client.postContent("https://g.o/submit", multipart=data)

  except:
    quit getCurrentExceptionMsg()
