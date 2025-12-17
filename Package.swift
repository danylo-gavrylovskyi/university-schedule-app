// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "university-schedule-app",
    platforms: [.iOS(.v16)],
    products: [
        .library(name: "university_schedule_app", targets: ["university_schedule_app"])
    ],
    targets: [
        .target(
            name: "university_schedule_app", 
            path: "Sources",
            exclude: [
                "UniversityScheduleApp.swift",
                "Views",
                "ViewModels",
                "App",
                "UI"
            ]
        ),
        .testTarget(
            name: "Tests", 
            dependencies: ["university_schedule_app"], 
            path: "Tests"
        )
    ]
)
