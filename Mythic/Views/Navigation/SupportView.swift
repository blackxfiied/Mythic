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

    @State private var isOpacityAnimated: Bool = false
    @State private var areOthersAnimated: Bool = false
    
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
        static let discordInviteURL = "https://discord.com/invite/58NZ7fFqPy"
        static let githubIssuesURL = "https://github.com/MythicApp/Mythic/issues"
        static let compatibilityListURL = "https://docs.google.com/spreadsheets/d/1W_1UexC1VOcbP2CHhoZBR5-8koH-ZPxJBDWntwH-tsc/edit?gid=0#gid=0"
        static let kofiURL = "https://ko-fi.com/vapidinfinity"
    }
    
    
    private let faqItems: [FAQItem] = [
        FAQItem(
            question: """
                What is Mythic?
                """,
            answer: """
                → Mythic is an open-source alternative to Epic Game Launcher and a normal game launcher for macOS, written in Swift. This project was created to provide a GUI frontend for Legendary and to play Windows games using Apple's game porting toolkit.
                """
        ),
        
        FAQItem(
            question: """
                Why do I get 'Mythic can't be opened because Apple cannot check it for malicious software'?
                """,
            answer: """
                → This is caused because Mythic isn't notarized yet. Open 'System Settings' then go to 'Privacy and Security' and then scroll down to where it says 'Mythic was blocked from use because it is not from an identified developer' and then press on 'Open Anyway' in the same dialogue box. Now attempt to reopen Mythic and press 'Open' and Mythic will now run. This will have to be done for every update that releases until the notarization process is complete.
                """
        ),
        FAQItem(
            question: """
                How does Mythic run Windows games on macOS?
                """,
            answer: """
                → This is caused because Mythic isn't notarized yet. Open 'System Settings' then go to 'Privacy and Security' and then scroll down to where it says 'Mythic was blocked from use because it is not from an identified developer' and then press on 'Open Anyway' in the same dialogue box. Now attempt to reopen Mythic and press 'Open' and Mythic will now run. This will have to be done for every update that releases until the notarization process is complete.
                """
        ),
        FAQItem(
            question: """
                How is this different from launchers like Heroic?
                """,
            answer: """
                → Compared to Heroic, Mythic has various features that make it a native experience. Mythic is written completely in Apple's own proprietary language, Swift. This gives Mythic a native macOS app appearance, as well as helps performance significantly. Heroic also makes use of Electron, which is known to have high resource consumption and is prone to clunky performance. Mythic's engine is a culmination of Apple's own Game Porting Toolkit, as well as other well known enhancements such as DXVK and soon, Winetricks.
                """
        ),
        FAQItem(
            question: """
                Will [x] feature or [y] game platform come to Mythic?
                """,
            answer: """
                → We're working our hardest to complete Mythic, and you can track our progress on the roadmap. If anything you want is missing, feel free to open up an issue on the GitHub"https://github.com/MythicApp/Mythic/issues" or join our Discord Server.
                """
        ),
        FAQItem(
            question: """
                What are the system requirements for Mythic?
                """,
            answer: """
                → Mythic requires macOS 14 Sonoma or later. It requires approximately 2GB of storage (Mythic Engine -- ~1.8GB and the app -- ~30MB). These requirements may change as the development progresses.
                """
        ),
        FAQItem(
            question: """
                Can I import my own games?
                """,
            answer: """
                → Yes, you can import your own games to Mythic, using the 'Import' button in the top menu of the app's Library section.
                """
        ),
        FAQItem(
            question: """
                What games can run using Mythic?
                """,
            answer: """
                → Almost any game or app that runs on Windows can run on Mythic (via GPTK), with the exception of games that use the Windows UWP platform and games that use kernel-level anti-cheats. Whether support for this will come is unknown and will come at the discretion of those working on Wine. For a (currently limited) list of games that have been tested, you may check out the community contributable spreadsheet.
                """
        ),
        FAQItem(
            question: """
                How do I import apps or launchers that have an Installer and then install to a local directory?
                """,
            answer: """
                → A community member (Asxrow) created a YouTube Video on how to import launchers (Steam as an example) with Mythic. In the near future, some launchers will be integrated in the same way as Epic Games is now.
                """
        ),
        FAQItem(
            question: """
                When I try to run a game on Mythic I receive an error saying "MS Visual C++ Runtime Missing"?
                """,
            answer: """
                → A community member (Asxrow) created a YouTube Video on how to fix this issue. It is a simple process and once installed, this error will not pop up again. When Winetricks is fixed, this video will not be needed.
                """
        ),
        FAQItem(
            question: """
                Why are the apps/games I import so small?
                """,
            answer: """
                → This is an issue with the compatibility layer between the two operating systems. To fix this, go to the "Containers" tab in the sidebar, and click on the gear icon next to the Bottle. At the bottom, press 'Launch Configurator' and at the top press on 'Graphics' and at the bottom of that menu, scale up to 240 DPI and press 'Apply,' then 'Ok.' If you want to see your changes, reopen that menu and change the scaling to whatever you want, but I don't recommend above 400 DPI. This only affects imported app windows.
                """
        )
    ]
    
    var body: some View {
    GeometryReader { geometry in
    ScrollView {
        ZStack {
                VStack(alignment: .leading){
                    ColorfulView(color: $colorfulAnimationColors, speed: $colorfulAnimationSpeed, noise: $colorfulAnimationNoise)
                        .ignoresSafeArea()
                }
                .frame(maxWidth: .infinity, maxHeight: geometry.size.height*0.7)
                .aspectRatio(contentMode: .fill)

                HStack {
                    
                    VStack(alignment: .leading){
                        Button(action: {
                            if let docUrl = URL(string: Constants.documentationURL) {
                                NSWorkspace.shared.open(docUrl)
                            }
                        }, label: {
                            VStack(alignment: .leading) {
                                Text("Get the help you need")
                                    .font(.system(size: geometry.size.height*0.07))
                                    .foregroundStyle(.white)
                                    .fontWeight(.bold)
                                    .opacity(1)
                                Text("Read the documentation ")
                                    .font(.system(size: geometry.size.height*0.03))
                                    .foregroundStyle(.blue)
                                    .underline()
                                + Text(Image(systemName: "arrow.right"))
                                    .font(.system(size: geometry.size.height*0.03))
                                    .foregroundStyle(.blue)
                                    .underline()
                            }
                        })
                        .buttonStyle(DocsButton())
                    }
                    .frame(width: geometry.size.width * 0.60)
                    .padding(.top, 40)
                    
                    
                    Spacer(minLength: geometry.size.width * 0.02)
                    
                        Image(nsImage: NSImage(named: "MythicIcon") ?? NSImage())
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(
                                maxWidth: geometry.size.width * 0.35,
                                maxHeight: geometry.size.height * 0.35
                            )
                            .padding(.trailing, geometry.size.width * 0.1)
                }
                .frame(width: geometry.size.width * 0.9)
                .padding(.top, 30)

                HStack {
                    VStack{

                        Spacer()

                        HStack(alignment: .center) {

                            HStack{
                                Spacer()

                                Button(action: {
                                    if let discordInviteUrl = URL(string: Constants.discordInviteURL) {
                                        NSWorkspace.shared.open(discordInviteUrl)
                                    }
                                }, label: {
                                    Text("Join our Discord Server")
                                        .font(.system(size: geometry.size.height*0.025))
                                        .fontWeight(.semibold)
                                })
                                .padding()
                                .buttonStyle(DiscordButton())

                                Spacer()
                            }
                            .padding()

                            HStack{
                                Divider()
                                    .frame(maxWidth: 1, maxHeight: geometry.size.height*0.08)

                                Spacer()

                                Button(action: {
                                    if let githubUrl = URL(string: Constants.githubIssuesURL) {
                                        NSWorkspace.shared.open(githubUrl)
                                    }
                                }, label: {
                                    Text("Report an issue on GitHub")
                                        .font(.system(size: geometry.size.height*0.025))
                                        .fontWeight(.semibold)
                                })
                                .padding()
                                .buttonStyle(GithubButton())

                                Spacer()

                                Divider()
                                    .frame(maxWidth: 1, maxHeight: geometry.size.height*0.08)
                            }.frame(maxWidth: geometry.size.width * 0.35, maxHeight: geometry.size.height*0.30)

                            HStack{
                                Spacer()

                                Button(action: {
                                    if let compatibilityListUrl = URL(string: Constants.compatibilityListURL) {
                                        NSWorkspace.shared.open(compatibilityListUrl)
                                    }
                                }, label: {
                                    Text("Game Compatibility list")
                                        .font(.system(size: geometry.size.height*0.025))
                                        .fontWeight(.semibold)
                                })
                                .padding()
                                .buttonStyle(CompatibilityButton())

                                Spacer()

                                Divider()
                                    .frame(width: 1, height: geometry.size.height*0.08)

                                Spacer()
                            }

                            HStack{
                                Button(action: {
                                    if let kofiUrl = URL(string: Constants.kofiURL) {
                                        NSWorkspace.shared.open(kofiUrl)
                                    }
                                }, label: {
                                    Text("Please consider donating!")
                                        .font(.system(size: geometry.size.height*0.025))
                                        .fontWeight(.semibold)
                                })
                                .padding()
                                .buttonStyle(DonateButton())

                                Spacer()
                            }.padding()
                        }
                        .frame(width: geometry.size.width, height: geometry.size.height / 30.5)

                    }
                    .frame(height: geometry.size.height * 0.65)
                    .frame(maxHeight: .infinity, alignment: .center)

                }
                .frame(maxWidth: .infinity)
                .padding(.bottom, 40)
            }
            .frame(maxHeight: geometry.size.height * 0.7)

            VStack(alignment: .leading) {

                Text("Frequently asked questions")
                    .font(.system(size: geometry.size.height * 0.04))
                    .fontWeight(.bold)
                    .padding(.bottom)
                    .padding(.trailing, geometry.size.width*0.020)

                Divider()
                    .frame(maxWidth: geometry.size.width - 40)
                
                ForEach(faqItems) { item in
                                        VStack(alignment: .leading) {
                                            HStack {
                                                Image(systemName: "chevron.down")
                                                    .rotationEffect(.degrees(expandedItemIDs.contains(item.id) ? 180 : 0))
                                                    .animation(.easeInOut, value: expandedItemIDs)
                                                    .padding()
                                                
                                                Text(item.question)
                                                    .font(.system(size: geometry.size.height*0.025))
                                                    .fontWeight(.semibold)
                                                
                                            }
                                            .contentShape(Rectangle())
                                            .onTapGesture {
                                                withAnimation {
                                                    if expandedItemIDs.contains(item.id) {
                                                        expandedItemIDs.remove(item.id)
                                                    } else {
                                                        expandedItemIDs.insert(item.id)
                                                    }
                                                }
                                            }
                                            
                                            if expandedItemIDs.contains(item.id) {
                                                Text(item.answer)
                                                    .font(.system(size: geometry.size.height*0.017))
                                                    .padding(.top, 4)
                                                    .padding(.leading, 35)
                                                    .transition(.move(edge: .top).combined(with: .opacity))
                                            }
                                            
                                            Divider()
                                        }
                                        .padding(.vertical, 8)
                                    }
                                }
                                .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
        }
            .frame(minHeight: geometry.size.height)
    }

                .task(priority: .background) {
                    discordRPC.setPresence({
                        var presence: RichPresence = .init()
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

    @State private var isHovered = false

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(isHovered ? Color(red: 198 / 255, green: 194 / 255, blue: 204 / 255, opacity: 0.2) : Color.clear)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .shadow(color: Color.accentColor.opacity(isHovered ? 1 : 0), radius: isHovered ? 12 : 0)
            .shadow(color: Color.accentColor.opacity(isHovered ? 1 : 0), radius: isHovered ? 12 : 0)
            .scaleEffect(isHovered ? 1.1 : 1)
            .animation(.spring(duration: 0.2, bounce: 0.3), value: isHovered)
            .scaleEffect(configuration.isPressed ? 1 : 1.1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
            .onHover { hovering in
                isHovered = hovering

            }
    }
}

struct DiscordButton: ButtonStyle {

    @State private var isHovered = false

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(Color(red: 198 / 255, green: 194 / 255, blue: 204 / 255, opacity: 0.2))
            .foregroundStyle(.white)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .shadow(color: Color(red: 114 / 255, green: 137 / 255, blue: 218 / 255).opacity(isHovered ? 1 : 0), radius: isHovered ? 12 : 0)
            .shadow(color: Color(red: 114 / 255, green: 137 / 255, blue: 218 / 255).opacity(isHovered ? 1 : 0), radius: isHovered ? 12 : 0)
            .shadow(color: Color.black.opacity(isHovered ? 0 : 0.2), radius: isHovered ? 0 : 3, x: 0, y: 4)
            .scaleEffect(isHovered ? 1.1 : 1)
            .animation(.spring(duration: 0.2, bounce: 0.3), value: isHovered)
            .scaleEffect(configuration.isPressed ? 1 : 1.1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
            .onHover { hovering in
                isHovered = hovering

            }
    }
}

struct GithubButton: ButtonStyle {

    @State private var isHovered = false

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(Color(red: 198 / 255, green: 194 / 255, blue: 204 / 255, opacity: 0.2))
            .foregroundStyle(.white)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .shadow(color: Color(red: 43 / 255, green: 49 / 255, blue: 55 / 255).opacity(isHovered ? 1 : 0), radius: isHovered ? 12 : 0)
            .shadow(color: Color(red: 43 / 255, green: 49 / 255, blue: 55 / 255).opacity(isHovered ? 1 : 0), radius: isHovered ? 12 : 0)
            .shadow(color: Color.black.opacity(isHovered ? 0 : 0.2), radius: isHovered ? 0 : 3, x: 0, y: 4)
            .scaleEffect(isHovered ? 1.1 : 1)
            .animation(.spring(duration: 0.2, bounce: 0.3), value: isHovered)
            .scaleEffect(configuration.isPressed ? 1 : 1.1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
            .onHover { hovering in
                isHovered = hovering

            }
    }
}

struct CompatibilityButton: ButtonStyle {

    @State private var isHovered = false

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(Color(red: 198 / 255, green: 194 / 255, blue: 204 / 255, opacity: 0.2))
            .foregroundStyle(.white)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .shadow(color: Color(red: 164 / 255, green: 125 / 255, blue: 171 / 255).opacity(isHovered ? 1 : 0), radius: isHovered ? 12 : 0)
            .shadow(color: Color(red: 164 / 255, green: 125 / 255, blue: 171 / 255).opacity(isHovered ? 1 : 0), radius: isHovered ? 12 : 0)
            .shadow(color: Color.black.opacity(isHovered ? 0 : 0.2), radius: isHovered ? 0 : 3, x: 0, y: 4)
            .scaleEffect(isHovered ? 1.1 : 1)
            .animation(.spring(duration: 0.2, bounce: 0.3), value: isHovered)
            .scaleEffect(configuration.isPressed ? 1 : 1.1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
            .onHover { hovering in
                isHovered = hovering

            }
    }
}

struct DonateButton: ButtonStyle {

    @State private var isHovered = false

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(Color(red: 198 / 255, green: 194 / 255, blue: 204 / 255, opacity: 0.2))
            .foregroundStyle(.white)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .shadow(color: Color.accentColor.opacity(isHovered ? 1 : 0), radius: isHovered ? 12 : 0)
            .shadow(color: Color.accentColor.opacity(isHovered ? 1 : 0), radius: isHovered ? 12 : 0)
            .shadow(color: Color.black.opacity(isHovered ? 0 : 0.2), radius: isHovered ? 0 : 3, x: 0, y: 4)
            .scaleEffect(isHovered ? 1.1 : 1)
            .animation(.spring(duration: 0.2, bounce: 0.3), value: isHovered)
            .scaleEffect(configuration.isPressed ? 1 : 1.1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
            .onHover { hovering in
                isHovered = hovering

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
