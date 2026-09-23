class QuadDamagePickupSoundMessage extends LocalMessage;

var sound PickupSound;
var float PickupSoundVolume;

static simulated function ClientReceive(
    PlayerController P,
    optional int SwitchNum,
    optional PlayerReplicationInfo RelatedPRI_1,
    optional PlayerReplicationInfo RelatedPRI_2,
    optional Object OptionalObject)
{
    if (P != None && P.ViewTarget != None)
        P.ViewTarget.PlaySound(
            Default.PickupSound,
            SLOT_Interface,
            Default.PickupSoundVolume,
            true,
            0.0,
            1.0,
            false);
}

defaultproperties
{
    PickupSound=Sound'QuadDamage.quadramix'
    PickupSoundVolume=2.000000
}
