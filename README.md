# Gratitude Clone iOS

Application de journaling iOS inspirée de Stoic, développée avec SwiftUI et SwiftData.

## Fonctionnalités

- **Prompt quotidien** avec rotation intelligente (évite les répétitions sur 7 jours)
- **Entrées de journal** avec sélection d'humeur
- **Liste des entrées** groupée par mois avec statistiques (streak, total)
- **Filtres** par catégorie et humeur
- **Recherche** dans le contenu
- **Notifications** quotidiennes configurables
- **Thème** clair/sombre/système

## Stack technique

| Technologie | Usage |
|-------------|-------|
| **SwiftUI** | Interface utilisateur |
| **SwiftData** | Persistance des données |
| **MVVM** | Architecture |
| **@Observable** | Gestion d'état (iOS 17+) |

## Prérequis

- Xcode 15+
- iOS 17.0+

## Installation

1. Cloner le repo
```bash
git clone git@github.com:CarolaneLFBV/gratitude-clone-ios.git
```

2. Ouvrir `GratitudeClone.xcodeproj` dans Xcode

3. Configurer le signing :
   - Sélectionner la target **GratitudeClone**
   - Onglet **Signing & Capabilities**
   - Choisir votre **Team**
   - Modifier le **Bundle Identifier** (ex: `com.votrenom.GratitudeClone`)

4. Build & Run sur simulateur ou device

## Structure du projet

```
GratitudeClone/
├── App/
│   └── GratitudeCloneApp.swift         # Entry point + SwiftData
├── Models/
│   ├── JournalEntry.swift              # Entrée de journal
│   ├── DailyPrompt.swift               # Prompt quotidien
│   ├── Mood.swift                      # Enum des humeurs
│   ├── PromptCategory.swift            # Catégories
│   └── PromptData.swift                # Parsing JSON
├── ViewModels/
│   ├── HomeViewModel.swift
│   ├── JournalViewModel.swift
│   └── SettingsViewModel.swift
├── Views/
│   ├── MainTabView.swift
│   ├── Home/
│   ├── Journal/
│   ├── Entry/
│   └── Settings/
├── Services/
│   ├── PromptService.swift             # Rotation des prompts
│   ├── NotificationService.swift       # Rappels
│   └── UserDefaultsService.swift       # Préférences
├── Resources/
│   └── prompts.json                    # 20 phrases de réflexion
└── Extensions/
    ├── Date+Extensions.swift
    └── View+Extensions.swift
```

## Ressources utilisées

### Frameworks Apple
- SwiftUI
- SwiftData
- UserNotifications

### Patterns
- MVVM avec `@Observable`
- Injection de dépendances via `@Environment`
- `NavigationStack` / `TabView`

## Captures d'écran

*À venir*

## Licence

MIT

---

Développé avec [Claude Code](https://claude.ai/claude-code)
