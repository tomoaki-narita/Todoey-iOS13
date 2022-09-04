//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    var itemArray = [Item]() //cellに表示させたい値を代入しておく配列。(Item型の配列)
    
    let defaults = UserDefaults.standard
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.barTintColor = .systemBlue //ナビゲーションバーのタイトルの背景色
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white] //ナビゲーションバーのタイトルの色
        
        let newItem = Item() //ItemClassをインスタンス化
        newItem.title = "Find Mike"
        itemArray.append(newItem)
        
        let newItem2 = Item()
        newItem2.title = "Buy Eggos"
        itemArray.append(newItem2)
        
        let newItem3 = Item()
        newItem3.title = "Destroy Demogorgon"
        itemArray.append(newItem3)
        
        
        
        
        //TodoListArrayに保存した配列を読み込んで代入。保存した値を再代入するのでappを終了して再起動しても前回の状態で表示できる
        //アンラップ成功(保存された値があれば)string型の配列にキャストしてitemsに代入
//        if let  items = defaults.array(forKey: "TodoListArray") as? [Item] {
//            itemArray = items //itemsに代入されている値(保存されている値をstring型の配列にキャストした値)をitemArrayに代入
//        }
    }
    
//MARK: - Tableview Datasource Methods

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { //cellの数
        itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { //cellに表示する内容

        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath) //storyboardでcellのidentifierと同じにする
        
        let item = itemArray[indexPath.row] //itemArrayのindexPathのrow番目を定数itemに代入
        cell.textLabel?.text = item.title //cellのtextLabelのtextにitemのtitleを代入
        
        cell.accessoryType = item.done == true ? .checkmark : .none //下のif文を三項演算子で1行に。== trueの部分も省略可
        
//        if item.done == true { //選択されたitemArrayの要素の.doneプロパティがtrueだったら
//            cell.accessoryType  = .checkmark //checkmarkを表示
//        } else { //それ以外だったら
//            cell.accessoryType = .none //checkmarkをnoneに(非表示)
//        }
        return cell//上で設定したcellを返す
    }
    
    //MARK: - Tableview Delegate Methods

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { //cellがタップされた時の処理
        print(itemArray[indexPath.row].title)
        print(itemArray[indexPath.row].done)
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done //下のif文をリファクタリング
        
//        if itemArray[indexPath.row].done == false { //選択されたitemArrayの要素の.doneプロパティがfalseだったら
//            itemArray[indexPath.row].done = true //trueにする
//        } else { //それ以外だったら
//            itemArray[indexPath.row].done = false //falseにする
//        }
        
        savaItems()
        
        tableView.deselectRow(at: indexPath, animated: true) //cellをタップした後ハイライトしたままになるのでハイライトを消す
    }
    
    //MARK: - Add New Items

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) { //プラスbuttonが押されたら
        var textField = UITextField() //UITextFieldのインスタンスを作る
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert) //ポップアップの内容
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in //ポップアップの中にユーザーが入力するtextFieldを表示
            
            let newItem = Item() //ItemClassをインスタンス化
            newItem.title = textField.text! //textFieldのtextをnewItemのtitleに代入
            
            self.itemArray.append(newItem) //newItemを配列に加える
            
            self.savaItems()
            
        }
        alert.addTextField { alertTextField in //ポップアップのtextFieldにplaceholderをつける
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
            
        }
        alert.addAction(action) //ポップアップを表示
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Model Manupulation Methods
    func savaItems() {
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        } catch {
            print("Error encoding item array, \(error)")
        }
       // self.defaults.set(self.itemArray, forKey: "TodoListArray") //アプリを終了してもデータが消えないようにdeviceに保存。TodoListArrayというkeyでitemArrayの値を保存する
        self.tableView.reloadData() //tableViewをリロード
        
    }
}



