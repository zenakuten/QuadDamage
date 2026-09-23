class QuadDamageRules extends GameRules;

function Pawn GetQuadDamagePawn(Pawn InstigatedBy)
{
    if (Vehicle(InstigatedBy) != None && Vehicle(InstigatedBy).Driver != None)
        return Vehicle(InstigatedBy).Driver;

    return InstigatedBy;
}

function bool HasQuadDamage(Pawn InstigatedBy)
{
    local Pawn DamagePawn;

    DamagePawn = GetQuadDamagePawn(InstigatedBy);
    return DamagePawn != None
        && DamagePawn.HasUDamage()
        && DamagePawn.FindInventoryType(class'QuadDamageMarker') != None;
}

function int NetDamage(
    int OriginalDamage,
    int Damage,
    Pawn Injured,
    Pawn InstigatedBy,
    vector HitLocation,
    out vector Momentum,
    class<DamageType> DamageType)
{
    if (NextGameRules != None)
        Damage = NextGameRules.NetDamage(
            OriginalDamage,
            Damage,
            Injured,
            InstigatedBy,
            HitLocation,
            Momentum,
            DamageType);

    if (HasQuadDamage(InstigatedBy))
        Damage *= 2;

    return Damage;
}

defaultproperties
{
}
