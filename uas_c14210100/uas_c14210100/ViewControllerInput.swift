//
//  ViewControllerInput.swift
//  uas_c14210100
//
//  Created by Catherine Rosalind on 03/12/23.
//

import UIKit

//passing data
protocol ViewControllerInputDelegate: AnyObject {
    func afterInput(for data: DataModel)
}

class ViewControllerInput: UIViewController {
    
    let ud = UserDefaults.standard
    var isian: [DataModel] = []
    
    var data: DataModel?
    weak var delegate: ViewControllerInputDelegate?
    
    var name: String = ""
    var email: String = ""
    var phone: String = ""
    var comp: String = ""
    var web: String = ""
    
    @IBOutlet weak var inName: UITextField!
    
    @IBOutlet weak var inEmail: UITextField!
    
    @IBOutlet weak var inPhone: UITextField!
    
    @IBOutlet weak var inComp: UITextField!
    
    @IBOutlet weak var inWeb: UITextField!
    
    @IBAction func btnSubmit(_ sender: UIButton) {
        let data = DataModel(
            nama: inName.text ?? "",
            email: inEmail.text ?? "",
            notelp: inPhone.text ?? "",
            perusahaan: inComp.text ?? "",
            web: inWeb.text ?? ""
        )
        
//      di cek, jika masih kosong, maka data dimasukkan
        if let savedData = loadDataFromUserDefaults() {
            isian = savedData
        }
        
//        jika ada data, maka di append
        isian.append(data)
                
        saveDataToUserDefaults(dataArray: isian)
                        
        delegate?.afterInput(for: data)
        navigationController?.popViewController(animated: true)
        
    }
    
//    mengisi data dari input dan di encode
    private func saveDataToUserDefaults(dataArray: [DataModel]) {
            do {
                let encoder = JSONEncoder()
                let encodedData = try encoder.encode(dataArray)
                ud.set(encodedData, forKey: "dataInputted")
            } catch {
                print("Error encoding data: \(error.localizedDescription)")
            }
        }
        
//    untuk melakukan pengecekan apakah data masih kosong
    private func loadDataFromUserDefaults() -> [DataModel]? {
        if let encodedData = ud.data(forKey: "dataInputted") {
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


    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
