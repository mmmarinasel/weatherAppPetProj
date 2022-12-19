import UIKit

class ForecastViewController: UIViewController {
    
    enum SectionKind: Int, CaseIterable {
        case hourlyForecast, weeklyForecast, description, info
        var cellCount: Int {
            switch self {
            case .hourlyForecast:
                return 24
            case .weeklyForecast:
                return 7
            case .description:
                return 1
            case .info:
                return 10
            }
        }
    }

    @IBOutlet weak var forecastCollectionView: UICollectionView!
    
    @IBAction func backButton(_ sender: Any) {
        
    }
    
    private var viewModel = CitiesListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.viewModel.weatherForecast.bind { [weak self] _ in
//
//        }
    }
    
    private func supplementaryHeaderItem() -> NSCollectionLayoutBoundarySupplementaryItem {
        .init(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                heightDimension: .estimated(50)),
              elementKind: UICollectionView.elementKindSectionHeader,
              alignment: .top)
    }
    
}

    // MARK: - UICollectionViewDataSource, UICollectionViewDelegate

extension ForecastViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return SectionKind.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let section = SectionKind(rawValue: section) else { return 0 }
        return section.cellCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        <#code#>
    }
}
