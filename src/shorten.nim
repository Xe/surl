import httpclient, os

for i in 1.countup(paramCount()):
  var data = newMultipartData()
  data["url"] = i.paramStr()

  try:
    echo "https://g.o/submit".postContent(multipart=data)

  except:
    echo getCurrentExceptionMsg()
