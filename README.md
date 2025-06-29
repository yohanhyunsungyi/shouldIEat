# shouldIEat


## **Screen Recording**
https://github.com/yohanhyunsungyi/shouldIEat/raw/refs/heads/main/ScreenRecording_06-29-2025%2014-43-26_1.MP4

## **주요 기능별 기술 요구사항**

### **1\) 소셜 로그인**

* **기능**  
  * 소셜 로그인 \- 애플, Google, Facebook  
* **Requirements**  
  * 로그인 토큰 관리 (Firebase)
* **Demo 구현 여부**
  * 제외

---

### **2\) 알러지 프로필 관리**

* **기능**  
  * 사용자별 알러지 성분(예: 땅콩, 해산물 등) 선택/저장  
  * 편집/추가/삭제 지원  
* **Requirements**  
  * 사용자 프로필 로컬 DB 저장 (CoreData)  
  * 알러지 카테고리 데이터(명칭/번역/대표 이미지 등) 테이블 설계  
  * 알러지 성분 코드 통일 (추후 API, 번역 등에 활용)
* **Demo 구현 여부**
  * 포함
    * 사용자별 알러지 성분 선택/저장 
    * 알러지 카테고리 데이터(명칭/번역/대표 이미지 등) 테이블
    * 알러지 성분 코드 통일
 
  * 제외
    * 사용자 프로필 저장 기능 
    * 사용자별 알러지 성분 편집/추가/삭제 
---

### **3-1 ) 메뉴판 → 음식 이름 → 위험 성분 예측**

* **기능**  
  * 메뉴판 사진 전체에서 텍스트 OCR로 추출  
  * 메뉴명 자동 분석 → 위험 메뉴 자동 하이라이트/표시  
* **Requirements**  
  * Apple Vision OCR 사용   
  * 결과 내 각 메뉴명 → 음식 이름 검색 플로우 연결  
  * 위험 메뉴(알러지 포함) bounding box 시각화  
* 다국어 OCR 지원 (한국어/영어/일본어/중국어 등)
* **Demo 구현 여부**
  * 제외
---

### **3 \- 2\) 음식 사진 인식 → 음식 인식 기능 → 위험 성분 예측**

* 사진에서 음식 인식 (딥러닝 이미지 분류)  
  * 인식된 음식 → 성분 추출 및 위험 알러지 탐지  
* **Requirements**  
  * Apple Vision \+ CoreML 모델 적용(Food101 등)  
  * 음식 인식 실패시 fallback: 음식 이름 입력?  
  * 인식 결과 신뢰도 threshold 적용 및 UI 안내  
  * 인식된 음식명(다국어) → 성분 탐색 플로우 재활용
* **Demo 구현 여부**
  * 포함
    * 사진에서 음식 인식. Apple Vision \+ CoreML 모델 적용 인식률이 낮아, OpenAPI 활용 **(Open API 활용)**
    * 알러지 카테고리 데이터(명칭/번역/대표 이미지 등) 테이블
    * 알러지 성분 코드 통일
    * 인식된 음식명(다국어) → 성분 탐색 플로우 재활용
 
  * 제외
    * Apple Vision \+ CoreML 모델 적용(Food101 등)  
    * 음식 인식 실패 플로우
    * 인식 결과 신뢰도 threshold 적용 및 UI 안내
---

**4\) 위험 성분 예측**

* **기능**  
  * 3 에서 인식한 음식에 포함된 알러지 성분 자동 탐색  
* **Requirements**  
  * 음식-성분 매핑 DB 구축   
  * 로컬 DB \+ LLM 연동 검색  
  * 입력값 자동 언어 감지 및 번역 (Apple Translate, NLLanguageRecognizer)  
  * 결과에서 사용자 알러지와 일치하는 위험성분 매칭 로직  
  * "might contain" 성분 별도 표기
* **Demo 구현 여부**
  * 포함
    * 음식-성분 매핑 DB 구축 
    * 로컬 DB \+ LLM 연동 검색 **(Open API 활용)**
    * 입력값 자동 언어 감지 및 번역 (Apple Translate, NLLanguageRecognizer)  
    * 결과에서 사용자 알러지와 일치하는 위험성분 매칭 로직
    * "might contain" 성분 별도 표기
 
  * 제외
    
---

### **5\) 다국어 질문글 생성 및 O/X 응답 시스템**

* **기능**  
  * "이 음식에 \[알러지\]가 들어있나요?" 등 질문 자동 생성  
  * 현지 언어로 번역(다국어 지원)  
  * 직원이 O/X(Yes/No) 카드로 직접 응답 → 사용자 위험 알림에 반영  
* **Requirements**  
  * 템플릿 기반 질문 생성(알러지 종류, 음식명 변수화)  
  * Apple Translate API 또는 자체 번역 테이블 구축  
  * 현지 언어별 폰트/길이 이슈 처리  
  * 직원 입력 화면(대형 버튼, 터치 지원, 별도 UX 설계)  
  * 응답 결과 실시간 반영(알림/경고/확인 UI)
* **Demo 구현 여부**
  * 포함
    * 템플릿 기반 질문 생성(알러지 종류, 음식명 변수화)
    * Apple Translate API 또는 자체 번역 테이블 구축 **(APPLE API 활용, 언어팩 다운로드 후 오프라인 사용 가능)**
    * 응답 결과 실시간 반영(알림/경고/확인 UI)
 
  * 제외
    * 현지 언어별 폰트/길이 이슈 처리 
    * 직원 입력 화면(대형 버튼, 터치 지원, 별도 UX 설계)
---

### **7\) 오프라인 모드 지원**

* **기능**  
  * 네트워크 연결 없이도 알러지 탐색, 음식 인식, 번역 일부 기능 제공  
* **Requirements**  
  * 주요 데이터/모델 로컬 캐싱(**알러지 DB 중요**, ML 모델)  
  * 오프라인 번역은 미리 준비된 언어만 제한 지원
* **Demo 구현 여부**
  * 제외
    * Apple Vision \+ CoreML 모델 적용 인식률이 낮아, OpenAPI 활용 **(Open API 활용)**

---

## **2\. 기술 스택 및 설계**

음식 인식, 문자인식, 번역 모델 전부 앱 내부에 저장 가능 \- 오프라인 지원 가능 (과금x)  
음식 이름과 알러전의 맵핑 테이블 \- 현재 LLM에 의존하고있음. 오프라인 지원을 위해서는 DB필요

* **iOS Native:** Swift, SwiftUI, UIKit (UI/UX)  
* **ML/OCR:** Vision, Core ML (Food101 등)   
* **번역:** Apple Translate (iOS 15+), NLLanguageRecognizer  
* **로컬/클라우드 저장:** CoreData/UserDefaults

UserData Model  - isFirstLaunch: Bool  
\- isProfileSetup: Bool?  
\- usersAllergens: \[UsersAllergen\]

UsersAllergen Model  
\- allergen: Allergen  
\- severityLevel: allergenLevel (Severe, Moderate, Mild)

Allergen Model  
\- id: Int  
\- name: String  
\- category: Category

AllergyCard Model  - foodName: String  
\- date: Date  
\- location: String  
\- containAllergens: \[containAllergen\]

containAllergen Model  
\- allergen: Allergen  
\- isContain: Bool

https://huggingface.co/dwililiya/food101-model-classification
