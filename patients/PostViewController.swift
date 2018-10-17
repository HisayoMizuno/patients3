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
    
    //@IBOutlet weak var varwage: UILabel! //年齢
    //@IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var addButon: UIButton!
    @IBOutlet weak var modButon: UIButton!
    
    let realm = try! Realm()
    var userdata:Userdata!  // 渡ってくる
    let healthData = List<HealthData>()
    var uid = 0
    var healthdataArray: Results<HealthData>?
    var userdataArray: Results<Userdata>?

    // 入力画面から戻ってきた時に TableView を更新させる
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    //------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self

        uid = userdata.id
        print("uuid")
        healthdataArray = try! Realm().objects(HealthData.self).filter("nurseid == %@",uid).sorted(byKeyPath: "date", ascending: false)

        for a in healthdataArray! {
            print("nurse= \(a.nurseid) : weight= \(a.weight)")
        }
        
        userdataArray = try! Realm().objects(Userdata.self).filter("id=%@",uid).sorted(byKeyPath: "date", ascending: false)
        for b in userdataArray! {
            print("uid= \(b.id) : name= \(b.name)")
        }
        
        viewname.text = userdata.name
        viewname.text = String(userdata.age)
        viewsex.text = userdata.sex
        modButon.isHidden = true //変更実行　無効化

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    //---------------------------------------

    
    

    
    //--------------------------------------------------------------------------------------------
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("count")
        
        return (healthdataArray?.count)!
        //return userdata.healthData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell2", for: indexPath)
        let uid = userdata.id
        print("cccccc")
        print(uid)
        //cellにセット
        let healthdata = healthdataArray?[indexPath.row]
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        let dateString:String = formatter.string(from: (healthdata?.date)!)
        cell.textLabel?.text = dateString
        return cell
        
    }
    // セルが選択された時に実行されるメソッド
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        modButon.isHidden = false //有効化
        addButon.isHidden = true //無効化
        //let a = self.tableView.indexPathForSelectedRow
        let healthdata = healthdataArray?[indexPath.row]
        weightTextField.text = healthdata?.weight.description
        bloodmaxTextField.text = healthdata?.bloodmax.description
        bloodminTextField.text = healthdata?.bloodmin.description
    }
        
    //変更実行時
    @IBAction func healthdataMod(_ sender: Any) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        if self.weightTextField.text == "" {
            print("NULLA")
            viewAlert(sts: 1)
        }
        else if self.bloodmaxTextField.text == "" {
            print("NULLB")
            viewAlert(sts: 2)
        }
        else if self.bloodminTextField.text == "" {
            print("NULLC")
            viewAlert(sts: 3)
        }
        else {
            var health = HealthData(value: [
                "nurseid" : userdata.id ,
                "weight"  : Int(self.weightTextField.text!),
                "bloodmax": Int(self.bloodmaxTextField.text!),
                "bloodmin": Int(self.bloodminTextField.text!)
            ])
            //変更処理
            try! realm.write {
                //userdata.healthData.append(health)
                realm.add(healthData, update: true)
                
            }
            tableView.reloadData()
            //入力項目をセットする
            self.weightTextField.text = ""
            self.bloodmaxTextField.text = ""
            self.bloodminTextField.text = ""
            viewAlert(sts: 0)
        }
    }
    //登録実行
    @IBAction func healthdataAdd(_ sender: Any) {
        //viewAlert()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        if self.weightTextField.text == "" {
            print("NULLA")
            viewAlert(sts: 1)
        }
        else if self.bloodmaxTextField.text == "" {
             print("NULLB")
            viewAlert(sts: 2)
        }
        else if self.bloodminTextField.text == "" {
            print("NULLC")
            viewAlert(sts: 3)
        }
        else {
            let health = HealthData(value: [
                "nurseid" : userdata.id ,
                "weight"  : Int(self.weightTextField.text!),
                "bloodmax": Int(self.bloodmaxTextField.text!),
                "bloodmin": Int(self.bloodminTextField.text!)
            ])
            //登録処理
            try! realm.write {
                userdata.healthData.append(health)
            }
            tableView.reloadData()
            //入力項目をセットする
            self.weightTextField.text = ""
            self.bloodmaxTextField.text = ""
            self.bloodminTextField.text = ""
            viewAlert(sts: 0)
        }
    }
    //--------------------------
    func viewAlert(sts: Int) {
        var msg = ""
        var ngword = "NG!入力確認"
        switch sts {
        case 1 :  msg = "体重が入力されていません"; break
        case 2 :  msg = "血圧（上）体重が入力されていません"; break
        case 3 :  msg = "血圧（下）体重が入力されていません"; break
        case 4 :  msg = "変更実行しました"; break
        default: //0の時
            msg    = "入力完了です";
            ngword = "OK";
            break
        }
        let title = "入力確認のポップアップ"
        let message = msg
        let NGText = ngword
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let okayButton = UIAlertAction(title: NGText, style: UIAlertActionStyle.cancel, handler: nil)
        alert.addAction(okayButton)
        present(alert, animated: true, completion: nil)
        }
    //--------------------------

    
}


