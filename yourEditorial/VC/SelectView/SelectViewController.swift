//
//  SelectViewController.swift
//  usefulAlerm
//
//  Created by 塩見陵介 on 2020/03/08.
//  Copyright © 2020 つまようじ職人. All rights reserved.
//

import UIKit

final class SelectViewController: UIViewController {
    
    enum selectViewTag: Int {
        case someButton = 0,
        selectPicker,
        decideButton,
        selectViewTagNum
    }
    
    enum buttonTag: Int {
        case close = 0,
        decide
    }

    @IBOutlet weak var selectView:      UITableView!
    @IBOutlet weak var closeViewLayer:  UIButton!
    
    // パーツ
    private var cancelButton: UIButton!
    private var picker:       UIPickerView!
    private var decideButton: UIButton!
    
    // 値
    var list:             Array<String> = []
    var selectedIndex:    Int = 0
    var closure:          ((Int?) ->Void)!
    
// MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        Log.getLog()
        
        // Viewを透明に
        self.view.backgroundColor = UIColor.clear

        // tableViewの設定
        selectView.delegate   = self
        selectView.dataSource = self
        selectView.allowsSelection = false
        selectView.isScrollEnabled = false
        selectView.separatorStyle  = .none
        selectView.layer.cornerRadius = 10
        selectView.isScrollEnabled = false
        
        // button設定
        closeViewLayer.addTarget(self, action: #selector(tapButton(_:)), for: .touchUpInside)
        closeViewLayer.tag = buttonTag.close.rawValue
        
        // キャンセルボタン
        cancelButton = UIButton()
        cancelButton.setTitle("キャンセル", for: .normal)
        cancelButton.setTitleColor(UIColor.systemBlue, for: .normal)
        cancelButton.addTarget(self, action: #selector(tapButton(_:)), for: .touchUpInside)
        cancelButton.tag = buttonTag.close.rawValue
        
        // 決定ボタン
        decideButton = UIButton()
        decideButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        decideButton.layer.cornerRadius = 10
        decideButton.setTitle("OK", for: .normal)
        decideButton.setTitleColor(UIColor.white, for: .normal)
        decideButton.addTarget(self, action: #selector(tapButton(_:)), for: .touchUpInside)
        decideButton.tag = buttonTag.decide.rawValue
        
        // ピッカー
        picker = UIPickerView()
        picker.delegate   = self
        picker.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        Log.getLog()
        
        // 再読み込み
        picker.reloadComponent(0)
        picker.selectRow(selectedIndex, inComponent: 0, animated: true)
        decideButton.backgroundColor = UIColor.getThemeColor()
        
        // ダークモード設定
        picker.tintColor       = UIColor.getDarkModeColor(area: "fontColor")
        picker.backgroundColor = UIColor.getDarkModeColor(area: "cell")
        picker.setValue(UIColor.getDarkModeColor(area: "fontColor"), forKey: "textColor")
        selectView.reloadData()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        Log.getLog()
        
        selectView.frame = CGRect(x: 20, y: view.frame.height - 350, width: self.view.frame.width - 40, height: 300)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        Log.getLog()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        Log.getLog()
    }
    
// MARK: - Method
    
    @objc private func tapButton(_ sender: UIButton){
        Log.getLog()
        
        switch sender.tag {
        case buttonTag.decide.rawValue:
            closure(picker.selectedRow(inComponent: 0))
            selectedIndex = picker.selectedRow(inComponent: 0)
            self.dismiss(animated: true, completion: nil)
            break
        case buttonTag.close.rawValue:
            dismiss(animated: true, completion: nil)
            break
        default:
            break
        }
    }
}




// MARK: - TableView

extension SelectViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        Log.getLog()
        return selectViewTag.selectViewTagNum.rawValue
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        Log.getLog()
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "selectView", for: indexPath)
        cell.backgroundColor = UIColor.getDarkModeColor(area: "cell")
        
        switch indexPath.row {
        case selectViewTag.someButton.rawValue:
            cancelButton.frame = CGRect(x: tableView.frame.width - 110, y: 10, width: 100, height: 30)
            
            cell.contentView.addSubview(cancelButton)
            break
            
        case selectViewTag.selectPicker.rawValue:
            picker.frame = CGRect(x: 10, y: 10, width: tableView.frame.width - 20, height: 140)
            
            cell.contentView.addSubview(picker)
            break
            
        case selectViewTag.decideButton.rawValue:
            decideButton.frame = CGRect(x: 10, y: 10, width: tableView.frame.width - 20, height: 60)
            
            cell.contentView.addSubview(decideButton)
            break
            
        default:
            break
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        Log.getLog()
        
        switch indexPath.row {
        case selectViewTag.someButton.rawValue:
            return 50
            
        case selectViewTag.selectPicker.rawValue:
            return 170
            
        case selectViewTag.decideButton.rawValue:
            return 80
            
        default:
            return 0
        }
        
    }
}

extension SelectViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return list.count
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return list[row]
    }
    
}
