//
//  SupportView.swift
//  Mythic
//
//  Created by vapidinfinity (esi) on 12/9/2023.
//

// MARK: - Copyright
// Copyright © 2024 vapidinfinity

// This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
// This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
// You should have received a copy of the GNU General Public License along with this program. If not, see http://www.gnu.org/licenses/.

// You can fold these comments by pressing [⌃ ⇧ ⌘ ◀︎], unfold with [⌃ ⇧ ⌘ ▶︎]

import SwiftUI
import SwordRPC
import ColorfulX

struct SupportView: View {

    @Environment(\.colorScheme) var colorScheme

    @State private var colorfulAnimationColors: [Color] = [
        .init(hex: "#5412F6"),
        .init(hex: "#7E1ED8"),
        .init(hex: "#2C2C2C")
    ]
    @State private var colorfulAnimationSpeed: Double = 1
    @State private var colorfulAnimationNoise: Double = 0

    @State private var expandedItemIDs = Set<UUID>()

    private var colorSchemeValue: String {
        switch colorScheme {
        case .light: return "light"
        case .dark: return "dark"
        @unknown default: return "dark"
        }
    }

    private enum Constants {
        static let documentationURL = "https://docs.getmythic.app/"
        static let discordInviteURL = "https://discord.gg/kQKdvjTVqh"
        static let githubIssuesURL = "https://github.com/MythicApp/Mythic/issues" // https://github.com/MythicApp/Mythic/issues/new/choose
        static let compatibilityListURL = "https://docs.google.com/spreadsheets/d/1W_1UexC1VOcbP2CHhoZBR5-8koH-ZPxJBDWntwH-tsc/edit?gid=0#gid=0"
        static let kofiURL = "https://ko-fi.com/vapidinfinity"
    }

    // TODO: implement dynamic FAQ endpoint at getmythic.app, and FAQItem decoder
    private let faqItems: [FAQItem] = []

    var body: some View {
        ZStack {
            ColorfulView(
                color: $colorfulAnimationColors,
                speed: $colorfulAnimationSpeed,
                noise: $colorfulAnimationNoise
            )
            .ignoresSafeArea()

            ScrollView {
                VStack {
                    HStack {
                        Button {
                            if let url = URL(string: Constants.documentationURL) {
                                NSWorkspace.shared.open(url)
                            }
                        } label: {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Get the help you need")
                                    .font(.largeTitle)
                                    .foregroundColor(.white)
                                    .fontWeight(.bold)

                                Label("Read the documentation", systemImage: "link")
                            }
                        }
                        .buttonStyle(DocsButton())

                        Spacer()

                        Image(nsImage: NSImage(named: "MythicIcon") ?? NSImage())
                            .resizable()
                            .aspectRatio(1, contentMode: .fit)
                            .padding()
                    }
                    .frame(maxHeight: 300)
                    .padding()

                    Spacer()

                    Divider()
                        .padding(.horizontal)

                    HStack {
                        Button {
                            if let url = URL(string: Constants.discordInviteURL) {
                                NSWorkspace.shared.open(url)
                            }
                        } label: {
                            Label("Join the Discord Server", systemImage: "link")
                                .fontWeight(.semibold)
                        }
                        .buttonStyle(DocsButton())

                        Button {
                            if let url = URL(string: Constants.githubIssuesURL) {
                                NSWorkspace.shared.open(url)
                            }
                        } label: {
                            Label("Report an issue on GitHub", systemImage: "link")
                                .fontWeight(.semibold)
                        }
                        .buttonStyle(DocsButton())

                        Button {
                            if let url = URL(string: Constants.compatibilityListURL) {
                                NSWorkspace.shared.open(url)
                            }
                        } label: {
                            Label("Game Compatibility list", systemImage: "link")
                                .fontWeight(.semibold)
                        }
                        .buttonStyle(DocsButton())

                        Button {
                            if let url = URL(string: Constants.kofiURL) {
                                NSWorkspace.shared.open(url)
                            }
                        } label: {
                            Label("Please consider donating!", systemImage: "link")
                                .fontWeight(.semibold)
                        }
                        .buttonStyle(DocsButton())
                    }
                    .padding()
                }
            }
        }
        .task(priority: .background) {
            // Set rich presence using SwordRPC
            discordRPC.setPresence({
                var presence = RichPresence()
                presence.details = "Looking for help"
                presence.state = "Viewing Support"
                presence.timestamps.start = .now
                presence.assets.largeImage = "macos_512x512_2x"
                return presence
            }())
        }
        .navigationTitle("Support")
    }
}

struct DocsButton: ButtonStyle {
    @State private var isHovering = false

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .buttonStyle(.bordered)
            .background(.fill)
            .clipShape(.rect(cornerRadius: 20))
            .shadow(color: .accent.opacity(isHovering ? 1 : 0), radius: isHovering ? 12 : 0)
            .scaleEffect(isHovering ? 1.05 : 1)
            .animation(.spring, value: isHovering)
            .onHover { hovering in
                isHovering = hovering
            }
    }
}

struct FAQItem: Identifiable {
    let id = UUID()
    let question: String
    let answer: String
}

#Preview {
    SupportView()
}
