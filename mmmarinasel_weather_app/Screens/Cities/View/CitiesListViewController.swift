import UIKit

class CitiesListViewController: UIViewController {

    @IBOutlet weak var citiesTableView: UITableView!

    private var viewModel = CitiesListViewModel()
    
    private let backgroundColor = UIColor(named: "list_background")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.citiesTableView.backgroundView?.backgroundColor = self.backgroundColor
        self.view.backgroundColor = self.backgroundColor
        self.citiesTableView.backgroundColor = self.backgroundColor
        
        self.viewModel.citiesCellViewModelsFiltered.bind { [weak self] _ in
            DispatchQueue.main.async {
                self?.citiesTableView.reloadSections(IndexSet(integer: 1), with: .none)
            }
        }
    }
}


    // MARK: - UITableViewDelegate


extension CitiesListViewController: UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.textColor = .white
        header.textLabel?.font = UIFont.boldSystemFont(ofSize: 34)
        header.textLabel?.frame = header.bounds
        header.textLabel?.textAlignment = .left
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sectionName: String
        switch section {
        case 0:
            sectionName = "Weather"
        default:
            sectionName = ""
        }
        return sectionName
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            let height = self.view.frame.height / 9
            return height
        case 1:
            return 10
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 40
        case 1:
            return 90
        default:
            return 0
        }
    }
}


    // MARK: - UITableViewDataSource


extension CitiesListViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return self.viewModel.citiesCellViewModelsFiltered.value?.count ?? 0
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.id) as? SearchTableViewCell else { return UITableViewCell() }
            cell.backgroundColor = self.backgroundColor
            cell.viewModel = self.viewModel
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CityTableViewCell.id) as? CityTableViewCell else { return UITableViewCell() }
            cell.backgroundColor = self.backgroundColor
            let cellVM = self.viewModel.getCityCellViewModel(at: indexPath)
            cell.cellViewModel = cellVM
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let storyboard: UIStoryboard = UIStoryboard(name: "Forecast", bundle: nil)
        let forecastVC  = storyboard.instantiateViewController(withIdentifier: ForecastViewController.id) as? ForecastViewController
        guard let vc = forecastVC else { return }
        vc.modalPresentationStyle = .fullScreen
        vc.city = self.viewModel.citiesCellViewModelsFiltered.value?[indexPath.row].city ?? ""
        self.present(vc, animated: true)
    }
}



