import RealmSwift

class TransactionRecordDataSource {
    weak var delegate: ITransactionRecordDataSourceDelegate?

    private let realmFactory: IRealmFactory

    var results: Results<TransactionRecord>
    var token: NotificationToken?

    init(realmFactory: IRealmFactory) {
        self.realmFactory = realmFactory

        results = TransactionRecordDataSource.results(realmFactory: realmFactory, coinCode: nil)
        subscribe()
    }

    private func subscribe() {
        token?.invalidate()

        token = results.observe { [weak self] _ in
            self?.delegate?.onUpdateResults()
        }
    }

    deinit {
        token?.invalidate()
    }

    static func results(realmFactory: IRealmFactory, coinCode: CoinCode?) -> Results<TransactionRecord> {
        var results = realmFactory.realm.objects(TransactionRecord.self).sorted(byKeyPath: "timestamp", ascending: false)

        if let coinCode = coinCode {
            results = results.filter("coinCode = %@", coinCode)
        }

        return results
    }

}

extension TransactionRecordDataSource: ITransactionRecordDataSource {

    var count: Int {
        return results.count
    }

    func record(forIndex index: Int) -> TransactionRecord {
        return results[index]
    }

    func set(coinCode: CoinCode?) {
        results = TransactionRecordDataSource.results(realmFactory: realmFactory, coinCode: coinCode)
        subscribe()
    }

}
