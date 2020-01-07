//------------------------------------------------------------------------------
//
//  DelphiDoom: A modified and improved DOOM engine for Windows
//  based on original Linux Doom as published by "id Software"
//  Copyright (C) 1993-1996 by id Software, Inc.
//  Copyright (C) 2004-2020 by Jim Valavanis
//
//  This program is free software; you can redistribute it and/or
//  modify it under the terms of the GNU General Public License
//  as published by the Free Software Foundation; either version 2
//  of the License, or (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program; if not, write to the Free Software
//  Foundation, inc., 59 Temple Place - Suite 330, Boston, MA
//  02111-1307, USA.
//
// DESCRIPTION:
//  Sprite animation.
//  Weapon sprite animation, weapon objects.
//  Action functions for weapons.
//
//------------------------------------------------------------------------------
//  Site  : http://sourceforge.net/projects/delphidoom/
//------------------------------------------------------------------------------

{$I Doom32.inc}

unit p_pspr;

interface

uses
// Basic data types.
// Needs fixed point, and BAM angles.
  m_fixed,
  tables,
  info_h,
  p_pspr_h,
  p_mobj_h,
  d_player;

const
//
// Frame flags:
// handles maximum brightness (torches, muzzle flare, light sources)
//
  FF_FULLBRIGHT = $8000; // flag in thing->frame
  FF_FRAMEMASK = $7fff;

procedure P_DropWeapon(player: Pplayer_t);

procedure A_WeaponReady(player: Pplayer_t; psp: Ppspdef_t);

procedure A_ReFire(player: Pplayer_t; psp: Ppspdef_t);

procedure A_CheckReload(player: Pplayer_t; psp: Ppspdef_t);

procedure A_Lower(player: Pplayer_t; psp: Ppspdef_t);

procedure A_Raise(player: Pplayer_t; psp: Ppspdef_t);

procedure A_GunFlash(player: Pplayer_t; psp: Ppspdef_t);

procedure A_Punch(player: Pplayer_t; psp: Ppspdef_t);

procedure A_Saw(player: Pplayer_t; psp: Ppspdef_t);

procedure A_FireMissile(player: Pplayer_t; psp: Ppspdef_t);

procedure A_FireBFG(player: Pplayer_t; psp: Ppspdef_t);

procedure A_FirePlasma(player: Pplayer_t; psp: Ppspdef_t);

procedure A_FirePistol(player: Pplayer_t; psp: Ppspdef_t);

procedure A_FireShotgun(player: Pplayer_t; psp: Ppspdef_t);

procedure A_FireShotgun2(player: Pplayer_t; psp: Ppspdef_t);

procedure A_FireCGun(player: Pplayer_t; psp: Ppspdef_t);

procedure A_Light0(player: Pplayer_t; psp: Ppspdef_t);

procedure A_Light1(player: Pplayer_t; psp: Ppspdef_t);

procedure A_Light2(player: Pplayer_t; psp: Ppspdef_t);

procedure A_BFGSpray(mo: Pmobj_t);

procedure A_BFGsound(player: Pplayer_t; psp: Ppspdef_t);

procedure P_SetupPsprites(player: Pplayer_t);

procedure P_MovePsprites(player: Pplayer_t);

procedure P_BulletSlope(mo: Pmobj_t);

var
// plasma cells for a bfg attack
  p_bfgcells: integer = 40;


implementation

uses
  d_delphi,
  info,
//
// Needs to include the precompiled
//  sprite animation tables.
// Header generated by multigen utility.
// This includes all the data for thing animation,
// i.e. the Thing Atrributes table
// and the Frame Sequence table.
  doomdef,
  d_event,
  d_items,
  m_rnd,
  p_local,
  p_tick,
  p_mobj,
  p_enemy,
  p_map,
  p_inter,
  r_main,
  s_sound,
// State.
  doomstat,
// Data.
  sounds;

//
// Adjust weapon bottom and top
//

const
  WEAPONTOP = 32 * FRACUNIT;
  WEAPONBOTTOM = WEAPONTOP + 96 * FRACUNIT;

const
  LOWERSPEED = 6 * FRACUNIT;
  RAISESPEED = 6 * FRACUNIT;

//
// P_SetPsprite
//
procedure P_SetPsprite(player: Pplayer_t; position: integer; stnum: statenum_t);
var
  psp: Ppspdef_t;
  state: Pstate_t;
