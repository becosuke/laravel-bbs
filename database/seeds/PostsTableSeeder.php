<?php

use Illuminate\Database\Seeder;
use Illuminate\Support\Carbon;
use Illuminate\Support\Facades\DB;

class PostsTableSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
        $titles = [
            'ありがとう',
            'いいね返し',
            'おうちごはん',
            'お写んぽ',
            'お弁当',
            'お洒落',
            'お洒落さんと繋がりたい',
            'かわいい',
            'その瞬間に物語を',
            'つけ麺',
            'なんでもないただの道が好き',
            'ゆめ写いい写',
            'らーめん',
            'インスタ映え',
            'インテリア',
            'カメラのある生活',
            'カメラ女子',
            'キリトリセカイ',
            'コスメ',
            'コーデ',
            'スクリーンに恋して',
            'ダイエット',
            'ネイル',
            'バーベキュー',
            'ビキニフィットネス',
            'ファインダー越しの私の世界',
            'ファッション',
            'フィットネスモデル',
            'フィットネス女子クラブ',
            'ヘアアレンジ',
            'ヘルシー',
            'ベストボディジャパン',
            'ポトレ女子',
            'ポートレート',
            'ポートレート女子',
            'メイク',
            'モデル',
            'モデル募集',
            'ランチ',
            'ラーメン',
            'ラーメンインスタグラマー',
            'ラーメンパトロール',
            'ラーメン倶楽部',
            'ラーメン部',
            'ワークアウト',
            'ワークアウト女子',
            '中華そば',
            '人物撮影',
            '何気ない瞬間を残したい',
            '儚くて何処か愛おしいような',
            '写真好きな人と繋がりたい',
            '可愛い',
            '和風',
            '夕食',
            '大好き',
            '大阪',
            '大阪グルメ',
            '大阪ランチ',
            '幸せな瞬間をもっと世界に',
            '彼ごはん',
            '撮影',
            '料理',
            '日常に魔法をかけて',
            '日本体育大学チャレンジャー',
            '映え映え',
            '昼食',
            '朝食',
            '東京',
            '東京カメラ部',
            '桜',
            '毎日が笑顔で溢れてる',
            '河津桜',
            '洋風',
            '海',
            '犬',
            '猫',
            '空',
            '筋トレ女子',
            '美味しい',
            '美少女',
            '肖像',
            '花',
            '被写体',
            '被写体募集',
            '透明感のある世界',
            '遠い時の向こうでも',
            '食事管理',
            '高校フィルム',
            '麺スタグラム',
        ];

        shuffle($titles);
        $carbon = new Carbon();
        $posts = array_reverse(
            array_map(function ($title) use ($carbon ) {
                return ['title' => $title, 'datetime' => $carbon->subSeconds(mt_rand(60, 300))->toDateTimeString()];
            }, $titles)
        );
        foreach ($posts as $post) {
            DB::table('posts')->insert([
                'title' => $post['title'],
                'description' => '',
                'image' => '',
                'created_at' => $post['datetime'],
                'updated_at' => $post['datetime'],
            ]);
        }
    }
}
