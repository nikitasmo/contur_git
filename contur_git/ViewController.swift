//
//  ViewController.swift
//  Contur2
//
//  Created by Никита on 14/08/2022.
//  Copyright © 2022 com.example. All rights reserved.
//

import UIKit

struct ImgRocket: Codable {
    let flickr_images: [String]
    let name: String
    let height, diameter: Diameter
    let mass: Mass
    let payload_weights: [PayloadWeight]
}

struct Diameter: Codable {
    let meters, feet: Double
}

struct Mass: Codable {
    let kg, lb: Int
}

struct PayloadWeight: Codable {
    let id, name: String
    let kg, lb: Int
}

class ViewController: UIViewController {
    
    let myView = UIView()
    var mainScrollView = UIScrollView()
    var iconScrollView = UIScrollView()
    let myImageView = UIImageView()
    var myPageControl = UIPageControl()
    var rocketLabel = UILabel()
    var settingButton = UIButton()
    var myTableView = UITableView()
    
    var viewIcon = [UIView]()
    let ImgFalcon9 = UIImage(named: "falcon9")
    let setting = UIImage(named: "setting")
    
    let identifier = "MyCell"
    
    let falcon9 = racket(iconsLabelValueFt: ["229.6", "12", "1,207,920", "50,265"], InfoValueLabel: ["11 мая, 2018", "США", "$67 млн", "9", "300 tn", "100 s", "1", "250 tn", "397 s"])
    
    let urlString = "https://api.spacexdata.com/v4/rockets" //адрес API
    
    let urlSession = URLSession.shared //начинаем сессию
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //view.backgroundColor = UIColor.black
        