begin
  psp := @player.psprites[position];
  repeat
    if Ord(stnum) = 0 then
    begin
      // object removed itself
      psp.state := nil;
      break;
    end;

    state := @states[Ord(stnum)];
    psp.state := state;
    psp.tics := state.tics; // could be 0

    // coordinate set
    if state.misc1 <> 0 then
      psp.sx := state.misc1 * FRACUNIT;

    if state.misc2 <> 0 then
      psp.sy := state.misc2 * FRACUNIT;

    // Call action routine.
    // Modified handling.
    if Assigned(state.action.acp2) then
    begin
      state.action.acp2(player, psp);
      if psp.state = nil then
        break;
    end;

    stnum := psp.state.nextstate;

  until psp.tics <> 0;
  // an initial state of 0 could cycle through
end;

//
// P_CalcSwing
//
var
  swingx: fixed_t;
  swingy: fixed_t;

procedure P_CalcSwing(player: Pplayer_t);
var
  swing: fixed_t;
  angle: integer;
begin
  // OPTIMIZE: tablify this.
  // A LUT would allow for different modes,
  //  and add flexibility.

  swing := player.bob;

  angle := (FINEANGLES div 70 * leveltime) and FINEMASK;
  swingx := FixedMul(swing, finesine[angle]);

  angle := (FINEANGLES div 70 * leveltime + FINEANGLES div 2) and FINEMASK;
  swingy := -FixedMul(swingx, finesine[angle]);
end;

//
// P_BringUpWeapon
// Starts bringing the pending weapon up
// from the bottom of the screen.
// Uses player
//
procedure P_BringUpWeapon(player: Pplayer_t);
var
  newstate: statenum_t;
begin
  if player.pendingweapon = wp_nochange then
    player.pendingweapon := player.readyweapon;

  if player.pendingweapon = wp_chainsaw then
    S_StartSound(player.mo, Ord(sfx_sawup));

  newstate := statenum_t(weaponinfo[Ord(player.pendingweapon)].upstate);

  player.pendingweapon := wp_nochange;
  player.psprites[Ord(ps_weapon)].sy := WEAPONBOTTOM;

  P_SetPsprite(player, Ord(ps_weapon), newstate);
end;

//
// P_CheckAmmo
// Returns true if there is enough ammo to shoot.
// If not, selects the next weapon to use.
//
function P_CheckAmmo(player: Pplayer_t): boolean;
var
  ammo: ammotype_t;
  count: integer;
begin
  ammo := weaponinfo[Ord(player.readyweapon)].ammo;

  // Minimal amount for one shot varies.
  if player.readyweapon = wp_bfg then
    count := p_bfgcells
  else if player.readyweapon = wp_supershotgun then
    count := 2 // Double barrel.
  else
    count := 1; // Regular.

  // Some do not need ammunition anyway.
  // Return if current ammunition sufficient.
  if (ammo = am_noammo) or (player.ammo[Ord(ammo)] >= count) then
  begin
    result := true;
    exit;
  end;

  // Out of ammo, pick a weapon to change to.
  // Preferences are set here.
  repeat
    if (player.weaponowned[Ord(wp_plasma)] <> 0) and
       (player.ammo[Ord(am_cell)] <> 0) and
      (gamemode <> shareware) then
      player.pendingweapon := wp_plasma
    else if (player.weaponowned[Ord(wp_supershotgun)] <> 0) and
            (player.ammo[Ord(am_shell)] > 2) and
            (gamemode = commercial) then
      player.pendingweapon := wp_supershotgun
    else if (player.weaponowned[Ord(wp_chaingun)] <> 0) and
            (player.ammo[Ord(am_clip)] <> 0) then
      player.pendingweapon := wp_chaingun
    else if (player.weaponowned[Ord(wp_shotgun)] <> 0) and
            (player.ammo[Ord(am_shell)] <> 0) then
      player.pendingweapon := wp_shotgun
    else if (player.ammo[Ord(am_clip)] <> 0) then
      player.pendingweapon := wp_pistol
    else if (player.weaponowned[Ord(wp_chainsaw)] <> 0) then
      player.pendingweapon := wp_chainsaw
    else if (player.weaponowned[Ord(wp_missile)] <> 0) and
            (player.ammo[Ord(am_misl)] <> 0) then
      player.pendingweapon := wp_missile
    else if (player.weaponowned[Ord(wp_bfg)] <> 0) and
            (player.ammo[Ord(am_cell)] > p_bfgcells) and
            (gamemode <> shareware) then
      player.pendingweapon := wp_bfg
    else
      // If everything fails.
      player.pendingweapon := wp_fist;

  until not (player.pendingweapon = wp_nochange);

  // Now set appropriate weapon overlay.
  P_SetPsprite(player, Ord(ps_weapon), statenum_t(weaponinfo[Ord(player.readyweapon)].downstate));

  result := false;
