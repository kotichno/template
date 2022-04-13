.PHONY: clean format get upgrade

get: 
	@echo "╠ Getting dependencies..."
	@flutter pub get

upgrade: 
	@echo "╠ Upgrading dependencies..."
	@flutter pub upgrade

format:
	@echo "╠ Formatting the code"
	@flutter format . -l 100

clean:
	@echo "╠ Clean the project"
	@flutter clean

br:
	@echo "╠ build_runner is building project ..."
	@flutter packages pub run build_runner build --delete-conflicting-outputs

intl:
	@echo "╠ Generating language strings ..."
	@flutter pub run intl_utils:generate && flutter format lib/l10n -l 100

analyze:
	@echo "╠ Analyzing ..."
	@flutter analyze

test:
	@echo "╠ Do tests..."
	@flutter test

golden:
	@echo "╠ Generating golden tests..."
	@flutter test --update-goldens
