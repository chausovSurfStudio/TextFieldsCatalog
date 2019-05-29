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
- [Создание собственного поля ввода](#Создание-собственного-поля-ввода)

## Возможности кастомизации

Основная цель, преследовавшаяся при создании существующей системы кастомизации полей - сделать изменяемым все то, что в коде изначально задавалось константами: шрифт, его кегль, любой цвет, размеры элементов и их расположение. Часть из этих параметров вы можете кастомизировать, создав наследника поля со своим `.xib` файлом, где расположение и размер некоторых элементов будет отвечать вашим требованиям (подробнее этот процесс описан [ниже](#Создание-собственного-поля-ввода) в данной статье). Остальная же часть параметров задается через параметр `configuration`, существующий у каждого поля ввода данной библиотеки.

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

Параметры настройки текста и его отступов в поле ввода.

* `font: UIFont` - шрифт текста в поле ввода
* `defaultPadding: UIEdgeInsets` - отступы для текста в обычном состоянии, без каких-либо кнопок
* `increasedPadding: UIEdgeInsets` - данные отступы для текста в поле ввода будут применены при наличии `action` кнопки, к примеру, в режиме ввода пароля
* `tintColor: UIColor` - `tintColor` для поля ввода (фактически, цвет курсора)
* `colors: ColorConfiguration` - настройка цвета текста в различных состояниях поля ввода ([ColorConfiguration](#ColorConfiguration))

### TextFieldBorderConfiguration

Параметры для настройки границы таблицы, используется в данный момент только в поле `BorderedTextField`.

* `cornerRadius: CGFloat` - радиус скругления границы
* `width: CGFloat` - ширина границы
* `colors: ColorConfiguration` - цвета границы в различных состояниях поля ввода ([ColorConfiguration](#ColorConfiguration))

### LineConfiguration

Параметры для настройки цвета, размера и положения линии под полем ввода.

* `insets: UIEdgeInsets` - параметр позволяет управлять положением линии, отступы рассчитываются относительно верха контейнера, параметр `.bottom` будет в силу этого проигнорирован. При установке в `.zero` - линия не будет отрисована.
* `defaultHeight: CGFloat` - высота линии в неактивном состоянии поля ввода
* `increasedHeight: CGFloat` - высота линии, когда поле ввода в фокусе
* `cornerRadius: CGFloat` - радиус скругления линии
* `colors: ColorConfiguration` - цвета линии в различных состояниях поля ввода ([ColorConfiguration](#ColorConfiguration))

### HintConfiguration

Параметры конфигурации для лейбла сподсказкой/сообщением об ошибке.

* `font: UIFont` - шрифт для текста в лейбле с подсказкой
* `lineHeight: CGFloat` - под капотом в лейбле будет показана `attributedString` с нестандартным межстрочным интервалом, данным параметром можно управлять этим интервалом. Соответствует параметру `lineHeight` в Figma.
* `colors: ColorConfiguration` - цвет текста в лейбле в зависимости от состояния поля ввода ([ColorConfiguration](#ColorConfiguration))

### PasswordModeConfiguration

Параметры для настройки режима ввода пароля, позволяет определить цвета и иконки для кнопки, переключающей `isSecureTextEntry` значение.

* `secureModeOnImage: UIImage` - иконка кнопки, которая будет показана в режиме secure ввода
* `secureModeOffImage: UIImage` - иконка кнопки, которая будет показана при отключенном режиме secure ввода
* `normalColor: UIColor` - цвет иконки в нормальном состоянии
* `pressedColor: UIColor` - цвет иконки в нажатом состоянии

### ActionButtonConfiguration

У некоторых полей ввода присутствует возможность показа некой своей кастомной кнопки. С помощью данных параметров можно настроить ее визуальное отображение.

* `image: UIImage` - иконка в кнопке
* `normalColor: UIColor` - цвет иконки в нормальном состоянии
* `pressedColor: UIColor` - цвет иконки в нажатом состоянии

### BackgroundConfiguration

Данный параметр позволяет переопределить цвет backgroundColor для контейнера с полем ввода.

* `color: UIColor` - backgroundColor контейнера с полем ввода

### ColorConfiguration

Данные параметры позволяют переопределить цвет различных элементов внутри полей ввода.

* `error: UIColor` - цвет элемента в состоянии ошибки
* `normal: UIColor` - цвет элемента в нормальном состоянии (поле ввода не в фокусе)
* `active: UIColor` - цвет элемента в активном состоянии (когда поле ввода в фокусе)
* `disabled: UIColor` - цвет элемента в задизейбленном состоянии

## Создание собственного поля ввода

Зачастую при реализации того или иного поля ввода необходимо строго соблюсти дизайн: требуется точная установка положения и размеров тех или иных элементов. В этом случае - вам необходимо всего лишь создать собственный наследник от уже существующего поля ввода и с собственным `.xib` файлом.

**Важно**: при верстке вы можете поменять положение элементов, сделав свое поле уникальным, не похожим на другое, но при этом требуется выполнение одного единственного правила: все `IBOutlet` должны быть установлены. Если вам, к примеру, не нужен подстрочеченик с текстом ошибки/подсказки - вы можете поставить ему в качестве цвета текста `UIColor.clear`, или сделать его фрейм таким, что он никогда не будет отображен в поле ввода, но `IBOutlet` к нему необходимо притянуть в любом случае.

Предположим, что нам нужно создать свое поле `MyTextField`, дизайн которого в целом похож на `UnderlinedTextField`. Необходимо выполнить следующие шаги:

* создать два файла `MyTextField.swift`, `MyTextField.xib`
* в файле `MyTextField.swift` определить класс `final class MyTextField: UnderlinedTextField`
* в `.xib` файле указать в качестве File's Owner класс `MyTextField`
* перенести на view объект UITextField, и **внимание**: задать ему класс `InnerTextField`, ведь под капотом используется именно он. В качестве `Module` должен автоматически подставиться модуль TextFieldsCatalog
* то же самое и с кнопкой: она является наследником от `IconButton` из модуля TextFieldsCatalog
* добавить лейбл для подсказки
* подсоединить все IBOutlet-ы
* в классе `MyTextField` на создании объекта добавить код, переопределяющий его конфигурацию

В качестве примера можно посмотреть поле `CustomUnderlinedTextField` из Example-проекта.