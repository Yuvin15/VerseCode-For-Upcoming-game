using { /Fortnite.com/UI }
using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /UnrealEngine.com/Temporary/UI }
using { /Verse.org/Colors }
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /Verse.org/Random }
using { /Fortnite.com/Characters }

# See https://dev.epicgames.com/documentation/en-us/uefn/create-your-own-device-in-verse for how to create a verse device.

# A Verse-authored creative device that can be placed in a level
Random_UI := class(creative_device):

    TextForUI<localizes>(InText : string) : message = "{InText}"

    @editable
    StartButton:button_device = button_device{}
    @editable
    ItemGranterUI1: item_granter_device = item_granter_device{}
    @editable
    ItemGranterUI2: item_granter_device = item_granter_device{}
    @editable
    ItemGranterUI3: item_granter_device = item_granter_device{}
    @editable
    WeaponItemGranter: item_granter_device = item_granter_device{}
    @editable
    GoldItemGranter: item_granter_device = item_granter_device{}

    UIArray : []string = array{"UI1", "UI2", "UI3"}

    TextForMyUI<localizes> : message = "Pick"
    # TextForMyUI2<localizes> : message = "Lose health\n-95 Health"
    # TextForMyUI3<localizes> : message = "Get more health\n+1000 Health"

    var MaybeMyUIPerPlayer : [player]?canvas = map{}
    # Runs when the device is started in a running game
    OnBegin<override>()<suspends>:void=
        # TODO: Replace this with your code
        StartButton.InteractedWithEvent.Subscribe(OnInteracted)
        ItemGranterUI1.ItemGrantedEvent.Subscribe(ItemGrantedForUI1)
        ItemGranterUI2.ItemGrantedEvent.Subscribe(ItemGrantedForUI2)
        ItemGranterUI3.ItemGrantedEvent.Subscribe(ItemGrantedForUI3)

    OnInteracted(Agent : agent ) : void = 
        PlayerRand := GetRandomInt(1,UIArray.Length)
            Print(ToString(PlayerRand))
            if (PlayerRand = 1):
                ItemGranterUI1.GrantItem(Agent)
                Print("UI1", ?Duration:=6.0)
            if(PlayerRand = 2):
                ItemGranterUI2.GrantItem(Agent)
                Print("UI2", ?Duration:=6.0)
            if(PlayerRand = 3):
                ItemGranterUI3.GrantItem(Agent)
                Print("UI3", ?Duration:=6.0)
            
    ItemGrantedForUI1(Agent : agent ) : void =
        if (InPlayer := player[Agent], PlayerUI := GetPlayerUI[InPlayer]):
            if (MyUI := MaybeMyUIPerPlayer[InPlayer]?):
                PlayerUI.RemoveWidget(MyUI)
                if (set MaybeMyUIPerPlayer[InPlayer] = false) {}
            else:
                UI1 := CreateUI1()
                PlayerUI.AddWidget(UI1, player_ui_slot{InputMode := ui_input_mode.All})
                if (set MaybeMyUIPerPlayer[InPlayer] = option{UI1}) {}
            
    ItemGrantedForUI2(Agent : agent ) : void =
        if (InPlayer := player[Agent], PlayerUI := GetPlayerUI[InPlayer]):
            if (MyUI := MaybeMyUIPerPlayer[InPlayer]?):
                PlayerUI.RemoveWidget(MyUI)
                if (set MaybeMyUIPerPlayer[InPlayer] = false) {}
            else:
                UI2 := CreateUI2()
                PlayerUI.AddWidget(UI2, player_ui_slot{InputMode := ui_input_mode.All})
                if (set MaybeMyUIPerPlayer[InPlayer] = option{UI2}) {}

    ItemGrantedForUI3(Agent : agent ) : void =
        if (InPlayer := player[Agent], PlayerUI := GetPlayerUI[InPlayer]):
            if (MyUI := MaybeMyUIPerPlayer[InPlayer]?):
                PlayerUI.RemoveWidget(MyUI)
                if (set MaybeMyUIPerPlayer[InPlayer] = false) {}
            else:
                UI3 := CreateUI3()
                PlayerUI.AddWidget(UI3, player_ui_slot{InputMode := ui_input_mode.All})
                if (set MaybeMyUIPerPlayer[InPlayer] = option{UI3}) {}
        
    HandleSelectedUIButton(Message : widget_message) : void =
        if (PlayerUI := GetPlayerUI[Message.Player], MyUI := MaybeMyUIPerPlayer[Message.Player]?, SelectedButton := text_button_base[Message.Source]):
            Print("Player selected {SelectedButton.GetText()}")
            if (FortChar:= Message.Player.GetFortCharacter[]):
                current_health: float = FortChar.GetHealth()
                FortChar.SetMaxHealth(current_health + 150.0)
                Print("Health Increase", ?Duration:=1.0)
            PlayerUI.RemoveWidget(MyUI)
            if (set MaybeMyUIPerPlayer[Message.Player] = false) {}

    HandleSelectedUIButton2(Message : widget_message) : void =
       if (PlayerUI := GetPlayerUI[Message.Player], MyUI := MaybeMyUIPerPlayer[Message.Player]?, SelectedButton := text_button_base[Message.Source]):
           Print("Player selected {SelectedButton.GetText()}")
           if (FortChar:= Message.Player.GetFortCharacter[]):
               current_health: float = FortChar.GetHealth()
               FortChar.SetMaxHealth(current_health - 95.0)
               Print("Health Increase", ?Duration:=1.0)
           PlayerUI.RemoveWidget(MyUI)
           if (set MaybeMyUIPerPlayer[Message.Player] = false) {}

    HandleSelectedUIButton3(Message : widget_message) : void =
        if (PlayerUI := GetPlayerUI[Message.Player], MyUI := MaybeMyUIPerPlayer[Message.Player]?, SelectedButton := text_button_base[Message.Source]):
            Print("Player selected {SelectedButton.GetText()}")
            if (FortChar:= Message.Player.GetFortCharacter[]):
                current_health: float = FortChar.GetHealth()
                FortChar.SetMaxHealth(current_health + 1000.0)
                Print("Health Increase", ?Duration:=1.0)
            PlayerUI.RemoveWidget(MyUI)
            if (set MaybeMyUIPerPlayer[Message.Player] = false) {}

    HandleSelectedUIButtonGrantRandomItem(Message : widget_message) : void =
        if (PlayerUI := GetPlayerUI[Message.Player], MyUI := MaybeMyUIPerPlayer[Message.Player]?, SelectedButton := text_button_base[Message.Source]):
            Print("Player selected {SelectedButton.GetText()}")
            WeaponItemGranter.CycleToRandomItem(Message.Player)
            PlayerUI.RemoveWidget(MyUI)
            if (set MaybeMyUIPerPlayer[Message.Player] = false) {}

    HandleSelectedUIButtonGrantRandomGold(Message : widget_message) : void =
        if (PlayerUI := GetPlayerUI[Message.Player], MyUI := MaybeMyUIPerPlayer[Message.Player]?, SelectedButton := text_button_base[Message.Source]):
            Print("Player selected {SelectedButton.GetText()}")
            GoldItemGranter.CycleToRandomItem(Message.Player)
            PlayerUI.RemoveWidget(MyUI)
            if (set MaybeMyUIPerPlayer[Message.Player] = false) {}

    HandleSelectedUIButtonConvertShield(Message : widget_message) : void =
        if (PlayerUI := GetPlayerUI[Message.Player], MyUI := MaybeMyUIPerPlayer[Message.Player]?, SelectedButton := text_button_base[Message.Source]):
            Print("Player selected {SelectedButton.GetText()}")
            if (FortChar:= Message.Player.GetFortCharacter[]):
                current_health: float = FortChar.GetHealth()
                current_shield: float = FortChar.GetMaxShield()
                FortChar.SetMaxHealth(current_health - 50.0)
                FortChar.SetMaxShield(current_shield + 50.0)
                # FortChar.SetShield(10000.0)
                Print("Shield increase", ?Duration:=1.0)
            PlayerUI.RemoveWidget(MyUI)
            if (set MaybeMyUIPerPlayer[Message.Player] = false) {}
        
    CreateUI1() : canvas =
        MyUIButton : button_loud = button_loud{DefaultText := TextForMyUI}
        MyUIButton.OnClick().Subscribe(HandleSelectedUIButton)

        MyUIButton2 : button_loud = button_loud{DefaultText := TextForMyUI}
        MyUIButton2.OnClick().Subscribe(HandleSelectedUIButton2)

        MyUIButton3 : button_loud = button_loud{DefaultText := TextForMyUI}
        MyUIButton3.OnClick().Subscribe(HandleSelectedUIButton3)

        Ui1 : canvas = canvas:
            Slots:=array:
                canvas_slot: 
                    Anchors := anchors{Minimum := vector2{X := 0.4, Y := 0.6}, Maximum := vector2{X := 0.4, Y := 0.6} }
                    Offsets := margin{Top := 0.0, Left := 0.0, Right := 0.0, Bottom := 0.0}
                    Alignment := vector2{X := 0.0, Y := 0.0}
                    SizeToContent := true
                    Widget := stack_box:
                        Orientation := orientation.Vertical
                        Slots := array:
                            stack_box_slot:
                                Widget := overlay:
                                    Slots := array:
                                        overlay_slot:
                                            Widget := color_block:
                                                DefaultColor := NamedColors.Black
                                                DefaultOpacity := 1.0
                                                DefaultDesiredSize := vector2{X := 500.0, Y := 150.0}    
                                        overlay_slot:
                                            Widget := color_block:
                                                DefaultColor := NamedColors.Blue
                                                DefaultOpacity := 1.0
                                                DefaultDesiredSize := vector2{X := 495.0, Y := 145.0}                           
                                        overlay_slot:
                                            HorizontalAlignment := horizontal_alignment.Left
                                            Padding:= margin {Left:= 10.0, Top:= 0.0, Right:= 0.0, Bottom:= 0.0}
                                            Widget := text_block:
                                                DefaultText := TextForUI("Gain Health\n+150 Health")
                                                DefaultTextColor := NamedColors.White
                                                DefaultShadowColor:= NamedColors.Black
                                        overlay_slot:
                                            Padding:= margin {Left:= 0.0, Top:= 0.0, Right:= 10.0, Bottom:= 0.0}
                                            Widget := MyUIButton
                                            HorizontalAlignment := horizontal_alignment.Right
                canvas_slot: 
                    Anchors := anchors{Minimum := vector2{X := 0.4, Y := 0.4}, Maximum := vector2{X := 0.4, Y := 0.4} }
                    Offsets := margin{Top := 0.0, Left := 0.0, Right := 0.0, Bottom := 0.0}
                    Alignment := vector2{X := 0.0, Y := 0.0}
                    SizeToContent := true
                    Widget := stack_box:
                        Orientation := orientation.Vertical
                        Slots := array:
                            stack_box_slot:
                                Widget := overlay:
                                    Slots := array:
                                        overlay_slot:
                                            Widget := color_block:
                                                DefaultColor := NamedColors.Black
                                                DefaultOpacity := 1.0
                                                DefaultDesiredSize := vector2{X := 500.0, Y := 150.0}    
                                        overlay_slot:
                                            Widget := color_block:
                                                DefaultColor := NamedColors.DarkKhaki
                                                DefaultOpacity := 1.0
                                                DefaultDesiredSize := vector2{X := 495.0, Y := 145.0}                           
                                        overlay_slot:
                                            HorizontalAlignment := horizontal_alignment.Left
                                            Padding:= margin {Left:= 10.0, Top:= 0.0, Right:= 0.0, Bottom:= 0.0}
                                            Widget := text_block:
                                                DefaultText := TextForUI("Lose Health\n-95 Health")
                                                DefaultTextColor := NamedColors.White
                                                DefaultShadowColor:= NamedColors.Black
                                        overlay_slot:
                                            Padding:= margin {Left:= 0.0, Top:= 0.0, Right:= 10.0, Bottom:= 0.0}
                                            Widget := MyUIButton2
                                            HorizontalAlignment := horizontal_alignment.Right
                canvas_slot: 
                    Anchors := anchors{Minimum := vector2{X := 0.4, Y := 0.2}, Maximum := vector2{X := 0.4, Y := 0.2} }
                    Offsets := margin{Top := 0.0, Left := 0.0, Right := 0.0, Bottom := 0.0}
                    Alignment := vector2{X := 0.0, Y := 0.0}
                    SizeToContent := true
                    Widget := stack_box:
                        Orientation := orientation.Vertical
                        Slots := array:
                            stack_box_slot:
                                Widget := overlay:
                                    Slots := array:
                                        overlay_slot:
                                            Widget := color_block:
                                                DefaultColor := NamedColors.Black
                                                DefaultOpacity := 1.0
                                                DefaultDesiredSize := vector2{X := 500.0, Y := 150.0}    
                                        overlay_slot:
                                            Widget := color_block:
                                                DefaultColor := NamedColors.DarkMagenta
                                                DefaultOpacity := 1.0
                                                DefaultDesiredSize := vector2{X := 495.0, Y := 145.0}                           
                                        overlay_slot:
                                            HorizontalAlignment := horizontal_alignment.Left
                                            Padding:= margin {Left:= 10.0, Top:= 0.0, Right:= 0.0, Bottom:= 0.0}
                                            Widget := text_block:
                                                DefaultText := TextForUI("Gain Health\n+1000 Health")
                                                DefaultTextColor := NamedColors.White
                                                DefaultShadowColor:= NamedColors.Black
                                        overlay_slot:
                                            Padding:= margin {Left:= 0.0, Top:= 0.0, Right:= 10.0, Bottom:= 0.0}
                                            Widget := MyUIButton3
                                            HorizontalAlignment := horizontal_alignment.Right
                            
                    
    CreateUI2() : canvas =
        MyUIButton : button_loud = button_loud{DefaultText := TextForMyUI}
        MyUIButton.OnClick().Subscribe(HandleSelectedUIButtonConvertShield)

        MyUIButton2 : button_loud = button_loud{DefaultText := TextForMyUI}
        MyUIButton2.OnClick().Subscribe(HandleSelectedUIButtonGrantRandomItem)

        MyUIButton3 : button_loud = button_loud{DefaultText := TextForMyUI}
        MyUIButton3.OnClick().Subscribe(HandleSelectedUIButtonGrantRandomGold)

        Ui2 : canvas = canvas:
            Slots:=array:
                canvas_slot: 
                    Anchors := anchors{Minimum := vector2{X := 0.4, Y := 0.6}, Maximum := vector2{X := 0.4, Y := 0.6} }
                    Offsets := margin{Top := 0.0, Left := 0.0, Right := 0.0, Bottom := 0.0}
                    Alignment := vector2{X := 0.0, Y := 0.0}
                    SizeToContent := true
                    Widget := stack_box:
                        Orientation := orientation.Vertical
                        Slots := array:
                            stack_box_slot:
                                Widget := overlay:
                                    Slots := array:
                                        overlay_slot:
                                            Widget := color_block:
                                                DefaultColor := NamedColors.Black
                                                DefaultOpacity := 1.0
                                                DefaultDesiredSize := vector2{X := 500.0, Y := 150.0}    
                                        overlay_slot:
                                            Widget := color_block:
                                                DefaultColor := NamedColors.Blue
                                                DefaultOpacity := 1.0
                                                DefaultDesiredSize := vector2{X := 495.0, Y := 145.0}                           
                                        overlay_slot:
                                            HorizontalAlignment := horizontal_alignment.Left
                                            Padding:= margin {Left:= 10.0, Top:= 0.0, Right:= 0.0, Bottom:= 0.0}
                                            Widget := text_block:
                                                DefaultText := TextForUI("Gain a shield but reduces health")
                                                DefaultTextColor := NamedColors.White
                                                DefaultShadowColor:= NamedColors.Black
                                        overlay_slot:
                                            Padding:= margin {Left:= 0.0, Top:= 0.0, Right:= 10.0, Bottom:= 0.0}
                                            Widget := MyUIButton
                                            HorizontalAlignment := horizontal_alignment.Right
                canvas_slot: 
                    Anchors := anchors{Minimum := vector2{X := 0.4, Y := 0.4}, Maximum := vector2{X := 0.4, Y := 0.4} }
                    Offsets := margin{Top := 0.0, Left := 0.0, Right := 0.0, Bottom := 0.0}
                    Alignment := vector2{X := 0.0, Y := 0.0}
                    SizeToContent := true
                    Widget := stack_box:
                        Orientation := orientation.Vertical
                        Slots := array:
                            stack_box_slot:
                                Widget := overlay:
                                    Slots := array:
                                        overlay_slot:
                                            Widget := color_block:
                                                DefaultColor := NamedColors.Black
                                                DefaultOpacity := 1.0
                                                DefaultDesiredSize := vector2{X := 500.0, Y := 150.0}    
                                        overlay_slot:
                                            Widget := color_block:
                                                DefaultColor := NamedColors.DarkKhaki
                                                DefaultOpacity := 1.0
                                                DefaultDesiredSize := vector2{X := 495.0, Y := 145.0}                           
                                        overlay_slot:
                                            HorizontalAlignment := horizontal_alignment.Left
                                            Padding:= margin {Left:= 10.0, Top:= 0.0, Right:= 0.0, Bottom:= 0.0}
                                            Widget := text_block:
                                                DefaultText := TextForUI("Get a new random wepaon")
                                                DefaultTextColor := NamedColors.White
                                                DefaultShadowColor:= NamedColors.Black
                                        overlay_slot:
                                            Padding:= margin {Left:= 0.0, Top:= 0.0, Right:= 10.0, Bottom:= 0.0}
                                            Widget := MyUIButton2
                                            HorizontalAlignment := horizontal_alignment.Right
                canvas_slot: 
                    Anchors := anchors{Minimum := vector2{X := 0.4, Y := 0.2}, Maximum := vector2{X := 0.4, Y := 0.2} }
                    Offsets := margin{Top := 0.0, Left := 0.0, Right := 0.0, Bottom := 0.0}
                    Alignment := vector2{X := 0.0, Y := 0.0}
                    SizeToContent := true
                    Widget := stack_box:
                        Orientation := orientation.Vertical
                        Slots := array:
                            stack_box_slot:
                                Widget := overlay:
                                    Slots := array:
                                        overlay_slot:
                                            Widget := color_block:
                                                DefaultColor := NamedColors.Black
                                                DefaultOpacity := 1.0
                                                DefaultDesiredSize := vector2{X := 500.0, Y := 150.0}    
                                        overlay_slot:
                                            Widget := color_block:
                                                DefaultColor := NamedColors.DarkMagenta
                                                DefaultOpacity := 1.0
                                                DefaultDesiredSize := vector2{X := 495.0, Y := 145.0}                           
                                        overlay_slot:
                                            HorizontalAlignment := horizontal_alignment.Left
                                            Padding:= margin {Left:= 10.0, Top:= 0.0, Right:= 0.0, Bottom:= 0.0}
                                            Widget := text_block:
                                                DefaultText := TextForUI("Get a random amount of gold")
                                                DefaultTextColor := NamedColors.White
                                                DefaultShadowColor:= NamedColors.Black
                                        overlay_slot:
                                            Padding:= margin {Left:= 0.0, Top:= 0.0, Right:= 10.0, Bottom:= 0.0}
                                            Widget := MyUIButton3
                                            HorizontalAlignment := horizontal_alignment.Right
    CreateUI3() : canvas =
        MyUIButton : button_loud = button_loud{DefaultText := TextForMyUI}
        MyUIButton.OnClick().Subscribe(HandleSelectedUIButton)

        MyUIButton2 : button_loud = button_loud{DefaultText := TextForMyUI}
        MyUIButton2.OnClick().Subscribe(HandleSelectedUIButton2)

        MyUIButton3 : button_loud = button_loud{DefaultText := TextForMyUI}
        MyUIButton3.OnClick().Subscribe(HandleSelectedUIButton3)

        Ui3 : canvas = canvas:
            Slots:=array:
                canvas_slot: 
                    Anchors := anchors{Minimum := vector2{X := 0.4, Y := 0.6}, Maximum := vector2{X := 0.4, Y := 0.6} }
                    Offsets := margin{Top := 0.0, Left := 0.0, Right := 0.0, Bottom := 0.0}
                    Alignment := vector2{X := 0.0, Y := 0.0}
                    SizeToContent := true
                    Widget := stack_box:
                        Orientation := orientation.Vertical
                        Slots := array:
                            stack_box_slot:
                                Widget := overlay:
                                    Slots := array:
                                        overlay_slot:
                                            Widget := color_block:
                                                DefaultColor := NamedColors.Black
                                                DefaultOpacity := 1.0
                                                DefaultDesiredSize := vector2{X := 500.0, Y := 150.0}    
                                        overlay_slot:
                                            Widget := color_block:
                                                DefaultColor := NamedColors.Blue
                                                DefaultOpacity := 1.0
                                                DefaultDesiredSize := vector2{X := 495.0, Y := 145.0}                           
                                        overlay_slot:
                                            HorizontalAlignment := horizontal_alignment.Left
                                            Padding:= margin {Left:= 10.0, Top:= 0.0, Right:= 0.0, Bottom:= 0.0}
                                            Widget := text_block:
                                                DefaultText := TextForUI("Gain Health\n+150 Health")
                                                DefaultTextColor := NamedColors.White
                                                DefaultShadowColor:= NamedColors.Black
                                        overlay_slot:
                                            Padding:= margin {Left:= 0.0, Top:= 0.0, Right:= 10.0, Bottom:= 0.0}
                                            Widget := MyUIButton
                                            HorizontalAlignment := horizontal_alignment.Right
                canvas_slot: 
                    Anchors := anchors{Minimum := vector2{X := 0.4, Y := 0.4}, Maximum := vector2{X := 0.4, Y := 0.4} }
                    Offsets := margin{Top := 0.0, Left := 0.0, Right := 0.0, Bottom := 0.0}
                    Alignment := vector2{X := 0.0, Y := 0.0}
                    SizeToContent := true
                    Widget := stack_box:
                        Orientation := orientation.Vertical
                        Slots := array:
                            stack_box_slot:
                                Widget := overlay:
                                    Slots := array:
                                        overlay_slot:
                                            Widget := color_block:
                                                DefaultColor := NamedColors.Black
                                                DefaultOpacity := 1.0
                                                DefaultDesiredSize := vector2{X := 500.0, Y := 150.0}    
                                        overlay_slot:
                                            Widget := color_block:
                                                DefaultColor := NamedColors.DarkKhaki
                                                DefaultOpacity := 1.0
                                                DefaultDesiredSize := vector2{X := 495.0, Y := 145.0}                           
                                        overlay_slot:
                                            HorizontalAlignment := horizontal_alignment.Left
                                            Padding:= margin {Left:= 10.0, Top:= 0.0, Right:= 0.0, Bottom:= 0.0}
                                            Widget := text_block:
                                                DefaultText := TextForUI("Lose Health\n-95 Health")
                                                DefaultTextColor := NamedColors.White
                                                DefaultShadowColor:= NamedColors.Black
                                        overlay_slot:
                                            Padding:= margin {Left:= 0.0, Top:= 0.0, Right:= 10.0, Bottom:= 0.0}
                                            Widget := MyUIButton2
                                            HorizontalAlignment := horizontal_alignment.Right
                canvas_slot: 
                    Anchors := anchors{Minimum := vector2{X := 0.4, Y := 0.2}, Maximum := vector2{X := 0.4, Y := 0.2} }
                    Offsets := margin{Top := 0.0, Left := 0.0, Right := 0.0, Bottom := 0.0}
                    Alignment := vector2{X := 0.0, Y := 0.0}
                    SizeToContent := true
                    Widget := stack_box:
                        Orientation := orientation.Vertical
                        Slots := array:
                            stack_box_slot:
                                Widget := overlay:
                                    Slots := array:
                                        overlay_slot:
                                            Widget := color_block:
                                                DefaultColor := NamedColors.Black
                                                DefaultOpacity := 1.0
                                                DefaultDesiredSize := vector2{X := 500.0, Y := 150.0}    
                                        overlay_slot:
                                            Widget := color_block:
                                                DefaultColor := NamedColors.DarkMagenta
                                                DefaultOpacity := 1.0
                                                DefaultDesiredSize := vector2{X := 495.0, Y := 145.0}                           
                                        overlay_slot:
                                            HorizontalAlignment := horizontal_alignment.Left
                                            Padding:= margin {Left:= 10.0, Top:= 0.0, Right:= 0.0, Bottom:= 0.0}
                                            Widget := text_block:
                                                DefaultText := TextForUI("Gain Health\n+10000 Health")
                                                DefaultTextColor := NamedColors.White
                                                DefaultShadowColor:= NamedColors.Black
                                        overlay_slot:
                                            Padding:= margin {Left:= 0.0, Top:= 0.0, Right:= 10.0, Bottom:= 0.0}
                                            Widget := MyUIButton3
                                            HorizontalAlignment := horizontal_alignment.Right
    
