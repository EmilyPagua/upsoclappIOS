# -*- coding: utf-8 -*-
from urllib2 import *
import urllib
import json
import sys

myApiKey="AIzaSyDyG9UhUq7LRG6-AUaXKLf8GTH6heuq_XQ"

data={
    "to" : "/topics/global",
    "notification" : {
        "body" : "great 102!",
        "title" : "Portugal vs. Denmark"
    }
}

dataAsJSON = json.dumps(data)

print data

request = Request(
    "https://gcm-http.googleapis.com/gcm/send",
    dataAsJSON,
    { "Authorization" : "key="+myApiKey,
      "Content-type" : "application/json",
                  "message" :"hola",
                  "idPost" : 377570,
                  "contentTitle": "chi",
                  "idMessage" : 231423414
    }
)


print urlopen(request).read()


