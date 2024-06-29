using { /Fortnite.com/Characters }
using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }
using {/Fortnite.com/Game}

# See https://dev.epicgames.com/documentation/en-us/uefn/create-your-own-device-in-verse for how to create a verse device.

# A Verse-authored creative device that can be placed in a level
FreezeTag := class(creative_device):

    @editable
    ConditionalButton: conditional_button_device = conditional_button_device{}
    @editable 
    FreezeTime : float = 2.0

    OnPlayerDamaged(DamageResult: damage_result): void =
        if: 
            Instigator := DamageResult.Instigator?
            Agent := Instigator.GetInstigatorAgent[]
            ConditionalButton.IsHoldingItem[Agent]
            Target := fort_character[DamageResult.Target]

        then:
            spawn:
                FreezePlayer(Target)

    FreezePlayer(Target: fort_character)<suspends>:void =
        Target.PutInStasis(stasis_args{})
        Sleep(FreezeTime)
        Target.ReleaseFromStasis()

    # Runs when the device is started in a running game
    OnBegin<override>()<suspends>:void=
        for(Player:GetPlayspace().GetPlayers(),FortCharacter := Player.GetFortCharacter[]):
            FortCharacter.DamagedEvent().Subscribe(OnPlayerDamaged)

        # Print("Hello, world!")
        # Print("2 + 2 = {2 + 2}")
