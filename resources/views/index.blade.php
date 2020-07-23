<!DOCTYPE html>
<html lang="{{ str_replace('_', '-', app()->getLocale()) }}">
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">

        <title>Laravel</title>

        <link rel="stylesheet" href="{{ asset('/css/app.css') }}">
    </head>
    <body>
        <div class="d-flex flex-column flex-md-row align-items-center p-3 px-md-4 mb-3 bg-white border-bottom box-shadow">
            <h5 class="my-0 mr-md-auto font-weight-normal">Laravel</h5>
            <nav class="my-2 my-md-0 mr-md-3">
                @auth
                    <a class="p-2 text-dark" href="{{ url('/home') }}">Home</a>
                @else
                    <a class="btn btn-outline-primary" href="{{ route('login') }}">Login</a>
                    <a class="btn btn-outline-primary" href="{{ route('register') }}">Register</a>
                @endauth
            </nav>
        </div>
        <div class="album py-5 bg-light">
            <div class="container">
                <div class="row mb-5">
                    <div class="mx-auto col-md-8">
                        @if($errors->any())
                            <div class="mb-2">
                                <ul class="list-group">
                                    @foreach($errors->all() as $message)
                                        <li class="list-group-item list-group-item-danger">{{ $message }}</li>
                                    @endforeach
                                </ul>
                            </div>
                        @endif
                        <form action="{{ route('post.create') }}" method="post" enctype="multipart/form-data">
                            @csrf
                            <div class="form-group">
                                <label for="title">タイトル</label>
                                <input type="text" class="form-control" name="title" id="title">
                            </div>
                            <div class="form-group">
                                <label for="image">画像ファイル</label>
                                <input type="file" class="form-control-file" name="image" id="image">
                            </div>
                            <div class="clearfix">
                                <button type="submit" class="btn btn-primary float-right">投稿</button>
                            </div>
                        </form>
                    </div>
                </div>
                <div class="d-flex justify-content-center">
                    {{ $posts->links() }}
                </div>
                <div class="row">
                    @foreach($posts as $post)
                        <div class="col-md-4">
                            <div class="card mb-4 box-shadow">
                                @empty($post->image)
                                    <img class="card-img-top" data-src="{{ asset('/img/thumbnail.svg') }}" alt="Thumbnail [100%x225]" style="height: 225px; width: 100%; display: block;" src="{{ asset('/img/thumbnail.svg') }}" data-holder-rendered="true">
                                @else
                                    <img class="card-img-top" data-src="{{ asset(config('consts.defaults.public_resized_image_path') . $post->image) }}" alt="Uploaded Image" style="object-fit: none; object-position: center; height: 225px; max-width: 100%; display: block;" src="{{ asset(config('consts.defaults.public_resized_image_path') . $post->image) }}" data-holder-rendered="true">
                                @endempty
                                <div class="card-body">
                                    <p class="card-text">{{ $post->title }}</p>
                                    <div class="d-flex justify-content-between align-items-center">
                                        <div class="btn-group">
                                            <button type="button" class="btn btn-sm btn-outline-secondary">View</button>
                                            <button type="button" class="btn btn-sm btn-outline-secondary">Edit</button>
                                        </div>
                                        <small class="text-muted">{{ $post->created_at_diff }}</small>
                                    </div>
                                </div>
                            </div>
                        </div>
                    @endforeach
                </div>
                <div class="d-flex justify-content-center">
                    {{ $posts->links() }}
                </div>
            </div>
        </div>

        <script src="{{ asset('/js/app.js') }}"></script>
    </body>
</html>
