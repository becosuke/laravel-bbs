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

v0.0.2:
	@echo make generate-post-request

generate-post-request:
	@php artisan make:request CreatePost
	@patch app/Http/Requests/CreatePost.php patches/20200713235743-app-http-requests-create-post.patch
	@echo make generate-post-controller

generate-post-controller:
	@php artisan make:controller PostController
	@patch app/Http/Controllers/PostController.php patches/20200713191842-app-http-controllers-post.patch
	@echo make patch-index-view

patch-index-view:
	@patch resources/views/index.blade.php patches/20200713192831-resources-views-index.patch
	@echo make patch-post-route

patch-post-route:
	@patch routes/web.php patches/20200713193215-routes-web.patch
	@echo CONGRATS ON v0.0.3

v0.0.3:
	@echo make copy-consts-config

copy-consts-config:
	@mkdir -p config/consts
	@cp patches/20200717161531-config-consts-defaults.php config/consts/defaults.php
	@echo make patch-posts-seeder

patch-posts-seeder: init-db
	@patch database/seeds/PostsTableSeeder.php patches/20200717161729-database-seeds-posts-table-seeder.patch
	@php artisan db:seed --class=PostsTableSeeder
	@echo make patch-app-post

patch-app-post:
	@patch app/Post.php patches/20200717162800-app-post.patch
	@echo make patch-index-controller

patch-index-controller:
	@patch app/Http/Controllers/IndexController.php patches/20200717163147-app-http-controllers-index-controller.patch
	@echo make patch-index-view-paginate

patch-index-view-paginate:
	@patch resources/views/index.blade.php patches/20200717163600-resources-views-index.patch
	@echo CONGRATS ON v0.0.4

v0.0.4:
	@echo make patch-consts-config

patch-consts-config:
	@patch config/consts/defaults.php patches/20200718175259-config-consts-defaults.patch
	@echo make link-uploaded

link-uploaded:
	@ln -s ../storage/app/public/uploaded public/uploaded
	@echo make patch-post-request

patch-post-request:
	@patch app/Http/Requests/CreatePost.php patches/20200718175428-app-http-requests-create-post.patch
	@echo make patch-post-controller

patch-post-controller:
	@patch app/Http/Controllers/PostController.php patches/20200718175642-app-http-controllers-post-controller.patch
	@echo make patch-index-view-image

patch-index-view-image:
	@patch resources/views/index.blade.php patches/20200718180241-resources-views-index.patch
	@echo CONGRATS ON v0.0.5

v0.0.5:
	@echo make install-intervention-image

install-intervention-image:
	@php composer.phar require intervention/image
	@php artisan vendor:publish --provider="Intervention\Image\ImageServiceProviderLaravelRecent"
	@echo make patch-consts-config-resized

patch-consts-config-resized:
	@patch config/consts/defaults.php patches/20200723160126-config-consts-default.patch
	@echo make link-resized

link-resized:
	@mkdir storage/app/public/resized
	@ln -s ../storage/app/public/resized public/resized
	@echo make patch-post-controller-resized

patch-post-controller-resized:
	@patch app/Http/Controllers/PostController.php patches/20200723160336-app-http-controllers-post-controller.patch
	@echo make patch-index-view-resized

patch-index-view-resized:
	@patch resources/views/index.blade.php patches/20200723160447-resources-views-index.patch
	@echo CONGRATS ON v0.0.6
