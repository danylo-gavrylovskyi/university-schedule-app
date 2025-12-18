// swift-tools-version: 5.9
// (Я вернул версию 5.9, так как 6.2 может не быть у всех коллег, это безопаснее)

import PackageDescription

let package = Package(
    name: "UniversityScheduleCore",
    platforms: [
            .iOS(.v15)
    ],
    products: [
        .library(
            name: "UniversityScheduleCore",
            targets: ["UniversityScheduleCore"]
        ),
    ],
    // ▼▼▼ ТЫ ПРОПУСТИЛА ВОТ ЭТУ ЧАСТЬ ▼▼▼
    dependencies: [
        .package(url: "https://github.com/SnapKit/SnapKit.git", .upToNextMajor(from: "5.0.0"))
    ],
    // ▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲
    
    targets: [
            .target(
                name: "UniversityScheduleCore",
                dependencies: ["SnapKit"], // Теперь это сработает, так как мы объявили пакет выше
                path: "Sources"
            ),
            .testTarget(
                name: "UniversityScheduleCoreTests",
                dependencies: ["UniversityScheduleCore"],
                path: "Tests"
            ),
        ]
)
