# TextFieldsCatalog

[![Build Status](https://travis-ci.org/chausovSurfStudio/TextFieldsCatalog.svg?branch=master)](https://travis-ci.org/chausovSurfStudio/TextFieldsCatalog)
[![Version](https://img.shields.io/cocoapods/v/TextFieldsCatalog.svg?style=flat)](https://cocoapods.org/pods/TextFieldsCatalog)
[![Platform](https://img.shields.io/cocoapods/p/TextFieldsCatalog.svg?style=flat)](https://cocoapods.org/pods/TextFieldsCatalog)
[![License](https://img.shields.io/cocoapods/l/TextFieldsCatalog.svg?style=flat)](https://cocoapods.org/pods/TextFieldsCatalog)
[![Swift Version](https://img.shields.io/badge/swift-4.2-orange.svg)](https://developer.apple.com/swift/)
[![codebeat badge](https://codebeat.co/badges/ae1cc1f8-72c1-4a84-9400-7e14defc904d)](https://codebeat.co/projects/github-com-chausovsurfstudio-textfieldscatalog-master)

## Overview

Данный репозиторий содержит коллекцию различных полей ввода, предоставляющих богатые возможности по проверке введенных значений и форматированию текста при вводе. К тому же, они просто симпатичные и хорошо кастомизируются :)

<p align="center">
	<img src="./Docs/Images/TextFieldsCatalog_video.gif" />
</p>

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

Этих действий вполне достаточно для базовой конфигурации поля ввода. Для получения более подробной информации - рекомендуется посмотреть Example проект и прочитать [документацию](/Docs/Usage.md).

## Строение репозитория

Фактически, репозиторий включает в себя как и сам `pod`, так и полноценный Example проект, на котором можно сразу протестировать на деле новое поле или изменения в существующих.

## Документация

[Документация по тестовому проекту](/Docs/ExampleProject.md)

[Документ по проекту с каталогом полей ввода](/Docs/PodProject.md)

[Документация по возможностям полей ввода](/Docs/Usage.md)

## Лицензия

TextFieldsCatalog распространяется под MIT [лицензией](./LICENSE.md)
