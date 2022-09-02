//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    var itemArray = ["Find Mike", "Buy Eggos", "Destory Demogorgon"] //cellに表示させたい値を代入しておく配列
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = .systemBlue //ナビゲーションバーのタイトルの背景色
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white] //ナビゲーションバーのタイトルの色
        
        //TodoListArrayに保存した配列を読み込んで代入。保存した値を再代入するのでappを終了して再起動しても前回の状態で表示できる
        //アンラップ成功(保存された値があれば)string型の配列にキャストしてitemsに代入
        if let  items = defaults.array(forKey: "TodoListArray") as? [String] {
            itemArray = items //itemsに代入されている値(保存されている値をstring型の配列にキャストした値)をitemArrayに代入
        }
    }
    
//MARK: - Tableview Datasource Methods

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { //cellの数
        itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { //cellに表示する内容
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath) //storyboardでcellのidentifierと同じにする
        cell.textLabel?.text = itemArray[indexPath.row] //cellのtextLabelに配列itemArrayを代入
        return cell//上で設定したcellを返す
    }
    
    //MARK: - Tableview Delegate Methods

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { //cellがタップされた時の処理
        print(itemArray[indexPath.row])
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark { //もしタップされたcellにcheckmark入っていたら
            tableView.cellForRow(at: indexPath)?.accessoryType = .none //checkmarkを消す(.none)
        } else { //そうでない場合(上の条件以外だったら)checkmarkが入っていなかったら
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark //checkmarkを表示
        }
        
        tableView.deselectRow(at: indexPath, animated: true) //cellをタップした後ハイライトしたままになるのでハイライトを消す
    }
    
    //MARK: - Add New Items

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) { //buttonが押されたら
        var textField = UITextField() //UITextFieldのインスタンスを作る
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert) //ポップアップの内容
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in //ポップアップの中にユーザーが入力するtextFieldを表示
            self.itemArray.append(textField.text!) //入力された値(String型)を、配列に加える
            self.defaults.set(self.itemArray, forKey: "TodoListArray") //アプリを終了してもデータが消えないようにdeviceに保存。TodoListArrayというkeyでitemArrayの値を保存する
            self.tableView.reloadData() //tableViewをリロード
        }
        alert.addTextField { alertTextField in //ポップアップのtextFieldにplaceholderをつける
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
            
        }
        alert.addAction(action) //ポップアップを表示
        present(alert, animated: true, completion: nil)
    }
}



