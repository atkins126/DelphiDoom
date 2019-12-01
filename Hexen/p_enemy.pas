//------------------------------------------------------------------------------
//
//  DelphiHexen: A modified and improved Hexen port for Windows
//  based on original Linux Doom as published by "id Software", on
//  Hexen source as published by "Raven" software and DelphiDoom
//  as published by Jim Valavanis.
//  Copyright (C) 2004-2017 by Jim Valavanis
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
//  Enemy thinking, AI.
//  Action Pointer Functions
//  that are associated with states/frames.
//
//------------------------------------------------------------------------------
//  E-Mail: jimmyvalavanis@yahoo.gr
//  Site  : http://sourceforge.net/projects/delphidoom/
//------------------------------------------------------------------------------

{$I Doom32.inc}

unit p_enemy;

interface

uses
  p_mobj_h,
  tables;

function P_Massacre: integer;

procedure P_NewChaseDir(actor: Pmobj_t);

procedure P_NoiseAlert(target: Pmobj_t; emmiter: Pmobj_t);

procedure A_Look(actor: Pmobj_t);

procedure A_Chase(actor: Pmobj_t);

procedure A_FaceTarget(actor: Pmobj_t);

procedure A_Pain(actor: Pmobj_t);

procedure A_SetReflective(actor: Pmobj_t);

procedure A_UnSetReflective(actor: Pmobj_t);

procedure A_PigLook(actor: Pmobj_t);

procedure A_PigChase(actor: Pmobj_t);

procedure A_PigAttack(actor: Pmobj_t);

procedure A_PigPain(actor: Pmobj_t);

procedure FaceMovementDirection(actor: Pmobj_t);

procedure A_MinotaurFade0(actor: Pmobj_t);

procedure A_MinotaurFade1(actor: Pmobj_t);

procedure A_MinotaurFade2(actor: Pmobj_t);

procedure A_MinotaurLook(actor: Pmobj_t);

procedure A_MinotaurRoam(actor: Pmobj_t);

procedure A_MinotaurChase(actor: Pmobj_t);

procedure A_MinotaurAtk1(actor: Pmobj_t);

procedure A_MinotaurDecide(actor: Pmobj_t);

procedure A_MinotaurCharge(actor: Pmobj_t);

procedure A_MinotaurAtk2(actor: Pmobj_t);

procedure A_MinotaurAtk3(actor: Pmobj_t);

procedure A_MntrFloorFire(actor: Pmobj_t);

procedure A_Scream(actor: Pmobj_t);

procedure A_Explode(actor: Pmobj_t);

procedure A_SkullPop(actor: Pmobj_t);

procedure A_CheckSkullFloor(actor: Pmobj_t);

procedure A_CheckSkullDone(actor: Pmobj_t);

procedure A_CheckBurnGone(actor: Pmobj_t);

procedure A_FreeTargMobj(mo: Pmobj_t);

procedure A_QueueCorpse(actor: Pmobj_t);

procedure A_DeQueueCorpse(actor: Pmobj_t);

procedure P_InitCreatureCorpseQueue(corpseScan: boolean);

procedure A_AddPlayerCorpse(actor: Pmobj_t);

procedure A_SerpentUnHide(actor: Pmobj_t);

procedure A_SerpentHide(actor: Pmobj_t);

procedure A_SerpentChase(actor: Pmobj_t);

procedure A_SerpentRaiseHump(actor: Pmobj_t);

procedure A_SerpentLowerHump(actor: Pmobj_t);

procedure A_SerpentHumpDecide(actor: Pmobj_t);

procedure A_SerpentBirthScream(actor: Pmobj_t);

procedure A_SerpentDiveSound(actor: Pmobj_t);

procedure A_SerpentWalk(actor: Pmobj_t);

procedure A_SerpentCheckForAttack(actor: Pmobj_t);

procedure A_SerpentChooseAttack(actor: Pmobj_t);

procedure A_SerpentMeleeAttack(actor: Pmobj_t);

procedure A_SerpentMissileAttack(actor: Pmobj_t);

procedure A_SerpentHeadPop(actor: Pmobj_t);

procedure A_SerpentSpawnGibs(actor: Pmobj_t);

procedure A_FloatGib(actor: Pmobj_t);

procedure A_SinkGib(actor: Pmobj_t);

procedure A_DelayGib(actor: Pmobj_t);

procedure A_SerpentHeadCheck(actor: Pmobj_t);

procedure A_CentaurAttack(actor: Pmobj_t);

procedure A_CentaurAttack2(actor: Pmobj_t);

procedure A_CentaurDropStuff(actor: Pmobj_t);

procedure A_CentaurDefend(actor: Pmobj_t);

procedure A_BishopAttack(actor: Pmobj_t);

procedure A_BishopAttack2(actor: Pmobj_t);

procedure A_BishopMissileWeave(actor: Pmobj_t);

procedure A_BishopMissileSeek(actor: Pmobj_t);

procedure A_BishopDecide(actor: Pmobj_t);

procedure A_BishopDoBlur(actor: Pmobj_t);

procedure A_BishopSpawnBlur(actor: Pmobj_t);

procedure A_BishopChase(actor: Pmobj_t);

procedure A_BishopPuff(actor: Pmobj_t);

procedure A_BishopPainBlur(actor: Pmobj_t);

procedure DragonSeek(actor: Pmobj_t; thresh: angle_t; turnMax: angle_t);

procedure A_DragonInitFlight(actor: Pmobj_t);

procedure A_DragonFlight(actor: Pmobj_t);

procedure A_DragonFlap(actor: Pmobj_t);

procedure A_DragonAttack(actor: Pmobj_t);

procedure A_DragonFX2(actor: Pmobj_t);

procedure A_DragonPain(actor: Pmobj_t);

procedure A_DragonCheckCrash(actor: Pmobj_t);

procedure A_DemonAttack1(actor: Pmobj_t);

procedure A_DemonAttack2(actor: Pmobj_t);

procedure A_DemonDeath(actor: Pmobj_t);

procedure A_Demon2Death(actor: Pmobj_t);

procedure A_WraithInit(actor: Pmobj_t);

procedure A_WraithRaiseInit(actor: Pmobj_t);

procedure A_WraithRaise(actor: Pmobj_t);

procedure A_WraithMelee(actor: Pmobj_t);

procedure A_WraithMissile(actor: Pmobj_t);

procedure A_WraithFX2(actor: Pmobj_t);

procedure A_WraithFX3(actor: Pmobj_t);

procedure A_WraithFX4(actor: Pmobj_t);

procedure A_WraithLook(actor: Pmobj_t);

procedure A_WraithChase(actor: Pmobj_t);

procedure A_EttinAttack(actor: Pmobj_t);

procedure A_DropMace(actor: Pmobj_t);

procedure A_FiredSpawnRock(actor: Pmobj_t);

procedure A_FiredRocks(actor: Pmobj_t);

procedure A_FiredAttack(actor: Pmobj_t);

procedure A_SmBounce(actor: Pmobj_t);

procedure A_FiredChase(actor: Pmobj_t);

procedure A_FiredSplotch(actor: Pmobj_t);

procedure A_IceGuyLook(actor: Pmobj_t);

procedure A_IceGuyChase(actor: Pmobj_t);

procedure A_IceGuyAttack(actor: Pmobj_t);

procedure A_IceGuyMissilePuff(actor: Pmobj_t);

procedure A_FreezeDeathChunks(actor: Pmobj_t);

procedure A_IceGuyDie(actor: Pmobj_t);

procedure A_IceGuyMissileExplode(actor: Pmobj_t);

procedure A_SorcSpinBalls(actor: Pmobj_t);

procedure A_SorcBallOrbit(actor: Pmobj_t);

procedure A_SpeedBalls(actor: Pmobj_t);

procedure A_SlowBalls(actor: Pmobj_t);

procedure A_StopBalls(actor: Pmobj_t);

procedure A_AccelBalls(actor: Pmobj_t);

procedure A_DecelBalls(actor: Pmobj_t);

procedure A_SorcUpdateBallAngle(actor: Pmobj_t);

procedure A_CastSorcererSpell(actor: Pmobj_t);

procedure A_SorcOffense1(actor: Pmobj_t);

procedure A_SorcOffense2(actor: Pmobj_t);

procedure A_SorcBossAttack(actor: Pmobj_t);

procedure A_SpawnFizzle(actor: Pmobj_t);

procedure A_SorcFX1Seek(actor: Pmobj_t);

procedure A_SorcFX2Split(actor: Pmobj_t);

procedure A_SorcFX2Orbit(actor: Pmobj_t);

procedure A_SpawnBishop(actor: Pmobj_t);

procedure A_SmokePuffExit(actor: Pmobj_t);

procedure A_SorcererBishopEntry(actor: Pmobj_t);

procedure A_SorcFX4Check(actor: Pmobj_t);

procedure A_SorcBallPop(actor: Pmobj_t);

procedure A_BounceCheck(actor: Pmobj_t);

procedure A_FastChase(actor: Pmobj_t);

procedure A_FighterAttack(actor: Pmobj_t);

procedure A_ClericAttack(actor: Pmobj_t);

procedure A_MageAttack(actor: Pmobj_t);

procedure A_ClassBossHealth(actor: Pmobj_t);

procedure A_CheckFloor(actor: Pmobj_t);

procedure A_FreezeDeath(actor: Pmobj_t);

procedure A_IceSetTics(actor: Pmobj_t);

procedure A_IceCheckHeadDone(actor: Pmobj_t);

procedure A_KoraxChase(actor: Pmobj_t);

procedure A_KoraxStep(actor: Pmobj_t);

procedure A_KoraxStep2(actor: Pmobj_t);

procedure A_KoraxBonePop(actor: Pmobj_t);

procedure KSpiritInit(spirit: Pmobj_t; korax: Pmobj_t);

procedure A_KoraxDecide(actor: Pmobj_t);

procedure A_KoraxMissile(actor: Pmobj_t);

procedure A_KoraxCommand(actor: Pmobj_t);

procedure KoraxFire1(actor: Pmobj_t; _type: integer);

procedure KoraxFire2(actor: Pmobj_t; _type: integer);

procedure KoraxFire3(actor: Pmobj_t; _type: integer);

procedure KoraxFire4(actor: Pmobj_t; _type: integer);

procedure KoraxFire5(actor: Pmobj_t; _type: integer);

procedure KoraxFire6(actor: Pmobj_t; _type: integer);

procedure A_KSpiritWeave(actor: Pmobj_t);

procedure A_KSpiritSeeker(actor: Pmobj_t; thresh: angle_t; turnMax: angle_t);

procedure A_KSpiritRoam(actor: Pmobj_t);

procedure A_KBolt(actor: Pmobj_t);

procedure A_KBoltRaise(actor: Pmobj_t);


function A_RaiseMobj(actor: Pmobj_t): boolean;

function A_SinkMobj(actor: Pmobj_t): boolean;

function P_CheckMeleeRange(actor: Pmobj_t): boolean;

function P_CheckMeleeRange2(actor: Pmobj_t): boolean;

function P_CheckMissileRange(actor: Pmobj_t): boolean;

function P_LookForMonsters(actor: Pmobj_t): boolean;

function P_LookForPlayers(actor: Pmobj_t; allaround: boolean): boolean;

function P_Move(actor: Pmobj_t): boolean;

function P_TryWalk(actor: Pmobj_t): boolean;

function P_UpdateMorphedMonster(actor: Pmobj_t; tics: integer): boolean;


type
  dirtype_t = (
    DI_EAST,
    DI_NORTHEAST,
    DI_NORTH,
    DI_NORTHWEST,
    DI_WEST,
    DI_SOUTHWEST,
    DI_SOUTH,
    DI_SOUTHEAST,
    DI_NODIR,
    NUMDIRS
  );

implementation

uses
  d_delphi,
  d_think,
  d_player,
  d_main,
  doomdata,
  doomdef,
  g_game,
  i_system,
  info_h,
  m_fixed,
  m_rnd,
  a_action,
  p_mobj,
  p_common,
  p_extra,
  p_tick,
  p_inter,
  p_map,
  p_maputl,
  p_setup,
  p_local,
  p_sight,
  p_spec,
  p_sounds,
  p_pspr,
  p_telept,
  p_acs,
  ps_main,
  r_defs,
  r_main,
  s_sound,
  sounds,
  sb_bar;

const
  opposite: array[0..8] of dirtype_t = (
    DI_WEST, DI_SOUTHWEST, DI_SOUTH, DI_SOUTHEAST,
    DI_EAST, DI_NORTHEAST, DI_NORTH, DI_NORTHWEST, DI_NODIR
  );

  diags: array[0..3] of dirtype_t = (
    DI_NORTHWEST, DI_NORTHEAST, DI_SOUTHWEST, DI_SOUTHEAST
  );

//----------------------------------------------------------------------------
//
// PROC P_Massacre
//
// Kills all monsters.
//
//----------------------------------------------------------------------------

function P_Massacre: integer;
var
  mo: Pmobj_t;
  think: Pthinker_t;
begin
  think := thinkercap.next;
  result := 0;
  while think <> @thinkercap do
  begin
    if @think._function.acp1 = @P_MobjThinker then
    begin
      mo := Pmobj_t(think);
      if (mo.flags and MF_COUNTKILL <> 0) and (mo.health > 0) then
      begin
        mo.flags2 := mo.flags2 and not (MF2_NONSHOOTABLE + MF2_INVULNERABLE);
        mo.flags_ex := mo.flags_ex and not MF_EX_INVULNERABLE;
        mo.flags := mo.flags or MF_SHOOTABLE;
        P_DamageMobj(mo, nil, nil, 10000);
        inc(result);
      end;
    end;
   think := think.next;
  end;
end;


//----------------------------------------------------------------------------
//
// PROC P_RecursiveSound
//
//----------------------------------------------------------------------------

var
  soundtarget: Pmobj_t;

procedure P_RecursiveSound(sec: Psector_t; soundblocks: integer);
var
  i: integer;
  check: Pline_t;
  other: Psector_t;
begin
  // Wake up all monsters in this sector
  if (sec.validcount = validcount) and (sec.soundtraversed <= soundblocks + 1) then
  begin // Already flooded
    exit;
  end;

  sec.validcount := validcount;
  sec.soundtraversed := soundblocks + 1;
  sec.soundtarget := soundtarget;
  for i := 0 to sec.linecount - 1 do
  begin
    check := sec.lines[i];
    if check.flags and ML_TWOSIDED = 0 then
    begin
      continue;
    end;

    P_LineOpening(check, false);
    if openrange <= 0 then
    begin // Closed door
      continue;
    end;
    if sides[check.sidenum[0]].sector = sec then
    begin
      other := sides[check.sidenum[1]].sector;
    end
    else
    begin
      other := sides[check.sidenum[0]].sector;
    end;
    if check.flags and ML_SOUNDBLOCK <> 0 then
    begin
      if soundblocks = 0 then
      begin
        P_RecursiveSound(other, 1);
      end;
    end
    else
    begin
      P_RecursiveSound(other, soundblocks);
    end;
  end;
end;

//----------------------------------------------------------------------------
//
// PROC P_NoiseAlert
//
// If a monster yells at a player, it will alert other monsters to the
// player.
//
//----------------------------------------------------------------------------

procedure P_NoiseAlert(target: Pmobj_t; emmiter: Pmobj_t);
begin
  soundtarget := target;
  inc(validcount);
  P_RecursiveSound(Psubsector_t(emmiter.subsector).sector, 0);
end;

//----------------------------------------------------------------------------
//
// FUNC P_CheckMeleeRange
//
//----------------------------------------------------------------------------

function P_CheckMeleeRange(actor: Pmobj_t): boolean;
var
  mo: Pmobj_t;
  dist: fixed_t;
begin
  if actor.target = nil then
  begin
    result := false;
    exit;
  end;

  mo := actor.target;
  dist := P_AproxDistance(mo.x - actor.x, mo.y - actor.y);
  if dist >= MELEERANGE then
  begin
    result := false;
    exit;
  end;

  if not P_CheckSight(actor, mo) then
  begin
    result := false;
    exit;
  end;

  if mo.z > actor.z + actor.height then
  begin // Target is higher than the attacker
    result := false;
    exit;
  end;

  if actor.z > mo.z + mo.height then
  begin // Attacker is higher
    result := false;
    exit;
  end;

  result := true;
end;

//----------------------------------------------------------------------------
//
// FUNC P_CheckMeleeRange2
//
//----------------------------------------------------------------------------

function P_CheckMeleeRange2(actor: Pmobj_t): boolean;
var
  mo: Pmobj_t;
  dist: fixed_t;
begin
  if actor.target = nil then
  begin
    result := false;
    exit;
  end;

  mo := actor.target;
  dist := P_AproxDistance(mo.x - actor.x, mo.y - actor.y);
  if (dist >= MELEERANGE * 2) or (dist < MELEERANGE) then
  begin
    result := false;
    exit;
  end;

  if not P_CheckSight(actor, mo) then
  begin
    result := false;
    exit;
  end;

  if mo.z > actor.z + actor.height then
  begin // Target is higher than the attacker
    result := false;
    exit;
  end;

  if actor.z > mo.z + mo.height then
  begin // Attacker is higher
    result := false;
    exit;
  end;

  result := true;
end;

//----------------------------------------------------------------------------
//
// FUNC P_CheckMissileRange
//
//----------------------------------------------------------------------------

function P_CheckMissileRange(actor: Pmobj_t): boolean;
var
  dist: fixed_t;
begin
  if not P_CheckSight(actor, actor.target) then
  begin
    result := false;
    exit;
  end;

  if actor.flags and MF_JUSTHIT <> 0 then
  begin // The target just hit the enemy, so fight back!
    actor.flags := actor.flags and not MF_JUSTHIT;
    result := true;
    exit;
  end;

  if actor.reactiontime <> 0 then
  begin // Don't attack yet
    result := false;
    exit;
  end;

  dist := FixedInt(P_AproxDistance(actor.x - actor.target.x, actor.y - actor.target.y)) - 64;

  if actor.info.meleestate = 0 then // No melee attack, so fire more frequently
    dist := dist - 128;

  if dist > 200 then
    dist := 200;

  if P_Random < dist then
  begin
    result := false;
    exit;
  end;

  result := true;
end;

//*
//================
//=
//= P_Move
//=
//= Move in the current direction
//= returns false if the move is blocked
//================
//*

const
  xspeed: array[0..7] of fixed_t =
    (FRACUNIT, 47000, 0, -47000, -FRACUNIT, -47000, 0, 47000);

  yspeed: array[0..7] of fixed_t =
    (0, 47000, FRACUNIT, 47000, 0, -47000, -FRACUNIT, -47000);

  MAXSPECIALCROSS = 8;

function P_Move(actor: Pmobj_t): boolean;
var
  tryx: fixed_t;
  tryy: fixed_t;
  ld: Pline_t;
  good: boolean;
begin
  if actor.flags2 and MF2_BLASTED <> 0 then
  begin
    result := true;
    exit;
  end;

  if actor.movedir = Ord(DI_NODIR) then
  begin
    result := false;
    exit;
  end;

  tryx := actor.x + actor.info.speed * xspeed[actor.movedir];
  tryy := actor.y + actor.info.speed * yspeed[actor.movedir];
  if not P_TryMove(actor, tryx, tryy) then
  begin // open any specials
    if (actor.flags and MF_FLOAT <> 0) and floatok then
    begin // must adjust height
      if actor.z < tmfloorz then
        actor.z := actor.z + FLOATSPEED
      else
        actor.z := actor.z - FLOATSPEED;
      actor.flags := actor.flags or MF_INFLOAT;
      result := true;
      exit;
    end;
    if numspechit = 0 then
    begin
      result := false;
      exit;
    end;
    actor.movedir := Ord(DI_NODIR);
    good := false;
    while numspechit > 0 do
    begin
      dec(numspechit);
      ld := spechit[numspechit];

      if ld.flags and ML_TRIGGERSCRIPTS <> 0 then
        if actor.flags2_ex and MF2_EX_DONTRUNSCRIPTS = 0 then
          PS_EventUseLine(actor, pDiff(ld, lines, SizeOf(line_t)), P_PointOnLineSide(actor.x, actor.y, ld));

      // if the special isn't a door that can be opened, return false
      if P_ActivateLine(ld, actor, 0, SPAC_USE) then
        good := true;
    end;
    result := good;
    exit;
  end
  else
    actor.flags := actor.flags and not MF_INFLOAT;

  if actor.flags and MF_FLOAT = 0 then
  begin
    if actor.z > actor.floorz then
      P_HitFloor(actor);
    actor.z := actor.floorz;
  end;
  result := true;
end;

