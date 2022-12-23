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
        self.dismiss(animated: true)
    }
    
    private var viewModel = ForecastViewModel()
    var city: String? {
        didSet {
            self.viewModel.city.value = city ?? ""
        }
    }
    
    static let id: String = "forecastVC"
    private let backgroundColor = UIColor(named: "forecast_background")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewModel.weatherForecast.bind { [weak self] _ in
            DispatchQueue.main.async {
                self?.forecastCollectionView.reloadData()
            }
        }

        let updateCollectionView: () -> () = { [weak self] in
            DispatchQueue.main.async {
                self?.forecastCollectionView.reloadData()
            }
        }
        self.viewModel.hourlyCellViewModels.bind { _ in updateCollectionView() }
        self.viewModel.infoCellViewModels.bind { _ in updateCollectionView() }
        self.viewModel.weeklyCellViewModels.bind { _ in updateCollectionView() }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.forecastCollectionView.collectionViewLayout = createLayout()
        self.view.backgroundColor = self.backgroundColor
        self.forecastCollectionView.backgroundColor = self.backgroundColor
    }
    
    
    // MARK: - UICollectionViewLayout
    
    
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] (sectionIndex, layoutEnviroment) -> NSCollectionLayoutSection? in
            let section = SectionKind(rawValue: sectionIndex)
            guard let section = section else { return nil }
            switch section {
            case .hourlyForecast:
                return self?.createHourlyForecastSection()
            case .weeklyForecast:
                return self?.createWeeklyForecastSection()
            case .description:
                return self?.createDescrSection()
            case .info:
                return self?.createInfoSection()
            }
        }
        let config = UICollectionViewCompositionalLayoutConfiguration()
        layout.configuration = config
        return layout
    }
    
    
    // MARK: - NSCollectionLayoutSection
    
    
    private func createHourlyForecastSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(60),
                                               heightDimension: .absolute(116))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item])
        group.interItemSpacing = .flexible(15)
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0,
                                                        leading: 10,
                                                        bottom: 0,
                                                        trailing: 10)
        section.orthogonalScrollingBehavior = .continuous
        section.boundarySupplementaryItems = [self.supplementaryHeaderViewItem()]
        return section
    }
    
    private func createWeeklyForecastSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(31))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .estimated(1))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize,
                                                       subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 15,
                                                        leading: 0,
                                                        bottom: 15,
                                                        trailing: 0)
        section.boundarySupplementaryItems = [self.supplementaryHeaderItem()]
        return section
    }
    
    private func createDescrSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(60))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [self.supplementaryHeaderItem()]
        return section
    }
    
    private func createInfoSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: /*.fractionalWidth(0.25)*/ .absolute(60))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       repeatingSubitem: item,
                                                       count: 2)
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0,
                                                        leading: 20,
                                                        bottom: 0,
                                                        trailing: 20)
        section.interGroupSpacing = 0.5
        section.boundarySupplementaryItems = [self.supplementaryHeaderItem()]
        return section
    }
    
    private func supplementaryHeaderItem() -> NSCollectionLayoutBoundarySupplementaryItem {
        .init(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                heightDimension: .estimated(0.5)),
              elementKind: UICollectionView.elementKindSectionHeader,
              alignment: .top)
    }
    
    private func supplementaryHeaderViewItem() -> NSCollectionLayoutBoundarySupplementaryItem {
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize:
                                                                    .init(widthDimension: .fractionalWidth(1),
                                                                          heightDimension: .estimated(326)),
                                                                 elementKind: UICollectionView.elementKindSectionHeader,
                                                                 alignment: .top)
        return header
    }
    
}

    // MARK: - UICollectionViewDataSource, UICollectionViewDelegate

extension ForecastViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return SectionKind.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let section = SectionKind(rawValue: section) else { return 0 }
        return section.cellCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let section = SectionKind(rawValue: indexPath.section) else { return UICollectionViewCell() }
        
        switch section {
        case .hourlyForecast:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HourlyForecastCollectionViewCell.id,
                                                          for: indexPath) as? HourlyForecastCollectionViewCell
            let cellVM = self.viewModel.getHourlyCellViewModel(at: indexPath)
            cell?.cellViewModel = cellVM
            guard let cell = cell else { return UICollectionViewCell() }
            return cell
            
        case .weeklyForecast:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeeklyForecastCollectionViewCell.id,
                                                          for: indexPath) as? WeeklyForecastCollectionViewCell
            let cellVM = self.viewModel.getWeeklyCellViewModel(at: indexPath)
            cell?.cellViewModel = cellVM
            guard let cell = cell else { return UICollectionViewCell() }
            return cell
            
        case .description:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DescriptionCollectionViewCell.id,
                                                          for: indexPath) as? DescriptionCollectionViewCell
            
            cell?.descriptionLabel.text = "Cloudy conditions will continue all day. Wind gusts are up ti 9 mph."
            
            guard let cell = cell else { return UICollectionViewCell() }
            return cell
            
        case .info:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InfoCollectionViewCell.id,
                                                          for: indexPath) as? InfoCollectionViewCell
            let cellVM = self.viewModel.getInfoCellViewModel(at: indexPath)
            cell?.cellViewModel = cellVM
            guard let cell = cell else { return UICollectionViewCell() }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ForecastCollectionReusableView.id, for: indexPath) as? ForecastCollectionReusableView
            else { return UICollectionReusableView() }
            if indexPath.section == 0 {
                header.setup(forecast: self.viewModel.weatherForecast.value as? WeatherForecast)
            } else {
                header.containerView.backgroundColor = .white
                header.layer.opacity = 0.3
            }
            
            return header
        default:
            return UICollectionReusableView()
        }
    }
}
