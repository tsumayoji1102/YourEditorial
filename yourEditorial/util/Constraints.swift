//
//  Constraints.swift
//  yourEditorial
//
//  Created by 塩見陵介 on 2020/10/19.
//

import UIKit

final class Constraints: NSObject {
    
    static let newsPapers: Array<NewsPaper> = [
    NewsPaper(
        name: "朝日新聞",
        url: "https://www.asahi.com/rensai/list.html?id=16",
        image: "asahi.png",
        group: NewsPaper.groups.nationWide
    ),
    NewsPaper(
        name: "産経新聞",
        url: "https://www.sankei.com/column/newslist/editorial-n1.html",
        image: "sankei.png",
        group: NewsPaper.groups.nationWide
    ),
    NewsPaper(
        name: "読売新聞",
        url: "https://www.yomiuri.co.jp/editorial/",
        image: "yomiuri.jpg",
        group: NewsPaper.groups.nationWide
    ),
    NewsPaper(
        name: "毎日新聞",
        url: "https://mainichi.jp/editorial/1",
        image: "mainichi.jpg",
        group: NewsPaper.groups.nationWide
    ),
    NewsPaper(
        name: "日本経済新聞",
        url: "https://www.nikkei.com/opinion/editorial/",
        image: "nikkei.png",
        group: NewsPaper.groups.nationWide
    ),
    NewsPaper(
        name: "北海道新聞",
        url: "https://www.hokkaido-np.co.jp/column/c_editorial",
        image: "hokkaido.jpg",
        group: NewsPaper.groups.block
    ),
    NewsPaper(
        name: "河北新報",
        url: "https://www.kahoku.co.jp/editorial/",
        image: "kahoku.jpeg",
        group: NewsPaper.groups.block
    ),
    NewsPaper(
        name: "東京新聞",
        url:"https://www.tokyo-np.co.jp/n/column/editorial/",
        image: "tokyo.jpg",
        group: NewsPaper.groups.block
        ),
    NewsPaper(
        name: "中国新聞",
        url: "https://www.chugoku-np.co.jp/column/article/?category_id=142&page=1",
        image: "tyugoku.png",
        group: NewsPaper.groups.block
    ),
    NewsPaper(
        name: "西日本新聞",
        url: "https://www.nishinippon.co.jp/category/column/editorial/",
        image: "nishinihon.jpg",
        group: NewsPaper.groups.block
    ),
    NewsPaper(
        name: "デーリー東北",
        url: "https://www.daily-tohoku.news/archives/category/column/jihyo",
        image: "dailyTohoku.jpg",
        group: NewsPaper.groups.local
        ),
    NewsPaper(
        name: "福島民報",
        url: "https://www.minpo.jp/news/column_ronsetsu",
        image: "hukushimaminpo.jpg",
        group: NewsPaper.groups.local
        ),
    NewsPaper(
        name: "秋田魁新報",
        url: "https://www.sakigake.jp/news/list/scd/100003001/?nv=akita",
        image: "akitamisinpo.png",
        group: NewsPaper.groups.local
    ),
    NewsPaper(
        name: "福島民友新聞",
        url: "https://www.minyu-net.com/shasetsu/shasetsu/",
        image: "fukushimaMinyu.jpg",
        group: NewsPaper.groups.local
        ),
    NewsPaper(
        name: "信濃毎日新聞",
        url: "https://www.shinmai.co.jp/news/list/4/97",
        image: "shinanoMainichi.jpg",
        group: NewsPaper.groups.local
    ),
    NewsPaper(
        name: "新潟日報",
        url: "https://www.niigata-nippo.co.jp/opinion/editorial/20201025576946.html",
        image: "nigata.jpg",
        group: NewsPaper.groups.local
    ),
    NewsPaper(
        name: "北國新聞",
        url: "https://www.hokkoku.co.jp/_syasetu/syasetu.htm",
        image: "kitaguni.jpeg",
        group: NewsPaper.groups.local
    ),
    NewsPaper(
        name: "福井新聞",
        url: "https://www.fukuishimbun.co.jp/category/editorial",
        image: "fukui.jpg",
        group: NewsPaper.groups.local
    ),
    NewsPaper(
        name: "京都新聞",
        url: "https://www.kyoto-np.co.jp/category/editorial",
        image: "kyoto.jpg",
        group: NewsPaper.groups.local
    ),
    NewsPaper(
        name: "神戸新聞",
        url: "https://www.kobe-np.co.jp/column/shasetsu/",
        image: "kobe.jpg",
        group: NewsPaper.groups.local
    ),
    NewsPaper(
        name: "奈良新聞",
        url: "https://www.nara-np.co.jp/opinion/friday.html",
        image: "nara.jpg",
        group: NewsPaper.groups.local
        ),
    NewsPaper(
        name: "山陽新聞",
        url: "https://www.sanyonews.jp/special/column/shasetsu",
        image: "sanyo.jpeg",
        group: NewsPaper.groups.local
    ),
    NewsPaper(
        name: "山陰中央新報",
        url: "https://www.sanin-chuo.co.jp/www/genre/1000100000058/index.html",
        image: "sanin_chuo",
        group: NewsPaper.groups.local
    ),
    NewsPaper(
        name: "愛媛新聞",
        url: "https://www.ehime-np.co.jp/online/editorial/",
        image: "ehime.jpg",
        group: NewsPaper.groups.local
    ),
    NewsPaper(
        name: "高知新聞",
        url: "https://www.kochinews.co.jp/news/k_editorial/",
        image: "kouchi.jpg",
        group: NewsPaper.groups.local
    ),
    NewsPaper(
        name: "佐賀新聞",
        url: "https://www.saga-s.co.jp/category/opinion-editorial",
        image: "saga.jpg",
        group: NewsPaper.groups.local
    ),
    NewsPaper(
        name: "南日本新聞",
        url: "https://373news.com/_column/syasetu.php?storyid=127560",
        image: "minaminihon.jpg",
        group: NewsPaper.groups.local
    ),
    NewsPaper(
        name: "琉球新報",
        url: "https://ryukyushimpo.jp/editorial/",
        image: "ryukyusimpo.png",
        group: NewsPaper.groups.local
    ),
    NewsPaper(
        name: "沖縄タイムス",
        url: "https://www.okinawatimes.co.jp/category/editorial",
        image: "okinawatimes.png",
        group: NewsPaper.groups.local
    ),
    ]
}
