```mermaid
---
title: Noch Experimentellere Dokumentation
---
classDiagram
class NewsProvider
NewsProvider : +graphQLClient$ GraphQLClient
NewsProvider o-- GraphQLClient
NewsProvider : +spaceID$ String
NewsProvider : +contentDeliveryApiAccessToken$ String
NewsProvider : +contentPreviewApiAccessToken$ String
NewsProvider : +newsBoxName$ String
NewsProvider : +latestViewedNewsKey$ String
NewsProvider : +latestViewedNewsDefaultValue$ DateTime
NewsProvider : +newsCollectionCache$ List~dynamic~
NewsProvider : +detailedNewsCache$ HashMap~dynamic, dynamic~
NewsProvider o-- HashMap~dynamic, dynamic~
NewsProvider : +shouldShowInAppNotification$ ValueNotifier~dynamic~
NewsProvider o-- ValueNotifier~dynamic~
NewsProvider : +newsContentTypeId$ String
NewsProvider : +newsCollectionContentTypeId$ String
NewsProvider : +updateShouldShowInAppNotification()$ dynamic
NewsProvider : +getDetailedNewsEntry()$ dynamic
NewsProvider : +getTotalEntries()$ dynamic
NewsProvider : +getNewsEntries()$ dynamic
NewsProvider : +initializeNewsHiveBox()$ dynamic

class ApiProviderSettings
ApiProviderSettings : +baseURL$ String

class AnnetteColorSchemes
AnnetteColorSchemes : +lightColorScheme$ ColorScheme
AnnetteColorSchemes o-- ColorScheme
AnnetteColorSchemes : +darkColorScheme$ ColorScheme
AnnetteColorSchemes o-- ColorScheme

class AnnetteApp
AnnetteApp : +build() Widget
StatelessWidget <|-- AnnetteApp

class MyHomePage
MyHomePage : +title String
MyHomePage : +createState() State<MyHomePage>
StatefulWidget <|-- MyHomePage

class _MyHomePageState
_MyHomePageState : -_selectedDestination _Destination
_MyHomePageState o-- _Destination
_MyHomePageState : +subscription StreamSubscription~BoxEvent~?
_MyHomePageState o-- StreamSubscription~BoxEvent~
_MyHomePageState : -_homeworkCount int
_MyHomePageState : +initState() void
_MyHomePageState : +dispose() void
_MyHomePageState : +build() Widget
_MyHomePageState : +refresh() void
State <|-- _MyHomePageState

class _Destination
<<enumeration>> _Destination
_Destination : +index int
_Destination : +values$ List~_Destination~
_Destination : +vertretung$ _Destination
_Destination o-- _Destination
_Destination : +stundenplan$ _Destination
_Destination o-- _Destination
_Destination : +has$ _Destination
_Destination o-- _Destination
_Destination : +sonstiges$ _Destination
_Destination o-- _Destination
_Destination : +klausurplan$ _Destination
_Destination o-- _Destination
Enum <|.. _Destination

class ClassId
<<enumeration>> ClassId
ClassId : +index int
ClassId : +values$ List~ClassId~
ClassId : +c5A$ ClassId
ClassId o-- ClassId
Enum <|.. ClassId

class FileFormat
<<enumeration>> FileFormat
FileFormat : +index int
FileFormat : +values$ List~FileFormat~
FileFormat : +PDF$ FileFormat
FileFormat o-- FileFormat
FileFormat : +PNG$ FileFormat
FileFormat o-- FileFormat
FileFormat : +JPG$ FileFormat
FileFormat o-- FileFormat
FileFormat : +JSON$ FileFormat
FileFormat o-- FileFormat
FileFormat : +HOMEWORK$ FileFormat
FileFormat o-- FileFormat
Enum <|.. FileFormat

class HomeworkEntry
HomeworkEntry : +id int
HomeworkEntry : +subject String
HomeworkEntry : +notes String
HomeworkEntry : +dueDate DateTime
HomeworkEntry : +done bool
HomeworkEntry : +lastUpdated DateTime
HomeworkEntry : +reminderDateTime DateTime?
HomeworkEntry : +scheduledNotificationId int?
HomeworkEntry : +toJson() Map<String, dynamic>
HomeworkEntry : +registerAdapter()$ void

class HomeworkEntryAdapter
HomeworkEntryAdapter : +typeId int
HomeworkEntryAdapter : +read() HomeworkEntry
HomeworkEntryAdapter : +write() void
TypeAdapter <|-- HomeworkEntryAdapter

class SortingType
<<enumeration>> SortingType
SortingType : +index int
SortingType : +values$ List~SortingType~
SortingType : +subject_asc$ SortingType
SortingType o-- SortingType
SortingType : +subject_desc$ SortingType
SortingType o-- SortingType
SortingType : +dueDate_asc$ SortingType
SortingType o-- SortingType
SortingType : +dueDate_desc$ SortingType
SortingType o-- SortingType
SortingType : +lastUpdated_asc$ SortingType
SortingType o-- SortingType
SortingType : +lastUpdated_desc$ SortingType
SortingType o-- SortingType
Enum <|.. SortingType

class AnnetteThemeMode
<<enumeration>> AnnetteThemeMode
AnnetteThemeMode : +index int
AnnetteThemeMode : +values$ List~AnnetteThemeMode~
AnnetteThemeMode : +system$ AnnetteThemeMode
AnnetteThemeMode o-- AnnetteThemeMode
AnnetteThemeMode : +light$ AnnetteThemeMode
AnnetteThemeMode o-- AnnetteThemeMode
AnnetteThemeMode : +dark$ AnnetteThemeMode
AnnetteThemeMode o-- AnnetteThemeMode
Enum <|.. AnnetteThemeMode

class AppInitializer
AppInitializer : +init()$ dynamic
AppInitializer : +shouldPerformOnboarding()$ bool

class ApiProvider
ApiProvider : +fetchChoiceOptions()$ dynamic
ApiProvider : +fetchClasses()$ dynamic

class FilesProvider
FilesProvider : -_loadExamPlansFromNetwork()$ dynamic
FilesProvider : +storeFile()$ dynamic
FilesProvider : +getExamPlanFile()$ dynamic

class SubjectsProvider
SubjectsProvider : +getSubjects()$ dynamic
SubjectsProvider : +loadSubjectsFromFile()$ dynamic
SubjectsProvider : +saveSubjectsToFile()$ dynamic

class CalendarProvider
CalendarProvider : +addCalendarEntry()$ void

class ConnectionProvider
ConnectionProvider : -_connection$ bool
ConnectionProvider : -_subscription$ StreamSubscription~ConnectivityResult~
ConnectionProvider o-- StreamSubscription~ConnectivityResult~
ConnectionProvider : +init()$ void
ConnectionProvider : +dispose()$ void
ConnectionProvider : +hasConnection()$ bool

class NotificationProvider
NotificationProvider : +notificationsPlugin FlutterLocalNotificationsPlugin
NotificationProvider o-- FlutterLocalNotificationsPlugin
NotificationProvider : +init() dynamic
NotificationProvider : +makeNotificationDetails() dynamic
NotificationProvider : +showNotification() dynamic
NotificationProvider : +cancelNotification() dynamic
NotificationProvider : +scheduleNotification() dynamic

class StorageProvider
StorageProvider : +saveExamPlanDate()$ void
StorageProvider : +isExamPlanUpToDate()$ dynamic

class TimetableProvider
TimetableProvider : +getCurrentSubjectAsString()$ String

class UserSettings
UserSettings : -_config$ Box~dynamic~
UserSettings o-- Box~dynamic~
UserSettings : -_appSettings$ Box~dynamic~
UserSettings o-- Box~dynamic~
UserSettings : +themeNotifier$ ValueNotifier~ThemeMode~
UserSettings o-- ValueNotifier~ThemeMode~
UserSettings : +classId$ ClassId
UserSettings o-- ClassId
UserSettings : +themeMode$ ThemeMode
UserSettings o-- ThemeMode
UserSettings : +useMaterial3$ bool
UserSettings : +isOberstufe$ bool
UserSettings : +subjectLastClassId$ String
UserSettings : +selectedSubjects$ List~dynamic~
UserSettings : +subjects$ List~dynamic~
UserSettings : +subjectNames$ List~String~
UserSettings : +subjectFullNames$ List~String~
UserSettings : +shouldPerformOnboarding$ bool
UserSettings : +saveSubjects()$ void
UserSettings : -_saveSubjectNames()$ void

class ExamScreen
ExamScreen : +createState() State<ExamScreen>
StatefulWidget <|-- ExamScreen

class _ExamScreenState
_ExamScreenState : -_isLoading bool
_ExamScreenState : -_pdfViewerKey Key
_ExamScreenState o-- Key
_ExamScreenState : -_catastrophicFailure bool
_ExamScreenState : -_classId ClassId
_ExamScreenState o-- ClassId
_ExamScreenState : -_file File
_ExamScreenState o-- File
_ExamScreenState : +showFileChoiceMenu bool
_ExamScreenState : +initState() void
_ExamScreenState : +build() Widget
_ExamScreenState : +switchClass() void
_ExamScreenState : -_shareExamPlan() void
State <|-- _ExamScreenState

class HomeworkTray
HomeworkTray : +refresh Function
HomeworkTray : +show()$ void
HomeworkTray : +createState() _HomeworkTrayState
StatefulWidget <|-- HomeworkTray

class _HomeworkTrayState
_HomeworkTrayState : +subscription StreamSubscription~BoxEvent~?
_HomeworkTrayState o-- StreamSubscription~BoxEvent~
_HomeworkTrayState : +contents List~HomeworkEntry~
_HomeworkTrayState : +initState() void
_HomeworkTrayState : +dispose() void
_HomeworkTrayState : +build() Widget
_HomeworkTrayState : -_buildItem() Widget
State <|-- _HomeworkTrayState

class HomeworkDialog
HomeworkDialog : +show()$ void

class _dialogSheet
_dialogSheet : +editOnly bool
_dialogSheet : +subjects List~String~
_dialogSheet : +createState() _dialogSheetState
StatefulWidget <|-- _dialogSheet

class _dialogSheetState
_dialogSheetState : -_selectedSubject String
_dialogSheetState : -_annotations String
_dialogSheetState : -_formKey GlobalKey~FormState~
_dialogSheetState o-- GlobalKey~FormState~
_dialogSheetState : -_autoRemind bool
_dialogSheetState : -_selectedDate DateTime
_dialogSheetState : -_selectedTime TimeOfDay
_dialogSheetState o-- TimeOfDay
_dialogSheetState : -_scrollController ScrollController
_dialogSheetState o-- ScrollController
_dialogSheetState : -_scrollToEnd() void
_dialogSheetState : +build() Widget
State <|-- _dialogSheetState

class HomeworkImport
HomeworkImport : +show()$ void

class HomeworkImportWidget
HomeworkImportWidget : +entry HomeworkEntry
HomeworkImportWidget o-- HomeworkEntry
HomeworkImportWidget : +showDefault bool
HomeworkImportWidget : +createState() State<HomeworkImportWidget>
StatefulWidget <|-- HomeworkImportWidget

class _HomeworkImportWidgetState
_HomeworkImportWidgetState : -_controller TextEditingController
_HomeworkImportWidgetState o-- TextEditingController
_HomeworkImportWidgetState : -_selectedDate DateTime
_HomeworkImportWidgetState : -_selectedTime TimeOfDay
_HomeworkImportWidgetState o-- TimeOfDay
_HomeworkImportWidgetState : -_selectedDateR DateTime
_HomeworkImportWidgetState : -_selectedTimeR TimeOfDay
_HomeworkImportWidgetState o-- TimeOfDay
_HomeworkImportWidgetState : -_selectedSubject String
_HomeworkImportWidgetState : +initState() void
_HomeworkImportWidgetState : +build() Widget
_HomeworkImportWidgetState : +widgets() List<Widget>
_HomeworkImportWidgetState : +headerWidgets() List<Widget>
_HomeworkImportWidgetState : +subjectWidgets() List<Widget>
_HomeworkImportWidgetState : +infoInputWidgets() List<Widget>
_HomeworkImportWidgetState : +faelligWidgets() List<Widget>
_HomeworkImportWidgetState : +reminderTimeWidget() List<Widget>
_HomeworkImportWidgetState : +reminderShortcutButtons() List<Widget>
_HomeworkImportWidgetState : +closeButtons() List<Widget>
State <|-- _HomeworkImportWidgetState

class HomeworkInfo
HomeworkInfo : +show()$ void

class HomeworkInfoWidget
HomeworkInfoWidget : +entry HomeworkEntry
HomeworkInfoWidget o-- HomeworkEntry
HomeworkInfoWidget : +showDefault bool
HomeworkInfoWidget : +createState() State<HomeworkInfoWidget>
StatefulWidget <|-- HomeworkInfoWidget

class _HomeworkInfoWidgetState
_HomeworkInfoWidgetState : -_controller TextEditingController
_HomeworkInfoWidgetState o-- TextEditingController
_HomeworkInfoWidgetState : -_selectedDate DateTime
_HomeworkInfoWidgetState : -_selectedTime TimeOfDay
_HomeworkInfoWidgetState o-- TimeOfDay
_HomeworkInfoWidgetState : -_selectedDateR DateTime
_HomeworkInfoWidgetState : -_selectedTimeR TimeOfDay
_HomeworkInfoWidgetState o-- TimeOfDay
_HomeworkInfoWidgetState : +initState() void
_HomeworkInfoWidgetState : +build() Widget
State <|-- _HomeworkInfoWidgetState

class HomeworkScreen
HomeworkScreen : +refresh Function
HomeworkScreen : +createState() HomeworkScreenState
StatefulWidget <|-- HomeworkScreen

class HomeworkScreenState
HomeworkScreenState : +subscription StreamSubscription~BoxEvent~?
HomeworkScreenState o-- StreamSubscription~BoxEvent~
HomeworkScreenState : +pendingHomework List~HomeworkEntry~
HomeworkScreenState : +sortingType SortingType
HomeworkScreenState o-- SortingType
HomeworkScreenState : +initState() void
HomeworkScreenState : +dispose() void
HomeworkScreenState : +build() Widget
HomeworkScreenState : -_buildItem() Widget
HomeworkScreenState : +sortPendingHomework() void
State <|-- HomeworkScreenState

class MiscScreen
MiscScreen : +build() Widget
StatelessWidget <|-- MiscScreen

class NewsCollectionScreen
NewsCollectionScreen : +entriesPerPage int
NewsCollectionScreen : +createState() State<StatefulWidget>
StatefulWidget <|-- NewsCollectionScreen

class _NewsCollectionScreenState
_NewsCollectionScreenState : -_page int
_NewsCollectionScreenState : -_totalPages int
_NewsCollectionScreenState : -_newsEntries dynamic
_NewsCollectionScreenState : +updateNewsEntries() dynamic
_NewsCollectionScreenState : +initState() void
_NewsCollectionScreenState : +build() Widget
State <|-- _NewsCollectionScreenState

class AppConfigScreen
AppConfigScreen : +createState() State<AppConfigScreen>

class _AppConfigScreenState
_AppConfigScreenState : -_hasClassesResponseYet: bool
_AppConfigScreenState : -_hasOptionsResponseYet: bool
_AppConfigScreenState : -_hasError: bool
_AppConfigScreenState : -_classes: List~dynamic~
_AppConfigScreenState : -_options: dynamic
_AppConfigScreenState : -_currentFuture: dynamic
_AppConfigScreenState : -_selectedClass: dynamic
_AppConfigScreenState : -_secondStep: bool
_AppConfigScreenState : -_selectedOptions: Map~String, dynamic~
_AppConfigScreenState : +widgetWhileLoading(dynamic, String?): Column
_AppConfigScreenState o-- Column
_AppConfigScreenState : +initState(): void
_AppConfigScreenState : +build(): Widget
_AppConfigScreenState : +submitSelectedOptions(): void
_AppConfigScreenState : +reloadClasses(): void
_AppConfigScreenState : +loadOptions(): void

StatefulWidget <|-- AppConfigScreen
State <|-- _AppConfigScreenState

class OnboardingSegment
OnboardingSegment : +title String
OnboardingSegment : +description String
OnboardingSegment : +imagePath String?

class Onboarding
Onboarding : +createState() State<Onboarding>
StatefulWidget <|-- Onboarding

class _OnboardingState
_OnboardingState : -_currentPage int
_OnboardingState : -_pageController PageController
_OnboardingState o-- PageController
_OnboardingState : +build() Widget
State <|-- _OnboardingState

class AboutAppScreen
AboutAppScreen : -_version String
AboutAppScreen : -_buildNumber String
AboutAppScreen : +build() Widget
StatelessWidget <|-- AboutAppScreen

class SettingsPage
SettingsPage : +createState() State<SettingsPage>
StatefulWidget <|-- SettingsPage

class _SettingsPageState
_SettingsPageState : +build() Widget
State <|-- _SettingsPageState

class SubstitutionScreen
SubstitutionScreen : +build() Widget
StatelessWidget <|-- SubstitutionScreen

class TimetableScreen
TimetableScreen : +build() Widget
StatelessWidget <|-- TimetableScreen

class HomeworkManager
HomeworkManager : +entries()$ List<HomeworkEntry>
HomeworkManager : +pendingHomework()$ List<HomeworkEntry>
HomeworkManager : +doneHomework()$ List<HomeworkEntry>
HomeworkManager : +generateRemainingTimeToast()$ dynamic
HomeworkManager : +doesHomeworkEntryExist()$ bool
HomeworkManager : +addEmptyHomeworkEntry()$ dynamic
HomeworkManager : +addHomeworkEntry()$ dynamic
HomeworkManager : +editHomeworkEntry()$ dynamic
HomeworkManager : +showImportDialog()$ void
HomeworkManager : -_dialogCallback()$ void
HomeworkManager : +showHomeworkDialog()$ void
HomeworkManager : +showHomeworkEditDialog()$ void
HomeworkManager : +hasHomework()$ bool
HomeworkManager : +howManyPendingEntries()$ int
HomeworkManager : +howManyDoneEntries()$ int
HomeworkManager : +howManyEntries()$ int
HomeworkManager : +moveToBin()$ void
HomeworkManager : +restoreFromBin()$ void
HomeworkManager : +deleteFromBin()$ void

class HomeworkSharer
HomeworkSharer : +platform$ MethodChannel
HomeworkSharer o-- MethodChannel
HomeworkSharer : +handleSharedData()$ void
HomeworkSharer : +importHomework()$ void
HomeworkSharer : +shareHomework()$ void
HomeworkSharer : +convertMapToBytes()$ List<int>
HomeworkSharer : +convertHomeworkToBytes()$ List<int>
HomeworkSharer : +convertBytesToMap()$ Map<String, dynamic>

class NavigationService
NavigationService : +navigatorKey$ GlobalKey~NavigatorState~
NavigationService o-- GlobalKey~NavigatorState~

class SubstitutionManager
SubstitutionManager : +hasEVASoon()$ bool

class HomeworkBinWidget
HomeworkBinWidget : +onChecked Function
HomeworkBinWidget : +entry HomeworkEntry
HomeworkBinWidget o-- HomeworkEntry
HomeworkBinWidget : +createState() State<HomeworkBinWidget>
StatefulWidget <|-- HomeworkBinWidget

class _HomeworkBinWidgetState
_HomeworkBinWidgetState : +build() Widget
State <|-- _HomeworkBinWidgetState

class HomeworkWidget
HomeworkWidget : +onChecked Function
HomeworkWidget : +entry HomeworkEntry
HomeworkWidget o-- HomeworkEntry
HomeworkWidget : +createState() State<HomeworkWidget>
StatefulWidget <|-- HomeworkWidget

class _HomeworkWidgetState
_HomeworkWidgetState : +build() Widget
State <|-- _HomeworkWidgetState

class NewsNotification
NewsNotification : +createState() State<StatefulWidget>
StatefulWidget <|-- NewsNotification

class _NewsNotificationState
_NewsNotificationState : +updateNewsNotification() dynamic
_NewsNotificationState : +initState() void
_NewsNotificationState : +build() Widget
State <|-- _NewsNotificationState

class NoSignalError
NoSignalError : +onPressed void Function
NoSignalError o-- void Function
NoSignalError : +build() Widget
StatelessWidget <|-- NoSignalError

class BadRequestError
BadRequestError : +onPressed void Function
BadRequestError o-- void Function
BadRequestError : +build() Widget
StatelessWidget <|-- BadRequestError