end;

//
// P_FireWeapon.
//
procedure P_FireWeapon(player: Pplayer_t);
var
  newstate: statenum_t;
begin
  if P_CheckAmmo(player) then
  begin
    P_SetMobjState(player.mo, S_PLAY_ATK1);
    newstate := statenum_t(weaponinfo[Ord(player.readyweapon)].atkstate);
    P_SetPsprite(player, Ord(ps_weapon), newstate);
    P_NoiseAlert(player.mo, player.mo);
  end;
end;

//
// P_DropWeapon
// Player died, so put the weapon away.
//
procedure P_DropWeapon(player: Pplayer_t);
begin
  P_SetPsprite(player, Ord(ps_weapon), statenum_t(weaponinfo[Ord(player.readyweapon)].downstate));
end;

//
// A_WeaponReady
// The player can fire the weapon
// or change to another weapon at this time.
// Follows after getting weapon up,
// or after previous attack/fire sequence.
//
procedure A_WeaponReady(player: Pplayer_t; psp: Ppspdef_t);
var
  newstate: statenum_t;
  angle: integer;
begin
  // get out of attack state
  if (player.mo.state = @states[Ord(S_PLAY_ATK1)]) or
     (player.mo.state = @states[Ord(S_PLAY_ATK2)]) then
    P_SetMobjState(player.mo, S_PLAY);

  if (player.readyweapon = wp_chainsaw) and
     (psp.state = @states[Ord(S_SAW)]) then
    S_StartSound(player.mo, Ord(sfx_sawidl));

  // check for change
  //  if player is dead, put the weapon away
  if (player.pendingweapon <> wp_nochange) or (player.health = 0) then
  begin
    // change weapon
    //  (pending weapon should allready be validated)
    newstate := statenum_t(weaponinfo[Ord(player.readyweapon)].downstate);
    P_SetPsprite(player, Ord(ps_weapon), newstate);
    exit;
  end;

  // check for fire
  //  the missile launcher and bfg do not auto fire
  if player.cmd.buttons and BT_ATTACK <> 0 then
  begin
    if (not player.attackdown) or
       ((player.readyweapon <> wp_missile) and (player.readyweapon <> wp_bfg)) then
    begin
      player.attackdown := true;
      P_FireWeapon(player);
      exit;
    end;
  end
  else
    player.attackdown := false;

  // bob the weapon based on movement speed
  angle := (128 * leveltime) and FINEMASK;
  psp.sx := FRACUNIT + FixedMul(player.bob, finecosine[angle]);
  angle := angle and (FINEANGLES div 2 - 1);
  psp.sy := WEAPONTOP + FixedMul(player.bob, finesine[angle]);
end;

//
// A_ReFire
// The player can re-fire the weapon
// without lowering it entirely.
//
procedure A_ReFire(player: Pplayer_t; psp: Ppspdef_t);
begin
  // check for fire
  //  (if a weaponchange is pending, let it go through instead)
  if (player.cmd.buttons and BT_ATTACK <> 0) and
     (player.pendingweapon = wp_nochange) and
     (player.health > 0) then
  begin
    player.refire := player.refire + 1;
    P_FireWeapon(player);
  end
  else
  begin
    player.refire := 0;
    P_CheckAmmo(player);
  end;
end;

procedure A_CheckReload(player: Pplayer_t; psp: Ppspdef_t);
begin
  P_CheckAmmo(player);
{
#if 0
    if (player->ammo[am_shell]<2)
  P_SetPsprite (player, ps_weapon, S_DSNR1);
#endif
}
end;

