class QuadDamageCharger extends UDamageCharger
    placeable;

var(QuadDamage) float RespawnTime;

function SpawnPickup()
{
    Super.SpawnPickup();

    if (MyPickup != None)
        MyPickup.RespawnTime = FMax(0.0, RespawnTime);
}

defaultproperties
{
    RespawnTime=90.000000
    PowerUp=Class'QuadDamage.QuadDamagePickup'
}
