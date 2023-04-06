# swift-starbucks
iOS 클래스 프로젝트 - 스타벅스 앱

> 현재 구현 진행하고 있는 Branch : feature/rotateScreen

## 📝 Introduce Project

> 해당 프로젝트는 현재 URLProtocol 을 사용하여 Network 작업을 하고 있습니다. Local 파일을 가져오는 과정이오니 clone 후 바로 실행해주시면 되겠습니다.

* Storyboard, RxSwift 를 이용한 MVVM 구현
* 스타벅스 앱이 가진 여러 커스텀 뷰 구현을 통한 UIKit 활용 능력 훈련
* 공통 객체의 중복 구현 방지를 위한 protocol, inheritance 활용

## 💻 Tech Stack

<img src="https://img.shields.io/badge/-Swift-red"/> <img src="https://img.shields.io/badge/Test-XCTest-brightgreen"> <img src="https://img.shields.io/badge/Logic-RxSwift-critical"> <img src="https://img.shields.io/badge/Logic-RxCocoa-critical"> <img src="https://img.shields.io/badge/Logic-RxRelay-critical">

## 🛠 Architecture

### MVVM

MVVM 에서 가장 중요하게 생각하는 것은 ViewModel 입니다.

현재까지 정의한 ViewModel 의 역할은 다음과 같습니다.

* ViewController 가 Model 을 사용해야 하는 작업을 요청하는 객체
* View 에서 사용할 Entity 의 타입을 정의. ViewModel 이 관리합니다.
* ViewModel 은 ViewController, View 가 사용할 API 를 제공해야 하며 이는 Rx 바인딩을 통해 대부분 사용합니다.
* ViewModel 은 그 자체만으로 화면의 상태를 관리하고 있어야 합니다.

## ❗️ Challenge

* XCTest 를 활용한 Unit-Test 를 통해 효율적인 ViewModel 생성.
  * 이후에는 ViewModel 일반화를 통해 코드 중복 및 유지보수성을 더욱 증가.
* 수평/수직 화면 모두 구현하여 더욱 훌륭한 UI 구현.
