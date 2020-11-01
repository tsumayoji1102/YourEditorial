//
//  Constraints.swift
//  yourEditorial
//
//  Created by 塩見陵介 on 2020/10/19.
//

import UIKit

class Constraints: NSObject {
    
    static let newsPapers: Array<NewsPaper> = [
    NewsPaper(
        name: "朝日新聞",
        url: "https://www.asahi.com/rensai/list.html?id=16",
        group: NewsPaper.groups.nationWide
    ),
    NewsPaper(
        name: "産経新聞",
        url: "https://www.sankei.com/column/newslist/editorial-n1.html",
        group: NewsPaper.groups.nationWide
    ),
    NewsPaper(
        name: "読売新聞",
        url: "https://www.yomiuri.co.jp/editorial/",
        group: NewsPaper.groups.nationWide
    ),
    NewsPaper(
        name: "毎日新聞",
        url: "https://mainichi.jp/editorial/1",
        group: NewsPaper.groups.nationWide
    ),
    NewsPaper(
        name: "北海道新聞",
        url: "https://www.hokkaido-np.co.jp/column/c_editorial",
        group: NewsPaper.groups.block
    ),
    NewsPaper(
        name: "河北新報",
        url: "https://www.kahoku.co.jp/editorial/",
        group: NewsPaper.groups.block
    ),
    NewsPaper(
        name: "東京新聞",
        url:"https://www.tokyo-np.co.jp/n/column/editorial/",
        group: NewsPaper.groups.block
        ),
    NewsPaper(
        name: "中国新聞",
        url: "https://www.chugoku-np.co.jp/column/article/?category_id=142&page=1",
        group: NewsPaper.groups.block
    ),
    NewsPaper(
        name: "西日本新聞",
        url: "https://www.nishinippon.co.jp/category/column/editorial/",
        group: NewsPaper.groups.block
    ),
    NewsPaper(
        name: "デーリー東北",
        url: "https://www.daily-tohoku.news/archives/category/column/jihyo",
        group: NewsPaper.groups.local
        ),
    NewsPaper(
        name: "福島民報",
        url: "https://www.minpo.jp/news/column_ronsetsu",
        group: NewsPaper.groups.local
        ),
    NewsPaper(
        name: "秋田魁新報",
        url: "https://www.sakigake.jp/news/list/scd/100003001/?nv=akita",
        group: NewsPaper.groups.local
    ),
    NewsPaper(
        name: "福島民友新聞",
        url: "https://www.minyu-net.com/shasetsu/shasetsu/",
        group: NewsPaper.groups.local
        ),
    NewsPaper(
        name: "信濃毎日新聞",
        url: "https://www.shinmai.co.jp/news/nagano/web_shasetsu_list.html",
        group: NewsPaper.groups.local
    ),
    NewsPaper(
        name: "新潟日報",
        url: "https://www.niigata-nippo.co.jp/opinion/editorial/20201025576946.html",
        group: NewsPaper.groups.local
    ),
    NewsPaper(
        name: "北國新聞",
        url: "https://www.hokkoku.co.jp/_syasetu/syasetu.htm",
        group: NewsPaper.groups.local
    ),
    NewsPaper(
        name: "福井新聞",
        url: "https://www.fukuishimbun.co.jp/category/editorial",
        group: NewsPaper.groups.local
    ),
    NewsPaper(
        name: "京都新聞",
        url: "https://www.kyoto-np.co.jp/category/editorial",
        group: NewsPaper.groups.local
    ),
    NewsPaper(
        name: "神戸新聞",
        url: "https://www.kobe-np.co.jp/column/shasetsu/",
        group: NewsPaper.groups.local
    ),
    NewsPaper(
        name: "奈良新聞",
        url: "https://www.nara-np.co.jp/opinion/friday.html",
        group: NewsPaper.groups.local
        ),
    NewsPaper(
        name: "山陽新聞",
        url: "https://www.sanyonews.jp/special/column/shasetsu",
        group: NewsPaper.groups.local
    ),
    NewsPaper(
        name: "山陰中央新聞",
        url: "https://www.sanin-chuo.co.jp/www/genre/1000100000058/index.html",
        group: NewsPaper.groups.local
    ),
    NewsPaper(
        name: "愛媛新聞",
        url: "https://www.ehime-np.co.jp/online/editorial/",
        group: NewsPaper.groups.local
    ),
    NewsPaper(
        name: "高知新聞",
        url: "https://www.kochinews.co.jp/news/k_editorial/",
        group: NewsPaper.groups.local
    ),
    NewsPaper(
        name: "佐賀新聞",
        url: "https://www.saga-s.co.jp/category/opinion-editorial",
        group: NewsPaper.groups.local
    ),
    NewsPaper(
        name: "南日本新聞",
        url: "https://373news.com/_column/syasetu.php?storyid=127560",
        group: NewsPaper.groups.local
    ),
    NewsPaper(
        name: "琉球新報",
        url: "https://ryukyushimpo.jp/editorial/",
        group: NewsPaper.groups.local
    ),
    NewsPaper(
        name: "沖縄タイムス",
        url: "https://www.okinawatimes.co.jp/category/editorial",
        group: NewsPaper.groups.local
    ),
    ]
}
