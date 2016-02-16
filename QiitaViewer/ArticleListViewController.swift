//
//  ArticleListViewController.swift
//  QiitaViewer
//
//  Created by 森泉亮介 on 2016/02/16.
//  Copyright © 2016年 森泉亮介. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ArticleListViewController: UIViewController, UITableViewDataSource {
    var articles: [[String: String?]] = [] // 記事を入れるプロパティを定義
    
    let table = UITableView() // プロパティにtableを追加
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "新着記事" // Navigation Barのタイトルを設定
        
        table.frame = view.frame // tableの大きさをviewの大きさに合わせる
        view.addSubview(table) // viewにtableを乗せる
        table.dataSource = self // dataSouceプロパティに自身を代入
        
        getArticles()
    }
    
    func getArticles() {
        Alamofire.request(.GET, "https://qiita.com/api/v2/items")
            .responseJSON { response in
                guard let object = response.result.value else {
                    return
                }
                
                let json = JSON(object)
                json.forEach { (_, json) in
                    let article: [String: String?] = [
                        "title": json["title"].string, // jsonから"title"がキーのものを取得、記事タイトルを表示
                        "userId": json["user"]["id"].string
                    ] // 1つの記事を表す辞書型を作る
                    self.articles.append(article) // 配列に入れる
                }
//                print(self.articles) // 全ての記事が保存出来たら配列を確認
                self.table.reloadData() // TableViewを更新
            }
    }
    
    // 記事の表示
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Subtitle, reuseIdentifier: "cell") // Subtitleのあるセルを生成
        let article = articles[indexPath.row] // 行数番目の記事を取得
        cell.textLabel?.text = article["title"]! // 記事のタイトルをtextLabelにセット
        cell.detailTextLabel?.text = article["userId"]! // 投稿者のユーザーIDをdetailTextLabelにセット
        return cell
    }

    
}