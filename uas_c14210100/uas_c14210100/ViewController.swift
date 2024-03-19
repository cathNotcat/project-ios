//
//  ViewController.swift
//  uas_c14210100
//
//  Created by Catherine Rosalind on 03/12/23.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ViewControllerInputDelegate  {
    
    var dataModels: [DataModel] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        
        if let savedData = loadDataFromUserDefaults() {
            dataModels = savedData
            tableView.reloadData()
        }
    }
    
//    pindah ke halaman input data
    @IBAction func btnAdd(_ sender: UIButton) {
        let vcInput = ViewControllerInput(nibName: "ViewControllerInput", bundle: nil)
        vcInput.delegate = self
        navigationController?.pushViewController(vcInput, animated: true)
        print("pressed")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModels.count
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (_, _, completionHandler) in
            self?.dataModels.remove(at: indexPath.row)

            tableView.deleteRows(at: [indexPath], with: .fade)
            
            self?.saveDataToUserDefaults()

            completionHandler(true)
        }

        deleteAction.image = UIImage(systemName: "trash.fill")

        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = false
        
        return configuration
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")! as! TableViewCell
        cell.accessoryType = .none
        
//        pengisian datan pada cell
        let data = dataModels[indexPath.row]
        cell.nama.text = data.nama
        cell.email.text = data.email
        cell.notelp.text = data.notelp
        cell.perusahaan.text = data.perusahaan
        cell.web.text = data.web
        
//        pemberian warna (ganjil genap) & tambah border radius
        if indexPath.row % 2 == 0 {
            cell.card.backgroundColor = UIColor.lightGray
        } else {
            cell.card.backgroundColor = UIColor.darkGray
        }
        cell.card.layoutMargins.bottom = 20
        cell.card.layoutMargins.left = 30
        cell.card.layoutMargins.right = 30
        cell.card.layer.cornerRadius = 10
        cell.card.layer.masksToBounds = true
        
    
        return cell
    }
    
    func afterInput(for data: DataModel) {
        dataModels.append(data)
        tableView.reloadData()
    }
    
//    save lagi datanya setelah dihapus
    private func saveDataToUserDefaults() {
        do {
            let encoder = JSONEncoder()
            let encodedData = try encoder.encode(dataModels)
            UserDefaults.standard.set(encodedData, forKey: "dataInputted")
        } catch {
            print("Error encoding data: \(error.localizedDescription)")
        }
    }
    
//    mengambil UserDefaults data dari halaman input
    private func loadDataFromUserDefaults() -> [DataModel]? {
        if let encodedData = UserDefaults.standard.data(forKey: "dataInputted") {
            do {
                let decoder = JSONDecoder()
                let data = try decoder.decode([DataModel].self, from: encodedData)
                return data
            } catch {
                print("Error decoding data: \(error.localizedDescription)")
                return nil
            }
        }
        return nil
    }

}

