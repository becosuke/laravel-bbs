help:
	@echo make v0.0.0

sync: install init-env init-db build

install: composer-install npm-install

init-db:
	@rm -f database/database.sqlite
	@touch database/database.sqlite
	@php artisan migrate

init-env:
	@cp .env.example .env
	@sed -i -e 's/^DB_\(.*\)$$/#DB_\1/' -e 's/#DB_CONNECTION=\(.*\)$$/DB_CONNECTION=sqlite/' .env
	@php artisan key:generate

composer-install:
	@php composer.phar install

composer-autoload:
	@php composer.phar dump-autoload

npm-install:
	@npm install

npm-build:
	@npm run dev

build: npm-build

up:
	@php artisan serve

v0.0.0:
	@echo make install-composer

install-composer:
	@curl -s -O https://getcomposer.org/installer
	@php installer
	@rm installer
	@echo make install-laravel

install-laravel:
	@php composer.phar create-project --prefer-dist laravel/laravel laravel
	@find laravel -mindepth 1 -maxdepth 1 -not -name README.md | xargs -n 1 -IXXX mv XXX ./
	@rm -rf laravel
	@patch config/app.php patches/20200711165010-config-app.patch
	@echo make install-laravel-ui

install-laravel-ui:
	@php composer.phar require laravel/ui
	@php artisan ui vue --auth
	@grep /public/js/app.js .gitignore || echo /public/js/app.js >> .gitignore
	@grep /public/css/app.css .gitignore || echo /public/css/app.css >> .gitignore
	@grep /public/mix-manifest.json .gitignore || echo /public/mix-manifest.json >> .gitignore
	@echo make finalize-install

finalize-install: npm-install init-env init-db build
	@grep /database/database.sqlite .gitignore || echo /database/database.sqlite >> .gitignore
	@echo CONGRATS ON v0.0.1