//----------------------------------------------------------------------------
//
// FUNC P_TryWalk
//
// Attempts to move actor in its current (ob.moveangle) direction.
// If blocked by either a wall or an actor returns FALSE.
// If move is either clear of block only by a door, returns TRUE and sets.
// If a door is in the way, an OpenDoor call is made to start it opening.
//
//----------------------------------------------------------------------------

function P_TryWalk(actor: Pmobj_t): boolean;
begin
  if not P_Move(actor) then
    result := false
  else
  begin
    actor.movecount := P_Random and 15;
    result := true;
  end;
end;

//*
//================
//=
//= P_NewChaseDir
//=
//================
//*

procedure P_NewChaseDir(actor: Pmobj_t);
var
  deltax: fixed_t;
  deltay: fixed_t;
  d: array[0..2] of dirtype_t;
  tdir: dirtype_t;
  olddir: dirtype_t;
  turnaround: dirtype_t;
  idx: integer;
begin
  if actor.target = nil then
    I_Error('P_NewChaseDir(): called with no target');

  olddir := dirtype_t(actor.movedir);
  turnaround := opposite[Ord(olddir)];

  deltax := actor.target.x - actor.x;
  deltay := actor.target.y - actor.y;

  if actor.flags2_ex and MF2_EX_FRIGHTENED <> 0 then
  begin
    deltax := -deltax;
    deltay := -deltay;
  end;

  if deltax > 10 * FRACUNIT then
    d[1] := DI_EAST
  else if deltax < -10 * FRACUNIT then
    d[1] := DI_WEST
  else
    d[1] := DI_NODIR;

  if deltay < -10 * FRACUNIT then
    d[2] := DI_SOUTH
  else if deltay > 10 * FRACUNIT then
    d[2] := DI_NORTH
  else
    d[2] := DI_NODIR;

  // try direct route
  if (d[1] <> DI_NODIR) and (d[2] <> DI_NODIR) then
  begin
    if deltay < 0 then
      idx := 2
    else
      idx := 0;
    if deltax > 0 then
      inc(idx);
    actor.movedir := Ord(diags[idx]);
    if (actor.movedir <> Ord(turnaround)) and P_TryWalk(actor) then
      exit;
  end;

  // try other directions
  if (P_Random > 200) or (abs(deltay) > abs(deltax)) then
  begin
    tdir := d[1];
    d[1] := d[2];
    d[2] := tdir;
  end;

  if d[1] = turnaround then
    d[1] := DI_NODIR;
  if d[2] = turnaround then
    d[2] := DI_NODIR;

  if d[1] <> DI_NODIR then
  begin
    actor.movedir := Ord(d[1]);
    if P_TryWalk(actor) then
      exit; // either moved forward or attacked
  end;

  if d[2] <> DI_NODIR then
  begin
    actor.movedir := Ord(d[2]);
    if P_TryWalk(actor) then
      exit;
  end;

  // there is no direct path to the player,
  // so pick another direction.
  if olddir <> DI_NODIR then
  begin
    actor.movedir := Ord(olddir);
    if P_TryWalk(actor) then
      exit;
  end;

  // randomly determine direction of search
  if P_Random and 1 <> 0 then
  begin
    for tdir := DI_EAST to DI_SOUTHEAST do
    begin
      if tdir <> turnaround then
      begin
        actor.movedir := Ord(tdir);
        if P_TryWalk(actor) then
          exit;
      end
    end
  end
  else
  begin
    for tdir := DI_SOUTHEAST downto DI_EAST do
    begin
      if tdir <> turnaround then
      begin
        actor.movedir := Ord(tdir);
        if P_TryWalk(actor) then
          exit;
      end;
    end;
  end;

  if turnaround <> DI_NODIR then
  begin
    actor.movedir := Ord(turnaround);
    if P_TryWalk(actor) then
      exit;
  end;

  actor.movedir := Ord(DI_NODIR); // can not move
end;


//---------------------------------------------------------------------------
//
// FUNC P_LookForMonsters
//
//---------------------------------------------------------------------------
const
  MONS_LOOK_RANGE = 20 * 64 * FRACUNIT;
  MONS_LOOK_LIMIT = 64;

function P_LookForMonsters(actor: Pmobj_t): boolean;
var
  count: integer;
  mo: Pmobj_t;
  think: Pthinker_t;
begin
  if not P_CheckSight(players[0].mo, actor) then
  begin // Player can't see monster
    result := false;
    exit;
  end;

  count := 0;
  think := thinkercap.next;
  while think <> @thinkercap do
  begin
    if @think._function.acp1 <> @P_MobjThinker then
    begin
      think := think.next;
      continue;
    end;

    mo := Pmobj_t(think);

    if (mo.flags and MF_COUNTKILL = 0) or (mo = actor) or (mo.health <= 0) then
    begin // Not a valid monster
      think := think.next;
      continue;
    end;

    if P_AproxDistance(actor.x - mo.x, actor.y - mo.y) > MONS_LOOK_RANGE then
    begin // Out of range
      think := think.next;
      continue;
    end;

    if P_Random < 16 then
    begin // Skip
      think := think.next;
      continue;
    end;

    inc(count);
    if count > MONS_LOOK_LIMIT then
    begin // Stop searching
      result := false;
      exit;
    end;

    if not P_CheckSight(actor, mo) then
    begin // Out of sight
      think := think.next;
      continue;
    end;

    // Found a target monster
    actor.target := mo;
    result := true;
    exit;
  end;

  result := false;
end;


//
// P_LookForPlayers
// If allaround is false, only look 180 degrees in front.
// Returns true if a player is targeted.
//
function P_LookForPlayers(actor: Pmobj_t; allaround: boolean): boolean;
var
  c: integer;
  stop: integer;
  player: Pplayer_t;
  an: angle_t;
  dist: fixed_t;
  initial: boolean;
begin
  if not netgame and (players[0].health <= 0) then
  begin
    result := P_LookForMonsters(actor);
    exit;
  end;

  c := 0;
  stop := (actor.lastlook + MAXPLAYERS - 1) mod MAXPLAYERS;

  initial := true;
  while true do
  begin
    if initial then
      initial := false
    else
      actor.lastlook := (actor.lastlook + 1) mod MAXPLAYERS;

    if not playeringame[actor.lastlook] then
      continue;

    if (c = 2) or (actor.lastlook = stop) then
    begin
      // done looking
      result := false;
      exit;
    end;
    inc(c);

    player := @players[actor.lastlook];

    if player.health <= 0 then
      continue;   // dead

    if not P_CheckSight(actor, player.mo) then
      continue;   // out of sight

    if not allaround then
    begin
      an := R_PointToAngle2(
              actor.x,
              actor.y,
              player.mo.x,
              player.mo.y)
          - actor.angle;

      if (an > ANG90) and (an < ANG270) then
      begin
        dist := P_AproxDistance(player.mo.x - actor.x, player.mo.y - actor.y);
        // if real close, react anyway
        if dist > MELEERANGE then
          continue; // behind back
      end;
    end;

    if player.mo.flags and MF_SHADOW <> 0 then
    begin // Player is invisible
      if (P_AproxDistance(player.mo.x - actor.x, player.mo.y - actor.y) > 2 * MELEERANGE) and
         (P_AproxDistance(player.mo.momx, player.mo.momy) < 5 * FRACUNIT) then
      begin // Player is sneaking - can't detect
        result := false;
        exit;
      end;

      if P_Random < 225 then
      begin // Player isn't sneaking, but still didn't detect
        result := false;
        exit;
      end;
    end;

    if actor._type = Ord(MT_MINOTAUR) then
    begin
      if Pplayer_t(actor.special1) = player then
      begin
        continue;      // Don't target master
      end;
    end;

    actor.target := player.mo;
    result := true;
    exit;
  end;

  result := false;
end;

//
//----------------------------------------------------------------------------===
//
//            ACTION ROUTINES
//
//----------------------------------------------------------------------------===
//

//----------------------------------------------------------------------------
//
// A_Look
//
// Stay in state until a player is sighted
//
//----------------------------------------------------------------------------

procedure A_Look(actor: Pmobj_t);
var
  targ: Pmobj_t;
  seeyou: boolean;
begin
  actor.threshold := 0;           // any shot will wake up
  targ := Psubsector_t(actor.subsector).sector.soundtarget;
  seeyou := false;
  if (targ <> nil) and (targ.flags and MF_SHOOTABLE <> 0) then
  begin
    actor.target := targ;
    if  actor.flags and MF_AMBUSH <> 0 then
    begin
      if P_CheckSight(actor, actor.target) then
        seeyou := true;
    end
    else
     seeyou := true;
  end;

  if not seeyou then
    if not P_LookForPlayers(actor, false) then
      exit;

// go into chase state
  A_SeeSound(actor);
  P_SetMobjState(actor, statenum_t(actor.info.seestate));
end;


//----------------------------------------------------------------------------
//
// A_Chase
//
// Actor has a melee attack, so it tries to close as fast as possible
//
//----------------------------------------------------------------------------

procedure A_Chase(actor: Pmobj_t);
var
  delta: integer;
  nomissile: boolean;
begin
  if actor.reactiontime <> 0 then
    actor.reactiontime := actor.reactiontime - 1;

  // modify target threshold
  if actor.threshold <> 0 then
    actor.threshold := actor.threshold - 1;

  if gameskill = sk_nightmare then
  begin // Monsters move faster in nightmare mode
    actor.tics := actor.tics - actor.tics div 2;
    if actor.tics < 3 then
      actor.tics := 3;
  end;

//
// turn towards movement direction if not there yet
//
  if actor.movedir < 8 then
  begin
    actor.angle := actor.angle and $E0000000;
    delta := actor.angle - _SHLW(actor.movedir, 29);

    if delta > 0 then
      actor.angle := actor.angle - ANG90 div 2
    else if delta < 0 then
      actor.angle := actor.angle + ANG90 div 2;
  end;

  if (actor.target = nil) or
     (actor.target.flags and MF_SHOOTABLE = 0) then
  begin
    // look for a new target
    if P_LookForPlayers(actor, true) then
      exit; // got a new target

    P_SetMobjState(actor, statenum_t(actor.info.spawnstate));
    exit;
  end;

  // do not attack twice in a row
  if actor.flags and MF_JUSTATTACKED <> 0 then
  begin
    actor.flags := actor.flags and (not MF_JUSTATTACKED);
    if (gameskill <> sk_nightmare) and (not fastparm) then
      P_NewChaseDir(actor);
    exit;
  end;

  // check for melee attack
  if (actor.info.meleestate <> 0) and P_CheckMeleeRange(actor) then
  begin
    A_AttackSound(actor);
    P_SetMobjState(actor, statenum_t(actor.info.meleestate));
    exit;
  end;


  // check for missile attack
  if actor.info.missilestate <> 0 then
  begin
    nomissile := false;
    if (gameskill < sk_nightmare) and (not fastparm) and (actor.movecount <> 0) then
      nomissile := true
    else if not P_CheckMissileRange(actor) then
      nomissile := true;
    if not nomissile then
    begin
      P_SetMobjState(actor, statenum_t(actor.info.missilestate));
      actor.flags := actor.flags or MF_JUSTATTACKED;
      exit;
    end;
  end;

  // possibly choose another target
  if netgame and
    (actor.threshold = 0) and
    (not P_CheckSight(actor, actor.target)) then
  begin
    if P_LookForPlayers(actor, true) then
      exit;  // got a new target
  end;


  // chase towards player
  actor.movecount := actor.movecount - 1;
  if (actor.movecount < 0) or (not P_Move(actor)) then
    P_NewChaseDir(actor);

//
// make active sound
//
  if (actor.info.activesound <> 0) and (P_Random < 3) then
  begin
    if (actor._type = Ord(MT_BISHOP)) and (P_Random < 128) then
    begin
      A_SeeSound(actor);
    end
    else if actor._type = Ord(MT_PIG) then
    begin
      S_StartSound(actor, Ord(SFX_PIG_ACTIVE1) + (P_Random and 1));
    end
    else
      A_ActiveSound(actor);
  end;
end;

//----------------------------------------------------------------------------
//
// PROC A_FaceTarget
//
//----------------------------------------------------------------------------

procedure A_FaceTarget(actor: Pmobj_t);
begin
  if actor.target = nil then
    exit;

  actor.flags := actor.flags and (not MF_AMBUSH);

  actor.angle :=
    R_PointToAngle2(actor.x, actor.y, actor.target.x, actor.target.y);

  if actor.target.flags and MF_SHADOW <> 0 then
    actor.angle := actor.angle + _SHLW(P_Random - P_Random, 21);
end;

//----------------------------------------------------------------------------
//
// PROC A_Pain
//
//----------------------------------------------------------------------------

procedure A_Pain(actor: Pmobj_t);
begin
  A_PainSound(actor);
end;

//----------------------------------------------------------------------------
//
// A_SetReflective
//
//----------------------------------------------------------------------------

procedure A_SetReflective(actor: Pmobj_t);
begin
  actor.flags2_ex := actor.flags2_ex or MF2_EX_REFLECTIVE;

  if (actor._type = Ord(MT_CENTAUR)) or
     (actor._type = Ord(MT_CENTAURLEADER)) then
    A_SetInvulnerable(actor);
end;

//----------------------------------------------------------------------------
//
// A_UnSetReflective
//
//----------------------------------------------------------------------------

procedure A_UnSetReflective(actor: Pmobj_t);
begin
  actor.flags2_ex := actor.flags2_ex and not MF2_EX_REFLECTIVE;

  if (actor._type = Ord(MT_CENTAUR)) or
     (actor._type = Ord(MT_CENTAURLEADER)) then
    A_UnSetInvulnerable(actor);
end;


//----------------------------------------------------------------------------
//
// FUNC P_UpdateMorphedMonster
//
// Returns true if the pig morphs.
//
//----------------------------------------------------------------------------

function P_UpdateMorphedMonster(actor: Pmobj_t; tics: integer): boolean;
var
  fog: Pmobj_t;
  x, y, z: fixed_t;
  moType: mobjtype_t;
  mo: Pmobj_t;
  oldMonster: mobj_t;
begin
  actor.special1 := actor.special1 - tics;
  if actor.special1 > 0 then
  begin
    result := false;
    exit;
  end;

  moType := mobjtype_t(actor.special2);
  case moType of
    MT_WRAITHB,      // These must remain morphed
    MT_SERPENT,
    MT_SERPENTLEADER,
    MT_MINOTAUR:
      begin
        result := false;
        exit;
      end;
  end;
  x := actor.x;
  y := actor.y;
  z := actor.z;
  oldMonster := actor^;      // Save pig vars

  P_RemoveMobjFromTIDList(actor);
  P_SetMobjState(actor, S_FREETARGMOBJ);
  mo := P_SpawnMobj(x, y, z, Ord(moType));

  if not P_TestMobjLocation(mo) = false then
  begin // Didn't fit
    P_RemoveMobj(mo);
    mo := P_SpawnMobj(x, y, z, oldMonster._type);
    mo.angle := oldMonster.angle;
    mo.flags := oldMonster.flags;
    mo.health := oldMonster.health;
    mo.target := oldMonster.target;
    mo.special := oldMonster.special;
    mo.special1 := 5 * TICRATE; // Next try in 5 seconds
    mo.special2 := Ord(moType);
    mo.tid := oldMonster.tid;
    memcpy(@mo.args, @oldMonster.args, 5);
    P_InsertMobjIntoTIDList(mo, oldMonster.tid);
    result := false;
    exit;
  end;
  mo.angle := oldMonster.angle;
  mo.target := oldMonster.target;
  mo.tid := oldMonster.tid;
  mo.special := oldMonster.special;
  memcpy(@mo.args, @oldMonster.args, 5);
  P_InsertMobjIntoTIDList(mo, oldMonster.tid);
  fog := P_SpawnMobj(x, y, z + TELEFOGHEIGHT, Ord(MT_TFOG));
  S_StartSound(fog, Ord(SFX_TELEPORT));
  result := true;
end;

//----------------------------------------------------------------------------
//
// PROC A_PigLook
//
//----------------------------------------------------------------------------

procedure A_PigLook(actor: Pmobj_t);
begin
  if P_UpdateMorphedMonster(actor, 10) then
    exit;

  A_Look(actor);
end;

//----------------------------------------------------------------------------
//
// PROC A_PigChase
//
//----------------------------------------------------------------------------

procedure A_PigChase(actor: Pmobj_t);
begin
  if P_UpdateMorphedMonster(actor, 3) then
    exit;

  A_Chase(actor);
end;

//----------------------------------------------------------------------------
//
// A_PigAttack
//
//----------------------------------------------------------------------------

procedure A_PigAttack(actor: Pmobj_t);
begin
  if P_UpdateMorphedMonster(actor, 18) then
    exit;

  if actor.target = nil then
    exit;

  if P_CheckMeleeRange(actor) then
  begin
    P_DamageMobj(actor.target, actor, actor, 2 + (P_Random and 1));
    S_StartSound(actor, Ord(SFX_PIG_ATTACK));
  end;
end;

//----------------------------------------------------------------------------
//
// A_PigPain
//
//----------------------------------------------------------------------------

procedure A_PigPain(actor: Pmobj_t);
begin
  A_Pain(actor);
  if actor.z <= actor.floorz then
    actor.momz := 7 * FRACUNIT div 2;
end;


procedure FaceMovementDirection(actor: Pmobj_t);
begin
  case actor.movedir of
    Ord(DI_EAST):
      actor.angle := $0;
    Ord(DI_NORTHEAST):
      actor.angle := $20000000;
    Ord(DI_NORTH):
      actor.angle := $40000000;
    Ord(DI_NORTHWEST):
      actor.angle := $60000000;
    Ord(DI_WEST):
      actor.angle := $80000000;
    Ord(DI_SOUTHWEST):
      actor.angle := $A0000000;
    Ord(DI_SOUTH):
      actor.angle := $C0000000;
    Ord(DI_SOUTHEAST):
      actor.angle := $E0000000;
  end;
end;


//----------------------------------------------------------------------------
//
// Minotaur variables
//
//   special1    pointer to player that spawned it (mobj_t)
//  special2    internal to minotaur AI
//  args[0]      args[0]-args[3] together make up minotaur start time
//  args[1]      |
//  args[2]      |
//  args[3]      V
//  args[4]      charge duration countdown
//----------------------------------------------------------------------------

procedure A_MinotaurFade0(actor: Pmobj_t);
begin
  actor.flags := actor.flags and not MF_ALTSHADOW;
  actor.flags := actor.flags or MF_SHADOW;
end;

procedure A_MinotaurFade1(actor: Pmobj_t);
begin
  // Second level of transparency
  actor.flags := actor.flags and not MF_SHADOW;
  actor.flags := actor.flags or MF_ALTSHADOW;
end;

procedure A_MinotaurFade2(actor: Pmobj_t);
begin
  // Make fully visible
  actor.flags := actor.flags and not MF_SHADOW;
  actor.flags := actor.flags and not MF_ALTSHADOW;
end;


//----------------------------------------------------------------------------
//
// A_MinotaurRoam - 
//
// 
//----------------------------------------------------------------------------

//----------------------------------------------------------------------------
//
//  PROC A_MinotaurLook
//
// Look for enemy of player
//----------------------------------------------------------------------------
const
  MINOTAUR_LOOK_DIST = 16 * 54 * FRACUNIT;

procedure A_MinotaurLook(actor: Pmobj_t);
var
  mo: Pmobj_t;
  player: Pplayer_t;
  think: Pthinker_t;
  dist: fixed_t;
  i: integer;
  master: Pmobj_t;
begin
  master := Pmobj_t(actor.special1);

  actor.target := nil;
  if deathmatch <> 0 then // Quick search for players
  begin
    for i := 0 to MAXPLAYERS - 1 do
    begin
      if not playeringame[i] then
        continue;
      player := @players[i];
      mo := player.mo;
      if mo = master then
        continue;
      if mo.health <= 0 then
        continue;
      dist := P_AproxDistance(actor.x - mo.x, actor.y - mo.y);
      if dist > MINOTAUR_LOOK_DIST then
        continue;
      actor.target := mo;
      break;
    end;
  end;

  if actor.target = nil then        // Near player monster search
  begin
    if (master <> nil) and (master.health > 0) and (master.player <> nil) then
      mo := P_RoughMonsterSearch(master, 20)
    else
      mo := P_RoughMonsterSearch(actor, 20);
    actor.target := mo;
  end;

  if actor.target = nil then        // Normal monster search
  begin
    think := thinkercap.next;
    while think <> @thinkercap do
    begin
      if @think._function.acp1 <> @P_MobjThinker then
      begin
        think := think.next;
        continue;
      end;

      mo := Pmobj_t(think);
      if (mo.flags and MF_COUNTKILL = 0) or
         (mo.flags and MF_SHOOTABLE = 0) or
         (mo.health <= 0) then
      begin
        think := think.next;
        continue;
      end;

      dist := P_AproxDistance(actor.x - mo.x, actor.y - mo.y);
      if dist > MINOTAUR_LOOK_DIST then
      begin
        think := think.next;
        continue;
      end;

      if (mo = master) or (mo = actor) then
      begin
        think := think.next;
        continue;
      end;

      if (mo._type = Ord(MT_MINOTAUR)) and
         (mo.special1 = actor.special1) then
      begin
        think := think.next;
        continue;
      end;

      actor.target := mo;
      break;      // Found mobj to attack
    end;
  end;

  if actor.target <> nil then
    P_SetMobjStateNF(actor, S_MNTR_WALK1)
  else
    P_SetMobjStateNF(actor, S_MNTR_ROAM1);
