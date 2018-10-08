//
//  HomeViewController.swift
//  patients
//
//  Created by 水野 久代 on 2018/08/13.
//  Copyright © 2018年 水野 久代. All rights reserved.
//

import UIKit
import RealmSwift

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    // Realmインスタンスを取得する
    let realm = try! Realm()
    // DB内のタスクが格納されるリスト。
    var userdataArray = try! Realm().objects(Userdata.self).sorted(byKeyPath: "date", ascending: false)
    //
    // 入力画面から戻ってきた時に TableView を更新させる
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // データの数（＝セルの数）を返すメソッド
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userdataArray.count
    }
    // 各セルの内容を返すメソッド
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        //cellにセット
        let userdata = userdataArray[indexPath.row]
        cell.textLabel?.text = userdata.name
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        let dateString:String = formatter.string(from: userdata.date)
        cell.detailTextLabel?.text = dateString
        print("aaaa")
        print(dateString)
        
        return cell
    }
    // 各セルを選択した時に実行されるメソッド
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "cellSegue",sender: nil)
    }
    // Delete ボタンが押された時に呼ばれるメソッド
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // データベースから削除する  // ←以降追加する
            try! realm.write {
                self.realm.delete(self.userdataArray[indexPath.row])
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }
    
    // ユーザー追加ボタンタップ時
    @IBAction func useraddButton(_ sender: UIButton) {
        print("DEBUG_PRINT: ユーザ追加ボタンがタップされました")
        let useraddViewController = self.storyboard?.instantiateViewController(withIdentifier: "Useradd") as! UseraddViewController
        present(useraddViewController, animated: true, completion: nil)
    }
    //segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        let indexPath = self.tableView.indexPathForSelectedRow
        let postViewController:PostViewController = segue.destination as! PostViewController
        postViewController.userdata = userdataArray[indexPath!.row]
    }
    
    @IBAction func unwind(_ segue: UIStoryboardSegue) {
    }
}
