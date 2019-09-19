//
//  SettingsTableViewController.swift
//  gamenews
//
//  Created by Maxim Skorynin on 13/12/2018.
//  Copyright © 2018 Maxim Skorynin. All rights reserved.
//

import Foundation
import UIKit

class SettingsTableViewController: UITableViewController {
    
    @IBOutlet weak var fontSizeCell: UITableViewCell!
    @IBOutlet weak var nightModeCell: UITableViewCell!
    
    let nightModeSwitch = UISwitch()
    
    override func viewDidLoad() {
        
        setLayoutOptions()
        fontSizeCell.detailTextLabel?.text = User.shared.fontSize == 0 ? "Обычный" : "Большой"
        
        nightModeSwitch.addTarget(self, action: #selector(onNightMode(_:)), for: .valueChanged)
        nightModeSwitch.setOn(User.shared.isNightMode, animated: false)

        nightModeSwitch.onTintColor = UIColor.Default.switchColor
        nightModeCell.accessoryView = nightModeSwitch
        
        let tapper = UITapGestureRecognizer(target: self, action: #selector(setFavorite))
        tapper.cancelsTouchesInView = false
        fontSizeCell.addGestureRecognizer(tapper)
    }
    
    @objc func setFavorite() {
        let alert = UIAlertController(title: "Размер шрифта", message: "Выберите размер шрифта", preferredStyle: UIAlertController.Style.alert)

        
        alert.addAction(UIAlertAction(title: "Обычный", style: UIAlertAction.Style.default, handler: { (action) in

            User.shared.setNormalFontSize() { _ in
                self.fontSizeCell.detailTextLabel?.text = User.shared.fontSize == 0 ? "Обычный" : "Большой"
                self.showAlertOk(title: "Размер шрифта", message: "Перезапустите приложение, что бы настройки вступили в силу")
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Большой", style: UIAlertAction.Style.default, handler: { (action) in

            User.shared.setLargeFonteSize() { _ in
                self.fontSizeCell.detailTextLabel?.text = User.shared.fontSize == 0 ? "Обычный" : "Большой"
                self.showAlertOk(title: "Размер шрифта", message: "Перезапустите приложение, что бы настройки вступили в силу")
            }
        }))
        alert.addAction(UIAlertAction(title: "Отмена", style: UIAlertAction.Style.destructive, handler: nil))

        DispatchQueue.main.async {
            self.present(alert, animated: true) {
                () -> Void in
            }
        }
    }
    
    @objc func onNightMode(_ segmentControl : UISegmentedControl) {
        if nightModeSwitch.isOn == true {
            User.shared.setNightMode()
        } else {
            User.shared.setNormalMode()
        }
        
        showAlertOk(title: "Ночной режим", message: "Перезапустите приложение, что бы настройки вступили в силу")
    }
    
    func setLayoutOptions() {
        DispatchQueue.main.async {
            self.view.backgroundColor = UIColor.Default.background
            self.tableView.backgroundColor = UIColor.Default.background
            self.navigationController?.navigationBar.barStyle = !User.shared.isNightMode ? .default : .black
            self.tabBarController?.tabBar.barStyle = !User.shared.isNightMode ? .default : .black
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let view = view as? UITableViewHeaderFooterView {
            view.textLabel?.textColor = UIColor.Default.date
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        if let view = view as? UITableViewHeaderFooterView {
            view.textLabel?.textColor = UIColor.Default.date
        }
    }
}