//
// A_Lower
// Lowers current weapon,
//  and changes weapon at bottom.
//
procedure A_Lower(player: Pplayer_t; psp: Ppspdef_t);
begin
  psp.sy := psp.sy + LOWERSPEED;

  // Is already down.
  if psp.sy < WEAPONBOTTOM then
    exit;

  // Player is dead.
  if player.playerstate = PST_DEAD then
  begin
    psp.sy := WEAPONBOTTOM;
    // don't bring weapon back up
    exit;
  end;

  // The old weapon has been lowered off the screen,
  // so change the weapon and start raising it
  if player.health = 0 then
  begin
    // Player is dead, so keep the weapon off screen.
    P_SetPsprite(player, Ord(ps_weapon), S_NULL);
    exit;
  end;

  player.readyweapon := player.pendingweapon;

  P_BringUpWeapon(player);
end;

//
// A_Raise
//
procedure A_Raise(player: Pplayer_t; psp: Ppspdef_t);
var
  newstate: statenum_t;
begin
  psp.sy := psp.sy - RAISESPEED;

  if psp.sy > WEAPONTOP then
    exit;

  psp.sy := WEAPONTOP;

  // The weapon has been raised all the way,
  //  so change to the ready state.
  newstate := statenum_t(weaponinfo[Ord(player.readyweapon)].readystate);

  P_SetPsprite(player, Ord(ps_weapon), newstate);
end;

//
// A_GunFlash
//
procedure A_GunFlash(player: Pplayer_t; psp: Ppspdef_t);
begin
  P_SetMobjState(player.mo, S_PLAY_ATK2);
  P_SetPsprite(player, Ord(ps_flash), statenum_t(weaponinfo[Ord(player.readyweapon)].flashstate));
end;

//
// WEAPON ATTACKS
//


//
// A_Punch
//
procedure A_Punch(player: Pplayer_t; psp: Ppspdef_t);
var
  angle: angle_t;
  damage: integer;
  slope: integer;
begin
  damage := (P_Random mod 10 + 1) * 2;

  if player.powers[Ord(pw_strength)] <> 0 then
    damage := damage * 10;

  angle := player.mo.angle;
  angle := angle + _SHLW(P_Random - P_Random, 18);
  slope := P_AimLineAttack(player.mo, angle, MELEERANGE);
  P_LineAttack(player.mo, angle, MELEERANGE, slope, damage);

  // turn to face target
  if linetarget <> nil then
  begin
    S_StartSound(player.mo, Ord(sfx_punch));
    player.mo.angle :=
      R_PointToAngle2(player.mo.x, player.mo.y, linetarget.x, linetarget.y);
  end;
end;

//
// A_Saw
//
procedure A_Saw(player: Pplayer_t; psp: Ppspdef_t);
var
  angle: angle_t;
  damage: integer;
  slope: integer;
begin
  damage := 2 * (P_Random mod 10 + 1);
  angle := player.mo.angle;
  angle := angle + _SHLW(P_Random - P_Random, 18);

  // use meleerange + 1 se the puff doesn't skip the flash
  slope := P_AimLineAttack(player.mo, angle, MELEERANGE + 1);
  P_LineAttack(player.mo, angle, MELEERANGE + 1, slope, damage);

  if linetarget = nil then
  begin
    S_StartSound(player.mo, Ord(sfx_sawful));
    exit;
  end;

  S_StartSound(player.mo, Ord(sfx_sawhit));

  // turn to face target
  angle :=
    R_PointToAngle2(player.mo.x, player.mo.y, linetarget.x, linetarget.y);
  if angle - player.mo.angle > ANG180 then
  begin
    if integer(angle - player.mo.angle) < - integer(ANG90 div 20) then
      player.mo.angle := angle + ANG90 div 21
    else
      player.mo.angle := player.mo.angle - ANG90 div 20;
  end
  else
  begin
    if angle - player.mo.angle > ANG90 div 20 then
      player.mo.angle := angle - ANG90 div 21
    else
      player.mo.angle := player.mo.angle + ANG90 div 20;
  end;

  player.mo.flags := player.mo.flags or MF_JUSTATTACKED;
end;

//
// A_FireMissile
//
procedure A_FireMissile(player: Pplayer_t; psp: Ppspdef_t);
begin
  player.ammo[Ord(weaponinfo[Ord(player.readyweapon)].ammo)] :=
    player.ammo[Ord(weaponinfo[Ord(player.readyweapon)].ammo)] - 1;
  P_SpawnPlayerMissile(player.mo, Ord(MT_ROCKET));
end;

