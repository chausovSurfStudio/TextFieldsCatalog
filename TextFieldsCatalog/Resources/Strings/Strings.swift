// Generated using SwiftGen, by O.Halligon — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// swiftlint:disable explicit_type_interface identifier_name line_length nesting type_body_length type_name
enum L10n {

  enum Errors {

    enum Textfield {
      /// Поле должно быть заполнено
      static let empty = L10n.tr("Localizable", "Errors.TextField.empty")
      /// Неверный формат
      static let notValid = L10n.tr("Localizable", "Errors.TextField.notValid")
      /// Поле должно содержать минимум %@ символов
      static func short(_ p1: String) -> String {
        return L10n.tr("Localizable", "Errors.TextField.short", p1)
      }
    }
  }
}
// swiftlint:enable explicit_type_interface identifier_name line_length nesting type_body_length type_name

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = NSLocalizedString(key, tableName: table, bundle: Bundle(for: BundleToken.self), comment: "")
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

private final class BundleToken {}
