# Кастомизация

## Содержание

- [Возможности кастомизации](#Возможности-кастомизации)
- [Параметры конфигурации](#Параметры-конфигурации)
	- [Обычный плейсхолдер (PlaceholderConfiguration)](#Обычный-плейсхолдер-(PlaceholderConfiguration))
	- [Плавающий плейсхолдер (FloatingPlaceholderConfiguration)](#Плавающий-плейсхолдер-(FloatingPlaceholderConfiguration))
	- [Текстовое поле (TextFieldConfiguration)](#Текстовое-поле-(TextFieldConfiguration))
	- [Граница текстового поля (TextFieldBorderConfiguration)](#Граница-текстового-поля-(TextFieldBorderConfiguration))
	- [Линия под текстовым полем (LineConfiguration)](#Линия-под-текстовым-полем-(LineConfiguration))
	- [Подсказка (HintConfiguration)](#Подсказка-(HintConfiguration))
	- [Режим ввода пароля (PasswordModeConfiguration)](#Режим-ввода-пароля-(PasswordModeConfiguration))
	- [Кнопка очистки (ActionButtonConfiguration)](#Кнопка-очистки-(ActionButtonConfiguration))
	- [Background (BackgroundConfiguration)](#Background-(BackgroundConfiguration))
	- [Настройка цвета (ColorConfiguration)](#Настройка-цвета-(ColorConfiguration))

## Возможности кастомизации

Основная цель, преследовавшаяся при создании существующей системы кастомизации полей - сделать изменяемым все то, что в коде изначально задавалось константами: шрифт, его кегль, любой цвет, размеры элементов и их расположение. Часть из этих параметров вы можете кастомизировать, создав наследника поля со своим .xib файлом, где расположение и размер некоторых элементов будет отвечать вашим требованиям (подробнее этот процесс описан ниже в данной статье). Остальная же часть параметров задается через параметр `configuration`, существующий у каждого поля ввода данной библиотеки.

Каждое поле ввода имеет свой класс объекта `configuration`: `BorderedTextFieldConfiguration`, `UnderlinedTextFieldConfiguration`, `UnderlinedTextViewConfiguration`. Такая реализация необходима в силу того, что каждое поле уникально в своем роде, и требует различные параметры конфигурации для своей работы.

Рассмотрим более подробно элементы, доступные для изменения:

* BorderedTextField
	* [Обычный плейсхолдер]()
	* [Текстовое поле]()
	* [Граница текстового поля]()
	* [Подсказка]()
	* [Режим ввода пароля]()
	* [Background]()
* UnderlinedTextField
	* [Плавающий плейсхолдер]()
	* [Текстовое поле]()
	* [Линия под текстовым полем]()
	* [Подсказка]()
	* [Режим ввода пароля]()
	* [Background]()
* UnderlinedTextView
	* [Плавающий плейсхолдер]()
	* [Текстовое поле]()
	* [Линия под текстовым полем]()
	* [Подсказка]()
	* [Кнопка очистки]()
	* [Background]()

## Параметры конфигурации

### Обычный плейсхолдер (PlaceholderConfiguration)

### Плавающий плейсхолдер (FloatingPlaceholderConfiguration)

### Текстовое поле (TextFieldConfiguration)

### Граница текстового поля (TextFieldBorderConfiguration)

### Линия под текстовым полем (LineConfiguration)

### Подсказка (HintConfiguration)

### Режим ввода пароля (PasswordModeConfiguration)

### Кнопка очистки (ActionButtonConfiguration)

### Background (BackgroundConfiguration)

### Настройка цвета (ColorConfiguration)
