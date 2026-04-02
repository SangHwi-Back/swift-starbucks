# swift-starbucks

<img src="https://img.shields.io/badge/-Swift-red"/> <img src="https://img.shields.io/badge/Test-XCTest-brightgreen"> <img src="https://img.shields.io/badge/Logic-RxSwift-critical"> <img src="https://img.shields.io/badge/Logic-RxCocoa-critical"> <img src="https://img.shields.io/badge/Logic-RxRelay-critical">

> 현재 구현 진행하고 있는 Branch : feature/rotateScreen<br/>
> 해당 프로젝트는 현재 URLProtocol 을 사용하여 Network 작업을 하고 있습니다. Local 파일을 가져오는 과정이오니 clone 후 바로 실행해주시면 되겠습니다.

## 📝 Introduce Project(간략 소개)

<table style="width: 50%">
  <td><image style="float:left" src="https://user-images.githubusercontent.com/65931336/230513431-dcdeef5a-7954-472f-9619-a13100e99458.gif" alt="Original Image"/></td>
  <td><image src="https://user-images.githubusercontent.com/65931336/230513433-7c15a137-8f75-4131-8207-3f4229b2123d.gif" alt="Portfolio App Image"/></td>
</table>
    
스타벅스 앱 프로젝트는 실제 스타벅스 앱의 뷰와 그 로직을 구현하는 실습을 통해 RxSwift, Storyboard 활용능력을 높이기 위해 진행하고 있습니다.

Storyboard 를 활용하는 프로젝트에서 Dynamic 한 동작이 필요한 UI 에 대해 Programmatically 한 방법을 많이 도입하였지만, Storyboard 를 최대한 활용하여 ViewController 의 부담을 많이 덜어내려 하고 있습니다. 결과적으로 Storyboard 가 View 의 역할을 함으로써 유지보수성이 증가하는 결과를 기대하고 있습니다.

이외에도 MVVM 활용 방안, RxSwift 심화 등 또한 중요하게 다뤄질 예정입니다.

## 🛠 Architecture(구조)

### MVVM

```none
┌────────────────┐     1:1    ┌────────────────┐    1:N     ┌───────────────┐
|   Storyboard   | ─────────▶ |     Custom     | ─────────▶ |   ViewModel   |
|      View      |            | ViewController |    ┌─────▶ └───────┬───────┘
└────────┬───────┘            └────────┬───────┘    | Send          |
         |                             |            | Event   ┌───────────┐
 ┌──────┐▼┌──────┐               ┌─────▼─────┐ ─────┘         |   Model   |
 | View | | View |   Reference   | @IBOutlet |                └─────┬─────┘
 └──────┘ └──────┘ ◀──────────── └───────────┘                      |
 ┌──────┐ ┌──────┐ ◀──────────── ┌───────────┐    RxCocoa   ┌───────▼──────────┐
 | View | | View |               | @IBOutlet |     Bind     |     ReadOnly     |
 └──────┘ └──────┘               └───────────┘ ◀─────────── |  var itemBinder  |
                                                            └──────────────────┘
```

* 스토리보드(View) = UI 속성 정의, 위치 및 크기 제약조건 설정
* ViewController = View 객체 참조, ViewModel 과 View 바인딩 정의, View Transition 정의.
* ViewModel = View 들의 상태관리, 메모리에 저장된 Entity 를 참조 및 수정.
* Model = Persistent, Network 등 앱이 필요한 정보를 요청하는 역할.
* Entity = UI의 상태 단위. 예를 들어 JSON에 포함된 하나의 객체를 표현.

## 🎣 Using External Dependency(외부 의존성 활용 방안)

<table style="width: 50%">
  <tr>
    <th colspan="2" width="30%">Source Code</th>
    <th width="30%">Description</th>
  </tr>
  <tr>
    <td><image style="flow:right" src="https://user-images.githubusercontent.com/65931336/230516171-454ab611-8a92-4534-9009-61baadb3851e.jpg"/></td>
    <td><image src="https://user-images.githubusercontent.com/65931336/230516174-0ccd564e-9a96-419d-b241-243af3faf629.jpg"/></td>
    <td>스타벅스의 이미지들은 GET 요청이 가능했지만 이미지를 모두 다운받아서 저장해 놓았습니다. 네트워크 환경과 관계없이 앱을 실행할 수 있게 만들기 위해서입니다.</td>
  </tr>
</table>

이미지를 가져오는 모델 객체가 구현하는 프로토콜입니다. imageData 프로퍼티를 가지는 것만으로 캐싱 및 불러오기 기능을 자동으로 갖게 됩니다.

