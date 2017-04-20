//
//  main.swift
//  Perfect Markdown Editor
//
//  Created by Rockford Wei on 4/19/17.
//	Copyright (C) 2017 PerfectlySoft, Inc.
//
//===----------------------------------------------------------------------===//
//
// This source file is part of the Perfect.org open source project
//
// Copyright (c) 2017 - 2018 PerfectlySoft Inc. and the Perfect project authors
// Licensed under Apache License v2.0
//
// See http://perfect.org/licensing.html for license information
//
//===----------------------------------------------------------------------===//
//

import PerfectLib
import PerfectHTTP
import PerfectHTTPServer
import PerfectWebSockets
import PerfectMarkdown

/// server port to start with
let port = 7777

public class EditorHandler: WebSocketSessionHandler {

  public let socketProtocol : String? = "editor"

  // This function is called by the WebSocketHandler once the connection has been established.
  public func handleSession(request: HTTPRequest, socket: WebSocket) {

    socket.readStringMessage { input, _, _ in

      guard let input = input else {
        socket.close()
        return
      }//end guard

      // convert the input from markdown to HTML
      let output = input.markdownToHTML ?? ""

      socket.sendStringMessage(string: output, final: true) {
        self.handleSession(request: request, socket: socket)
      }//end send
    }//end readStringMessage
  }//end handleSession
}//end handler

func socketHandler(data: [String:Any]) throws -> RequestHandler {
	return {
		request, response in

    WebSocketHandler(handlerProducer: { (request: HTTPRequest, protocols: [String]) -> WebSocketSessionHandler? in

      guard protocols.contains("editor") else {
        return nil
      }//end guard

      return EditorHandler()
    }).handleRequest(request: request, response: response)
  }//end return
}//end handler

// default home page 
let homePage = "<html><head><title>Perfect Online Markdown Editor</title>\n" +
  "<meta http-equiv='Content-Type' content='text/html;charset=utf-8'>\n" +
  "<script language=javascript type='text/javascript'>\nvar input, output;\n" +
  "function init()\n { input=document.getElementById('textInput'); \noutput=document.getElementById('results');\n" +
  "sock=new WebSocket('ws://' + window.location.host + '/editor', 'editor');\n" +
  "sock.onmessage=function(evt) { output.innerHTML = evt.data; } }\n" +
  "function send() { sock.send(input.value); } \n" +
  "window.addEventListener('load', init, false);\n" +
  "</script></head><body><H1>Perfect Markdown Online Editor</H1>\n" +
  "<p><textarea id=textInput cols=60 rows=20 onkeyup='send()'></textarea></p>\n" +
  "<p id=results></p></body></html>"

/// page handler: will print a input form with the solution list below
func handler(data: [String:Any]) throws -> RequestHandler {
  return {
    request, response in
    response.setHeader(.contentType, value: "text/html")
    response.appendBody(string: homePage)
    response.completed()
  }//end return
}//end handler

/// favicon
func favicon(data: [String:Any]) throws -> RequestHandler {
  return {
    request, response in
    response.completed()
  }//end return
}//end handler

let confData = [
	"servers": [
		[
			"name":"localhost",
			"port":port,
			"routes":[
				["method":"get", "uri":"/", "handler":handler],
				["method":"get", "uri":"/favicon.ico", "handler":favicon],
        ["method":"get", "uri":"/editor", "handler":socketHandler]
			]
		]
	]
]

do {
	// Launch the servers based on the configuration data.
	try HTTPServer.launch(configurationData: confData)
} catch {
	fatalError("\(error)") // fatal error launching one of the servers
}
