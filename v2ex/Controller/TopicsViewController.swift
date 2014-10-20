//
//  ViewController.swift
//  v2ex
//
//  Created by liaojinxing on 14-10-16.
//  Copyright (c) 2014年 jinxing. All rights reserved.
//

import UIKit

class TopicsViewController: BaseTableViewController {
    
    var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "V2EX"
        
        self.sendRequest()
    }
    
    func sendRequest() {
        self.refreshing = true
        APIClient.sharedInstance.getLatestTopics({ (json) -> Void in
            self.refreshing = false
            print(json)
            if json.type == Type.Array {
                self.datasource = json.arrayValue
            }
            }, failure: { (error) -> Void in
                self.refreshing = false
        })
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.datasource != nil) {
            return self.datasource.count
        }
        return 0
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60;
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(TopicCellID) as? TopicCell
        let json = self.datasource[indexPath.row] as JSON
        cell?.titleLabel.text = json["title"].stringValue
        var avatarURL = "http:" + json["member"]["avatar_large"].stringValue
        cell?.avatarImageView.sd_setImageWithURL(NSURL(string: avatarURL), placeholderImage:UIImage(named: "avatar_normal"))
        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let json = self.datasource[indexPath.row] as JSON
        var vc = TopicDetailViewController()
        vc.json = json
        self.navigationController?.pushViewController(vc, animated: true)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func onPullToFresh() {
        self.sendRequest()
    }

}
