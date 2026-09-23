class QuadDamageTimer extends UDamageTimer;

function Timer()
{
    if (Pawn(Owner) == None)
    {
        Destroy();
        return;
    }

    if (SoundCount < 4)
    {
        SoundCount++;
        Pawn(Owner).PlaySound(
            Sound'QuadDamage.quadramix2_countdown',
            SLOT_None,
            2.0,
            false,
            1500.0,
            1.0);
        SetTimer(0.75, false);
        return;
    }

    Pawn(Owner).DisableUDamage();
    Destroy();
}

defaultproperties
{
}
