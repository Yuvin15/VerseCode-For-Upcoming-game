using { /Fortnite.com/UI }
using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /UnrealEngine.com/Temporary/UI }
using { /Verse.org/Colors }
using { /UnrealEngine.com/Temporary/SpatialMath }

# See https://dev.epicgames.com/documentation/en-us/uefn/create-your-own-device-in-verse for how to create a verse device.

# A Verse-authored creative device that can be placed in a level
CustomUI := class(creative_device):

    TextForUI<localizes>(InText : string) : message = "{InText}"
    
    @editable
    StartingScoreRed:int = 0
    
    @editable
    StartingScoreBlue:int = 0

    @editable
    AddOnCapture:int = 1

    var RedFlags:int = 0
    var BlueFlags:int = 0

    @editable
    StartingUI:item_granter_device = item_granter_device{}

    @editable
    ButtonUI:button_device = button_device{}

    @editable
    BlueFlagArea:capture_area_device = capture_area_device{} 

    @editable
    RedFlagArea:capture_area_device = capture_area_device{} 

    TextForMyUI<localizes> : message = "Center"
    # Runs when the device is started in a running game
    OnBegin<override>()<suspends>:void=
        # TODO: Replace this with your code
        StartingUI.ItemGrantedEvent.Subscribe(ItemGranted)
        ButtonUI.InteractedWithEvent.Subscribe(OnInteracted)
        BlueFlagArea.ItemIsDeliveredEvent.Subscribe(RedFlagStolen)
        RedFlagArea.ItemIsDeliveredEvent.Subscribe(BlueFlagStolen)

    CreateUI() : canvas =
        NewCanvas : canvas = canvas:
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
                                                DefaultText := TextForUI("Flags: {BlueFlags}")
                                                DefaultTextColor := NamedColors.White
                                                DefaultShadowColor:= NamedColors.Black
                            
                            stack_box_slot:
                                Widget := overlay:
                                    Slots := array:
                                        overlay_slot:
                                            Widget := overlay:
                                                Slots := array:
                                                    overlay_slot:
                                                        Widget := color_block:
                                                            DefaultColor := NamedColors.Black
                                                            DefaultOpacity := 1.0
                                                            DefaultDesiredSize := vector2{X := 400.0, Y := 100.0}
                                                    overlay_slot:
                                                        Widget := color_block:
                                                            DefaultColor := NamedColors.Magenta
                                                            DefaultOpacity := 1.0
                                                            DefaultDesiredSize := vector2{X := 395.0, Y := 95.0}                                
                                                    overlay_slot:
                                                        Widget := text_block:
                                                            DefaultShadowColor:= NamedColors.Black
                                                            DefaultText := TextForUI("Collect 3 flags to win!")                               
                            stack_box_slot:
                                Widget := overlay:
                                    Slots := array:
                                        overlay_slot:
                                            Widget := color_block:
                                                DefaultColor := NamedColors.Black
                                                DefaultOpacity := 1.0
                                                DefaultDesiredSize := vector2{X := 200.0, Y := 50.0}
                                        overlay_slot:
                                            Widget := overlay:
                                                Slots := array:
                                                    overlay_slot:
                                                        Widget := color_block:
                                                            DefaultColor := NamedColors.Red
                                                            DefaultOpacity := 1.0
                                                            DefaultDesiredSize := vector2{X := 195.0, Y := 45.0}                                
                                                    overlay_slot:
                                                        Widget := text_block:
                                                            DefaultText := TextForUI("Flags: {RedFlags}")
                                                            DefaultTextColor := NamedColors.White
                                                            DefaultShadowColor:= NamedColors.Black                      
                                        # overlay_slot:
                                        #     Widget := text_block:
                                        #         DefaultText := TextForUI("Flags: {RedFlags}")
                                                
                            # stack_box_slot:
                            #     Widget := color_block:
                            #         DefaultColor := NamedColors.White
                            #         DefaultOpacity := 1.0
                            #         DefaultDesiredSize := vector2{X := 120.0, Y := 50.0}

                # canvas_slot: # Upper Middle of Screen
                #     Anchors := anchors{Minimum := vector2{X := 0.5, Y := 0.1}, Maximum := vector2{X := 0.5, Y := 0.1} }
                #     Offsets := margin{Top := 0.0, Left := 0.0, Right := 0.0, Bottom := 0.0}
                #     Alignment := vector2{X := 0.0, Y := 0.0}
                #     SizeToContent := true
                #     Widget := overlay:
                #         Slots := array:
                #             overlay_slot:
                #                 Widget := color_block:
                #                     DefaultColor := NamedColors.Red
                #                     DefaultOpacity := 1.0
                #                     DefaultDesiredSize := vector2{X := 120.0, Y := 50.0}                                
                #             overlay_slot:
                #                 Widget := text_block:
                #                     DefaultText := TextForUI("Flags: 0")
    
    ItemGranted(Agent : agent ) : void =
        if(Player := player[Agent], PlayerUI := GetPlayerUI[Player]):
            # set RedFlags += StartingScoreRed + AddOnCapture
            # set BlueFlags += StartingScoreBlue + AddOnCapture
            RefreshUI(PlayerUI)

            Print("UI Added", ?Duration := 6.0)

    RefreshUI(PlayerUI : player_ui) : void =
        NewUI : canvas = CreateUI()
            PlayerUI.RemoveWidget(NewUI)
            PlayerUI.AddWidget(NewUI)

    RedFlagStolen(Agent : agent ) : void =
        if(Player := player[Agent], PlayerUI := GetPlayerUI[Player]):
            set BlueFlags += StartingScoreBlue + AddOnCapture
            RefreshUI(PlayerUI)

            Print("Flags updated", ?Duration := 6.0)

    BlueFlagStolen(Agent : agent ) : void =
        if(Player := player[Agent], PlayerUI := GetPlayerUI[Player]):
            set RedFlags += StartingScoreRed + AddOnCapture
            RefreshUI(PlayerUI)

            Print("Flags updated", ?Duration := 6.0)
            
    OnInteracted(Agent : agent ) : void =
        if(Player := player[Agent], PlayerUI := GetPlayerUI[Player]):
            set RedFlags += StartingScoreRed + AddOnCapture
            set BlueFlags += StartingScoreBlue + AddOnCapture
            RefreshUI(PlayerUI)

            Print("Flags updated", ?Duration := 6.0)
