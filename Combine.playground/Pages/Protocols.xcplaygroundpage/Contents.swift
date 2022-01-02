//: [Previous](@previous)

//: ref: [22가지 짧은 테스트](https://www.cocoawithlove.com/blog/twenty-two-short-tests-of-combine-part-1.html) \
//: ref: [github](https://github.com/mattgallagher/CombineExploration)

/*:
 💬Intent
 ==============
 Combine의 성능은 다른 Reactive 프레임워크와 어떻게 차이날까? \
 3부분으로 나눠서 비교해보겠다.
 
 1. Combine의 핵심 프로토콜 재구현
 2. 세 가지 주제: shared computation, shared reference lifetimes, sharing subscribers
 3. asynchrony, threading, performance
 
 
 - Callout(⚠︎Warning):
 이것은 Combine에 대한 튜토리얼이 아닙니다. \
 기존 방식으로 Combine 을 사용하지 않고 Combine의 일부 엣지 케이스를 살펴보고 향후 변경될 수 있는 동작을 테스트합니다.
 */

/*:
 ### 난 튜토리얼이 필요한데...

 그래서 찾아보게 된 정석 튜토리얼 : WWDC19 \
 [Introducing Combine](https://developer.apple.com/videos/play/wwdc2019/722/)  \
 [Combine in Practice](https://developer.apple.com/videos/play/wwdc2019/721/) 다음번에..
 */

/*:
 1️⃣ Introducing Combine
 ==============
 ## 비동기에 대해서 얘기해볼까?
 Asynchronous programming (by Tony parker, Foundation Manager)
 */
/*:
 ### 작업 중인 앱
 학생들이 마법학교에 등록(회원가입) 하는 화면
 */
/*:
 ### 앱 요구사항
 - Valid user name (서버에 네트워크 요청을 하여 확인할 유효한 사용자 이름)
 - Matching passwords (앱에서 로컬하게 확인할 수 있는 비밀번호)
 - Responsive user interface (이 작업들을 수행하는 동안 메인 스레드를 차단하지 않고 유지할 사용자 인터페이스)
 */
/*:
 ### 동작
 "일단, 이름을 입력해볼까? Merlin.. 어때? 꽤 괜찮은 마법사 이름 같은데..."\
 이러는 동안에 이미 많은 비동기적 행동들이 일어나고 있습니다.
 1. Target/Action 을 사용하여 사용자 입력에 대한 notifications 을 받았습니다.
 2. 네트워크 요청으로 서버에 무리 주지 않기 위해 타이머를 사용해서 사용자가 입력을 멈추기를 조금 기다립니다.
 3. KVO 같은 걸 이용해서 그 비동기 작업에 대한 진행 상황 업데이트를 듣습니다.
 4. 이제 계속 진행하면 해당 요청으로부터 응답이 수신되어 UI를 업데이트해야 합니다.\
 그래서 새로운 사용자 이름과 12345 라는 엄청 비밀스러운 비밀번호를 골랐습니다. (농담입니다.)
 */
/*:
 ### summary : 어떤 비동기 작업들이 있었나?
 ![asynchronous-work](asynchronous-work.png)
 1. URL 세션 요청에 대한 응답을 기다려야 했습니다.
 2. 그 결과를 synchronous 하게 검사해서 결과와 합쳐야 했고
 3. 모두 완료되면, KVC 와 같은 것을 사용하여 UI를 다시 업데이트해야 했습니다.
 */
/*:
 ### Cocoa SDK에서 찾은 비동기식 인터페이스
 - Target/Action
 - NotificationCenter
 - URLSession
 - Key-value observing
 - Ad-hoc callbacks
 - Callout(💬): Target/Action 과 같은 것도 있지만 `NotificationCenter` 와 `ad-hoc 콜백` 등 훨씬 더 많습니다.\
 이것들은 `closure` 또는 `completion block` 을 취하는 API입니다.\
 이 모든 것들은 중요하고 다른 사용 사례를 가지고 있습니다. 하지만 여러분이 이것들을 함께 사용해야 할 때, 좀 어려울 수 있습니다.\
 그래서 Combine을 통해 이 모든 것을 대체하는 것이 아니라 그 안에서 공통적인 것을 찾기 시작했습니다.
 */