```swift
import Foundation
import RxSwift

protocol ImageFetchable {
  var imageData: [String: Data] { get set }
}

extension ImageFetchable {
  func getImageFrom(fileName: String) -> Observable<Data> {
      if let data = imageData[fileName] {
        return .just(data)
      }
      
      guard let url = fileName.getImageURL() else {
        return .just(Data())
      }
      
      return URLSession.shared.rx.data(request: URLRequest(url: url))
  }
}

extension String {
  func getImageURL() -> URL? {
    Bundle.main.url(forResource: self, withExtension: "jpeg")
    ?? Bundle.main.url(forResource: self, withExtension: "jpg")
    ?? Bundle.main.url(forResource: self, withExtension: "png")
  }
}
```

jsonName 을 지정하면 json 을 불러오는 프로토콜입니다. 구현만 하면 JSON 을 가져오는 모델 객체가 될 수 있도록 하였습니다.

```swift
import Foundation
import RxSwift

protocol JSONFetchable {
  var jsonName: String? { get set }
}

extension JSONFetchable {
  func getJSONFetchObservable() -> Observable<(response: HTTPURLResponse, data: Data)> {
    guard let jsonName else {
      return .error(ViewModelError.errorWithMessage("JSON File Name not defined."))
    }
    guard let url = Bundle.main.url(forResource: jsonName, withExtension: "json") else {
      return .error(ViewModelError.urlError("JSON URL doesn't created using jsonname \(jsonName)."))
    }
    
    return URLSession.shared.rx
      .response(request: URLRequest(url: url))
  }
}
```

## 👨‍🎨 View == Storyboard

Storyboard 를 사용할 때 최고의 이점이라 생각되는 부분은 다음과 같습니다.

1. Storyboard 를 통해 어떤 뷰인지 가늠할 수 있습니다(코드 가독성 향상).
2. 뷰 수정이 간편합니다.
3. UIStackView 를 이용하면 뷰를 제거/추가/위치변경 등이 매우 수월합니다.

그에 비해 다음과 같은 단점이 존재할 수 있습니다.

1. 수정 시 Code Conflict 위험이 존재합니다.
2. 실제 디바이스의 실행 결과와 다른 Case 가 의심스럽게도 다수 등장합니다.
3. AutoLayout 사용 시 충분한 Constraint 를 제공하지 못하면 오류가 발생합니다. 이는 AutoLayout 의 알고리즘에 따른 것이므로, 작업자의 생각과 다를 수 있습니다.

실제 프로젝트를 진행하면서 Storyboard 에 대해 느낀 점은 아래와 같습니다.

<table style="width: 50%">
  <tr>
    <td width="30%"><image src="https://user-images.githubusercontent.com/65931336/230519346-1ebf1fb5-c873-4085-8062-0262e37a15cf.jpg"/></td>
    <td width="30%">처음에는 UIScrollView를 스토리보드로 구현하지 못한다고 생각하여 CodeBase-UI만 사용해야겠다고 생각하였습니다.<br/>하지만 이는 Content Layout Guide, Frame Layout Guide 를 구분하지 못했기 때문이었습니다.<br/>스토리보드를 통해 UI 요소들을 미리 초기화시킬 수 있는 점을 적극 활용할 수 있습니다.<br/>또한, Static한 UI 요소들을 UIStackView에 위치시키면 나중에 다른 요소를 추가하거나 대체할 때 쉽게 진행할 수 있습니다.</td>
  </tr>
  <tr>
    <td width="30%"><image src="https://user-images.githubusercontent.com/65931336/230519349-05c9dc3a-b8c1-432b-8bfb-00f7a739054f.jpg"/></td>
    <td width="30%">스토리보드로 UITableView, UICollectionView 를 각각 구현한 화면입니다.<br/>왼쪽처럼 Vertical 하게 컨텐츠를 보여주고 Swipe 액션을 통해 수정하는 것은 UITableView로도 충분하였습니다. 프레임워크 차원에서 제공하는 기능을 최대한 활용하는 것이 최적화의 기본이라고 생각합니다.<br/>오른쪽처럼 3 종류의 화면을 Horizontal 하게 할 경우에는 UICollectionView를 사용했습니다. 복잡한 상황에 UICollectionView가 굉장히 유용했습니다. UICollectionViewCell 안에 UITableView 를 넣기도 하였습니다.<br/>물론 모드 코드로 구현 가능하지만 이처럼 스토리보드로 구현해 놓으면 한눈에 화면 구성을 확인할 수 있습니다.</td>
  </tr>
</table>

## 😶‍🌫️ Abstraction(객체 추상화)

