//
//  ViewController.swift
//  uts_c14210100
//
//  Created by Catherine Rosalind on 08/10/23.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    @IBOutlet weak var viewAfter: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.viewAfter.isHidden = true
    }
    
    
    let apiKey = "ad26c3724c68cbb0ef3f07a04f5c9cfa"
    var idOrigin: String = ""
    var idDest: String = ""
    
    var service: [String] = []
    var harga: [Int] = []
    
    @IBOutlet weak var inputOrigin: UITextField!
    
    @IBOutlet weak var inputDestination: UITextField!
    
    @IBOutlet weak var cekKotaLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func cekKota(_ sender: UIButton) {
//        agar isinya kosong dulu / di restart dulu
        inputBerat.text = ""
        inputCourier.text = ""
        tableView.isHidden = true
        
        let headers = ["key": apiKey]

        let request = NSMutableURLRequest(url: NSURL(string: "https://api.rajaongkir.com/starter/city")! as URL,
             cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
              if (error != nil) {
                print(error as Any)
              } else {
                let httpResponse = response as? HTTPURLResponse
                print(httpResponse as Any)
              }

            if let iniData = data {
                self.parseJSON(Datanya: iniData)
            }
        })

        dataTask.resume()
    }
    
    @IBOutlet weak var inputBerat: UITextField!

    @IBOutlet weak var inputCourier: UITextField!
    
    @IBAction func cekOngkir(_ sender: UIButton) {
//        untuk restart agar table view kosong dulu
        service = []
        harga = []
        tableView.isHidden = false
        
        let headers = [
          "key": apiKey,
          "content-type": "application/x-www-form-urlencoded"
        ]

        let postData = NSMutableData(data: "origin=\(self.idOrigin)".data(using: String.Encoding.utf8)!)
        postData.append("&destination=\(self.idDest)".data(using: String.Encoding.utf8)!)
        postData.append("&weight=\(self.inputBerat.text ?? "")".data(using: String.Encoding.utf8)!)
        postData.append("&courier=\(self.inputCourier.text ?? "jne")".data(using: String.Encoding.utf8)!)

        let request = NSMutableURLRequest(url: NSURL(string: "https://api.rajaongkir.com/starter/cost")! as URL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = postData as Data

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
          if (error != nil) {
            print(error as Any)
          } else {
            let httpResponse = response as? HTTPURLResponse
            print(httpResponse as Any)
          }
            
            if let iniData = data {
                let decoder = JSONDecoder()
                do {
                    let decodeDataOngkir = try decoder.decode(OngkirModel.self, from: iniData)
                    DispatchQueue.main.async {
                        for i in 0...Int(decodeDataOngkir.rajaongkir.results[0].costs.count)-1 {
                            self.service.append(decodeDataOngkir.rajaongkir.results[0].costs[i].service)
                            self.harga.append(decodeDataOngkir.rajaongkir.results[0].costs[i].cost[0].value)
                        }
                        print(self.service.count)
                        self.tableView.reloadData()
                    }
                } catch {
                    print("error: \(error)")
                }
            }
        })

        dataTask.resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return service.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")! as! TableViewCell
//        agar cell kosong saat dijalankan kebeberapa kali
        cell.serviceLabel.text = ""
        cell.hargaLabel.text = ""
        cell.serviceLabel.text = service[indexPath.row]
        cell.hargaLabel.text = formatAsRupiah(harga[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }

    func parseJSON(Datanya: Data) {
        let decoder = JSONDecoder()
        var matchingOriginID: Int? = nil
        var matchingDestID: Int? = nil
        do {
            let decodeDataCity = try decoder.decode(CityModel.self, from: Datanya)
            
            DispatchQueue.main.async {
                if let inputTextOrigin = self.inputOrigin.text?.trimmingCharacters(in: .whitespacesAndNewlines).lowercased(), let inputTextDest =  self.inputDestination.text?.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() {

//                    untuk mencari id kota asal dan kota tujuan untuk dimasukkan ke api cost
                    for (index, result) in decodeDataCity.rajaongkir.results.enumerated() {
                        if result.city_name.lowercased().contains(inputTextOrigin) {
                            matchingOriginID = index + 1
                            print(matchingOriginID ?? "")
                            break
                        }
                    }
                    for (index, result) in decodeDataCity.rajaongkir.results.enumerated() {
                        if result.city_name.lowercased().contains(inputTextDest) {
                            matchingDestID = index + 1
                            print(matchingDestID ?? "")
                            break
                        }
                    }
                    

                    if let originID = matchingOriginID, let destID = matchingDestID {
//                       id kota tersebut disimpan dalam variabel
                        self.idOrigin = String(originID)
                        self.idDest = String(destID)
                        
                        self.cekKotaLabel.text = ""
                        self.viewAfter.isHidden = false

                    } else {
                        self.cekKotaLabel.text = "kota tidak tersedia"
                        self.viewAfter.isHidden = true
                    }
                }
                print("lewat")
            }
            
        } catch {
            print("ada error saat decode: \(error)")
        }
    }
    
    func formatAsRupiah(_ amount: Int) -> String {
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "id_ID")
        formatter.numberStyle = .currency
        formatter.currencySymbol = "Rp. "
        
        if let formattedString = formatter.string(from: NSNumber(value: amount)) {
            return formattedString
        } else {
            return "Rp. 0"
        }
    }
}

