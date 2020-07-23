<?php

namespace App;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Carbon;

class Post extends Model
{
    protected $appends = ['created_at_diff'];

    /**
     * @return string
     */
    public function getCreatedAtDiffAttribute()
    {
        try {
            $created_at = new Carbon($this->getAttribute($this->getCreatedAtColumn()));
        } catch (\Exception $e) {
            $created_at = new Carbon();
        }
        return $created_at->diffForHumans();
    }
}
