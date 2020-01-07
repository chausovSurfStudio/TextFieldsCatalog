// Generated using SwiftGen, by O.Halligon — https://github.com/SwiftGen/SwiftGen

#if os(OSX)
  import AppKit.NSImage
  typealias AssetColorTypeAlias = NSColor
  typealias Image = NSImage
#elseif os(iOS) || os(tvOS) || os(watchOS)
  import UIKit.UIImage
  typealias AssetColorTypeAlias = UIColor
  typealias Image = UIImage
#endif

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

@available(*, deprecated, renamed: "ImageAsset")
typealias AssetType = ImageAsset

struct ImageAsset {
  fileprivate var name: String

  var image: Image {
    let bundle = Bundle(for: BundleToken.self)
    #if os(iOS) || os(tvOS)
    let image = Image(named: name, in: bundle, compatibleWith: nil)
    #elseif os(OSX)
    let image = bundle.image(forResource: NSImage.Name(name))
    #elseif os(watchOS)
    let image = Image(named: name)
    #endif
    guard let result = image else { fatalError("Unable to load image named \(name).") }
    return result
  }
}

struct ColorAsset {
  fileprivate var name: String

  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, OSX 10.13, *)
  var color: AssetColorTypeAlias {
    return AssetColorTypeAlias(asset: self)
  }
}

// swiftlint:disable identifier_name line_length nesting type_body_length type_name
enum Asset {
  enum Colors {
    static let active = ColorAsset(name: "active")
    static let activePress = ColorAsset(name: "activePress")
    static let background = ColorAsset(name: "background")
    static let error = ColorAsset(name: "error")
    static let fieldNormal = ColorAsset(name: "fieldNormal")
    static let highlighted = ColorAsset(name: "highlighted")
    static let mainButtonText = ColorAsset(name: "mainButtonText")
    static let placeholderGray = ColorAsset(name: "placeholderGray")
    static let regular = ColorAsset(name: "regular")
    static let text = ColorAsset(name: "text")
  }
  enum MainTab {
    static let catalog = ImageAsset(name: "MainTab/catalog")
    static let example = ImageAsset(name: "MainTab/example")
    static let info = ImageAsset(name: "MainTab/info")
  }
  static let close = ImageAsset(name: "close")
  static let customEyeOff = ImageAsset(name: "customEyeOff")
  static let customEyeOn = ImageAsset(name: "customEyeOn")
  static let info = ImageAsset(name: "info")
  static let qrCode = ImageAsset(name: "qrCode")

  // swiftlint:disable trailing_comma
  static let allColors: [ColorAsset] = [
    Colors.active,
    Colors.activePress,
    Colors.background,
    Colors.error,
    Colors.fieldNormal,
    Colors.highlighted,
    Colors.mainButtonText,
    Colors.placeholderGray,
    Colors.regular,
    Colors.text,
  ]
  static let allImages: [ImageAsset] = [
    MainTab.catalog,
    MainTab.example,
    MainTab.info,
    close,
    customEyeOff,
    customEyeOn,
    info,
    qrCode,
  ]
  // swiftlint:enable trailing_comma
  @available(*, deprecated, renamed: "allImages")
  static let allValues: [AssetType] = allImages
}
// swiftlint:enable identifier_name line_length nesting type_body_length type_name

extension Image {
  @available(iOS 1.0, tvOS 1.0, watchOS 1.0, *)
  @available(OSX, deprecated,
    message: "This initializer is unsafe on macOS, please use the ImageAsset.image property")
  convenience init!(asset: ImageAsset) {
    #if os(iOS) || os(tvOS)
    let bundle = Bundle(for: BundleToken.self)
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(OSX)
    self.init(named: NSImage.Name(asset.name))
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

extension AssetColorTypeAlias {
  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, OSX 10.13, *)
  convenience init!(asset: ColorAsset) {
    let bundle = Bundle(for: BundleToken.self)
    #if os(iOS) || os(tvOS)
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(OSX)
    self.init(named: NSColor.Name(asset.name), bundle: bundle)
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

private final class BundleToken {}
