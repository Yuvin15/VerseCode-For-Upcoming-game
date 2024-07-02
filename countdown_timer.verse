using { /UnrealEngine.com/Temporary/Diagnostics }

using { /UnrealEngine.com/Temporary/UI }

using { /UnrealEngine.com/Temporary/SpatialMath }

using { /Verse.org/Simulation }
using { /Verse.org/Colors }
using { /Fortnite.com/UI }

 

MakeCountdownTimer<constructor><public>(MaxTime : float, InPlayer : agent) := countdown_timer:

    RemainingTime := MaxTime

    MaybePlayerUI := option{GetPlayerUI[player[InPlayer]]} 

countdown_timer := class:
    <# This block runs for each instance of the countdown_timer class.
    We can setup the canvas once here. #>
    block:

        set Canvas = canvas:

            Slots := array:

                canvas_slot:
                    Anchors := anchors:
                        Minimum := vector2{X := 0.42, Y := 0.05}
                        Maximum := vector2{X := 0.42, Y := 0.05}
                    Alignment := vector2{X := 0.0, Y := 0.0 }
                    Offsets := margin{Top := 0.0, Left := 0.0, Bottom := 0.0, Right := 0.0}
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
                                                DefaultDesiredSize := vector2{X := 350.0, Y := 50.0}    
                                        overlay_slot:
                                            Widget := color_block:
                                                DefaultColor := NamedColors.PaleGoldenrod
                                                DefaultOpacity := 1.0
                                                DefaultDesiredSize := vector2{X := 345.0, Y := 45.0}                           
                                        overlay_slot:      
                                                Widget := RemainingTimeTextBlock 
    CountdownEndedEvent<public> : event(float) = event(float){}
    StartCountdown<public>() : void =
        if (PlayerUI := MaybePlayerUI?):
            PlayerUI.AddWidget(Canvas)
            # Update the UI when we start the timer to see the initial RemainingTime on screen
            UpdateUI()
            spawn:
                RunCountdown()

    
    MaybePlayerUI<internal> : ?player_ui = false

    var RemainingTime<internal> : float = 0.0

    RemainingTimeTextBlock<private> : text_block = text_block{DefaultTextColor := NamedColors.Black} 
    RemainingTimeText<localizes><private>(CurrentRemainingTime : int) : message = "Time remaining: {CurrentRemainingTime}"

    AddedTimeText<localizes><private>(AddedTime : int) : message = " +{AddedTime}!"

    var Canvas<private> : canvas = canvas{}

    var TotalTime<private> : float = 0.0

    # The timer "precision": how often, in seconds, it ticks.

    TimerTickPeriod<private> : float = 1.0
    RunCountdown<private>()<suspends> : void =
        # We loop with the TimerTickPeriod.
        # The UI is also updated each time.
        loop:
            Sleep(TimerTickPeriod)
            set TotalTime += TimerTickPeriod
            set RemainingTime -= TimerTickPeriod
            UpdateUI()
            # Timer End
            if (RemainingTime <= 0.0):
                Canvas.RemoveWidget(RemainingTimeTextBlock)
                 if (UI := MaybePlayerUI?):
                     UI.RemoveWidget(Canvas)
                CountdownEndedEvent.Signal(TotalTime)
                break

    UpdateUI<private>() : void =
        if (IntTime := Int[RemainingTime]):
            RemainingTimeTextBlock.SetText(RemainingTimeText(IntTime))
