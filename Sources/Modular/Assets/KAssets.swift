// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#if os(OSX)
  import AppKit.NSImage
  internal typealias KAssetColorTypeAlias = NSColor
  internal typealias KAssetImageTypeAlias = NSImage
#elseif os(iOS) || os(tvOS) || os(watchOS)
  import UIKit.UIImage
  internal typealias KAssetColorTypeAlias = UIColor
  internal typealias KAssetImageTypeAlias = UIImage
#endif

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Asset Catalogs

// swiftlint:disable identifier_name line_length nesting type_body_length type_name
internal enum KAsset {
    internal enum Colors {
        internal static let background = KColorAsset(name: "kBackground")
        internal static let surface = KColorAsset(name: "kSurface")
        internal static let system = KColorAsset(name: "kSystem")
        internal static let text = KColorAsset(name: "kText")
        // Dark ios < 13
        internal static let backgroundDark = KColorAsset(name: "kBackgroundDark")
        internal static let surfaceDark = KColorAsset(name: "kSurfaceDark")
        internal static let systemDark = KColorAsset(name: "kSystemDark")
        internal static let textDark = KColorAsset(name: "kTextDark")
    }
    
    internal enum Keyboard {
        internal static let backspaceOff = KImageAsset(name: "kBackspaceOff")
        internal static let backspaceOn = KImageAsset(name: "kBackspaceOn")
        internal static let capslock = KImageAsset(name: "kCapslock")
        internal static let newline = KImageAsset(name: "kNewline")
        internal static let shiftOff = KImageAsset(name: "kShiftOff")
        internal static let shiftOn = KImageAsset(name: "kShiftOn")
        internal static let space = KImageAsset(name: "kSpace")
        internal static let switchKeyboard = KImageAsset(name: "kSwitchKeyboard")
        // Dark ios < 13
        internal static let backspaceOffDark = KImageAsset(name: "kBackspaceOffDark")
        internal static let backspaceOnDark = KImageAsset(name: "kBackspaceOnDark")
        internal static let capslockDark = KImageAsset(name: "kCapslockDark")
        internal static let newlineDark = KImageAsset(name: "kNewlineDark")
        internal static let shiftOffDark = KImageAsset(name: "kShiftOffDark")
        internal static let shiftOnDark = KImageAsset(name: "kShiftOnDark")
        internal static let spaceDark = KImageAsset(name: "kSpaceDark")
        internal static let switchKeyboardDark = KImageAsset(name: "kSwitchKeyboardDark")
    }
  
}
// swiftlint:enable identifier_name line_length nesting type_body_length type_name

// MARK: - Implementation Details

internal struct KColorAsset {
  internal fileprivate(set) var name: String

  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, OSX 10.13, *)
  internal var color: KAssetColorTypeAlias {
    return KAssetColorTypeAlias(asset: self)
  }
}

internal extension KAssetColorTypeAlias {
  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, OSX 10.13, *)
  convenience init!(asset: KColorAsset) {
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

internal struct KDataAsset {
  internal fileprivate(set) var name: String

  #if os(iOS) || os(tvOS) || os(OSX)
  @available(iOS 9.0, tvOS 9.0, OSX 10.11, *)
  internal var data: NSDataAsset {
    return NSDataAsset(asset: self)
  }
  #endif
}

#if os(iOS) || os(tvOS) || os(OSX)
@available(iOS 9.0, tvOS 9.0, OSX 10.11, *)
internal extension NSDataAsset {
  convenience init!(asset: KDataAsset) {
    let bundle = Bundle(for: BundleToken.self)
    #if os(iOS) || os(tvOS)
    self.init(name: asset.name, bundle: bundle)
    #elseif os(OSX)
    self.init(name: NSDataAsset.Name(asset.name), bundle: bundle)
    #endif
  }
}
#endif

internal struct KImageAsset {
  internal fileprivate(set) var name: String

  internal var image: KAssetImageTypeAlias {
    let bundle = Bundle(for: BundleToken.self)
    #if os(iOS) || os(tvOS)
    let image = KAssetImageTypeAlias(named: name, in: bundle, compatibleWith: nil)
    #elseif os(OSX)
    let image = bundle.image(forResource: NSImage.Name(name))
    #elseif os(watchOS)
    let image = KAssetImageTypeAlias(named: name)
    #endif
    guard let result = image else { fatalError("Unable to load image named \(name).") }
    return result
  }
}

internal extension KAssetImageTypeAlias {
  @available(iOS 1.0, tvOS 1.0, watchOS 1.0, *)
  @available(OSX, deprecated,
    message: "This initializer is unsafe on macOS, please use the ImageAsset.image property")
  convenience init!(asset: KImageAsset) {
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

private final class BundleToken {}
