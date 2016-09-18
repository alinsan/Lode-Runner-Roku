' ********************************************************************************************************
' ********************************************************************************************************
' **  Roku Lode Runner Channel - http://github.com/lvcabral/Lode-Runner-Roku
' **
' **  Created: September 2016
' **  Updated: September 2016
' **
' **  Remake in Brightscropt developed by Marcelo Lv Cabral - http://lvcabral.com
' **  https://github.com/SimonHung/LodeRunner - HTML5 version by Simon Hung
' **
' ********************************************************************************************************
' ********************************************************************************************************

Function StartMenu() as boolean
    this = {
            screen: CreateObject("roListScreen")
            port: CreateObject("roMessagePort")
           }
    this.screen.SetMessagePort(this.port)
    this.screen.SetHeader("Game Menu")
    this.spriteModes  = ["Apple II", "Commodore 64", "IBM-PC", "Atari 8 bits", "Randomize!"]
    this.spriteHelp   = ["Original Version", "Original Version", "CGA Version", "400/800/XL/XE", "New theme every level"]
    this.spriteImage  = ["pkg:/images/apple_ii.png", "pkg:/images/commodore_64.png", "pkg:/images/ibm_pc.png", "pkg:/images/atari_400.png", "pkg:/images/randomize.png"]
    this.versionModes = ["Classic (1983)", "Championship (1984)", "Professional (1985)"]
    this.versionHelp  = ["150 original levels", "50 difficult levels created by fans", "150 new levels by Dodosoft"]
    this.versionImage = ["pkg:/images/version_classic.png","pkg:/images/version_championship.png","pkg:/images/version_professional.png"]
    this.controlModes = ["Vertical Mode", "Horizontal Mode"]
    this.controlHelp  = ["", ""]
    this.controlImage = ["pkg:/images/control_vertical.png", "pkg:/images/control_horizontal.png"]
    this.rewFFModes   = ["Game Level", "Life Counter"]
    this.rewFFHelp    = ["REW & FF keys changes current level", "REW & FF increase/decrease life"]
    this.rewFFImage   = [invalid, invalid]
    listItems = GetMenuItems(this)
    this.screen.SetContent(listItems)
    this.screen.Show()
    startGame = false
    listIndex = 0
    oldIndex = 0
    while true
        msg = wait(0,this.port)
        if msg.isScreenClosed() then exit while
        if type(msg) = "roListScreenEvent"
            if msg.isListItemFocused()
                listIndex = msg.GetIndex()
            else if msg.isListItemSelected()
                if msg.GetIndex() = 0
                    SaveSettings(m.settings)
                    startGame = true
                    exit while
                end if
            else if msg.isRemoteKeyPressed()
                remoteKey = msg.GetIndex()
                if listIndex = 1 'Sprites
                    if remoteKey = m.code.BUTTON_LEFT_PRESSED
                        m.settings.spriteMode--
                        if m.settings.spriteMode < 0 then m.settings.spriteMode = this.spriteModes.Count() - 1
                    else if remoteKey = m.code.BUTTON_RIGHT_PRESSED
                        m.settings.spriteMode++
                        if m.settings.spriteMode = this.spriteModes.Count() then m.settings.spriteMode = 0
                    end if
                    listItems[listIndex].Title = "Graphics: " + this.spriteModes[m.settings.spriteMode]
                    listItems[listIndex].ShortDescriptionLine1 = this.spriteHelp[m.settings.spriteMode]
                    listItems[listIndex].HDPosterUrl = this.spriteImage[m.settings.spriteMode]
                    listItems[listIndex].SDPosterUrl = this.spriteImage[m.settings.spriteMode]
                    this.screen.SetItem(listIndex, listItems[listIndex])
                else if listIndex = 2 'Version
                    if remoteKey = m.code.BUTTON_LEFT_PRESSED
                        m.settings.version--
                        if m.settings.version < 0 then m.settings.version = this.versionModes.Count() - 1
                    else if remoteKey = m.code.BUTTON_RIGHT_PRESSED
                        m.settings.version++
                        if m.settings.version = this.versionModes.Count() then m.settings.version = 0
                    end if
                    listItems[listIndex].Title = "Version: " + this.versionModes[m.settings.version]
                    listItems[listIndex].ShortDescriptionLine1 = this.versionHelp[m.settings.version]
                    listItems[listIndex].HDPosterUrl = this.versionImage[m.settings.version]
                    listItems[listIndex].SDPosterUrl = this.versionImage[m.settings.version]
                    this.screen.SetItem(listIndex, listItems[listIndex])
                else if listIndex = 3 'Control
                    if remoteKey = m.code.BUTTON_LEFT_PRESSED
                        m.settings.controlMode--
                        if m.settings.controlMode < 0 then m.settings.controlMode = this.controlModes.Count() - 1
                    else if remoteKey = m.code.BUTTON_RIGHT_PRESSED
                        m.settings.controlMode++
                        if m.settings.controlMode = this.controlModes.Count() then m.settings.controlMode = 0
                    end if
                    listItems[listIndex].Title = "Control: " + this.controlModes[m.settings.controlMode]
                    listItems[listIndex].ShortDescriptionLine1 = this.controlHelp[m.settings.controlMode]
                    listItems[listIndex].HDPosterUrl = this.controlImage[m.settings.controlMode]
                    listItems[listIndex].SDPosterUrl = this.controlImage[m.settings.controlMode]
                    this.screen.SetItem(listIndex, listItems[listIndex])
                else if listIndex = 4 'REW & FF
                    if remoteKey = m.code.BUTTON_LEFT_PRESSED
                        m.settings.rewFF--
                        if m.settings.rewFF < 0 then m.settings.rewFF = this.rewFFModes.Count() - 1
                    else if remoteKey = m.code.BUTTON_RIGHT_PRESSED
                        m.settings.rewFF++
                        if m.settings.rewFF = this.rewFFModes.Count() then m.settings.rewFF = 0
                    end if
                    listItems[listIndex].Title = "Cheat Mode: " + this.rewFFModes[m.settings.rewFF]
                    listItems[listIndex].ShortDescriptionLine1 = this.rewFFHelp[m.settings.rewFF]
                    listItems[listIndex].HDPosterUrl = this.rewFFImage[m.settings.rewFF]
                    listItems[listIndex].SDPosterUrl = this.rewFFImage[m.settings.rewFF]
                    this.screen.SetItem(listIndex, listItems[listIndex])
                end if
            end if
        end if
    end while
    return startGame
