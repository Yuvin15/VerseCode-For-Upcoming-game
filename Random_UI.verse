using { /Fortnite.com/UI }
using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /UnrealEngine.com/Temporary/UI }
using { /Verse.org/Colors }
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /Verse.org/Random }

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

    Test : []string = array{"UI1", "UI2", "UI3"}

    # Runs when the device is started in a running game
    OnBegin<override>()<suspends>:void=
        # TODO: Replace this with your code
        StartButton.InteractedWithEvent.Subscribe(OnInteracted)
        ItemGranterUI1.ItemGrantedEvent.Subscribe(ItemGrantedForUI1)
        ItemGranterUI2.ItemGrantedEvent.Subscribe(ItemGrantedForUI2)
        ItemGranterUI3.ItemGrantedEvent.Subscribe(ItemGrantedForUI3)

    OnInteracted(Agent : agent ) : void = 
        PlayerRand := GetRandomInt(1,Test.Length)
            Print(ToString(PlayerRand))
            if (PlayerRand = "UI1"):
                ItemGranterUI1.GrantItem(Agent)
                Print("UI1", ?Duration:=6.0)
            if(PlayerRand = "UI2"):
                ItemGranterUI2.GrantItem(Agent)
                Print("UI2", ?Duration:=6.0)
            if(PlayerRand = "UI3"):
                ItemGranterUI3.GrantItem(Agent)
                Print("UI3", ?Duration:=6.0)
            
    ItemGrantedForUI1(Agent : agent ) : void =
        if(Player := player[Agent], PlayerUI := GetPlayerUI[Player]):
            Ui1 : canvas = CreateUI1()
            PlayerUI.AddWidget(Ui1)
            Print("UI1 Added", ?Duration := 6.0)

    ItemGrantedForUI2(Agent : agent ) : void =
        if(Player := player[Agent], PlayerUI := GetPlayerUI[Player]):
            Ui2 : canvas = CreateUI2()
            PlayerUI.AddWidget(Ui2)
            Print("UI2 Added", ?Duration := 6.0)

    ItemGrantedForUI3(Agent : agent ) : void =
        if(Player := player[Agent], PlayerUI := GetPlayerUI[Player]):
            Ui3 : canvas = CreateUI3()
            PlayerUI.AddWidget(Ui3)
            Print("UI3 Added", ?Duration := 6.0)
        
    
    CreateUI1() : canvas =
        Ui1 : canvas = canvas:
            Slots:=array:
                canvas_slot: # Upper Middle of Screen
                    Anchors := anchors{Minimum := vector2{X := 0.3, Y := 0.1}, Maximum := vector2{X := 0.3, Y := 0.1} }
                    Offsets := margin{Top := 0.0, Left := 0.0, Right := 0.0, Bottom := 0.0}
                    Alignment := vector2{X := 0.0, Y := 0.0}
                    SizeToContent := true
                    Widget := stack_box:
                        Orientation := orientation.Horizontal
                        Slots := array:
                            stack_box_slot:
                                Widget := overlay:
                                    Slots := array:
                                        overlay_slot:
                                            Widget := color_block:
                                                DefaultColor := NamedColors.Black
                                                DefaultOpacity := 1.0
                                                DefaultDesiredSize := vector2{X := 200.0, Y := 50.0}    
                                        overlay_slot:
                                            Widget := color_block:
                                                DefaultColor := NamedColors.Blue
                                                DefaultOpacity := 1.0
                                                DefaultDesiredSize := vector2{X := 195.0, Y := 45.0}                           
                                        overlay_slot:
                                            Widget := text_block:
                                                DefaultText := TextForUI("UI1")
                                                DefaultTextColor := NamedColors.White
                                                DefaultShadowColor:= NamedColors.Black
    CreateUI2() : canvas =
        UI2 : canvas = canvas:
            Slots:=array:
                canvas_slot: # Upper Middle of Screen
                    Anchors := anchors{Minimum := vector2{X := 0.3, Y := 0.1}, Maximum := vector2{X := 0.3, Y := 0.1} }
                    Offsets := margin{Top := 0.0, Left := 0.0, Right := 0.0, Bottom := 0.0}
                    Alignment := vector2{X := 0.0, Y := 0.0}
                    SizeToContent := true
                    Widget := stack_box:
                        Orientation := orientation.Horizontal
                        Slots := array:
                            stack_box_slot:
                                Widget := overlay:
                                    Slots := array:
                                        overlay_slot:
                                            Widget := color_block:
                                                DefaultColor := NamedColors.Black
                                                DefaultOpacity := 1.0
                                                DefaultDesiredSize := vector2{X := 200.0, Y := 50.0}    
                                        overlay_slot:
                                            Widget := color_block:
                                                DefaultColor := NamedColors.DarkGreen
                                                DefaultOpacity := 1.0
                                                DefaultDesiredSize := vector2{X := 195.0, Y := 45.0}                           
                                        overlay_slot:
                                            Widget := text_block:
                                                DefaultText := TextForUI("UI2")
                                                DefaultTextColor := NamedColors.White
                                                DefaultShadowColor:= NamedColors.Black
    CreateUI3() : canvas =
        UI3 : canvas = canvas:
            Slots:=array:
                canvas_slot: # Upper Middle of Screen
                    Anchors := anchors{Minimum := vector2{X := 0.3, Y := 0.1}, Maximum := vector2{X := 0.3, Y := 0.1} }
                    Offsets := margin{Top := 0.0, Left := 0.0, Right := 0.0, Bottom := 0.0}
                    Alignment := vector2{X := 0.0, Y := 0.0}
                    SizeToContent := true
                    Widget := stack_box:
                        Orientation := orientation.Horizontal
                        Slots := array:
                            stack_box_slot:
                                Widget := overlay:
                                    Slots := array:
                                        overlay_slot:
                                            Widget := color_block:
                                                DefaultColor := NamedColors.Black
                                                DefaultOpacity := 1.0
                                                DefaultDesiredSize := vector2{X := 200.0, Y := 50.0}    
                                        overlay_slot:
                                            Widget := color_block:
                                                DefaultColor := NamedColors.Purple  
                                                DefaultOpacity := 1.0
                                                DefaultDesiredSize := vector2{X := 195.0, Y := 45.0}                           
                                        overlay_slot:
                                            Widget := text_block:
                                                DefaultText := TextForUI("UI3")
                                                DefaultTextColor := NamedColors.White
                                                DefaultShadowColor:= NamedColors.Black
    
        
