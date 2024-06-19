
using { /Fortnite.com/Devices }
using { /Verse.org/Random }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }

# See https://dev.epicgames.com/documentation/en-us/uefn/create-your-own-device-in-verse for how to create a verse device.

# A Verse-authored creative device that can be placed in a level
RandomUI := class(creative_device):

    @editable NewButton: button_device = button_device{}
    
    Test : []string = array{"Test1", "Test2"}
    
    OnBegin<override>()<suspends>:void=
        NewButton.InteractedWithEvent.Subscribe(OnInteracted)

    OnInteracted(Agent: agent): void=
        PlayerRand := GetRandomInt(1,Test.Length)
        # Print("Message", ?Duration:=6.0)
        Print(ToString(PlayerRand))

        if (PlayerRand = 1):

            Print("Big!", ?Duration:=6.0)
        if(PlayerRand = 2):
            Print("Small!", ?Duration:=6.0)
        
           