end;


procedure A_MinotaurRoam(actor: Pmobj_t);
var
  starttime: PInteger;
begin
  starttime := @actor.args[0];

  actor.flags := actor.flags and not MF_SHADOW;      // In pain caused him to
  actor.flags := actor.flags and not MF_ALTSHADOW;    // skip his fade in.

  if leveltime - starttime^ >= MAULATORTICS then
  begin
    P_DamageMobj(actor, nil, nil, 10000);
    exit;
  end;

  if P_Random < 30 then
    A_MinotaurLook(actor);    // adjust to closest target

  if P_Random < 6 then
  begin
    //Choose new direction
    actor.movedir := P_Random mod 8;
    FaceMovementDirection(actor);
  end;
  if not P_Move(actor) then
  begin
    // Turn
    if P_Random and 1 <> 0 then
      actor.movedir := (actor.movedir + 1) mod 8
    else
      actor.movedir := (actor.movedir + 7) mod 8;
    FaceMovementDirection(actor);
  end;
end;

procedure A_MinotaurChase(actor: Pmobj_t);
var
  starttime: PInteger;
begin
  starttime := @actor.args[0];

  actor.flags := actor.flags and not MF_SHADOW;      // In pain caused him to
  actor.flags := actor.flags and not MF_ALTSHADOW;    // skip his fade in.

  if leveltime - starttime^ >= MAULATORTICS then
  begin
    P_DamageMobj(actor, nil, nil, 10000);
    exit;
  end;


  if P_Random < 30 then
    A_MinotaurLook(actor);    // adjust to closest target

  if (actor.target = nil) or
     (actor.target.health <= 0) or
     (actor.target.flags and MF_SHOOTABLE = 0) then
  begin // look for a new target
    P_SetMobjState(actor, S_MNTR_LOOK1);
    exit;
  end;

  FaceMovementDirection(actor);
  actor.reactiontime := 0;

  // Melee attack
  if (actor.info.meleestate <> 0) and P_CheckMeleeRange(actor) then
  begin
    A_AttackSound(actor);
    P_SetMobjState(actor, statenum_t(actor.info.meleestate));
    exit;
  end;

  // Missile attack
  if (actor.info.missilestate <> 0) and P_CheckMissileRange(actor) then
  begin
    P_SetMobjState(actor, statenum_t(actor.info.missilestate));
    exit;
  end;

  // chase towards target
  if not P_Move(actor) then
    P_NewChaseDir(actor);

  // Active sound
  if P_Random < 6 then
    A_ActiveSound(actor);

end;


//----------------------------------------------------------------------------
//
// PROC A_MinotaurAtk1
//
// Melee attack.
//
//----------------------------------------------------------------------------

procedure A_MinotaurAtk1(actor: Pmobj_t);
begin
  if actor.target = nil then
    exit;

  S_StartSound(actor, Ord(SFX_MAULATOR_HAMMER_SWING));
  if P_CheckMeleeRange(actor) then
    P_DamageMobj(actor.target, actor, actor, HITDICE(4));
end;

//----------------------------------------------------------------------------
//
// PROC A_MinotaurDecide
//
// Choose a missile attack.
//
//----------------------------------------------------------------------------

const
  MNTR_CHARGE_SPEED = 23 * FRACUNIT;

procedure A_MinotaurDecide(actor: Pmobj_t);
var
  angle: angle_t;
  target: Pmobj_t;
  dist: integer;
begin
  target := actor.target;
  if target = nil then
    exit;

  dist := P_AproxDistance(actor.x - target.x, actor.y - target.y);
  if (target.z + target.height > actor.z) and
     (target.z + target.height < actor.z + actor.height) and
     (dist < 16 * 64 * FRACUNIT) and
     (dist > 1 * 64 * FRACUNIT) and
     (P_Random < 230) then
  begin // Charge attack
    // Don't call the state function right away
    P_SetMobjStateNF(actor, S_MNTR_ATK4_1);
    actor.flags := actor.flags or MF_SKULLFLY;
    A_FaceTarget(actor);
    angle := actor.angle shr ANGLETOFINESHIFT;
    actor.momx := FixedMul(MNTR_CHARGE_SPEED, finecosine[angle]);
    actor.momy := FixedMul(MNTR_CHARGE_SPEED, finesine[angle]);
    actor.args[4] := TICRATE div 2; // Charge duration
  end
  else if (target.z = target.floorz) and
          (dist < 9 * 64 * FRACUNIT) and
          (P_Random < 100) then
  begin // Floor fire attack
    P_SetMobjState(actor, S_MNTR_ATK3_1);
    actor.special2 := 0;
  end
  else // Swing attack
    A_FaceTarget(actor);
    // Don't need to call P_SetMobjState because the current state
    // falls through to the swing attack
end;

//----------------------------------------------------------------------------
//
// PROC A_MinotaurCharge
//
//----------------------------------------------------------------------------

procedure A_MinotaurCharge(actor: Pmobj_t);
var
  puff: Pmobj_t;
begin
  if actor.target = nil then
    exit;

  if actor.args[4] > 0 then
  begin
    puff := P_SpawnMobj(actor.x, actor.y, actor.z, Ord(MT_PUNCHPUFF));
    puff.momz := 2 * FRACUNIT;
    dec(actor.args[4]);
  end
  else
  begin
    actor.flags := actor.flags and not MF_SKULLFLY;
    P_SetMobjState(actor, statenum_t(actor.info.seestate));
  end;
end;

//----------------------------------------------------------------------------
//
// PROC A_MinotaurAtk2
//
// Swing attack.
//
//----------------------------------------------------------------------------

procedure A_MinotaurAtk2(actor: Pmobj_t);
var
  mo: Pmobj_t;
  angle: angle_t;
  momz: fixed_t;
begin
  if actor.target = nil then
    exit;

  S_StartSound(actor, Ord(SFX_MAULATOR_HAMMER_SWING));
  if P_CheckMeleeRange(actor) then
  begin
    P_DamageMobj(actor.target, actor, actor, HITDICE(3));
    exit;
  end;
  mo := P_SpawnMissile(actor, actor.target, Ord(MT_MNTRFX1));
  if mo <> nil then
  begin
    momz := mo.momz;
    angle := mo.angle;
    P_SpawnMissileAngle(actor, Ord(MT_MNTRFX1), angle - (ANG45 div 8), momz);
    P_SpawnMissileAngle(actor, Ord(MT_MNTRFX1), angle + (ANG45 div 8), momz);
    P_SpawnMissileAngle(actor, Ord(MT_MNTRFX1), angle - (ANG45 div 16), momz);
    P_SpawnMissileAngle(actor, Ord(MT_MNTRFX1), angle + (ANG45 div 16), momz);
  end;
end;

//----------------------------------------------------------------------------
//
// PROC A_MinotaurAtk3
//
// Floor fire attack.
//
//----------------------------------------------------------------------------

procedure A_MinotaurAtk3(actor: Pmobj_t);
var
  mo: Pmobj_t;
  player: Pplayer_t;
begin
  if actor.target = nil then
    exit;

  if P_CheckMeleeRange(actor) then
  begin
    P_DamageMobj(actor.target, actor, actor, HITDICE(3));
    player := actor.target.player;
    if player <> nil then
    begin // Squish the player
      player.deltaviewheight := -16 * FRACUNIT;
    end;
  end
  else
  begin
    mo := P_SpawnMissile(actor, actor.target, Ord(MT_MNTRFX2));
    if mo <> nil then
      S_StartSound(mo, Ord(SFX_MAULATOR_HAMMER_HIT));
  end;
  if (P_Random < 192) and (actor.special2 = 0) then
  begin
    P_SetMobjState(actor, S_MNTR_ATK3_4);
    actor.special2 := 1;
  end;
end;

//----------------------------------------------------------------------------
//
// PROC A_MntrFloorFire
//
//----------------------------------------------------------------------------

procedure A_MntrFloorFire(actor: Pmobj_t);
var
  mo: Pmobj_t;
begin
  actor.z := actor.floorz;
  mo := P_SpawnMobj(actor.x + (P_Random - P_Random) * 1024, actor.y + (P_Random - P_Random) * 1024, ONFLOORZ, Ord(MT_MNTRFX3));
  mo.target := actor.target;
  mo.momx := 1; // Force block checking
  P_CheckMissileSpawn(mo);
end;


//----------------------------------------------------------------------------
//
// PROC A_Scream
//
//----------------------------------------------------------------------------

procedure A_Scream(actor: Pmobj_t);
var
  sound: integer;
begin
  S_StopSound(actor);
  if actor.player <> nil then
  begin
    if Pplayer_t(actor.player).morphTics <> 0 then
    begin
      A_DeathSound(actor);
    end
    else
    begin
      // Handle the different player death screams
      if actor.momz <= -39 * FRACUNIT then
      begin // Falling splat
        sound := Ord(SFX_PLAYER_FALLING_SPLAT);
      end
      else if actor.health > -50 then
      begin // Normal death sound
        case Pplayer_t(actor.player)._class of
          PCLASS_FIGHTER:
            sound := Ord(SFX_PLAYER_FIGHTER_NORMAL_DEATH);
          PCLASS_CLERIC:
            sound := Ord(SFX_PLAYER_CLERIC_NORMAL_DEATH);
          PCLASS_MAGE:
            sound := Ord(SFX_PLAYER_MAGE_NORMAL_DEATH);
        else
          sound := Ord(SFX_NONE);
        end;
      end
      else if actor.health > -100 then
      begin // Crazy death sound
        case Pplayer_t(actor.player)._class of
          PCLASS_FIGHTER:
            sound := Ord(SFX_PLAYER_FIGHTER_CRAZY_DEATH);
          PCLASS_CLERIC:
            sound := Ord(SFX_PLAYER_CLERIC_CRAZY_DEATH);
          PCLASS_MAGE:
            sound := Ord(SFX_PLAYER_MAGE_CRAZY_DEATH);
        else
          sound := Ord(SFX_NONE);
        end;
      end
      else
      begin // Extreme death sound
        case Pplayer_t(actor.player)._class of
          PCLASS_FIGHTER:
            sound := Ord(SFX_PLAYER_FIGHTER_EXTREME1_DEATH);
          PCLASS_CLERIC:
            sound := Ord(SFX_PLAYER_CLERIC_EXTREME1_DEATH);
          PCLASS_MAGE:
            sound := Ord(SFX_PLAYER_MAGE_EXTREME1_DEATH);
        else
          sound := Ord(SFX_NONE);
        end;
        sound := sound + P_Random mod 3; // Three different extreme deaths
      end;
      S_StartSound(actor, sound);
    end;
  end
  else
  begin
    A_DeathSound(actor);
  end;
end;

//----------------------------------------------------------------------------
//
// PROC A_Explode
//
// Handles a bunch of exploding things.
//
//----------------------------------------------------------------------------

procedure A_Explode(actor: Pmobj_t);
var
  damage: integer;
  distance: integer;
  damageSelf: boolean;
begin
  if actor.info.flags_ex and MF_EX_CUSTOMEXPLODE <> 0 then
  begin
    damage := actor.info.explosiondamage;
    distance := actor.info.explosionradius;
    P_RadiusAttack2(actor, actor.target, damage, distance);
  end
  else if actor.state.params <> nil then
  begin
    damage := actor.state.params.IntVal[0];
    distance := actor.state.params.IntVal[1];
    P_RadiusAttack2(actor, actor.target, damage, distance);
  end
  else
  begin
    damage := 128;
    distance := 128;
    damageSelf := true;
    case actor._type of
      Ord(MT_FIREBOMB): // Time Bombs
        begin
          actor.z := actor.z + 32 * FRACUNIT;
          actor.flags := actor.flags and not MF_SHADOW;
        end;
      Ord(MT_MNTRFX2): // Minotaur floor fire
        begin
          damage := 24;
        end;
      Ord(MT_BISHOP): // Bishop radius death
        begin
          damage := 25 + (P_Random and 15);
        end;
      Ord(MT_HAMMER_MISSILE): // Fighter Hammer
        begin
          damage := 128;
          damageSelf := false;
        end;
      Ord(MT_FSWORD_MISSILE): // Fighter Runesword
        begin
          damage := 64;
          damageSelf := false;
        end;
      Ord(MT_CIRCLEFLAME): // Cleric Flame secondary flames
        begin
          damage := 20;
          damageSelf := false;
        end;
      Ord(MT_SORCBALL1),   // Sorcerer balls
      Ord(MT_SORCBALL2),
      Ord(MT_SORCBALL3):
        begin
          distance := 255;
          damage := 255;
          actor.args[0] := 1;    // don't play bounce
        end;
      Ord(MT_SORCFX1):   // Sorcerer spell 1
        begin
          damage := 30;
        end;
      Ord(MT_SORCFX4):   // Sorcerer spell 4
        begin
          damage := 20;
        end;
      Ord(MT_TREEDESTRUCTIBLE):
        begin
          damage := 10;
        end;
      Ord(MT_DRAGON_FX2):
        begin
          damage := 80;
          damageSelf := false;
        end;
      Ord(MT_MSTAFF_FX):
        begin
          damage := 64;
          distance := 192;
          damageSelf := false;
        end;
      Ord(MT_MSTAFF_FX2):
        begin
          damage := 80;
          distance := 192;
          damageSelf := false;
        end;
      Ord(MT_POISONCLOUD):
        begin
          damage := 4;
          distance := 40;
        end;
      Ord(MT_ZXMAS_TREE),
      Ord(MT_ZSHRUB2):
        begin
          damage := 30;
          distance := 64;
        end;
    end;
    P_RadiusAttack(actor, actor.target, damage, distance, damageSelf);
  end;
  if (actor.z <= actor.floorz + (distance * FRACUNIT)) or
     (actor._type <> Ord(MT_POISONCLOUD)) then
     P_HitFloor(actor);
end;

//----------------------------------------------------------------------------
//
// PROC A_SkullPop
//
//----------------------------------------------------------------------------

procedure A_SkullPop(actor: Pmobj_t);
var
  mo: Pmobj_t;
  player: Pplayer_t;
begin
  if actor.player = nil then
    exit;

  actor.flags := actor.flags and not MF_SOLID;
  mo := P_SpawnMobj(actor.x, actor.y, actor.z + 48 * FRACUNIT, Ord(MT_BLOODYSKULL));
  //mo.target := actor;
  mo.momx := (P_Random - P_Random) * 512;
  mo.momy := (P_Random - P_Random) * 512;
  mo.momz := FRACUNIT * 2 + (P_Random * 64);
  // Attach player mobj to bloody skull
  player := actor.player;
  actor.player := nil;
  actor.special1 := Ord(player._class);
  mo.player := player;
  mo.health := actor.health;
  mo.angle := actor.angle;
  player.mo := mo;
  player.lookdir := 0;
  player.damagecount := 32;
end;

//----------------------------------------------------------------------------
//
// PROC A_CheckSkullFloor
//
//----------------------------------------------------------------------------

procedure A_CheckSkullFloor(actor: Pmobj_t);
begin
  if actor.z <= actor.floorz then
  begin
    P_SetMobjState(actor, S_BLOODYSKULLX1);
    S_StartSound(actor, Ord(SFX_DRIP));
  end;
end;

//----------------------------------------------------------------------------
//
// PROC A_CheckSkullDone
//
//----------------------------------------------------------------------------

procedure A_CheckSkullDone(actor: Pmobj_t);
begin
  if actor.special2 = 666 then
    P_SetMobjState(actor, S_BLOODYSKULLX2);
end;

//----------------------------------------------------------------------------
//
// PROC A_CheckBurnGone
//
//----------------------------------------------------------------------------

procedure A_CheckBurnGone(actor: Pmobj_t);
begin
  if actor.special2 = 666 then
    P_SetMobjState(actor, S_PLAY_FDTH20);
end;

//----------------------------------------------------------------------------
//
// PROC A_FreeTargMobj
//
//----------------------------------------------------------------------------

procedure A_FreeTargMobj(mo: Pmobj_t);
begin
  mo.momx := 0;
  mo.momy := 0;
  mo.momz := 0;
  mo.z := mo.ceilingz + 4 * FRACUNIT;
  mo.flags := mo.flags and not (MF_SHOOTABLE or MF_FLOAT or MF_SKULLFLY or MF_SOLID or MF_COUNTKILL);
  mo.flags := mo.flags or MF_CORPSE or MF_DROPOFF or MF_NOGRAVITY;
  mo.flags2 := mo.flags2 and not (MF2_PASSMOBJ or MF2_LOGRAV);
  mo.flags_ex :=   mo.flags_ex and (not MF_EX_LOWGRAVITY);
  mo.flags2_ex :=   mo.flags2_ex and (not MF2_EX_MEDIUMGRAVITY);
  mo.flags2 := mo.flags2 or MF2_DONTDRAW;
  mo.player := nil;
  mo.health := -1000;    // Don't resurrect
end;


//----------------------------------------------------------------------------
//
// CorpseQueue Routines
//
//----------------------------------------------------------------------------

// Corpse queue for monsters - this should be saved out
const
  CORPSEQUEUESIZE = 64;

var
  corpseQueue: array[0..CORPSEQUEUESIZE - 1] of Pmobj_t;
  corpseQueueSlot: integer;

// throw another corpse on the queue
procedure A_QueueCorpse(actor: Pmobj_t);
var
  corpse: Pmobj_t;
begin
  if corpseQueueSlot >= CORPSEQUEUESIZE then
  begin // Too many corpses - remove an old one
    corpse := corpseQueue[corpseQueueSlot mod CORPSEQUEUESIZE];
    if corpse <> nil then
      P_RemoveMobj(corpse);
  end;
  corpseQueue[corpseQueueSlot mod CORPSEQUEUESIZE] := actor;
  inc(corpseQueueSlot);
end;

// Remove a mobj from the queue (for resurrection)
procedure A_DeQueueCorpse(actor: Pmobj_t);
var
  slot: integer;
begin
  for slot := 0 to CORPSEQUEUESIZE - 1 do
  begin
    if corpseQueue[slot] = actor then
    begin
      corpseQueue[slot] := nil;
      exit;
    end;
  end;
end;

procedure P_InitCreatureCorpseQueue(corpseScan: boolean);
var
  think: Pthinker_t;
  mo: Pmobj_t;
begin
  // Initialize queue
  corpseQueueSlot := 0;
  memset(@corpseQueue, 0, SizeOf(Pmobj_t) * CORPSEQUEUESIZE);

  if not corpseScan then
    exit;

  // Search mobj list for corpses and place them in this queue
  think := thinkercap.next;
  while think <> @thinkercap do
  begin
    if @think._function.acp1 <> @P_MobjThinker then
    begin
      think := think.next;
      continue;
    end;

    mo := Pmobj_t(think);
    if mo.flags and MF_CORPSE = 0 then
    begin // Must be a corpse
      think := think.next;
      continue;
    end;

    if mo.flags and MF_ICECORPSE <> 0 then
    begin // Not ice corpses
      think := think.next;
      continue;
    end;

    // Only corpses that call A_QueueCorpse from death routine
    case mobjtype_t(mo._type) of
      MT_CENTAUR,
      MT_CENTAURLEADER,
      MT_DEMON,
      MT_DEMON2,
      MT_WRAITH,
      MT_WRAITHB,
      MT_BISHOP,
      MT_ETTIN,
      MT_PIG,
      MT_CENTAUR_SHIELD,
      MT_CENTAUR_SWORD,
      MT_DEMONCHUNK1,
      MT_DEMONCHUNK2,
      MT_DEMONCHUNK3,
      MT_DEMONCHUNK4,
      MT_DEMONCHUNK5,
      MT_DEMON2CHUNK1,
      MT_DEMON2CHUNK2,
      MT_DEMON2CHUNK3,
      MT_DEMON2CHUNK4,
      MT_DEMON2CHUNK5,
      MT_FIREDEMON_SPLOTCH1,
      MT_FIREDEMON_SPLOTCH2:
        A_QueueCorpse(mo);    // Add corpse to queue
    end;
    think := think.next;
  end;
end;


//----------------------------------------------------------------------------
//
// PROC A_AddPlayerCorpse
//
//----------------------------------------------------------------------------

const
  BODYQUESIZE = 32;

