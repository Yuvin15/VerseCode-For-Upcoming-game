
using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }

# See https://dev.epicgames.com/documentation/en-us/uefn/create-your-own-device-in-verse for how to create a verse device.

# A Verse-authored creative device that can be placed in a level
NewTimerTest := class(creative_device):

    @editable 
    MainHUD : hud_message_device = hud_message_device{}
    @editable 
    StartCountdown : trigger_device = trigger_device{}
    @editable 
    StopCountdown : trigger_device = trigger_device{}
    
    @editable 
    TimerMins :int = 0
    @editable 
    TimerSec :int = 0

    var BreakLoop: logic = false

    CountdownTimerToUI<localizes>(CountdownTimerText:string)<compute>:message = "Time Left: {CountdownTimerText}"
    # Runs when the device is started in a running game
    OnBegin<override>()<suspends>:void=
        StartCountdown.TriggeredEvent.Subscribe(StartCountdownEvent)
        StopCountdown.TriggeredEvent.Subscribe(StopCountdownEvent)

    StartCountdownEvent(Agent : ?agent):void=
        spawn {OnCountdownTimer()}

    StopCountdownEvent(Agent : ?agent):void=
        set BreakLoop = true

    OnCountdownTimer()<suspends>:void=
        var Mins :int = TimerMins
        var Sec :int = TimerSec
        set BreakLoop = false
        loop:
            Sleep(1.0)
            if(Sec>=10):
                HudMessage:string = "{Mins}:{Sec}"
                MainHUD.SetText(CountdownTimerToUI(HudMessage))
            else:
                HudMessage:string = "{Mins}:0{Sec}"
                MainHUD.SetText(CountdownTimerToUI(HudMessage))
            if(Sec >=1):
                set Sec -=1
            else:
                if(Mins>0):
                    set Mins -=1
                    set Sec =59
                else:
                    set BreakLoop = true
                    OnDone()
                    # OnCountdownTimer()
            
            if(BreakLoop?):
                break

    OnDone():void=
        MainHUD.Hide()
        Print("Done", ?Duration:=6.0)
