# 10th Seminar
Content Hugging Priority & Compression Resistance Priority
> [2020.06.21]

<br/>

# Contents
- [0 단계 | Intrinsic Size?](#Intrinsic-Size)
- [1 단계 | What is Content Hugging Priority?](#Content-Hugging-Priority)
- [2 단계 | What is Compression Resistance Priority?](#Compression-Resistance-Priority)

<br/>

* Autolayout의 priorty란, 제약 간의 우선순위를 주는 것입니다.

* 서로 충돌하는 상황에서 warning 경고가 뜨기도 하는데요, 이러한 상황에서 우선순위를 설정할 수 있는 방법이 있습니다.

<p align="center">
<img width="251" alt="스크린샷 2020-06-21 오후 8 11 45" src="https://user-images.githubusercontent.com/44978839/85223172-b26ef200-b3fb-11ea-88c9-a42e00bf05bb.png">
<p/>

* 우선순위를 매기는 숫자는 1부터 1000까지 임의로 줄 수 있는데, 당연한 얘기일 수도 있지만 자가 높을수록 우선 순위를 갖게 됩니다.

* 모든 constaints 가 constant, multiplier 와 함께 동일하게 갖고 있는 속성입니다.

---

* 이 Priority 말고도 hugging priority, compression resistance priority 라는 개념이 있습니다.

<p align="center">
<img width=600 src="https://user-images.githubusercontent.com/44978839/87055905-e04b9780-c23f-11ea-8b17-f86baea28c86.png">
<p/>

* 각각 vertical 값과 horizontal 값을 설정할 수 있습니다.

<p align="center">
<img width="253" alt="스크린샷 2020-06-21 오후 8 10 05" src="https://user-images.githubusercontent.com/44978839/85223171-b00c9800-b3fb-11ea-94cc-8115c5c6aa5c.png">
<p/>

> 참고 | [개발과 투자](https://m.blog.naver.com/PostView.nhn?blogId=jdub7138&logNo=220963551062&proxyReferer=https:%2F%2Fwww.google.com%2F)

* 사진을 보시면, priority 각각의 세로, 가로 값 말고도 intrinsic size 라는 속성 값을 보실 수가 있는데요, 이 개념이 아주 중요하여 먼저 공부하고 가겠습니다.

## Intrinsic Size

## Content Hugging Priority
* Hugging Priority는 "Hugging" 이라는 이름에서 알 수 있듯이, 스스로를 꽉 감싸 안고서 <커지기를 거부한다>는 뜻입니다.

* Hugging Priority 가 높으면 해당 constraint의 높이나 폭이 커지는 것을 우선적으로 저항할 수 있습니다.

* 아이폰 se에서 아이폰 x로 큰 화면으로 빌드했을 때 다른 것들이 다 커지고 배치된 다음에 거기에 맞춰 크기를 조정하게 됩니다.

<p align="center">
<img width="413" alt="스크린샷 2020-06-21 오후 8 21 14" src="https://user-images.githubusercontent.com/44978839/85223269-c49d6000-b3fc-11ea-9e16-5f32d79abe55.png">
<p/>

## Compression Resistance Priority
* compression 은 압축이고, resistance 는 저항이라는 뜻을 가지고 있다시피 **작아지는 것을 거부**하는 우선순위라고 생각하시면 됩니다.

* Compression Resistance Priority 가 높을수록 해당 constraint 의 높이나 폭이 작아지는 것을 후순위로 둘 수 있습니다.
즉, 다른 아이템들이 최대한 축소될 수 있을 때까지 축소되고 나서 영향을 받습니다.

<p align="center">
<img width="440" alt="스크린샷 2020-06-21 오후 8 26 43" src="https://user-images.githubusercontent.com/44978839/85223356-88b6ca80-b3fd-11ea-8378-b0557a8c12b4.png">
<p/>
<p align="center">
<img width="431" alt="스크린샷 2020-06-21 오후 8 27 43" src="https://user-images.githubusercontent.com/44978839/85223373-aab04d00-b3fd-11ea-9c71-90f48017858c.png">
<p/>
