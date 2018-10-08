//
//  PostViewController.swift
//  patients
//
//  Created by 水野 久代 on 2018/08/13.
//  Copyright © 2018年 水野 久代. All rights reserved.
//

import UIKit
import RealmSwift

class PostViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var weightTextField: UITextField! //体重
    @IBOutlet weak var bloodmaxTextField: UITextField! //血圧上
    @IBOutlet weak var bloodminTextField: UITextField! //血圧下
    @IBOutlet weak var viewname: UILabel! //名前
    @IBOutlet weak var viewsex: UILabel! //性別
    @IBOutlet weak var viewage: UILabel! //年齢
    //@IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableView: UITableView!
    
    let realm = try! Realm()
    var userdata:Userdata!  // 渡ってくる
    let healthData = List<HealthData>()
    //let userdataArray = try! Realm().objects(Userdata.self).sorted(byKeyPath: "date", ascending: false)
    let healthdataArray = try! Realm().objects(HealthData.self).sorted(byKeyPath: "date", ascending: false)
    //let healthdataArray = try! Realm().objects(HealthData.self).filter("nurseid = 2").sorted(byKeyPath: "date", ascending: false)

    // 入力画面から戻ってきた時に TableView を更新させる
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        print("DEBUG:",  userdata.id)
        let UID = userdata.id
        print(UID)
       
        viewname.text = userdata.name
        viewage.text = String(userdata.age)
        viewsex.text = userdata.sex
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("count")
        print(healthdataArray.count)
        return healthdataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell2", for: indexPath)
        let uid = userdata.id
        print("cccccc")
        print(uid)
        //cellにセット
        //let healthdata = healthdataArray[indexPath.row]
        //let healthdataArray2 = try! Realm().objects(HealthData.self).filter("nurseid == userdata.id").sorted(byKeyPath: "date", ascending: false)
        let healthdata = healthdataArray.filter("nurseid == userdata.id")[indexPath.row]
        //print(healthdata)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        let dateString:String = formatter.string(from: healthdata.date)
        cell.textLabel?.text = dateString
        return cell

    }
    
    
    //登録実行
    @IBAction func healthdataAdd(_ sender: Any) {
        //let UID = userdata.id
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        let health = HealthData(value: [
            //"museid"  : 10 ,
            "nurseid"  : userdata.id ,
            "weight"  : Int(self.weightTextField.text!),
            "bloodmax": Int(self.bloodmaxTextField.text!),
            "bloodmin": Int(self.bloodminTextField.text!)
         ])
        try! realm.write {
            //userdata.healthData.append(health)
            userdata.healthData.append(health)
        }
    }
    



}
