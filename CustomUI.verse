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
    ButtonUI:button_device = button_device{}

    TextForMyUI<localizes> : message = "Center"
    # Runs when the device is started in a running game
    OnBegin<override>()<suspends>:void=
        # TODO: Replace this with your code
        ButtonUI.InteractedWithEvent.Subscribe(OnInteracted)
    
    CreateUI() : canvas =
        NewCanvas : canvas = canvas:
            Slots:=array:
                canvas_slot: # Upper Middle of Screen
                    Anchors := anchors{Minimum := vector2{X := 0.5, Y := 0.1}, Maximum := vector2{X := 0.5, Y := 0.1} }
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
                                            Widget := overlay:
                                                Slots := array:
                                                    overlay_slot:
                                                        Widget := color_block:
                                                            DefaultColor := NamedColors.Red
                                                            DefaultOpacity := 1.0
                                                            DefaultDesiredSize := vector2{X := 120.0, Y := 50.0}                                
                                                    overlay_slot:
                                                        Widget := text_block:
                                                            DefaultText := TextForUI("Flags: 0")                            
                                        overlay_slot:
                                            Widget := text_block:
                                                DefaultText := TextForUI("Flags: 0")
                            stack_box_slot:
                                Widget := overlay:
                                    Slots := array:
                                        overlay_slot:
                                            Widget := color_block:
                                                DefaultColor := NamedColors.Blue
                                                DefaultOpacity := 1.0
                                                DefaultDesiredSize := vector2{X := 120.0, Y := 50.0}                                
                                        overlay_slot:
                                            Widget := text_block:
                                                DefaultText := TextForUI("Flags: 0")
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

    OnInteracted(Agent : agent ) : void = 
        if(Player := player[Agent], PlayerUI := GetPlayerUI[Player]):
            NewUI : canvas = CreateUI()
            PlayerUI.AddWidget(NewUI)
             Print("Hi", ?Duration:=6.0)