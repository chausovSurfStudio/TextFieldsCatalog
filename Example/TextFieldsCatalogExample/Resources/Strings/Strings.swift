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

  enum Main {

    enum Info {
      /// Данный проект содержит каталог полей ввода, большая часть из которых имеет одинаковый API для взаимодействия с ними. Наличие встроенных валидаторов и форматтеров позволяет широко кастомизировать поведение полей ввода для различных целей: пароль, email, номер телефона и т.п. Более подробно ознакомиться с полями на деле можно открыв экран с примером и посмотреть работу в различных конфигурациях, часть которых из наиболее часто используемых уже включена в проект.\n\n• Если вам необходимо посмотреть на исходный код полей - он находится в дирректории TextFieldsCatalog/TextFields/TextFields.\n• Если вам необходимо посмотреть на исходный код настройки полей в различных конфигурациях - он находится в каталоге TextFieldsCatalog/TextFields/Types and presets/Presets.\n• Если вы - разработчик, и вы хотите добавить новое поле в данный каталог - то необходимо добавить исходный код своего поля ввода в соответствующую дирректорию, добавить новое значение в enum TextFieldType, реализовать свой файл с пресетами и поправить все возникшие ошибки, решение которых приведет к тому, что ваше поле ввода появится в каталоге.
      static let description = L10n.tr("Localizable", "Main.Info.description")
    }

    enum Main {
      /// Каталог
      static let title = L10n.tr("Localizable", "Main.Main.title")
    }
  }

  enum Presets {

    enum Cardexpirationdate {
      /// Пример работы поля для случая ввода срока действия карты.\n\n• Для соответствия содержимого корректному формату - используется форматтер с определенной маской.
      static let description = L10n.tr("Localizable", "Presets.cardExpirationDate.description")
      /// Введите месяц и год окончания срока действия
      static let errorMessage = L10n.tr("Localizable", "Presets.cardExpirationDate.errorMessage")
      /// Срок действия карты
      static let name = L10n.tr("Localizable", "Presets.cardExpirationDate.name")
      /// Срок действия карты
      static let placeholder = L10n.tr("Localizable", "Presets.cardExpirationDate.placeholder")
    }

    enum Cardnumber {
      /// Пример работы поля для случая ввода номера карты.\n\n• Для соответствия содержимого корректному формату - используется форматтер с определенной маской, вставка текста разрешена.\n• Маска поддерживает номера карт от 16 до 19 символов (как пример того, как можно настроить поле для ввода форматированного текста с длиной из некоторого диапазона)
      static let description = L10n.tr("Localizable", "Presets.cardNumber.description")
      /// Введите правильно номер Вашей карты
      static let errorMessage = L10n.tr("Localizable", "Presets.cardNumber.errorMessage")
      /// Номер карты
      static let name = L10n.tr("Localizable", "Presets.cardNumber.name")
      /// Номер карты
      static let placeholder = L10n.tr("Localizable", "Presets.cardNumber.placeholder")
    }

    enum Cvc {
      /// Пример работы поля для случая ввода срока действия карты.\n\n• Для соответствия содержимого корректному формату - используется форматтер с определенной маской, вставка текста разрешена.\n• При этом возможно применение обычного валидатора, в котором необходимо задать минимальную и максимальную длину содержимого равной трем, установить соответствующий тип клавиатуры и запретить вставку в поле ввода.
      static let description = L10n.tr("Localizable", "Presets.cvc.description")
      /// CVC-код должен содержать 3 цифры
      static let errorMessage = L10n.tr("Localizable", "Presets.cvc.errorMessage")
      /// CVC-код
      static let name = L10n.tr("Localizable", "Presets.cvc.name")
      /// CVC
      static let placeholder = L10n.tr("Localizable", "Presets.cvc.placeholder")
    }

    enum Email {
      /// Пример работы поля для случая ввода email-адреса.\n\n• Для корректной работы достаточно только изменить тип клавиатуры и задать валидатор, не позволяющий оставлять поле пустым и содержащий регулярное выражение.
      static let description = L10n.tr("Localizable", "Presets.email.description")
      /// Email
      static let name = L10n.tr("Localizable", "Presets.email.name")
      /// Email
      static let placeholder = L10n.tr("Localizable", "Presets.email.placeholder")
    }

    enum Password {
      /// Пример кастомизации и работы поля для ввода пароля.\n\n• Максимальная длина пароля - 20 символов (возможно сделать более изящное решение, изменив маску, что приведет к тому, что пользователь не введет более 20 символов в принципе).\n• Задана маска, которая не позволяет вводить пробелы и переносы строки.\n• Запрещена вставка символов.\n• Задано регулярное выражение: корректный пароль состоит из не менее 8 символов, букв латинского алфавита, хотя бы одной маленькой, одной большой буквы и одной цифры.\n\nВажная особенность: rightView у внутреннего текстфилда отсутствует, чтобы предотвратить наложение иконки с глазом поверх стрелки в режиме caps lock.\n\nЕще одна особенность: добавлен код, предотвращающий полное удаление содержимого при повторном вводе в поле ввода (дефолтное поведение, связанное с secureMode).
      static let description = L10n.tr("Localizable", "Presets.password.description")
      /// Пароль должен содержать буквы латинского алфавита, хотя бы одну маленькую, одну большую буквы и быть длинною не менее 8 символов
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
      /// Текст возможной подсказки
      static let shortHint = L10n.tr("Localizable", "Presets.password.shortHint")
    }

    enum Phone {
      /// Пример работы поля для случая ввода номера телефона.\n\n• Отличный пример совместного использования валидатора и форматтера. Форматтер позволяет задать маску под номер телефона, валидатор же проверяет на полноту его ввода.\n\nВ данном кейсе представлен пример ввода телефона в российском формате.
      static let description = L10n.tr("Localizable", "Presets.phone.description")
      /// Номер телефона должен содержать 10 цифр
      static let errorMessage = L10n.tr("Localizable", "Presets.phone.errorMessage")
      /// Номер телефона
      static let name = L10n.tr("Localizable", "Presets.phone.name")
      /// Номер телефона
      static let placeholder = L10n.tr("Localizable", "Presets.phone.placeholder")
    }

    enum Qrcode {
      /// Пример работы поля с кастомной кнопкой справа.\n\n• Контент для кнопки устанавливается вместе с модом самого текстового поля (метод setTextFieldMode).\n• Есть возможность указать необходимую иконку для кнопки, а также ее цвет в нормальном состоянии и состояниях highlighted/selected
      static let description = L10n.tr("Localizable", "Presets.qrCode.description")
      /// Можно считать QR-код с помощью камеры
      static let hint = L10n.tr("Localizable", "Presets.qrCode.hint")
      /// QR-код
      static let name = L10n.tr("Localizable", "Presets.qrCode.name")
      /// Введите QR-код
      static let placeholder = L10n.tr("Localizable", "Presets.qrCode.placeholder")
    }
  }

  enum Textfieldtype {

    enum Bordered {
      /// • Границы поля ввода скруглены и подсвечены.\n• Имеется плейсхолдер над полем ввода.\n• Информационное-сообщение или сообщение об ошибке внизу, в одну строку.\n• Кастомизируется под ввод пароля.\n• Поддержка валидаторов и форматтеров.
      static let description = L10n.tr("Localizable", "TextFieldType.Bordered.description")
      /// Поле ввода с обводкой
      static let title = L10n.tr("Localizable", "TextFieldType.Bordered.title")
    }

    enum Customunderlined {
      /// • То же самое, что и поле ввода с подчеркиванием, но кастомизированное.\n• Отсутствует лейбл с подсказкой/ошибкой.
      static let description = L10n.tr("Localizable", "TextFieldType.CustomUnderlined.description")
      /// Кастомизированое поле ввода с подчеркивание
      static let title = L10n.tr("Localizable", "TextFieldType.CustomUnderlined.title")
    }

    enum Underlined {
      /// • Под полем ввода присутствует линия.\n• Плейсхолдер выполнен как CATextLayer, что позволяет анимационно изменять его кегль, цвет и позицию при переходе между состояниями.\n• Кастомизируется под ввод пароля.\n• Информационное-сообщение или сообщение об ошибке внизу, в одну строку.\n• Поддержка валидаторов и форматтеров.
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