var
  bodyque: array[0..BODYQUESIZE - 1] of Pmobj_t;
  bodyqueslot: integer;

procedure A_AddPlayerCorpse(actor: Pmobj_t);
begin
  if bodyqueslot >= BODYQUESIZE then
  begin // Too many player corpses - remove an old one
    P_RemoveMobj(bodyque[bodyqueslot mod BODYQUESIZE]);
  end;

  bodyque[bodyqueslot mod BODYQUESIZE] := actor;
  inc(bodyqueslot);
end;

//----------------------------------------------------------------------------
//
// A_SerpentUnHide
//
//----------------------------------------------------------------------------

procedure A_SerpentUnHide(actor: Pmobj_t);
begin
  actor.flags2 := actor.flags2 and not MF2_DONTDRAW;
  actor.floorclip := 24 * FRACUNIT;
end;

//----------------------------------------------------------------------------
//
// A_SerpentHide
//
//----------------------------------------------------------------------------

procedure A_SerpentHide(actor: Pmobj_t);
begin
  actor.flags2 := actor.flags2 or MF2_DONTDRAW;
  actor.floorclip := 0;
end;

//----------------------------------------------------------------------------
//
// A_SerpentChase
//
//----------------------------------------------------------------------------

procedure A_SerpentChase(actor: Pmobj_t);
var
  delta: integer;
  oldX, oldY, oldFloor: integer;
begin
  if actor.reactiontime <> 0 then
    dec(actor.reactiontime);

  // Modify target threshold
  if actor.threshold <> 0 then
    dec(actor.threshold);

  if gameskill = sk_nightmare then
  begin // Monsters move faster in nightmare mode
    actor.tics := actor.tics - actor.tics div 2;
    if actor.tics < 3 then
      actor.tics := 3;
  end;

//
// turn towards movement direction if not there yet
//
  if actor.movedir < 8 then
  begin
    actor.angle := actor.angle and $E0000000;
    delta := actor.angle - _SHLW(actor.movedir, 29);
    if delta > 0 then
    begin
      actor.angle := actor.angle - ANG45;
    end
    else if delta < 0 then
    begin
      actor.angle := actor.angle + ANG45;
    end;
  end;

  if (actor.target = nil) or (actor.target.flags and MF_SHOOTABLE = 0) then
  begin // look for a new target
    if P_LookForPlayers(actor, true) then
    begin // got a new target
      exit;
    end;
    P_SetMobjState(actor, statenum_t(actor.info.spawnstate));
    exit;
  end;

//
// don't attack twice in a row
//
  if actor.flags and MF_JUSTATTACKED <> 0 then
  begin
    actor.flags := actor.flags and not MF_JUSTATTACKED;
    if gameskill <> sk_nightmare then
      P_NewChaseDir(actor);
    exit;
  end;

//
// check for melee attack
//
  if (actor.info.meleestate <> 0) and P_CheckMeleeRange(actor) then
  begin
    A_AttackSound(actor);
    P_SetMobjState (actor, statenum_t(actor.info.meleestate));
    exit;
  end;

//
// possibly choose another target
//
  if netgame and (actor.threshold = 0) and not P_CheckSight(actor, actor.target) then
    if P_LookForPlayers(actor,true) then
      exit;         // got a new target

//
// chase towards player
//
  oldX := actor.x;
  oldY := actor.y;
  oldFloor := Psubsector_t(actor.subsector).sector.floorpic;
  dec(actor.movecount);
  if (actor.movecount < 0) or not P_Move(actor) then
    P_NewChaseDir (actor);

  if Psubsector_t(actor.subsector).sector.floorpic <> oldFloor then
  begin
    P_TryMove(actor, oldX, oldY);
    P_NewChaseDir(actor);
  end;

//
// make active sound
//
  if P_Random < 3 then
    A_ActiveSound(actor);
end;

//----------------------------------------------------------------------------
//
// A_SerpentRaiseHump
//
// Raises the hump above the surface by raising the floorclip level
//----------------------------------------------------------------------------

procedure A_SerpentRaiseHump(actor: Pmobj_t);
begin
  actor.floorclip := actor.floorclip - 4 * FRACUNIT;
end;

//----------------------------------------------------------------------------
//
// A_SerpentLowerHump
//
//----------------------------------------------------------------------------

procedure A_SerpentLowerHump(actor: Pmobj_t);
begin
  actor.floorclip := actor.floorclip + 4 * FRACUNIT;
end;

//----------------------------------------------------------------------------
//
// A_SerpentHumpDecide
//
//    Decided whether to hump up, or if the mobj is a serpent leader,
//      to missile attack
//----------------------------------------------------------------------------

procedure A_SerpentHumpDecide(actor: Pmobj_t);
begin
  if actor._type = Ord(MT_SERPENTLEADER) then
  begin
    if P_Random > 30 then
    begin
      exit;
    end
    else if P_Random < 40 then
    begin // Missile attack
      P_SetMobjState(actor, S_SERPENT_SURFACE1);
      exit;
    end;
  end
  else if P_Random > 3 then
  begin
    exit;
  end;

  if not P_CheckMeleeRange(actor) then
  begin // The hump shouldn't occur when within melee range
    if (actor._type = Ord(MT_SERPENTLEADER)) and (P_Random < 128) then
    begin
      P_SetMobjState(actor, S_SERPENT_SURFACE1);
    end
    else
    begin
      P_SetMobjState(actor, S_SERPENT_HUMP1);
      S_StartSound(actor, Ord(SFX_SERPENT_ACTIVE));
    end;
  end;
end;

//----------------------------------------------------------------------------
//
// A_SerpentBirthScream
//
//----------------------------------------------------------------------------

procedure A_SerpentBirthScream(actor: Pmobj_t);
begin
  S_StartSound(actor, Ord(SFX_SERPENT_BIRTH));
end;

//----------------------------------------------------------------------------
//
// A_SerpentDiveSound
//
//----------------------------------------------------------------------------

procedure A_SerpentDiveSound(actor: Pmobj_t);
begin
  S_StartSound(actor, Ord(SFX_SERPENT_ACTIVE));
end;

//----------------------------------------------------------------------------
//
// A_SerpentWalk
//
// Similar to A_Chase, only has a hardcoded entering of meleestate
//----------------------------------------------------------------------------

procedure A_SerpentWalk(actor: Pmobj_t);
var
  delta: integer;
begin
  if actor.reactiontime <> 0 then
  begin
    dec(actor.reactiontime);
  end;

  // Modify target threshold
  if actor.threshold <> 0 then
  begin
    dec(actor.threshold);
  end;

  if gameskill = sk_nightmare then
  begin // Monsters move faster in nightmare mode
    actor.tics := actor.tics - actor.tics div 2;
    if actor.tics < 3 then
      actor.tics := 3;
  end;

//
// turn towards movement direction if not there yet
//
  if actor.movedir < 8 then
  begin
    actor.angle := actor.angle and $E0000000;
    delta := actor.angle - _SHLW(actor.movedir, 29);
    if delta > 0 then
      actor.angle := actor.angle - ANG45
    else if delta < 0 then
      actor.angle := actor.angle + ANG45
  end;

  if (actor.target = nil) or (actor.target.flags and MF_SHOOTABLE = 0) then
  begin // look for a new target
    if P_LookForPlayers(actor, true) then
    begin // got a new target
      exit;
    end;
    P_SetMobjState(actor, statenum_t(actor.info.spawnstate));
    exit;
  end;

//
// don't attack twice in a row
//
  if actor.flags and MF_JUSTATTACKED <> 0 then
  begin
    actor.flags := actor.flags and not MF_JUSTATTACKED;
    if gameskill <> sk_nightmare then
      P_NewChaseDir(actor);
    exit;
  end;

//
// check for melee attack
//
  if (actor.info.meleestate <> 0) and P_CheckMeleeRange(actor) then
  begin
    A_AttackSound(actor);
    P_SetMobjState(actor, S_SERPENT_ATK1);
    exit;
  end;
//
// possibly choose another target
//
  if netgame and (actor.threshold = 0) and not P_CheckSight(actor, actor.target) then
    if P_LookForPlayers(actor,true) then
      exit;         // got a new target

//
// chase towards player
//
  dec(actor.movecount);
  if (actor.movecount < 0) or not P_Move(actor) then
    P_NewChaseDir(actor);
end;

//----------------------------------------------------------------------------
//
// A_SerpentCheckForAttack
//
//----------------------------------------------------------------------------

procedure A_SerpentCheckForAttack(actor: Pmobj_t);
begin
  if actor.target = nil then
    exit;

  if actor._type = Ord(MT_SERPENTLEADER) then
  begin
    if not P_CheckMeleeRange(actor) then
    begin
      P_SetMobjState(actor, S_SERPENT_ATK1);
      exit;
    end;
  end;
  if P_CheckMeleeRange2(actor) then
  begin
    P_SetMobjState(actor, S_SERPENT_WALK1);
  end
  else if P_CheckMeleeRange(actor) then
  begin
    if P_Random < 32 then
    begin
      P_SetMobjState(actor, S_SERPENT_WALK1);
    end
    else
    begin
      P_SetMobjState(actor, S_SERPENT_ATK1);
    end;
  end;
end;

//----------------------------------------------------------------------------
//
// A_SerpentChooseAttack
//
//----------------------------------------------------------------------------

procedure A_SerpentChooseAttack(actor: Pmobj_t);
begin
  if (actor.target = nil) or P_CheckMeleeRange(actor) then
    exit;

  if actor._type = Ord(MT_SERPENTLEADER) then
    P_SetMobjState(actor, S_SERPENT_MISSILE1);
end;

//----------------------------------------------------------------------------
//
// A_SerpentMeleeAttack
//
//----------------------------------------------------------------------------

procedure A_SerpentMeleeAttack(actor: Pmobj_t);
begin
  if actor.target = nil then
    exit;

  if P_CheckMeleeRange(actor) then
  begin
    P_DamageMobj(actor.target, actor, actor, HITDICE(5));
    S_StartSound(actor, Ord(SFX_SERPENT_MELEEHIT));
  end;

  if P_Random < 96 then
    A_SerpentCheckForAttack(actor);
end;

//----------------------------------------------------------------------------
//
// A_SerpentMissileAttack
//
//----------------------------------------------------------------------------

procedure A_SerpentMissileAttack(actor: Pmobj_t);
begin
  if actor.target <> nil then
    P_SpawnMissile(actor, actor.target, Ord(MT_SERPENTFX));
end;

//----------------------------------------------------------------------------
//
// A_SerpentHeadPop
//
//----------------------------------------------------------------------------

procedure A_SerpentHeadPop(actor: Pmobj_t);
begin
  P_SpawnMobj(actor.x, actor.y, actor.z + 45 * FRACUNIT, Ord(MT_SERPENT_HEAD));
end;

//----------------------------------------------------------------------------
//
// A_SerpentSpawnGibs
//
//----------------------------------------------------------------------------

procedure A_SerpentSpawnGibs(actor: Pmobj_t);
var
  mo: Pmobj_t;
begin
  mo := P_SpawnMobj(actor.x + ((P_Random - 128) * $1000),
                    actor.y + ((P_Random - 128) * $1000),
                    actor.floorz + FRACUNIT,
                    Ord(MT_SERPENT_GIB1));
  if mo <> nil then
  begin
    mo.momx := (P_Random - 128) * 64;
    mo.momy := (P_Random - 128) * 64;
    mo.floorclip := 6 * FRACUNIT;
  end;
  mo := P_SpawnMobj(actor.x + ((P_Random - 128) * $1000),
                    actor.y + ((P_Random - 128) * $1000),
                    actor.floorz + FRACUNIT,
                    Ord(MT_SERPENT_GIB2));
  if mo <> nil then
  begin
    mo.momx := (P_Random - 128) * 64;
    mo.momy := (P_Random - 128) * 64;
    mo.floorclip := 6 * FRACUNIT;
  end;
  mo := P_SpawnMobj(actor.x + ((P_Random - 128) * $1000),
                    actor.y + ((P_Random - 128) * $1000),
                    actor.floorz + FRACUNIT,
                    Ord(MT_SERPENT_GIB3));
  if mo <> nil then
  begin
    mo.momx := (P_Random - 128) * 64;
    mo.momy := (P_Random - 128) * 64;
    mo.floorclip := 6 * FRACUNIT;
  end;
end;

//----------------------------------------------------------------------------
//
// A_FloatGib
//
//----------------------------------------------------------------------------

procedure A_FloatGib(actor: Pmobj_t);
begin
  actor.floorclip := actor.floorclip - FRACUNIT;
end;

//----------------------------------------------------------------------------
//
// A_SinkGib
//
//----------------------------------------------------------------------------

procedure A_SinkGib(actor: Pmobj_t);
begin
  actor.floorclip := actor.floorclip + FRACUNIT;
end;

//----------------------------------------------------------------------------
//
// A_DelayGib
//
//----------------------------------------------------------------------------

procedure A_DelayGib(actor: Pmobj_t);
begin
  actor.tics := actor.tics - P_Random div 4;
end;

//----------------------------------------------------------------------------
//
// A_SerpentHeadCheck
//
//----------------------------------------------------------------------------

procedure A_SerpentHeadCheck(actor: Pmobj_t);
begin
  if actor.z <= actor.floorz then
  begin
    if P_GetThingFloorType(actor) >= FLOOR_LIQUID then
    begin
      P_HitFloor(actor);
      P_SetMobjState(actor, S_NULL);
    end
    else
    begin
      P_SetMobjState(actor, S_SERPENT_HEAD_X1);
    end;
  end;
end;

//----------------------------------------------------------------------------
//
// A_CentaurAttack
//
//----------------------------------------------------------------------------

procedure A_CentaurAttack(actor: Pmobj_t);
begin
  if actor.target = nil then
    exit;

  if P_CheckMeleeRange(actor) then
    P_DamageMobj(actor.target, actor, actor, P_Random mod 7 + 3);
end;

//----------------------------------------------------------------------------
//
// A_CentaurAttack2
//
//----------------------------------------------------------------------------

procedure A_CentaurAttack2(actor: Pmobj_t);
begin
  if actor.target = nil then
    exit;

  P_SpawnMissile(actor, actor.target, Ord(MT_CENTAUR_FX));
  S_StartSound(actor, Ord(SFX_CENTAURLEADER_ATTACK));
end;

//----------------------------------------------------------------------------
//
// A_CentaurDropStuff
//
//   Spawn shield/sword sprites when the centaur pulps //----------------------------------------------------------------------------

procedure A_CentaurDropStuff(actor: Pmobj_t);
var
  mo: Pmobj_t;
  angle: angle_t;
begin
  mo := P_SpawnMobj(actor.x, actor.y, actor.z + 45 * FRACUNIT, Ord(MT_CENTAUR_SHIELD));
  if mo <> nil then
  begin
    angle := actor.angle + ANG90;
    mo.momz := FRACUNIT * 8 + (P_Random * 1024);
    mo.momx := FixedMul((P_Random - 128) * 2048 + FRACUNIT, finecosine[angle shr ANGLETOFINESHIFT]);
    mo.momy := FixedMul((P_Random - 128) * 2048 + FRACUNIT, finesine[angle shr ANGLETOFINESHIFT]);
    mo.target := actor;
  end;
  mo := P_SpawnMobj(actor.x, actor.y, actor.z + 45 * FRACUNIT, Ord(MT_CENTAUR_SWORD));
  if mo <> nil then
  begin
    angle := actor.angle - ANG90;
    mo.momz := FRACUNIT * 8 + (P_Random * 1024);
    mo.momx := FixedMul((P_Random - 128) * 2048 + FRACUNIT, finecosine[angle shr ANGLETOFINESHIFT]);
    mo.momy := FixedMul((P_Random - 128) * 2048 + FRACUNIT, finesine[angle shr ANGLETOFINESHIFT]);
    mo.target := actor;
  end;
end;

//----------------------------------------------------------------------------
//
// A_CentaurDefend
//
//----------------------------------------------------------------------------

procedure A_CentaurDefend(actor: Pmobj_t);
begin
  A_FaceTarget(actor);
  if P_CheckMeleeRange(actor) and (P_Random < 32) then
  begin
    A_UnSetInvulnerable(actor);
    P_SetMobjState(actor, statenum_t(actor.info.meleestate));
  end;
end;

//----------------------------------------------------------------------------
//
// A_BishopAttack
//
//----------------------------------------------------------------------------

procedure A_BishopAttack(actor: Pmobj_t);
begin
  if actor.target = nil then
    exit;

  A_AttackSound(actor);

  if P_CheckMeleeRange(actor) then
    P_DamageMobj(actor.target, actor, actor, HITDICE(4))
  else
    actor.special1 := (P_Random and 3) + 5;
end;

//----------------------------------------------------------------------------
//
// A_BishopAttack2
//
//    Spawns one of a string of bishop missiles
//----------------------------------------------------------------------------

procedure A_BishopAttack2(actor: Pmobj_t);
var
  mo: Pmobj_t;
begin
  if (actor.target = nil) or (actor.special1 = 0) then
  begin
    actor.special1 := 0;
    P_SetMobjState(actor, S_BISHOP_WALK1);
    exit;
  end;

  mo := P_SpawnMissile(actor, actor.target, Ord(MT_BISH_FX));
  if mo <> nil then
  begin
    mo.special1 := integer(actor.target);
    mo.special2 := 16; // High word = x/y, Low word = z
  end;
  dec(actor.special1);
end;

//----------------------------------------------------------------------------
//
// A_BishopMissileWeave
//
//----------------------------------------------------------------------------

procedure A_BishopMissileWeave(actor: Pmobj_t);
var
  newX, newY: fixed_t;
  weaveXY, weaveZ: integer;
  angle: angle_t;
begin
  weaveXY := FixedInt(actor.special2);
  weaveZ := actor.special2 and $FFFF;
  angle := (actor.angle + ANG90) shr ANGLETOFINESHIFT;
  newX := actor.x - FixedMul(finecosine[angle], FloatBobOffsets[weaveXY] * 2);
  newY := actor.y - FixedMul(finesine[angle], FloatBobOffsets[weaveXY] * 2);
  weaveXY := (weaveXY + 2) and 63;
  newX := newX + FixedMul(finecosine[angle], FloatBobOffsets[weaveXY] * 2);
  newY := newY + FixedMul(finesine[angle], FloatBobOffsets[weaveXY] * 2);
  P_TryMove(actor, newX, newY);
  actor.z := actor.z - FloatBobOffsets[weaveZ];
  weaveZ := (weaveZ + 2) and 63;
  actor.z := actor.z + FloatBobOffsets[weaveZ];
  actor.special2 := weaveZ + (weaveXY * FRACUNIT);
end;

//----------------------------------------------------------------------------
//
// A_BishopMissileSeek
//
//----------------------------------------------------------------------------

procedure A_BishopMissileSeek(actor: Pmobj_t);
begin
  P_SeekerMissile(actor, ANG1 * 2, ANG1 * 3);
end;

//----------------------------------------------------------------------------
//
// A_BishopDecide
//
//----------------------------------------------------------------------------

procedure A_BishopDecide(actor: Pmobj_t);
begin
  if P_Random >= 220 then
    P_SetMobjState(actor, S_BISHOP_BLUR1);
end;

//----------------------------------------------------------------------------
//
// A_BishopDoBlur
//
//----------------------------------------------------------------------------

procedure A_BishopDoBlur(actor: Pmobj_t);
begin
  actor.special1 := (P_Random and 3) + 3; // Random number of blurs
  if P_Random < 120 then
    P_ThrustMobj(actor, actor.angle + ANG90, 11 * FRACUNIT)
  else if P_Random > 125 then
    P_ThrustMobj(actor, actor.angle - ANG90, 11 * FRACUNIT)
  else // Thrust forward
    P_ThrustMobj(actor, actor.angle, 11 * FRACUNIT);
  S_StartSound(actor, Ord(SFX_BISHOP_BLUR));
end;

//----------------------------------------------------------------------------
//
// A_BishopSpawnBlur
//
//----------------------------------------------------------------------------

procedure A_BishopSpawnBlur(actor: Pmobj_t);
var
  mo: Pmobj_t;
begin
  dec(actor.special1);
  if actor.special1 = 0 then
  begin
    actor.momx := 0;
    actor.momy := 0;
    if P_Random > 96 then
      P_SetMobjState(actor, S_BISHOP_WALK1)
    else
      P_SetMobjState(actor, S_BISHOP_ATK1);
  end;
  mo := P_SpawnMobj(actor.x, actor.y, actor.z, Ord(MT_BISHOPBLUR));
  if mo <> nil then
    mo.angle := actor.angle;
end;

//----------------------------------------------------------------------------
//
// A_BishopChase
//
//----------------------------------------------------------------------------

