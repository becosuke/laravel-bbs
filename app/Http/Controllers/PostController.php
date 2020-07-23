<?php

namespace App\Http\Controllers;

use App\Http\Requests\CreatePost;
use App\Post;
use Illuminate\Support\Facades\Storage;
use Intervention\Image\Facades\Image;

class PostController extends Controller
{
    public function create(CreatePost $request)
    {
        $uploaded = $request->file('image')->store(config('consts.defaults.storage_uploaded_image_path'));
        $image = Image::make(Storage::get($uploaded));
        $smaller = function ($one, $two) {
            return $one < $two ? $one : $two;
        };
        $image->crop(
            $smaller($image->getWidth(), config('consts.defaults.image_width')),
            $smaller($image->getHeight(), config('consts.defaults.image_height'))
        );
        Storage::put(
            config('consts.defaults.storage_resized_image_path') . basename($uploaded),
            $image->encode()
        );
        $post = new Post();
        $post->setAttribute('title', $request->get('title', ''));
        $post->setAttribute('description', '');
        $post->setAttribute('image', basename($uploaded));
        $post->save();
        return redirect()->route('index');
    }
}
