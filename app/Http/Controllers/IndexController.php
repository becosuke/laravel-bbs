<?php

namespace App\Http\Controllers;

use App\Post;
use Illuminate\Http\Request;

class IndexController extends Controller
{
    /**
     * @return \Illuminate\Contracts\Support\Renderable
     */
    public function index()
    {
        $posts = Post::query()->orderByDesc('created_at')->paginate(config('consts.defaults.contents_per_page'));
        return view('index')->with('posts', $posts);
    }
}