procedure A_BishopChase(actor: Pmobj_t);
begin
  actor.z := actor.z - _SHR1(FloatBobOffsets[actor.special2]);
  actor.special2 := (actor.special2 + 4) and 63;
  actor.z := actor.z + _SHR1(FloatBobOffsets[actor.special2]);
end;

//----------------------------------------------------------------------------
//
// A_BishopPuff
//
//----------------------------------------------------------------------------

procedure A_BishopPuff(actor: Pmobj_t);
var
  mo: Pmobj_t;
begin
  mo := P_SpawnMobj(actor.x, actor.y, actor.z + 40 * FRACUNIT, Ord(MT_BISHOP_PUFF));
  if mo <> nil then
    mo.momz := FRACUNIT div 2;
end;

//----------------------------------------------------------------------------
//
// A_BishopPainBlur
//
//----------------------------------------------------------------------------

procedure A_BishopPainBlur(actor: Pmobj_t);
var
  mo: Pmobj_t;
begin
  if P_Random < 64 then
  begin
    P_SetMobjState(actor, S_BISHOP_BLUR1);
    exit;
  end;

  mo := P_SpawnMobj(actor.x + (P_Random - P_Random) * $1000,
                    actor.y + (P_Random - P_Random) * $1000,
                    actor.z + (P_Random - P_Random) * $800,
                    Ord(MT_BISHOPPAINBLUR));
  if mo <> nil then
    mo.angle := actor.angle;
end;

//----------------------------------------------------------------------------
//
// DragonSeek
//
//----------------------------------------------------------------------------

procedure DragonSeek(actor: Pmobj_t; thresh: angle_t; turnMax: angle_t);
var
  dir: integer;
  dist: integer;
  delta: angle_t;
  angle: angle_t;
  target: Pmobj_t;
  search: integer;
  i: integer;
  bestArg: integer;
  bestAngle: angle_t;
  angleToSpot, angleToTarget: angle_t;
  mo: Pmobj_t;
  oldTarget: Pmobj_t;
  tangle: angle_t;
begin
  target := Pmobj_t(actor.special1);
  if target = nil then
    exit;

  dir := P_FaceMobj(actor, target, @delta);
  if delta > thresh then
  begin
    delta := _SHR1(delta);
    if delta > turnMax then
      delta := turnMax;
  end;
  if dir <> 0 then
  begin // Turn clockwise
    actor.angle := actor.angle + delta;
  end
  else
  begin // Turn counter clockwise
    actor.angle := actor.angle - delta;
  end;
  angle := actor.angle shr ANGLETOFINESHIFT;
  actor.momx := FixedMul(actor.info.speed, finecosine[angle]);
  actor.momy := FixedMul(actor.info.speed, finesine[angle]);
  if (actor.z + actor.height < target.z) or
     (target.z + target.height < actor.z) then
  begin
    dist := P_AproxDistance(target.x - actor.x, target.y - actor.y);
    dist := dist div actor.info.speed;
    if dist < 1 then
      dist := 1;
    actor.momz := (target.z - actor.z) div dist;
  end
  else
  begin
    dist := P_AproxDistance(target.x - actor.x, target.y - actor.y);
    dist := dist div actor.info.speed;
  end;
  if (target.flags and MF_SHOOTABLE <> 0) and (P_Random < 64) then
  begin // attack the destination mobj if it's attackable
    tangle := actor.angle - R_PointToAngle2(actor.x, actor.y, target.x, target.y);
    if (tangle < ANG45 div 2) or (tangle > ANGLE_MAX - ANG45 div 2) then
    begin
      oldTarget := actor.target;
      actor.target := target;
      if P_CheckMeleeRange(actor) then
      begin
        P_DamageMobj(actor.target, actor, actor, HITDICE(10));
        S_StartSound(actor, Ord(SFX_DRAGON_ATTACK));
      end
      else if (P_Random < 128) and P_CheckMissileRange(actor) then
      begin
        P_SpawnMissile(actor, target, Ord(MT_DRAGON_FX));
        S_StartSound(actor, Ord(SFX_DRAGON_ATTACK));
      end;
      actor.target := oldTarget;
    end;
  end;
  if dist < 4 then
  begin // Hit the target thing
    if (actor.target <> nil) and (P_Random < 200) then
    begin
      bestArg := -1;
      bestAngle := ANGLE_MAX;
      angleToTarget := R_PointToAngle2(actor.x, actor.y, actor.target.x, actor.target.y);
      for i := 0 to 4 do
      begin
        if target.args[i] = 0 then
          continue;

        search := -1;
        mo := P_FindMobjFromTID(target.args[i], @search);
        angleToSpot := R_PointToAngle2(actor.x, actor.y, mo.x, mo.y);
        tangle := angleToSpot - angleToTarget;
        if (tangle < bestAngle) or (tangle > ANGLE_MAX - bestAngle) then
        begin
          bestAngle := tangle; // JVAL SOS
          bestArg := i;
        end;
      end;
      if bestArg <> -1 then
      begin
        search := -1;
        actor.special1 := integer(P_FindMobjFromTID(target.args[bestArg], @search));
      end;
    end
    else
    begin
      repeat
        i := _SHR2(P_Random) mod 5;
      until target.args[i] <> 0;
      search := -1;
      actor.special1 := integer(P_FindMobjFromTID(target.args[i], @search));
    end;
  end;
end;

//----------------------------------------------------------------------------
//
// A_DragonInitFlight
//
//----------------------------------------------------------------------------

procedure A_DragonInitFlight(actor: Pmobj_t);
var
  search: integer;
begin
  search := -1;
  repeat  // find the first tid identical to the dragon's tid
    actor.special1 := integer(P_FindMobjFromTID(actor.tid, @search));
    if search = -1 then
    begin
      P_SetMobjState(actor, statenum_t(actor.info.spawnstate));
      exit;
    end;
  until actor.special1 <> integer(actor);
  P_RemoveMobjFromTIDList(actor);
end;

//----------------------------------------------------------------------------
//
// A_DragonFlight
//
//----------------------------------------------------------------------------

procedure A_DragonFlight(actor: Pmobj_t);
var
  angle: angle_t;
  tangle: angle_t;
  angbool: boolean;
begin
  DragonSeek(actor, 4 * ANG1, 8 * ANG1);
  if actor.target <> nil then
  begin
    if actor.target.flags and MF_SHOOTABLE <> 0 then
    begin // target died
      actor.target := nil;
      exit;
    end;
    angle := R_PointToAngle2(actor.x, actor.y, actor.target.x, actor.target.y);
    tangle := actor.angle - angle;
    angbool := (tangle < ANG45 div 2) or (tangle > ANGLE_MAX - ANG45 div 2);
    if angbool and P_CheckMeleeRange(actor) then
    begin
      P_DamageMobj(actor.target, actor, actor, HITDICE(8));
      S_StartSound(actor, Ord(SFX_DRAGON_ATTACK));
    end
    else
    begin
      angbool := (tangle <= ANG1 * 20) or (tangle >= ANGLE_MAX - ANG1 * 20);
      if angbool then
      begin
        P_SetMobjState(actor, statenum_t(actor.info.missilestate));
        S_StartSound(actor, Ord(SFX_DRAGON_ATTACK));
      end;
    end;
  end
  else
    P_LookForPlayers(actor, true);
end;

//----------------------------------------------------------------------------
//
// A_DragonFlap
//
//----------------------------------------------------------------------------

procedure A_DragonFlap(actor: Pmobj_t);
begin
  A_DragonFlight(actor);
  if P_Random < 240 then
    S_StartSound(actor, Ord(SFX_DRAGON_WINGFLAP))
  else
    A_ActiveSound(actor)
end;

//----------------------------------------------------------------------------
//
// A_DragonAttack
//
//----------------------------------------------------------------------------

procedure A_DragonAttack(actor: Pmobj_t);
begin
  P_SpawnMissile(actor, actor.target, Ord(MT_DRAGON_FX));
end;

//----------------------------------------------------------------------------
//
// A_DragonFX2
//
//----------------------------------------------------------------------------

procedure A_DragonFX2(actor: Pmobj_t);
var
  mo: Pmobj_t;
  i: integer;
  delay: integer;
begin
  delay := 16 + _SHR3(P_Random);
  for i := 1 + (P_Random and 3) downto 0 do
  begin
    mo := P_SpawnMobj(actor.x + (P_Random - 128) * $4000,
                      actor.y + (P_Random - 128) * $4000,
                      actor.z + (P_Random - 128) * $1000,
                      Ord(MT_DRAGON_FX2));
    if mo <> nil then
    begin
      mo.tics := delay + (P_Random and 3) * i * 2;
      mo.target := actor.target;
    end;
  end;
end;

//----------------------------------------------------------------------------
//
// A_DragonPain
//
//----------------------------------------------------------------------------

procedure A_DragonPain(actor: Pmobj_t);
begin
  A_Pain(actor);
  if actor.special1 = 0 then // no destination spot yet
    P_SetMobjState(actor, S_DRAGON_INIT);
end;

//----------------------------------------------------------------------------
//
// A_DragonCheckCrash
//
//----------------------------------------------------------------------------

procedure A_DragonCheckCrash(actor: Pmobj_t);
begin
  if actor.z <= actor.floorz then
    P_SetMobjState(actor, S_DRAGON_CRASH1);
end;

//----------------------------------------------------------------------------
// Demon AI
//----------------------------------------------------------------------------

//
// A_DemonAttack1 (melee)
//
procedure A_DemonAttack1(actor: Pmobj_t);
begin
  if P_CheckMeleeRange(actor) then
    P_DamageMobj(actor.target, actor, actor, HITDICE(2));
end;


//
// A_DemonAttack2 (missile)
//
procedure A_DemonAttack2(actor: Pmobj_t);
var
  mo: Pmobj_t;
  fireBall: integer;
begin
  if actor._type = Ord(MT_DEMON) then
    fireBall := Ord(MT_DEMONFX1)
  else
    fireBall := Ord(MT_DEMON2FX1);
  mo := P_SpawnMissile(actor, actor.target, fireBall);
  if mo <> nil then
  begin
    mo.z := mo.z + 30 * FRACUNIT;
    S_StartSound(actor, Ord(SFX_DEMON_MISSILE_FIRE));
  end;
end;

//
// A_DemonDeath
//

procedure A_DemonDeath(actor: Pmobj_t);
var
  mo: Pmobj_t;
  angle: angle_t;
begin
  mo := P_SpawnMobj(actor.x, actor.y, actor.z + 45 * FRACUNIT, Ord(MT_DEMONCHUNK1));
  if mo <> nil then
  begin
    angle := actor.angle + ANG90;
    mo.momz := 8 * FRACUNIT;
    mo.momx := FixedMul((P_Random * 1024) + FRACUNIT, finecosine[angle shr ANGLETOFINESHIFT]);
    mo.momy := FixedMul((P_Random * 1024) + FRACUNIT, finesine[angle shr ANGLETOFINESHIFT]);
    mo.target := actor;
  end;
  mo := P_SpawnMobj(actor.x, actor.y, actor.z + 45 * FRACUNIT, Ord(MT_DEMONCHUNK2));
  if mo <> nil then
  begin
    angle := actor.angle - ANG90;
    mo.momz := 8 * FRACUNIT;
    mo.momx := FixedMul((P_Random * 1024) + FRACUNIT, finecosine[angle shr ANGLETOFINESHIFT]);
    mo.momy := FixedMul((P_Random * 1024) + FRACUNIT, finesine[angle shr ANGLETOFINESHIFT]);
    mo.target := actor;
  end;
  mo := P_SpawnMobj(actor.x, actor.y, actor.z + 45 * FRACUNIT, Ord(MT_DEMONCHUNK3));
  if mo <> nil then
  begin
    angle := actor.angle - ANG90;
    mo.momz := 8 * FRACUNIT;
    mo.momx := FixedMul((P_Random * 1024) + FRACUNIT, finecosine[angle shr ANGLETOFINESHIFT]);
    mo.momy := FixedMul((P_Random * 1024) + FRACUNIT, finesine[angle shr ANGLETOFINESHIFT]);
    mo.target := actor;
  end;
  mo := P_SpawnMobj(actor.x, actor.y, actor.z + 45 * FRACUNIT, Ord(MT_DEMONCHUNK4));
  if mo <> nil then
  begin
    angle := actor.angle - ANG90;
    mo.momz := 8 * FRACUNIT;
    mo.momx := FixedMul((P_Random * 1024) + FRACUNIT,
      finecosine[angle shr ANGLETOFINESHIFT]);
    mo.momy := FixedMul((P_Random * 1024) + FRACUNIT,
      finesine[angle shr ANGLETOFINESHIFT]);
    mo.target := actor;
  end;
  mo := P_SpawnMobj(actor.x, actor.y, actor.z + 45 * FRACUNIT, Ord(MT_DEMONCHUNK5));
  if mo <> nil then
  begin
    angle := actor.angle - ANG90;
    mo.momz := 8 * FRACUNIT;
    mo.momx := FixedMul((P_Random * 1024) + FRACUNIT, finecosine[angle shr ANGLETOFINESHIFT]);
    mo.momy := FixedMul((P_Random * 1024) + FRACUNIT, finesine[angle shr ANGLETOFINESHIFT]);
    mo.target := actor;
  end;
end;

//===========================================================================
//
// A_Demon2Death
//
//===========================================================================

procedure A_Demon2Death(actor: Pmobj_t);
var
  mo: Pmobj_t;
  angle: angle_t;
begin
  mo := P_SpawnMobj(actor.x, actor.y, actor.z + 45 * FRACUNIT, Ord(MT_DEMON2CHUNK1));
  if mo <> nil then
  begin
    angle := actor.angle + ANG90;
    mo.momz := 8 * FRACUNIT;
    mo.momx := FixedMul((P_Random * 1024) + FRACUNIT, finecosine[angle shr ANGLETOFINESHIFT]);
    mo.momy := FixedMul((P_Random * 1024) + FRACUNIT, finesine[angle shr ANGLETOFINESHIFT]);
    mo.target := actor;
  end;
  mo := P_SpawnMobj(actor.x, actor.y, actor.z + 45 * FRACUNIT, Ord(MT_DEMON2CHUNK2));
  if mo <> nil then
  begin
    angle := actor.angle - ANG90;
    mo.momz := 8 * FRACUNIT;
    mo.momx := FixedMul((P_Random * 1024) + FRACUNIT, finecosine[angle shr ANGLETOFINESHIFT]);
    mo.momy := FixedMul((P_Random * 1024) + FRACUNIT, finesine[angle shr ANGLETOFINESHIFT]);
    mo.target := actor;
  end;
  mo := P_SpawnMobj(actor.x, actor.y, actor.z + 45 * FRACUNIT, Ord(MT_DEMON2CHUNK3));
  if mo <> nil then
  begin
    angle := actor.angle - ANG90;
    mo.momz := 8 * FRACUNIT;
    mo.momx := FixedMul((P_Random * 1024) + FRACUNIT, finecosine[angle shr ANGLETOFINESHIFT]);
    mo.momy := FixedMul((P_Random * 1024) + FRACUNIT, finesine[angle shr ANGLETOFINESHIFT]);
    mo.target := actor;
  end;
  mo := P_SpawnMobj(actor.x, actor.y, actor.z + 45 * FRACUNIT, Ord(MT_DEMON2CHUNK4));
  if mo <> nil then
  begin
    angle := actor.angle - ANG90;
    mo.momz := 8 * FRACUNIT;
    mo.momx := FixedMul((P_Random * 1024) + FRACUNIT, finecosine[angle shr ANGLETOFINESHIFT]);
    mo.momy := FixedMul((P_Random * 1024) + FRACUNIT, finesine[angle shr ANGLETOFINESHIFT]);
    mo.target := actor;
  end;
  mo := P_SpawnMobj(actor.x, actor.y, actor.z + 45 * FRACUNIT, Ord(MT_DEMON2CHUNK5));
  if mo <> nil then
  begin
    angle := actor.angle - ANG90;
    mo.momz := 8 * FRACUNIT;
    mo.momx := FixedMul((P_Random * 1024) + FRACUNIT, finecosine[angle shr ANGLETOFINESHIFT]);
    mo.momy := FixedMul((P_Random * 1024) + FRACUNIT, finesine[angle shr ANGLETOFINESHIFT]);
    mo.target := actor;
  end;
end;



//
// A_SinkMobj
// Sink a mobj incrementally into the floor
//

function A_SinkMobj(actor: Pmobj_t): boolean;
begin
  if actor.floorclip <  actor.info.height then
  begin
    case actor._type of
      Ord(MT_THRUSTFLOOR_DOWN),
      Ord(MT_THRUSTFLOOR_UP):
        actor.floorclip := actor.floorclip + 6 * FRACUNIT;
    else
      actor.floorclip := actor.floorclip + FRACUNIT;
    end;
    result := false;
    exit;
  end;

  result := true;
end;

//
// A_RaiseMobj
// Raise a mobj incrementally from the floor to
//

function A_RaiseMobj(actor: Pmobj_t): boolean;
begin
  result := true;
  // Raise a mobj from the ground
  if actor.floorclip > 0 then
  begin
    case actor._type of
      Ord(MT_WRAITHB):
        actor.floorclip := actor.floorclip - 2 * FRACUNIT;
      Ord(MT_THRUSTFLOOR_DOWN),
      Ord(MT_THRUSTFLOOR_UP):
        actor.floorclip := actor.floorclip - actor.special2 * FRACUNIT;
    else
      actor.floorclip := actor.floorclip - 2 * FRACUNIT;
    end;
    if actor.floorclip <= 0 then
    begin
      actor.floorclip := 0;
    end
    else
    begin
      result := false;
    end;
  end;
end;


//----------------------------------------------------------------------------
// Wraith Variables
//
//  special1        Internal index into floatbob
//  special2
//----------------------------------------------------------------------------

//
// A_WraithInit
//

procedure A_WraithInit(actor: Pmobj_t);
begin
  actor.z := actor.z + 48 * FRACUNIT;
  actor.special1 := 0;      // index into floatbob
end;

procedure A_WraithRaiseInit(actor: Pmobj_t);
begin
  actor.flags2 := actor.flags2 and not MF2_DONTDRAW;
  actor.flags2 := actor.flags2 and not MF2_NONSHOOTABLE;
  actor.flags := actor.flags or MF_SHOOTABLE or MF_SOLID;
  actor.floorclip := actor.info.height;
end;

procedure A_WraithRaise(actor: Pmobj_t);
begin
  if A_RaiseMobj(actor) then
  begin
    // Reached it's target height
    P_SetMobjState(actor, S_WRAITH_CHASE1);
  end;

  P_SpawnDirt(actor, actor.radius);
end;


procedure A_WraithMelee(actor: Pmobj_t);
var
  amount: integer;
begin
  // Steal health from target and give to player
  if P_CheckMeleeRange(actor) and (P_Random < 220) then
  begin
    amount := HITDICE(2);
    P_DamageMobj(actor.target, actor, actor, amount);
    actor.health := actor.health + amount;
  end;
end;

procedure A_WraithMissile(actor: Pmobj_t);
var
  mo: Pmobj_t;
begin
  mo := P_SpawnMissile(actor, actor.target, Ord(MT_WRAITHFX1));
  if mo <> nil then
    S_StartSound(actor, Ord(SFX_WRAITH_MISSILE_FIRE));
end;


//
// A_WraithFX2 - spawns sparkle tail of missile
//

procedure A_WraithFX2(actor: Pmobj_t);
var
  mo: Pmobj_t;
  angle: angle_t;
  i: integer;
begin
  for i := 0 to 1 do
  begin
    mo := P_SpawnMobj(actor.x, actor.y, actor.z, Ord(MT_WRAITHFX2));
    if mo <> nil then
    begin
      if P_Random < 128 then
         angle := actor.angle + _SHLW(P_Random, 22)
      else
         angle := actor.angle - _SHLW(P_Random, 22);
      mo.momz := 0;
      mo.momx := FixedMul((P_Random * 128) + FRACUNIT, finecosine[angle shr ANGLETOFINESHIFT]);
      mo.momy := FixedMul((P_Random * 128) + FRACUNIT, finesine[angle shr ANGLETOFINESHIFT]);
      mo.target := actor;
      mo.floorclip := 10 * FRACUNIT;
    end;
  end;
end;


// Spawn an FX3 around the actor during attacks
procedure A_WraithFX3(actor: Pmobj_t);
var
  mo: Pmobj_t;
  numdropped: integer;
  i: integer;
begin
  numdropped := P_Random mod 15;
  for i := 0 to numdropped - 1 do
  begin
      mo := P_SpawnMobj(actor.x, actor.y, actor.z, Ord(MT_WRAITHFX3));
      if mo <> nil then
      begin
        mo.x := mo.x + (P_Random - 128) * 2048;
        mo.y := mo.y + (P_Random - 128) * 2048;
        mo.z := mo.z + (P_Random * 1024);
        mo.target := actor;
      end;
  end;
