import Foundation
import UIKit

class ContentsViewController: UIViewController {
  
  @IBOutlet weak var mainScrollView: UIScrollView!
  
  @IBOutlet weak var nameLabel: UILabel!
  
  @IBOutlet weak var recommendScrollView: UIScrollView!
  @IBOutlet weak var recommendStackView: UIStackView!
  
  @IBOutlet weak var mainEventImageView: UIImageView!
  @IBOutlet weak var mainEventImageViewHeightConstraint: NSLayoutConstraint!
  
  @IBOutlet weak var seeAllButton: UIButton!
  
  @IBOutlet weak var ingListScrollView: UIScrollView!
  
  @IBOutlet weak var thisTimeRecommendScrollView: UIScrollView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
}
