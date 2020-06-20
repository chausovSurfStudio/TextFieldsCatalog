# TextFieldsCatalog

[![GitHubActions Build Status](https://github.com/chausovSurfStudio/TextFieldsCatalog/workflows/CI/badge.svg)](https://github.com/chausovSurfStudio/TextFieldsCatalog/actions)
[![Documentation](https://github.com/chausovSurfStudio/TextFieldsCatalog/blob/master/docs/badge.svg)](https://chausovsurfstudio.github.io/TextFieldsCatalog/)
[![Version](https://img.shields.io/cocoapods/v/TextFieldsCatalog.svg?style=flat)](https://cocoapods.org/pods/TextFieldsCatalog)
[![Platform](https://img.shields.io/cocoapods/p/TextFieldsCatalog.svg?style=flat)](https://cocoapods.org/pods/TextFieldsCatalog)
[![License](https://img.shields.io/cocoapods/l/TextFieldsCatalog.svg?style=flat)](https://cocoapods.org/pods/TextFieldsCatalog)
[![Swift Version](https://img.shields.io/badge/swift-5.0-orange.svg)](https://developer.apple.com/swift/)
[![codebeat badge](https://codebeat.co/badges/ae1cc1f8-72c1-4a84-9400-7e14defc904d)](https://codebeat.co/projects/github-com-chausovsurfstudio-textfieldscatalog-master)

## Overview

Данный репозиторий содержит коллекцию различных полей ввода, предоставляющих богатые возможности по проверке введенных значений и форматированию текста при вводе. К тому же, они просто симпатичные и хорошо кастомизируются :)

<p align="center">
	<img src="https://raw.githubusercontent.com/chausovSurfStudio/TextFieldsCatalog/master/tech_docs/Images/TextFieldsCatalog_video.gif" />
</p>

Полная документация - доступна на [GitHub Pages](https://chausovsurfstudio.github.io/TextFieldsCatalog/)

## Installation

### Cocoapods

Просто добавьте следующую строку в ваш Podfile:

````ruby
pod 'TextFieldsCatalog'
````

## First Step Guide

Предположим, вам необходимо реализовать поле ввода для Имени пользователя, которое должно быть от 5 до 25 символов и вас устраивает дизайн `UnderlinedTextField`, предоставляемый из коробки.

Вам необходимо выполнить следующие шаги:

* добавить в Podfile `pod 'TextFieldsCatalog'`, выполнить `pod install`, открыть `.workspace`
* добавить на экран UIView, изменить его класс на `UnderlinedTextField`, установить высоту равной 77
* во ViewController сделать `IBOutlet` на это поле, назвать, к примеру, `textField`
* сконфигурировать поле ввода
````swift
textField.configure(placeholder: "Имя", maxLength: 25)
textField.configure(autocapitalizationType: .words)
textField.validator = TextFieldValidator(minLength: 5, maxLength: 25, regex: nil)
````

Этих действий вполне достаточно для базовой конфигурации поля ввода. Для получения более подробной информации - рекомендуется посмотреть Example проект и прочитать [документацию][usage].

## Строение репозитория

Фактически, репозиторий включает в себя как и сам `pod`, так и полноценный Example проект, на котором можно сразу протестировать на деле новое поле или изменения в существующих.

## Документация

[Документация по тестовому проекту][exampleProject]

[Документ по проекту с каталогом полей ввода][podProject]

[Документация по возможностям полей ввода][usage]

## Лицензия

TextFieldsCatalog распространяется под MIT [лицензией][license]




[configuration]:	https://github.com/chausovSurfStudio/TextFieldsCatalog/blob/master/tech_docs/Configuration.md
[exampleProject]:	https://github.com/chausovSurfStudio/TextFieldsCatalog/blob/master/tech_docs/ExampleProject.md
[podProject]:		https://github.com/chausovSurfStudio/TextFieldsCatalog/blob/master/tech_docs/PodProject.md
[usage]:			https://github.com/chausovSurfStudio/TextFieldsCatalog/blob/master/tech_docs/Usage.md
[license]:			https://github.com/chausovSurfStudio/TextFieldsCatalog/blob/master/LICENSE