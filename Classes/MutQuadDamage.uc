class MutQuadDamage extends Mutator
    config(QuadDamage);

var config float MinAdren;

event PostBeginPlay()
{
    local GameRules Rules;

    Super.PostBeginPlay();

    if (bDeleteMe || Level.Game == None)
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

function bool CheckReplacement(Actor Other, out byte bSuperRelevant)
{
    bSuperRelevant = 0;

    if (Other.Class == class'XGame.UDamageCharger')
    {
        UDamageCharger(Other).PowerUp = class'QuadDamagePickup';
        return true;
    }

    if (Other.Class == class'XPickups.UDamagePack')
    {
        ReplaceWith(Other, "QuadDamage.QuadDamagePickup");
        return false;
    }

    return true;
}

defaultproperties
{
    MinAdren=0.000000
    GroupName="QuadDamage"
    FriendlyName="Quad Damage"
    Description="Replaces Double Damage pickups with Quad Damage."
    bAddToServerPackages=True
}
