class QuadDamagePickup extends UDamagePack
    notplaceable;

#exec OBJ LOAD FILE=PickupSkins.utx
#exec NEW STANDALONE StaticMeshFactory FILE=StaticMeshes\QuadDamage.ase NAME=QuadDamage PACKAGE=QuadDamage
#exec AUDIO IMPORT FILE=Sounds\quadramix.wav NAME=quadramix
#exec AUDIO IMPORT FILE=Sounds\quadramix2.wav NAME=quadramix2
#exec AUDIO IMPORT FILE=Sounds\quadramix2_countdown.wav NAME=quadramix2_countdown

var() float QuadDamageDuration;
var() sound WorldPickupSound;
var() float QuadSoundVolume;
var() float QuadSoundRadius;
var() sound DeniedSound;

var Pawn LastDeniedPawn;
var float LastDeniedTime;

function float GetAdrenalineCost()
{
    return FMax(0.0, class'MutQuadDamage'.default.MinAdren);
}

function bool CanAffordQuadDamage(Pawn P)
{
    local float AdrenalineCost;

    AdrenalineCost = GetAdrenalineCost();
    return AdrenalineCost <= 0.0
        || (P.Controller != None && P.Controller.Adrenaline >= AdrenalineCost);
}

function DenyQuadDamage(Pawn P)
{
    local PlayerController PC;

    PC = PlayerController(P.Controller);
    if (PC == None)
        return;

    // Touch refires every time the player lands on the base; one notice per second
    if (P == LastDeniedPawn && Level.TimeSeconds - LastDeniedTime < 1.0)
        return;

    LastDeniedPawn = P;
    LastDeniedTime = Level.TimeSeconds;

    PC.ClientPlaySound(DeniedSound);
    PC.ClientMessage("You need " $ int(GetAdrenalineCost())
        $ " adrenaline to use Quad Damage!");
}

function float BotDesireability(Pawn Bot)
{
    if (!CanAffordQuadDamage(Bot))
        return 0.0;

    return Super.BotDesireability(Bot);
}

event PostBeginPlay()
{
    local GameRules Rules;

    Super.PostBeginPlay();

    if (Role != ROLE_Authority || Level.Game == None)
        return;

    for (Rules = Level.Game.GameRulesModifiers;
        Rules != None;
        Rules = Rules.NextGameRules)
    {
        if (QuadDamageRules(Rules) != None)
            return;
    }

    Level.Game.AddGameModifier(Spawn(class'QuadDamageRules'));
}

static function StaticPrecache(LevelInfo L)
{
    L.AddPrecacheStaticMesh(StaticMesh'QuadDamage.QuadDamage');
    L.AddPrecacheMaterial(Material'XGameShaders.PlayerShaders.WeaponUDamageShader');
}

simulated function UpdatePrecacheStaticMeshes()
{
    Level.AddPrecacheStaticMesh(StaticMesh'QuadDamage.QuadDamage');
    Super.UpdatePrecacheStaticMeshes();
}

function GrantQuadDamage(Pawn P, float Duration)
{
    local QuadDamageMarker Marker;
    local xPawn XP;

    Marker = QuadDamageMarker(P.FindInventoryType(class'QuadDamageMarker'));
    if (Marker == None)
    {
        Marker = Spawn(class'QuadDamageMarker', P);
        if (Marker != None)
            Marker.GiveTo(P);
    }

    if (Marker != None && !Marker.bDeleteMe)
        Marker.ExtendDuration(Duration);

    P.EnableUDamage(Duration);

    XP = xPawn(P);
    if (XP != None && QuadDamageTimer(XP.UDamageTimer) == None)
    {
        if (XP.UDamageTimer != None)
            XP.UDamageTimer.Destroy();

        XP.UDamageTimer = Spawn(class'QuadDamageTimer', XP);
        if (XP.UDamageTimer != None)
            XP.UDamageTimer.SetTimer(
                FMax(0.01, XP.UDamageTime - Level.TimeSeconds - 3.0),
                false);
    }
}

function AnnouncePickup(Pawn Receiver)
{
    local Controller C;
    local PlayerController PC;
    local vector SoundParameters;

    Receiver.HandlePickup(self);

    PC = PlayerController(Receiver.Controller);
    if (PC != None)
        PC.ReceiveLocalizedMessage(class'QuadDamagePickupSoundMessage');

    if (Role != ROLE_Authority || Level.NetMode == NM_Standalone)
        return;

    if (!Receiver.IsLocallyControlled())
    {
        Receiver.PlayOwnedSound(
            WorldPickupSound,
            SLOT_Interact,
            QuadSoundVolume,
            false,
            QuadSoundRadius,
            1.0,
            true);
        return;
    }

    SoundParameters.X = QuadSoundVolume * 1000.0;
    SoundParameters.Y = QuadSoundRadius;
    SoundParameters.Z = 1000.0;
    for (C = Level.ControllerList; C != None; C = C.NextController)
    {
        PC = PlayerController(C);
        if (PC != None && C != Receiver.Controller)
            PC.ClientHearSound(
                Receiver,
                Rand(100000000),
                WorldPickupSound,
                Receiver.Location,
                SoundParameters,
                true);
    }
}

auto state Pickup
{
    function Touch(Actor Other)
    {
        local Pawn P;

        if (ValidTouch(Other))
        {
            P = Pawn(Other);
            if (!CanAffordQuadDamage(P))
            {
                DenyQuadDamage(P);
                return;
            }

            if (GetAdrenalineCost() > 0.0)
                P.Controller.Adrenaline = FMax(
                    0.0,
                    P.Controller.Adrenaline - GetAdrenalineCost());

            GrantQuadDamage(P, QuadDamageDuration);
            AnnouncePickup(P);
            SetRespawn();
        }
    }
}

defaultproperties
{
    QuadDamageDuration=30.000000
    WorldPickupSound=Sound'QuadDamage.quadramix2'
    QuadSoundVolume=2.000000
    QuadSoundRadius=1500.000000
    DeniedSound=Sound'MenuSounds.denied1'
    PickupMessage="QUAD DAMAGE!"
    PickupSound=Sound'QuadDamage.quadramix2'
    StaticMesh=StaticMesh'QuadDamage.QuadDamage'
}
