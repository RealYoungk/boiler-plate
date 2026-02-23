# Flutter Clean Architecture Guide

> 이 문서는 본 프로젝트의 아키텍처를 다른 프로젝트에 적용할 때 참고하는 가이드입니다.

---

## 목차

1. [아키텍처 개요](#1-아키텍처-개요)
2. [레이어 구조와 의존성 규칙](#2-레이어-구조와-의존성-규칙)
3. [Domain Layer](#3-domain-layer)
4. [Data Layer](#4-data-layer)
5. [Presentation Layer](#5-presentation-layer)
6. [Core Layer](#6-core-layer)
7. [의존성 주입 (DI)](#7-의존성-주입-di)
8. [상태 관리 패턴](#8-상태-관리-패턴)
9. [데이터 흐름](#9-데이터-흐름)
10. [새 피쳐 추가 가이드](#10-새-피쳐-추가-가이드)
11. [네이밍 컨벤션](#11-네이밍-컨벤션)
12. [테스트 전략](#12-테스트-전략)
13. [기술 스택](#13-기술-스택)

---

## 1. 아키텍처 개요

3계층 Clean Architecture를 채택합니다. 핵심 원칙은 **의존성 역전(DIP)** 입니다. 안쪽 레이어(Domain)는 바깥 레이어를 모르고, 바깥 레이어만 안쪽을 참조합니다.

```
┌─────────────────────────────────────────────┐
│            Presentation Layer               │
│    (UI, State Management, Widgets, Hooks)   │
├─────────────────────────────────────────────┤
│              Domain Layer                   │
│  (Entities, Repository Interfaces, UseCases)│
├─────────────────────────────────────────────┤
│               Data Layer                    │
│  (Repository Impl, DataSources, DTOs)       │
└─────────────────────────────────────────────┘
```

```mermaid
graph TB
    subgraph Presentation["Presentation Layer"]
        direction LR
        Page["Page<br/>(HookWidget)"]
        Provider["Provider<br/>(ChangeNotifier)"]
        State["State<br/>(Freezed)"]
        View["View + Widgets<br/>(StatelessWidget)"]
    end

    subgraph Domain["Domain Layer"]
        direction LR
        Entity["Entity<br/>(Freezed)"]
        RepoIF["Repository<br/>(abstract interface)"]
        UseCase["UseCase"]
    end

    subgraph Data["Data Layer"]
        direction LR
        RepoImpl["Repository Impl"]
        DS["DataSource"]
        Model["Model / DTO<br/>(Freezed + JSON)"]
    end

    subgraph Core["Core"]
        direction LR
        DI["DI Container<br/>(GetIt)"]
        Ext["Extensions"]
    end

    Page --> Provider
    Provider --> UseCase
    Provider --> RepoIF
    UseCase --> RepoIF
    RepoImpl -.->|implements| RepoIF
    RepoImpl --> DS
    DS --> Model
    DI -.->|registers| RepoImpl
    DI -.->|registers| DS
    DI -.->|registers| UseCase

    style Presentation fill:#e1f5fe,stroke:#0288d1
    style Domain fill:#fff3e0,stroke:#f57c00
    style Data fill:#e8f5e9,stroke:#388e3c
    style Core fill:#f3e5f5,stroke:#7b1fa2
```

---

## 2. 레이어 구조와 의존성 규칙

### 디렉토리 구조

```
lib/
├── core/                          # 공통 인프라
│   ├── di/                        #   DI 컨테이너 설정
│   └── extensions/                #   확장 함수
│
├── domain/                        # 순수 비즈니스 로직
│   ├── {도메인명}/
│   │   ├── entities/              #   불변 엔티티
│   │   ├── repos/                 #   Repository 인터페이스
│   │   └── {도메인명}.dart         #   배럴 파일
│   └── usecases/                  #   교차 도메인 비즈니스 로직
│
├── data/                          # 외부 데이터 접근
│   ├── {소스명}/                   #   데이터소스 그룹 (API별)
│   │   ├── datasources/           #     DataSource 구현
│   │   ├── models/                #     DTO 모델
│   │   └── {소스명}.dart           #     배럴 파일
│   └── repositories/              #   Repository 구현체
│
└── presentation/                  # UI
    ├── hooks/                     #   커스텀 Flutter Hooks
    └── pages/{페이지명}/
        ├── {페이지명}_page.dart    #   진입점 (DI 주입, Hook 설정)
        ├── {페이지명}_provider.dart #   상태 관리
        ├── {페이지명}_state.dart   #   불변 상태 클래스
        ├── {페이지명}_view.dart    #   메인 UI
        └── widgets/               #   세부 위젯
```

### 의존성 규칙

```mermaid
graph LR
    P["Presentation"] -->|참조| D["Domain"]
    DA["Data"] -->|구현| D
    P x--x DA

    style D fill:#fff3e0,stroke:#f57c00
    style P fill:#e1f5fe,stroke:#0288d1
    style DA fill:#e8f5e9,stroke:#388e3c
```

| 규칙 | 설명 |
|------|------|
| Domain은 어디에도 의존하지 않는다 | Flutter/Dart SDK 외 import 금지. 가장 안정적인 레이어. |
| Presentation은 Domain만 참조한다 | Repository 인터페이스와 Entity만 사용. Data 레이어 직접 참조 금지. |
| Data는 Domain을 구현한다 | Repository 인터페이스의 구현체를 제공. Presentation을 몰라야 함. |
| Presentation ↔ Data 직접 참조 금지 | GetIt(DI)을 통해 런타임에 연결. |

---

## 3. Domain Layer

**역할**: 비즈니스 규칙 정의. 프레임워크에 의존하지 않는 순수 Dart 코드.

### 3-1. Entity

불변 도메인 객체. `@freezed`로 `copyWith`, `==`, `toString` 자동 생성.

```dart
// domain/stock/entities/stock.dart
@freezed
abstract class Stock with _$Stock {
  const Stock._();  // 커스텀 getter 사용 시 필요

  const factory Stock({
    @Default('') String code,
    @Default('') String name,
    @Default(0.0) double changeRate,
    @Default([]) List<int> priceHistory,
  }) = _Stock;

  // 파생 속성은 getter로 정의
  int get currentPrice => priceHistory.isEmpty ? 0 : priceHistory.last;
}
```

**규칙:**
- 모든 필드에 `@Default` 값을 지정하여 `const factory` 사용
- JSON 직렬화 코드 **없음** (Domain은 전송 형식을 모름)
- 파생 속성은 `getter`로 정의 (`const Stock._()` 필요)

### 3-2. Repository Interface

데이터 접근 계약. `abstract interface class`로 선언.

```dart
// domain/stock/repos/stock_repository.dart
abstract interface class StockRepository {
  Future<Stock> getStock(String code);
  Stream<Stock> stockTickStream(String code);
  Future<void> connect();
  void disconnect();
}
```

**규칙:**
- 반환 타입은 항상 **Domain Entity** (DTO 반환 금지)
- `abstract interface class` 키워드 사용 (Dart 3 인터페이스)
- 구현은 Data Layer에 위임

### 3-3. UseCase

2개 이상의 도메인에 걸친 비즈니스 로직을 캡슐화.

```dart
// domain/usecases/toggle_watchlist_use_case.dart
class ToggleWatchlistUseCase {
  const ToggleWatchlistUseCase(this._repository);

  final WatchlistRepository _repository;

  Future<void> call({
    required WatchlistItem item,
    required bool isInWatchlist,
  }) async {
    if (isInWatchlist) {
      await _repository.removeItem(item.stockCode);
    } else {
      await _repository.addItem(item);
    }
  }
}
```

**규칙:**
- `call()` 메서드로 실행 (함수처럼 호출 가능: `useCase(...)`)
- 생성자에서 Repository 인터페이스를 주입받음
- 단일 도메인 내 단순 CRUD는 UseCase 없이 Repository 직접 사용 가능

### 3-4. 배럴 파일

도메인별 공개 API를 하나의 import로 제공.

```dart
// domain/watchlist/watchlist.dart
export 'entities/alert_type.dart';
export 'entities/watchlist_item.dart';
export 'repos/watchlist_repository.dart';
```

---

## 4. Data Layer

**역할**: 외부 데이터 소스(API, DB) 접근 및 Domain Entity 변환.

### 4-1. Model (DTO)

외부 데이터 형식과 매핑되는 전송 객체.

```dart
// data/ezar/models/stock_model.dart
@freezed
abstract class StockModel with _$StockModel {
  const factory StockModel({
    @Default('') String code,
    @Default('') String name,
    @Default(0.0) double changeRate,
    @Default([]) List<int> priceHistory,
  }) = _StockModel;

  factory StockModel.fromJson(Map<String, dynamic> json) =>
      _$StockModelFromJson(json);
}
```

**Entity vs Model 차이:**

| 구분 | Entity (Domain) | Model (Data) |
|------|----------------|--------------|
| 위치 | `domain/{도메인}/entities/` | `data/{소스}/models/` |
| JSON 직렬화 | 없음 | `fromJson` / `toJson` |
| Hive 어노테이션 | 없음 | `@HiveType` (로컬 DB용) |
| 비즈니스 로직 | getter로 파생 속성 | 없음 (순수 데이터) |

### 4-2. DataSource

실제 데이터 소스에 접근하는 클래스.

```dart
// data/ezar/datasources/stock_data_source_ezar.dart
class StockDataSourceEzar {
  Future<StockModel> getStock(String code) {
    // HTTP API 호출 → StockModel 반환
  }
}
```

```dart
// data/local/datasources/watchlist_data_source_local.dart
class WatchlistDataSourceLocal {
  final Box<WatchlistItemModel> _box;

  static Future<WatchlistDataSourceLocal> init() async {
    final box = await Hive.openBox<WatchlistItemModel>(boxName);
    return WatchlistDataSourceLocal(box);
  }

  List<WatchlistItemModel> getAll() => _box.values.toList();
  Future<void> add(WatchlistItemModel item) => _box.put(item.stockCode, item);
}
```

**규칙:**
- DataSource는 **Model(DTO)** 을 반환 (Entity 반환 금지)
- 데이터소스 종류별 디렉토리 분리 (`ezar/`, `local/`, `firebase/` 등)
- 비동기 초기화가 필요하면 `static Future<T> init()` 팩토리 패턴 사용

### 4-3. Repository Implementation

Domain의 Repository 인터페이스를 구현. **Model → Entity 변환 책임**.

```dart
// data/repositories/stock_repository_impl.dart
class StockRepositoryImpl implements StockRepository {
  final StockDataSourceEzar _stockDataSource;
  final StockTickDataSourceEzar _tickDataSource;

  StockRepositoryImpl(this._stockDataSource, this._tickDataSource);

  @override
  Future<Stock> getStock(String code) async {
    final model = await _stockDataSource.getStock(code);
    return Stock(                   // ← Model → Entity 변환
      code: model.code,
      name: model.name,
      changeRate: model.changeRate,
      priceHistory: model.priceHistory,
    );
  }

  @override
  Stream<Stock> stockTickStream(String code) {
    return _tickDataSource.messageStream
        .where((tick) => tick.stockCode == code)
        .map((tick) => Stock(       // ← Model → Entity 변환
          code: tick.stockCode,
          changeRate: tick.changeRate,
          priceHistory: [tick.currentPrice],
        ));
  }
}
```

**규칙:**
- `implements`로 Domain 인터페이스 구현 (extends 아님)
- DataSource를 생성자 주입받음
- 여기서 DTO ↔ Entity 변환 수행
- Stream 변환도 Repository에서 처리

---

## 5. Presentation Layer

**역할**: UI 렌더링, 사용자 인터랙션 처리, 상태 관리.

### 5-1. Page (진입점)

`HookWidget`으로 DI 주입과 Provider 생성을 담당.

```dart
// presentation/pages/stock/stock_page.dart
class StockPage extends HookWidget {
  const StockPage({super.key, required this.stockCode});
  final String stockCode;

  @override
  Widget build(BuildContext context) {
    // 1. Hook으로 컨트롤러/리소스 초기화
    final tabScrollController = useTabScrollController(tabViewCount: 5);

    // 2. ChangeNotifierProvider로 Provider 생성 + DI 주입
    return ChangeNotifierProvider(
      create: (_) => StockProvider(
        stockRepository: getIt<StockRepository>(),        // ← 인터페이스로 주입
        watchlistRepository: getIt<WatchlistRepository>(), // ← 인터페이스로 주입
        toggleWatchlistUseCase: getIt<ToggleWatchlistUseCase>(),
        checkTargetPriceUseCase: getIt<CheckTargetPriceUseCase>(),
      )..onInitialized(stockCode),

      // 3. View에 위임
      child: HookBuilder(
        builder: (context) {
          // 4. Side effect Hook (알림 등)
          useListenableEffect(
            context.read<StockProvider>(),
            () => context.read<StockProvider>().state.triggeredAlert,
            (alert) => _showAlertSnackBar(context, alert),
          );
          return StockView(tabScrollController: tabScrollController);
        },
      ),
    );
  }
}
```

**Page의 책임:**
1. GetIt에서 의존성을 꺼내 Provider에 주입
2. Hook으로 리소스(컨트롤러 등) 초기화
3. Side effect(SnackBar, Navigation 등) 연결
4. View 위젯에 렌더링 위임

### 5-2. Provider (상태 관리)

`ChangeNotifier`를 상속하여 상태 변경을 통지.

```dart
// presentation/pages/stock/stock_provider.dart
class StockProvider extends ChangeNotifier {
  StockProvider({
    required StockRepository stockRepository,
    required WatchlistRepository watchlistRepository,
    required ToggleWatchlistUseCase toggleWatchlistUseCase,
    required CheckTargetPriceUseCase checkTargetPriceUseCase,
  }) : _stockRepository = stockRepository,
       _watchlistRepository = watchlistRepository,
       _toggleWatchlistUseCase = toggleWatchlistUseCase,
       _checkTargetPriceUseCase = checkTargetPriceUseCase;

  StockState _state = const StockState();
  StockState get state => _state;

  Future<void> onInitialized(String code) async {
    await _fetchStock(code);
    if (_state.hasError) return;
    await _fetchWatchlist();
    await _subscribeTick(code);
  }

  Future<void> _fetchStock(String code) async {
    try {
      _state = _state.copyWith(
        stock: await _stockRepository.getStock(code),
        isLoading: false,
      );
    } catch (_) {
      _state = _state.copyWith(stock: const Stock(), isLoading: false);
      notifyListeners();
      rethrow;   // ← 글로벌 에러 핸들러로 전파
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    _tickSubscription?.cancel();
    _stockRepository.disconnect();
    super.dispose();
  }
}
```

**Provider의 책임:**
- 불변 State를 `copyWith`로 갱신 후 `notifyListeners()` 호출
- Repository / UseCase를 호출하여 데이터 fetch
- Stream 구독 및 생명주기 관리 (dispose)
- 에러 발생 시 `rethrow` / `Error.throwWithStackTrace`로 글로벌 로깅 지원

### 5-3. State (불변 상태)

`@freezed`로 불변 상태 객체를 정의. 파생 속성은 `getter`로 표현.

```dart
// presentation/pages/stock/stock_state.dart
@freezed
abstract class StockState with _$StockState {
  const StockState._();

  const factory StockState({
    @Default(Stock()) Stock stock,
    @Default(true) bool isLoading,
    @Default([]) List<WatchlistItem> watchlist,
    ({WatchlistItem item, bool isUpper})? triggeredAlert,
  }) = _StockState;

  // 파생 상태: 별도 필드 없이 기존 상태에서 계산
  bool get hasError => !isLoading && stock.code.isEmpty;
  bool get isInWatchlist =>
      watchlist.any((item) => item.stockCode == stock.code);
}
```

**State 설계 원칙:**
- 모든 필드에 `@Default` 값 → `const StockState()` 로 초기화 가능
- UI가 직접 판단할 로직은 `getter`로 (hasError, isInWatchlist 등)
- State 자체에 비즈니스 로직 금지 (순수 데이터 + 파생 속성만)

### 5-4. View + Widgets (UI)

`StatelessWidget` + `Selector`로 선택적 리빌드.

```dart
// presentation/pages/stock/stock_view.dart
class StockView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Selector<StockProvider, ({bool hasError, bool isLoading})>(
      selector: (_, p) =>
          (hasError: p.state.hasError, isLoading: p.state.isLoading),
      builder: (context, state, _) {
        if (state.hasError) return /* 에러 UI */;
        if (state.isLoading) return /* 로딩 UI */;
        return Scaffold(/* 메인 UI */);
      },
    );
  }
}
```

**UI 규칙:**
- `Selector`로 필요한 상태만 구독 → 불필요한 rebuild 방지
- 섹션별 위젯 파일 분리 (`widgets/` 디렉토리)
- View는 `StatelessWidget` (상태는 Provider가 관리)

### 5-5. Custom Hooks

재사용 가능한 상태 로직을 Hook으로 추출.

```dart
// 범용 Listenable 변경 감지
void useListenableEffect<T>(
  Listenable listenable,
  T Function() selector,
  void Function(T value) effect,
);

// 탭-스크롤 동기화 컨트롤러
TabScrollController useTabScrollController({required int tabViewCount});
```

---

## 6. Core Layer

**역할**: 레이어 전체에서 공유하는 인프라 코드.

```dart
// core/di/injection.dart  → DI 컨테이너 설정
// core/extensions/         → 유틸리티 확장 함수
```

**규칙:**
- Core는 어떤 레이어든 import 가능
- 비즈니스 로직 금지 (순수 유틸리티, 인프라만)
- 향후 `core/error/`, `core/network/`, `core/constants/` 등 추가 가능

---

## 7. 의존성 주입 (DI)

GetIt 서비스 로케이터로 런타임에 의존성을 연결합니다.

```dart
// core/di/injection.dart
final getIt = GetIt.instance;

Future<void> initDependencies() async {
  // 1. DataSource (Singleton) — 앱 생명주기 동안 유지
  getIt.registerSingleton(await WatchlistDataSourceLocal.init());
  getIt.registerSingleton(StockDataSourceEzar());
  getIt.registerSingleton(StockTickDataSourceEzar());

  // 2. Repository (Singleton, 인터페이스 타입으로 등록)
  getIt.registerSingleton<WatchlistRepository>(        // ← 인터페이스!
    WatchlistRepositoryImpl(getIt<WatchlistDataSourceLocal>()),
  );
  getIt.registerSingleton<StockRepository>(            // ← 인터페이스!
    StockRepositoryImpl(
      getIt<StockDataSourceEzar>(),
      getIt<StockTickDataSourceEzar>(),
    ),
  );

  // 3. UseCase (Factory) — 매번 새 인스턴스
  getIt.registerFactory(
    () => ToggleWatchlistUseCase(getIt<WatchlistRepository>()),
  );
  getIt.registerFactory(
    () => CheckTargetPriceUseCase(getIt<WatchlistRepository>()),
  );
}
```

```mermaid
graph LR
    subgraph GetIt["GetIt Container"]
        direction TB
        S["Singleton"]
        F["Factory"]
    end

    S --> DS["DataSource"]
    S --> R["Repository<br/>(인터페이스 타입 등록)"]
    F --> UC["UseCase"]

    R -.->|주입| DS
    UC -.->|주입| R
```

**등록 규칙:**

| 등록 방식 | 대상 | 이유 |
|-----------|------|------|
| `registerSingleton` | DataSource | DB 연결, API 클라이언트는 공유 |
| `registerSingleton<Interface>` | Repository | **인터페이스 타입으로 등록** (DIP 핵심) |
| `registerFactory` | UseCase | 상태 없는 로직, 매번 새로 생성해도 무방 |

---

## 8. 상태 관리 패턴

```mermaid
sequenceDiagram
    participant U as User Action
    participant P as Provider
    participant S as State (Freezed)
    participant V as View (Selector)

    U->>P: onFavoriteToggled()
    P->>P: _state = _state.copyWith(...)
    P->>V: notifyListeners()
    V->>V: Selector가 변경된 부분만 rebuild
```

### 상태 변경 흐름

```
1. 사용자 액션 → Provider 메서드 호출
2. Provider가 Repository/UseCase 호출
3. 결과를 state.copyWith(...)로 새 State 생성
4. notifyListeners()로 UI 갱신 통지
5. Selector가 관심 있는 상태만 비교 → 변경 시에만 rebuild
```

### 에러 처리 패턴

```dart
// Provider 내부
try {
  _state = _state.copyWith(stock: await _stockRepository.getStock(code));
} catch (_) {
  _state = _state.copyWith(stock: const Stock(), isLoading: false);
  notifyListeners();
  rethrow;           // ← runZonedGuarded로 전파 → 글로벌 로깅
}
```

```dart
// main.dart
runZonedGuarded(() async {
  // ...앱 실행
}, (error, stackTrace) {
  // Crashlytics 등 글로벌 에러 리포팅
});
```

### 실시간 스트림 패턴

```dart
// Provider 내부 — 스트림 구독 + 자동 재연결
Future<void> _subscribeTick(String code) async {
  await _stockRepository.connect();
  _tickSubscription = _stockRepository
      .stockTickStream(code)
      .listen(
        (tick) async { /* 상태 갱신 */ },
        onError: (error, stackTrace) {
          _tickSubscription?.cancel();
          _stockRepository.disconnect();
          _reconnectTick(code);                    // ← 5초 후 재연결
          Error.throwWithStackTrace(error, stackTrace);
        },
      );
}
```

---

## 9. 데이터 흐름

### 초기 로딩

```mermaid
sequenceDiagram
    participant Page as StockPage
    participant Prov as StockProvider
    participant Repo as StockRepository
    participant DS as DataSource

    Page->>Prov: onInitialized(code)
    Prov->>Repo: getStock(code)
    Repo->>DS: getStock(code)
    DS-->>Repo: StockModel (DTO)
    Repo-->>Prov: Stock (Entity)
    Prov->>Prov: state.copyWith(stock, isLoading: false)
    Prov-->>Page: notifyListeners()
```

### 실시간 스트림

```mermaid
sequenceDiagram
    participant DS as DataSource<br/>(Timer + BehaviorSubject)
    participant Repo as StockRepository
    participant Prov as StockProvider
    participant UI as View (Selector)

    loop 5초마다
        DS->>Repo: StockTickMessage (DTO)
        Repo->>Prov: Stock (Entity)
        Prov->>Prov: state.copyWith(stock: updated)
        Prov->>Prov: checkTargetPriceUseCase(...)
        Prov-->>UI: notifyListeners()
        UI->>UI: Selector rebuild
    end
```

### 변환 흐름 요약

```
[외부 API / DB]
       ↓ JSON / Raw
   DataSource
       ↓ Model (DTO)
   Repository Impl
       ↓ Entity (Domain)
   Provider
       ↓ State (Freezed)
   View (Selector)
       ↓ UI
   [사용자 화면]
```

---

## 10. 새 피쳐 추가 가이드

예시: "뉴스(News)" 피쳐를 추가한다고 가정합니다.

### Step 1: Domain Layer

```
domain/
└── news/
    ├── entities/
    │   └── news_article.dart        ← @freezed Entity
    ├── repos/
    │   └── news_repository.dart     ← abstract interface class
    └── news.dart                    ← 배럴 파일
```

```dart
// domain/news/entities/news_article.dart
@freezed
abstract class NewsArticle with _$NewsArticle {
  const factory NewsArticle({
    @Default('') String id,
    @Default('') String title,
    @Default('') String content,
    @Default(ConstDateTime(0)) DateTime publishedAt,
  }) = _NewsArticle;
}

// domain/news/repos/news_repository.dart
abstract interface class NewsRepository {
  Future<List<NewsArticle>> getNews(String stockCode);
}
```

### Step 2: Data Layer

```
data/
├── {api_name}/
│   ├── datasources/
│   │   └── news_data_source_{api_name}.dart
│   └── models/
│       └── news_article_model.dart  ← @freezed + fromJson
└── repositories/
    └── news_repository_impl.dart
```

```dart
// data/repositories/news_repository_impl.dart
class NewsRepositoryImpl implements NewsRepository {
  final NewsDataSourceXxx _dataSource;
  NewsRepositoryImpl(this._dataSource);

  @override
  Future<List<NewsArticle>> getNews(String stockCode) async {
    final models = await _dataSource.getNews(stockCode);
    return models.map((m) => NewsArticle(
      id: m.id,
      title: m.title,
      content: m.content,
      publishedAt: m.publishedAt,
    )).toList();
  }
}
```

### Step 3: DI 등록

```dart
// core/di/injection.dart 에 추가
getIt.registerSingleton(NewsDataSourceXxx());
getIt.registerSingleton<NewsRepository>(
  NewsRepositoryImpl(getIt<NewsDataSourceXxx>()),
);
```

### Step 4: Presentation Layer

```
presentation/pages/news/
├── news_page.dart          ← HookWidget, DI 주입
├── news_provider.dart      ← ChangeNotifier
├── news_state.dart         ← @freezed State
├── news_view.dart          ← StatelessWidget + Selector
└── widgets/
    └── news_card_view.dart
```

### Step 5: 코드 생성

```bash
dart run build_runner build --delete-conflicting-outputs
```

### Step 6: 테스트 작성

```
test/
├── domain/news/entities/
│   └── news_article_test.dart
├── data/repositories/
│   └── news_repository_impl_test.dart
└── presentation/pages/news/
    └── news_provider_test.dart
```

---

## 11. 네이밍 컨벤션

### 파일명

| 대상 | 패턴 | 예시 |
|------|------|------|
| Entity | `{이름}.dart` | `stock.dart` |
| Repository 인터페이스 | `{이름}_repository.dart` | `stock_repository.dart` |
| Repository 구현체 | `{이름}_repository_impl.dart` | `stock_repository_impl.dart` |
| DataSource | `{이름}_data_source_{소스명}.dart` | `stock_data_source_ezar.dart` |
| Model (DTO) | `{이름}_model.dart` | `stock_model.dart` |
| UseCase | `{동사}_{대상}_use_case.dart` | `toggle_watchlist_use_case.dart` |
| Page | `{페이지명}_page.dart` | `stock_page.dart` |
| Provider | `{페이지명}_provider.dart` | `stock_provider.dart` |
| State | `{페이지명}_state.dart` | `stock_state.dart` |
| View | `{페이지명}_view.dart` | `stock_view.dart` |
| Widget | `{페이지명}_{섹션}_view.dart` | `stock_price_view.dart` |
| Hook | `use_{기능명}.dart` | `use_tab_scroll_controller.dart` |
| 배럴 파일 | `{도메인/소스명}.dart` | `stock.dart`, `ezar.dart` |
| 테스트 | `{원본명}_test.dart` | `stock_repository_impl_test.dart` |

### 클래스명

| 대상 | 패턴 | 예시 |
|------|------|------|
| Entity | `PascalCase` | `Stock`, `WatchlistItem` |
| Repository 인터페이스 | `{이름}Repository` | `StockRepository` |
| Repository 구현체 | `{이름}RepositoryImpl` | `StockRepositoryImpl` |
| DataSource | `{이름}DataSource{소스}` | `StockDataSourceEzar` |
| Model | `{이름}Model` | `StockModel` |
| UseCase | `{동사}{대상}UseCase` | `ToggleWatchlistUseCase` |
| Provider | `{페이지}Provider` | `StockProvider` |
| State | `{페이지}State` | `StockState` |

### DataSource 그룹명

`data/` 하위 디렉토리는 데이터 소스 종류별로 분리합니다.

| 디렉토리 | 용도 | 예시 |
|----------|------|------|
| `local/` | 로컬 DB (Hive, SQLite) | `watchlist_data_source_local.dart` |
| `{api명}/` | 외부 API | `stock_data_source_ezar.dart` |
| `firebase/` | Firebase 서비스 | `auth_data_source_firebase.dart` |

---

## 12. 테스트 전략

### 디렉토리 구조

`test/` 디렉토리는 `lib/`의 구조를 미러링합니다.

```
test/
├── core/extensions/
│   └── number_format_extension_test.dart
├── domain/
│   ├── stock/entities/
│   │   └── stock_test.dart
│   ├── watchlist/entities/
│   │   ├── watchlist_item_test.dart
│   │   └── alert_type_test.dart
│   └── usecases/
│       ├── toggle_watchlist_use_case_test.dart
│       └── check_target_price_use_case_test.dart
├── data/
│   ├── ezar/
│   │   ├── datasources/
│   │   │   ├── stock_data_source_ezar_test.dart
│   │   │   └── stock_tick_data_source_ezar_test.dart
│   │   └── models/
│   │       ├── stock_model_test.dart
│   │       └── stock_tick_message_test.dart
│   ├── local/
│   │   ├── datasources/
│   │   │   └── watchlist_data_source_local_test.dart
│   │   └── models/
│   │       └── watchlist_item_model_test.dart
│   └── repositories/
│       ├── stock_repository_impl_test.dart
│       └── watchlist_repository_impl_test.dart
└── presentation/
    ├── hooks/
    │   └── use_listenable_effect_test.dart
    └── pages/stock/
        ├── stock_provider_test.dart
        └── stock_view_test.dart
```

### 레이어별 테스트 범위

| 레이어 | 테스트 대상 | 모킹 대상 | 도구 |
|--------|-----------|----------|------|
| **Domain Entity** | 생성, 기본값, copyWith, 파생 속성 | 없음 | flutter_test |
| **Domain UseCase** | 비즈니스 로직 분기 | Repository | mocktail |
| **Data Model** | fromJson/toJson, 기본값 | 없음 | flutter_test |
| **Data DataSource** | API 호출, DB 접근 로직 | Hive Box 등 | mocktail, fake_async |
| **Data Repository** | DTO → Entity 변환, 스트림 변환 | DataSource | mocktail |
| **Presentation Provider** | 상태 전이, 에러 처리, 생명주기 | Repository, UseCase | mocktail, fake_async |
| **Presentation View** | 위젯 렌더링, 상태별 UI 분기 | Provider | flutter_test |
| **Hooks** | 콜백 호출 조건, 리소스 정리 | Listenable | flutter_test |

### 테스트 패턴

```dart
// mocktail로 모킹
class MockStockRepository extends Mock implements StockRepository {}

void main() {
  late MockStockRepository mockRepo;
  late StockProvider provider;

  setUp(() {
    mockRepo = MockStockRepository();
    provider = StockProvider(stockRepository: mockRepo, ...);
  });

  test('fetchStock 성공 시 isLoading이 false가 된다', () async {
    when(() => mockRepo.getStock(any())).thenAnswer(
      (_) async => const Stock(code: '005930', name: '삼성전자'),
    );

    await provider.onInitialized('005930');

    expect(provider.state.isLoading, false);
    expect(provider.state.stock.code, '005930');
  });
}
```

---

## 13. 기술 스택

| 카테고리 | 라이브러리 | 역할 |
|---------|-----------|------|
| **상태 관리** | provider | ChangeNotifier 기반 상태 구독 |
| **불변 객체** | freezed / freezed_annotation | Entity, State, DTO 코드 생성 |
| **DI** | get_it | 서비스 로케이터 패턴 |
| **JSON** | json_serializable / json_annotation | DTO fromJson/toJson 코드 생성 |
| **로컬 DB** | hive_ce / hive_ce_flutter / hive_ce_generator | 경량 로컬 저장소 |
| **리액티브** | rxdart | BehaviorSubject (실시간 스트림) |
| **UI Hook** | flutter_hooks | 재사용 가능한 상태 로직 |
| **차트** | fl_chart | 가격 그래프 |
| **테스트** | mocktail, fake_async | 모킹, 비동기 테스트 |
| **코드 생성** | build_runner | freezed, json_serializable, hive 통합 |

---

## 부록: 한눈에 보는 레이어 규칙 체크리스트

### Domain Layer

- [ ] Flutter/외부 패키지 import 없음 (freezed_annotation, const_date_time 제외)
- [ ] Entity는 `@freezed` + `@Default` + `const factory`
- [ ] Repository는 `abstract interface class`
- [ ] 반환 타입은 항상 Domain Entity
- [ ] UseCase는 `call()` 메서드로 실행

### Data Layer

- [ ] DataSource는 Model(DTO)을 반환
- [ ] Repository Impl은 `implements`로 Domain 인터페이스 구현
- [ ] DTO → Entity 변환은 Repository Impl에서 수행
- [ ] 데이터소스 종류별 디렉토리 분리

### Presentation Layer

- [ ] Page는 HookWidget, DI 주입 담당
- [ ] Provider는 ChangeNotifier, State를 copyWith로 갱신
- [ ] State는 `@freezed` 불변 객체
- [ ] View는 StatelessWidget + Selector로 선택적 리빌드
- [ ] Provider에서 에러 발생 시 `rethrow` 사용

### DI

- [ ] DataSource, Repository → Singleton
- [ ] Repository는 **인터페이스 타입**으로 등록
- [ ] UseCase → Factory
