//
//  ViewModel.swift
//  CodeAssignment
//
//  Created by Mollick, Tapash on 19/06/21.
//

import ObjectMapper
import Starscream

class ViewModel {
    
    var server = WebSocketServer()
    var socket: WebSocket!
    var netWorkd = Network()
    
    private(set) var dataSource: [City]? {
        didSet {
            self.bindDataToController()
        }
    }
    
    var bindDataToController: (() -> ()) = {}
    
    func numberOfRowsInSection() -> Int {
        guard let source = dataSource else {
            return 0
        }
        debugPrint("source\(source.map {$0.city})")
        return source.count
    }
    
    func item(for row: Int) -> City? {
        guard let source = dataSource else {
            return nil
        }
        return source[row]
    }
    
    func loadData(completion: () -> Void) {
        self.prepareModel()
        netWorkd.load { [weak self] (result) in
            switch result {
                case .success(let data) :
                    print("data:\(data)")
                case .failure(let error):
                    print("error: \(error.localizedDescription)")
            }
        }
    }
    
    func prepareModel(){
        netWorkd.bindDataToViewModel = {
            if let dataSource = self.dataSource, dataSource.count > 0 {
            let indexes = self.indexesOfCities(city: $0 ?? [])
            debugPrint("indexes:\(indexes)")
                self.updateArrCities(indexesOfStocksValue: indexes, iexEvents: $0 ?? [])
            }
            else {
                self.dataSource = $0
            }
        }
    }
    
    

    final func indexesOfCities(city:[City]) -> [Int] {

        return city.reduce([]) { (currentResult, currentcity) in

            if let currentAqiIndex = dataSource?.firstIndex(where: { currentcity.city == $0.city }) {

                return currentResult + [currentAqiIndex]
            }
            return currentResult
        }
    }
    
    final func updateArrCities(indexesOfStocksValue:[Int], iexEvents:[City]) {

        for i in stride(from: 0, to: indexesOfStocksValue.count, by: 1) {

            dataSource?[indexesOfStocksValue[i]] = iexEvents[i]
        }
    }
}

