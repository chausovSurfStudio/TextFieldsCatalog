// Generated using SwiftGen, by O.Halligon — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// swiftlint:disable explicit_type_interface identifier_name line_length nesting type_body_length type_name
enum L10n {

  enum Button {
    /// Изменить пресет
    static let changePreset = L10n.tr("Localizable", "Button.changePreset")
    /// Сбросить
    static let reset = L10n.tr("Localizable", "Button.reset")
  }

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

  enum Main {

    enum Main {
      /// Какое-то сообщение о том, зачем вообще все это сделано
      static let message = L10n.tr("Localizable", "Main.Main.message")
      /// Каталог
      static let title = L10n.tr("Localizable", "Main.Main.title")
    }
  }

  enum Presets {

    enum Borderedfield {

      enum Email {
        /// Типичный кейс для поля ввода email
        static let description = L10n.tr("Localizable", "Presets.BorderedField.email.description")
        /// Email
        static let name = L10n.tr("Localizable", "Presets.BorderedField.email.name")
        /// Email
        static let placeholder = L10n.tr("Localizable", "Presets.BorderedField.email.placeholder")
      }

      enum Password {
        /// Типичный кейс для ввода пароля. Здесь должно быть подробное описание
        static let description = L10n.tr("Localizable", "Presets.BorderedField.password.description")
        /// Текст подсказки
        static let hint = L10n.tr("Localizable", "Presets.BorderedField.password.hint")
        /// Пароль
        static let name = L10n.tr("Localizable", "Presets.BorderedField.password.name")
        /// Пароль
        static let placeholder = L10n.tr("Localizable", "Presets.BorderedField.password.placeholder")
        /// Пароль слишком короткий
        static let shortErrorText = L10n.tr("Localizable", "Presets.BorderedField.password.shortErrorText")
      }
    }
  }

  enum Textfieldtype {

    enum Bordered {
      /// Границы поля ввода скруглены и подсвечены, имеется плейсхолдер над полем ввода, информационное-сообщение или сообщение об ошибке внизу, в одну строку. Есть возможность кастомизации с помощью своей кнопки. Кастомизируется под ввод пароля. Поддержка валидаторов и форматтеров.
      static let description = L10n.tr("Localizable", "TextFieldType.Bordered.description")
      /// Поле ввода с обводкой
      static let title = L10n.tr("Localizable", "TextFieldType.Bordered.title")
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