현재 ViewModel 은 아래와 같이 추상화 되어 있습니다.

하지만, 이번 수평/수직 화면전환 관련 작업을 하면서 Entity 를 저장할 필요성을 느끼지 못하고 있습니다. **아래 내용은 차후에 수정될 가능성이 크다는 점을 강조드리고 싶습니다**.

```none
┌───────────────┐ Entity 타입 정의, 배열 형태로 저장 및 참조
|   ViewModel   | DisposeBag 관리
|  (protocol)   | Entity 를 방출하는 Subject 객체를 관리
└────┬──────────┘
     |  Conformance    ┌──────────────────────┐
     └───────────────▶ |  StarbucksViewModel  | Entity 타입을 StarbucksEntity 로 정의
                       |        Class         | init/deinit 시 HTTPRequestMockProtocol 등록/제거
                       |     1st Concrete     | Identifiable, Equatable 을 구현한 Entity 는 기본적으로 CRUD 함수를 제공하도록 구현 
                       └────┬─────────────────┘
                            |                       **Example**
┌──────────────────┐        |  Inheritance    ┌──────────────────────┐
|  ImageFetchable  | ───────└───────────────▶ |  OrderMainViewModel  | JSONFetchable 로 원하는 Entity 가 정의 json 을 손쉽게 load 
|  JSONFetchable   |           Conformance    |        Class         | ImageFetchable 로 원하는 이름의 이미지 파일을 요청
|     protocol     | ───────────────────────▶ |     2st Concrete     |
└──────────────────┘                          └──────────────────────┘
```

## 🧪 Example of Custom View. Navigation Bar(커스텀 뷰 예시. 네비게이션 바)

스타벅스 앱은 특이하게 UINavigationBar 의 Large format 을 두 가지 형태로 사용합니다.

1. 첫 번째 메인 화면에 여러 정보를 담은 Large format 의 NavigationBar
2. UITableView, UICollectionView 만을 담은 뷰에 위치한 Large format 의 NavigationBar

하지만, Navigation Bar large format 은 뷰 계층의 맨 상위의 뷰가 테이블 뷰 혹은 컬렉션 뷰일 경우만 적용됩니다. 2번에만 해당하는 내용입니다.

1번은 RxCocoa 를 통해 직접 구현하는 수 밖에는 없는 것입니다. 컨트롤이 불가능한 NavigationBar 는 숨기고 직접 구현하는 편이 더 낫다고 생각합니다. 아래는 UIScrollView 의 Content offset 값을 통해 NavigationBar 를 컨트롤하는 코드입니다.

> 아래 코드는 실제 코드의 축약 버전입니다.

```swift

@IBOutlet weak var headerScrollView: UIScrollView!
@IBOutlet weak var headerScrollViewHeight: NSLayoutConstraint!

@IBOutlet weak var mainScrollView: UIScrollView!
    
private var originalHeaderHeight: CGFloat = 0
private var headerHeightExceptButtons: CGFloat {
  originalHeaderHeight - (UIDevice.current.hasNotch ? 32 : 16)
}
    
override func viewDidLoad() {
  super.viewDidLoad()
  
  originalHeaderHeight = headerScrollView.frame.height
  
  // 메인 컨텐츠의 스크롤 뷰 ContentOffset 값을 방출하는 Observable 을 생성합니다.
  let mainScrollViewOffsetObservable = mainScrollView.rx.contentOffset
    .observeOn(MainScheduler.asyncInstance)
    .filter({ $0.y <= self.headerHeightExceptButtons }) // next 이벤트의 값은 최초 높이 값 이하로 제한합니다.
  
  // AutoLayout Constraint 의 constant 값과 바인딩 합니다.
  mainScrollViewOffsetObservable
    .map({ self.originalHeaderHeight - $0.y})
    .bind(to: headerScrollViewHeight.rx.constant)
    .disposed(by: disposeBag)
  
  // 줄어드는 만큼 alpha 값도 줄어들도록 바인딩 합니다.
  mainScrollViewOffsetObservable
    .map({ 1 - ($0.y / self.headerHeightExceptButtons) })
    .bind(to: thumbnailView.rx.alpha, rewardView.rx.alpha)
    .disposed(by: disposeBag)
}
        
```

## ❗️ Challenge

* XCTest 를 활용한 Unit-Test 를 통해 효율적인 ViewModel 생성.
  * 이후에는 ViewModel 일반화를 통해 코드 중복 및 유지보수성을 더욱 증가.
* 수평/수직 화면 모두 구현하여 더욱 훌륭한 UI 구현.