end;

// Spawn an FX4 during movement
procedure A_WraithFX4(actor: Pmobj_t);
var
  mo: Pmobj_t;
  chance: integer;
  spawn4, spawn5: boolean;
begin
  chance := P_Random;
  if chance < 10 then
  begin
    spawn4 := true;
    spawn5 := false;
  end
  else if chance < 20 then
  begin
    spawn4 := false;
    spawn5 := true;
  end
  else if chance < 25 then
  begin
    spawn4 := true;
    spawn5 := true;
  end
  else
  begin
    spawn4 := false;
    spawn5 := false;
  end;

  if spawn4 then
  begin
    mo := P_SpawnMobj(actor.x, actor.y, actor.z, Ord(MT_WRAITHFX4));
    if mo <> nil then
    begin
      mo.x := mo.x + (P_Random - 128) * $1000;
      mo.y := mo.y + (P_Random - 128) * $1000;
      mo.z := mo.z + (P_Random * 1024);
      mo.target := actor;
    end;
  end;

  if spawn5 then
  begin
    mo := P_SpawnMobj(actor.x, actor.y, actor.z, Ord(MT_WRAITHFX5));
    if mo <> nil then
    begin
      mo.x := mo.x + (P_Random - 128) * 2048;
      mo.y := mo.y + (P_Random - 128) * 2048;
      mo.z := mo.z + (P_Random * 1024);
      mo.target := actor;
    end;
  end;
end;


procedure A_WraithLook(actor: Pmobj_t);
begin
//  A_WraithFX4(actor);    // too expensive
  A_Look(actor);
end;


procedure A_WraithChase(actor: Pmobj_t);
var
  weaveindex: integer;
begin
  weaveindex := actor.special1;
  actor.z := actor.z + FloatBobOffsets[weaveindex];
  actor.special1 := (weaveindex + 2) and 63;
//  if actor.floorclip > 0 then
//  begin
//    P_SetMobjState(actor, S_WRAITH_RAISE2);
//    exit;
//  end;
  A_Chase(actor);
  A_WraithFX4(actor);
end;



//----------------------------------------------------------------------------
// Ettin AI
//----------------------------------------------------------------------------

procedure A_EttinAttack(actor: Pmobj_t);
begin
  if P_CheckMeleeRange(actor) then
    P_DamageMobj(actor.target, actor, actor, HITDICE(2));
end;


procedure A_DropMace(actor: Pmobj_t);
var
  mo: Pmobj_t;
begin
  mo := P_SpawnMobj(actor.x, actor.y, actor.z + _SHR1(actor.height), Ord(MT_ETTIN_MACE));
  if mo <> nil then
  begin
    mo.momx := (P_Random - 128) * 2048;
    mo.momy := (P_Random - 128) * 2048;
    mo.momz := FRACUNIT * 10+(P_Random * 1024);
    mo.target := actor;
  end;
end;


//----------------------------------------------------------------------------
// Fire Demon AI
//
// special1      index into floatbob
// special2      whether strafing or not
//----------------------------------------------------------------------------

procedure A_FiredSpawnRock(actor: Pmobj_t);
var
  mo: Pmobj_t;
  x, y, z: integer;
  rtype: integer;
begin
  case P_Random mod 5 of
    0: rtype := Ord(MT_FIREDEMON_FX1);
    1: rtype := Ord(MT_FIREDEMON_FX2);
    2: rtype := Ord(MT_FIREDEMON_FX3);
    3: rtype := Ord(MT_FIREDEMON_FX4);
  else
    rtype := Ord(MT_FIREDEMON_FX5);
  end;

  x := actor.x + (P_Random - 128) * $1000;
  y := actor.y + (P_Random - 128) * $1000;
  z := actor.z + (P_Random) * 2048;
  mo := P_SpawnMobj(x, y, z, rtype);
  if mo <> nil then
  begin
    mo.target := actor;
    mo.momx := (P_Random - 128) * 1024;
    mo.momy := (P_Random - 128) * 1024;
    mo.momz := P_Random * 1024;
    mo.special1 := 2;    // Number bounces
  end;

  // Initialize fire demon
  actor.special2 := 0;
  actor.flags := actor.flags and not MF_JUSTATTACKED;
end;

procedure A_FiredRocks(actor: Pmobj_t);
begin
  A_FiredSpawnRock(actor);
  A_FiredSpawnRock(actor);
  A_FiredSpawnRock(actor);
  A_FiredSpawnRock(actor);
  A_FiredSpawnRock(actor);
end;

procedure A_FiredAttack(actor: Pmobj_t);
var
  mo: Pmobj_t;
begin
  mo := P_SpawnMissile(actor, actor.target, Ord(MT_FIREDEMON_FX6));
  if mo <> nil then
    S_StartSound(actor, Ord(SFX_FIRED_ATTACK));
end;

procedure A_SmBounce(actor: Pmobj_t);
begin
  // give some more momentum (x,y,&z)
  actor.z := actor.floorz + FRACUNIT;
  actor.momz := (2 * FRACUNIT) + (P_Random * 1024);
  actor.momx := (P_Random mod 3) * FRACUNIT;
  actor.momy := (P_Random mod 3) * FRACUNIT;
end;

const
  FIREDEMON_ATTACK_RANGE = 64 * 8 * FRACUNIT;

procedure A_FiredChase(actor: Pmobj_t);
var
  weaveindex: integer;
  target: Pmobj_t;
  ang: angle_t;
  dist: fixed_t;
begin
  weaveindex := actor.special1;
  target := actor.target;

  if actor.reactiontime > 0 then
    dec(actor.reactiontime);
  if actor.threshold > 0 then
    dec(actor.threshold);

  // Float up and down
  actor.z := actor.z + FloatBobOffsets[weaveindex];
  actor.special1 := (weaveindex + 2) and 63;

  // Insure it stays above certain height
  if actor.z < actor.floorz + (64 * FRACUNIT) then
    actor.z := actor.z + 2 * FRACUNIT;

  if (target = nil) or (actor.target.flags and MF_SHOOTABLE = 0) then
  begin  // Invalid target
    P_LookForPlayers(actor, true);
    exit;
  end;

  // Strafe
  if actor.special2 > 0 then
  begin
    dec(actor.special2);
  end
  else
  begin
    actor.special2 := 0;
    actor.momx := 0;
    actor.momy := 0;
    dist := P_AproxDistance(actor.x - target.x, actor.y - target.y);
    if dist < FIREDEMON_ATTACK_RANGE then
    begin
      if P_Random < 30 then
      begin
        ang := R_PointToAngle2(actor.x, actor.y, target.x, target.y);
        if P_Random < 128 then
          ang := ang + ANG90
        else
          ang := ang - ANG90;
        ang := ang shr ANGLETOFINESHIFT;
        actor.momx := FixedMul(8 * FRACUNIT, finecosine[ang]);
        actor.momy := FixedMul(8 * FRACUNIT, finesine[ang]);
        actor.special2 := 3;    // strafe time
      end;
    end;
  end;

  FaceMovementDirection(actor);

  // Normal movement
  if actor.special2 = 0 then
  begin
    dec(actor.movecount);
    if (actor.movecount < 0) or (not P_Move(actor)) then
      P_NewChaseDir (actor);
  end;

  // Do missile attack
  if actor.flags and MF_JUSTATTACKED = 0 then
  begin
    if P_CheckMissileRange(actor) and (P_Random < 20) then
    begin
      P_SetMobjState(actor, statenum_t(actor.info.missilestate));
      actor.flags := actor.flags or MF_JUSTATTACKED;
      exit;
    end;
  end
  else
    actor.flags := actor.flags and not MF_JUSTATTACKED;

  // make active sound
  if P_Random < 3 then
    A_ActiveSound(actor);
end;

procedure A_FiredSplotch(actor: Pmobj_t);
var
  mo: Pmobj_t;
begin
  mo := P_SpawnMobj(actor.x,actor.y,actor.z, Ord(MT_FIREDEMON_SPLOTCH1));
  if mo <> nil then
  begin
    mo.momx := (P_Random - 128) * 2048;
    mo.momy := (P_Random - 128) * 2048;
    mo.momz := FRACUNIT * 3 + (P_Random * 1024);
  end;
  mo := P_SpawnMobj(actor.x, actor.y, actor.z, Ord(MT_FIREDEMON_SPLOTCH2));
  if mo <> nil then
  begin
    mo.momx := (P_Random - 128) * 2048;
    mo.momy := (P_Random - 128) * 2048;
    mo.momz := FRACUNIT * 3 + (P_Random * 1024);
  end;
end;


//----------------------------------------------------------------------------
//
// A_IceGuyLook
//
//----------------------------------------------------------------------------

procedure A_IceGuyLook(actor: Pmobj_t);
var
  dist: fixed_t;
  an: fixed_t;
begin
  A_Look(actor);
  if P_Random < 64 then
  begin
    dist := _SHR7((P_Random - 128) * actor.radius);
    an := (actor.angle + ANG90) shr ANGLETOFINESHIFT;

    P_SpawnMobj(actor.x + FixedMul(dist, finecosine[an]),
                actor.y + FixedMul(dist, finesine[an]),
                actor.z + 60 * FRACUNIT,
                Ord(MT_ICEGUY_WISP1) + (P_Random and 1));
  end;
end;

//----------------------------------------------------------------------------
//
// A_IceGuyChase
//
//----------------------------------------------------------------------------

procedure A_IceGuyChase(actor: Pmobj_t);
var
  dist: fixed_t;
  an: fixed_t;
  mo: Pmobj_t;
begin
  A_Chase(actor);
  if P_Random < 128 then
  begin
    dist := _SHR7((P_Random - 128) * actor.radius);
    an := (actor.angle + ANG90) shr ANGLETOFINESHIFT;

    mo := P_SpawnMobj(actor.x + FixedMul(dist, finecosine[an]),
                      actor.y + FixedMul(dist, finesine[an]),
                      actor.z + 60 * FRACUNIT,
                      Ord(MT_ICEGUY_WISP1) + (P_Random and 1));
    if mo <> nil then
    begin
      mo.momx := actor.momx;
      mo.momy := actor.momy;
      mo.momz := actor.momz;
      mo.target := actor;
    end;
  end;
end;

//----------------------------------------------------------------------------
//
// A_IceGuyAttack
//
//----------------------------------------------------------------------------

procedure A_IceGuyAttack(actor: Pmobj_t);
var
  an: fixed_t;
begin
  if actor.target = nil then
    exit;

  an := (actor.angle + ANG90) shr ANGLETOFINESHIFT;
  P_SpawnMissileXYZ(actor.x + FixedMul(_SHR1(actor.radius), finecosine[an]),
                    actor.y + FixedMul(_SHR1(actor.radius), finesine[an]),
                    actor.z + 40 * FRACUNIT,
                    actor, actor.target,
                    Ord(MT_ICEGUY_FX));

  an := (actor.angle - ANG90) shr ANGLETOFINESHIFT;
  P_SpawnMissileXYZ(actor.x + FixedMul(_SHR1(actor.radius), finecosine[an]),
                    actor.y + FixedMul(_SHR1(actor.radius), finesine[an]),
                    actor.z + 40 * FRACUNIT,
                    actor, actor.target,
                    Ord(MT_ICEGUY_FX));

  A_AttackSound(actor);
end;

//----------------------------------------------------------------------------
//
// A_IceGuyMissilePuff
//
//----------------------------------------------------------------------------

procedure A_IceGuyMissilePuff(actor: Pmobj_t);
begin
  P_SpawnMobj(actor.x, actor.y, actor.z + 2 * FRACUNIT, Ord(MT_ICEFX_PUFF));
end;

//----------------------------------------------------------------------------
//
// A_IceGuyDie
//
//----------------------------------------------------------------------------

procedure A_IceGuyDie(actor: Pmobj_t);
begin
  actor.momx := 0;
  actor.momy := 0;
  actor.momz := 0;
  actor.height := actor.height * 4;
  A_FreezeDeathChunks(actor);
end;


//----------------------------------------------------------------------------
//
// A_IceGuyMissileExplode
//
//----------------------------------------------------------------------------

procedure A_IceGuyMissileExplode(actor: Pmobj_t);
var
  mo: Pmobj_t;
  i: integer;
begin
  for i := 0 to 7 do
  begin
    mo := P_SpawnMissileAngle(actor, Ord(MT_ICEGUY_FX2), i * ANG45,  -19661);
    if mo <> nil then
      mo.target := actor.target;
  end;
end;



//----------------------------------------------------------------------------
//
//  Sorcerer stuff
//
// Sorcerer Variables
//    special1    Angle of ball 1 (all others relative to that)
//    special2    which ball to stop at in stop mode (MT_???)
//    args[0]      Denfense time
//    args[1]      Number of full rotations since stopping mode
//    args[2]      Target orbit speed for acceleration/deceleration
//    args[3]      Movement mode (see SORC_ macros)
//    args[4]      Current ball orbit speed
//  Sorcerer Ball Variables
//    special1    Previous angle of ball (for woosh)
//    special2    Countdown of rapid fire (FX4)
//    args[0]      If set, don't play the bounce sound when bouncing
//----------------------------------------------------------------------------

const
  SORCBALL_INITIAL_SPEED = 7;
  SORCBALL_TERMINAL_SPEED = 25;
  SORCBALL_SPEED_ROTATIONS = 5;
  SORC_DEFENSE_TIME = 255;
  SORC_DEFENSE_HEIGHT = 45;
  BOUNCE_TIME_UNIT = (TICRATE div 2);
  SORCFX4_RAPIDFIRE_TIME = (6 * 3);    // 3 seconds
  SORCFX4_SPREAD_ANGLE = 20;

  SORC_DECELERATE = 0;
  SORC_ACCELERATE = 1;
  SORC_STOPPING = 2;
  SORC_FIRESPELL = 3;
  SORC_STOPPED = 4;
  SORC_NORMAL = 5;
  SORC_FIRING_SPELL = 6;

  BALL1_ANGLEOFFSET = 0;
  BALL2_ANGLEOFFSET = $55555555;
  BALL3_ANGLEOFFSET = $AAAAAAAA;

//procedure A_SorcBallOrbit(actor: Pmobj_t);
//procedure A_SorcSpinBalls(actor: Pmobj_t);
//procedure A_SpeedBalls(actor: Pmobj_t);
//procedure A_SlowBalls(actor: Pmobj_t);
//procedure A_StopBalls(actor: Pmobj_t);
//procedure A_AccelBalls(actor: Pmobj_t);
//procedure A_DecelBalls(actor: Pmobj_t);
//procedure A_SorcBossAttack(actor: Pmobj_t);
//procedure A_SpawnFizzle(actor: Pmobj_t);
//procedure A_CastSorcererSpell(actor: Pmobj_t);
//procedure A_SorcUpdateBallAngle(actor: Pmobj_t);
//procedure A_BounceCheck(actor: Pmobj_t);
//procedure A_SorcFX1Seek(actor: Pmobj_t);
//procedure A_SorcOffense1(actor: Pmobj_t);
//procedure A_SorcOffense2(actor: Pmobj_t);


// Spawn spinning balls above head - actor is sorcerer
procedure A_SorcSpinBalls(actor: Pmobj_t);
var
  mo: Pmobj_t;
  z: fixed_t;
begin
  A_SlowBalls(actor);
  actor.args[0] := 0;                  // Currently no defense
  actor.args[3] := SORC_NORMAL;
  actor.args[4] := SORCBALL_INITIAL_SPEED;    // Initial orbit speed
  actor.special1 := ANG1;
  z := actor.z - actor.floorclip + actor.info.height;

  mo := P_SpawnMobj(actor.x, actor.y, z, Ord(MT_SORCBALL1));
  if mo <> nil then
  begin
    mo.target := actor;
    mo.special2 := SORCFX4_RAPIDFIRE_TIME;
  end;
  mo := P_SpawnMobj(actor.x, actor.y, z, Ord(MT_SORCBALL2));
  if mo <> nil then
    mo.target := actor;
  mo := P_SpawnMobj(actor.x, actor.y, z, Ord(MT_SORCBALL3));
  if mo <> nil then
    mo.target := actor;
end;


//
// A_SorcBallOrbit ==========================================
//

procedure A_SorcBallOrbit(actor: Pmobj_t);
var
  x, y: integer;
  angle, baseangle: angle_t;
  mode: integer;
  parent: Pmobj_t;
  dist: integer;
  prevangle: angle_t;
begin
  mode := actor.target.args[3];
  parent := Pmobj_t(actor.target);
  dist := parent.radius - (actor.radius  * 2);
  prevangle := actor.special1;
  if actor.target.health <= 0 then
    P_SetMobjState(actor, statenum_t(actor.info.painstate));

  baseangle := angle_t(parent.special1);
  case actor._type of
    Ord(MT_SORCBALL1):
      angle := baseangle + BALL1_ANGLEOFFSET;
    Ord(MT_SORCBALL2):
      angle := baseangle + BALL2_ANGLEOFFSET;
    Ord(MT_SORCBALL3):
      angle := baseangle + BALL3_ANGLEOFFSET;
  else
    begin
      I_Error('A_SorcBallOrbit(): corrupted sorcerer');
      angle := 0;
    end;
  end;
  actor.angle := angle;
  angle := angle shr ANGLETOFINESHIFT;

  case mode of
    SORC_NORMAL:        // Balls rotating normally
      A_SorcUpdateBallAngle(actor);
    SORC_DECELERATE:    // Balls decelerating
      begin
        A_DecelBalls(actor);
        A_SorcUpdateBallAngle(actor);
      end;
    SORC_ACCELERATE:    // Balls accelerating
      begin
        A_AccelBalls(actor);
        A_SorcUpdateBallAngle(actor);
      end;
    SORC_STOPPING:      // Balls stopping
      begin
        if (parent.special2 = actor._type) and
           (parent.args[1] > SORCBALL_SPEED_ROTATIONS) and
           (abs(angle - (parent.angle shr ANGLETOFINESHIFT)) < (30 shl 5)) then
        begin
          // Can stop now
          actor.target.args[3] := SORC_FIRESPELL;
          actor.target.args[4] := 0;
          // Set angle so ball angle = sorcerer angle
          case actor._type of
            Ord(MT_SORCBALL1):
              parent.special1 := integer(parent.angle - BALL1_ANGLEOFFSET);
            Ord(MT_SORCBALL2):
              parent.special1 := integer(parent.angle - BALL2_ANGLEOFFSET);
            Ord(MT_SORCBALL3):
              parent.special1 := integer(parent.angle - BALL3_ANGLEOFFSET);
          end;
        end
        else
          A_SorcUpdateBallAngle(actor);
      end;
    SORC_FIRESPELL:      // Casting spell
      begin
        if parent.special2 = actor._type then
        begin
          // Put sorcerer into special throw spell anim
          if parent.health > 0 then
            P_SetMobjStateNF(parent, S_SORC_ATTACK1);

          if (actor._type = Ord(MT_SORCBALL1)) and (P_Random < 200) then
          begin
            S_StartSound(nil, Ord(SFX_SORCERER_SPELLCAST));
            actor.special2 := SORCFX4_RAPIDFIRE_TIME;
            actor.args[4] := 128;
            parent.args[3] := SORC_FIRING_SPELL;
          end
          else
          begin
            A_CastSorcererSpell(actor);
            parent.args[3] := SORC_STOPPED;
          end;
        end;
      end;
    SORC_FIRING_SPELL:
      begin
        if parent.special2 = actor._type then
        begin
          dec(actor.special2);
          if actor.special2 <= 0 then
          begin
            // Done rapid firing
            parent.args[3] := SORC_STOPPED;
            // Back to orbit balls
            if parent.health > 0 then
              P_SetMobjStateNF(parent, S_SORC_ATTACK4);
          end
          else
          begin
            // Do rapid fire spell
            A_SorcOffense2(actor);
          end;
        end;
      end;
  end;

  if (angle < prevangle) and (parent.args[4] = SORCBALL_TERMINAL_SPEED) then
  begin
    inc(parent.args[1]);      // Bump rotation counter
    // Completed full rotation - make woosh sound
    S_StartSound(actor, Ord(SFX_SORCERER_BALLWOOSH));
  end;
  actor.special1 := angle;    // Set previous angle
  x := parent.x + FixedMul(dist, finecosine[angle]);
  y := parent.y + FixedMul(dist, finesine[angle]);
  actor.x := x;
  actor.y := y;
  actor.z := parent.z - parent.floorclip + parent.info.height;
end;


//
// Set balls to speed mode - actor is sorcerer
//
procedure A_SpeedBalls(actor: Pmobj_t);
begin
  actor.args[3] := SORC_ACCELERATE;        // speed mode
  actor.args[2] := SORCBALL_TERMINAL_SPEED;    // target speed
end;