        configureView()
        configureImageView()
        configureMainScrollView()
        configurePageControl()
        createRocketLabel()
        configureSettingButton()
        configureIconScrollView()
        viewForScrollViewIcon()
        configureTableView()
        loadPictureAndName()
        
        
    }
    
    //MARK: - configure
    func configureView() {
        
        //делаем так, чтобы view занимала две трети экрана снизу
        myView.frame = CGRect(x: 0, y: (UIScreen.main.bounds.height / 3)*2, width: UIScreen.main.bounds.width, height: 800)
        //закругляем края view
        myView.layer.cornerRadius = 30
        myView.backgroundColor = UIColor.black
        //self.view.addSubview(myView)
        //чтобы view было поверх imageView
        //self.view.bringSubviewToFront(myView)
    }
    
    func configureImageView() {
        myImageView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: ((UIScreen.main.bounds.height / 3)*2) + 30)
        myImageView.contentMode = .scaleAspectFill
        //        myImageView.image = ImgFalcon9
        
    }
    
    
    
    func configureMainScrollView() {
        
        mainScrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 70))
        mainScrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height + 450)
        mainScrollView.setContentOffset(CGPoint(x: 0, y: UIScreen.main.bounds.height / 3), animated: false)
        mainScrollView.showsVerticalScrollIndicator = false
        
        self.view.addSubview(mainScrollView)
        mainScrollView.addSubview(myImageView)
        mainScrollView.addSubview(myView)
        
        
        //        self.view.addSubview(mainScrollView)
        //        mainScrollView.addSubview(myImageView)
        //        mainScrollView.addSubview(myView)
        
    }
    
    
    func configurePageControl() {
        myPageControl = UIPageControl(frame: CGRect(x: 0, y: UIScreen.main.bounds.height - 70, width: UIScreen.main.bounds.width, height: 70))
        myPageControl.backgroundColor = UIColor.black
        myPageControl.numberOfPages = 4
        
        view.addSubview(myPageControl)
    }
    
    func createRocketLabel() {
        rocketLabel.frame = CGRect(x: 30, y: 30, width: 200, height: 50)
        //        rocketLabel.text = "Falcon 9"
        rocketLabel.font = UIFont.boldSystemFont(ofSize: 30)
        rocketLabel.textColor = UIColor.white
        myView.addSubview(rocketLabel)
    }
    
    func configureSettingButton() {
        settingButton = UIButton(frame: CGRect(x: UIScreen.main.bounds.width - 50, y: 40, width: 32, height: 32))
        settingButton.setImage(setting, for: .normal)
        
        myView.addSubview(settingButton)
    }
    
    func configureTableView() {
        myTableView = UITableView(frame: CGRect(x: 0, y: 210, width: UIScreen.main.bounds.width, height: 520), style: .plain)
        myTableView.register(UITableViewCell.self, forCellReuseIdentifier: identifier)
        myTableView.isScrollEnabled = false
        
        //чтобы была прозрачной
        myTableView.layer.backgroundColor = UIColor.clear.cgColor
        myTableView.backgroundColor = .clear
        
        //чтобы небыло разделителей
        myTableView.separatorStyle = .none
        
        
        
        myTableView.delegate = self
        myTableView.dataSource = self
        
        myView.addSubview(myTableView)
    }
    
    // создаем скролл для иконок с параметрами
    func configureIconScrollView() {
        iconScrollView = UIScrollView(frame: CGRect(x: 0, y: 100, width: UIScreen.main.bounds.width, height: 100))
        //iconScrollView.backgroundColor = UIColor.green
        //iconScrollView.isPagingEnabled = true
        iconScrollView.contentSize = CGSize(width: 70+(115*4), height: 100)
        iconScrollView.showsHorizontalScrollIndicator = false
        
        myView.addSubview(iconScrollView)
    }
    
    //MARK: - function
    //добавляем иконки с параметрами на скролл
    func viewForScrollViewIcon() {
        
        for index in 0...3 {
            viewIcon.append(generatorViewForIcon(x: 40+(115*index), name: falcon9.iconsLabelNameFt[index], value: falcon9.iconsLabelValueFt[index], index: index))  //отступ первой иконик 40
            iconScrollView.addSubview(viewIcon[index])
        }
        
    }
    //в этой функции генерируем иконки и лэйблы на них
    func generatorViewForIcon(x: Int, name: String, value: String, index: Int) -> UIView{
        let icon = UIView()
        icon.frame = CGRect(x: x, y: 0, width: 100, height: 100)
        icon.layer.cornerRadius = 30
        icon.backgroundColor = UIColor.darkGray
        //лэйбл отвечающий за название
        let label = UILabel(frame: CGRect(x: 10, y: 50, width: 80, height: 30))
        label.text = name
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        icon.addSubview(label)
        //лэйбл для значения
        let labelValue = UILabel(frame: CGRect(x: 0, y: 30, width: 100, height: 20))
        labelValue.textColor = UIColor.white
        labelValue.textAlignment = .center
        //labelValue.text = value
        loadIconLabel(iconLabel: labelValue, index: index)
        icon.addSubview(labelValue)
        
        
        return icon
    }
    
    func loadPictureAndName(){
        
        guard let url = URL(string: urlString) else { return }
        
        urlSession.dataTask(with: url) { (data, _, _) in
            
            guard let data = data else { return }
            
            do {
                
                let result = try JSONDecoder().decode([ImgRocket].self, from: data)
                
                //получаем изображение
                guard let urlPicture = URL(string: result[0].flickr_images[Int.random(in: 0..<result[0].flickr_images.count)]) else { return }
                
                let picture = try Data(contentsOf: urlPicture)
                
                DispatchQueue.main.async {
                    self.myImageView.image = UIImage(data: picture)
                    self.rocketLabel.text = result[0].name
                }
                
            } catch
            {
                print("Error")
            }
            }.resume()
        
    }
    
    func loadIconLabel(iconLabel: UILabel, index: Int) {
        
        guard let url = URL(string: urlString) else { return }
        
        urlSession.dataTask(with: url) { (data, _, _) in
            
            guard let data = data else { return }
            
            do {
                
                let result = try JSONDecoder().decode([ImgRocket].self, from: data)
                
                DispatchQueue.main.async {
                    switch index {
                    case 0: iconLabel.text = String(result[0].height.feet)
                    case 1: iconLabel.text = String(result[0].diameter.feet)
                    case 2: iconLabel.text = String(result[0].mass.lb)
                    case 3: iconLabel.text = String(result[0].payload_weights[0].lb)
                    default: break
                    }
                }
                
                
            } catch {
                print("Error")
            }
            
            }.resume()
    }
    
}



extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func createCell(cell: UITableViewCell, text: String, index: Int){
        let myView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40))
        let nameLabel = UILabel(frame: CGRect(x: 30, y: 0, width: (UIScreen.main.bounds.width / 2)+15, height: 40))
        nameLabel.textColor = UIColor.lightGray
        nameLabel.text = text
        let valueLabel = UILabel(frame: CGRect(x: (UIScreen.main.bounds.width / 2)+15, y: 0, width: (UIScreen.main.bounds.width / 2)-30, height: 40))
        valueLabel.textAlignment = .right
        valueLabel.textColor = UIColor.lightGray
        valueLabel.text = falcon9.InfoValueLabel[index]
        
        cell.contentView.addSubview(myView)
        myView.addSubview(nameLabel)
        myView.addSubview(valueLabel)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 12
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = myTableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        
        cell.selectionStyle = .none
        cell.layer.backgroundColor = UIColor.clear.cgColor
        cell.backgroundColor = .clear
        
        switch indexPath.row {
        case 0:
            createCell(cell: cell, text: "Первый запуск", index: indexPath.row)
        case 1:
            createCell(cell: cell, text: "Страна", index: indexPath.row)
        case 2:
            createCell(cell: cell, text: "Стоимость запуска", index: indexPath.row)
        case 3:
            let myView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40))
            let nameLabel = UILabel(frame: CGRect(x: 30, y: 0, width: (UIScreen.main.bounds.width / 2)-30, height: 40))
            nameLabel.text = "Первая ступень"
            nameLabel.textColor = UIColor.white
            nameLabel.font = UIFont.boldSystemFont(ofSize: 20)
            
            cell.contentView.addSubview(myView)
            myView.addSubview(nameLabel)
        case 4:
            createCell(cell: cell, text: "Количество двигателей", index: indexPath.row - 1)
        case 5:
            createCell(cell: cell, text: "Количество топлива", index: indexPath.row - 1)
        case 6:
            createCell(cell: cell, text: "Время сгорания в секундах", index: indexPath.row - 1)
        case 7:
            let myView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40))
            let nameLabel = UILabel(frame: CGRect(x: 30, y: 0, width: (UIScreen.main.bounds.width / 2)-30, height: 40))
            nameLabel.text = "Вторая ступень"
            nameLabel.textColor = UIColor.white
            nameLabel.font = UIFont.boldSystemFont(ofSize: 20)
            
            cell.contentView.addSubview(myView)
            myView.addSubview(nameLabel)
        case 8:
            createCell(cell: cell, text: "Количество двигателей", index: indexPath.row - 2)
        case 9:
            createCell(cell: cell, text: "Количество топлива", index: indexPath.row - 2)
        case 10:
            createCell(cell: cell, text: "Время сгорания в секундах", index: indexPath.row - 2)
        case 11:
            let myView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 60))
            let myButton = UIButton(frame: CGRect(x: 5, y: 0, width: UIScreen.main.bounds.width-5, height: 60))
            myButton.backgroundColor = UIColor.darkGray
            myButton.layer.cornerRadius = 10
            myButton.setTitle("Посмотреть запуски", for: .normal)
            
            cell.contentView.addSubview(myView)
            myView.addSubview(myButton)
        default:
            break
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 2:
            return 50
        case 6:
            return 50
        case 11:
            return 60
        default:
            break
        }
        return 40
    }
    
    
}

