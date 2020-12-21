// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {

  internal enum Button {
    /// Изменить пресет
    internal static let changePreset = L10n.tr("Localizable", "Button.changePreset")
    /// Готово
    internal static let done = L10n.tr("Localizable", "Button.done")
    /// Сбросить
    internal static let reset = L10n.tr("Localizable", "Button.reset")
  }

  internal enum Constants {
    internal enum MainTab {
      /// Каталог
      internal static let catalog = L10n.tr("Localizable", "Constants.MainTab.catalog")
      /// Примеры
      internal static let example = L10n.tr("Localizable", "Constants.MainTab.example")
      /// Инфо
      internal static let info = L10n.tr("Localizable", "Constants.MainTab.info")
    }
    internal enum Sex {
      /// Женский
      internal static let female = L10n.tr("Localizable", "Constants.Sex.female")
      /// Мужской
      internal static let male = L10n.tr("Localizable", "Constants.Sex.male")
    }
  }

  internal enum Example {
    /// Примеры
    internal static let title = L10n.tr("Localizable", "Example.title")
  }

  internal enum Info {
    /// Данный проект содержит каталог полей ввода, большая часть из которых имеет одинаковый API для взаимодействия с ними. Наличие встроенных валидаторов и форматтеров позволяет широко кастомизировать поведение полей ввода для различных целей: пароль, email, номер телефона и т.п. Более подробно ознакомиться с полями на деле можно открыв экран с примером и посмотреть работу в различных конфигурациях, часть которых из наиболее часто используемых уже включена в проект.\n\n• Если вам необходимо посмотреть на исходный код полей - он находится в дирректории TextFieldsCatalog/TextFields/TextFields.\n• Если вам необходимо посмотреть на исходный код настройки полей в различных конфигурациях - он находится в каталоге TextFieldsCatalog/TextFields/Types and presets/Presets.\n• Если вы - разработчик, и вы хотите добавить новое поле в данный каталог - то необходимо добавить исходный код своего поля ввода в соответствующую дирректорию, добавить новое значение в enum TextFieldType, реализовать свой файл с пресетами и поправить все возникшие ошибки, решение которых приведет к тому, что ваше поле ввода появится в каталоге.
    internal static let description = L10n.tr("Localizable", "Info.description")
    /// Инфо
    internal static let title = L10n.tr("Localizable", "Info.title")
  }

  internal enum Main {
    /// Каталог
    internal static let title = L10n.tr("Localizable", "Main.title")
  }

  internal enum Presets {
    internal enum Birthday {
      /// Пример работы поля для ввода какой либо даты. К примеру, даты рождения. Особенность состоит в том, что для ввода даты используется UIDatePicker.\n\n• Для корректной работы поля необходимо создать кастомное inputView, предоставляемое библиотекой, указав его размер, поле ввода, к которому оно будет относится, а также dateFormat (который по умолчанию установлен в dd.MM.yyyy).\n• При смене даты - текст в поле ввода будет меняться автоматически, в соответствии с установленным dateFormat, а саму дату можно получить, реализовав замыкание onDateChanged.\n• Toolbar кастомизируется, можно поменять текст 'return' кнопки, цвет кнопок, цвет бэкграунда, цвет сепараторов.\n• При установке previous/next input в полях ввода - в тулбаре автоматически появятся кнопки для навигации между полями. При этом создавать inputView необходимо до установки этих значений.\n• Имеется доступ к UIDatePicker, а соответственно, и его настройкам.
      internal static let description = L10n.tr("Localizable", "Presets.birthday.description")
      /// Вы должны выбрать дату своего рождения
      internal static let hint = L10n.tr("Localizable", "Presets.birthday.hint")
      /// Дата
      internal static let name = L10n.tr("Localizable", "Presets.birthday.name")
      /// Дата рождения
      internal static let placeholder = L10n.tr("Localizable", "Presets.birthday.placeholder")
    }
    internal enum CardExpirationDate {
      /// Пример работы поля для случая ввода срока действия карты.\n\n• Для соответствия содержимого корректному формату - используется форматтер с определенной маской.
      internal static let description = L10n.tr("Localizable", "Presets.cardExpirationDate.description")
      /// Введите месяц и год окончания срока действия
      internal static let errorMessage = L10n.tr("Localizable", "Presets.cardExpirationDate.errorMessage")
      /// Срок действия карты
      internal static let name = L10n.tr("Localizable", "Presets.cardExpirationDate.name")
      /// Срок действия карты
      internal static let placeholder = L10n.tr("Localizable", "Presets.cardExpirationDate.placeholder")
    }
    internal enum CardNumber {
      /// Пример работы поля для случая ввода номера карты.\n\n• Для соответствия содержимого корректному формату - используется форматтер с определенной маской, вставка текста разрешена.\n• Маска поддерживает номера карт от 16 до 19 символов (как пример того, как можно настроить поле для ввода форматированного текста с длиной из некоторого диапазона)
      internal static let description = L10n.tr("Localizable", "Presets.cardNumber.description")
      /// Введите правильно номер Вашей карты
      internal static let errorMessage = L10n.tr("Localizable", "Presets.cardNumber.errorMessage")
      /// Номер карты
      internal static let name = L10n.tr("Localizable", "Presets.cardNumber.name")
      /// Номер карты
      internal static let placeholder = L10n.tr("Localizable", "Presets.cardNumber.placeholder")
    }
    internal enum Comment {
      /// Пример работы поля в случае ввода какого-либо комментария, в данном случае - комментария к доставке.\n\n• Имеется возможность скрыть кнопку очистки содержимого.\n• Есть возможность полностью кастомизировать поле.
      internal static let description = L10n.tr("Localizable", "Presets.comment.description")
      /// Оставьте развернутый комментарий к доставке, он должен быть не менее 30 символов
      internal static let errorMessage = L10n.tr("Localizable", "Presets.comment.errorMessage")
      /// Пожалуйста, поделитесь с нами Вашим мнением
      internal static let hint = L10n.tr("Localizable", "Presets.comment.hint")
      /// Комментарий
      internal static let name = L10n.tr("Localizable", "Presets.comment.name")
      /// Комментарий к доставке
      internal static let placeholder = L10n.tr("Localizable", "Presets.comment.placeholder")
    }
    internal enum Cvc {
      /// Пример работы поля для случая ввода срока действия карты.\n\n• Для соответствия содержимого корректному формату - используется форматтер с определенной маской, вставка текста разрешена.\n• При этом возможно применение обычного валидатора, в котором необходимо задать минимальную и максимальную длину содержимого равной трем, установить соответствующий тип клавиатуры и запретить вставку в поле ввода.
      internal static let description = L10n.tr("Localizable", "Presets.cvc.description")
      /// CVC-код должен содержать 3 цифры
      internal static let errorMessage = L10n.tr("Localizable", "Presets.cvc.errorMessage")
      /// CVC-код
      internal static let name = L10n.tr("Localizable", "Presets.cvc.name")
      /// CVC
      internal static let placeholder = L10n.tr("Localizable", "Presets.cvc.placeholder")
    }
    internal enum Email {
      /// Пример работы поля для случая ввода email-адреса.\n\n• Для корректной работы достаточно только изменить тип клавиатуры и задать валидатор, не позволяющий оставлять поле пустым и содержащий регулярное выражение.
      internal static let description = L10n.tr("Localizable", "Presets.email.description")
      /// Email
      internal static let name = L10n.tr("Localizable", "Presets.email.name")
      /// Email
      internal static let placeholder = L10n.tr("Localizable", "Presets.email.placeholder")
    }
    internal enum Name {
      /// Пример поля ввода, в котором установлена маска с кастомной нотацией.\n\n• Поле имеет возможность установить маску для ввода, к примеру маску номера телефона, но есть и еще одна возможность использования: можно создать свою кастомную нотацию для маски (в частности, здесь применена кастомная нотация, где в маске символом R обозначается символ, соответствующий букве русского алфавита и пробелу).\n• Таким образом, в это поле нельзя ввести ничего, кроме пробела и букв русского алфавита.\n• В качестве приятного бонуса - пример, как можно обрезать пробелы в начале и конце строки при стнятии фокуса.
      internal static let description = L10n.tr("Localizable", "Presets.name.description")
      /// Используйте только русские буквы
      internal static let hint = L10n.tr("Localizable", "Presets.name.hint")
      /// Имя должно быть не более 20 символов
      internal static let largeTextError = L10n.tr("Localizable", "Presets.name.largeTextError")
      /// Имя
      internal static let name = L10n.tr("Localizable", "Presets.name.name")
      /// Используйте только русские буквы
      internal static let notValidError = L10n.tr("Localizable", "Presets.name.notValidError")
      /// Имя
      internal static let placeholder = L10n.tr("Localizable", "Presets.name.placeholder")
    }
    internal enum Password {
      /// Пример кастомизации и работы поля для ввода пароля.\n\n• Максимальная длина пароля - 20 символов (возможно сделать более изящное решение, изменив маску, что приведет к тому, что пользователь не введет более 20 символов в принципе).\n• Задана маска, которая не позволяет вводить пробелы и переносы строки.\n• Запрещена вставка символов.\n• Задано регулярное выражение: корректный пароль состоит из не менее 8 символов, букв латинского алфавита, хотя бы одной маленькой, одной большой буквы и одной цифры.\n\nВажная особенность: rightView у внутреннего текстфилда отсутствует, чтобы предотвратить наложение иконки с глазом поверх стрелки в режиме caps lock.\n\nЕще одна особенность: добавлен код, предотвращающий полное удаление содержимого при повторном вводе в поле ввода (дефолтное поведение, связанное с secureMode).
      internal static let description = L10n.tr("Localizable", "Presets.password.description")
      /// Пароль должен содержать буквы латинского алфавита, хотя бы одну маленькую, одну большую буквы и быть длинною не менее 8 символов
      internal static let hint = L10n.tr("Localizable", "Presets.password.hint")
      /// Пароль должен содержать не более %@ символов
      internal static func largeErrorText(_ p1: Any) -> String {
        return L10n.tr("Localizable", "Presets.password.largeErrorText", String(describing: p1))
      }
      /// Пароль
      internal static let name = L10n.tr("Localizable", "Presets.password.name")
      /// Пароль
      internal static let placeholder = L10n.tr("Localizable", "Presets.password.placeholder")
      /// Пароль слишком короткий
      internal static let shortErrorText = L10n.tr("Localizable", "Presets.password.shortErrorText")
      /// Текст возможной подсказки
      internal static let shortHint = L10n.tr("Localizable", "Presets.password.shortHint")
    }
    internal enum Phone {
      /// Пример работы поля для случая ввода номера телефона.\n\n• Отличный пример совместного использования валидатора и форматтера. Форматтер позволяет задать маску под номер телефона, валидатор же проверяет на полноту его ввода.\n\nВ данном кейсе представлен пример ввода телефона в российском формате.
      internal static let description = L10n.tr("Localizable", "Presets.phone.description")
      /// Номер телефона должен содержать 10 цифр
      internal static let errorMessage = L10n.tr("Localizable", "Presets.phone.errorMessage")
      /// Номер телефона
      internal static let name = L10n.tr("Localizable", "Presets.phone.name")
      /// Номер телефона
      internal static let placeholder = L10n.tr("Localizable", "Presets.phone.placeholder")
    }
    internal enum QrCode {
      /// Пример работы поля с кастомной кнопкой справа.\n\n• Контент для кнопки устанавливается вместе с модом самого текстового поля (метод setTextFieldMode).\n• Есть возможность указать необходимую иконку для кнопки, а также ее цвет в нормальном состоянии и состояниях highlighted/selected
      internal static let description = L10n.tr("Localizable", "Presets.qrCode.description")
      /// Можно считать QR-код с помощью камеры
      internal static let hint = L10n.tr("Localizable", "Presets.qrCode.hint")
      /// QR-код
      internal static let name = L10n.tr("Localizable", "Presets.qrCode.name")
      /// Введите QR-код
      internal static let placeholder = L10n.tr("Localizable", "Presets.qrCode.placeholder")
    }
    internal enum Sex {
      /// Пример работы поля для выбора какого-то значения из заранее заготовленного списка. Для более простого выбора используется барабан (UIPickerView).\n\n• Для корректной работы поля необходимо создать кастомное inputView, предоставляемое библиотекой, указав его размер, поле ввода, к которому оно будет относится, а также передать список необходимых к отображению значений.\n• При смене значения - текст в поле ввода будет меняться автоматически.\n• Toolbar кастомизируется, можно поменять текст 'return' кнопки, цвет кнопок, цвет бэкграунда, цвет сепараторов.\n• При установке previous/next input в полях ввода - в тулбаре автоматически появятся кнопки для навигации между полями. При этом создавать inputView необходимо до установки этих значений.
      internal static let description = L10n.tr("Localizable", "Presets.sex.description")
      /// Вы должны определиться со своим полом
      internal static let hint = L10n.tr("Localizable", "Presets.sex.hint")
      /// Пол
      internal static let name = L10n.tr("Localizable", "Presets.sex.name")
      /// Пол
      internal static let placeholder = L10n.tr("Localizable", "Presets.sex.placeholder")
    }
    internal enum Sum {
      /// Пример работы поля для ввода суммы.\n\n• Не самая простая его реализация.\n• Имеет три плейсхолдера, один - статический, второй - нативный. Третий же - кастомный, отвечает за символ валюты, перемещающийся вслед за текстом.\n• При ввода какого-либо валидного значения - оно устанавливается в нативный плейсхолдер.\n• Имеется обработка разных граничных значений при ввода, а также при снятии фокуса.\n• Коряво работает перемещение каретки ввода при добавлении символов или их удалении, если они проводятся не в конце вводимой строки, простите :(
      internal static let description = L10n.tr("Localizable", "Presets.sum.description")
      /// Сумма
      internal static let name = L10n.tr("Localizable", "Presets.sum.name")
      /// Сумма
      internal static let placeholder = L10n.tr("Localizable", "Presets.sum.placeholder")
    }
  }

  internal enum TextFieldType {
    internal enum Box {
      /// • Границы поля ввода скруглены и подсвечены.\n• Имеется плейсхолдер над полем ввода.\n• Информационное-сообщение или сообщение об ошибке внизу, в одну строку.\n• Кастомизируется под ввод пароля.\n• Поддержка валидаторов и форматтеров.
      internal static let description = L10n.tr("Localizable", "TextFieldType.Box.description")
      /// Поле ввода с обводкой
      internal static let title = L10n.tr("Localizable", "TextFieldType.Box.title")
    }
    internal enum CustomUnderlined {
      /// • То же самое, что и поле ввода с подчеркиванием, но кастомизированное.\n• Отсутствует лейбл с подсказкой/ошибкой.
      internal static let description = L10n.tr("Localizable", "TextFieldType.CustomUnderlined.description")
      /// Кастомизированое поле ввода с подчеркивание
      internal static let title = L10n.tr("Localizable", "TextFieldType.CustomUnderlined.title")
    }
    internal enum SumTextField {
      /// • Пример кастомизации полей для случая ввода суммы.\n• Имеет целых три плейхолдера, один из которых - кастомный.\n• Логика для обработки введенных значений не привязана к библиотеке, реализована в качестве примера.\n• Помимо прочего - введенный текст уменьшается, если не влезает в границы поля.
      internal static let description = L10n.tr("Localizable", "TextFieldType.SumTextField.description")
      /// Поле ввода суммы
      internal static let title = L10n.tr("Localizable", "TextFieldType.SumTextField.title")
    }
    internal enum Underlined {
      /// • Под полем ввода присутствует линия.\n• Плейсхолдер выполнен как CATextLayer, что позволяет анимационно изменять его кегль, цвет и позицию при переходе между состояниями.\n• Кастомизируется под ввод пароля.\n• Информационное-сообщение или сообщение об ошибке внизу, в одну строку.\n• Поддержка валидаторов и форматтеров.
      internal static let description = L10n.tr("Localizable", "TextFieldType.Underlined.description")
      /// Подчеркнутое поле ввода
      internal static let title = L10n.tr("Localizable", "TextFieldType.Underlined.title")
    }
    internal enum UnderlinedTextView {
      /// • По дизайну - то же самое, что и просто подчеркнутое поле ввода.\n• Имеет практически все его возможности, за некоторым исключением (нет тех методов, которые данному полю в принципе не нужны).\n• В основном используется для полей ввода комментариев - то есть в тех местах, где текст будет явно превышать одну строку. Именно по этому данное поле - пока что единственная в этой библиотеке обертка именно над UITextView, а не UITextField\n• Имеется возможность показа/скрытия кнопки очистки содержимого.
      internal static let description = L10n.tr("Localizable", "TextFieldType.UnderlinedTextView.description")
      /// UITextView с подчеркиванием
      internal static let title = L10n.tr("Localizable", "TextFieldType.UnderlinedTextView.title")
    }
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: nil, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