//
// Set balls to slow mode - actor is sorcerer
//
procedure A_SlowBalls(actor: Pmobj_t);
begin
  actor.args[3] := SORC_DECELERATE;        // slow mode
  actor.args[2] := SORCBALL_INITIAL_SPEED;    // target speed
end;


//
// Instant stop when rotation gets to ball in special2
//    actor is sorcerer
//
procedure A_StopBalls(actor: Pmobj_t);
var
  chance: integer;
begin
  chance := P_Random;
  actor.args[3] := SORC_STOPPING;        // stopping mode
  actor.args[1] := 0;              // Reset rotation counter

  if (actor.args[0] <= 0) and (chance < 200) then
    actor.special2 := Ord(MT_SORCBALL2)  // Blue
  else if (actor.health < _SHR1(actor.info.spawnhealth)) and (chance < 200) then
    actor.special2 := Ord(MT_SORCBALL3)  // Green
  else
    actor.special2 := Ord(MT_SORCBALL1); // Yellow
end;


//
// Increase ball orbit speed - actor is ball
//
procedure A_AccelBalls(actor: Pmobj_t);
var
  sorc: Pmobj_t;
begin
  sorc := actor.target;
  if sorc.args[4] < sorc.args[2] then
  begin
    inc(sorc.args[4]);
  end
  else
  begin
    sorc.args[3] := SORC_NORMAL;
    if sorc.args[4] >= SORCBALL_TERMINAL_SPEED then
    begin
      // Reached terminal velocity - stop balls
      A_StopBalls(sorc);
    end;
  end;
end;


// Decrease ball orbit speed - actor is ball
procedure A_DecelBalls(actor: Pmobj_t);
var
  sorc: Pmobj_t;
begin
  sorc := actor.target;
  if sorc.args[4] > sorc.args[2] then
  begin
    dec(sorc.args[4]);
  end
  else
  begin
    sorc.args[3] := SORC_NORMAL;
  end;
end;


// Update angle if first ball - actor is ball
procedure A_SorcUpdateBallAngle(actor: Pmobj_t);
begin
  if actor._type = Ord(MT_SORCBALL1) then
    actor.target.special1 := actor.target.special1 + ANG1 * actor.target.args[4];
end;


// actor is ball
procedure A_CastSorcererSpell(actor: Pmobj_t);
var
  mo: Pmobj_t;
  spell: integer;
  ang_1, ang_2: angle_t;
  z: fixed_t;
  parent: Pmobj_t;
begin
  spell := actor._type;
  parent := actor.target;

  S_StartSound(nil, Ord(SFX_SORCERER_SPELLCAST));

  // Put sorcerer into throw spell animation
  if parent.health > 0 then
    P_SetMobjStateNF(parent, S_SORC_ATTACK4);

  case spell of
    Ord(MT_SORCBALL1):        // Offensive
      A_SorcOffense1(actor);
    Ord(MT_SORCBALL2):        // Defensive
      begin
        z := parent.z - parent.floorclip + SORC_DEFENSE_HEIGHT * FRACUNIT;
        mo := P_SpawnMobj(actor.x, actor.y, z, Ord(MT_SORCFX2));
        parent.flags2 := parent.flags2 or MF2_INVULNERABLE;
        parent.flags_ex := parent.flags_ex or MF_EX_INVULNERABLE;
        parent.flags2_ex := parent.flags2_ex or MF2_EX_REFLECTIVE;
        parent.args[0] := SORC_DEFENSE_TIME;
        if mo <> nil then
          mo.target := parent;
      end;
    Ord(MT_SORCBALL3):        // Reinforcements
      begin
        ang_1 := actor.angle - ANG45;
        ang_2 := actor.angle + ANG45;
        if actor.health < (actor.info.spawnhealth div 3) then
        begin  // Spawn 2 at a time
          mo := P_SpawnMissileAngle(parent, Ord(MT_SORCFX3), ang_1, 4 * FRACUNIT);
          if mo <> nil then
            mo.target := parent;
          mo := P_SpawnMissileAngle(parent, Ord(MT_SORCFX3), ang_2, 4 * FRACUNIT);
          if mo <> nil then
            mo.target := parent;
        end
        else
        begin
          if P_Random < 128 then
            ang_1 := ang_2;
          mo := P_SpawnMissileAngle(parent, Ord(MT_SORCFX3), ang_1, 4 * FRACUNIT);
          if mo <> nil then
            mo.target := parent;
        end;
      end;
  end;
end;

// actor is ball
procedure A_SorcOffense1(actor: Pmobj_t);
var
  mo: Pmobj_t;
  ang_1, ang_2: angle_t;
  parent: Pmobj_t;
begin
  parent := actor.target;

  ang_1 := actor.angle + ANG1 * 70;
  ang_2 := actor.angle - ANG1 * 70;

  mo := P_SpawnMissileAngle(parent, Ord(MT_SORCFX1), ang_1, 0);
  if mo <> nil then
  begin
    mo.target := parent;
    mo.special1 := integer(parent.target);
    mo.args[4] := BOUNCE_TIME_UNIT;
    mo.args[3] := 15;        // Bounce time in seconds
  end;
  
  mo := P_SpawnMissileAngle(parent, Ord(MT_SORCFX1), ang_2, 0);
  if mo <> nil then
  begin
    mo.target := parent;
    mo.special1 := integer(parent.target);
    mo.args[4] := BOUNCE_TIME_UNIT;
    mo.args[3] := 15;        // Bounce time in seconds
  end;
end;


// Actor is ball
procedure A_SorcOffense2(actor: Pmobj_t);
var
  ang_1: angle_t;
  mo: Pmobj_t;
  index: integer;
  delta: angle_t;
  parent, dest: Pmobj_t;
  dist: integer;
begin
  parent := actor.target;
  dest := parent.target;

  index := actor.args[4] * 32;
  actor.args[4] := actor.args[4] + 15;
  delta := (finesine[index]) * SORCFX4_SPREAD_ANGLE;
  delta := FixedInt(delta) * ANG1;
  ang_1 := actor.angle + delta;
  mo := P_SpawnMissileAngle(parent, Ord(MT_SORCFX4), ang_1, 0);
  if mo <> nil then
  begin
    mo.special2 := TICRATE * 5 div 2;    // 5 seconds  // JVAL 2.5 seconds ????
    dist := P_AproxDistance(dest.x - mo.x, dest.y - mo.y);
    dist := dist div mo.info.speed;
    if dist < 1 then
      dist := 1;
    mo.momz := (dest.z - mo.z) div dist;
  end;
end;


// Resume ball spinning
procedure A_SorcBossAttack(actor: Pmobj_t);
begin
  actor.args[3] := SORC_ACCELERATE;
  actor.args[2] := SORCBALL_INITIAL_SPEED;
end;


// spell cast magic fizzle
procedure A_SpawnFizzle(actor: Pmobj_t);
var
  x, y, z: fixed_t;
  dist: fixed_t;
  angle: angle_t;
  speed: fixed_t;
  rangle: angle_t;
  mo: Pmobj_t;
  ix: integer;
begin
  dist := 5 * FRACUNIT;
  angle := actor.angle shr ANGLETOFINESHIFT;
  speed := actor.info.speed;

  x := actor.x + FixedMul(dist,finecosine[angle]);
  y := actor.y + FixedMul(dist,finesine[angle]);
  z := actor.z - actor.floorclip + _SHR1(actor.height);
  for ix := 0 to 4 do
  begin
    mo := P_SpawnMobj(x, y, z, Ord(MT_SORCSPARK1));
    if mo <> nil then
    begin
      rangle := angle + _SHRW(P_Random mod 5, 1);
      mo.momx := FixedMul(P_Random mod speed, finecosine[rangle]);
      mo.momy := FixedMul(P_Random mod speed, finesine[rangle]);
      mo.momz := FRACUNIT * 2;
    end;
  end;
end;


//----------------------------------------------------------------------------
// Yellow spell - offense
//----------------------------------------------------------------------------

procedure A_SorcFX1Seek(actor: Pmobj_t);
begin
  A_BounceCheck(actor);
  P_SeekerMissile(actor,ANG1 * 2,ANG1 * 6);
end;


//----------------------------------------------------------------------------
// Blue spell - defense
//----------------------------------------------------------------------------
//
// FX2 Variables
//    special1    current angle
//    special2
//    args[0]    0 := CW,  1 := CCW
//    args[1]
//----------------------------------------------------------------------------

// Split ball in two
procedure A_SorcFX2Split(actor: Pmobj_t);
var
  mo: Pmobj_t;
begin
  mo := P_SpawnMobj(actor.x, actor.y, actor.z, Ord(MT_SORCFX2));
  if mo <> nil then
  begin
    mo.target := actor.target;
    mo.args[0] := 0;                  // CW
    mo.special1 := actor.angle;          // Set angle
    P_SetMobjStateNF(mo, S_SORCFX2_ORBIT1);
  end;

  mo := P_SpawnMobj(actor.x, actor.y, actor.z, Ord(MT_SORCFX2));
  if mo <> nil then
  begin
    mo.target := actor.target;
    mo.args[0] := 1;                  // CCW
    mo.special1 := actor.angle;       // Set angle
    P_SetMobjStateNF(mo, S_SORCFX2_ORBIT1);
  end;

  P_SetMobjStateNF(actor, S_NULL);
end;


// Orbit FX2 about sorcerer
procedure A_SorcFX2Orbit(actor: Pmobj_t);
var
  angle: angle_t;
  x, y, z: fixed_t;
  parent: Pmobj_t;
  dist: fixed_t;
begin
  parent := actor.target;
  dist := parent.info.radius;

  if (parent.health <= 0) or    // Sorcerer is dead
     (parent.args[0] = 0) then  // Time expired
  begin
    P_SetMobjStateNF(actor, statenum_t(actor.info.deathstate));
    parent.args[0] := 0;
    parent.flags2 := parent.flags2 and not MF2_INVULNERABLE;
    parent.flags_ex := parent.flags_ex and not MF_EX_INVULNERABLE; // JVAL old invulnerability flag
    parent.flags2_ex := parent.flags2_ex and not MF2_EX_REFLECTIVE;
  end;

  if actor.args[0] <> 0 then
  begin
    dec(parent.args[0]);
    if parent.args[0] <= 0 then    // Time expired
    begin
      P_SetMobjStateNF(actor, statenum_t(actor.info.deathstate));
      parent.args[0] := 0;
      parent.flags2_ex := parent.flags2_ex and not MF2_EX_REFLECTIVE;
    end;
  end;

  // Move to new position based on angle
  if actor.args[0] <> 0 then  // Counter clock-wise
  begin
    actor.special1 := actor.special1 + ANG1 * 10;
    angle := angle_t(actor.special1) shr ANGLETOFINESHIFT;
    x := parent.x + FixedMul(dist, finecosine[angle]);
    y := parent.y + FixedMul(dist, finesine[angle]);
    z := parent.z - parent.floorclip + SORC_DEFENSE_HEIGHT * FRACUNIT;
    z := z + FixedMul(15 * FRACUNIT, finecosine[angle]);
    // Spawn trailer
    P_SpawnMobj(x,y,z, Ord(MT_SORCFX2_T1));
  end
  else              // Clock wise
  begin
    actor.special1 := actor.special1 - ANG1 * 10;
    angle := angle_t(actor.special1) shr ANGLETOFINESHIFT;
    x := parent.x + FixedMul(dist, finecosine[angle]);
    y := parent.y + FixedMul(dist, finesine[angle]);
    z := parent.z - parent.floorclip + SORC_DEFENSE_HEIGHT * FRACUNIT;
    z := z + FixedMul(20 * FRACUNIT,finesine[angle]);
    // Spawn trailer
    P_SpawnMobj(x,y,z, Ord(MT_SORCFX2_T1));
  end;

  actor.x := x;
  actor.y := y;
  actor.z := z;
end;



//----------------------------------------------------------------------------
// Green spell - spawn bishops
//----------------------------------------------------------------------------

procedure A_SpawnBishop(actor: Pmobj_t);
var
  mo: Pmobj_t;
begin
  mo := P_SpawnMobj(actor.x, actor.y, actor.z, Ord(MT_BISHOP));
  if mo <> nil then
    if not P_TestMobjLocation(mo) then
      P_SetMobjState(mo, S_NULL);
  P_SetMobjState(actor, S_NULL);
end;

procedure A_SmokePuffExit(actor: Pmobj_t);
begin
  P_SpawnMobj(actor.x, actor.y, actor.z, Ord(MT_MNTRSMOKEEXIT));
end;

procedure A_SorcererBishopEntry(actor: Pmobj_t);
begin
  P_SpawnMobj(actor.x, actor.y, actor.z, Ord(MT_SORCFX3_EXPLOSION));
  A_SeeSound(actor);
end;


//----------------------------------------------------------------------------
// FX4 - rapid fire balls
//----------------------------------------------------------------------------

procedure A_SorcFX4Check(actor: Pmobj_t);
begin
  dec(actor.special2);
  if actor.special2 <= 0 then
    P_SetMobjStateNF(actor, statenum_t(actor.info.deathstate));
end;

//----------------------------------------------------------------------------
// Ball death - spawn stuff
//----------------------------------------------------------------------------

procedure A_SorcBallPop(actor: Pmobj_t);
begin
  S_StartSound(nil, Ord(SFX_SORCERER_BALLPOP));
  A_LowGravity(actor);
  actor.momx := ((P_Random mod 10) - 5) * FRACUNIT;
  actor.momy := ((P_Random mod 10) - 5) * FRACUNIT;
  actor.momz := (2 + (P_Random mod 3)) * FRACUNIT;
  actor.special2 := 4 * FRACUNIT;    // Initial bounce factor
  actor.args[4] := BOUNCE_TIME_UNIT;  // Bounce time unit
  actor.args[3] := 5;          // Bounce time in seconds
end;



procedure A_BounceCheck(actor: Pmobj_t);
begin
  dec(actor.args[4]);
  if actor.args[4] <= 0 then
  begin
    dec(actor.args[3]);
    if actor.args[3] <= 0 then
    begin
      P_SetMobjState(actor, statenum_t(actor.info.deathstate));
      case actor._type of
        Ord(MT_SORCBALL1),
        Ord(MT_SORCBALL2),
        Ord(MT_SORCBALL3):
          S_StartSound(nil, Ord(SFX_SORCERER_BIGBALLEXPLODE));
        Ord(MT_SORCFX1):
          S_StartSound(nil, Ord(SFX_SORCERER_HEADSCREAM));
      end;
    end
    else
      actor.args[4] := BOUNCE_TIME_UNIT;
  end;
end;




//----------------------------------------------------------------------------
// Class Bosses
//----------------------------------------------------------------------------
const
  CLASS_BOSS_STRAFE_RANGE = 64 * 10 * FRACUNIT;

procedure A_FastChase(actor: Pmobj_t);
var
  delta: integer;
  dist: fixed_t;
  ang: angle_t;
  target: Pmobj_t;
  nomissile: boolean;
begin

  if actor.reactiontime > 0 then
    dec(actor.reactiontime);

  // Modify target threshold
  if actor.threshold > 0 then
    dec(actor.threshold);

  if gameskill = sk_nightmare then
  begin // Monsters move faster in nightmare mode
    actor.tics := actor.tics - actor.tics div 2;
    if actor.tics < 3 then
      actor.tics := 3;
  end;

//
// turn towards movement direction if not there yet
//
  if actor.movedir < 8 then
  begin
    actor.angle := actor.angle and $E0000000;
    delta := actor.angle - _SHLW(actor.movedir, 29);
    if delta > 0 then
      actor.angle := actor.angle - ANG45
    else if delta < 0 then
      actor.angle := actor.angle + ANG45;
  end;

  if (actor.target = nil) or (actor.target.flags and MF_SHOOTABLE = 0) then
  begin // look for a new target
    if P_LookForPlayers(actor, true) then
    begin // got a new target
      exit;
    end;
    P_SetMobjState(actor, statenum_t(actor.info.spawnstate));
    exit;
  end;

//
// don't attack twice in a row
//
  if actor.flags and MF_JUSTATTACKED <> 0 then
  begin
    actor.flags := actor.flags and not MF_JUSTATTACKED;
    if gameskill <> sk_nightmare then
      P_NewChaseDir(actor);
    exit;
  end;

  // Strafe
  if actor.special2 > 0 then
    dec(actor.special2)
  else
  begin
    target := actor.target;
    actor.special2 := 0;
    actor.momx := 0;
    actor.momy := 0;
    dist := P_AproxDistance(actor.x - target.x, actor.y - target.y);
    if dist < CLASS_BOSS_STRAFE_RANGE then
    begin
      if P_Random < 100 then
      begin
        ang := R_PointToAngle2(actor.x, actor.y, target.x, target.y);
        if P_Random < 128 then
          ang := ang + ANG90
        else
          ang := ang - ANG90;
        ang := ang shr ANGLETOFINESHIFT;
        actor.momx := FixedMul(13 * FRACUNIT, finecosine[ang]);
        actor.momy := FixedMul(13 * FRACUNIT, finesine[ang]);
        actor.special2 := 3;    // strafe time
      end;
    end;
  end;

//
// check for missile attack
//

  if actor.info.missilestate <> 0 then
  begin
    nomissile := false;
    if (gameskill < sk_nightmare) and (actor.movecount <> 0) then
      nomissile := true;
    if not P_CheckMissileRange(actor) then
      nomissile := true;
    if not nomissile then
    begin
      P_SetMobjState(actor, statenum_t(actor.info.missilestate));
      actor.flags := actor.flags or MF_JUSTATTACKED;
    end;
  end;

//
// possibly choose another target
//
  if netgame and (actor.threshold = 0) and (not P_CheckSight(actor, actor.target)) then
    if P_LookForPlayers(actor,true) then
      exit;         // got a new target

//
// chase towards player
//
  if actor.special2 = 0 then
  begin
    dec(actor.movecount);
    if (actor.movecount < 0) or not P_Move(actor) then
      P_NewChaseDir(actor);
  end;
end;


procedure A_FighterAttack(actor: Pmobj_t);
begin
  if actor.target <> nil then
    A_FSwordAttack2(actor);
end;


procedure A_ClericAttack(actor: Pmobj_t);
begin
  if actor.target <> nil then
    A_CHolyAttack3(actor);
end;



procedure A_MageAttack(actor: Pmobj_t);
begin
  if actor.target <> nil then
    A_MStaffAttack2(actor);
end;

procedure A_ClassBossHealth(actor: Pmobj_t);
begin
  if netgame and (deathmatch <> 0) then   // co-op only
    if actor.special1 = 0 then
    begin
      actor.health := actor.health * 5;
      actor.special1 := 1;  // has been initialized
    end;
end;


//===========================================================================
//
// A_CheckFloor - Checks if an object hit the floor
//
//===========================================================================

procedure A_CheckFloor(actor: Pmobj_t);
begin
  if actor.z <= actor.floorz then
  begin
    actor.z := actor.floorz;
    A_Gravity(actor); // JVAL SOS
    P_SetMobjState(actor, statenum_t(actor.info.deathstate));
  end;
end;

//----------------------------------------------------------------------------
//
// A_FreezeDeath
//
//----------------------------------------------------------------------------

procedure A_FreezeDeath(actor: Pmobj_t);
begin
  actor.tics := 75 + P_Random + P_Random;
  actor.flags := actor.flags or MF_SOLID or MF_SHOOTABLE or MF_NOBLOOD;
  actor.flags2 := actor.flags2 or MF2_PUSHABLE or MF2_TELESTOMP or MF2_PASSMOBJ or MF2_SLIDE;
  actor.height := actor.height * 4;
  S_StartSound(actor, Ord(SFX_FREEZE_DEATH));

  if actor.player <> nil then
  begin
    Pplayer_t(actor.player).damagecount := 0;
    Pplayer_t(actor.player).poisoncount := 0;
    Pplayer_t(actor.player).bonuscount := 0;
    if actor.player = @players[consoleplayer] then
      SB_PaletteFlash(false);
  end
  else if (actor.flags and MF_COUNTKILL <> 0) and (actor.special <> 0) then
  begin // Initiate monster death actions
    P_ExecuteLineSpecial(actor.special, @actor.args, nil, 0, actor);
  end;
end;

//----------------------------------------------------------------------------
//
// A_IceSetTics
//
//----------------------------------------------------------------------------

procedure A_IceSetTics(actor: Pmobj_t);
var
  floor: integer;
begin
  actor.tics := 70 + (P_Random and 63);
  floor := P_GetThingFloorType(actor);
  if floor = FLOOR_LAVA then
    actor.tics := _SHR2(actor.tics)
  else if floor = FLOOR_ICE then
    actor.tics := actor.tics * 2;
end;

//----------------------------------------------------------------------------
//
// A_IceCheckHeadDone
//
//----------------------------------------------------------------------------

