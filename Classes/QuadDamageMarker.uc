class QuadDamageMarker extends Inventory
    notplaceable;

function ExtendDuration(float Duration)
{
    LifeSpan = FMax(LifeSpan, Duration);
}

defaultproperties
{
    bHidden=True
    bDisplayableInv=False
    RemoteRole=ROLE_None
}