End Function

Function GetMenuItems(menu as object)
    listItems = []
    listItems.Push({
                Title: "Start the Game"
                HDSmallIconUrl: "pkg:/images/icon_start.png"
                SDSmallIconUrl: "pkg:/images/icon_start.png"
                HDPosterUrl: "pkg:/images/cover.png"
                SDPosterUrl: "pkg:/images/cover.png"
                ShortDescriptionLine1: ""
                ShortDescriptionLine2: "Press OK to start the game"
                })
    listItems.Push({
                Title: "Graphics: " + menu.spriteModes[m.settings.spriteMode]
                HDSmallIconUrl: "pkg:/images/icon_arrows.png"
                SDSmallIconUrl: "pkg:/images/icon_arrows.png"
                HDPosterUrl: menu.spriteImage[m.settings.spriteMode]
                SDPosterUrl: menu.spriteImage[m.settings.spriteMode]
                ShortDescriptionLine1: menu.spriteHelp[m.settings.spriteMode]
                ShortDescriptionLine2: "Use Left and Right to select the skin"
                })
    listItems.Push({
                Title: "Version: " + menu.versionModes[m.settings.version]
                HDSmallIconUrl: "pkg:/images/icon_arrows.png"
                SDSmallIconUrl: "pkg:/images/icon_arrows.png"
                HDPosterUrl: menu.versionImage[m.settings.version]
                SDPosterUrl: menu.versionImage[m.settings.version]
                ShortDescriptionLine1: menu.versionHelp[m.settings.version]
                ShortDescriptionLine2: "Use Left and Right to select a level set"
                })
    listItems.Push({
                Title: "Control: " + menu.controlModes[m.settings.controlMode]
                HDSmallIconUrl: "pkg:/images/icon_arrows.png"
                SDSmallIconUrl: "pkg:/images/icon_arrows.png"
                HDPosterUrl: menu.controlImage[m.settings.controlMode]
                SDPosterUrl: menu.controlImage[m.settings.controlMode]
                ShortDescriptionLine1: menu.controlHelp[m.settings.controlMode]
                ShortDescriptionLine2: "Use Left and Right to select the control mode"
                })
    listItems.Push({
                Title: "Cheat Mode: " + menu.rewFFModes[m.settings.rewFF]
                HDSmallIconUrl: "pkg:/images/icon_arrows.png"
                SDSmallIconUrl: "pkg:/images/icon_arrows.png"
                HDPosterUrl: menu.rewFFImage[m.settings.rewFF]
                SDPosterUrl: menu.rewFFImage[m.settings.rewFF]
                ShortDescriptionLine1: menu.rewFFHelp[m.settings.rewFF]
                ShortDescriptionLine2: "Use Left and Right to select the cheat mode"
                })
    return listItems
End Function