procedure A_IceCheckHeadDone(actor: Pmobj_t);
begin
  if actor.special2 = 666 then
    P_SetMobjState(actor, S_ICECHUNK_HEAD2);
end;

//----------------------------------------------------------------------------
//
// A_FreezeDeathChunks
//
//----------------------------------------------------------------------------

procedure A_FreezeDeathChunks(actor: Pmobj_t);
var
  i: integer;
  mo: Pmobj_t;
begin
  if (actor.momx <> 0) or (actor.momy <> 0) or (actor.momz <> 0) then
  begin
    actor.tics := 3 * TICRATE;
    exit;
  end;

  S_StartSound(actor, Ord(SFX_FREEZE_SHATTER));

  for i := 12 + (P_Random and 15) downto 0 do
  begin
    mo := P_SpawnMobj(actor.x + _SHR7((P_Random - 128) * actor.radius),
                      actor.y + _SHR7((P_Random - 128) * actor.radius),
                      actor.z + (P_Random * actor.height div 255),
                      Ord(MT_ICECHUNK));
    if mo <> nil then
    begin
      P_SetMobjState(mo, statenum_t(mo.info.spawnstate + (P_Random mod 3)));
      mo.momz := FixedDiv(mo.z-actor.z, actor.height) * 4;
      mo.momx := (P_Random - P_Random) * 512;
      mo.momy := (P_Random - P_Random) * 512;
      A_IceSetTics(mo); // set a random tic wait
    end;
  end;

  for i := 12 + (P_Random and 15) downto 0 do
  begin
    mo := P_SpawnMobj(actor.x + _SHR7((P_Random - 128) * actor.radius),
                      actor.y + _SHR7((P_Random - 128) * actor.radius),
                      actor.z + (P_Random * actor.height div 255),
                      Ord(MT_ICECHUNK));
    if mo <> nil then
    begin
      P_SetMobjState(mo, statenum_t(mo.info.spawnstate + (P_Random mod 3)));
      mo.momz := FixedDiv(mo.z - actor.z, actor.height) * 4;
      mo.momx := (P_Random - P_Random) * 512;
      mo.momy := (P_Random - P_Random) * 512;
      A_IceSetTics(mo); // set a random tic wait
    end;
  end;

  if actor.player <> nil then
  begin // attach the player's view to a chunk of ice
    mo := P_SpawnMobj(actor.x, actor.y, actor.z + PVIEWHEIGHT, Ord(MT_ICECHUNK));
    P_SetMobjState(mo, S_ICECHUNK_HEAD);
    mo.momz := FixedDiv(mo.z - actor.z, actor.height) * 4;
    mo.momx := (P_Random - P_Random) * 512;
    mo.momy := (P_Random - P_Random) * 512;
    mo.flags2 := mo.flags2 or MF2_ICEDAMAGE; // used to force blue palette
    mo.flags2 := mo.flags2 and not MF2_FLOORCLIP;
    mo.player := actor.player;
    actor.player := nil;
    mo.health := actor.health;
    mo.angle := actor.angle;
    Pplayer_t(mo.player).mo := mo;
    Pplayer_t(mo.player).lookdir := 0;
  end;
  P_RemoveMobjFromTIDList(actor);
  P_SetMobjState(actor, S_FREETARGMOBJ);
  actor.flags2 := actor.flags2 or MF2_DONTDRAW;
end;

//----------------------------------------------------------------------------
// Korax Variables
//  special1  last teleport destination
//  special2  set if "below half" script not yet run
//
// Korax Scripts (reserved)
//  249    Tell scripts that we are below half health
//  250-254  Control scripts
//  255    Death script
//
// Korax TIDs (reserved)
//  245    Reserved for Korax himself
//  248    Initial teleport destination
//  249    Teleport destination
//  250-254  For use in respective control scripts
//  255    For use in death script (spawn spots)
//----------------------------------------------------------------------------
const
  KORAX_SPIRIT_LIFETIME = 5 * (TICRATE div 5);  // 5 seconds
  KORAX_COMMAND_HEIGHT = 120 * FRACUNIT;
  KORAX_COMMAND_OFFSET = 27 * FRACUNIT;

const
  KORAX_TID = 245;
  KORAX_FIRST_TELEPORT_TID = 248;
  KORAX_TELEPORT_TID = 249;

procedure A_KoraxChase(actor: Pmobj_t);
var
  spot: Pmobj_t;
  lastfound: integer;
  args: array[0..2] of byte;
begin
  args[0] := 0;
  args[1] := 0;
  args[2] := 0;

  if (actor.special2 = 0) and
     (actor.health <= (actor.info.spawnhealth div 2)) then
  begin
    lastfound := 0;
    spot := P_FindMobjFromTID(KORAX_FIRST_TELEPORT_TID, @lastfound);
    if spot <> nil then
      P_Teleport(actor, spot.x, spot.y, spot.angle, true, spot.floorz, spot.ceilingz);

    P_StartACS(249, 0, @args, actor, nil, 0);
    actor.special2 := 1;  // Don't run again

    exit;
  end;

  if actor.target = nil then
    exit;

  if P_Random < 30 then
    P_SetMobjState(actor, statenum_t(actor.info.missilestate))
  else if P_Random < 30 then
    S_StartSound(nil, Ord(SFX_KORAX_ACTIVE));

  // Teleport away
  if actor.health < (actor.info.spawnhealth div 2) then
  begin
    if P_Random < 10 then
    begin
      lastfound := actor.special1;
      spot := P_FindMobjFromTID(KORAX_TELEPORT_TID, @lastfound);
      actor.special1 := lastfound;
      if spot <> nil then
        P_Teleport(actor, spot.x, spot.y, spot.angle, true, spot.floorz, spot.ceilingz);
    end;
  end;
end;

procedure A_KoraxStep(actor: Pmobj_t);
begin
  A_Chase(actor);
end;

procedure A_KoraxStep2(actor: Pmobj_t);
begin
  S_StartSound(nil, Ord(SFX_KORAX_STEP));
  A_Chase(actor);
end;

procedure A_KoraxBonePop(actor: Pmobj_t);
var
  mo: Pmobj_t;
  args: array[0..4] of byte;
begin
  args[0] := 0;
  args[1] := 0;
  args[2] := 0;
  args[3] := 0;
  args[4] := 0;

  // Spawn 6 spirits equalangularly
  mo := P_SpawnMissileAngle(actor, Ord(MT_KORAX_SPIRIT1), 0, 5 * FRACUNIT);
  if mo <> nil then
    KSpiritInit(mo, actor);
  mo := P_SpawnMissileAngle(actor, Ord(MT_KORAX_SPIRIT2), ANG60, 5 * FRACUNIT);
  if mo <> nil then
    KSpiritInit(mo, actor);
  mo := P_SpawnMissileAngle(actor, Ord(MT_KORAX_SPIRIT3), ANG120, 5 * FRACUNIT);
  if mo <> nil then
    KSpiritInit(mo, actor);
  mo := P_SpawnMissileAngle(actor, Ord(MT_KORAX_SPIRIT4), ANG180, 5 * FRACUNIT);
  if mo <> nil then
    KSpiritInit(mo, actor);
  mo := P_SpawnMissileAngle(actor, Ord(MT_KORAX_SPIRIT5), ANG240, 5 * FRACUNIT);
  if mo <> nil then
    KSpiritInit(mo, actor);
  mo := P_SpawnMissileAngle(actor, Ord(MT_KORAX_SPIRIT6), ANG300, 5 * FRACUNIT);
  if mo <> nil then
    KSpiritInit(mo, actor);

  P_StartACS(255, 0, @args, actor, nil, 0);    // Death script
end;

procedure KSpiritInit(spirit: Pmobj_t; korax: Pmobj_t);
var
  i: integer;
  tail, next: Pmobj_t;
begin

  spirit.health := KORAX_SPIRIT_LIFETIME;

  spirit.special1 := integer(korax);        // Swarm around korax
  spirit.special2 := 32 + (P_Random and 7); // Float bob index
  spirit.args[0] := 10; // initial turn value
  spirit.args[1] := 0;  // initial look angle

  // Spawn a tail for spirit
  tail := P_SpawnMobj(spirit.x, spirit.y, spirit.z, Ord(MT_HOLY_TAIL));
  tail.special2 := integer(spirit); // parent
  for i := 0 to 1 do
  begin
    next := P_SpawnMobj(spirit.x, spirit.y, spirit.z, Ord(MT_HOLY_TAIL));
    P_SetMobjState(next, statenum_t(next.info.spawnstate + 1));
    tail.special1 := integer(next);
    tail := next;
  end;
  tail.special1 := 0; // last tail bit
end;

procedure A_KoraxDecide(actor: Pmobj_t);
begin
  if P_Random < 220 then
    P_SetMobjState(actor, S_KORAX_MISSILE1)
  else
    P_SetMobjState(actor, S_KORAX_COMMAND1);
end;

procedure A_KoraxMissile(actor: Pmobj_t);
var
  _type: integer;
  sound: integer;
begin
  _type := P_Random mod 6;

  S_StartSound(actor, Ord(SFX_KORAX_ATTACK));

  case _type of
    0:
      begin
        _type := Ord(MT_WRAITHFX1);
        sound := Ord(SFX_WRAITH_MISSILE_FIRE);
      end;
    1:
      begin
        _type := Ord(MT_DEMONFX1);
        sound := Ord(SFX_DEMON_MISSILE_FIRE);
      end;
    2:
      begin
        _type := Ord(MT_DEMON2FX1);
        sound := Ord(SFX_DEMON_MISSILE_FIRE);
      end;
    3:
      begin
        _type := Ord(MT_FIREDEMON_FX6);
        sound := Ord(SFX_FIRED_ATTACK);
      end;
    4:
      begin
        _type := Ord(MT_CENTAUR_FX);
        sound := Ord(SFX_CENTAURLEADER_ATTACK);
      end;
  else
    begin
      _type := Ord(MT_SERPENTFX);
      sound := Ord(SFX_CENTAURLEADER_ATTACK);
    end;
  end;

  // Fire all 6 missiles at once
  S_StartSound(nil, sound);
  KoraxFire1(actor, _type);
  KoraxFire2(actor, _type);
  KoraxFire3(actor, _type);
  KoraxFire4(actor, _type);
  KoraxFire5(actor, _type);
  KoraxFire6(actor, _type);
end;


// Call action code scripts (250-254)
procedure A_KoraxCommand(actor: Pmobj_t);
var
  args: array[0..4] of byte;
  x, y, z: fixed_t;
  ang: angle_t;
  numcommands: integer;
begin
  S_StartSound(actor, Ord(SFX_KORAX_COMMAND));

  // Shoot stream of lightning to ceiling
  ang := (actor.angle - ANG90) shr ANGLETOFINESHIFT;
  x := actor.x + FixedMul(KORAX_COMMAND_OFFSET, finecosine[ang]);
  y := actor.y + FixedMul(KORAX_COMMAND_OFFSET, finesine[ang]);
  z := actor.z + KORAX_COMMAND_HEIGHT;
  P_SpawnMobj(x, y, z, Ord(MT_KORAX_BOLT));

  args[0] := 0;
  args[1] := 0;
  args[2] := 0;
  args[3] := 0;
  args[4] := 0;

  if actor.health <= _SHR1(actor.info.spawnhealth) then
    numcommands := 5
  else
    numcommands := 4;

  case P_Random mod numcommands of
    0: P_StartACS(250, 0, @args, actor, nil, 0);
    1: P_StartACS(251, 0, @args, actor, nil, 0);
    2: P_StartACS(252, 0, @args, actor, nil, 0);
    3: P_StartACS(253, 0, @args, actor, nil, 0);
  else
    P_StartACS(254, 0, @args, actor, nil, 0);
  end;
end;

const
  KORAX_DELTAANGLE = 85 * ANG1;
  KORAX_ARM_EXTENSION_SHORT = 40 * FRACUNIT;
  KORAX_ARM_EXTENSION_LONG = 55 * FRACUNIT;

const
  KORAX_ARM1_HEIGHT = 108 * FRACUNIT;
  KORAX_ARM2_HEIGHT = 82 * FRACUNIT;
  KORAX_ARM3_HEIGHT = 54 * FRACUNIT;
  KORAX_ARM4_HEIGHT = 104 * FRACUNIT;
  KORAX_ARM5_HEIGHT = 86 * FRACUNIT;
  KORAX_ARM6_HEIGHT = 53 * FRACUNIT;


// Arm projectiles
//    arm positions numbered:
//      1  top left
//      2  middle left
//      3  lower left
//      4  top right
//      5  middle right
//      6  lower right


// Arm 1 projectile
procedure KoraxFire1(actor: Pmobj_t; _type: integer);
var
  ang: angle_t;
  x, y, z: fixed_t;
begin
  ang := (actor.angle - KORAX_DELTAANGLE) shr ANGLETOFINESHIFT;
  x := actor.x + FixedMul(KORAX_ARM_EXTENSION_SHORT, finecosine[ang]);
  y := actor.y + FixedMul(KORAX_ARM_EXTENSION_SHORT, finesine[ang]);
  z := actor.z - actor.floorclip + KORAX_ARM1_HEIGHT;
  P_SpawnKoraxMissile(x, y, z,actor, actor.target, _type);
end;


// Arm 2 projectile
procedure KoraxFire2(actor: Pmobj_t; _type: integer);
var
  ang: angle_t;
  x, y, z: fixed_t;
begin
  ang := (actor.angle - KORAX_DELTAANGLE) shr ANGLETOFINESHIFT;
  x := actor.x + FixedMul(KORAX_ARM_EXTENSION_LONG, finecosine[ang]);
  y := actor.y + FixedMul(KORAX_ARM_EXTENSION_LONG, finesine[ang]);
  z := actor.z - actor.floorclip + KORAX_ARM2_HEIGHT;
  P_SpawnKoraxMissile(x, y, z, actor, actor.target, _type);
end;

// Arm 3 projectile
procedure KoraxFire3(actor: Pmobj_t; _type: integer);
var
  ang: angle_t;
  x, y, z: fixed_t;
begin
  ang := (actor.angle - KORAX_DELTAANGLE) shr ANGLETOFINESHIFT;
  x := actor.x + FixedMul(KORAX_ARM_EXTENSION_LONG, finecosine[ang]);
  y := actor.y + FixedMul(KORAX_ARM_EXTENSION_LONG, finesine[ang]);
  z := actor.z - actor.floorclip + KORAX_ARM3_HEIGHT;
  P_SpawnKoraxMissile(x, y, z, actor, actor.target, _type);
end;

// Arm 4 projectile
procedure KoraxFire4(actor: Pmobj_t; _type: integer);
var
  ang: angle_t;
  x, y, z: fixed_t;
begin
  ang := (actor.angle + KORAX_DELTAANGLE) shr ANGLETOFINESHIFT;
  x := actor.x + FixedMul(KORAX_ARM_EXTENSION_SHORT, finecosine[ang]);
  y := actor.y + FixedMul(KORAX_ARM_EXTENSION_SHORT, finesine[ang]);
  z := actor.z - actor.floorclip + KORAX_ARM4_HEIGHT;
  P_SpawnKoraxMissile(x, y, z, actor, actor.target, _type);
end;

// Arm 5 projectile
procedure KoraxFire5(actor: Pmobj_t; _type: integer);
var
  ang: angle_t;
  x, y, z: fixed_t;
begin
  ang := (actor.angle + KORAX_DELTAANGLE) shr ANGLETOFINESHIFT;
  x := actor.x + FixedMul(KORAX_ARM_EXTENSION_LONG, finecosine[ang]);
  y := actor.y + FixedMul(KORAX_ARM_EXTENSION_LONG, finesine[ang]);
  z := actor.z - actor.floorclip + KORAX_ARM5_HEIGHT;
  P_SpawnKoraxMissile(x, y, z, actor, actor.target, _type);
end;

// Arm 6 projectile
procedure KoraxFire6(actor: Pmobj_t; _type: integer);
var
  ang: angle_t;
  x, y, z: fixed_t;
begin
  ang := (actor.angle + KORAX_DELTAANGLE) shr ANGLETOFINESHIFT;
  x := actor.x + FixedMul(KORAX_ARM_EXTENSION_LONG, finecosine[ang]);
  y := actor.y + FixedMul(KORAX_ARM_EXTENSION_LONG, finesine[ang]);
  z := actor.z - actor.floorclip + KORAX_ARM6_HEIGHT;
  P_SpawnKoraxMissile(x, y, z, actor, actor.target, _type);
end;


procedure A_KSpiritWeave(actor: Pmobj_t);
var
  newX, newY: fixed_t;
  weaveXY, weaveZ: integer;
  angle: angle_t;
begin
  weaveXY := FixedInt(actor.special2);
  weaveZ := actor.special2 and $FFFF;
  angle := (actor.angle + ANG90) shr ANGLETOFINESHIFT;
  newX := actor.x - FixedMul(finecosine[angle], FloatBobOffsets[weaveXY] * 4);
  newY := actor.y - FixedMul(finesine[angle], FloatBobOffsets[weaveXY] * 4);
  weaveXY := (weaveXY + (P_Random mod 5)) and 63;
  newX := newX + FixedMul(finecosine[angle], FloatBobOffsets[weaveXY] * 4);
  newY := newY + FixedMul(finesine[angle], FloatBobOffsets[weaveXY] * 4);
  P_TryMove(actor, newX, newY);
  actor.z := actor.z - FloatBobOffsets[weaveZ] * 2;
  weaveZ := (weaveZ + (P_Random mod 5)) and 63;
  actor.z := actor.z + FloatBobOffsets[weaveZ] * 2;
  actor.special2 := weaveZ + (weaveXY * FRACUNIT);
end;

procedure A_KSpiritSeeker(actor: Pmobj_t; thresh: angle_t; turnMax: angle_t);
var
  dir: integer;
  dist: integer;
  delta: angle_t;
  angle: angle_t;
  target: Pmobj_t;
  newZ: fixed_t;
  deltaZ: fixed_t;
begin
  target := Pmobj_t(actor.special1);
  if target = nil then
    exit;

  dir := P_FaceMobj(actor, target, @delta);
  if delta > thresh then
  begin
    delta := _SHR1(delta);
    if delta > turnMax then
      delta := turnMax;
  end;
  if dir <> 0 then
  begin // Turn clockwise
    actor.angle := actor.angle + delta;
  end
  else
  begin // Turn counter clockwise
    actor.angle := actor.angle - delta;
  end;

  angle := actor.angle shr ANGLETOFINESHIFT;
  actor.momx := FixedMul(actor.info.speed, finecosine[angle]);
  actor.momy := FixedMul(actor.info.speed, finesine[angle]);

  if (leveltime and 15 = 0) or
     (actor.z > target.z + target.info.height) or
     (actor.z + actor.height < target.z) then
  begin
    newZ := target.z + _SHR8(P_Random * target.info.height);
    deltaZ := newZ - actor.z;
    if deltaZ > 15 * FRACUNIT then
      deltaZ := 15 * FRACUNIT
    else if deltaZ < -15 * FRACUNIT then
      deltaZ := -15 * FRACUNIT;
    dist := P_AproxDistance(target.x - actor.x, target.y - actor.y);
    dist := dist div actor.info.speed;
    if dist < 1 then
      dist := 1;
    actor.momz := deltaZ div dist;
  end;
end;


procedure A_KSpiritRoam(actor: Pmobj_t);
begin
  dec(actor.health);
  if actor.health <= 0 then
  begin
    S_StartSound(actor, Ord(SFX_SPIRIT_DIE));
    P_SetMobjState(actor, S_KSPIRIT_DEATH1);
  end
  else
  begin
    if actor.special1 <> 0 then
      A_KSpiritSeeker(actor, actor.args[0] * ANG1, actor.args[0] * ANG1 * 2);
    A_KSpiritWeave(actor);
    if P_Random < 50 then
      S_StartSound(nil, Ord(SFX_SPIRIT_ACTIVE));
  end;
end;

procedure A_KBolt(actor: Pmobj_t);
begin
  // Countdown lifetime
  dec(actor.special1);
  if actor.special1 <= 0 then
    P_SetMobjState(actor, S_NULL);
end;

const
  KORAX_BOLT_HEIGHT = 48 * FRACUNIT;
  KORAX_BOLT_LIFETIME = 3;

procedure A_KBoltRaise(actor: Pmobj_t);
var
  mo: Pmobj_t;
  z: fixed_t;
begin
  // Spawn a child upward
  z := actor.z + KORAX_BOLT_HEIGHT;

  if (z + KORAX_BOLT_HEIGHT) < actor.ceilingz then
  begin
    mo := P_SpawnMobj(actor.x, actor.y, z, Ord(MT_KORAX_BOLT));
    if mo <> nil then
      mo.special1 := KORAX_BOLT_LIFETIME;
  end
  else
  begin
    // Maybe cap it off here
  end;
end;


end.