//
// A_FireBFG
//
procedure A_FireBFG(player: Pplayer_t; psp: Ppspdef_t);
begin
  player.ammo[Ord(weaponinfo[Ord(player.readyweapon)].ammo)] :=
    player.ammo[Ord(weaponinfo[Ord(player.readyweapon)].ammo)] - p_bfgcells;
  P_SpawnPlayerMissile(player.mo, Ord(MT_BFG));
end;

//
// A_FirePlasma
//
procedure A_FirePlasma(player: Pplayer_t; psp: Ppspdef_t);
begin
  player.ammo[Ord(weaponinfo[Ord(player.readyweapon)].ammo)] :=
    player.ammo[Ord(weaponinfo[Ord(player.readyweapon)].ammo)] - 1;

  P_SetPsprite(player,
    Ord(ps_flash), statenum_t(weaponinfo[Ord(player.readyweapon)].flashstate + (P_Random and 1)));

  P_SpawnPlayerMissile(player.mo, Ord(MT_PLASMA));
end;

//
// P_BulletSlope
// Sets a slope so a near miss is at aproximately
// the height of the intended target
//
var
  bulletslope: fixed_t;


procedure P_BulletSlope(mo: Pmobj_t);
var
  an: angle_t;
begin
  // see which target is to be aimed at
  an := mo.angle;
  bulletslope := P_AimLineAttack(mo, an, 16 * 64 * FRACUNIT);

  if linetarget = nil then
  begin
    an := an + $4000000;
    bulletslope := P_AimLineAttack(mo, an, 16 * 64 * FRACUNIT);
    if linetarget = nil then
    begin
      an := an - $8000000;
      bulletslope := P_AimLineAttack(mo, an, 16 * 64 * FRACUNIT);
      if zaxisshift and (linetarget = nil) then
        bulletslope := (Pplayer_t(mo.player).lookdir * FRACUNIT) div 173;
    end;
  end;
end;

//
// P_GunShot
//
procedure P_GunShot(mo: Pmobj_t; accurate: boolean);
var
  angle: angle_t;
  damage: integer;
begin
  damage := 5 * ((P_Random mod 3) + 1);
  angle := mo.angle;

  if not accurate then
    angle := angle + _SHLW(P_Random - P_Random, 18);

  P_LineAttack(mo, angle, MISSILERANGE, bulletslope, damage);
end;

//
// A_FirePistol
//
procedure A_FirePistol(player: Pplayer_t; psp: Ppspdef_t);
var
  am: integer;
begin
  S_StartSound(player.mo, Ord(sfx_pistol));

  P_SetMobjState(player.mo, S_PLAY_ATK2);

  am := Ord(weaponinfo[Ord(player.readyweapon)].ammo);
  player.ammo[am] := player.ammo[am] - 1;

  P_SetPsprite(player, Ord(ps_flash), statenum_t(weaponinfo[Ord(player.readyweapon)].flashstate));

  P_BulletSlope(player.mo);
  P_GunShot(player.mo, player.refire = 0);
end;

//
// A_FireShotgun
//
procedure A_FireShotgun(player: Pplayer_t; psp: Ppspdef_t);
var
  i: integer;
  am: integer;
begin
  S_StartSound(player.mo, Ord(sfx_shotgn));
  P_SetMobjState(player.mo, S_PLAY_ATK2);

  am := Ord(weaponinfo[Ord(player.readyweapon)].ammo);
  player.ammo[am] := player.ammo[am] - 1;

  P_SetPsprite(player, Ord(ps_flash), statenum_t(weaponinfo[Ord(player.readyweapon)].flashstate));

  P_BulletSlope(player.mo);

  for i := 0 to 6 do
    P_GunShot(player.mo, false);
end;

//
// A_FireShotgun2
//
procedure A_FireShotgun2(player: Pplayer_t; psp: Ppspdef_t);
var
  i: integer;
  angle: angle_t;
  damage: integer;
  am: integer;
begin
  S_StartSound(player.mo, Ord(sfx_dshtgn));
  P_SetMobjState(player.mo, S_PLAY_ATK2);

  am := Ord(weaponinfo[Ord(player.readyweapon)].ammo);
  player.ammo[am] := player.ammo[am] - 2;

  P_SetPsprite(player, Ord(ps_flash), statenum_t(weaponinfo[Ord(player.readyweapon)].flashstate));

  P_BulletSlope(player.mo);

  for i := 0 to 19 do
  begin
    damage := 5 * ((P_Random mod 3) + 1);
    angle := player.mo.angle;
    angle := angle + _SHLW(P_Random - P_Random, 19);
    P_LineAttack(player.mo, angle, MISSILERANGE,
      bulletslope + _SHL(P_Random - P_Random, 5), damage);
  end;
