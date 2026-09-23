# QuadDamage

![Quad Damage pickup](QuadDamage.png)

QuadDamage adds a true 4x damage pickup and a mutator that replaces stock Double
Damage pickups. The pickup keeps the stock 30-second timer, weapon overlay, and
respawn behavior. The collector hears `quadramix`, nearby players hear `quadramix2`,
and the final countdown uses a 0.68-second, pitch-preserved tempo compression of
`quadramix2` so each sound finishes before the next tick. The custom sounds play
substantially louder than the stock UDamage sounds. The collector cue uses a reliable,
non-overriding interface sound slot. Its mesh contains two crossed copies of
`E_Pickups.General.UDamage`.

## Use

Add `QuadDamage.MutQuadDamage` to the server's mutator list. For authored maps, place
`QuadDamage.QuadDamageCharger`. Each charger exposes `QuadDamage -> RespawnTime` in
UnrealEd and defaults to the stock UDamage interval of 90 seconds.

Servers must make `QuadDamage.u` available to clients.

## Configuration

`System/QuadDamage.ini`:

```ini
[QuadDamage.MutQuadDamage]
MinAdren=0.0
```

`MinAdren` is the minimum adrenaline required to collect Quad Damage. A successful
pickup spends that amount. At `0.0`, no adrenaline is required or spent.

## Build

From the install's `System` directory:

```bash
rm -f QuadDamage.u QuadDamage.ucl
wine ./UCC.exe make -ini="Z:\home\josh\UT2004_p23win\QuadDamage\make.ini"
wine ./UCC.exe exportcache QuadDamage.u
```
