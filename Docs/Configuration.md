# Кастомизация

## Содержание

- [Возможности кастомизации](#Возможности-кастомизации)
- [Параметры конфигурации](#Параметры-конфигурации)
	- [Обычный плейсхолдер (PlaceholderConfiguration)](#PlaceholderConfiguration)
	- [Плавающий плейсхолдер (FloatingPlaceholderConfiguration)](#FloatingPlaceholderConfiguration)
	- [Текстовое поле (TextFieldConfiguration)](#TextFieldConfiguration)
	- [Граница текстового поля (TextFieldBorderConfiguration)](#TextFieldBorderConfiguration)
	- [Линия под текстовым полем (LineConfiguration)](#LineConfiguration)
	- [Подсказка (HintConfiguration)](#HintConfiguration)
	- [Режим ввода пароля (PasswordModeConfiguration)](#PasswordModeConfiguration)
	- [Кнопка очистки (ActionButtonConfiguration)](#ActionButtonConfiguration)
	- [Background (BackgroundConfiguration)](#BackgroundConfiguration)
	- [Настройка цвета (ColorConfiguration)](#ColorConfiguration)

## Возможности кастомизации

Основная цель, преследовавшаяся при создании существующей системы кастомизации полей - сделать изменяемым все то, что в коде изначально задавалось константами: шрифт, его кегль, любой цвет, размеры элементов и их расположение. Часть из этих параметров вы можете кастомизировать, создав наследника поля со своим .xib файлом, где расположение и размер некоторых элементов будет отвечать вашим требованиям (подробнее этот процесс описан ниже в данной статье). Остальная же часть параметров задается через параметр `configuration`, существующий у каждого поля ввода данной библиотеки.

Каждое поле ввода имеет свой класс объекта `configuration`: `BorderedTextFieldConfiguration`, `UnderlinedTextFieldConfiguration`, `UnderlinedTextViewConfiguration`. Такая реализация необходима в силу того, что каждое поле уникально в своем роде, и требует различные параметры конфигурации для своей работы.

Рассмотрим более подробно элементы, доступные для изменения:

* BorderedTextField
	* [Обычный плейсхолдер](#PlaceholderConfiguration)
	* [Текстовое поле](#TextFieldConfiguration)
	* [Граница текстового поля](#TextFieldBorderConfiguration)
	* [Подсказка](#HintConfiguration)
	* [Режим ввода пароля](#PasswordModeConfiguration)
	* [Background](#BackgroundConfiguration)
* UnderlinedTextField
	* [Плавающий плейсхолдер](#FloatingPlaceholderConfiguration)
	* [Текстовое поле](#TextFieldConfiguration)
	* [Линия под текстовым полем](#LineConfiguration)
	* [Подсказка](#HintConfiguration)
	* [Режим ввода пароля](#PasswordModeConfiguration)
	* [Background](#BackgroundConfiguration)
* UnderlinedTextView
	* [Плавающий плейсхолдер](#FloatingPlaceholderConfiguration)
	* [Текстовое поле](#TextFieldConfiguration)
	* [Линия под текстовым полем](#LineConfiguration)
	* [Подсказка](#Подсказка-(HintConfiguration))
	* [Кнопка очистки](#ActionButtonConfiguration)
	* [Background](#BackgroundConfiguration)

## Параметры конфигурации

### PlaceholderConfiguration

Параметры конфигурации обычного плейсхолдера, используется в данный момент только в поле `BorderedTextField`.

* `font: UIFont` - шрифт плейсхолдера
* `colors: ColorConfiguration` - настройка цвета плейсхолдера в разных состояниях (смотри [ColorConfiguration](#ColorConfiguration))

### FloatingPlaceholderConfiguration

Параметры конфигурации 'плавающего' плейсхолдера, изменяющего свое положение и размеры в зависимости от состояния поля ввода.

* `font: UIFont` - шрифт текста для плейсхолдера. В данном случае, значимым является только `fontName`, кегль шрифта задается в других параметрах
* `height: CGFloat` - высота плейсхолдера
* `topInsets: UIEdgeInsets` - отступы плейсхолдера от границ контейнера, когда он находится в верхнем положении. Итоговое положение рассчитывается относительно верхней границы контейнера, потому параметр `bottom` будет игнорироваться
* `bottomInsets: UIEdgeInsets` - отступы плейсхолдера от границ контейнера, когда он находится в нижнем положении. Итоговое положение рассчитывается относительно верхней границы контейнера, потому параметр `bottom` будет игнорироваться
* `smallFontSize: CGFloat` - кегль шрифта для плейсхолдера, когда он будет находиться вверху
* `bigFontSize: CGFloat` - кегль шрифта для плейсхолдера, когда он будет находиться внизу
* `topColors: ColorConfiguration` - настройка цвета плейсхолдера в состоянии, когда он вверху ([ColorConfiguration](#ColorConfiguration))
* `bottomColors: ColorConfiguration` - настройка цвета плейсхолдера в состоянии, когда он внизу ([ColorConfiguration](#ColorConfiguration))

### TextFieldConfiguration

* `font: UIFont` - шрифт текста в поле ввода
* `defaultPadding: UIEdgeInsets` - отступы для текста в обычном состоянии, без каких-либо кнопок
* `increasedPadding: UIEdgeInsets` - данные отступы для текста в поле ввода будут применены при наличии `action` кнопки, к примеру, в режиме ввода пароля
* `tintColor: UIColor` - `tintColor` для поля ввода (фактически, цвет курсора)
* `colors: ColorConfiguration` - настройка цвета текста в различных состояниях поля ввода ([ColorConfiguration](#ColorConfiguration))

### TextFieldBorderConfiguration

### LineConfiguration

### HintConfiguration

### PasswordModeConfiguration

### ActionButtonConfiguration

### BackgroundConfiguration

### ColorConfiguration
