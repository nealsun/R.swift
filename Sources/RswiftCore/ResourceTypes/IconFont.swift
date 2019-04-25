//
//  IconFont.swift
//  rswift
//
//  Created by aron on 2019/4/23.
//

import Foundation

struct IconFont: WhiteListedExtensionsResourceType {
  static var supportedExtensions: Set<String> = ["css"]

  let filename: String

  var parsedCss: [String: String] = [:]

  init(url: URL) throws {
    try IconFont.throwIfUnsupportedExtension(url.pathExtension)
    if url.lastPathComponent != "iconfont.css" {
      throw ResourceParsingError.parsingFailed("only iconfont.css supported")
    }

    guard let filename = url.filename else {
      throw ResourceParsingError.parsingFailed("Couldn't extract filename without extension from URL: \(url)")
    }

    self.filename = filename

    let content = try! String(contentsOf: url, encoding: .utf8)
//    "\\.(.*):before\\s{\\n\\s*content:\\s\"\\\\(\\w*)\""
//    #"\.(.*):before\s\{\n\s*content:\s"\\(\w*)""#
    let reg = try! NSRegularExpression(pattern:  "\\.(.*):before\\s\\{\\n\\s*content:\\s\"\\\\(\\w*)\"", options: [])
    reg.enumerateMatches(in: content, options: [], range: content.fullRange) { (match, flags, stop) in
      guard let match = match else { return }

      if match.numberOfRanges == 3,
        let firstCaptureRange = Range(match.range(at: 1),
                                     in: content),
        let secondCaptureRange = Range(match.range(at: 2),
                                       in: content)
      {
        parsedCss[String(content[firstCaptureRange])] = "\\u{\(String(content[secondCaptureRange]))}"
      }
    }
  }


}