end;

//
// A_FireCGun
//
procedure A_FireCGun(player: Pplayer_t; psp: Ppspdef_t);
var
  am : integer;
begin
  S_StartSound(player.mo, Ord(sfx_pistol));

  if player.ammo[Ord(weaponinfo[Ord(player.readyweapon)].ammo)] = 0 then
    exit;

  P_SetMobjState(player.mo, S_PLAY_ATK2);

  am := Ord(weaponinfo[Ord(player.readyweapon)].ammo);
  player.ammo[am] := player.ammo[am] - 1;

  P_SetPsprite(player, Ord(ps_flash),
    statenum_t(
      weaponinfo[Ord(player.readyweapon)].flashstate +
      pDiff(psp.state, @states[Ord(S_CHAIN1)], SizeOf(state_t))
    ));

  P_BulletSlope(player.mo);

  P_GunShot(player.mo, player.refire = 0);
end;

//
// ?
//
procedure A_Light0(player: Pplayer_t; psp: Ppspdef_t);
begin
  player.extralight := 0;
end;

procedure A_Light1(player: Pplayer_t; psp: Ppspdef_t);
begin
  player.extralight := 1;
end;

procedure A_Light2(player: Pplayer_t; psp: Ppspdef_t);
begin
  player.extralight := 2;
end;

//
// A_BFGSpray
// Spawn a BFG explosion on every monster in view
//
procedure A_BFGSpray(mo: Pmobj_t);
var
  i: integer;
  j: integer;
  damage: integer;
  an: angle_t;
  dan: angle_t;
begin
  // offset angles from its attack angle
{ JVAL -> original code was: ---------------
  for i := 0 to 39 do
  begin
    an := mo.angle - ANG90 div 2 + (ANG90 div 40) * i;
-----------------}
  an := mo.angle - ANG90 div 2;
  dan := ANG90 div 40;
  for i := 0 to 39 do
  begin
    an := an + dan;

    // mo->target is the originator (player)
    //  of the missile
    P_AimLineAttack(mo.target, an, 16 * 64 * FRACUNIT);

    if linetarget = nil then
      continue;

    P_SpawnMobj(
      linetarget.x, linetarget.y, linetarget.z + _SHR(linetarget.height, 2), Ord(MT_EXTRABFG));

    damage := 0;
    for j := 0 to 14 do
      damage := damage + (P_Random and 7) + 1;

    P_DamageMobj(linetarget, mo.target, mo.target, damage);
  end;
end;

//
// A_BFGsound
//
procedure A_BFGsound(player: Pplayer_t; psp: Ppspdef_t);
begin
  S_StartSound(player.mo, Ord(sfx_bfg));
end;

//
// P_SetupPsprites
// Called at start of level for each player.
//
procedure P_SetupPsprites(player: Pplayer_t);
var
  i: integer;
begin
  // remove all psprites
  for i := 0 to Ord(NUMPSPRITES) - 1 do
    player.psprites[i].state := nil;

  // spawn the gun
  player.pendingweapon := player.readyweapon;
  P_BringUpWeapon(player);
end;

//
// P_MovePsprites
// Called every tic by player thinking routine.
//
procedure P_MovePsprites(player: Pplayer_t);
var
  i: integer;
  psp: Ppspdef_t;
  state: Pstate_t;
begin
  for i := 0 to Ord(NUMPSPRITES) - 1 do
  begin
    psp := @player.psprites[i];
    // a null state means not active
    state := psp.state;
    if state <> nil then
    begin
      // drop tic count and possibly change state
      // a -1 tic count never changes
      if psp.tics <> -1 then
      begin
        psp.tics := psp.tics - 1;
        if psp.tics = 0 then
          P_SetPsprite(player, i, psp.state.nextstate);
      end;
    end;
  end;

  player.psprites[Ord(ps_flash)].sx := player.psprites[Ord(ps_weapon)].sx;
  player.psprites[Ord(ps_flash)].sy := player.psprites[Ord(ps_weapon)].sy;
end;

end.
