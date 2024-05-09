
using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /Fortnite.com/Characters }
using { /UnrealEngine.com/Temporary/Diagnostics }

# See https://dev.epicgames.com/documentation/en-us/uefn/create-your-own-device-in-verse for how to create a verse device.

# A Verse-authored creative device that can be placed in a level
ConditionalButtonHealth := class(creative_device):

    # Runs when the device is started in a running game
    @editable 
    Button: button_device = button_device{}

    @editable 
    ConButton: conditional_button_device = conditional_button_device:

    increaseHealth:float = 150.0 

    # Runs when the device is started in a running game
    OnBegin<override>()<suspends>:void=
        # Button.InteractedWithEvent.Subscribe(OnInteracted)
        ConButton.ActivatedEvent.Subscribe(Activate)

    # Set max health of the instigator to 150 
    Activate(Agent: agent): void=
        if (FortChar:= Agent.GetFortCharacter[]):
            current_health: float = FortChar.GetHealth()
            FortChar.SetMaxHealth(current_health + increaseHealth)
            Print("ConButtonWorking", ?Duration:=1.0)