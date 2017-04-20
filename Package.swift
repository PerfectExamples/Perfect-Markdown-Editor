//
//  Package.swift
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
import PackageDescription

let package = Package(
    name: "PerfectMarkdownEditor",
    dependencies: [
	.Package(url: "https://github.com/PerfectlySoft/Perfect-HTTPServer.git", majorVersion: 2),
  .Package(url: "https://github.com/PerfectlySoft/Perfect-WebSockets.git", majorVersion:2),
  .Package(url: "https://github.com/PerfectlySoft/Perfect-Markdown.git", majorVersion: 1)
  ]
)
