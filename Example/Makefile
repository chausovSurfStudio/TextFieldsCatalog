# COLORS
GREEN  := $(shell tput -Txterm setaf 2)
YELLOW := $(shell tput -Txterm setaf 3)
WHITE  := $(shell tput -Txterm setaf 7)
RESET  := $(shell tput -Txterm sgr0)


TARGET_MAX_CHAR_NUM=20
## Show help
help:
	@echo ''
	@echo 'Usage:'
	@echo '  ${YELLOW}make${RESET} ${GREEN}<target>${RESET}'
	@echo ''
	@echo 'Targets:'
	@awk '/^[a-zA-Z\-\_0-9]+:/ { \
		helpMessage = match(lastLine, /^## (.*)/); \
		if (helpMessage) { \
			helpCommand = substr($$1, 0, index($$1, ":")-1); \
			helpMessage = substr(lastLine, RSTART + 3, RLENGTH); \
			printf "  ${YELLOW}%-$(TARGET_MAX_CHAR_NUM)s${RESET} ${GREEN}%s${RESET}\n", helpCommand, helpMessage; \
		} \
	} \
	{ lastLine = $$0 }' $(MAKEFILE_LIST)

## Initialization of the working environment.
init:
	# Install bundler if not installed
	if ! gem spec bundler > /dev/null 2>&1; then\
  		echo "bundler gem is not installed!";\
  		-sudo gem install bundler;\
	fi
	-bundle install --path .bundle
	-bundle exec pod repo update
	-bundle exec pod install

## Used to create a new module. Example: make screen modName=<ModuleName> flow=<FlowName>
screen:
	bundle exec generamba gen $(modName) surf_mvp_coordinatable_module --module_path 'TextFieldsCatalogExample/Flows/$(flow)'

## Used to create a new alert. Example: make alert modName=<AlertName> flow=<FlowName>
alert:
	bundle exec generamba gen $(modName) surf_mvp_coordinatable_alert --module_path 'TextFieldsCatalogExample/Flows/$(flow)'

## Allows you to perfrom swiftlint lint command.
lint:
	./Pods/SwiftLint/swiftlint lint --config .swiftlint.yml

## Allows you to perfrom swiftlint autocorrect command.
format:
	./Pods/SwiftLint/swiftlint autocorrect --config .swiftlint.yml

## Allows you to perform pod install command via bundler settings. Use it instead plain pod install command.
pod:
	bundle exec pod install