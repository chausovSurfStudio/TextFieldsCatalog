# Заметки разработчика

Данный документ содержит вспомогательную информацию, которая поможет в будущем понять разработчикам тот или иной кусок логики. Документ для внутреннего использования.

## NativePlaceholderService

Сервис содержит метод `func updatePlaceholderVisibility(fieldState: FieldState)` с довольно странной логикой внутри.

Чтобы понять, почему именно так, а не как-то иначе - ниже предоставлено фото, которое объясняет взаимосвязь жизненных кейсов и логику внутри этого метода:

<p align="center">
	<img src="https://raw.githubusercontent.com/chausovSurfStudio/TextFieldsCatalog/master/tech_docs/Images/NativePlaceholderService.png" />
</p>