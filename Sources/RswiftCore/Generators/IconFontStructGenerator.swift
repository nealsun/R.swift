//
//  IconFontStructGenerator.swift
//  rswift
//
//  Created by aron on 2019/4/23.
//

import Foundation

struct IconFontStructGenerator: ExternalOnlyStructGenerator {

  let iconFonts: [IconFont]

  init(iconFonts: [IconFont]) {
    self.iconFonts = iconFonts
  }

  func generatedStruct(at externalAccessLevel: AccessLevel, prefix: SwiftIdentifier) -> Struct {
    let structName: SwiftIdentifier = "iconFont"
    let qualifiedName = prefix + structName

    let structs = iconFonts.compactMap { iconFont in
        return self.iconStructFromFontCss(iconFont: iconFont, at: externalAccessLevel, prefix: qualifiedName)
      }

    return Struct(
      availables: [],
      comments: ["This `\(qualifiedName)` struct is generated, and contains static references to icon fonts."],
      accessModifier: externalAccessLevel,
      type: Type(module: .host, name: structName),
      implements: [],
      typealiasses: [],
      properties: [],
      functions: [],
      structs: structs,
      classes: []
    )
  }

  private func iconStructFromFontCss(iconFont: IconFont, at externalAccessLevel: AccessLevel, prefix: SwiftIdentifier) -> Struct? {

    let structName = SwiftIdentifier(name: iconFont.filename)
    let qualifiedName = prefix + structName


    return Struct(
      availables: [],
      comments: ["This `\(qualifiedName)` struct is generated, and contains static references to ."],
      accessModifier: externalAccessLevel,
      type: Type(module: .host, name: structName),
      implements: [],
      typealiasses: [],
      properties: iconFont.parsedCss.map { key, value in iconFontLet(name: key, value: value, at: externalAccessLevel) },
      functions: iconFont.parsedCss.map { key, value in iconFontFunction(name: key, value: value, at: externalAccessLevel, prefix: qualifiedName) },
      structs: [],
      classes: []
    )
  }

  private func iconFontLet(name: String, value: String, at externalAccessLevel: AccessLevel) -> Let {

    return Let(
      comments: [],
      accessModifier: externalAccessLevel,
      isStatic: true,
      name: SwiftIdentifier(name: name),
      typeDefinition: .inferred(Type.IconFontResource),
      value: "Rswift.IconFontResource(name: \"\(name)\", value: \"\(value)\")"
    )
  }

  private func iconFontFunction(name: String, value: String, at externalAccessLevel: AccessLevel, prefix: SwiftIdentifier) -> Function {
    let structName = SwiftIdentifier(name: name)
    let qualifiedName = prefix + structName

    return Function(
      availables: [],
      comments: [],
      accessModifier: externalAccessLevel,
      isStatic: true,
      name: SwiftIdentifier(name: name),
      generics: nil,
      parameters: [
        Function.Parameter(name: "_", type: Type._Void, defaultValue: "()")
      ],
      doesThrow: false,
      returnType: Type._IconFont,
      body: "return \(qualifiedName).value"
    )
  }
}
