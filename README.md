# swiftui-mvvm-clean-architecture-todo

Clean Architecture をベースに実装しています。  
Presentation 層は MVVM を採用しています。

https://github.com/user-attachments/assets/9479f6f3-3c54-46d8-8ca1-db5e022d50bd

## アーキテクチャ

```mermaid
classDiagram
namespace Presentation {
  class TaskView
  class TaskRowView
  class TaskDetailView
  class TaskCreateView
  class TaskViewModel
  class TaskDetailViewModel
  class TaskCreateViewModel
}
namespace UseCase {
  class TaskUseCaseProtocol
  class TaskUseCase
}
namespace Domain {
  class TaskEntity
  class TaskTitleValueObject
  class TaskNoteValueObject
  class TaskDueDateValueObject
}
namespace Infrastructure {
  class TaskRepositoryProtocol
  class TaskRepository
  class CoreData
}

direction LR
TaskView..>TaskViewModel
TaskView..>TaskRowView
TaskDetailView..>TaskDetailViewModel
TaskCreateView..>TaskCreateViewModel

TaskViewModel..>TaskUseCaseProtocol
TaskDetailViewModel..>TaskUseCaseProtocol
TaskCreateViewModel..>TaskUseCaseProtocol
TaskUseCaseProtocol<|--TaskUseCase

TaskEntity*--TaskTitleValueObject: title
TaskEntity*--TaskNoteValueObject: note
TaskEntity*--TaskDueDateValueObject: dueDate
TaskUseCase..>TaskEntity


TaskRepositoryProtocol<|--TaskRepository
TaskRepository..>CoreData
TaskUseCase..>TaskRepositoryProtocol


<<Protocol>> TaskUseCaseProtocol
<<Protocol>> TaskRepositoryProtocol
```

## ドメインモデル図

```mermaid
classDiagram
direction LR
class TaskEntity {
  + id: UUID
  + title: TaskTitleValueObject
  + note: TaskNoteValueObject
  + dueDate: TaskDueDateValueObject
  + isDone: Bool
  + createdAt: Date
  + updatedAt: Date
  + setTitleTo(_ title: String) Void
  + setNoteTo(_ description: String) Void
  + setDueDateTo(_ dueDate: Date) Void
  + toggleIsDone() Void
  - setUpdatedAt() Void
}
class TaskTitleValueObject {
  + value: String
}
class TaskNoteValueObject {
  + value: String
}
class TaskDueDateValueObject {
  + value: Date?
}

TaskEntity *-- TaskTitleValueObject: title
TaskEntity *-- TaskNoteValueObject: note
TaskEntity *-- TaskDueDateValueObject: dueDate

note for TaskTitleValueObject "- 前後の空白を除き１文字以上20文字以内とする\n- 前後に空白がある場合は空白を削除"
note for TaskNoteValueObject "前後の空白は削除"
note for TaskDueDateValueObject "設定時は今日以降のみ"
```