/*:
 ### 그렇게 만들어진 Combine 의 특징들
 - Generic
 - Type safe
 - Composition first
 - Request driven
 
 1. 시간에 따른 값 처리를 위해 만들어진 unified 한 선언적 API
 - Swift 로 만들었고 Swift 에서 사용할 수 있습니다.
 - 즉, `Generics` 과 같은 스위프트 기능을 활용할 수 있습니다. (비동기 동작에 대한 일반적인 알고리즘을 한 번 작성하여 다른 모든 종류의 비동기 인터페이스에 적용할 수 있습니다.)
 
 2. 런타임 말고 컴파일 시간에 오류를 탐지할 수 있어서 안전합니다!
 - Combine 에 대한 주요 디자인 포인트는 composition 이 먼저라는 것입니다.
 - 핵심 개념들이 단순하고 이해하기 쉽지만 종합해보면 그 부분의 합보다 더 큰 것을 만들 수 있다는 얘기!
 
 3. request-driven 이므로 앱의 메모리 사용량과 성능을 보다 세심하게 관리할 수 있습니다.
 - 이제 그 핵심 개념들에 대해 이야기해보도록 하겠습니다
 - 딱 3명만 있습니다. `Publishers`, `Subscribers`, `Operators`
 */
/*:
 ### 먼저 Publishers.
 1. Combine API 의 선언적(declarative) 부분
 - 값(values)와 오류(errors)가 어떻게 만들어지는지를 설명한다.
 - 실제로 반드시 생산하는 것은 아닙니다.
 - 즉, 값 유형이고 스위프트에서는 우리가 struct 를 사용한다는 것을 의미합니다.
 
 2. `Subscriber` 의 등록(registration)을 허용하며, `Subscriber` 는 시간이 지남에 따라 그 값들을 받을 수 있습니다.
 ![protocol-publisher](protocol-publisher.png)
 1. 두 가지 `associatedtype` 이 있습니다: Output(생산되는 value) 과 Failure(생산되는 errors).
 - publisher 가 오류를 생성할 수 없는 경우 `associatedtype` 에 대해 `Never` 형식을 사용할 수 있습니다.\
    예를들어 `Just` 를 확인해보면 `Failure` 가 `Never` 로 정의된 것을 볼 수 있습니다.\
    publisher가 fail 이벤트가 절대 일어나지 않는 경우 사용합니다.
     ![just](just.png)
     
 2. Subscribe 라고 하는 1가지 key 함수가 있습니다.
 - `Generic` 제약 조건을 보면 알 수 있듯이 구독하려면 `Subscriber` 의 인풋이 `Publisher` 의 아웃풋과 일치해야 하고
 - `Subscriber` 의 `Failure` 가 `Publisher` 의 `Failure` 와 일치해야 합니다.
 - 여기 `Publisher` 의 예시를 하나 보여드릴게요. NotificationCenter 로서의 Publisher 를 사용하는 방법입니다.\
 보시다시피 struct 이며 Ouput 유형은 Notifications 이고 Failure 유형은 Never 입니다.\
 center, name, object 3가지로 초기화하고 있죠? (기존 NotificationCenter API 와 비슷)\
 다시 말하지만 NotificationCenter 를 replace 하려는 것이 아닙니다. 그냥 적용하는 거예요.
 ![publisher-notification](publisher-notification.png)
 */

/*:
 ### 다음은 Subscribers.
 - `Subscriber` 는 `Publisher` 의 상대입니다.
 - `Publisher` 가 유한한 경우 completion 을 포함하여 값(values)을 받는 것입니다. (values + completion)
 - `Subscriber` 는 보통 값을 받으면 동작하고 상태를 변형시키기 때문에, 참조 타입을 사용합니다. 클래스라는거죠. (reference type)
 
 ![protocol-subscriber](protocol-subscriber.png)
 1. 보시다시피 두 가지 `associatedtype` 이 동일합니다: Input, Failure.
 - `Subscriber` 가 `Failure` 를 수신할 수 없는 경우 `Never` 형식을 사용할 수 있습니다.
 
 2. 3가지 key 함수가 있습니다.
 - `subscription` 을 받을 수 있습니다:\
 `Subscriber` 가 `Publisher` 에서 `Subscriber` 로의 데이터 흐름을 제어하는 방법입니다.
 - 물론 Input 을 받을 수도 있습니다. 마지막으로 연결된 `Publisher` 가 유한한 경우 완료 또는 실패가 될 수 있는 completion 을 받을 수 있습니다.
 - 여기 `Subscriber` 의 예시를 하나 보여드릴게요. `Assign` 입니다.
 Assign 은 클래스이며 클래스의 인스턴스, 객체의 인스턴스, 해당 객체에 대한 안전한 key path 타입으로 초기화됩니다.\
 input 을 받으면 그 개체의 property 에 write 합니다.\
 Swift 에서는 property 만 write 할 때 오류를 처리할 수 있는 방법이 없기 때문에 Assign의 `Failure` 타입을 `Never` 로 설정합니다.\
 ![subscriber-assign](subscriber-assign.png)
*/

