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

seeder:
	@php artisan db:seed --class=PostsTableSeeder

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

v0.0.1:
	@echo make generate-posts-migration

generate-posts-migration: artisan-make-migration-create-posts
	@patch $(shell find database/migrations -name '*_create_posts_table.php') patches/20200711172914-database-migrations-create-posts-table.patch
	@php artisan migrate
	@echo make generate-post-model

artisan-make-migration-create-posts:
	@php artisan make:migration create_posts_table --create=posts

generate-post-model:
	@php artisan make:model Post
	@echo make generate-index-controller

generate-index-controller:
	@php artisan make:controller IndexController
	@patch app/Http/Controllers/IndexController.php patches/20200713004714-app-http-controllers-index.patch
	@echo make create-index-view

create-index-view:
	@cp resources/views/welcome.blade.php resources/views/index.blade.php
	@patch resources/views/index.blade.php patches/20200713003445-resources-views-index.patch
	@echo make patch-index-route

patch-index-route:
	@patch routes/web.php patches/20200711165011-routes-web.patch
	@echo make generate-posts-seeder

generate-posts-seeder:
	@php artisan make:seeder PostsTableSeeder
	@patch database/seeds/PostsTableSeeder.php patches/20200712024852-database-seeds-posts-table-seeder.patch
	@php composer.phar dump-autoload
	@php artisan db:seed --class=PostsTableSeeder
	@echo make copy-thumbnail

copy-thumbnail:
	@mkdir -p public/img
	@cp patches/20200714002354-public-img-thumbnail.svg public/img/thumbnail.svg
	@echo CONGRATS ON v0.0.2
