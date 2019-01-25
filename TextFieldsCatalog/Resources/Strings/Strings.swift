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

    enum Cardexpirationdate {
      /// Пример поля ввода для срока окончания действия карты
      static let description = L10n.tr("Localizable", "Presets.cardExpirationDate.description")
      /// Введите месяц и год окончания срока действия
      static let errorMessage = L10n.tr("Localizable", "Presets.cardExpirationDate.errorMessage")
      /// Срок действия карты
      static let name = L10n.tr("Localizable", "Presets.cardExpirationDate.name")
      /// Срок действия карты
      static let placeholder = L10n.tr("Localizable", "Presets.cardExpirationDate.placeholder")
    }

    enum Cardnumber {
      /// Пример поля для ввода номера карты
      static let description = L10n.tr("Localizable", "Presets.cardNumber.description")
      /// Введите правильно номер Вашей карты
      static let errorMessage = L10n.tr("Localizable", "Presets.cardNumber.errorMessage")
      /// Номер карты
      static let name = L10n.tr("Localizable", "Presets.cardNumber.name")
      /// Номер карты
      static let placeholder = L10n.tr("Localizable", "Presets.cardNumber.placeholder")
    }

    enum Cvc {
      /// Пример поля для ввода CVC-кода карты
      static let description = L10n.tr("Localizable", "Presets.cvc.description")
      /// CVC-код должен содержать 3 цифры
      static let errorMessage = L10n.tr("Localizable", "Presets.cvc.errorMessage")
      /// CVC-код
      static let name = L10n.tr("Localizable", "Presets.cvc.name")
      /// CVC
      static let placeholder = L10n.tr("Localizable", "Presets.cvc.placeholder")
    }

    enum Email {
      /// Типичный кейс для поля ввода email
      static let description = L10n.tr("Localizable", "Presets.email.description")
      /// Email
      static let name = L10n.tr("Localizable", "Presets.email.name")
      /// Email
      static let placeholder = L10n.tr("Localizable", "Presets.email.placeholder")
    }

    enum Password {
      /// Типичный кейс для ввода пароля. Здесь должно быть подробное описание
      static let description = L10n.tr("Localizable", "Presets.password.description")
      /// Текст подсказки
      static let hint = L10n.tr("Localizable", "Presets.password.hint")
      /// Пароль должен содержать не более %@ символов
      static func largeErrorText(_ p1: String) -> String {
        return L10n.tr("Localizable", "Presets.password.largeErrorText", p1)
      }
      /// Пароль
      static let name = L10n.tr("Localizable", "Presets.password.name")
      /// Пароль
      static let placeholder = L10n.tr("Localizable", "Presets.password.placeholder")
      /// Пароль слишком короткий
      static let shortErrorText = L10n.tr("Localizable", "Presets.password.shortErrorText")
    }

    enum Phone {
      /// Пример поля ввода для номера телефона
      static let description = L10n.tr("Localizable", "Presets.phone.description")
      /// Номер телефона должен содержать 10 цифр
      static let errorMessage = L10n.tr("Localizable", "Presets.phone.errorMessage")
      /// Номер телефона
      static let name = L10n.tr("Localizable", "Presets.phone.name")
      /// Номер телефона
      static let placeholder = L10n.tr("Localizable", "Presets.phone.placeholder")
    }
  }

  enum Textfieldtype {

    enum Bordered {
      /// Границы поля ввода скруглены и подсвечены, имеется плейсхолдер над полем ввода, информационное-сообщение или сообщение об ошибке внизу, в одну строку. Есть возможность кастомизации с помощью своей кнопки. Кастомизируется под ввод пароля. Поддержка валидаторов и форматтеров.
      static let description = L10n.tr("Localizable", "TextFieldType.Bordered.description")
      /// Поле ввода с обводкой
      static let title = L10n.tr("Localizable", "TextFieldType.Bordered.title")
    }

    enum Underlined {
      /// Под полем ввода присутствует линия. Плейсхолдер выполнен как CATextLayer, что позволяет анимационно изменять его кегль, цвет и позицию при переходе между состояниями. Кастомизируется под ввод пароля. Поддержка валидаторов и форматтеров.
      static let description = L10n.tr("Localizable", "TextFieldType.Underlined.description")
      /// Подчеркнутое поле ввода
      static let title = L10n.tr("Localizable", "TextFieldType.Underlined.title")
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