/*:
 ### Pattern
 ![pattern](pattern.png)
 1. `Subscriber` 를 보유하는 컨트롤러 개체나 다른 유형이 있을 수 있으며 subscribe 메소드를 호출해서 `Subscriber` 를  `Publisher` 에 붙힐 수 있습니다.
 2. 이 때 `Publisher` 는  `Subscriber` 에게 `subscription` 을 보내고 `Subscriber`가 이것을 특정 갯수만큼의 값 또는 무제한에 대한 요청을 하는 데 사용할 겁니다.
 3. 이 때 `Publisher` 는 해당 수 이하의 값을 `Subscriber` 에게 자유롭게 보낼 수 있습니다.
 4. `Publisher` 가 유한하면 완료 또는 오류를 보냅니다.
 */

/*:
 ### Comeback to Ex
 ![pattern-ex-wizard](pattern-ex-wizard.png)
 1. 다시 예시로 돌아가면, 제가 Wizard 라고 부르는 모델 오브젝트를 가지고 있는데, 그 마법사가 몇 학년인지가 궁금합니다.
 2. 현재 5학년인 Merlin 부터 시작하겠습니다. 제 학생들이 졸업했다는 알림을 듣고, 졸업하면 모델 객체의 값을 업데이트하고 싶습니다.
 3. Merlin 의 졸업에 대한 NotificationCenter Publisher 부터 만들었습니다.
 4. `Subscriber` Assign 을 만들어서 Merlin 학년 property 값에 새 학년을 write 하도록 만들었습니다.
 5. 마지막으로 Subscribe 을 사용하여 붙히려고(attach) 했습니다. 하지만 예상하신 대로 컴파일되지 않습니다.\
 그 이유는?? type 맞지 않기 때문입니다.\
 ![pattern-ex2-wizard](pattern-ex2-wizard.png)
 6. NotificationCenter 에서는 notifications 을 생성하지만 Assign 에는 int 가 필요합니다.
 7. 그래서 우리가 필요한 것은 notifications - int 사이에서 변환하는 것입니다. 그것이 바로 `Operator` 입니다.
 */
 
/*:
### Operator (변환자, 연산자)
 - `Operator` 는 `Publisher` 프로토콜을 채택하기 전까진 `Publisher` 입니다.
 - 역시 선언적이기 때문에 value type 입니다.
 - 하는 일은 값을 바꾸고, 값을 더하고, 값을 제거하는 것입니다.
 - 다른 `Publisher` 를 구독하는 것을 `upstream` 이라 부르고,
 - 그 결과를 `Subscriber` 에게 보내는 것을 `downstream` 이라 부릅니다.
 ![protocol-operator](protocol-operator.png)
 - Operator 의 예시 Map 입니다.
 - Map 은 upstream 과 해당 upstream 의 출력을 변환하고 싶은 출력의 Ouput 으로 초기화하는 struct 입니다.
 - Map 은 자체적으로 Failure 를 생성하지 않으므로, upstream 의 Failure 유형을 그대로 반영하여 통과시킵니다.
*/

/*:
 ### 어떻게 하는지 봅시다.
 ![pattern-ex3-wizard](pattern-ex3-wizard.png)
 - Publisher 와 Subscriber 를 동일하게 유지하기 위해 converter 를 추가했는데요.
 - 보시다시피 gradationPublisher 에 연결되도록 구성되어 있고 closure 가 있는 걸 볼 수 있습니다.
 - 이 closure 는 notification 을 받고 NewGrade 라는 사용자 정보 키를 찾습니다.
 - 만약, 키가 있고 정수라면 이 closure 에서 돌려주고, 이 값이 없거나 정수가 아닌 경우 기본값 0을 사용합니다.
 - 즉, 어떤 경우에도 결과는 정수로 반환되므로 Subscriber 에 연결할 수 있습니다.
 */

//: [Next](@next)
