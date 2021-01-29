//------------------------------------------------------------------------------
//
//  DelphiHeretic: A modified and improved Heretic port for Windows
//  based on original Linux Doom as published by "id Software", on
//  Heretic source as published by "Raven" software and DelphiDoom
//  as published by Jim Valavanis.
//  Copyright (C) 2004-2021 by Jim Valavanis
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
//  Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA
//  02111-1307, USA.
//
//  DESCRIPTION:
//   Thing frame/state LUT
//
//------------------------------------------------------------------------------
//  Site  : http://sourceforge.net/projects/delphidoom/
//------------------------------------------------------------------------------

{$I Doom32.inc}

unit info;

interface

uses
  d_delphi,
  d_think,
  m_fixed,
  info_h;

type
  statesArray_t = packed array[0..$FFFF] of state_t;
  PstatesArray_t = ^statesArray_t;

  sprnamesArray_t = packed array[0..Ord(DO_NUMSPRITES) - 1] of string[4];
  PsprnamesArray_t = ^sprnamesArray_t;

  mobjinfoArray_t = packed array[0..Ord(DO_NUMMOBJTYPES) - 1] of mobjinfo_t;
  PmobjinfoArray_t = ^mobjinfoArray_t;

var
  states: PstatesArray_t = nil;
  numstates: integer = Ord(DO_NUMSTATES);
  sprnames: PIntegerArray = nil;
  numsprites: integer = Ord(DO_NUMSPRITES);
  mobjinfo: PmobjinfoArray_t = nil;
  nummobjtypes: integer = Ord(DO_NUMMOBJTYPES);

procedure Info_Init(const usethinkers: boolean);

const
  DEFPUSHFACTOR = FRACUNIT div 4;

implementation

uses
  doomdef,
  i_system,
  p_enemy,
  p_pspr,
  p_mobj_h,
  p_inter,
  p_common,
  info_common,
  r_renderstyle,
  sounds;

const
  DO_states: array[0..Ord(DO_NUMSTATES) - 1] of state_t = (
   (
    sprite: Ord(SPR_IMPX);    // sprite
    frame: 0;                 // frame
    tics: -1;                 // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_NULL;        // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_NULL

   (
    sprite: Ord(SPR_ACLO);    // sprite
    frame: 4;                 // frame
    tics: 1050;               // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_NULL;        // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_FREETARGMOBJ

   (
    sprite: Ord(SPR_PTN1);    // sprite
    frame: 0;                 // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_ITEM_PTN1_2;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_ITEM_PTN1_1

   (
    sprite: Ord(SPR_PTN1);    // sprite
    frame: 1;                 // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_ITEM_PTN1_3;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_ITEM_PTN1_2

   (
    sprite: Ord(SPR_PTN1);    // sprite
    frame: 2;                 // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_ITEM_PTN1_1;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_ITEM_PTN1_3

   (
    sprite: Ord(SPR_SHLD);    // sprite
    frame: 0;                 // frame
    tics: -1;                 // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_NULL;        // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_ITEM_SHLD1

   (
    sprite: Ord(SPR_SHD2);    // sprite
    frame: 0;                 // frame
    tics: -1;                 // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_NULL;        // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_ITEM_SHD2_1

   (
    sprite: Ord(SPR_BAGH);    // sprite
    frame: 0;                 // frame
    tics: -1;                 // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_NULL;        // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_ITEM_BAGH1

   (
    sprite: Ord(SPR_SPMP);    // sprite
    frame: 0;                 // frame
    tics: -1;                 // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_NULL;        // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_ITEM_SPMP1

   (
    sprite: Ord(SPR_ACLO);    // sprite
    frame: 4;                 // frame
    tics: 1400;               // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_HIDESPECIAL2;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_HIDESPECIAL1

   (
    sprite: Ord(SPR_ACLO);    // sprite
    frame: 0;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_HIDESPECIAL3;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_HIDESPECIAL2

   (
    sprite: Ord(SPR_ACLO);    // sprite
    frame: 1;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_HIDESPECIAL4;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_HIDESPECIAL3

   (
    sprite: Ord(SPR_ACLO);    // sprite
    frame: 0;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_HIDESPECIAL5;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_HIDESPECIAL4

   (
    sprite: Ord(SPR_ACLO);    // sprite
    frame: 1;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_HIDESPECIAL6;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_HIDESPECIAL5

   (
    sprite: Ord(SPR_ACLO);    // sprite
    frame: 2;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_HIDESPECIAL7;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_HIDESPECIAL6

   (
    sprite: Ord(SPR_ACLO);    // sprite
    frame: 1;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_HIDESPECIAL8;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_HIDESPECIAL7

   (
    sprite: Ord(SPR_ACLO);    // sprite
    frame: 2;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_HIDESPECIAL9;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_HIDESPECIAL8

   (
    sprite: Ord(SPR_ACLO);    // sprite
    frame: 3;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_HIDESPECIAL10;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_HIDESPECIAL9

   (
    sprite: Ord(SPR_ACLO);    // sprite
    frame: 2;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_HIDESPECIAL11;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_HIDESPECIAL10

   (
    sprite: Ord(SPR_ACLO);    // sprite
    frame: 3;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_NULL;        // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_HIDESPECIAL11

   (
    sprite: Ord(SPR_ACLO);    // sprite
    frame: 3;                 // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_DORMANTARTI2;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_DORMANTARTI1

   (
    sprite: Ord(SPR_ACLO);    // sprite
    frame: 2;                 // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_DORMANTARTI3;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_DORMANTARTI2

   (
    sprite: Ord(SPR_ACLO);    // sprite
    frame: 3;                 // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_DORMANTARTI4;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_DORMANTARTI3

   (
    sprite: Ord(SPR_ACLO);    // sprite
    frame: 2;                 // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_DORMANTARTI5;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_DORMANTARTI4

   (
    sprite: Ord(SPR_ACLO);    // sprite
    frame: 1;                 // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_DORMANTARTI6;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_DORMANTARTI5

   (
    sprite: Ord(SPR_ACLO);    // sprite
    frame: 2;                 // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_DORMANTARTI7;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_DORMANTARTI6

   (
    sprite: Ord(SPR_ACLO);    // sprite
    frame: 1;                 // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_DORMANTARTI8;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_DORMANTARTI7

   (
    sprite: Ord(SPR_ACLO);    // sprite
    frame: 0;                 // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_DORMANTARTI9;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_DORMANTARTI8

   (
    sprite: Ord(SPR_ACLO);    // sprite
    frame: 1;                 // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_DORMANTARTI10;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_DORMANTARTI9

   (
    sprite: Ord(SPR_ACLO);    // sprite
    frame: 0;                 // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_DORMANTARTI11;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_DORMANTARTI10

   (
    sprite: Ord(SPR_ACLO);    // sprite
    frame: 0;                 // frame
    tics: 1400;               // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_DORMANTARTI12;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_DORMANTARTI11

   (
    sprite: Ord(SPR_ACLO);    // sprite
    frame: 0;                 // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_DORMANTARTI13;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_DORMANTARTI12

   (
    sprite: Ord(SPR_ACLO);    // sprite
    frame: 1;                 // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_DORMANTARTI14;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_DORMANTARTI13

   (
    sprite: Ord(SPR_ACLO);    // sprite
    frame: 0;                 // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_DORMANTARTI15;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_DORMANTARTI14

   (
    sprite: Ord(SPR_ACLO);    // sprite
    frame: 1;                 // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_DORMANTARTI16;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_DORMANTARTI15

   (
    sprite: Ord(SPR_ACLO);    // sprite
    frame: 2;                 // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_DORMANTARTI17;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_DORMANTARTI16

   (
    sprite: Ord(SPR_ACLO);    // sprite
    frame: 1;                 // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_DORMANTARTI18;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_DORMANTARTI17

   (
    sprite: Ord(SPR_ACLO);    // sprite
    frame: 2;                 // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_DORMANTARTI19;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_DORMANTARTI18

   (
    sprite: Ord(SPR_ACLO);    // sprite
    frame: 3;                 // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_DORMANTARTI20;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_DORMANTARTI19

   (
    sprite: Ord(SPR_ACLO);    // sprite
    frame: 2;                 // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_DORMANTARTI21;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_DORMANTARTI20

   (
    sprite: Ord(SPR_ACLO);    // sprite
    frame: 3;                 // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_NULL;        // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_DORMANTARTI21

   (
    sprite: Ord(SPR_ACLO);    // sprite
    frame: 3;                 // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_DEADARTI2;   // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_DEADARTI1

   (
    sprite: Ord(SPR_ACLO);    // sprite
    frame: 2;                 // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_DEADARTI3;   // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_DEADARTI2

   (
    sprite: Ord(SPR_ACLO);    // sprite
    frame: 3;                 // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_DEADARTI4;   // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_DEADARTI3

   (
    sprite: Ord(SPR_ACLO);    // sprite
    frame: 2;                 // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_DEADARTI5;   // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_DEADARTI4

   (
    sprite: Ord(SPR_ACLO);    // sprite
    frame: 1;                 // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_DEADARTI6;   // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_DEADARTI5

   (
    sprite: Ord(SPR_ACLO);    // sprite
    frame: 2;                 // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_DEADARTI7;   // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_DEADARTI6

   (
    sprite: Ord(SPR_ACLO);    // sprite
    frame: 1;                 // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_DEADARTI8;   // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_DEADARTI7

   (
    sprite: Ord(SPR_ACLO);    // sprite
    frame: 0;                 // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_DEADARTI9;   // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_DEADARTI8

   (
    sprite: Ord(SPR_ACLO);    // sprite
    frame: 1;                 // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_DEADARTI10;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_DEADARTI9

   (
    sprite: Ord(SPR_ACLO);    // sprite
    frame: 0;                 // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_NULL;        // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_DEADARTI10

   (
    sprite: Ord(SPR_INVS);    // sprite
    frame: 32768;             // frame
    tics: 350;                // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_ARTI_INVS1;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_ARTI_INVS1

   (
    sprite: Ord(SPR_PTN2);    // sprite
    frame: 0;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_ARTI_PTN2_2;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_ARTI_PTN2_1

   (
    sprite: Ord(SPR_PTN2);    // sprite
    frame: 1;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_ARTI_PTN2_3;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_ARTI_PTN2_2

   (
    sprite: Ord(SPR_PTN2);    // sprite
    frame: 2;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_ARTI_PTN2_1;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_ARTI_PTN2_3

   (
    sprite: Ord(SPR_SOAR);    // sprite
    frame: 0;                 // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_ARTI_SOAR2;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_ARTI_SOAR1

   (
    sprite: Ord(SPR_SOAR);    // sprite
    frame: 1;                 // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_ARTI_SOAR3;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_ARTI_SOAR2

   (
    sprite: Ord(SPR_SOAR);    // sprite
    frame: 2;                 // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_ARTI_SOAR4;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_ARTI_SOAR3

   (
    sprite: Ord(SPR_SOAR);    // sprite
    frame: 1;                 // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_ARTI_SOAR1;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_ARTI_SOAR4

   (
    sprite: Ord(SPR_INVU);    // sprite
    frame: 0;                 // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_ARTI_INVU2;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_ARTI_INVU1

   (
    sprite: Ord(SPR_INVU);    // sprite
    frame: 1;                 // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_ARTI_INVU3;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_ARTI_INVU2

   (
    sprite: Ord(SPR_INVU);    // sprite
    frame: 2;                 // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_ARTI_INVU4;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_ARTI_INVU3

   (
    sprite: Ord(SPR_INVU);    // sprite
    frame: 3;                 // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_ARTI_INVU1;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_ARTI_INVU4

   (
    sprite: Ord(SPR_PWBK);    // sprite
    frame: 0;                 // frame
    tics: 350;                // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_ARTI_PWBK1;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_ARTI_PWBK1

   (
    sprite: Ord(SPR_EGGC);    // sprite
    frame: 0;                 // frame
    tics: 6;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_ARTI_EGGC2;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_ARTI_EGGC1

   (
    sprite: Ord(SPR_EGGC);    // sprite
    frame: 1;                 // frame
    tics: 6;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_ARTI_EGGC3;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_ARTI_EGGC2

   (
    sprite: Ord(SPR_EGGC);    // sprite
    frame: 2;                 // frame
    tics: 6;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_ARTI_EGGC4;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_ARTI_EGGC3

   (
    sprite: Ord(SPR_EGGC);    // sprite
    frame: 1;                 // frame
    tics: 6;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_ARTI_EGGC1;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_ARTI_EGGC4

   (
    sprite: Ord(SPR_EGGM);    // sprite
    frame: 0;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_EGGFX2;      // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_EGGFX1

   (
    sprite: Ord(SPR_EGGM);    // sprite
    frame: 1;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_EGGFX3;      // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_EGGFX2

   (
    sprite: Ord(SPR_EGGM);    // sprite
    frame: 2;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_EGGFX4;      // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_EGGFX3

   (
    sprite: Ord(SPR_EGGM);    // sprite
    frame: 3;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_EGGFX5;      // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_EGGFX4

   (
    sprite: Ord(SPR_EGGM);    // sprite
    frame: 4;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_EGGFX1;      // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_EGGFX5

   (
    sprite: Ord(SPR_FX01);    // sprite
    frame: 32772;             // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_EGGFXI1_2;   // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_EGGFXI1_1

   (
    sprite: Ord(SPR_FX01);    // sprite
    frame: 32773;             // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_EGGFXI1_3;   // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_EGGFXI1_2

   (
    sprite: Ord(SPR_FX01);    // sprite
    frame: 32774;             // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_EGGFXI1_4;   // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_EGGFXI1_3

   (
    sprite: Ord(SPR_FX01);    // sprite
    frame: 32775;             // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_NULL;        // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_EGGFXI1_4

   (
    sprite: Ord(SPR_SPHL);    // sprite
    frame: 0;                 // frame
    tics: 350;                // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_ARTI_SPHL1;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_ARTI_SPHL1

   (
    sprite: Ord(SPR_TRCH);    // sprite
    frame: 32768;             // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_ARTI_TRCH2;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_ARTI_TRCH1

   (
    sprite: Ord(SPR_TRCH);    // sprite
    frame: 32769;             // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_ARTI_TRCH3;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_ARTI_TRCH2

   (
    sprite: Ord(SPR_TRCH);    // sprite
    frame: 32770;             // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_ARTI_TRCH1;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_ARTI_TRCH3

   (
    sprite: Ord(SPR_FBMB);    // sprite
    frame: 4;                 // frame
    tics: 350;                // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_ARTI_FBMB1;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_ARTI_FBMB1

   (
    sprite: Ord(SPR_FBMB);    // sprite
    frame: 0;                 // frame
    tics: 10;                 // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_FIREBOMB2;   // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_FIREBOMB1

   (
    sprite: Ord(SPR_FBMB);    // sprite
    frame: 1;                 // frame
    tics: 10;                 // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_FIREBOMB3;   // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_FIREBOMB2

   (
    sprite: Ord(SPR_FBMB);    // sprite
    frame: 2;                 // frame
    tics: 10;                 // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_FIREBOMB4;   // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_FIREBOMB3

   (
    sprite: Ord(SPR_FBMB);    // sprite
    frame: 3;                 // frame
    tics: 10;                 // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_FIREBOMB5;   // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_FIREBOMB4

   (
    sprite: Ord(SPR_FBMB);    // sprite
    frame: 4;                 // frame
    tics: 6;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_FIREBOMB6;   // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_FIREBOMB5

   (
    sprite: Ord(SPR_XPL1);    // sprite
    frame: 32768;             // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_FIREBOMB7;   // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_FIREBOMB6

   (
    sprite: Ord(SPR_XPL1);    // sprite
    frame: 32769;             // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_FIREBOMB8;   // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_FIREBOMB7

   (
    sprite: Ord(SPR_XPL1);    // sprite
    frame: 32770;             // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_FIREBOMB9;   // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_FIREBOMB8

   (
    sprite: Ord(SPR_XPL1);    // sprite
    frame: 32771;             // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_FIREBOMB10;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_FIREBOMB9

   (
    sprite: Ord(SPR_XPL1);    // sprite
    frame: 32772;             // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_FIREBOMB11;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_FIREBOMB10

   (
    sprite: Ord(SPR_XPL1);    // sprite
    frame: 32773;             // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_NULL;        // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_FIREBOMB11

   (
    sprite: Ord(SPR_ATLP);    // sprite
    frame: 0;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_ARTI_ATLP2;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_ARTI_ATLP1

   (
    sprite: Ord(SPR_ATLP);    // sprite
    frame: 1;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_ARTI_ATLP3;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_ARTI_ATLP2

   (
    sprite: Ord(SPR_ATLP);    // sprite
    frame: 2;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_ARTI_ATLP4;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_ARTI_ATLP3

   (
    sprite: Ord(SPR_ATLP);    // sprite
    frame: 1;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_ARTI_ATLP1;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_ARTI_ATLP4

   (
    sprite: Ord(SPR_PPOD);    // sprite
    frame: 0;                 // frame
    tics: 10;                 // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_POD_WAIT1;   // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_POD_WAIT1

   (
    sprite: Ord(SPR_PPOD);    // sprite
    frame: 1;                 // frame
    tics: 14;                 // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_POD_WAIT1;   // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_POD_PAIN1

   (
    sprite: Ord(SPR_PPOD);    // sprite
    frame: 32770;             // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_POD_DIE2;    // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_POD_DIE1

   (
    sprite: Ord(SPR_PPOD);    // sprite
    frame: 32771;             // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_POD_DIE3;    // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_POD_DIE2

   (
    sprite: Ord(SPR_PPOD);    // sprite
    frame: 32772;             // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_POD_DIE4;    // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_POD_DIE3

   (
    sprite: Ord(SPR_PPOD);    // sprite
    frame: 32773;             // frame
    tics: 10;                 // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_FREETARGMOBJ;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_POD_DIE4

   (
    sprite: Ord(SPR_PPOD);    // sprite
    frame: 8;                 // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_POD_GROW2;   // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_POD_GROW1

   (
    sprite: Ord(SPR_PPOD);    // sprite
    frame: 9;                 // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_POD_GROW3;   // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_POD_GROW2

   (
    sprite: Ord(SPR_PPOD);    // sprite
    frame: 10;                // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_POD_GROW4;   // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_POD_GROW3

   (
    sprite: Ord(SPR_PPOD);    // sprite
    frame: 11;                // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_POD_GROW5;   // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_POD_GROW4

   (
    sprite: Ord(SPR_PPOD);    // sprite
    frame: 12;                // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_POD_GROW6;   // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_POD_GROW5

   (
    sprite: Ord(SPR_PPOD);    // sprite
    frame: 13;                // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_POD_GROW7;   // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_POD_GROW6

   (
    sprite: Ord(SPR_PPOD);    // sprite
    frame: 14;                // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_POD_GROW8;   // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_POD_GROW7

   (
    sprite: Ord(SPR_PPOD);    // sprite
    frame: 15;                // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_POD_WAIT1;   // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_POD_GROW8

   (
    sprite: Ord(SPR_PPOD);    // sprite
    frame: 6;                 // frame
    tics: 8;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_PODGOO2;     // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_PODGOO1

   (
    sprite: Ord(SPR_PPOD);    // sprite
    frame: 7;                 // frame
    tics: 8;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_PODGOO1;     // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_PODGOO2

   (
    sprite: Ord(SPR_PPOD);    // sprite
    frame: 6;                 // frame
    tics: 10;                 // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_NULL;        // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_PODGOOX

   (
    sprite: Ord(SPR_AMG1);    // sprite
    frame: 0;                 // frame
    tics: 35;                 // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_PODGENERATOR;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_PODGENERATOR

   (
    sprite: Ord(SPR_SPSH);    // sprite
    frame: 0;                 // frame
    tics: 8;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_SPLASH2;     // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SPLASH1

   (
    sprite: Ord(SPR_SPSH);    // sprite
    frame: 1;                 // frame
    tics: 8;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_SPLASH3;     // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SPLASH2

   (
    sprite: Ord(SPR_SPSH);    // sprite
    frame: 2;                 // frame
    tics: 8;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_SPLASH4;     // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SPLASH3

   (
    sprite: Ord(SPR_SPSH);    // sprite
    frame: 3;                 // frame
    tics: 16;                 // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_NULL;        // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SPLASH4

   (
    sprite: Ord(SPR_SPSH);    // sprite
    frame: 3;                 // frame
    tics: 10;                 // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_NULL;        // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SPLASHX

   (
    sprite: Ord(SPR_SPSH);    // sprite
    frame: 4;                 // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_SPLASHBASE2;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SPLASHBASE1

   (
    sprite: Ord(SPR_SPSH);    // sprite
    frame: 5;                 // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_SPLASHBASE3;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SPLASHBASE2

   (
    sprite: Ord(SPR_SPSH);    // sprite
    frame: 6;                 // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_SPLASHBASE4;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SPLASHBASE3

   (
    sprite: Ord(SPR_SPSH);    // sprite
    frame: 7;                 // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_SPLASHBASE5;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SPLASHBASE4

   (
    sprite: Ord(SPR_SPSH);    // sprite
    frame: 8;                 // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_SPLASHBASE6;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SPLASHBASE5

   (
    sprite: Ord(SPR_SPSH);    // sprite
    frame: 9;                 // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_SPLASHBASE7;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SPLASHBASE6

   (
    sprite: Ord(SPR_SPSH);    // sprite
    frame: 10;                // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_NULL;        // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SPLASHBASE7

   (
    sprite: Ord(SPR_LVAS);    // sprite
    frame: 32768;             // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_LAVASPLASH2;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_LAVASPLASH1

   (
    sprite: Ord(SPR_LVAS);    // sprite
    frame: 32769;             // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_LAVASPLASH3;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_LAVASPLASH2

   (
    sprite: Ord(SPR_LVAS);    // sprite
    frame: 32770;             // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_LAVASPLASH4;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_LAVASPLASH3

   (
    sprite: Ord(SPR_LVAS);    // sprite
    frame: 32771;             // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_LAVASPLASH5;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_LAVASPLASH4

   (
    sprite: Ord(SPR_LVAS);    // sprite
    frame: 32772;             // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_LAVASPLASH6;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_LAVASPLASH5

   (
    sprite: Ord(SPR_LVAS);    // sprite
    frame: 32773;             // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_NULL;        // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_LAVASPLASH6

   (
    sprite: Ord(SPR_LVAS);    // sprite
    frame: 32774;             // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_LAVASMOKE2;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_LAVASMOKE1

   (
    sprite: Ord(SPR_LVAS);    // sprite
    frame: 32775;             // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_LAVASMOKE3;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_LAVASMOKE2

   (
    sprite: Ord(SPR_LVAS);    // sprite
    frame: 32776;             // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_LAVASMOKE4;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_LAVASMOKE3

   (
    sprite: Ord(SPR_LVAS);    // sprite
    frame: 32777;             // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_LAVASMOKE5;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_LAVASMOKE4

   (
    sprite: Ord(SPR_LVAS);    // sprite
    frame: 32778;             // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_NULL;        // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_LAVASMOKE5

   (
    sprite: Ord(SPR_SLDG);    // sprite
    frame: 0;                 // frame
    tics: 8;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_SLUDGECHUNK2;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SLUDGECHUNK1

   (
    sprite: Ord(SPR_SLDG);    // sprite
    frame: 1;                 // frame
    tics: 8;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_SLUDGECHUNK3;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SLUDGECHUNK2

   (
    sprite: Ord(SPR_SLDG);    // sprite
    frame: 2;                 // frame
    tics: 8;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_SLUDGECHUNK4;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SLUDGECHUNK3

   (
    sprite: Ord(SPR_SLDG);    // sprite
    frame: 3;                 // frame
    tics: 8;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_NULL;        // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SLUDGECHUNK4

   (
    sprite: Ord(SPR_SLDG);    // sprite
    frame: 3;                 // frame
    tics: 6;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_NULL;        // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SLUDGECHUNKX

   (
    sprite: Ord(SPR_SLDG);    // sprite
    frame: 4;                 // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_SLUDGESPLASH2;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SLUDGESPLASH1

   (
    sprite: Ord(SPR_SLDG);    // sprite
    frame: 5;                 // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_SLUDGESPLASH3;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SLUDGESPLASH2

   (
    sprite: Ord(SPR_SLDG);    // sprite
    frame: 6;                 // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_SLUDGESPLASH4;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SLUDGESPLASH3

   (
    sprite: Ord(SPR_SLDG);    // sprite
    frame: 7;                 // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_NULL;        // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SLUDGESPLASH4

   (
    sprite: Ord(SPR_SKH1);    // sprite
    frame: 0;                 // frame
    tics: -1;                 // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_NULL;        // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SKULLHANG70_1

   (
    sprite: Ord(SPR_SKH2);    // sprite
    frame: 0;                 // frame
    tics: -1;                 // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_NULL;        // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SKULLHANG60_1

   (
    sprite: Ord(SPR_SKH3);    // sprite
    frame: 0;                 // frame
    tics: -1;                 // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_NULL;        // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SKULLHANG45_1

   (
    sprite: Ord(SPR_SKH4);    // sprite
    frame: 0;                 // frame
    tics: -1;                 // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_NULL;        // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SKULLHANG35_1

   (
    sprite: Ord(SPR_CHDL);    // sprite
    frame: 0;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_CHANDELIER2;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_CHANDELIER1

   (
    sprite: Ord(SPR_CHDL);    // sprite
    frame: 1;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_CHANDELIER3;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_CHANDELIER2

   (
    sprite: Ord(SPR_CHDL);    // sprite
    frame: 2;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_CHANDELIER1;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_CHANDELIER3

   (
    sprite: Ord(SPR_SRTC);    // sprite
    frame: 0;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_SERPTORCH2;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SERPTORCH1

   (
    sprite: Ord(SPR_SRTC);    // sprite
    frame: 1;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_SERPTORCH3;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SERPTORCH2

   (
    sprite: Ord(SPR_SRTC);    // sprite
    frame: 2;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_SERPTORCH1;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SERPTORCH3

   (
    sprite: Ord(SPR_SMPL);    // sprite
    frame: 0;                 // frame
    tics: -1;                 // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_NULL;        // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SMALLPILLAR

   (
    sprite: Ord(SPR_STGS);    // sprite
    frame: 0;                 // frame
    tics: -1;                 // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_NULL;        // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_STALAGMITESMALL

   (
    sprite: Ord(SPR_STGL);    // sprite
    frame: 0;                 // frame
    tics: -1;                 // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_NULL;        // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_STALAGMITELARGE

   (
    sprite: Ord(SPR_STCS);    // sprite
    frame: 0;                 // frame
    tics: -1;                 // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_NULL;        // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_STALACTITESMALL

   (
    sprite: Ord(SPR_STCL);    // sprite
    frame: 0;                 // frame
    tics: -1;                 // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_NULL;        // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_STALACTITELARGE

   (
    sprite: Ord(SPR_KFR1);    // sprite
    frame: 32768;             // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_FIREBRAZIER2;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_FIREBRAZIER1

   (
    sprite: Ord(SPR_KFR1);    // sprite
    frame: 32769;             // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_FIREBRAZIER3;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_FIREBRAZIER2

   (
    sprite: Ord(SPR_KFR1);    // sprite
    frame: 32770;             // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_FIREBRAZIER4;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_FIREBRAZIER3

   (
    sprite: Ord(SPR_KFR1);    // sprite
    frame: 32771;             // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_FIREBRAZIER5;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_FIREBRAZIER4

   (
    sprite: Ord(SPR_KFR1);    // sprite
    frame: 32772;             // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_FIREBRAZIER6;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_FIREBRAZIER5

   (
    sprite: Ord(SPR_KFR1);    // sprite
    frame: 32773;             // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_FIREBRAZIER7;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_FIREBRAZIER6

   (
    sprite: Ord(SPR_KFR1);    // sprite
    frame: 32774;             // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_FIREBRAZIER8;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_FIREBRAZIER7

   (
    sprite: Ord(SPR_KFR1);    // sprite
    frame: 32775;             // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_FIREBRAZIER1;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_FIREBRAZIER8

   (
    sprite: Ord(SPR_BARL);    // sprite
    frame: 0;                 // frame
    tics: -1;                 // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_NULL;        // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_BARREL

   (
    sprite: Ord(SPR_BRPL);    // sprite
    frame: 0;                 // frame
    tics: -1;                 // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_NULL;        // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_BRPILLAR

   (
    sprite: Ord(SPR_MOS1);    // sprite
    frame: 0;                 // frame
    tics: -1;                 // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_NULL;        // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_MOSS1

   (
    sprite: Ord(SPR_MOS2);    // sprite
    frame: 0;                 // frame
    tics: -1;                 // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_NULL;        // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_MOSS2

   (
    sprite: Ord(SPR_WTRH);    // sprite
    frame: 32768;             // frame
    tics: 6;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_WALLTORCH2;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_WALLTORCH1

   (
    sprite: Ord(SPR_WTRH);    // sprite
    frame: 32769;             // frame
    tics: 6;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_WALLTORCH3;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_WALLTORCH2

   (
    sprite: Ord(SPR_WTRH);    // sprite
    frame: 32770;             // frame
    tics: 6;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_WALLTORCH1;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_WALLTORCH3

   (
    sprite: Ord(SPR_HCOR);    // sprite
    frame: 0;                 // frame
    tics: -1;                 // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_NULL;        // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_HANGINGCORPSE

   (
    sprite: Ord(SPR_KGZ1);    // sprite
    frame: 0;                 // frame
    tics: 1;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_KEYGIZMO2;   // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_KEYGIZMO1

   (
    sprite: Ord(SPR_KGZ1);    // sprite
    frame: 0;                 // frame
    tics: 1;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_KEYGIZMO3;   // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_KEYGIZMO2

   (
    sprite: Ord(SPR_KGZ1);    // sprite
    frame: 0;                 // frame
    tics: -1;                 // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_NULL;        // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_KEYGIZMO3

   (
    sprite: Ord(SPR_KGZB);    // sprite
    frame: 0;                 // frame
    tics: 1;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_KGZ_START;   // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_KGZ_START

   (
    sprite: Ord(SPR_KGZB);    // sprite
    frame: 32768;             // frame
    tics: -1;                 // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_NULL;        // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_KGZ_BLUEFLOAT1

   (
    sprite: Ord(SPR_KGZG);    // sprite
    frame: 32768;             // frame
    tics: -1;                 // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_NULL;        // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_KGZ_GREENFLOAT1

   (
    sprite: Ord(SPR_KGZY);    // sprite
    frame: 32768;             // frame
    tics: -1;                 // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_NULL;        // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_KGZ_YELLOWFLOAT1

   (
    sprite: Ord(SPR_VLCO);    // sprite
    frame: 0;                 // frame
    tics: 350;                // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_VOLCANO2;    // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_VOLCANO1

   (
    sprite: Ord(SPR_VLCO);    // sprite
    frame: 0;                 // frame
    tics: 35;                 // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_VOLCANO3;    // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_VOLCANO2

   (
    sprite: Ord(SPR_VLCO);    // sprite
    frame: 1;                 // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_VOLCANO4;    // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_VOLCANO3

   (
    sprite: Ord(SPR_VLCO);    // sprite
    frame: 2;                 // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_VOLCANO5;    // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_VOLCANO4

   (
    sprite: Ord(SPR_VLCO);    // sprite
    frame: 3;                 // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_VOLCANO6;    // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_VOLCANO5

   (
    sprite: Ord(SPR_VLCO);    // sprite
    frame: 1;                 // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_VOLCANO7;    // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_VOLCANO6

   (
    sprite: Ord(SPR_VLCO);    // sprite
    frame: 2;                 // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_VOLCANO8;    // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_VOLCANO7

   (
    sprite: Ord(SPR_VLCO);    // sprite
    frame: 3;                 // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_VOLCANO9;    // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_VOLCANO8

   (
    sprite: Ord(SPR_VLCO);    // sprite
    frame: 4;                 // frame
    tics: 10;                 // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_VOLCANO2;    // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_VOLCANO9

   (
    sprite: Ord(SPR_VFBL);    // sprite
    frame: 0;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_VOLCANOBALL2;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_VOLCANOBALL1

   (
    sprite: Ord(SPR_VFBL);    // sprite
    frame: 1;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_VOLCANOBALL1;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_VOLCANOBALL2

   (
    sprite: Ord(SPR_XPL1);    // sprite
    frame: 0;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_VOLCANOBALLX2;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_VOLCANOBALLX1

   (
    sprite: Ord(SPR_XPL1);    // sprite
    frame: 1;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_VOLCANOBALLX3;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_VOLCANOBALLX2

   (
    sprite: Ord(SPR_XPL1);    // sprite
    frame: 2;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_VOLCANOBALLX4;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_VOLCANOBALLX3

   (
    sprite: Ord(SPR_XPL1);    // sprite
    frame: 3;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_VOLCANOBALLX5;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_VOLCANOBALLX4

   (
    sprite: Ord(SPR_XPL1);    // sprite
    frame: 4;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_VOLCANOBALLX6;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_VOLCANOBALLX5

   (
    sprite: Ord(SPR_XPL1);    // sprite
    frame: 5;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_NULL;        // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_VOLCANOBALLX6

   (
    sprite: Ord(SPR_VTFB);    // sprite
    frame: 0;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_VOLCANOTBALL2;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_VOLCANOTBALL1

   (
    sprite: Ord(SPR_VTFB);    // sprite
    frame: 1;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_VOLCANOTBALL1;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_VOLCANOTBALL2

   (
    sprite: Ord(SPR_SFFI);    // sprite
    frame: 2;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_VOLCANOTBALLX2;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_VOLCANOTBALLX1

   (
    sprite: Ord(SPR_SFFI);    // sprite
    frame: 1;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_VOLCANOTBALLX3;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_VOLCANOTBALLX2

   (
    sprite: Ord(SPR_SFFI);    // sprite
    frame: 0;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_VOLCANOTBALLX4;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_VOLCANOTBALLX3

   (
    sprite: Ord(SPR_SFFI);    // sprite
    frame: 1;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_VOLCANOTBALLX5;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_VOLCANOTBALLX4

   (
    sprite: Ord(SPR_SFFI);    // sprite
    frame: 2;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_VOLCANOTBALLX6;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_VOLCANOTBALLX5

   (
    sprite: Ord(SPR_SFFI);    // sprite
    frame: 3;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_VOLCANOTBALLX7;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_VOLCANOTBALLX6

   (
    sprite: Ord(SPR_SFFI);    // sprite
    frame: 4;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_NULL;        // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_VOLCANOTBALLX7

   (
    sprite: Ord(SPR_TGLT);    // sprite
    frame: 0;                 // frame
    tics: 8;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_TELEGLITGEN1;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_TELEGLITGEN1

   (
    sprite: Ord(SPR_TGLT);    // sprite
    frame: 5;                 // frame
    tics: 8;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_TELEGLITGEN2;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_TELEGLITGEN2

   (
    sprite: Ord(SPR_TGLT);    // sprite
    frame: 32768;             // frame
    tics: 2;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_TELEGLITTER1_2;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_TELEGLITTER1_1

   (
    sprite: Ord(SPR_TGLT);    // sprite
    frame: 32769;             // frame
    tics: 2;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_TELEGLITTER1_3;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_TELEGLITTER1_2

   (
    sprite: Ord(SPR_TGLT);    // sprite
    frame: 32770;             // frame
    tics: 2;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_TELEGLITTER1_4;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_TELEGLITTER1_3

   (
    sprite: Ord(SPR_TGLT);    // sprite
    frame: 32771;             // frame
    tics: 2;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_TELEGLITTER1_5;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_TELEGLITTER1_4

   (
    sprite: Ord(SPR_TGLT);    // sprite
    frame: 32772;             // frame
    tics: 2;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_TELEGLITTER1_1;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_TELEGLITTER1_5

   (
    sprite: Ord(SPR_TGLT);    // sprite
    frame: 32773;             // frame
    tics: 2;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_TELEGLITTER2_2;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_TELEGLITTER2_1

   (
    sprite: Ord(SPR_TGLT);    // sprite
    frame: 32774;             // frame
    tics: 2;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_TELEGLITTER2_3;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_TELEGLITTER2_2

   (
    sprite: Ord(SPR_TGLT);    // sprite
    frame: 32775;             // frame
    tics: 2;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_TELEGLITTER2_4;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_TELEGLITTER2_3

   (
    sprite: Ord(SPR_TGLT);    // sprite
    frame: 32776;             // frame
    tics: 2;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_TELEGLITTER2_5;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_TELEGLITTER2_4

   (
    sprite: Ord(SPR_TGLT);    // sprite
    frame: 32777;             // frame
    tics: 2;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_TELEGLITTER2_1;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_TELEGLITTER2_5

   (
    sprite: Ord(SPR_TELE);    // sprite
    frame: 32768;             // frame
    tics: 6;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_TFOG2;       // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_TFOG1

   (
    sprite: Ord(SPR_TELE);    // sprite
    frame: 32769;             // frame
    tics: 6;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_TFOG3;       // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_TFOG2

   (
    sprite: Ord(SPR_TELE);    // sprite
    frame: 32770;             // frame
    tics: 6;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_TFOG4;       // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_TFOG3

   (
    sprite: Ord(SPR_TELE);    // sprite
    frame: 32771;             // frame
    tics: 6;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_TFOG5;       // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_TFOG4

   (
    sprite: Ord(SPR_TELE);    // sprite
    frame: 32772;             // frame
    tics: 6;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_TFOG6;       // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_TFOG5

   (
    sprite: Ord(SPR_TELE);    // sprite
    frame: 32773;             // frame
    tics: 6;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_TFOG7;       // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_TFOG6

   (
    sprite: Ord(SPR_TELE);    // sprite
    frame: 32774;             // frame
    tics: 6;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_TFOG8;       // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_TFOG7

   (
    sprite: Ord(SPR_TELE);    // sprite
    frame: 32775;             // frame
    tics: 6;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_TFOG9;       // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_TFOG8

   (
    sprite: Ord(SPR_TELE);    // sprite
    frame: 32774;             // frame
    tics: 6;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_TFOG10;      // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_TFOG9

   (
    sprite: Ord(SPR_TELE);    // sprite
    frame: 32773;             // frame
    tics: 6;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_TFOG11;      // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_TFOG10

   (
    sprite: Ord(SPR_TELE);    // sprite
    frame: 32772;             // frame
    tics: 6;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_TFOG12;      // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_TFOG11

   (
    sprite: Ord(SPR_TELE);    // sprite
    frame: 32771;             // frame
    tics: 6;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_TFOG13;      // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_TFOG12

   (
    sprite: Ord(SPR_TELE);    // sprite
    frame: 32770;             // frame
    tics: 6;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_NULL;        // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_TFOG13

   (
    sprite: Ord(SPR_STFF);    // sprite
    frame: 0;                 // frame
    tics: 0;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_NULL;        // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_LIGHTDONE

   (
    sprite: Ord(SPR_STFF);    // sprite
    frame: 0;                 // frame
    tics: 1;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_STAFFREADY;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_STAFFREADY

   (
    sprite: Ord(SPR_STFF);    // sprite
    frame: 0;                 // frame
    tics: 1;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_STAFFDOWN;   // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_STAFFDOWN

   (
    sprite: Ord(SPR_STFF);    // sprite
    frame: 0;                 // frame
    tics: 1;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_STAFFUP;     // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_STAFFUP

   (
    sprite: Ord(SPR_STFF);    // sprite
    frame: 3;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_STAFFREADY2_2;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_STAFFREADY2_1

   (
    sprite: Ord(SPR_STFF);    // sprite
    frame: 4;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_STAFFREADY2_3;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_STAFFREADY2_2

   (
    sprite: Ord(SPR_STFF);    // sprite
    frame: 5;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_STAFFREADY2_1;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_STAFFREADY2_3

   (
    sprite: Ord(SPR_STFF);    // sprite
    frame: 3;                 // frame
    tics: 1;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_STAFFDOWN2;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_STAFFDOWN2

   (
    sprite: Ord(SPR_STFF);    // sprite
    frame: 3;                 // frame
    tics: 1;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_STAFFUP2;    // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_STAFFUP2

   (
    sprite: Ord(SPR_STFF);    // sprite
    frame: 1;                 // frame
    tics: 6;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_STAFFATK1_2;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_STAFFATK1_1

   (
    sprite: Ord(SPR_STFF);    // sprite
    frame: 2;                 // frame
    tics: 8;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_STAFFATK1_3;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_STAFFATK1_2

   (
    sprite: Ord(SPR_STFF);    // sprite
    frame: 1;                 // frame
    tics: 8;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_STAFFREADY;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_STAFFATK1_3

   (
    sprite: Ord(SPR_STFF);    // sprite
    frame: 6;                 // frame
    tics: 6;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_STAFFATK2_2;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_STAFFATK2_1

   (
    sprite: Ord(SPR_STFF);    // sprite
    frame: 7;                 // frame
    tics: 8;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_STAFFATK2_3;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_STAFFATK2_2

   (
    sprite: Ord(SPR_STFF);    // sprite
    frame: 6;                 // frame
    tics: 8;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_STAFFREADY2_1;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_STAFFATK2_3

   (
    sprite: Ord(SPR_PUF3);    // sprite
    frame: 32768;             // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_STAFFPUFF2;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_STAFFPUFF1

   (
    sprite: Ord(SPR_PUF3);    // sprite
    frame: 1;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_STAFFPUFF3;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_STAFFPUFF2

   (
    sprite: Ord(SPR_PUF3);    // sprite
    frame: 2;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_STAFFPUFF4;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_STAFFPUFF3

   (
    sprite: Ord(SPR_PUF3);    // sprite
    frame: 3;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_NULL;        // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_STAFFPUFF4

   (
    sprite: Ord(SPR_PUF4);    // sprite
    frame: 32768;             // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_STAFFPUFF2_2;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_STAFFPUFF2_1

   (
    sprite: Ord(SPR_PUF4);    // sprite
    frame: 32769;             // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_STAFFPUFF2_3;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_STAFFPUFF2_2

   (
    sprite: Ord(SPR_PUF4);    // sprite
    frame: 32770;             // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_STAFFPUFF2_4;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_STAFFPUFF2_3

   (
    sprite: Ord(SPR_PUF4);    // sprite
    frame: 32771;             // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_STAFFPUFF2_5;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_STAFFPUFF2_4

   (
    sprite: Ord(SPR_PUF4);    // sprite
    frame: 32772;             // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_STAFFPUFF2_6;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_STAFFPUFF2_5

   (
    sprite: Ord(SPR_PUF4);    // sprite
    frame: 32773;             // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_NULL;        // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_STAFFPUFF2_6

   (
    sprite: Ord(SPR_BEAK);    // sprite
    frame: 0;                 // frame
    tics: 1;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_BEAKREADY;   // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_BEAKREADY

   (
    sprite: Ord(SPR_BEAK);    // sprite
    frame: 0;                 // frame
    tics: 1;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_BEAKDOWN;    // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_BEAKDOWN

   (
    sprite: Ord(SPR_BEAK);    // sprite
    frame: 0;                 // frame
    tics: 1;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_BEAKUP;      // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_BEAKUP

   (
    sprite: Ord(SPR_BEAK);    // sprite
    frame: 0;                 // frame
    tics: 18;                 // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_BEAKREADY;   // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_BEAKATK1_1

   (
    sprite: Ord(SPR_BEAK);    // sprite
    frame: 0;                 // frame
    tics: 12;                 // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_BEAKREADY;   // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_BEAKATK2_1

   (
    sprite: Ord(SPR_WGNT);    // sprite
    frame: 0;                 // frame
    tics: -1;                 // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_NULL;        // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_WGNT

   (
    sprite: Ord(SPR_GAUN);    // sprite
    frame: 0;                 // frame
    tics: 1;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_GAUNTLETREADY;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_GAUNTLETREADY

   (
    sprite: Ord(SPR_GAUN);    // sprite
    frame: 0;                 // frame
    tics: 1;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_GAUNTLETDOWN;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_GAUNTLETDOWN

   (
    sprite: Ord(SPR_GAUN);    // sprite
    frame: 0;                 // frame
    tics: 1;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_GAUNTLETUP;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_GAUNTLETUP

   (
    sprite: Ord(SPR_GAUN);    // sprite
    frame: 6;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_GAUNTLETREADY2_2;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_GAUNTLETREADY2_1

   (
    sprite: Ord(SPR_GAUN);    // sprite
    frame: 7;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_GAUNTLETREADY2_3;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_GAUNTLETREADY2_2

   (
    sprite: Ord(SPR_GAUN);    // sprite
    frame: 8;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_GAUNTLETREADY2_1;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_GAUNTLETREADY2_3

   (
    sprite: Ord(SPR_GAUN);    // sprite
    frame: 6;                 // frame
    tics: 1;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_GAUNTLETDOWN2;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_GAUNTLETDOWN2

   (
    sprite: Ord(SPR_GAUN);    // sprite
    frame: 6;                 // frame
    tics: 1;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_GAUNTLETUP2;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_GAUNTLETUP2

   (
    sprite: Ord(SPR_GAUN);    // sprite
    frame: 1;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_GAUNTLETATK1_2;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_GAUNTLETATK1_1

   (
    sprite: Ord(SPR_GAUN);    // sprite
    frame: 2;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_GAUNTLETATK1_3;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_GAUNTLETATK1_2

   (
    sprite: Ord(SPR_GAUN);    // sprite
    frame: 32771;             // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_GAUNTLETATK1_4;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_GAUNTLETATK1_3

   (
    sprite: Ord(SPR_GAUN);    // sprite
    frame: 32772;             // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_GAUNTLETATK1_5;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_GAUNTLETATK1_4

   (
    sprite: Ord(SPR_GAUN);    // sprite
    frame: 32773;             // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_GAUNTLETATK1_6;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_GAUNTLETATK1_5

   (
    sprite: Ord(SPR_GAUN);    // sprite
    frame: 2;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_GAUNTLETATK1_7;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_GAUNTLETATK1_6

   (
    sprite: Ord(SPR_GAUN);    // sprite
    frame: 1;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_GAUNTLETREADY;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_GAUNTLETATK1_7

   (
    sprite: Ord(SPR_GAUN);    // sprite
    frame: 9;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_GAUNTLETATK2_2;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_GAUNTLETATK2_1

   (
    sprite: Ord(SPR_GAUN);    // sprite
    frame: 10;                // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_GAUNTLETATK2_3;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_GAUNTLETATK2_2

   (
    sprite: Ord(SPR_GAUN);    // sprite
    frame: 32779;             // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_GAUNTLETATK2_4;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_GAUNTLETATK2_3

   (
    sprite: Ord(SPR_GAUN);    // sprite
    frame: 32780;             // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_GAUNTLETATK2_5;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_GAUNTLETATK2_4

   (
    sprite: Ord(SPR_GAUN);    // sprite
    frame: 32781;             // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_GAUNTLETATK2_6;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_GAUNTLETATK2_5

   (
    sprite: Ord(SPR_GAUN);    // sprite
    frame: 10;                // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_GAUNTLETATK2_7;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_GAUNTLETATK2_6

   (
    sprite: Ord(SPR_GAUN);    // sprite
    frame: 9;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_GAUNTLETREADY2_1;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_GAUNTLETATK2_7

   (
    sprite: Ord(SPR_PUF1);    // sprite
    frame: 32768;             // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_GAUNTLETPUFF1_2;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_GAUNTLETPUFF1_1

   (
    sprite: Ord(SPR_PUF1);    // sprite
    frame: 32769;             // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_GAUNTLETPUFF1_3;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_GAUNTLETPUFF1_2

   (
    sprite: Ord(SPR_PUF1);    // sprite
    frame: 32770;             // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_GAUNTLETPUFF1_4;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_GAUNTLETPUFF1_3

   (
    sprite: Ord(SPR_PUF1);    // sprite
    frame: 32771;             // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_NULL;        // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_GAUNTLETPUFF1_4

   (
    sprite: Ord(SPR_PUF1);    // sprite
    frame: 32772;             // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_GAUNTLETPUFF2_2;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_GAUNTLETPUFF2_1

   (
    sprite: Ord(SPR_PUF1);    // sprite
    frame: 32773;             // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_GAUNTLETPUFF2_3;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_GAUNTLETPUFF2_2

   (
    sprite: Ord(SPR_PUF1);    // sprite
    frame: 32774;             // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_GAUNTLETPUFF2_4;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_GAUNTLETPUFF2_3

   (
    sprite: Ord(SPR_PUF1);    // sprite
    frame: 32775;             // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_NULL;        // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_GAUNTLETPUFF2_4

   (
    sprite: Ord(SPR_WBLS);    // sprite
    frame: 0;                 // frame
    tics: -1;                 // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_NULL;        // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_BLSR

   (
    sprite: Ord(SPR_BLSR);    // sprite
    frame: 0;                 // frame
    tics: 1;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_BLASTERREADY;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_BLASTERREADY

   (
    sprite: Ord(SPR_BLSR);    // sprite
    frame: 0;                 // frame
    tics: 1;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_BLASTERDOWN;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_BLASTERDOWN

   (
    sprite: Ord(SPR_BLSR);    // sprite
    frame: 0;                 // frame
    tics: 1;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_BLASTERUP;   // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_BLASTERUP

   (
    sprite: Ord(SPR_BLSR);    // sprite
    frame: 1;                 // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_BLASTERATK1_2;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_BLASTERATK1_1

   (
    sprite: Ord(SPR_BLSR);    // sprite
    frame: 2;                 // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_BLASTERATK1_3;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_BLASTERATK1_2

   (
    sprite: Ord(SPR_BLSR);    // sprite
    frame: 3;                 // frame
    tics: 2;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_BLASTERATK1_4;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_BLASTERATK1_3

   (
    sprite: Ord(SPR_BLSR);    // sprite
    frame: 2;                 // frame
    tics: 2;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_BLASTERATK1_5;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_BLASTERATK1_4

   (
    sprite: Ord(SPR_BLSR);    // sprite
    frame: 1;                 // frame
    tics: 2;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_BLASTERATK1_6;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_BLASTERATK1_5

   (
    sprite: Ord(SPR_BLSR);    // sprite
    frame: 0;                 // frame
    tics: 0;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_BLASTERREADY;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_BLASTERATK1_6

   (
    sprite: Ord(SPR_BLSR);    // sprite
    frame: 1;                 // frame
    tics: 0;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_BLASTERATK2_2;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_BLASTERATK2_1

   (
    sprite: Ord(SPR_BLSR);    // sprite
    frame: 2;                 // frame
    tics: 0;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_BLASTERATK2_3;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_BLASTERATK2_2

   (
    sprite: Ord(SPR_BLSR);    // sprite
    frame: 3;                 // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_BLASTERATK2_4;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_BLASTERATK2_3

   (
    sprite: Ord(SPR_BLSR);    // sprite
    frame: 2;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_BLASTERATK2_5;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_BLASTERATK2_4

   (
    sprite: Ord(SPR_BLSR);    // sprite
    frame: 1;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_BLASTERATK2_6;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_BLASTERATK2_5

   (
    sprite: Ord(SPR_BLSR);    // sprite
    frame: 0;                 // frame
    tics: 0;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_BLASTERREADY;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_BLASTERATK2_6

   (
    sprite: Ord(SPR_ACLO);    // sprite
    frame: 4;                 // frame
    tics: 200;                // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_BLASTERFX1_1;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_BLASTERFX1_1

   (
    sprite: Ord(SPR_FX18);    // sprite
    frame: 32768;             // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_BLASTERFXI1_2;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_BLASTERFXI1_1

   (
    sprite: Ord(SPR_FX18);    // sprite
    frame: 32769;             // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_BLASTERFXI1_3;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_BLASTERFXI1_2

   (
    sprite: Ord(SPR_FX18);    // sprite
    frame: 32770;             // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_BLASTERFXI1_4;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_BLASTERFXI1_3

   (
    sprite: Ord(SPR_FX18);    // sprite
    frame: 32771;             // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_BLASTERFXI1_5;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_BLASTERFXI1_4

   (
    sprite: Ord(SPR_FX18);    // sprite
    frame: 32772;             // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_BLASTERFXI1_6;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_BLASTERFXI1_5

   (
    sprite: Ord(SPR_FX18);    // sprite
    frame: 32773;             // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_BLASTERFXI1_7;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_BLASTERFXI1_6

   (
    sprite: Ord(SPR_FX18);    // sprite
    frame: 32774;             // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_NULL;        // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_BLASTERFXI1_7

   (
    sprite: Ord(SPR_FX18);    // sprite
    frame: 7;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_BLASTERSMOKE2;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_BLASTERSMOKE1

   (
    sprite: Ord(SPR_FX18);    // sprite
    frame: 8;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_BLASTERSMOKE3;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_BLASTERSMOKE2

   (
    sprite: Ord(SPR_FX18);    // sprite
    frame: 9;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_BLASTERSMOKE4;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_BLASTERSMOKE3

   (
    sprite: Ord(SPR_FX18);    // sprite
    frame: 10;                // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_BLASTERSMOKE5;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_BLASTERSMOKE4

   (
    sprite: Ord(SPR_FX18);    // sprite
    frame: 11;                // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_NULL;        // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_BLASTERSMOKE5

   (
    sprite: Ord(SPR_FX18);    // sprite
    frame: 12;                // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_RIPPER2;     // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_RIPPER1

   (
    sprite: Ord(SPR_FX18);    // sprite
    frame: 13;                // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_RIPPER1;     // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_RIPPER2

   (
    sprite: Ord(SPR_FX18);    // sprite
    frame: 32782;             // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_RIPPERX2;    // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_RIPPERX1

   (
    sprite: Ord(SPR_FX18);    // sprite
    frame: 32783;             // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_RIPPERX3;    // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_RIPPERX2

   (
    sprite: Ord(SPR_FX18);    // sprite
    frame: 32784;             // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_RIPPERX4;    // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_RIPPERX3

   (
    sprite: Ord(SPR_FX18);    // sprite
    frame: 32785;             // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_RIPPERX5;    // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_RIPPERX4

   (
    sprite: Ord(SPR_FX18);    // sprite
    frame: 32786;             // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_NULL;        // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_RIPPERX5

   (
    sprite: Ord(SPR_FX17);    // sprite
    frame: 32768;             // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_BLASTERPUFF1_2;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_BLASTERPUFF1_1

   (
    sprite: Ord(SPR_FX17);    // sprite
    frame: 32769;             // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_BLASTERPUFF1_3;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_BLASTERPUFF1_2

   (
    sprite: Ord(SPR_FX17);    // sprite
    frame: 32770;             // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_BLASTERPUFF1_4;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_BLASTERPUFF1_3

   (
    sprite: Ord(SPR_FX17);    // sprite
    frame: 32771;             // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_BLASTERPUFF1_5;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_BLASTERPUFF1_4

   (
    sprite: Ord(SPR_FX17);    // sprite
    frame: 32772;             // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_NULL;        // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_BLASTERPUFF1_5

   (
    sprite: Ord(SPR_FX17);    // sprite
    frame: 32773;             // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_BLASTERPUFF2_2;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_BLASTERPUFF2_1

   (
    sprite: Ord(SPR_FX17);    // sprite
    frame: 32774;             // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_BLASTERPUFF2_3;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_BLASTERPUFF2_2

   (
    sprite: Ord(SPR_FX17);    // sprite
    frame: 32775;             // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_BLASTERPUFF2_4;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_BLASTERPUFF2_3

   (
    sprite: Ord(SPR_FX17);    // sprite
    frame: 32776;             // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_BLASTERPUFF2_5;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_BLASTERPUFF2_4

   (
    sprite: Ord(SPR_FX17);    // sprite
    frame: 32777;             // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_BLASTERPUFF2_6;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_BLASTERPUFF2_5

   (
    sprite: Ord(SPR_FX17);    // sprite
    frame: 32778;             // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_BLASTERPUFF2_7;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_BLASTERPUFF2_6

   (
    sprite: Ord(SPR_FX17);    // sprite
    frame: 32779;             // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_NULL;        // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_BLASTERPUFF2_7

   (
    sprite: Ord(SPR_WMCE);    // sprite
    frame: 0;                 // frame
    tics: -1;                 // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_NULL;        // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_WMCE

   (
    sprite: Ord(SPR_MACE);    // sprite
    frame: 0;                 // frame
    tics: 1;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_MACEREADY;   // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_MACEREADY

   (
    sprite: Ord(SPR_MACE);    // sprite
    frame: 0;                 // frame
    tics: 1;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_MACEDOWN;    // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_MACEDOWN

   (
    sprite: Ord(SPR_MACE);    // sprite
    frame: 0;                 // frame
    tics: 1;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_MACEUP;      // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_MACEUP

   (
    sprite: Ord(SPR_MACE);    // sprite
    frame: 1;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_MACEATK1_2;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_MACEATK1_1

   (
    sprite: Ord(SPR_MACE);    // sprite
    frame: 2;                 // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_MACEATK1_3;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_MACEATK1_2

   (
    sprite: Ord(SPR_MACE);    // sprite
    frame: 3;                 // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_MACEATK1_4;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_MACEATK1_3

   (
    sprite: Ord(SPR_MACE);    // sprite
    frame: 4;                 // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_MACEATK1_5;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_MACEATK1_4

   (
    sprite: Ord(SPR_MACE);    // sprite
    frame: 5;                 // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_MACEATK1_6;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_MACEATK1_5

   (
    sprite: Ord(SPR_MACE);    // sprite
    frame: 2;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_MACEATK1_7;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_MACEATK1_6

   (
    sprite: Ord(SPR_MACE);    // sprite
    frame: 3;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_MACEATK1_8;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_MACEATK1_7

   (
    sprite: Ord(SPR_MACE);    // sprite
    frame: 4;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_MACEATK1_9;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_MACEATK1_8

   (
    sprite: Ord(SPR_MACE);    // sprite
    frame: 5;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_MACEATK1_10;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_MACEATK1_9

   (
    sprite: Ord(SPR_MACE);    // sprite
    frame: 1;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_MACEREADY;   // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_MACEATK1_10

   (
    sprite: Ord(SPR_MACE);    // sprite
    frame: 1;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_MACEATK2_2;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_MACEATK2_1

   (
    sprite: Ord(SPR_MACE);    // sprite
    frame: 3;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_MACEATK2_3;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_MACEATK2_2

   (
    sprite: Ord(SPR_MACE);    // sprite
    frame: 1;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_MACEATK2_4;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_MACEATK2_3

   (
    sprite: Ord(SPR_MACE);    // sprite
    frame: 0;                 // frame
    tics: 8;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_MACEREADY;   // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_MACEATK2_4

   (
    sprite: Ord(SPR_FX02);    // sprite
    frame: 0;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_MACEFX1_2;   // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_MACEFX1_1

   (
    sprite: Ord(SPR_FX02);    // sprite
    frame: 1;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_MACEFX1_1;   // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_MACEFX1_2

   (
    sprite: Ord(SPR_FX02);    // sprite
    frame: 32773;             // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_MACEFXI1_2;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_MACEFXI1_1

   (
    sprite: Ord(SPR_FX02);    // sprite
    frame: 32774;             // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_MACEFXI1_3;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_MACEFXI1_2

   (
    sprite: Ord(SPR_FX02);    // sprite
    frame: 32775;             // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_MACEFXI1_4;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_MACEFXI1_3

   (
    sprite: Ord(SPR_FX02);    // sprite
    frame: 32776;             // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_MACEFXI1_5;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_MACEFXI1_4

   (
    sprite: Ord(SPR_FX02);    // sprite
    frame: 32777;             // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_NULL;        // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_MACEFXI1_5

   (
    sprite: Ord(SPR_FX02);    // sprite
    frame: 2;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_MACEFX2_2;   // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_MACEFX2_1

   (
    sprite: Ord(SPR_FX02);    // sprite
    frame: 3;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_MACEFX2_1;   // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_MACEFX2_2

   (
    sprite: Ord(SPR_FX02);    // sprite
    frame: 32773;             // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_MACEFXI1_2;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_MACEFXI2_1

   (
    sprite: Ord(SPR_FX02);    // sprite
    frame: 0;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_MACEFX3_2;   // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_MACEFX3_1

   (
    sprite: Ord(SPR_FX02);    // sprite
    frame: 1;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_MACEFX3_1;   // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_MACEFX3_2

   (
    sprite: Ord(SPR_FX02);    // sprite
    frame: 4;                 // frame
    tics: 99;                 // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_MACEFX4_1;   // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_MACEFX4_1

   (
    sprite: Ord(SPR_FX02);    // sprite
    frame: 32770;             // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_MACEFXI1_2;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_MACEFXI4_1

   (
    sprite: Ord(SPR_WSKL);    // sprite
    frame: 0;                 // frame
    tics: -1;                 // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_NULL;        // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_WSKL

   (
    sprite: Ord(SPR_HROD);    // sprite
    frame: 0;                 // frame
    tics: 1;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_HORNRODREADY;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_HORNRODREADY

   (
    sprite: Ord(SPR_HROD);    // sprite
    frame: 0;                 // frame
    tics: 1;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_HORNRODDOWN;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_HORNRODDOWN

   (
    sprite: Ord(SPR_HROD);    // sprite
    frame: 0;                 // frame
    tics: 1;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_HORNRODUP;   // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_HORNRODUP

   (
    sprite: Ord(SPR_HROD);    // sprite
    frame: 0;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_HORNRODATK1_2;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_HORNRODATK1_1

   (
    sprite: Ord(SPR_HROD);    // sprite
    frame: 1;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_HORNRODATK1_3;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_HORNRODATK1_2

   (
    sprite: Ord(SPR_HROD);    // sprite
    frame: 1;                 // frame
    tics: 0;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_HORNRODREADY;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_HORNRODATK1_3

   (
    sprite: Ord(SPR_HROD);    // sprite
    frame: 2;                 // frame
    tics: 2;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_HORNRODATK2_2;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_HORNRODATK2_1

   (
    sprite: Ord(SPR_HROD);    // sprite
    frame: 3;                 // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_HORNRODATK2_3;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_HORNRODATK2_2

   (
    sprite: Ord(SPR_HROD);    // sprite
    frame: 4;                 // frame
    tics: 2;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_HORNRODATK2_4;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_HORNRODATK2_3

   (
    sprite: Ord(SPR_HROD);    // sprite
    frame: 5;                 // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_HORNRODATK2_5;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_HORNRODATK2_4

   (
    sprite: Ord(SPR_HROD);    // sprite
    frame: 6;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_HORNRODATK2_6;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_HORNRODATK2_5

   (
    sprite: Ord(SPR_HROD);    // sprite
    frame: 5;                 // frame
    tics: 2;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_HORNRODATK2_7;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_HORNRODATK2_6

   (
    sprite: Ord(SPR_HROD);    // sprite
    frame: 4;                 // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_HORNRODATK2_8;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_HORNRODATK2_7

   (
    sprite: Ord(SPR_HROD);    // sprite
    frame: 3;                 // frame
    tics: 2;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_HORNRODATK2_9;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_HORNRODATK2_8

   (
    sprite: Ord(SPR_HROD);    // sprite
    frame: 2;                 // frame
    tics: 2;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_HORNRODREADY;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_HORNRODATK2_9

   (
    sprite: Ord(SPR_FX00);    // sprite
    frame: 32768;             // frame
    tics: 6;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_HRODFX1_2;   // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_HRODFX1_1

   (
    sprite: Ord(SPR_FX00);    // sprite
    frame: 32769;             // frame
    tics: 6;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_HRODFX1_1;   // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_HRODFX1_2

   (
    sprite: Ord(SPR_FX00);    // sprite
    frame: 32775;             // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_HRODFXI1_2;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_HRODFXI1_1

   (
    sprite: Ord(SPR_FX00);    // sprite
    frame: 32776;             // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_HRODFXI1_3;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_HRODFXI1_2

   (
    sprite: Ord(SPR_FX00);    // sprite
    frame: 32777;             // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_HRODFXI1_4;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_HRODFXI1_3

   (
    sprite: Ord(SPR_FX00);    // sprite
    frame: 32778;             // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_HRODFXI1_5;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_HRODFXI1_4

   (
    sprite: Ord(SPR_FX00);    // sprite
    frame: 32779;             // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_HRODFXI1_6;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_HRODFXI1_5

   (
    sprite: Ord(SPR_FX00);    // sprite
    frame: 32780;             // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_NULL;        // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_HRODFXI1_6

   (
    sprite: Ord(SPR_FX00);    // sprite
    frame: 32770;             // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_HRODFX2_2;   // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_HRODFX2_1

   (
    sprite: Ord(SPR_FX00);    // sprite
    frame: 32771;             // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_HRODFX2_3;   // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_HRODFX2_2

   (
    sprite: Ord(SPR_FX00);    // sprite
    frame: 32772;             // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_HRODFX2_4;   // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_HRODFX2_3

   (
    sprite: Ord(SPR_FX00);    // sprite
    frame: 32773;             // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_HRODFX2_1;   // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_HRODFX2_4

   (
    sprite: Ord(SPR_FX00);    // sprite
    frame: 32775;             // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_HRODFXI2_2;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_HRODFXI2_1

   (
    sprite: Ord(SPR_FX00);    // sprite
    frame: 32776;             // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_HRODFXI2_3;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_HRODFXI2_2

   (
    sprite: Ord(SPR_FX00);    // sprite
    frame: 32777;             // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_HRODFXI2_4;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_HRODFXI2_3

   (
    sprite: Ord(SPR_FX00);    // sprite
    frame: 32778;             // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_HRODFXI2_5;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_HRODFXI2_4

   (
    sprite: Ord(SPR_FX00);    // sprite
    frame: 32779;             // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_HRODFXI2_6;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_HRODFXI2_5

   (
    sprite: Ord(SPR_FX00);    // sprite
    frame: 32780;             // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_HRODFXI2_7;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_HRODFXI2_6

   (
    sprite: Ord(SPR_FX00);    // sprite
    frame: 6;                 // frame
    tics: 1;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_HRODFXI2_8;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_HRODFXI2_7

   (
    sprite: Ord(SPR_FX00);    // sprite
    frame: 6;                 // frame
    tics: 1;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_HRODFXI2_8;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_HRODFXI2_8

   (
    sprite: Ord(SPR_FX20);    // sprite
    frame: 32768;             // frame
    tics: -1;                 // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_NULL;        // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_RAINPLR1_1

   (
    sprite: Ord(SPR_FX21);    // sprite
    frame: 32768;             // frame
    tics: -1;                 // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_NULL;        // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_RAINPLR2_1

   (
    sprite: Ord(SPR_FX22);    // sprite
    frame: 32768;             // frame
    tics: -1;                 // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_NULL;        // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_RAINPLR3_1

   (
    sprite: Ord(SPR_FX23);    // sprite
    frame: 32768;             // frame
    tics: -1;                 // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_NULL;        // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_RAINPLR4_1

   (
    sprite: Ord(SPR_FX20);    // sprite
    frame: 32769;             // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_RAINPLR1X_2;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_RAINPLR1X_1

   (
    sprite: Ord(SPR_FX20);    // sprite
    frame: 32770;             // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_RAINPLR1X_3;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_RAINPLR1X_2

   (
    sprite: Ord(SPR_FX20);    // sprite
    frame: 32771;             // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_RAINPLR1X_4;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_RAINPLR1X_3

   (
    sprite: Ord(SPR_FX20);    // sprite
    frame: 32772;             // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_RAINPLR1X_5;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_RAINPLR1X_4

   (
    sprite: Ord(SPR_FX20);    // sprite
    frame: 32773;             // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_NULL;        // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_RAINPLR1X_5

   (
    sprite: Ord(SPR_FX21);    // sprite
    frame: 32769;             // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_RAINPLR2X_2;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_RAINPLR2X_1

   (
    sprite: Ord(SPR_FX21);    // sprite
    frame: 32770;             // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_RAINPLR2X_3;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_RAINPLR2X_2

   (
    sprite: Ord(SPR_FX21);    // sprite
    frame: 32771;             // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_RAINPLR2X_4;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_RAINPLR2X_3

   (
    sprite: Ord(SPR_FX21);    // sprite
    frame: 32772;             // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_RAINPLR2X_5;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_RAINPLR2X_4

   (
    sprite: Ord(SPR_FX21);    // sprite
    frame: 32773;             // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_NULL;        // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_RAINPLR2X_5

   (
    sprite: Ord(SPR_FX22);    // sprite
    frame: 32769;             // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_RAINPLR3X_2;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_RAINPLR3X_1

   (
    sprite: Ord(SPR_FX22);    // sprite
    frame: 32770;             // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_RAINPLR3X_3;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_RAINPLR3X_2

   (
    sprite: Ord(SPR_FX22);    // sprite
    frame: 32771;             // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_RAINPLR3X_4;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_RAINPLR3X_3

   (
    sprite: Ord(SPR_FX22);    // sprite
    frame: 32772;             // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_RAINPLR3X_5;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_RAINPLR3X_4

   (
    sprite: Ord(SPR_FX22);    // sprite
    frame: 32773;             // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_NULL;        // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_RAINPLR3X_5

   (
    sprite: Ord(SPR_FX23);    // sprite
    frame: 32769;             // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_RAINPLR4X_2;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_RAINPLR4X_1

   (
    sprite: Ord(SPR_FX23);    // sprite
    frame: 32770;             // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_RAINPLR4X_3;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_RAINPLR4X_2

   (
    sprite: Ord(SPR_FX23);    // sprite
    frame: 32771;             // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_RAINPLR4X_4;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_RAINPLR4X_3

   (
    sprite: Ord(SPR_FX23);    // sprite
    frame: 32772;             // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_RAINPLR4X_5;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_RAINPLR4X_4

   (
    sprite: Ord(SPR_FX23);    // sprite
    frame: 32773;             // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_NULL;        // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_RAINPLR4X_5

   (
    sprite: Ord(SPR_FX20);    // sprite
    frame: 32774;             // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_RAINAIRXPLR1_2;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_RAINAIRXPLR1_1

   (
    sprite: Ord(SPR_FX21);    // sprite
    frame: 32774;             // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_RAINAIRXPLR2_2;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_RAINAIRXPLR2_1

   (
    sprite: Ord(SPR_FX22);    // sprite
    frame: 32774;             // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_RAINAIRXPLR3_2;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_RAINAIRXPLR3_1

   (
    sprite: Ord(SPR_FX23);    // sprite
    frame: 32774;             // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_RAINAIRXPLR4_2;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_RAINAIRXPLR4_1

   (
    sprite: Ord(SPR_FX20);    // sprite
    frame: 32775;             // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_RAINAIRXPLR1_3;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_RAINAIRXPLR1_2

   (
    sprite: Ord(SPR_FX21);    // sprite
    frame: 32775;             // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_RAINAIRXPLR2_3;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_RAINAIRXPLR2_2

   (
    sprite: Ord(SPR_FX22);    // sprite
    frame: 32775;             // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_RAINAIRXPLR3_3;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_RAINAIRXPLR3_2

   (
    sprite: Ord(SPR_FX23);    // sprite
    frame: 32775;             // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_RAINAIRXPLR4_3;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_RAINAIRXPLR4_2

   (
    sprite: Ord(SPR_FX20);    // sprite
    frame: 32776;             // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_NULL;        // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_RAINAIRXPLR1_3

   (
    sprite: Ord(SPR_FX21);    // sprite
    frame: 32776;             // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_NULL;        // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_RAINAIRXPLR2_3

   (
    sprite: Ord(SPR_FX22);    // sprite
    frame: 32776;             // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_NULL;        // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_RAINAIRXPLR3_3

   (
    sprite: Ord(SPR_FX23);    // sprite
    frame: 32776;             // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_NULL;        // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_RAINAIRXPLR4_3

   (
    sprite: Ord(SPR_GWND);    // sprite
    frame: 0;                 // frame
    tics: 1;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_GOLDWANDREADY;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_GOLDWANDREADY

   (
    sprite: Ord(SPR_GWND);    // sprite
    frame: 0;                 // frame
    tics: 1;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_GOLDWANDDOWN;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_GOLDWANDDOWN

   (
    sprite: Ord(SPR_GWND);    // sprite
    frame: 0;                 // frame
    tics: 1;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_GOLDWANDUP;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_GOLDWANDUP

   (
    sprite: Ord(SPR_GWND);    // sprite
    frame: 1;                 // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_GOLDWANDATK1_2;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_GOLDWANDATK1_1

   (
    sprite: Ord(SPR_GWND);    // sprite
    frame: 2;                 // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_GOLDWANDATK1_3;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_GOLDWANDATK1_2

   (
    sprite: Ord(SPR_GWND);    // sprite
    frame: 3;                 // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_GOLDWANDATK1_4;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_GOLDWANDATK1_3

   (
    sprite: Ord(SPR_GWND);    // sprite
    frame: 3;                 // frame
    tics: 0;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_GOLDWANDREADY;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_GOLDWANDATK1_4

   (
    sprite: Ord(SPR_GWND);    // sprite
    frame: 1;                 // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_GOLDWANDATK2_2;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_GOLDWANDATK2_1

   (
    sprite: Ord(SPR_GWND);    // sprite
    frame: 2;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_GOLDWANDATK2_3;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_GOLDWANDATK2_2

   (
    sprite: Ord(SPR_GWND);    // sprite
    frame: 3;                 // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_GOLDWANDATK2_4;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_GOLDWANDATK2_3

   (
    sprite: Ord(SPR_GWND);    // sprite
    frame: 3;                 // frame
    tics: 0;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_GOLDWANDREADY;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_GOLDWANDATK2_4

   (
    sprite: Ord(SPR_FX01);    // sprite
    frame: 32768;             // frame
    tics: 6;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_GWANDFX1_2;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_GWANDFX1_1

   (
    sprite: Ord(SPR_FX01);    // sprite
    frame: 32769;             // frame
    tics: 6;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_GWANDFX1_1;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_GWANDFX1_2

   (
    sprite: Ord(SPR_FX01);    // sprite
    frame: 32772;             // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_GWANDFXI1_2;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_GWANDFXI1_1

   (
    sprite: Ord(SPR_FX01);    // sprite
    frame: 32773;             // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_GWANDFXI1_3;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_GWANDFXI1_2

   (
    sprite: Ord(SPR_FX01);    // sprite
    frame: 32774;             // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_GWANDFXI1_4;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_GWANDFXI1_3

   (
    sprite: Ord(SPR_FX01);    // sprite
    frame: 32775;             // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_NULL;        // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_GWANDFXI1_4

   (
    sprite: Ord(SPR_FX01);    // sprite
    frame: 32770;             // frame
    tics: 6;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_GWANDFX2_2;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_GWANDFX2_1

   (
    sprite: Ord(SPR_FX01);    // sprite
    frame: 32771;             // frame
    tics: 6;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_GWANDFX2_1;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_GWANDFX2_2

   (
    sprite: Ord(SPR_PUF2);    // sprite
    frame: 32768;             // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_GWANDPUFF1_2;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_GWANDPUFF1_1

   (
    sprite: Ord(SPR_PUF2);    // sprite
    frame: 32769;             // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_GWANDPUFF1_3;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_GWANDPUFF1_2

   (
    sprite: Ord(SPR_PUF2);    // sprite
    frame: 32770;             // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_GWANDPUFF1_4;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_GWANDPUFF1_3

   (
    sprite: Ord(SPR_PUF2);    // sprite
    frame: 32771;             // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_GWANDPUFF1_5;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_GWANDPUFF1_4

   (
    sprite: Ord(SPR_PUF2);    // sprite
    frame: 32772;             // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_NULL;        // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_GWANDPUFF1_5

   (
    sprite: Ord(SPR_WPHX);    // sprite
    frame: 0;                 // frame
    tics: -1;                 // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_NULL;        // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_WPHX

   (
    sprite: Ord(SPR_PHNX);    // sprite
    frame: 0;                 // frame
    tics: 1;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_PHOENIXREADY;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_PHOENIXREADY

   (
    sprite: Ord(SPR_PHNX);    // sprite
    frame: 0;                 // frame
    tics: 1;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_PHOENIXDOWN;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_PHOENIXDOWN

   (
    sprite: Ord(SPR_PHNX);    // sprite
    frame: 0;                 // frame
    tics: 1;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_PHOENIXUP;   // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_PHOENIXUP

   (
    sprite: Ord(SPR_PHNX);    // sprite
    frame: 1;                 // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_PHOENIXATK1_2;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_PHOENIXATK1_1

   (
    sprite: Ord(SPR_PHNX);    // sprite
    frame: 2;                 // frame
    tics: 7;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_PHOENIXATK1_3;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_PHOENIXATK1_2

   (
    sprite: Ord(SPR_PHNX);    // sprite
    frame: 3;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_PHOENIXATK1_4;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_PHOENIXATK1_3

   (
    sprite: Ord(SPR_PHNX);    // sprite
    frame: 1;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_PHOENIXATK1_5;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_PHOENIXATK1_4

   (
    sprite: Ord(SPR_PHNX);    // sprite
    frame: 1;                 // frame
    tics: 0;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_PHOENIXREADY;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_PHOENIXATK1_5

   (
    sprite: Ord(SPR_PHNX);    // sprite
    frame: 1;                 // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_PHOENIXATK2_2;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_PHOENIXATK2_1

   (
    sprite: Ord(SPR_PHNX);    // sprite
    frame: 32770;             // frame
    tics: 1;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_PHOENIXATK2_3;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_PHOENIXATK2_2

   (
    sprite: Ord(SPR_PHNX);    // sprite
    frame: 1;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_PHOENIXATK2_4;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_PHOENIXATK2_3

   (
    sprite: Ord(SPR_PHNX);    // sprite
    frame: 1;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_PHOENIXREADY;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_PHOENIXATK2_4

   (
    sprite: Ord(SPR_FX04);    // sprite
    frame: 32768;             // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_PHOENIXFX1_1;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_PHOENIXFX1_1

   (
    sprite: Ord(SPR_FX08);    // sprite
    frame: 32768;             // frame
    tics: 6;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_PHOENIXFXI1_2;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_PHOENIXFXI1_1

   (
    sprite: Ord(SPR_FX08);    // sprite
    frame: 32769;             // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_PHOENIXFXI1_3;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_PHOENIXFXI1_2

   (
    sprite: Ord(SPR_FX08);    // sprite
    frame: 32770;             // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_PHOENIXFXI1_4;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_PHOENIXFXI1_3

   (
    sprite: Ord(SPR_FX08);    // sprite
    frame: 32771;             // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_PHOENIXFXI1_5;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_PHOENIXFXI1_4

   (
    sprite: Ord(SPR_FX08);    // sprite
    frame: 32772;             // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_PHOENIXFXI1_6;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_PHOENIXFXI1_5

   (
    sprite: Ord(SPR_FX08);    // sprite
    frame: 32773;             // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_PHOENIXFXI1_7;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_PHOENIXFXI1_6

   (
    sprite: Ord(SPR_FX08);    // sprite
    frame: 32774;             // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_PHOENIXFXI1_8;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_PHOENIXFXI1_7

   (
    sprite: Ord(SPR_FX08);    // sprite
    frame: 32775;             // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_NULL;        // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_PHOENIXFXI1_8

   (
    sprite: Ord(SPR_FX04);    // sprite
    frame: 1;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_PHOENIXPUFF2;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_PHOENIXPUFF1

   (
    sprite: Ord(SPR_FX04);    // sprite
    frame: 2;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_PHOENIXPUFF3;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_PHOENIXPUFF2

   (
    sprite: Ord(SPR_FX04);    // sprite
    frame: 3;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_PHOENIXPUFF4;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_PHOENIXPUFF3

   (
    sprite: Ord(SPR_FX04);    // sprite
    frame: 4;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_PHOENIXPUFF5;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_PHOENIXPUFF4

   (
    sprite: Ord(SPR_FX04);    // sprite
    frame: 5;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_NULL;        // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_PHOENIXPUFF5

   (
    sprite: Ord(SPR_FX09);    // sprite
    frame: 32768;             // frame
    tics: 2;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_PHOENIXFX2_2;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_PHOENIXFX2_1

   (
    sprite: Ord(SPR_FX09);    // sprite
    frame: 32769;             // frame
    tics: 2;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_PHOENIXFX2_3;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_PHOENIXFX2_2

   (
    sprite: Ord(SPR_FX09);    // sprite
    frame: 32768;             // frame
    tics: 2;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_PHOENIXFX2_4;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_PHOENIXFX2_3

   (
    sprite: Ord(SPR_FX09);    // sprite
    frame: 32769;             // frame
    tics: 2;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_PHOENIXFX2_5;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_PHOENIXFX2_4

   (
    sprite: Ord(SPR_FX09);    // sprite
    frame: 32768;             // frame
    tics: 2;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_PHOENIXFX2_6;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_PHOENIXFX2_5

   (
    sprite: Ord(SPR_FX09);    // sprite
    frame: 32769;             // frame
    tics: 2;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_PHOENIXFX2_7;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_PHOENIXFX2_6

   (
    sprite: Ord(SPR_FX09);    // sprite
    frame: 32770;             // frame
    tics: 2;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_PHOENIXFX2_8;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_PHOENIXFX2_7

   (
    sprite: Ord(SPR_FX09);    // sprite
    frame: 32771;             // frame
    tics: 2;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_PHOENIXFX2_9;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_PHOENIXFX2_8

   (
    sprite: Ord(SPR_FX09);    // sprite
    frame: 32772;             // frame
    tics: 2;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_PHOENIXFX2_10;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_PHOENIXFX2_9

   (
    sprite: Ord(SPR_FX09);    // sprite
    frame: 32773;             // frame
    tics: 2;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_NULL;        // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_PHOENIXFX2_10

   (
    sprite: Ord(SPR_FX09);    // sprite
    frame: 32774;             // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_PHOENIXFXI2_2;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_PHOENIXFXI2_1

   (
    sprite: Ord(SPR_FX09);    // sprite
    frame: 32775;             // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_PHOENIXFXI2_3;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_PHOENIXFXI2_2

   (
    sprite: Ord(SPR_FX09);    // sprite
    frame: 32776;             // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_PHOENIXFXI2_4;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_PHOENIXFXI2_3

   (
    sprite: Ord(SPR_FX09);    // sprite
    frame: 32777;             // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_PHOENIXFXI2_5;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_PHOENIXFXI2_4

   (
    sprite: Ord(SPR_FX09);    // sprite
    frame: 32778;             // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_NULL;        // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_PHOENIXFXI2_5

   (
    sprite: Ord(SPR_WBOW);    // sprite
    frame: 0;                 // frame
    tics: -1;                 // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_NULL;        // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_WBOW

   (
    sprite: Ord(SPR_CRBW);    // sprite
    frame: 0;                 // frame
    tics: 1;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_CRBOW2;      // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_CRBOW1

   (
    sprite: Ord(SPR_CRBW);    // sprite
    frame: 0;                 // frame
    tics: 1;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_CRBOW3;      // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_CRBOW2

   (
    sprite: Ord(SPR_CRBW);    // sprite
    frame: 0;                 // frame
    tics: 1;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_CRBOW4;      // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_CRBOW3

   (
    sprite: Ord(SPR_CRBW);    // sprite
    frame: 0;                 // frame
    tics: 1;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_CRBOW5;      // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_CRBOW4

   (
    sprite: Ord(SPR_CRBW);    // sprite
    frame: 0;                 // frame
    tics: 1;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_CRBOW6;      // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_CRBOW5

   (
    sprite: Ord(SPR_CRBW);    // sprite
    frame: 0;                 // frame
    tics: 1;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_CRBOW7;      // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_CRBOW6

   (
    sprite: Ord(SPR_CRBW);    // sprite
    frame: 1;                 // frame
    tics: 1;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_CRBOW8;      // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_CRBOW7

   (
    sprite: Ord(SPR_CRBW);    // sprite
    frame: 1;                 // frame
    tics: 1;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_CRBOW9;      // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_CRBOW8

   (
    sprite: Ord(SPR_CRBW);    // sprite
    frame: 1;                 // frame
    tics: 1;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_CRBOW10;     // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_CRBOW9

   (
    sprite: Ord(SPR_CRBW);    // sprite
    frame: 1;                 // frame
    tics: 1;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_CRBOW11;     // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_CRBOW10

   (
    sprite: Ord(SPR_CRBW);    // sprite
    frame: 1;                 // frame
    tics: 1;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_CRBOW12;     // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_CRBOW11

   (
    sprite: Ord(SPR_CRBW);    // sprite
    frame: 1;                 // frame
    tics: 1;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_CRBOW13;     // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_CRBOW12

   (
    sprite: Ord(SPR_CRBW);    // sprite
    frame: 2;                 // frame
    tics: 1;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_CRBOW14;     // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_CRBOW13

   (
    sprite: Ord(SPR_CRBW);    // sprite
    frame: 2;                 // frame
    tics: 1;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_CRBOW15;     // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_CRBOW14

   (
    sprite: Ord(SPR_CRBW);    // sprite
    frame: 2;                 // frame
    tics: 1;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_CRBOW16;     // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_CRBOW15

   (
    sprite: Ord(SPR_CRBW);    // sprite
    frame: 2;                 // frame
    tics: 1;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_CRBOW17;     // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_CRBOW16

   (
    sprite: Ord(SPR_CRBW);    // sprite
    frame: 2;                 // frame
    tics: 1;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_CRBOW18;     // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_CRBOW17

   (
    sprite: Ord(SPR_CRBW);    // sprite
    frame: 2;                 // frame
    tics: 1;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_CRBOW1;      // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_CRBOW18

   (
    sprite: Ord(SPR_CRBW);    // sprite
    frame: 0;                 // frame
    tics: 1;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_CRBOWDOWN;   // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_CRBOWDOWN

   (
    sprite: Ord(SPR_CRBW);    // sprite
    frame: 0;                 // frame
    tics: 1;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_CRBOWUP;     // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_CRBOWUP

   (
    sprite: Ord(SPR_CRBW);    // sprite
    frame: 3;                 // frame
    tics: 6;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_CRBOWATK1_2;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_CRBOWATK1_1

   (
    sprite: Ord(SPR_CRBW);    // sprite
    frame: 4;                 // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_CRBOWATK1_3;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_CRBOWATK1_2

   (
    sprite: Ord(SPR_CRBW);    // sprite
    frame: 5;                 // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_CRBOWATK1_4;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_CRBOWATK1_3

   (
    sprite: Ord(SPR_CRBW);    // sprite
    frame: 6;                 // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_CRBOWATK1_5;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_CRBOWATK1_4

   (
    sprite: Ord(SPR_CRBW);    // sprite
    frame: 7;                 // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_CRBOWATK1_6;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_CRBOWATK1_5

   (
    sprite: Ord(SPR_CRBW);    // sprite
    frame: 0;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_CRBOWATK1_7;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_CRBOWATK1_6

   (
    sprite: Ord(SPR_CRBW);    // sprite
    frame: 1;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_CRBOWATK1_8;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_CRBOWATK1_7

   (
    sprite: Ord(SPR_CRBW);    // sprite
    frame: 2;                 // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_CRBOW1;      // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_CRBOWATK1_8

   (
    sprite: Ord(SPR_CRBW);    // sprite
    frame: 3;                 // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_CRBOWATK2_2;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_CRBOWATK2_1

   (
    sprite: Ord(SPR_CRBW);    // sprite
    frame: 4;                 // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_CRBOWATK2_3;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_CRBOWATK2_2

   (
    sprite: Ord(SPR_CRBW);    // sprite
    frame: 5;                 // frame
    tics: 2;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_CRBOWATK2_4;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_CRBOWATK2_3

   (
    sprite: Ord(SPR_CRBW);    // sprite
    frame: 6;                 // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_CRBOWATK2_5;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_CRBOWATK2_4

   (
    sprite: Ord(SPR_CRBW);    // sprite
    frame: 7;                 // frame
    tics: 2;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_CRBOWATK2_6;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_CRBOWATK2_5

   (
    sprite: Ord(SPR_CRBW);    // sprite
    frame: 0;                 // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_CRBOWATK2_7;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_CRBOWATK2_6

   (
    sprite: Ord(SPR_CRBW);    // sprite
    frame: 1;                 // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_CRBOWATK2_8;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_CRBOWATK2_7

   (
    sprite: Ord(SPR_CRBW);    // sprite
    frame: 2;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_CRBOW1;      // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_CRBOWATK2_8

   (
    sprite: Ord(SPR_FX03);    // sprite
    frame: 32769;             // frame
    tics: 1;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_CRBOWFX1;    // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_CRBOWFX1

   (
    sprite: Ord(SPR_FX03);    // sprite
    frame: 32775;             // frame
    tics: 8;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_CRBOWFXI1_2;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_CRBOWFXI1_1

   (
    sprite: Ord(SPR_FX03);    // sprite
    frame: 32776;             // frame
    tics: 8;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_CRBOWFXI1_3;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_CRBOWFXI1_2

   (
    sprite: Ord(SPR_FX03);    // sprite
    frame: 32777;             // frame
    tics: 8;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_NULL;        // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_CRBOWFXI1_3

   (
    sprite: Ord(SPR_FX03);    // sprite
    frame: 32769;             // frame
    tics: 1;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_CRBOWFX2;    // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_CRBOWFX2

   (
    sprite: Ord(SPR_FX03);    // sprite
    frame: 32768;             // frame
    tics: 1;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_CRBOWFX3;    // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_CRBOWFX3

   (
    sprite: Ord(SPR_FX03);    // sprite
    frame: 32770;             // frame
    tics: 8;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_CRBOWFXI3_2;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_CRBOWFXI3_1

   (
    sprite: Ord(SPR_FX03);    // sprite
    frame: 32771;             // frame
    tics: 8;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_CRBOWFXI3_3;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_CRBOWFXI3_2

   (
    sprite: Ord(SPR_FX03);    // sprite
    frame: 32772;             // frame
    tics: 8;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_NULL;        // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_CRBOWFXI3_3

   (
    sprite: Ord(SPR_FX03);    // sprite
    frame: 32773;             // frame
    tics: 8;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_CRBOWFX4_2;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_CRBOWFX4_1

   (
    sprite: Ord(SPR_FX03);    // sprite
    frame: 32774;             // frame
    tics: 8;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_NULL;        // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_CRBOWFX4_2

   (
    sprite: Ord(SPR_BLOD);    // sprite
    frame: 2;                 // frame
    tics: 8;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_BLOOD2;      // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_BLOOD1

   (
    sprite: Ord(SPR_BLOD);    // sprite
    frame: 1;                 // frame
    tics: 8;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_BLOOD3;      // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_BLOOD2

   (
    sprite: Ord(SPR_BLOD);    // sprite
    frame: 0;                 // frame
    tics: 8;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_NULL;        // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_BLOOD3

   (
    sprite: Ord(SPR_BLOD);    // sprite
    frame: 2;                 // frame
    tics: 8;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_BLOODSPLATTER2;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_BLOODSPLATTER1

   (
    sprite: Ord(SPR_BLOD);    // sprite
    frame: 1;                 // frame
    tics: 8;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_BLOODSPLATTER3;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_BLOODSPLATTER2

   (
    sprite: Ord(SPR_BLOD);    // sprite
    frame: 0;                 // frame
    tics: 8;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_NULL;        // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_BLOODSPLATTER3

   (
    sprite: Ord(SPR_BLOD);    // sprite
    frame: 0;                 // frame
    tics: 6;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_NULL;        // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_BLOODSPLATTERX

   (
    sprite: Ord(SPR_PLAY);    // sprite
    frame: 0;                 // frame
    tics: -1;                 // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_NULL;        // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_PLAY

   (
    sprite: Ord(SPR_PLAY);    // sprite
    frame: 0;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_PLAY_RUN2;   // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_PLAY_RUN1

   (
    sprite: Ord(SPR_PLAY);    // sprite
    frame: 1;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_PLAY_RUN3;   // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_PLAY_RUN2

   (
    sprite: Ord(SPR_PLAY);    // sprite
    frame: 2;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_PLAY_RUN4;   // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_PLAY_RUN3

   (
    sprite: Ord(SPR_PLAY);    // sprite
    frame: 3;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_PLAY_RUN1;   // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_PLAY_RUN4

   (
    sprite: Ord(SPR_PLAY);    // sprite
    frame: 4;                 // frame
    tics: 12;                 // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_PLAY;        // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_PLAY_ATK1

   (
    sprite: Ord(SPR_PLAY);    // sprite
    frame: 32773;             // frame
    tics: 6;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_PLAY_ATK1;   // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_PLAY_ATK2

   (
    sprite: Ord(SPR_PLAY);    // sprite
    frame: 6;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_PLAY_PAIN2;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_PLAY_PAIN

   (
    sprite: Ord(SPR_PLAY);    // sprite
    frame: 6;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_PLAY;        // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_PLAY_PAIN2

   (
    sprite: Ord(SPR_PLAY);    // sprite
    frame: 7;                 // frame
    tics: 6;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_PLAY_DIE2;   // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_PLAY_DIE1

   (
    sprite: Ord(SPR_PLAY);    // sprite
    frame: 8;                 // frame
    tics: 6;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_PLAY_DIE3;   // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_PLAY_DIE2

   (
    sprite: Ord(SPR_PLAY);    // sprite
    frame: 9;                 // frame
    tics: 6;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_PLAY_DIE4;   // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_PLAY_DIE3

   (
    sprite: Ord(SPR_PLAY);    // sprite
    frame: 10;                // frame
    tics: 6;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_PLAY_DIE5;   // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_PLAY_DIE4

   (
    sprite: Ord(SPR_PLAY);    // sprite
    frame: 11;                // frame
    tics: 6;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_PLAY_DIE6;   // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_PLAY_DIE5

   (
    sprite: Ord(SPR_PLAY);    // sprite
    frame: 12;                // frame
    tics: 6;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_PLAY_DIE7;   // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_PLAY_DIE6

   (
    sprite: Ord(SPR_PLAY);    // sprite
    frame: 13;                // frame
    tics: 6;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_PLAY_DIE8;   // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_PLAY_DIE7

   (
    sprite: Ord(SPR_PLAY);    // sprite
    frame: 14;                // frame
    tics: 6;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_PLAY_DIE9;   // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_PLAY_DIE8

   (
    sprite: Ord(SPR_PLAY);    // sprite
    frame: 15;                // frame
    tics: -1;                 // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_NULL;        // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_PLAY_DIE9

   (
    sprite: Ord(SPR_PLAY);    // sprite
    frame: 16;                // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_PLAY_XDIE2;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_PLAY_XDIE1

   (
    sprite: Ord(SPR_PLAY);    // sprite
    frame: 17;                // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_PLAY_XDIE3;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_PLAY_XDIE2

   (
    sprite: Ord(SPR_PLAY);    // sprite
    frame: 18;                // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_PLAY_XDIE4;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_PLAY_XDIE3

   (
    sprite: Ord(SPR_PLAY);    // sprite
    frame: 19;                // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_PLAY_XDIE5;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_PLAY_XDIE4

   (
    sprite: Ord(SPR_PLAY);    // sprite
    frame: 20;                // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_PLAY_XDIE6;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_PLAY_XDIE5

   (
    sprite: Ord(SPR_PLAY);    // sprite
    frame: 21;                // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_PLAY_XDIE7;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_PLAY_XDIE6

   (
    sprite: Ord(SPR_PLAY);    // sprite
    frame: 22;                // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_PLAY_XDIE8;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_PLAY_XDIE7

   (
    sprite: Ord(SPR_PLAY);    // sprite
    frame: 23;                // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_PLAY_XDIE9;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_PLAY_XDIE8

   (
    sprite: Ord(SPR_PLAY);    // sprite
    frame: 24;                // frame
    tics: -1;                 // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_NULL;        // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_PLAY_XDIE9

   (
    sprite: Ord(SPR_FDTH);    // sprite
    frame: 32768;             // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_PLAY_FDTH2;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_PLAY_FDTH1

   (
    sprite: Ord(SPR_FDTH);    // sprite
    frame: 32769;             // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_PLAY_FDTH3;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_PLAY_FDTH2

   (
    sprite: Ord(SPR_FDTH);    // sprite
    frame: 32770;             // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_PLAY_FDTH4;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_PLAY_FDTH3

   (
    sprite: Ord(SPR_FDTH);    // sprite
    frame: 32771;             // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_PLAY_FDTH5;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_PLAY_FDTH4

   (
    sprite: Ord(SPR_FDTH);    // sprite
    frame: 32772;             // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_PLAY_FDTH6;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_PLAY_FDTH5

   (
    sprite: Ord(SPR_FDTH);    // sprite
    frame: 32773;             // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_PLAY_FDTH7;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_PLAY_FDTH6

   (
    sprite: Ord(SPR_FDTH);    // sprite
    frame: 32774;             // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_PLAY_FDTH8;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_PLAY_FDTH7

   (
    sprite: Ord(SPR_FDTH);    // sprite
    frame: 32775;             // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_PLAY_FDTH9;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_PLAY_FDTH8

   (
    sprite: Ord(SPR_FDTH);    // sprite
    frame: 32776;             // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_PLAY_FDTH10;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_PLAY_FDTH9

   (
    sprite: Ord(SPR_FDTH);    // sprite
    frame: 32777;             // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_PLAY_FDTH11;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_PLAY_FDTH10

   (
    sprite: Ord(SPR_FDTH);    // sprite
    frame: 32778;             // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_PLAY_FDTH12;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_PLAY_FDTH11

   (
    sprite: Ord(SPR_FDTH);    // sprite
    frame: 32779;             // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_PLAY_FDTH13;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_PLAY_FDTH12

   (
    sprite: Ord(SPR_FDTH);    // sprite
    frame: 32780;             // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_PLAY_FDTH14;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_PLAY_FDTH13

   (
    sprite: Ord(SPR_FDTH);    // sprite
    frame: 32781;             // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_PLAY_FDTH15;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_PLAY_FDTH14

   (
    sprite: Ord(SPR_FDTH);    // sprite
    frame: 32782;             // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_PLAY_FDTH16;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_PLAY_FDTH15

   (
    sprite: Ord(SPR_FDTH);    // sprite
    frame: 32783;             // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_PLAY_FDTH17;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_PLAY_FDTH16

   (
    sprite: Ord(SPR_FDTH);    // sprite
    frame: 32784;             // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_PLAY_FDTH18;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_PLAY_FDTH17

   (
    sprite: Ord(SPR_FDTH);    // sprite
    frame: 32785;             // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_PLAY_FDTH19;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_PLAY_FDTH18

   (
    sprite: Ord(SPR_ACLO);    // sprite
    frame: 4;                 // frame
    tics: 35;                 // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_PLAY_FDTH19;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_PLAY_FDTH19

   (
    sprite: Ord(SPR_ACLO);    // sprite
    frame: 4;                 // frame
    tics: 8;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_NULL;        // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_PLAY_FDTH20

   (
    sprite: Ord(SPR_BSKL);    // sprite
    frame: 0;                 // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_BLOODYSKULL2;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_BLOODYSKULL1

   (
    sprite: Ord(SPR_BSKL);    // sprite
    frame: 1;                 // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_BLOODYSKULL3;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_BLOODYSKULL2

   (
    sprite: Ord(SPR_BSKL);    // sprite
    frame: 2;                 // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_BLOODYSKULL4;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_BLOODYSKULL3

   (
    sprite: Ord(SPR_BSKL);    // sprite
    frame: 3;                 // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_BLOODYSKULL5;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_BLOODYSKULL4

   (
    sprite: Ord(SPR_BSKL);    // sprite
    frame: 4;                 // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_BLOODYSKULL1;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_BLOODYSKULL5

   (
    sprite: Ord(SPR_BSKL);    // sprite
    frame: 5;                 // frame
    tics: 16;                 // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_BLOODYSKULLX1;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_BLOODYSKULLX1

   (
    sprite: Ord(SPR_BSKL);    // sprite
    frame: 5;                 // frame
    tics: 1050;               // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_NULL;        // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_BLOODYSKULLX2

   (
    sprite: Ord(SPR_CHKN);    // sprite
    frame: 0;                 // frame
    tics: -1;                 // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_NULL;        // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_CHICPLAY

   (
    sprite: Ord(SPR_CHKN);    // sprite
    frame: 0;                 // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_CHICPLAY_RUN2;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_CHICPLAY_RUN1

   (
    sprite: Ord(SPR_CHKN);    // sprite
    frame: 1;                 // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_CHICPLAY_RUN3;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_CHICPLAY_RUN2

   (
    sprite: Ord(SPR_CHKN);    // sprite
    frame: 0;                 // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_CHICPLAY_RUN4;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_CHICPLAY_RUN3

   (
    sprite: Ord(SPR_CHKN);    // sprite
    frame: 1;                 // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_CHICPLAY_RUN1;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_CHICPLAY_RUN4

   (
    sprite: Ord(SPR_CHKN);    // sprite
    frame: 2;                 // frame
    tics: 12;                 // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_CHICPLAY;    // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_CHICPLAY_ATK1

   (
    sprite: Ord(SPR_CHKN);    // sprite
    frame: 3;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_CHICPLAY_PAIN2;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_CHICPLAY_PAIN

   (
    sprite: Ord(SPR_CHKN);    // sprite
    frame: 2;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_CHICPLAY;    // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_CHICPLAY_PAIN2

   (
    sprite: Ord(SPR_CHKN);    // sprite
    frame: 0;                 // frame
    tics: 10;                 // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_CHICKEN_LOOK2;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_CHICKEN_LOOK1

   (
    sprite: Ord(SPR_CHKN);    // sprite
    frame: 1;                 // frame
    tics: 10;                 // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_CHICKEN_LOOK1;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_CHICKEN_LOOK2

   (
    sprite: Ord(SPR_CHKN);    // sprite
    frame: 0;                 // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_CHICKEN_WALK2;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_CHICKEN_WALK1

   (
    sprite: Ord(SPR_CHKN);    // sprite
    frame: 1;                 // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_CHICKEN_WALK1;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_CHICKEN_WALK2

   (
    sprite: Ord(SPR_CHKN);    // sprite
    frame: 3;                 // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_CHICKEN_PAIN2;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_CHICKEN_PAIN1

   (
    sprite: Ord(SPR_CHKN);    // sprite
    frame: 2;                 // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_CHICKEN_WALK1;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_CHICKEN_PAIN2

   (
    sprite: Ord(SPR_CHKN);    // sprite
    frame: 0;                 // frame
    tics: 8;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_CHICKEN_ATK2;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_CHICKEN_ATK1

   (
    sprite: Ord(SPR_CHKN);    // sprite
    frame: 2;                 // frame
    tics: 10;                 // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_CHICKEN_WALK1;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_CHICKEN_ATK2

   (
    sprite: Ord(SPR_CHKN);    // sprite
    frame: 4;                 // frame
    tics: 6;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_CHICKEN_DIE2;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_CHICKEN_DIE1

   (
    sprite: Ord(SPR_CHKN);    // sprite
    frame: 5;                 // frame
    tics: 6;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_CHICKEN_DIE3;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_CHICKEN_DIE2

   (
    sprite: Ord(SPR_CHKN);    // sprite
    frame: 6;                 // frame
    tics: 6;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_CHICKEN_DIE4;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_CHICKEN_DIE3

   (
    sprite: Ord(SPR_CHKN);    // sprite
    frame: 7;                 // frame
    tics: 6;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_CHICKEN_DIE5;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_CHICKEN_DIE4

   (
    sprite: Ord(SPR_CHKN);    // sprite
    frame: 8;                 // frame
    tics: 6;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_CHICKEN_DIE6;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_CHICKEN_DIE5

   (
    sprite: Ord(SPR_CHKN);    // sprite
    frame: 9;                 // frame
    tics: 6;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_CHICKEN_DIE7;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_CHICKEN_DIE6

   (
    sprite: Ord(SPR_CHKN);    // sprite
    frame: 10;                // frame
    tics: 6;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_CHICKEN_DIE8;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_CHICKEN_DIE7

   (
    sprite: Ord(SPR_CHKN);    // sprite
    frame: 11;                // frame
    tics: -1;                 // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_NULL;        // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_CHICKEN_DIE8

   (
    sprite: Ord(SPR_CHKN);    // sprite
    frame: 12;                // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_FEATHER2;    // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_FEATHER1

   (
    sprite: Ord(SPR_CHKN);    // sprite
    frame: 13;                // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_FEATHER3;    // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_FEATHER2

   (
    sprite: Ord(SPR_CHKN);    // sprite
    frame: 14;                // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_FEATHER4;    // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_FEATHER3

   (
    sprite: Ord(SPR_CHKN);    // sprite
    frame: 15;                // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_FEATHER5;    // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_FEATHER4

   (
    sprite: Ord(SPR_CHKN);    // sprite
    frame: 16;                // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_FEATHER6;    // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_FEATHER5

   (
    sprite: Ord(SPR_CHKN);    // sprite
    frame: 15;                // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_FEATHER7;    // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_FEATHER6

   (
    sprite: Ord(SPR_CHKN);    // sprite
    frame: 14;                // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_FEATHER8;    // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_FEATHER7

   (
    sprite: Ord(SPR_CHKN);    // sprite
    frame: 13;                // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_FEATHER1;    // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_FEATHER8

   (
    sprite: Ord(SPR_CHKN);    // sprite
    frame: 13;                // frame
    tics: 6;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_NULL;        // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_FEATHERX

   (
    sprite: Ord(SPR_MUMM);    // sprite
    frame: 0;                 // frame
    tics: 10;                 // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_MUMMY_LOOK2;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_MUMMY_LOOK1

   (
    sprite: Ord(SPR_MUMM);    // sprite
    frame: 1;                 // frame
    tics: 10;                 // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_MUMMY_LOOK1;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_MUMMY_LOOK2

   (
    sprite: Ord(SPR_MUMM);    // sprite
    frame: 0;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_MUMMY_WALK2;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_MUMMY_WALK1

   (
    sprite: Ord(SPR_MUMM);    // sprite
    frame: 1;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_MUMMY_WALK3;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_MUMMY_WALK2

   (
    sprite: Ord(SPR_MUMM);    // sprite
    frame: 2;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_MUMMY_WALK4;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_MUMMY_WALK3

   (
    sprite: Ord(SPR_MUMM);    // sprite
    frame: 3;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_MUMMY_WALK1;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_MUMMY_WALK4

   (
    sprite: Ord(SPR_MUMM);    // sprite
    frame: 4;                 // frame
    tics: 6;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_MUMMY_ATK2;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_MUMMY_ATK1

   (
    sprite: Ord(SPR_MUMM);    // sprite
    frame: 5;                 // frame
    tics: 6;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_MUMMY_ATK3;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_MUMMY_ATK2

   (
    sprite: Ord(SPR_MUMM);    // sprite
    frame: 6;                 // frame
    tics: 6;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_MUMMY_WALK1;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_MUMMY_ATK3

   (
    sprite: Ord(SPR_MUMM);    // sprite
    frame: 23;                // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_MUMMYL_ATK2;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_MUMMYL_ATK1

   (
    sprite: Ord(SPR_MUMM);    // sprite
    frame: 32792;             // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_MUMMYL_ATK3;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_MUMMYL_ATK2

   (
    sprite: Ord(SPR_MUMM);    // sprite
    frame: 23;                // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_MUMMYL_ATK4;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_MUMMYL_ATK3

   (
    sprite: Ord(SPR_MUMM);    // sprite
    frame: 32792;             // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_MUMMYL_ATK5;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_MUMMYL_ATK4

   (
    sprite: Ord(SPR_MUMM);    // sprite
    frame: 23;                // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_MUMMYL_ATK6;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_MUMMYL_ATK5

   (
    sprite: Ord(SPR_MUMM);    // sprite
    frame: 32792;             // frame
    tics: 15;                 // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_MUMMY_WALK1;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_MUMMYL_ATK6

   (
    sprite: Ord(SPR_MUMM);    // sprite
    frame: 7;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_MUMMY_PAIN2;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_MUMMY_PAIN1

   (
    sprite: Ord(SPR_MUMM);    // sprite
    frame: 7;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_MUMMY_WALK1;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_MUMMY_PAIN2

   (
    sprite: Ord(SPR_MUMM);    // sprite
    frame: 8;                 // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_MUMMY_DIE2;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_MUMMY_DIE1

   (
    sprite: Ord(SPR_MUMM);    // sprite
    frame: 9;                 // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_MUMMY_DIE3;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_MUMMY_DIE2

   (
    sprite: Ord(SPR_MUMM);    // sprite
    frame: 10;                // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_MUMMY_DIE4;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_MUMMY_DIE3

   (
    sprite: Ord(SPR_MUMM);    // sprite
    frame: 11;                // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_MUMMY_DIE5;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_MUMMY_DIE4

   (
    sprite: Ord(SPR_MUMM);    // sprite
    frame: 12;                // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_MUMMY_DIE6;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_MUMMY_DIE5

   (
    sprite: Ord(SPR_MUMM);    // sprite
    frame: 13;                // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_MUMMY_DIE7;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_MUMMY_DIE6

   (
    sprite: Ord(SPR_MUMM);    // sprite
    frame: 14;                // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_MUMMY_DIE8;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_MUMMY_DIE7

   (
    sprite: Ord(SPR_MUMM);    // sprite
    frame: 15;                // frame
    tics: -1;                 // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_NULL;        // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_MUMMY_DIE8

   (
    sprite: Ord(SPR_MUMM);    // sprite
    frame: 16;                // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_MUMMY_SOUL2;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_MUMMY_SOUL1

   (
    sprite: Ord(SPR_MUMM);    // sprite
    frame: 17;                // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_MUMMY_SOUL3;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_MUMMY_SOUL2

   (
    sprite: Ord(SPR_MUMM);    // sprite
    frame: 18;                // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_MUMMY_SOUL4;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_MUMMY_SOUL3

   (
    sprite: Ord(SPR_MUMM);    // sprite
    frame: 19;                // frame
    tics: 9;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_MUMMY_SOUL5;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_MUMMY_SOUL4

   (
    sprite: Ord(SPR_MUMM);    // sprite
    frame: 20;                // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_MUMMY_SOUL6;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_MUMMY_SOUL5

   (
    sprite: Ord(SPR_MUMM);    // sprite
    frame: 21;                // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_MUMMY_SOUL7;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_MUMMY_SOUL6

   (
    sprite: Ord(SPR_MUMM);    // sprite
    frame: 22;                // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_NULL;        // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_MUMMY_SOUL7

   (
    sprite: Ord(SPR_FX15);    // sprite
    frame: 32768;             // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_MUMMYFX1_2;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_MUMMYFX1_1

   (
    sprite: Ord(SPR_FX15);    // sprite
    frame: 32769;             // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_MUMMYFX1_3;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_MUMMYFX1_2

   (
    sprite: Ord(SPR_FX15);    // sprite
    frame: 32770;             // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_MUMMYFX1_4;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_MUMMYFX1_3

   (
    sprite: Ord(SPR_FX15);    // sprite
    frame: 32769;             // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_MUMMYFX1_1;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_MUMMYFX1_4

   (
    sprite: Ord(SPR_FX15);    // sprite
    frame: 32771;             // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_MUMMYFXI1_2;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_MUMMYFXI1_1

   (
    sprite: Ord(SPR_FX15);    // sprite
    frame: 32772;             // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_MUMMYFXI1_3;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_MUMMYFXI1_2

   (
    sprite: Ord(SPR_FX15);    // sprite
    frame: 32773;             // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_MUMMYFXI1_4;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_MUMMYFXI1_3

   (
    sprite: Ord(SPR_FX15);    // sprite
    frame: 32774;             // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_NULL;        // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_MUMMYFXI1_4

   (
    sprite: Ord(SPR_BEAS);    // sprite
    frame: 0;                 // frame
    tics: 10;                 // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_BEAST_LOOK2;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_BEAST_LOOK1

   (
    sprite: Ord(SPR_BEAS);    // sprite
    frame: 1;                 // frame
    tics: 10;                 // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_BEAST_LOOK1;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_BEAST_LOOK2

   (
    sprite: Ord(SPR_BEAS);    // sprite
    frame: 0;                 // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_BEAST_WALK2;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_BEAST_WALK1

   (
    sprite: Ord(SPR_BEAS);    // sprite
    frame: 1;                 // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_BEAST_WALK3;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_BEAST_WALK2

   (
    sprite: Ord(SPR_BEAS);    // sprite
    frame: 2;                 // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_BEAST_WALK4;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_BEAST_WALK3

   (
    sprite: Ord(SPR_BEAS);    // sprite
    frame: 3;                 // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_BEAST_WALK5;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_BEAST_WALK4

   (
    sprite: Ord(SPR_BEAS);    // sprite
    frame: 4;                 // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_BEAST_WALK6;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_BEAST_WALK5

   (
    sprite: Ord(SPR_BEAS);    // sprite
    frame: 5;                 // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_BEAST_WALK1;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_BEAST_WALK6

   (
    sprite: Ord(SPR_BEAS);    // sprite
    frame: 7;                 // frame
    tics: 10;                 // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_BEAST_ATK2;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_BEAST_ATK1

   (
    sprite: Ord(SPR_BEAS);    // sprite
    frame: 8;                 // frame
    tics: 10;                 // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_BEAST_WALK1;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_BEAST_ATK2

   (
    sprite: Ord(SPR_BEAS);    // sprite
    frame: 6;                 // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_BEAST_PAIN2;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_BEAST_PAIN1

   (
    sprite: Ord(SPR_BEAS);    // sprite
    frame: 6;                 // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_BEAST_WALK1;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_BEAST_PAIN2

   (
    sprite: Ord(SPR_BEAS);    // sprite
    frame: 17;                // frame
    tics: 6;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_BEAST_DIE2;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_BEAST_DIE1

   (
    sprite: Ord(SPR_BEAS);    // sprite
    frame: 18;                // frame
    tics: 6;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_BEAST_DIE3;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_BEAST_DIE2

   (
    sprite: Ord(SPR_BEAS);    // sprite
    frame: 19;                // frame
    tics: 6;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_BEAST_DIE4;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_BEAST_DIE3

   (
    sprite: Ord(SPR_BEAS);    // sprite
    frame: 20;                // frame
    tics: 6;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_BEAST_DIE5;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_BEAST_DIE4

   (
    sprite: Ord(SPR_BEAS);    // sprite
    frame: 21;                // frame
    tics: 6;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_BEAST_DIE6;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_BEAST_DIE5

   (
    sprite: Ord(SPR_BEAS);    // sprite
    frame: 22;                // frame
    tics: 6;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_BEAST_DIE7;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_BEAST_DIE6

   (
    sprite: Ord(SPR_BEAS);    // sprite
    frame: 23;                // frame
    tics: 6;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_BEAST_DIE8;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_BEAST_DIE7

   (
    sprite: Ord(SPR_BEAS);    // sprite
    frame: 24;                // frame
    tics: 6;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_BEAST_DIE9;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_BEAST_DIE8

   (
    sprite: Ord(SPR_BEAS);    // sprite
    frame: 25;                // frame
    tics: -1;                 // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_NULL;        // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_BEAST_DIE9

   (
    sprite: Ord(SPR_BEAS);    // sprite
    frame: 9;                 // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_BEAST_XDIE2;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_BEAST_XDIE1

   (
    sprite: Ord(SPR_BEAS);    // sprite
    frame: 10;                // frame
    tics: 6;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_BEAST_XDIE3;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_BEAST_XDIE2

   (
    sprite: Ord(SPR_BEAS);    // sprite
    frame: 11;                // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_BEAST_XDIE4;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_BEAST_XDIE3

   (
    sprite: Ord(SPR_BEAS);    // sprite
    frame: 12;                // frame
    tics: 6;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_BEAST_XDIE5;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_BEAST_XDIE4

   (
    sprite: Ord(SPR_BEAS);    // sprite
    frame: 13;                // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_BEAST_XDIE6;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_BEAST_XDIE5

   (
    sprite: Ord(SPR_BEAS);    // sprite
    frame: 14;                // frame
    tics: 6;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_BEAST_XDIE7;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_BEAST_XDIE6

   (
    sprite: Ord(SPR_BEAS);    // sprite
    frame: 15;                // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_BEAST_XDIE8;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_BEAST_XDIE7

   (
    sprite: Ord(SPR_BEAS);    // sprite
    frame: 16;                // frame
    tics: -1;                 // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_NULL;        // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_BEAST_XDIE8

   (
    sprite: Ord(SPR_FRB1);    // sprite
    frame: 0;                 // frame
    tics: 2;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_BEASTBALL2;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_BEASTBALL1

   (
    sprite: Ord(SPR_FRB1);    // sprite
    frame: 0;                 // frame
    tics: 2;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_BEASTBALL3;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_BEASTBALL2

   (
    sprite: Ord(SPR_FRB1);    // sprite
    frame: 1;                 // frame
    tics: 2;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_BEASTBALL4;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_BEASTBALL3

   (
    sprite: Ord(SPR_FRB1);    // sprite
    frame: 1;                 // frame
    tics: 2;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_BEASTBALL5;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_BEASTBALL4

   (
    sprite: Ord(SPR_FRB1);    // sprite
    frame: 2;                 // frame
    tics: 2;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_BEASTBALL6;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_BEASTBALL5

   (
    sprite: Ord(SPR_FRB1);    // sprite
    frame: 2;                 // frame
    tics: 2;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_BEASTBALL1;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_BEASTBALL6

   (
    sprite: Ord(SPR_FRB1);    // sprite
    frame: 3;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_BEASTBALLX2;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_BEASTBALLX1

   (
    sprite: Ord(SPR_FRB1);    // sprite
    frame: 4;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_BEASTBALLX3;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_BEASTBALLX2

   (
    sprite: Ord(SPR_FRB1);    // sprite
    frame: 5;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_BEASTBALLX4;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_BEASTBALLX3

   (
    sprite: Ord(SPR_FRB1);    // sprite
    frame: 6;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_BEASTBALLX5;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_BEASTBALLX4

   (
    sprite: Ord(SPR_FRB1);    // sprite
    frame: 7;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_NULL;        // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_BEASTBALLX5

   (
    sprite: Ord(SPR_FRB1);    // sprite
    frame: 0;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_BURNBALL2;   // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_BURNBALL1

   (
    sprite: Ord(SPR_FRB1);    // sprite
    frame: 1;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_BURNBALL3;   // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_BURNBALL2

   (
    sprite: Ord(SPR_FRB1);    // sprite
    frame: 2;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_BURNBALL4;   // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_BURNBALL3

   (
    sprite: Ord(SPR_FRB1);    // sprite
    frame: 3;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_BURNBALL5;   // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_BURNBALL4

   (
    sprite: Ord(SPR_FRB1);    // sprite
    frame: 4;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_BURNBALL6;   // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_BURNBALL5

   (
    sprite: Ord(SPR_FRB1);    // sprite
    frame: 5;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_BURNBALL7;   // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_BURNBALL6

   (
    sprite: Ord(SPR_FRB1);    // sprite
    frame: 6;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_BURNBALL8;   // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_BURNBALL7

   (
    sprite: Ord(SPR_FRB1);    // sprite
    frame: 7;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_NULL;        // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_BURNBALL8

   (
    sprite: Ord(SPR_FRB1);    // sprite
    frame: 32768;             // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_BURNBALLFB2;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_BURNBALLFB1

   (
    sprite: Ord(SPR_FRB1);    // sprite
    frame: 32769;             // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_BURNBALLFB3;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_BURNBALLFB2

   (
    sprite: Ord(SPR_FRB1);    // sprite
    frame: 32770;             // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_BURNBALLFB4;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_BURNBALLFB3

   (
    sprite: Ord(SPR_FRB1);    // sprite
    frame: 32771;             // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_BURNBALLFB5;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_BURNBALLFB4

   (
    sprite: Ord(SPR_FRB1);    // sprite
    frame: 32772;             // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_BURNBALLFB6;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_BURNBALLFB5

   (
    sprite: Ord(SPR_FRB1);    // sprite
    frame: 32773;             // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_BURNBALLFB7;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_BURNBALLFB6

   (
    sprite: Ord(SPR_FRB1);    // sprite
    frame: 32774;             // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_BURNBALLFB8;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_BURNBALLFB7

   (
    sprite: Ord(SPR_FRB1);    // sprite
    frame: 32775;             // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_NULL;        // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_BURNBALLFB8

   (
    sprite: Ord(SPR_FRB1);    // sprite
    frame: 3;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_PUFFY2;      // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_PUFFY1

   (
    sprite: Ord(SPR_FRB1);    // sprite
    frame: 4;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_PUFFY3;      // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_PUFFY2

   (
    sprite: Ord(SPR_FRB1);    // sprite
    frame: 5;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_PUFFY4;      // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_PUFFY3

   (
    sprite: Ord(SPR_FRB1);    // sprite
    frame: 6;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_PUFFY5;      // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_PUFFY4

   (
    sprite: Ord(SPR_FRB1);    // sprite
    frame: 7;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_NULL;        // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_PUFFY5

   (
    sprite: Ord(SPR_SNKE);    // sprite
    frame: 0;                 // frame
    tics: 10;                 // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_SNAKE_LOOK2;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SNAKE_LOOK1

   (
    sprite: Ord(SPR_SNKE);    // sprite
    frame: 1;                 // frame
    tics: 10;                 // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_SNAKE_LOOK1;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SNAKE_LOOK2

   (
    sprite: Ord(SPR_SNKE);    // sprite
    frame: 0;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_SNAKE_WALK2;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SNAKE_WALK1

   (
    sprite: Ord(SPR_SNKE);    // sprite
    frame: 1;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_SNAKE_WALK3;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SNAKE_WALK2

   (
    sprite: Ord(SPR_SNKE);    // sprite
    frame: 2;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_SNAKE_WALK4;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SNAKE_WALK3

   (
    sprite: Ord(SPR_SNKE);    // sprite
    frame: 3;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_SNAKE_WALK1;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SNAKE_WALK4

   (
    sprite: Ord(SPR_SNKE);    // sprite
    frame: 5;                 // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_SNAKE_ATK2;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SNAKE_ATK1

   (
    sprite: Ord(SPR_SNKE);    // sprite
    frame: 5;                 // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_SNAKE_ATK3;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SNAKE_ATK2

   (
    sprite: Ord(SPR_SNKE);    // sprite
    frame: 5;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_SNAKE_ATK4;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SNAKE_ATK3

   (
    sprite: Ord(SPR_SNKE);    // sprite
    frame: 5;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_SNAKE_ATK5;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SNAKE_ATK4

   (
    sprite: Ord(SPR_SNKE);    // sprite
    frame: 5;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_SNAKE_ATK6;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SNAKE_ATK5

   (
    sprite: Ord(SPR_SNKE);    // sprite
    frame: 5;                 // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_SNAKE_ATK7;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SNAKE_ATK6

   (
    sprite: Ord(SPR_SNKE);    // sprite
    frame: 5;                 // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_SNAKE_ATK8;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SNAKE_ATK7

   (
    sprite: Ord(SPR_SNKE);    // sprite
    frame: 5;                 // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_SNAKE_ATK9;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SNAKE_ATK8

   (
    sprite: Ord(SPR_SNKE);    // sprite
    frame: 5;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_SNAKE_WALK1;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SNAKE_ATK9

   (
    sprite: Ord(SPR_SNKE);    // sprite
    frame: 4;                 // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_SNAKE_PAIN2;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SNAKE_PAIN1

   (
    sprite: Ord(SPR_SNKE);    // sprite
    frame: 4;                 // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_SNAKE_WALK1;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SNAKE_PAIN2

   (
    sprite: Ord(SPR_SNKE);    // sprite
    frame: 6;                 // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_SNAKE_DIE2;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SNAKE_DIE1

   (
    sprite: Ord(SPR_SNKE);    // sprite
    frame: 7;                 // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_SNAKE_DIE3;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SNAKE_DIE2

   (
    sprite: Ord(SPR_SNKE);    // sprite
    frame: 8;                 // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_SNAKE_DIE4;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SNAKE_DIE3

   (
    sprite: Ord(SPR_SNKE);    // sprite
    frame: 9;                 // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_SNAKE_DIE5;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SNAKE_DIE4

   (
    sprite: Ord(SPR_SNKE);    // sprite
    frame: 10;                // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_SNAKE_DIE6;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SNAKE_DIE5

   (
    sprite: Ord(SPR_SNKE);    // sprite
    frame: 11;                // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_SNAKE_DIE7;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SNAKE_DIE6

   (
    sprite: Ord(SPR_SNKE);    // sprite
    frame: 12;                // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_SNAKE_DIE8;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SNAKE_DIE7

   (
    sprite: Ord(SPR_SNKE);    // sprite
    frame: 13;                // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_SNAKE_DIE9;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SNAKE_DIE8

   (
    sprite: Ord(SPR_SNKE);    // sprite
    frame: 14;                // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_SNAKE_DIE10;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SNAKE_DIE9

   (
    sprite: Ord(SPR_SNKE);    // sprite
    frame: 15;                // frame
    tics: -1;                 // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_NULL;        // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SNAKE_DIE10

   (
    sprite: Ord(SPR_SNFX);    // sprite
    frame: 32768;             // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_SNAKEPRO_A2;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SNAKEPRO_A1

   (
    sprite: Ord(SPR_SNFX);    // sprite
    frame: 32769;             // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_SNAKEPRO_A3;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SNAKEPRO_A2

   (
    sprite: Ord(SPR_SNFX);    // sprite
    frame: 32770;             // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_SNAKEPRO_A4;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SNAKEPRO_A3

   (
    sprite: Ord(SPR_SNFX);    // sprite
    frame: 32771;             // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_SNAKEPRO_A1;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SNAKEPRO_A4

   (
    sprite: Ord(SPR_SNFX);    // sprite
    frame: 32772;             // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_SNAKEPRO_AX2;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SNAKEPRO_AX1

   (
    sprite: Ord(SPR_SNFX);    // sprite
    frame: 32773;             // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_SNAKEPRO_AX3;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SNAKEPRO_AX2

   (
    sprite: Ord(SPR_SNFX);    // sprite
    frame: 32774;             // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_SNAKEPRO_AX4;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SNAKEPRO_AX3

   (
    sprite: Ord(SPR_SNFX);    // sprite
    frame: 32775;             // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_SNAKEPRO_AX5;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SNAKEPRO_AX4

   (
    sprite: Ord(SPR_SNFX);    // sprite
    frame: 32776;             // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_NULL;        // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SNAKEPRO_AX5

   (
    sprite: Ord(SPR_SNFX);    // sprite
    frame: 32777;             // frame
    tics: 6;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_SNAKEPRO_B2;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SNAKEPRO_B1

   (
    sprite: Ord(SPR_SNFX);    // sprite
    frame: 32778;             // frame
    tics: 6;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_SNAKEPRO_B1;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SNAKEPRO_B2

   (
    sprite: Ord(SPR_SNFX);    // sprite
    frame: 32779;             // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_SNAKEPRO_BX2;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SNAKEPRO_BX1

   (
    sprite: Ord(SPR_SNFX);    // sprite
    frame: 32780;             // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_SNAKEPRO_BX3;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SNAKEPRO_BX2

   (
    sprite: Ord(SPR_SNFX);    // sprite
    frame: 32781;             // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_SNAKEPRO_BX4;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SNAKEPRO_BX3

   (
    sprite: Ord(SPR_SNFX);    // sprite
    frame: 32782;             // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_NULL;        // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SNAKEPRO_BX4

   (
    sprite: Ord(SPR_HEAD);    // sprite
    frame: 0;                 // frame
    tics: 10;                 // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_HEAD_LOOK;   // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_HEAD_LOOK

   (
    sprite: Ord(SPR_HEAD);    // sprite
    frame: 0;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_HEAD_FLOAT;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_HEAD_FLOAT

   (
    sprite: Ord(SPR_HEAD);    // sprite
    frame: 0;                 // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_HEAD_ATK2;   // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_HEAD_ATK1

   (
    sprite: Ord(SPR_HEAD);    // sprite
    frame: 1;                 // frame
    tics: 20;                 // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_HEAD_FLOAT;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_HEAD_ATK2

   (
    sprite: Ord(SPR_HEAD);    // sprite
    frame: 0;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_HEAD_PAIN2;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_HEAD_PAIN1

   (
    sprite: Ord(SPR_HEAD);    // sprite
    frame: 0;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_HEAD_FLOAT;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_HEAD_PAIN2

   (
    sprite: Ord(SPR_HEAD);    // sprite
    frame: 2;                 // frame
    tics: 7;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_HEAD_DIE2;   // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_HEAD_DIE1

   (
    sprite: Ord(SPR_HEAD);    // sprite
    frame: 3;                 // frame
    tics: 7;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_HEAD_DIE3;   // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_HEAD_DIE2

   (
    sprite: Ord(SPR_HEAD);    // sprite
    frame: 4;                 // frame
    tics: 7;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_HEAD_DIE4;   // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_HEAD_DIE3

   (
    sprite: Ord(SPR_HEAD);    // sprite
    frame: 5;                 // frame
    tics: 7;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_HEAD_DIE5;   // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_HEAD_DIE4

   (
    sprite: Ord(SPR_HEAD);    // sprite
    frame: 6;                 // frame
    tics: 7;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_HEAD_DIE6;   // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_HEAD_DIE5

   (
    sprite: Ord(SPR_HEAD);    // sprite
    frame: 7;                 // frame
    tics: 7;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_HEAD_DIE7;   // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_HEAD_DIE6

   (
    sprite: Ord(SPR_HEAD);    // sprite
    frame: 8;                 // frame
    tics: -1;                 // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_NULL;        // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_HEAD_DIE7

   (
    sprite: Ord(SPR_FX05);    // sprite
    frame: 0;                 // frame
    tics: 6;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_HEADFX1_2;   // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_HEADFX1_1

   (
    sprite: Ord(SPR_FX05);    // sprite
    frame: 1;                 // frame
    tics: 6;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_HEADFX1_3;   // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_HEADFX1_2

   (
    sprite: Ord(SPR_FX05);    // sprite
    frame: 2;                 // frame
    tics: 6;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_HEADFX1_1;   // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_HEADFX1_3

   (
    sprite: Ord(SPR_FX05);    // sprite
    frame: 3;                 // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_HEADFXI1_2;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_HEADFXI1_1

   (
    sprite: Ord(SPR_FX05);    // sprite
    frame: 4;                 // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_HEADFXI1_3;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_HEADFXI1_2

   (
    sprite: Ord(SPR_FX05);    // sprite
    frame: 5;                 // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_HEADFXI1_4;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_HEADFXI1_3

   (
    sprite: Ord(SPR_FX05);    // sprite
    frame: 6;                 // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_NULL;        // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_HEADFXI1_4

   (
    sprite: Ord(SPR_FX05);    // sprite
    frame: 7;                 // frame
    tics: 6;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_HEADFX2_2;   // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_HEADFX2_1

   (
    sprite: Ord(SPR_FX05);    // sprite
    frame: 8;                 // frame
    tics: 6;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_HEADFX2_3;   // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_HEADFX2_2

   (
    sprite: Ord(SPR_FX05);    // sprite
    frame: 9;                 // frame
    tics: 6;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_HEADFX2_1;   // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_HEADFX2_3

   (
    sprite: Ord(SPR_FX05);    // sprite
    frame: 3;                 // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_HEADFXI2_2;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_HEADFXI2_1

   (
    sprite: Ord(SPR_FX05);    // sprite
    frame: 4;                 // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_HEADFXI2_3;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_HEADFXI2_2

   (
    sprite: Ord(SPR_FX05);    // sprite
    frame: 5;                 // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_HEADFXI2_4;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_HEADFXI2_3

   (
    sprite: Ord(SPR_FX05);    // sprite
    frame: 6;                 // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_NULL;        // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_HEADFXI2_4

   (
    sprite: Ord(SPR_FX06);    // sprite
    frame: 0;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_HEADFX3_2;   // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_HEADFX3_1

   (
    sprite: Ord(SPR_FX06);    // sprite
    frame: 1;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_HEADFX3_3;   // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_HEADFX3_2

   (
    sprite: Ord(SPR_FX06);    // sprite
    frame: 2;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_HEADFX3_1;   // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_HEADFX3_3

   (
    sprite: Ord(SPR_FX06);    // sprite
    frame: 0;                 // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_HEADFX3_5;   // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_HEADFX3_4

   (
    sprite: Ord(SPR_FX06);    // sprite
    frame: 1;                 // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_HEADFX3_6;   // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_HEADFX3_5

   (
    sprite: Ord(SPR_FX06);    // sprite
    frame: 2;                 // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_HEADFX3_4;   // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_HEADFX3_6

   (
    sprite: Ord(SPR_FX06);    // sprite
    frame: 3;                 // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_HEADFXI3_2;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_HEADFXI3_1

   (
    sprite: Ord(SPR_FX06);    // sprite
    frame: 4;                 // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_HEADFXI3_3;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_HEADFXI3_2

   (
    sprite: Ord(SPR_FX06);    // sprite
    frame: 5;                 // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_HEADFXI3_4;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_HEADFXI3_3

   (
    sprite: Ord(SPR_FX06);    // sprite
    frame: 6;                 // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_NULL;        // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_HEADFXI3_4

   (
    sprite: Ord(SPR_FX07);    // sprite
    frame: 3;                 // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_HEADFX4_2;   // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_HEADFX4_1

   (
    sprite: Ord(SPR_FX07);    // sprite
    frame: 4;                 // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_HEADFX4_3;   // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_HEADFX4_2

   (
    sprite: Ord(SPR_FX07);    // sprite
    frame: 5;                 // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_HEADFX4_4;   // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_HEADFX4_3

   (
    sprite: Ord(SPR_FX07);    // sprite
    frame: 6;                 // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_HEADFX4_5;   // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_HEADFX4_4

   (
    sprite: Ord(SPR_FX07);    // sprite
    frame: 0;                 // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_HEADFX4_6;   // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_HEADFX4_5

   (
    sprite: Ord(SPR_FX07);    // sprite
    frame: 1;                 // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_HEADFX4_7;   // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_HEADFX4_6

   (
    sprite: Ord(SPR_FX07);    // sprite
    frame: 2;                 // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_HEADFX4_5;   // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_HEADFX4_7

   (
    sprite: Ord(SPR_FX07);    // sprite
    frame: 6;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_HEADFXI4_2;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_HEADFXI4_1

   (
    sprite: Ord(SPR_FX07);    // sprite
    frame: 5;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_HEADFXI4_3;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_HEADFXI4_2

   (
    sprite: Ord(SPR_FX07);    // sprite
    frame: 4;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_HEADFXI4_4;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_HEADFXI4_3

   (
    sprite: Ord(SPR_FX07);    // sprite
    frame: 3;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_NULL;        // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_HEADFXI4_4

   (
    sprite: Ord(SPR_CLNK);    // sprite
    frame: 0;                 // frame
    tics: 10;                 // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_CLINK_LOOK2;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_CLINK_LOOK1

   (
    sprite: Ord(SPR_CLNK);    // sprite
    frame: 1;                 // frame
    tics: 10;                 // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_CLINK_LOOK1;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_CLINK_LOOK2

   (
    sprite: Ord(SPR_CLNK);    // sprite
    frame: 0;                 // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_CLINK_WALK2;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_CLINK_WALK1

   (
    sprite: Ord(SPR_CLNK);    // sprite
    frame: 1;                 // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_CLINK_WALK3;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_CLINK_WALK2

   (
    sprite: Ord(SPR_CLNK);    // sprite
    frame: 2;                 // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_CLINK_WALK4;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_CLINK_WALK3

   (
    sprite: Ord(SPR_CLNK);    // sprite
    frame: 3;                 // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_CLINK_WALK1;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_CLINK_WALK4

   (
    sprite: Ord(SPR_CLNK);    // sprite
    frame: 4;                 // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_CLINK_ATK2;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_CLINK_ATK1

   (
    sprite: Ord(SPR_CLNK);    // sprite
    frame: 5;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_CLINK_ATK3;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_CLINK_ATK2

   (
    sprite: Ord(SPR_CLNK);    // sprite
    frame: 6;                 // frame
    tics: 7;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_CLINK_WALK1;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_CLINK_ATK3

   (
    sprite: Ord(SPR_CLNK);    // sprite
    frame: 7;                 // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_CLINK_PAIN2;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_CLINK_PAIN1

   (
    sprite: Ord(SPR_CLNK);    // sprite
    frame: 7;                 // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_CLINK_WALK1;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_CLINK_PAIN2

   (
    sprite: Ord(SPR_CLNK);    // sprite
    frame: 8;                 // frame
    tics: 6;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_CLINK_DIE2;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_CLINK_DIE1

   (
    sprite: Ord(SPR_CLNK);    // sprite
    frame: 9;                 // frame
    tics: 6;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_CLINK_DIE3;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_CLINK_DIE2

   (
    sprite: Ord(SPR_CLNK);    // sprite
    frame: 10;                // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_CLINK_DIE4;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_CLINK_DIE3

   (
    sprite: Ord(SPR_CLNK);    // sprite
    frame: 11;                // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_CLINK_DIE5;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_CLINK_DIE4

   (
    sprite: Ord(SPR_CLNK);    // sprite
    frame: 12;                // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_CLINK_DIE6;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_CLINK_DIE5

   (
    sprite: Ord(SPR_CLNK);    // sprite
    frame: 13;                // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_CLINK_DIE7;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_CLINK_DIE6

   (
    sprite: Ord(SPR_CLNK);    // sprite
    frame: 14;                // frame
    tics: -1;                 // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_NULL;        // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_CLINK_DIE7

   (
    sprite: Ord(SPR_WZRD);    // sprite
    frame: 0;                 // frame
    tics: 10;                 // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_WIZARD_LOOK2;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_WIZARD_LOOK1

   (
    sprite: Ord(SPR_WZRD);    // sprite
    frame: 1;                 // frame
    tics: 10;                 // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_WIZARD_LOOK1;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_WIZARD_LOOK2

   (
    sprite: Ord(SPR_WZRD);    // sprite
    frame: 0;                 // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_WIZARD_WALK2;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_WIZARD_WALK1

   (
    sprite: Ord(SPR_WZRD);    // sprite
    frame: 0;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_WIZARD_WALK3;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_WIZARD_WALK2

   (
    sprite: Ord(SPR_WZRD);    // sprite
    frame: 0;                 // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_WIZARD_WALK4;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_WIZARD_WALK3

   (
    sprite: Ord(SPR_WZRD);    // sprite
    frame: 0;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_WIZARD_WALK5;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_WIZARD_WALK4

   (
    sprite: Ord(SPR_WZRD);    // sprite
    frame: 1;                 // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_WIZARD_WALK6;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_WIZARD_WALK5

   (
    sprite: Ord(SPR_WZRD);    // sprite
    frame: 1;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_WIZARD_WALK7;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_WIZARD_WALK6

   (
    sprite: Ord(SPR_WZRD);    // sprite
    frame: 1;                 // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_WIZARD_WALK8;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_WIZARD_WALK7

   (
    sprite: Ord(SPR_WZRD);    // sprite
    frame: 1;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_WIZARD_WALK1;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_WIZARD_WALK8

   (
    sprite: Ord(SPR_WZRD);    // sprite
    frame: 2;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_WIZARD_ATK2;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_WIZARD_ATK1

   (
    sprite: Ord(SPR_WZRD);    // sprite
    frame: 2;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_WIZARD_ATK3;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_WIZARD_ATK2

   (
    sprite: Ord(SPR_WZRD);    // sprite
    frame: 2;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_WIZARD_ATK4;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_WIZARD_ATK3

   (
    sprite: Ord(SPR_WZRD);    // sprite
    frame: 2;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_WIZARD_ATK5;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_WIZARD_ATK4

   (
    sprite: Ord(SPR_WZRD);    // sprite
    frame: 2;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_WIZARD_ATK6;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_WIZARD_ATK5

   (
    sprite: Ord(SPR_WZRD);    // sprite
    frame: 2;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_WIZARD_ATK7;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_WIZARD_ATK6

   (
    sprite: Ord(SPR_WZRD);    // sprite
    frame: 2;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_WIZARD_ATK8;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_WIZARD_ATK7

   (
    sprite: Ord(SPR_WZRD);    // sprite
    frame: 2;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_WIZARD_ATK9;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_WIZARD_ATK8

   (
    sprite: Ord(SPR_WZRD);    // sprite
    frame: 3;                 // frame
    tics: 12;                 // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_WIZARD_WALK1;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_WIZARD_ATK9

   (
    sprite: Ord(SPR_WZRD);    // sprite
    frame: 4;                 // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_WIZARD_PAIN2;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_WIZARD_PAIN1

   (
    sprite: Ord(SPR_WZRD);    // sprite
    frame: 4;                 // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_WIZARD_WALK1;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_WIZARD_PAIN2

   (
    sprite: Ord(SPR_WZRD);    // sprite
    frame: 5;                 // frame
    tics: 6;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_WIZARD_DIE2;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_WIZARD_DIE1

   (
    sprite: Ord(SPR_WZRD);    // sprite
    frame: 6;                 // frame
    tics: 6;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_WIZARD_DIE3;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_WIZARD_DIE2

   (
    sprite: Ord(SPR_WZRD);    // sprite
    frame: 7;                 // frame
    tics: 6;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_WIZARD_DIE4;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_WIZARD_DIE3

   (
    sprite: Ord(SPR_WZRD);    // sprite
    frame: 8;                 // frame
    tics: 6;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_WIZARD_DIE5;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_WIZARD_DIE4

   (
    sprite: Ord(SPR_WZRD);    // sprite
    frame: 9;                 // frame
    tics: 6;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_WIZARD_DIE6;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_WIZARD_DIE5

   (
    sprite: Ord(SPR_WZRD);    // sprite
    frame: 10;                // frame
    tics: 6;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_WIZARD_DIE7;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_WIZARD_DIE6

   (
    sprite: Ord(SPR_WZRD);    // sprite
    frame: 11;                // frame
    tics: 6;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_WIZARD_DIE8;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_WIZARD_DIE7

   (
    sprite: Ord(SPR_WZRD);    // sprite
    frame: 12;                // frame
    tics: -1;                 // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_NULL;        // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_WIZARD_DIE8

   (
    sprite: Ord(SPR_FX11);    // sprite
    frame: 32768;             // frame
    tics: 6;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_WIZFX1_2;    // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_WIZFX1_1

   (
    sprite: Ord(SPR_FX11);    // sprite
    frame: 32769;             // frame
    tics: 6;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_WIZFX1_1;    // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_WIZFX1_2

   (
    sprite: Ord(SPR_FX11);    // sprite
    frame: 32770;             // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_WIZFXI1_2;   // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_WIZFXI1_1

   (
    sprite: Ord(SPR_FX11);    // sprite
    frame: 32771;             // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_WIZFXI1_3;   // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_WIZFXI1_2

   (
    sprite: Ord(SPR_FX11);    // sprite
    frame: 32772;             // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_WIZFXI1_4;   // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_WIZFXI1_3

   (
    sprite: Ord(SPR_FX11);    // sprite
    frame: 32773;             // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_WIZFXI1_5;   // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_WIZFXI1_4

   (
    sprite: Ord(SPR_FX11);    // sprite
    frame: 32774;             // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_NULL;        // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_WIZFXI1_5

   (
    sprite: Ord(SPR_IMPX);    // sprite
    frame: 0;                 // frame
    tics: 10;                 // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_IMP_LOOK2;   // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_IMP_LOOK1

   (
    sprite: Ord(SPR_IMPX);    // sprite
    frame: 1;                 // frame
    tics: 10;                 // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_IMP_LOOK3;   // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_IMP_LOOK2

   (
    sprite: Ord(SPR_IMPX);    // sprite
    frame: 2;                 // frame
    tics: 10;                 // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_IMP_LOOK4;   // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_IMP_LOOK3

   (
    sprite: Ord(SPR_IMPX);    // sprite
    frame: 1;                 // frame
    tics: 10;                 // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_IMP_LOOK1;   // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_IMP_LOOK4

   (
    sprite: Ord(SPR_IMPX);    // sprite
    frame: 0;                 // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_IMP_FLY2;    // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_IMP_FLY1

   (
    sprite: Ord(SPR_IMPX);    // sprite
    frame: 0;                 // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_IMP_FLY3;    // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_IMP_FLY2

   (
    sprite: Ord(SPR_IMPX);    // sprite
    frame: 1;                 // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_IMP_FLY4;    // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_IMP_FLY3

   (
    sprite: Ord(SPR_IMPX);    // sprite
    frame: 1;                 // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_IMP_FLY5;    // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_IMP_FLY4

   (
    sprite: Ord(SPR_IMPX);    // sprite
    frame: 2;                 // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_IMP_FLY6;    // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_IMP_FLY5

   (
    sprite: Ord(SPR_IMPX);    // sprite
    frame: 2;                 // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_IMP_FLY7;    // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_IMP_FLY6

   (
    sprite: Ord(SPR_IMPX);    // sprite
    frame: 1;                 // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_IMP_FLY8;    // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_IMP_FLY7

   (
    sprite: Ord(SPR_IMPX);    // sprite
    frame: 1;                 // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_IMP_FLY1;    // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_IMP_FLY8

   (
    sprite: Ord(SPR_IMPX);    // sprite
    frame: 3;                 // frame
    tics: 6;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_IMP_MEATK2;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_IMP_MEATK1

   (
    sprite: Ord(SPR_IMPX);    // sprite
    frame: 4;                 // frame
    tics: 6;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_IMP_MEATK3;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_IMP_MEATK2

   (
    sprite: Ord(SPR_IMPX);    // sprite
    frame: 5;                 // frame
    tics: 6;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_IMP_FLY1;    // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_IMP_MEATK3

   (
    sprite: Ord(SPR_IMPX);    // sprite
    frame: 0;                 // frame
    tics: 10;                 // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_IMP_MSATK1_2;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_IMP_MSATK1_1

   (
    sprite: Ord(SPR_IMPX);    // sprite
    frame: 1;                 // frame
    tics: 6;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_IMP_MSATK1_3;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_IMP_MSATK1_2

   (
    sprite: Ord(SPR_IMPX);    // sprite
    frame: 2;                 // frame
    tics: 6;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_IMP_MSATK1_4;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_IMP_MSATK1_3

   (
    sprite: Ord(SPR_IMPX);    // sprite
    frame: 1;                 // frame
    tics: 6;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_IMP_MSATK1_5;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_IMP_MSATK1_4

   (
    sprite: Ord(SPR_IMPX);    // sprite
    frame: 0;                 // frame
    tics: 6;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_IMP_MSATK1_6;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_IMP_MSATK1_5

   (
    sprite: Ord(SPR_IMPX);    // sprite
    frame: 1;                 // frame
    tics: 6;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_IMP_MSATK1_3;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_IMP_MSATK1_6

   (
    sprite: Ord(SPR_IMPX);    // sprite
    frame: 3;                 // frame
    tics: 6;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_IMP_MSATK2_2;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_IMP_MSATK2_1

   (
    sprite: Ord(SPR_IMPX);    // sprite
    frame: 4;                 // frame
    tics: 6;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_IMP_MSATK2_3;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_IMP_MSATK2_2

   (
    sprite: Ord(SPR_IMPX);    // sprite
    frame: 5;                 // frame
    tics: 6;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_IMP_FLY1;    // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_IMP_MSATK2_3

   (
    sprite: Ord(SPR_IMPX);    // sprite
    frame: 6;                 // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_IMP_PAIN2;   // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_IMP_PAIN1

   (
    sprite: Ord(SPR_IMPX);    // sprite
    frame: 6;                 // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_IMP_FLY1;    // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_IMP_PAIN2

   (
    sprite: Ord(SPR_IMPX);    // sprite
    frame: 6;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_IMP_DIE2;    // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_IMP_DIE1

   (
    sprite: Ord(SPR_IMPX);    // sprite
    frame: 7;                 // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_IMP_DIE2;    // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_IMP_DIE2

   (
    sprite: Ord(SPR_IMPX);    // sprite
    frame: 18;                // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_IMP_XDIE2;   // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_IMP_XDIE1

   (
    sprite: Ord(SPR_IMPX);    // sprite
    frame: 19;                // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_IMP_XDIE3;   // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_IMP_XDIE2

   (
    sprite: Ord(SPR_IMPX);    // sprite
    frame: 20;                // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_IMP_XDIE4;   // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_IMP_XDIE3

   (
    sprite: Ord(SPR_IMPX);    // sprite
    frame: 21;                // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_IMP_XDIE5;   // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_IMP_XDIE4

   (
    sprite: Ord(SPR_IMPX);    // sprite
    frame: 22;                // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_IMP_XDIE5;   // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_IMP_XDIE5

   (
    sprite: Ord(SPR_IMPX);    // sprite
    frame: 8;                 // frame
    tics: 7;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_IMP_CRASH2;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_IMP_CRASH1

   (
    sprite: Ord(SPR_IMPX);    // sprite
    frame: 9;                 // frame
    tics: 7;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_IMP_CRASH3;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_IMP_CRASH2

   (
    sprite: Ord(SPR_IMPX);    // sprite
    frame: 10;                // frame
    tics: 7;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_IMP_CRASH4;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_IMP_CRASH3

   (
    sprite: Ord(SPR_IMPX);    // sprite
    frame: 11;                // frame
    tics: -1;                 // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_NULL;        // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_IMP_CRASH4

   (
    sprite: Ord(SPR_IMPX);    // sprite
    frame: 23;                // frame
    tics: 7;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_IMP_XCRASH2;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_IMP_XCRASH1

   (
    sprite: Ord(SPR_IMPX);    // sprite
    frame: 24;                // frame
    tics: 7;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_IMP_XCRASH3;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_IMP_XCRASH2

   (
    sprite: Ord(SPR_IMPX);    // sprite
    frame: 25;                // frame
    tics: -1;                 // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_NULL;        // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_IMP_XCRASH3

   (
    sprite: Ord(SPR_IMPX);    // sprite
    frame: 12;                // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_IMP_CHUNKA2;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_IMP_CHUNKA1

   (
    sprite: Ord(SPR_IMPX);    // sprite
    frame: 13;                // frame
    tics: 700;                // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_IMP_CHUNKA3;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_IMP_CHUNKA2

   (
    sprite: Ord(SPR_IMPX);    // sprite
    frame: 14;                // frame
    tics: 700;                // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_NULL;        // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_IMP_CHUNKA3

   (
    sprite: Ord(SPR_IMPX);    // sprite
    frame: 15;                // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_IMP_CHUNKB2;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_IMP_CHUNKB1

   (
    sprite: Ord(SPR_IMPX);    // sprite
    frame: 16;                // frame
    tics: 700;                // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_IMP_CHUNKB3;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_IMP_CHUNKB2

   (
    sprite: Ord(SPR_IMPX);    // sprite
    frame: 17;                // frame
    tics: 700;                // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_NULL;        // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_IMP_CHUNKB3

   (
    sprite: Ord(SPR_FX10);    // sprite
    frame: 32768;             // frame
    tics: 6;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_IMPFX2;      // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_IMPFX1

   (
    sprite: Ord(SPR_FX10);    // sprite
    frame: 32769;             // frame
    tics: 6;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_IMPFX3;      // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_IMPFX2

   (
    sprite: Ord(SPR_FX10);    // sprite
    frame: 32770;             // frame
    tics: 6;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_IMPFX1;      // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_IMPFX3

   (
    sprite: Ord(SPR_FX10);    // sprite
    frame: 32771;             // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_IMPFXI2;     // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_IMPFXI1

   (
    sprite: Ord(SPR_FX10);    // sprite
    frame: 32772;             // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_IMPFXI3;     // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_IMPFXI2

   (
    sprite: Ord(SPR_FX10);    // sprite
    frame: 32773;             // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_IMPFXI4;     // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_IMPFXI3

   (
    sprite: Ord(SPR_FX10);    // sprite
    frame: 32774;             // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_NULL;        // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_IMPFXI4

   (
    sprite: Ord(SPR_KNIG);    // sprite
    frame: 0;                 // frame
    tics: 10;                 // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_KNIGHT_STND2;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_KNIGHT_STND1

   (
    sprite: Ord(SPR_KNIG);    // sprite
    frame: 1;                 // frame
    tics: 10;                 // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_KNIGHT_STND1;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_KNIGHT_STND2

   (
    sprite: Ord(SPR_KNIG);    // sprite
    frame: 0;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_KNIGHT_WALK2;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_KNIGHT_WALK1

   (
    sprite: Ord(SPR_KNIG);    // sprite
    frame: 1;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_KNIGHT_WALK3;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_KNIGHT_WALK2

   (
    sprite: Ord(SPR_KNIG);    // sprite
    frame: 2;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_KNIGHT_WALK4;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_KNIGHT_WALK3

   (
    sprite: Ord(SPR_KNIG);    // sprite
    frame: 3;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_KNIGHT_WALK1;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_KNIGHT_WALK4

   (
    sprite: Ord(SPR_KNIG);    // sprite
    frame: 4;                 // frame
    tics: 10;                 // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_KNIGHT_ATK2;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_KNIGHT_ATK1

   (
    sprite: Ord(SPR_KNIG);    // sprite
    frame: 5;                 // frame
    tics: 8;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_KNIGHT_ATK3;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_KNIGHT_ATK2

   (
    sprite: Ord(SPR_KNIG);    // sprite
    frame: 6;                 // frame
    tics: 8;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_KNIGHT_ATK4;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_KNIGHT_ATK3

   (
    sprite: Ord(SPR_KNIG);    // sprite
    frame: 4;                 // frame
    tics: 10;                 // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_KNIGHT_ATK5;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_KNIGHT_ATK4

   (
    sprite: Ord(SPR_KNIG);    // sprite
    frame: 5;                 // frame
    tics: 8;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_KNIGHT_ATK6;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_KNIGHT_ATK5

   (
    sprite: Ord(SPR_KNIG);    // sprite
    frame: 6;                 // frame
    tics: 8;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_KNIGHT_WALK1;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_KNIGHT_ATK6

   (
    sprite: Ord(SPR_KNIG);    // sprite
    frame: 7;                 // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_KNIGHT_PAIN2;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_KNIGHT_PAIN1

   (
    sprite: Ord(SPR_KNIG);    // sprite
    frame: 7;                 // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_KNIGHT_WALK1;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_KNIGHT_PAIN2

   (
    sprite: Ord(SPR_KNIG);    // sprite
    frame: 8;                 // frame
    tics: 6;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_KNIGHT_DIE2;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_KNIGHT_DIE1

   (
    sprite: Ord(SPR_KNIG);    // sprite
    frame: 9;                 // frame
    tics: 6;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_KNIGHT_DIE3;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_KNIGHT_DIE2

   (
    sprite: Ord(SPR_KNIG);    // sprite
    frame: 10;                // frame
    tics: 6;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_KNIGHT_DIE4;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_KNIGHT_DIE3

   (
    sprite: Ord(SPR_KNIG);    // sprite
    frame: 11;                // frame
    tics: 6;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_KNIGHT_DIE5;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_KNIGHT_DIE4

   (
    sprite: Ord(SPR_KNIG);    // sprite
    frame: 12;                // frame
    tics: 6;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_KNIGHT_DIE6;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_KNIGHT_DIE5

   (
    sprite: Ord(SPR_KNIG);    // sprite
    frame: 13;                // frame
    tics: 6;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_KNIGHT_DIE7;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_KNIGHT_DIE6

   (
    sprite: Ord(SPR_KNIG);    // sprite
    frame: 14;                // frame
    tics: -1;                 // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_NULL;        // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_KNIGHT_DIE7

   (
    sprite: Ord(SPR_SPAX);    // sprite
    frame: 32768;             // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_SPINAXE2;    // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SPINAXE1

   (
    sprite: Ord(SPR_SPAX);    // sprite
    frame: 32769;             // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_SPINAXE3;    // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SPINAXE2

   (
    sprite: Ord(SPR_SPAX);    // sprite
    frame: 32770;             // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_SPINAXE1;    // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SPINAXE3

   (
    sprite: Ord(SPR_SPAX);    // sprite
    frame: 32771;             // frame
    tics: 6;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_SPINAXEX2;   // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SPINAXEX1

   (
    sprite: Ord(SPR_SPAX);    // sprite
    frame: 32772;             // frame
    tics: 6;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_SPINAXEX3;   // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SPINAXEX2

   (
    sprite: Ord(SPR_SPAX);    // sprite
    frame: 32773;             // frame
    tics: 6;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_NULL;        // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SPINAXEX3

   (
    sprite: Ord(SPR_RAXE);    // sprite
    frame: 32768;             // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_REDAXE2;     // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_REDAXE1

   (
    sprite: Ord(SPR_RAXE);    // sprite
    frame: 32769;             // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_REDAXE1;     // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_REDAXE2

   (
    sprite: Ord(SPR_RAXE);    // sprite
    frame: 32770;             // frame
    tics: 6;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_REDAXEX2;    // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_REDAXEX1

   (
    sprite: Ord(SPR_RAXE);    // sprite
    frame: 32771;             // frame
    tics: 6;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_REDAXEX3;    // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_REDAXEX2

   (
    sprite: Ord(SPR_RAXE);    // sprite
    frame: 32772;             // frame
    tics: 6;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_NULL;        // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_REDAXEX3

   (
    sprite: Ord(SPR_SRCR);    // sprite
    frame: 0;                 // frame
    tics: 10;                 // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_SRCR1_LOOK2;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SRCR1_LOOK1

   (
    sprite: Ord(SPR_SRCR);    // sprite
    frame: 1;                 // frame
    tics: 10;                 // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_SRCR1_LOOK1;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SRCR1_LOOK2

   (
    sprite: Ord(SPR_SRCR);    // sprite
    frame: 0;                 // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_SRCR1_WALK2;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SRCR1_WALK1

   (
    sprite: Ord(SPR_SRCR);    // sprite
    frame: 1;                 // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_SRCR1_WALK3;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SRCR1_WALK2

   (
    sprite: Ord(SPR_SRCR);    // sprite
    frame: 2;                 // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_SRCR1_WALK4;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SRCR1_WALK3

   (
    sprite: Ord(SPR_SRCR);    // sprite
    frame: 3;                 // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_SRCR1_WALK1;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SRCR1_WALK4

   (
    sprite: Ord(SPR_SRCR);    // sprite
    frame: 16;                // frame
    tics: 6;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_SRCR1_WALK1;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SRCR1_PAIN1

   (
    sprite: Ord(SPR_SRCR);    // sprite
    frame: 16;                // frame
    tics: 7;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_SRCR1_ATK2;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SRCR1_ATK1

   (
    sprite: Ord(SPR_SRCR);    // sprite
    frame: 17;                // frame
    tics: 6;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_SRCR1_ATK3;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SRCR1_ATK2

   (
    sprite: Ord(SPR_SRCR);    // sprite
    frame: 18;                // frame
    tics: 10;                 // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_SRCR1_WALK1;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SRCR1_ATK3

   (
    sprite: Ord(SPR_SRCR);    // sprite
    frame: 18;                // frame
    tics: 10;                 // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_SRCR1_ATK5;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SRCR1_ATK4

   (
    sprite: Ord(SPR_SRCR);    // sprite
    frame: 16;                // frame
    tics: 7;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_SRCR1_ATK6;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SRCR1_ATK5

   (
    sprite: Ord(SPR_SRCR);    // sprite
    frame: 17;                // frame
    tics: 6;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_SRCR1_ATK7;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SRCR1_ATK6

   (
    sprite: Ord(SPR_SRCR);    // sprite
    frame: 18;                // frame
    tics: 10;                 // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_SRCR1_WALK1;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SRCR1_ATK7

   (
    sprite: Ord(SPR_SRCR);    // sprite
    frame: 4;                 // frame
    tics: 7;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_SRCR1_DIE2;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SRCR1_DIE1

   (
    sprite: Ord(SPR_SRCR);    // sprite
    frame: 5;                 // frame
    tics: 7;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_SRCR1_DIE3;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SRCR1_DIE2

   (
    sprite: Ord(SPR_SRCR);    // sprite
    frame: 6;                 // frame
    tics: 7;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_SRCR1_DIE4;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SRCR1_DIE3

   (
    sprite: Ord(SPR_SRCR);    // sprite
    frame: 7;                 // frame
    tics: 6;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_SRCR1_DIE5;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SRCR1_DIE4

   (
    sprite: Ord(SPR_SRCR);    // sprite
    frame: 8;                 // frame
    tics: 6;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_SRCR1_DIE6;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SRCR1_DIE5

   (
    sprite: Ord(SPR_SRCR);    // sprite
    frame: 9;                 // frame
    tics: 6;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_SRCR1_DIE7;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SRCR1_DIE6

   (
    sprite: Ord(SPR_SRCR);    // sprite
    frame: 10;                // frame
    tics: 6;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_SRCR1_DIE8;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SRCR1_DIE7

   (
    sprite: Ord(SPR_SRCR);    // sprite
    frame: 11;                // frame
    tics: 25;                 // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_SRCR1_DIE9;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SRCR1_DIE8

   (
    sprite: Ord(SPR_SRCR);    // sprite
    frame: 12;                // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_SRCR1_DIE10;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SRCR1_DIE9

   (
    sprite: Ord(SPR_SRCR);    // sprite
    frame: 13;                // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_SRCR1_DIE11;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SRCR1_DIE10

   (
    sprite: Ord(SPR_SRCR);    // sprite
    frame: 14;                // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_SRCR1_DIE12;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SRCR1_DIE11

   (
    sprite: Ord(SPR_SRCR);    // sprite
    frame: 11;                // frame
    tics: 20;                 // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_SRCR1_DIE13;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SRCR1_DIE12

   (
    sprite: Ord(SPR_SRCR);    // sprite
    frame: 12;                // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_SRCR1_DIE14;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SRCR1_DIE13

   (
    sprite: Ord(SPR_SRCR);    // sprite
    frame: 13;                // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_SRCR1_DIE15;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SRCR1_DIE14

   (
    sprite: Ord(SPR_SRCR);    // sprite
    frame: 14;                // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_SRCR1_DIE16;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SRCR1_DIE15

   (
    sprite: Ord(SPR_SRCR);    // sprite
    frame: 11;                // frame
    tics: 12;                 // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_SRCR1_DIE17;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SRCR1_DIE16

   (
    sprite: Ord(SPR_SRCR);    // sprite
    frame: 15;                // frame
    tics: -1;                 // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_NULL;        // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SRCR1_DIE17

   (
    sprite: Ord(SPR_FX14);    // sprite
    frame: 32768;             // frame
    tics: 6;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_SRCRFX1_2;   // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SRCRFX1_1

   (
    sprite: Ord(SPR_FX14);    // sprite
    frame: 32769;             // frame
    tics: 6;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_SRCRFX1_3;   // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SRCRFX1_2

   (
    sprite: Ord(SPR_FX14);    // sprite
    frame: 32770;             // frame
    tics: 6;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_SRCRFX1_1;   // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SRCRFX1_3

   (
    sprite: Ord(SPR_FX14);    // sprite
    frame: 32771;             // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_SRCRFXI1_2;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SRCRFXI1_1

   (
    sprite: Ord(SPR_FX14);    // sprite
    frame: 32772;             // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_SRCRFXI1_3;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SRCRFXI1_2

   (
    sprite: Ord(SPR_FX14);    // sprite
    frame: 32773;             // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_SRCRFXI1_4;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SRCRFXI1_3

   (
    sprite: Ord(SPR_FX14);    // sprite
    frame: 32774;             // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_SRCRFXI1_5;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SRCRFXI1_4

   (
    sprite: Ord(SPR_FX14);    // sprite
    frame: 32775;             // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_NULL;        // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SRCRFXI1_5

   (
    sprite: Ord(SPR_SOR2);    // sprite
    frame: 0;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_SOR2_RISE2;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SOR2_RISE1

   (
    sprite: Ord(SPR_SOR2);    // sprite
    frame: 1;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_SOR2_RISE3;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SOR2_RISE2

   (
    sprite: Ord(SPR_SOR2);    // sprite
    frame: 2;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_SOR2_RISE4;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SOR2_RISE3

   (
    sprite: Ord(SPR_SOR2);    // sprite
    frame: 3;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_SOR2_RISE5;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SOR2_RISE4

   (
    sprite: Ord(SPR_SOR2);    // sprite
    frame: 4;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_SOR2_RISE6;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SOR2_RISE5

   (
    sprite: Ord(SPR_SOR2);    // sprite
    frame: 5;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_SOR2_RISE7;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SOR2_RISE6

   (
    sprite: Ord(SPR_SOR2);    // sprite
    frame: 6;                 // frame
    tics: 12;                 // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_SOR2_WALK1;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SOR2_RISE7

   (
    sprite: Ord(SPR_SOR2);    // sprite
    frame: 12;                // frame
    tics: 10;                 // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_SOR2_LOOK2;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SOR2_LOOK1

   (
    sprite: Ord(SPR_SOR2);    // sprite
    frame: 13;                // frame
    tics: 10;                 // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_SOR2_LOOK1;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SOR2_LOOK2

   (
    sprite: Ord(SPR_SOR2);    // sprite
    frame: 12;                // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_SOR2_WALK2;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SOR2_WALK1

   (
    sprite: Ord(SPR_SOR2);    // sprite
    frame: 13;                // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_SOR2_WALK3;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SOR2_WALK2

   (
    sprite: Ord(SPR_SOR2);    // sprite
    frame: 14;                // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_SOR2_WALK4;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SOR2_WALK3

   (
    sprite: Ord(SPR_SOR2);    // sprite
    frame: 15;                // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_SOR2_WALK1;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SOR2_WALK4

   (
    sprite: Ord(SPR_SOR2);    // sprite
    frame: 16;                // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_SOR2_PAIN2;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SOR2_PAIN1

   (
    sprite: Ord(SPR_SOR2);    // sprite
    frame: 16;                // frame
    tics: 6;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_SOR2_WALK1;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SOR2_PAIN2

   (
    sprite: Ord(SPR_SOR2);    // sprite
    frame: 17;                // frame
    tics: 9;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_SOR2_ATK2;   // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SOR2_ATK1

   (
    sprite: Ord(SPR_SOR2);    // sprite
    frame: 18;                // frame
    tics: 9;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_SOR2_ATK3;   // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SOR2_ATK2

   (
    sprite: Ord(SPR_SOR2);    // sprite
    frame: 19;                // frame
    tics: 20;                 // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_SOR2_WALK1;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SOR2_ATK3

   (
    sprite: Ord(SPR_SOR2);    // sprite
    frame: 11;                // frame
    tics: 6;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_SOR2_TELE2;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SOR2_TELE1

   (
    sprite: Ord(SPR_SOR2);    // sprite
    frame: 10;                // frame
    tics: 6;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_SOR2_TELE3;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SOR2_TELE2

   (
    sprite: Ord(SPR_SOR2);    // sprite
    frame: 9;                 // frame
    tics: 6;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_SOR2_TELE4;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SOR2_TELE3

   (
    sprite: Ord(SPR_SOR2);    // sprite
    frame: 8;                 // frame
    tics: 6;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_SOR2_TELE5;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SOR2_TELE4

   (
    sprite: Ord(SPR_SOR2);    // sprite
    frame: 7;                 // frame
    tics: 6;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_SOR2_TELE6;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SOR2_TELE5

   (
    sprite: Ord(SPR_SOR2);    // sprite
    frame: 6;                 // frame
    tics: 6;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_SOR2_WALK1;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SOR2_TELE6

   (
    sprite: Ord(SPR_SDTH);    // sprite
    frame: 0;                 // frame
    tics: 8;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_SOR2_DIE2;   // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SOR2_DIE1

   (
    sprite: Ord(SPR_SDTH);    // sprite
    frame: 1;                 // frame
    tics: 8;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_SOR2_DIE3;   // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SOR2_DIE2

   (
    sprite: Ord(SPR_SDTH);    // sprite
    frame: 2;                 // frame
    tics: 8;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_SOR2_DIE4;   // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SOR2_DIE3

   (
    sprite: Ord(SPR_SDTH);    // sprite
    frame: 3;                 // frame
    tics: 7;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_SOR2_DIE5;   // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SOR2_DIE4

   (
    sprite: Ord(SPR_SDTH);    // sprite
    frame: 4;                 // frame
    tics: 7;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_SOR2_DIE6;   // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SOR2_DIE5

   (
    sprite: Ord(SPR_SDTH);    // sprite
    frame: 5;                 // frame
    tics: 7;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_SOR2_DIE7;   // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SOR2_DIE6

   (
    sprite: Ord(SPR_SDTH);    // sprite
    frame: 6;                 // frame
    tics: 6;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_SOR2_DIE8;   // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SOR2_DIE7

   (
    sprite: Ord(SPR_SDTH);    // sprite
    frame: 7;                 // frame
    tics: 6;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_SOR2_DIE9;   // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SOR2_DIE8

   (
    sprite: Ord(SPR_SDTH);    // sprite
    frame: 8;                 // frame
    tics: 18;                 // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_SOR2_DIE10;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SOR2_DIE9

   (
    sprite: Ord(SPR_SDTH);    // sprite
    frame: 9;                 // frame
    tics: 6;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_SOR2_DIE11;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SOR2_DIE10

   (
    sprite: Ord(SPR_SDTH);    // sprite
    frame: 10;                // frame
    tics: 6;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_SOR2_DIE12;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SOR2_DIE11

   (
    sprite: Ord(SPR_SDTH);    // sprite
    frame: 11;                // frame
    tics: 6;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_SOR2_DIE13;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SOR2_DIE12

   (
    sprite: Ord(SPR_SDTH);    // sprite
    frame: 12;                // frame
    tics: 6;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_SOR2_DIE14;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SOR2_DIE13

   (
    sprite: Ord(SPR_SDTH);    // sprite
    frame: 13;                // frame
    tics: 6;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_SOR2_DIE15;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SOR2_DIE14

   (
    sprite: Ord(SPR_SDTH);    // sprite
    frame: 14;                // frame
    tics: -1;                 // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_NULL;        // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SOR2_DIE15

   (
    sprite: Ord(SPR_FX16);    // sprite
    frame: 32768;             // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_SOR2FX1_2;   // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SOR2FX1_1

   (
    sprite: Ord(SPR_FX16);    // sprite
    frame: 32769;             // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_SOR2FX1_3;   // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SOR2FX1_2

   (
    sprite: Ord(SPR_FX16);    // sprite
    frame: 32770;             // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_SOR2FX1_1;   // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SOR2FX1_3

   (
    sprite: Ord(SPR_FX16);    // sprite
    frame: 32774;             // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_SOR2FXI1_2;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SOR2FXI1_1

   (
    sprite: Ord(SPR_FX16);    // sprite
    frame: 32775;             // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_SOR2FXI1_3;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SOR2FXI1_2

   (
    sprite: Ord(SPR_FX16);    // sprite
    frame: 32776;             // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_SOR2FXI1_4;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SOR2FXI1_3

   (
    sprite: Ord(SPR_FX16);    // sprite
    frame: 32777;             // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_SOR2FXI1_5;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SOR2FXI1_4

   (
    sprite: Ord(SPR_FX16);    // sprite
    frame: 32778;             // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_SOR2FXI1_6;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SOR2FXI1_5

   (
    sprite: Ord(SPR_FX16);    // sprite
    frame: 32779;             // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_NULL;        // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SOR2FXI1_6

   (
    sprite: Ord(SPR_FX16);    // sprite
    frame: 32771;             // frame
    tics: 12;                 // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_SOR2FXSPARK2;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SOR2FXSPARK1

   (
    sprite: Ord(SPR_FX16);    // sprite
    frame: 32772;             // frame
    tics: 12;                 // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_SOR2FXSPARK3;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SOR2FXSPARK2

   (
    sprite: Ord(SPR_FX16);    // sprite
    frame: 32773;             // frame
    tics: 12;                 // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_NULL;        // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SOR2FXSPARK3

   (
    sprite: Ord(SPR_FX11);    // sprite
    frame: 32768;             // frame
    tics: 35;                 // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_SOR2FX2_2;   // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SOR2FX2_1

   (
    sprite: Ord(SPR_FX11);    // sprite
    frame: 32768;             // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_SOR2FX2_3;   // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SOR2FX2_2

   (
    sprite: Ord(SPR_FX11);    // sprite
    frame: 32769;             // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_SOR2FX2_2;   // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SOR2FX2_3

   (
    sprite: Ord(SPR_FX11);    // sprite
    frame: 32770;             // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_SOR2FXI2_2;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SOR2FXI2_1

   (
    sprite: Ord(SPR_FX11);    // sprite
    frame: 32771;             // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_SOR2FXI2_3;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SOR2FXI2_2

   (
    sprite: Ord(SPR_FX11);    // sprite
    frame: 32772;             // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_SOR2FXI2_4;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SOR2FXI2_3

   (
    sprite: Ord(SPR_FX11);    // sprite
    frame: 32773;             // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_SOR2FXI2_5;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SOR2FXI2_4

   (
    sprite: Ord(SPR_FX11);    // sprite
    frame: 32774;             // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_NULL;        // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SOR2FXI2_5

   (
    sprite: Ord(SPR_SOR2);    // sprite
    frame: 6;                 // frame
    tics: 8;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_SOR2TELEFADE2;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SOR2TELEFADE1

   (
    sprite: Ord(SPR_SOR2);    // sprite
    frame: 7;                 // frame
    tics: 6;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_SOR2TELEFADE3;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SOR2TELEFADE2

   (
    sprite: Ord(SPR_SOR2);    // sprite
    frame: 8;                 // frame
    tics: 6;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_SOR2TELEFADE4;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SOR2TELEFADE3

   (
    sprite: Ord(SPR_SOR2);    // sprite
    frame: 9;                 // frame
    tics: 6;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_SOR2TELEFADE5;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SOR2TELEFADE4

   (
    sprite: Ord(SPR_SOR2);    // sprite
    frame: 10;                // frame
    tics: 6;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_SOR2TELEFADE6;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SOR2TELEFADE5

   (
    sprite: Ord(SPR_SOR2);    // sprite
    frame: 11;                // frame
    tics: 6;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_NULL;        // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SOR2TELEFADE6

   (
    sprite: Ord(SPR_MNTR);    // sprite
    frame: 0;                 // frame
    tics: 10;                 // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_MNTR_LOOK2;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_MNTR_LOOK1

   (
    sprite: Ord(SPR_MNTR);    // sprite
    frame: 1;                 // frame
    tics: 10;                 // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_MNTR_LOOK1;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_MNTR_LOOK2

   (
    sprite: Ord(SPR_MNTR);    // sprite
    frame: 0;                 // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_MNTR_WALK2;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_MNTR_WALK1

   (
    sprite: Ord(SPR_MNTR);    // sprite
    frame: 1;                 // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_MNTR_WALK3;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_MNTR_WALK2

   (
    sprite: Ord(SPR_MNTR);    // sprite
    frame: 2;                 // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_MNTR_WALK4;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_MNTR_WALK3

   (
    sprite: Ord(SPR_MNTR);    // sprite
    frame: 3;                 // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_MNTR_WALK1;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_MNTR_WALK4

   (
    sprite: Ord(SPR_MNTR);    // sprite
    frame: 21;                // frame
    tics: 10;                 // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_MNTR_ATK1_2;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_MNTR_ATK1_1

   (
    sprite: Ord(SPR_MNTR);    // sprite
    frame: 22;                // frame
    tics: 7;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_MNTR_ATK1_3;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_MNTR_ATK1_2

   (
    sprite: Ord(SPR_MNTR);    // sprite
    frame: 23;                // frame
    tics: 12;                 // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_MNTR_WALK1;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_MNTR_ATK1_3

   (
    sprite: Ord(SPR_MNTR);    // sprite
    frame: 21;                // frame
    tics: 10;                 // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_MNTR_ATK2_2;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_MNTR_ATK2_1

   (
    sprite: Ord(SPR_MNTR);    // sprite
    frame: 24;                // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_MNTR_ATK2_3;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_MNTR_ATK2_2

   (
    sprite: Ord(SPR_MNTR);    // sprite
    frame: 25;                // frame
    tics: 9;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_MNTR_WALK1;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_MNTR_ATK2_3

   (
    sprite: Ord(SPR_MNTR);    // sprite
    frame: 21;                // frame
    tics: 10;                 // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_MNTR_ATK3_2;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_MNTR_ATK3_1

   (
    sprite: Ord(SPR_MNTR);    // sprite
    frame: 22;                // frame
    tics: 7;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_MNTR_ATK3_3;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_MNTR_ATK3_2

   (
    sprite: Ord(SPR_MNTR);    // sprite
    frame: 23;                // frame
    tics: 12;                 // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_MNTR_WALK1;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_MNTR_ATK3_3

   (
    sprite: Ord(SPR_MNTR);    // sprite
    frame: 23;                // frame
    tics: 12;                 // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_MNTR_ATK3_1;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_MNTR_ATK3_4

   (
    sprite: Ord(SPR_MNTR);    // sprite
    frame: 20;                // frame
    tics: 2;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_MNTR_ATK4_1;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_MNTR_ATK4_1

   (
    sprite: Ord(SPR_MNTR);    // sprite
    frame: 4;                 // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_MNTR_PAIN2;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_MNTR_PAIN1

   (
    sprite: Ord(SPR_MNTR);    // sprite
    frame: 4;                 // frame
    tics: 6;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_MNTR_WALK1;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_MNTR_PAIN2

   (
    sprite: Ord(SPR_MNTR);    // sprite
    frame: 5;                 // frame
    tics: 6;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_MNTR_DIE2;   // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_MNTR_DIE1

   (
    sprite: Ord(SPR_MNTR);    // sprite
    frame: 6;                 // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_MNTR_DIE3;   // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_MNTR_DIE2

   (
    sprite: Ord(SPR_MNTR);    // sprite
    frame: 7;                 // frame
    tics: 6;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_MNTR_DIE4;   // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_MNTR_DIE3

   (
    sprite: Ord(SPR_MNTR);    // sprite
    frame: 8;                 // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_MNTR_DIE5;   // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_MNTR_DIE4

   (
    sprite: Ord(SPR_MNTR);    // sprite
    frame: 9;                 // frame
    tics: 6;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_MNTR_DIE6;   // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_MNTR_DIE5

   (
    sprite: Ord(SPR_MNTR);    // sprite
    frame: 10;                // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_MNTR_DIE7;   // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_MNTR_DIE6

   (
    sprite: Ord(SPR_MNTR);    // sprite
    frame: 11;                // frame
    tics: 6;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_MNTR_DIE8;   // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_MNTR_DIE7

   (
    sprite: Ord(SPR_MNTR);    // sprite
    frame: 12;                // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_MNTR_DIE9;   // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_MNTR_DIE8

   (
    sprite: Ord(SPR_MNTR);    // sprite
    frame: 13;                // frame
    tics: 6;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_MNTR_DIE10;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_MNTR_DIE9

   (
    sprite: Ord(SPR_MNTR);    // sprite
    frame: 14;                // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_MNTR_DIE11;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_MNTR_DIE10

   (
    sprite: Ord(SPR_MNTR);    // sprite
    frame: 15;                // frame
    tics: 6;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_MNTR_DIE12;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_MNTR_DIE11

   (
    sprite: Ord(SPR_MNTR);    // sprite
    frame: 16;                // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_MNTR_DIE13;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_MNTR_DIE12

   (
    sprite: Ord(SPR_MNTR);    // sprite
    frame: 17;                // frame
    tics: 6;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_MNTR_DIE14;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_MNTR_DIE13

   (
    sprite: Ord(SPR_MNTR);    // sprite
    frame: 18;                // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_MNTR_DIE15;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_MNTR_DIE14

   (
    sprite: Ord(SPR_MNTR);    // sprite
    frame: 19;                // frame
    tics: -1;                 // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_NULL;        // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_MNTR_DIE15

   (
    sprite: Ord(SPR_FX12);    // sprite
    frame: 32768;             // frame
    tics: 6;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_MNTRFX1_2;   // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_MNTRFX1_1

   (
    sprite: Ord(SPR_FX12);    // sprite
    frame: 32769;             // frame
    tics: 6;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_MNTRFX1_1;   // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_MNTRFX1_2

   (
    sprite: Ord(SPR_FX12);    // sprite
    frame: 32770;             // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_MNTRFXI1_2;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_MNTRFXI1_1

   (
    sprite: Ord(SPR_FX12);    // sprite
    frame: 32771;             // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_MNTRFXI1_3;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_MNTRFXI1_2

   (
    sprite: Ord(SPR_FX12);    // sprite
    frame: 32772;             // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_MNTRFXI1_4;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_MNTRFXI1_3

   (
    sprite: Ord(SPR_FX12);    // sprite
    frame: 32773;             // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_MNTRFXI1_5;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_MNTRFXI1_4

   (
    sprite: Ord(SPR_FX12);    // sprite
    frame: 32774;             // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_MNTRFXI1_6;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_MNTRFXI1_5

   (
    sprite: Ord(SPR_FX12);    // sprite
    frame: 32775;             // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_NULL;        // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_MNTRFXI1_6

   (
    sprite: Ord(SPR_FX13);    // sprite
    frame: 0;                 // frame
    tics: 2;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_MNTRFX2_1;   // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_MNTRFX2_1

   (
    sprite: Ord(SPR_FX13);    // sprite
    frame: 32776;             // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_MNTRFXI2_2;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_MNTRFXI2_1

   (
    sprite: Ord(SPR_FX13);    // sprite
    frame: 32777;             // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_MNTRFXI2_3;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_MNTRFXI2_2

   (
    sprite: Ord(SPR_FX13);    // sprite
    frame: 32778;             // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_MNTRFXI2_4;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_MNTRFXI2_3

   (
    sprite: Ord(SPR_FX13);    // sprite
    frame: 32779;             // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_MNTRFXI2_5;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_MNTRFXI2_4

   (
    sprite: Ord(SPR_FX13);    // sprite
    frame: 32780;             // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_NULL;        // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_MNTRFXI2_5

   (
    sprite: Ord(SPR_FX13);    // sprite
    frame: 32771;             // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_MNTRFX3_2;   // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_MNTRFX3_1

   (
    sprite: Ord(SPR_FX13);    // sprite
    frame: 32770;             // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_MNTRFX3_3;   // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_MNTRFX3_2

   (
    sprite: Ord(SPR_FX13);    // sprite
    frame: 32769;             // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_MNTRFX3_4;   // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_MNTRFX3_3

   (
    sprite: Ord(SPR_FX13);    // sprite
    frame: 32770;             // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_MNTRFX3_5;   // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_MNTRFX3_4

   (
    sprite: Ord(SPR_FX13);    // sprite
    frame: 32771;             // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_MNTRFX3_6;   // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_MNTRFX3_5

   (
    sprite: Ord(SPR_FX13);    // sprite
    frame: 32772;             // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_MNTRFX3_7;   // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_MNTRFX3_6

   (
    sprite: Ord(SPR_FX13);    // sprite
    frame: 32773;             // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_MNTRFX3_8;   // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_MNTRFX3_7

   (
    sprite: Ord(SPR_FX13);    // sprite
    frame: 32774;             // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_MNTRFX3_9;   // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_MNTRFX3_8

   (
    sprite: Ord(SPR_FX13);    // sprite
    frame: 32775;             // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_NULL;        // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_MNTRFX3_9

   (
    sprite: Ord(SPR_AKYY);    // sprite
    frame: 32768;             // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_AKYY2;       // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_AKYY1

   (
    sprite: Ord(SPR_AKYY);    // sprite
    frame: 32769;             // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_AKYY3;       // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_AKYY2

   (
    sprite: Ord(SPR_AKYY);    // sprite
    frame: 32770;             // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_AKYY4;       // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_AKYY3

   (
    sprite: Ord(SPR_AKYY);    // sprite
    frame: 32771;             // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_AKYY5;       // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_AKYY4

   (
    sprite: Ord(SPR_AKYY);    // sprite
    frame: 32772;             // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_AKYY6;       // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_AKYY5

   (
    sprite: Ord(SPR_AKYY);    // sprite
    frame: 32773;             // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_AKYY7;       // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_AKYY6

   (
    sprite: Ord(SPR_AKYY);    // sprite
    frame: 32774;             // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_AKYY8;       // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_AKYY7

   (
    sprite: Ord(SPR_AKYY);    // sprite
    frame: 32775;             // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_AKYY9;       // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_AKYY8

   (
    sprite: Ord(SPR_AKYY);    // sprite
    frame: 32776;             // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_AKYY10;      // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_AKYY9

   (
    sprite: Ord(SPR_AKYY);    // sprite
    frame: 32777;             // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_AKYY1;       // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_AKYY10

   (
    sprite: Ord(SPR_BKYY);    // sprite
    frame: 32768;             // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_BKYY2;       // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_BKYY1

   (
    sprite: Ord(SPR_BKYY);    // sprite
    frame: 32769;             // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_BKYY3;       // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_BKYY2

   (
    sprite: Ord(SPR_BKYY);    // sprite
    frame: 32770;             // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_BKYY4;       // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_BKYY3

   (
    sprite: Ord(SPR_BKYY);    // sprite
    frame: 32771;             // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_BKYY5;       // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_BKYY4

   (
    sprite: Ord(SPR_BKYY);    // sprite
    frame: 32772;             // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_BKYY6;       // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_BKYY5

   (
    sprite: Ord(SPR_BKYY);    // sprite
    frame: 32773;             // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_BKYY7;       // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_BKYY6

   (
    sprite: Ord(SPR_BKYY);    // sprite
    frame: 32774;             // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_BKYY8;       // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_BKYY7

   (
    sprite: Ord(SPR_BKYY);    // sprite
    frame: 32775;             // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_BKYY9;       // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_BKYY8

   (
    sprite: Ord(SPR_BKYY);    // sprite
    frame: 32776;             // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_BKYY10;      // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_BKYY9

   (
    sprite: Ord(SPR_BKYY);    // sprite
    frame: 32777;             // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_BKYY1;       // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_BKYY10

   (
    sprite: Ord(SPR_CKYY);    // sprite
    frame: 32768;             // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_CKYY2;       // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_CKYY1

   (
    sprite: Ord(SPR_CKYY);    // sprite
    frame: 32769;             // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_CKYY3;       // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_CKYY2

   (
    sprite: Ord(SPR_CKYY);    // sprite
    frame: 32770;             // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_CKYY4;       // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_CKYY3

   (
    sprite: Ord(SPR_CKYY);    // sprite
    frame: 32771;             // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_CKYY5;       // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_CKYY4

   (
    sprite: Ord(SPR_CKYY);    // sprite
    frame: 32772;             // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_CKYY6;       // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_CKYY5

   (
    sprite: Ord(SPR_CKYY);    // sprite
    frame: 32773;             // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_CKYY7;       // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_CKYY6

   (
    sprite: Ord(SPR_CKYY);    // sprite
    frame: 32774;             // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_CKYY8;       // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_CKYY7

   (
    sprite: Ord(SPR_CKYY);    // sprite
    frame: 32775;             // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_CKYY9;       // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_CKYY8

   (
    sprite: Ord(SPR_CKYY);    // sprite
    frame: 32776;             // frame
    tics: 3;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_CKYY1;       // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_CKYY9

   (
    sprite: Ord(SPR_AMG1);    // sprite
    frame: 0;                 // frame
    tics: -1;                 // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_NULL;        // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_AMG1

   (
    sprite: Ord(SPR_AMG2);    // sprite
    frame: 0;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_AMG2_2;      // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_AMG2_1

   (
    sprite: Ord(SPR_AMG2);    // sprite
    frame: 1;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_AMG2_3;      // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_AMG2_2

   (
    sprite: Ord(SPR_AMG2);    // sprite
    frame: 2;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_AMG2_1;      // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_AMG2_3

   (
    sprite: Ord(SPR_AMM1);    // sprite
    frame: 0;                 // frame
    tics: -1;                 // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_NULL;        // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_AMM1

   (
    sprite: Ord(SPR_AMM2);    // sprite
    frame: 0;                 // frame
    tics: -1;                 // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_NULL;        // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_AMM2

   (
    sprite: Ord(SPR_AMC1);    // sprite
    frame: 0;                 // frame
    tics: -1;                 // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_NULL;        // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_AMC1

   (
    sprite: Ord(SPR_AMC2);    // sprite
    frame: 0;                 // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_AMC2_2;      // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_AMC2_1

   (
    sprite: Ord(SPR_AMC2);    // sprite
    frame: 1;                 // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_AMC2_3;      // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_AMC2_2

   (
    sprite: Ord(SPR_AMC2);    // sprite
    frame: 2;                 // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_AMC2_1;      // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_AMC2_3

   (
    sprite: Ord(SPR_AMS1);    // sprite
    frame: 0;                 // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_AMS1_2;      // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_AMS1_1

   (
    sprite: Ord(SPR_AMS1);    // sprite
    frame: 1;                 // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_AMS1_1;      // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_AMS1_2

   (
    sprite: Ord(SPR_AMS2);    // sprite
    frame: 0;                 // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_AMS2_2;      // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_AMS2_1

   (
    sprite: Ord(SPR_AMS2);    // sprite
    frame: 1;                 // frame
    tics: 5;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_AMS2_1;      // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_AMS2_2

   (
    sprite: Ord(SPR_AMP1);    // sprite
    frame: 0;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_AMP1_2;      // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_AMP1_1

   (
    sprite: Ord(SPR_AMP1);    // sprite
    frame: 1;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_AMP1_3;      // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_AMP1_2

   (
    sprite: Ord(SPR_AMP1);    // sprite
    frame: 2;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_AMP1_1;      // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_AMP1_3

   (
    sprite: Ord(SPR_AMP2);    // sprite
    frame: 0;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_AMP2_2;      // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_AMP2_1

   (
    sprite: Ord(SPR_AMP2);    // sprite
    frame: 1;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_AMP2_3;      // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_AMP2_2

   (
    sprite: Ord(SPR_AMP2);    // sprite
    frame: 2;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_AMP2_1;      // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_AMP2_3

   (
    sprite: Ord(SPR_AMB1);    // sprite
    frame: 0;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_AMB1_2;      // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_AMB1_1

   (
    sprite: Ord(SPR_AMB1);    // sprite
    frame: 1;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_AMB1_3;      // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_AMB1_2

   (
    sprite: Ord(SPR_AMB1);    // sprite
    frame: 2;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_AMB1_1;      // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_AMB1_3

   (
    sprite: Ord(SPR_AMB2);    // sprite
    frame: 0;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_AMB2_2;      // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_AMB2_1

   (
    sprite: Ord(SPR_AMB2);    // sprite
    frame: 1;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_AMB2_3;      // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_AMB2_2

   (
    sprite: Ord(SPR_AMB2);    // sprite
    frame: 2;                 // frame
    tics: 4;                  // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_AMB2_1;      // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_AMB2_3

   (
    sprite: Ord(SPR_AMG1);    // sprite
    frame: 0;                 // frame
    tics: 100;                // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_SND_WIND;    // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   ),                         // S_SND_WIND

   (
    sprite: Ord(SPR_AMG1);    // sprite
    frame: 0;                 // frame
    tics: 85;                 // tics
    action: (acp1: nil);      // action, will be set after
    nextstate: S_SND_WATERFALL;  // nextstate
    misc1: 0;                 // misc1
    misc2: 0;                 // misc2
    flags_ex: 0;              // flags_ex
   )                          // S_SND_WATERFALL

  );

const // Doom Original Sprite Names
  DO_sprnames: array[0..Ord(DO_NUMSPRITES)] of string[4] = (
    'IMPX', 'ACLO', 'PTN1', 'SHLD', 'SHD2', 'BAGH', 'SPMP', 'INVS', 'PTN2', 'SOAR',
    'INVU', 'PWBK', 'EGGC', 'EGGM', 'FX01', 'SPHL', 'TRCH', 'FBMB', 'XPL1', 'ATLP',
    'PPOD', 'AMG1', 'SPSH', 'LVAS', 'SLDG', 'SKH1', 'SKH2', 'SKH3', 'SKH4', 'CHDL',
    'SRTC', 'SMPL', 'STGS', 'STGL', 'STCS', 'STCL', 'KFR1', 'BARL', 'BRPL', 'MOS1',
    'MOS2', 'WTRH', 'HCOR', 'KGZ1', 'KGZB', 'KGZG', 'KGZY', 'VLCO', 'VFBL', 'VTFB',
    'SFFI', 'TGLT', 'TELE', 'STFF', 'PUF3', 'PUF4', 'BEAK', 'WGNT', 'GAUN', 'PUF1',
    'WBLS', 'BLSR', 'FX18', 'FX17', 'WMCE', 'MACE', 'FX02', 'WSKL', 'HROD', 'FX00',
    'FX20', 'FX21', 'FX22', 'FX23', 'GWND', 'PUF2', 'WPHX', 'PHNX', 'FX04', 'FX08',
    'FX09', 'WBOW', 'CRBW', 'FX03', 'BLOD', 'PLAY', 'FDTH', 'BSKL', 'CHKN', 'MUMM',
    'FX15', 'BEAS', 'FRB1', 'SNKE', 'SNFX', 'HEAD', 'FX05', 'FX06', 'FX07', 'CLNK',
    'WZRD', 'FX11', 'FX10', 'KNIG', 'SPAX', 'RAXE', 'SRCR', 'FX14', 'SOR2', 'SDTH',
    'FX16', 'MNTR', 'FX12', 'FX13', 'AKYY', 'BKYY', 'CKYY', 'AMG2', 'AMM1', 'AMM2',
    'AMC1', 'AMC2', 'AMS1', 'AMS2', 'AMP1', 'AMP2', 'AMB1', 'AMB2', 'TNT1', ''
  );

const // Doom Original mobjinfo
  DO_mobjinfo: array[0..Ord(DO_NUMMOBJTYPES) - 1] of mobjinfo_t = (
   (    // MT_MISC0
    name: 'Crystal Vial';                                         // name
    inheritsfrom: -1;                                             // inheritsfrom
    doomednum: 81;                                                // doomednum
    spawnstate: Ord(S_ITEM_PTN1_1);                               // spawnstate
    spawnhealth: 1000;                                            // spawnhealth
    seestate: Ord(S_NULL);                                        // seestate
    seesound: Ord(sfx_None);                                      // seesound
    reactiontime: 8;                                              // reactiontime
    attacksound: Ord(sfx_None);                                   // attacksound
    painstate: Ord(S_NULL);                                       // painstate
    painchance: 0;                                                // painchance
    painsound: Ord(sfx_None);                                     // painsound
    meleestate: Ord(S_NULL);                                      // meleestate
    missilestate: Ord(S_NULL);                                    // missilestate
    crashstate: Ord(S_NULL);                                      // crashstate
    deathstate: Ord(S_NULL);                                      // deathstate
    xdeathstate: Ord(S_NULL);                                     // xdeathstate
    deathsound: Ord(sfx_None);                                    // deathsound
    speed: 0;                                                     // speed
    radius: 20 * FRACUNIT;                                        // radius
    height: 16 * FRACUNIT;                                        // height
    mass: 100;                                                    // mass
    damage: 0;                                                    // damage
    activesound: Ord(sfx_None);                                   // activesound
    flags: MF_SPECIAL;                                            // flags
    flags2: MF2_FLOATBOB;                                         // flags2
    pushfactor: DEFPUSHFACTOR;                                    // pushfactor
    scale: FRACUNIT;                                              // scale
    gravity: FRACUNIT;                                            // gravity
    flags3_ex: 0;                                                 // flags3_ex
    flags4_ex: 0;                                                 // flags4_ex
   ),

   (    // MT_ITEMSHIELD1
    name: 'Silver Shield';                                        // name
    inheritsfrom: -1;                                             // inheritsfrom
    doomednum: 85;                                                // doomednum
    spawnstate: Ord(S_ITEM_SHLD1);                                // spawnstate
    spawnhealth: 1000;                                            // spawnhealth
    seestate: Ord(S_NULL);                                        // seestate
    seesound: Ord(sfx_None);                                      // seesound
    reactiontime: 8;                                              // reactiontime
    attacksound: Ord(sfx_None);                                   // attacksound
    painstate: Ord(S_NULL);                                       // painstate
    painchance: 0;                                                // painchance
    painsound: Ord(sfx_None);                                     // painsound
    meleestate: Ord(S_NULL);                                      // meleestate
    missilestate: Ord(S_NULL);                                    // missilestate
    crashstate: Ord(S_NULL);                                      // crashstate
    deathstate: Ord(S_NULL);                                      // deathstate
    xdeathstate: Ord(S_NULL);                                     // xdeathstate
    deathsound: Ord(sfx_None);                                    // deathsound
    speed: 0;                                                     // speed
    radius: 20 * FRACUNIT;                                        // radius
    height: 16 * FRACUNIT;                                        // height
    mass: 100;                                                    // mass
    damage: 0;                                                    // damage
    activesound: Ord(sfx_None);                                   // activesound
    flags: MF_SPECIAL;                                            // flags
    flags2: MF2_FLOATBOB;                                         // flags2
    pushfactor: DEFPUSHFACTOR;                                    // pushfactor
    scale: FRACUNIT;                                              // scale
    gravity: FRACUNIT;                                            // gravity
    flags3_ex: 0;                                                 // flags3_ex
    flags4_ex: 0;                                                 // flags4_ex
   ),

   (    // MT_ITEMSHIELD2
    name: 'Enchanted Shield';
    inheritsfrom: -1;                                             // inheritsfrom
    doomednum: 31;                                                // doomednum
    spawnstate: Ord(S_ITEM_SHD2_1);                               // spawnstate
    spawnhealth: 1000;                                            // spawnhealth
    seestate: Ord(S_NULL);                                        // seestate
    seesound: Ord(sfx_None);                                      // seesound
    reactiontime: 8;                                              // reactiontime
    attacksound: Ord(sfx_None);                                   // attacksound
    painstate: Ord(S_NULL);                                       // painstate
    painchance: 0;                                                // painchance
    painsound: Ord(sfx_None);                                     // painsound
    meleestate: Ord(S_NULL);                                      // meleestate
    missilestate: Ord(S_NULL);                                    // missilestate
    crashstate: Ord(S_NULL);                                      // crashstate
    deathstate: Ord(S_NULL);                                      // deathstate
    xdeathstate: Ord(S_NULL);                                     // xdeathstate
    deathsound: Ord(sfx_None);                                    // deathsound
    speed: 0;                                                     // speed
    radius: 20 * FRACUNIT;                                        // radius
    height: 16 * FRACUNIT;                                        // height
    mass: 100;                                                    // mass
    damage: 0;                                                    // damage
    activesound: Ord(sfx_None);                                   // activesound
    flags: MF_SPECIAL;                                            // flags
    flags2: MF2_FLOATBOB;                                         // flags2
    pushfactor: DEFPUSHFACTOR;                                    // pushfactor
    scale: FRACUNIT;                                              // scale
    gravity: FRACUNIT;                                            // gravity
    flags3_ex: 0;                                                 // flags3_ex
    flags4_ex: 0;                                                 // flags4_ex
   ),

   (    // MT_MISC1
    name: 'Bag Of Holding';
    inheritsfrom: -1;                                             // inheritsfrom
    doomednum: 8;                                                 // doomednum
    spawnstate: Ord(S_ITEM_BAGH1);                                // spawnstate
    spawnhealth: 1000;                                            // spawnhealth
    seestate: Ord(S_NULL);                                        // seestate
    seesound: Ord(sfx_None);                                      // seesound
    reactiontime: 8;                                              // reactiontime
    attacksound: Ord(sfx_None);                                   // attacksound
    painstate: Ord(S_NULL);                                       // painstate
    painchance: 0;                                                // painchance
    painsound: Ord(sfx_None);                                     // painsound
    meleestate: Ord(S_NULL);                                      // meleestate
    missilestate: Ord(S_NULL);                                    // missilestate
    crashstate: Ord(S_NULL);                                      // crashstate
    deathstate: Ord(S_NULL);                                      // deathstate
    xdeathstate: Ord(S_NULL);                                     // xdeathstate
    deathsound: Ord(sfx_None);                                    // deathsound
    speed: 0;                                                     // speed
    radius: 20 * FRACUNIT;                                        // radius
    height: 16 * FRACUNIT;                                        // height
    mass: 100;                                                    // mass
    damage: 0;                                                    // damage
    activesound: Ord(sfx_None);                                   // activesound
    flags: MF_SPECIAL or MF_COUNTITEM;                            // flags
    flags2: MF2_FLOATBOB;                                         // flags2
    pushfactor: DEFPUSHFACTOR;                                    // pushfactor
    scale: FRACUNIT;                                              // scale
    gravity: FRACUNIT;                                            // gravity
    flags3_ex: 0;                                                 // flags3_ex
    flags4_ex: 0;                                                 // flags4_ex
   ),

   (    // MT_MISC2
    name: 'Map Scroll';
    inheritsfrom: -1;                                             // inheritsfrom
    doomednum: 35;                                                // doomednum
    spawnstate: Ord(S_ITEM_SPMP1);                                // spawnstate
    spawnhealth: 1000;                                            // spawnhealth
    seestate: Ord(S_NULL);                                        // seestate
    seesound: Ord(sfx_None);                                      // seesound
    reactiontime: 8;                                              // reactiontime
    attacksound: Ord(sfx_None);                                   // attacksound
    painstate: Ord(S_NULL);                                       // painstate
    painchance: 0;                                                // painchance
    painsound: Ord(sfx_None);                                     // painsound
    meleestate: Ord(S_NULL);                                      // meleestate
    missilestate: Ord(S_NULL);                                    // missilestate
    crashstate: Ord(S_NULL);                                      // crashstate
    deathstate: Ord(S_NULL);                                      // deathstate
    xdeathstate: Ord(S_NULL);                                     // xdeathstate
    deathsound: Ord(sfx_None);                                    // deathsound
    speed: 0;                                                     // speed
    radius: 20 * FRACUNIT;                                        // radius
    height: 16 * FRACUNIT;                                        // height
    mass: 100;                                                    // mass
    damage: 0;                                                    // damage
    activesound: Ord(sfx_None);                                   // activesound
    flags: MF_SPECIAL or MF_COUNTITEM;                            // flags
    flags2: MF2_FLOATBOB;                                         // flags2
    pushfactor: DEFPUSHFACTOR;                                    // pushfactor
    scale: FRACUNIT;                                              // scale
    gravity: FRACUNIT;                                            // gravity
    flags3_ex: 0;                                                 // flags3_ex
    flags4_ex: 0;                                                 // flags4_ex
   ),

   (    // MT_ARTIINVISIBILITY
    name: 'Shadowsphere';
    inheritsfrom: -1;                                             // inheritsfrom
    doomednum: 75;                                                // doomednum
    spawnstate: Ord(S_ARTI_INVS1);                                // spawnstate
    spawnhealth: 1000;                                            // spawnhealth
    seestate: Ord(S_NULL);                                        // seestate
    seesound: Ord(sfx_None);                                      // seesound
    reactiontime: 8;                                              // reactiontime
    attacksound: Ord(sfx_None);                                   // attacksound
    painstate: Ord(S_NULL);                                       // painstate
    painchance: 0;                                                // painchance
    painsound: Ord(sfx_None);                                     // painsound
    meleestate: Ord(S_NULL);                                      // meleestate
    missilestate: Ord(S_NULL);                                    // missilestate
    crashstate: Ord(S_NULL);                                      // crashstate
    deathstate: Ord(S_NULL);                                      // deathstate
    xdeathstate: Ord(S_NULL);                                     // xdeathstate
    deathsound: Ord(sfx_None);                                    // deathsound
    speed: 0;                                                     // speed
    radius: 20 * FRACUNIT;                                        // radius
    height: 16 * FRACUNIT;                                        // height
    mass: 100;                                                    // mass
    damage: 0;                                                    // damage
    activesound: Ord(sfx_None);                                   // activesound
    flags: MF_SPECIAL or MF_SHADOW or MF_COUNTITEM;               // flags
    flags2: MF2_FLOATBOB;                                         // flags2
    flags2_ex: MF2_EX_DONOTRENDERSHADOW;                          // flags2_ex
    pushfactor: DEFPUSHFACTOR;                                    // pushfactor
    scale: FRACUNIT;                                              // scale
    gravity: FRACUNIT;                                            // gravity
    flags3_ex: 0;                                                 // flags3_ex
    flags4_ex: 0;                                                 // flags4_ex
   ),

   (    // MT_MISC3
    name: 'Quartz Flask';
    inheritsfrom: -1;                                             // inheritsfrom
    doomednum: 82;                                                // doomednum
    spawnstate: Ord(S_ARTI_PTN2_1);                               // spawnstate
    spawnhealth: 1000;                                            // spawnhealth
    seestate: Ord(S_NULL);                                        // seestate
    seesound: Ord(sfx_None);                                      // seesound
    reactiontime: 8;                                              // reactiontime
    attacksound: Ord(sfx_None);                                   // attacksound
    painstate: Ord(S_NULL);                                       // painstate
    painchance: 0;                                                // painchance
    painsound: Ord(sfx_None);                                     // painsound
    meleestate: Ord(S_NULL);                                      // meleestate
    missilestate: Ord(S_NULL);                                    // missilestate
    crashstate: Ord(S_NULL);                                      // crashstate
    deathstate: Ord(S_NULL);                                      // deathstate
    xdeathstate: Ord(S_NULL);                                     // xdeathstate
    deathsound: Ord(sfx_None);                                    // deathsound
    speed: 0;                                                     // speed
    radius: 20 * FRACUNIT;                                        // radius
    height: 16 * FRACUNIT;                                        // height
    mass: 100;                                                    // mass
    damage: 0;                                                    // damage
    activesound: Ord(sfx_None);                                   // activesound
    flags: MF_SPECIAL or MF_COUNTITEM;                            // flags
    flags2: MF2_FLOATBOB;                                         // flags2
    pushfactor: DEFPUSHFACTOR;                                    // pushfactor
    scale: FRACUNIT;                                              // scale
    gravity: FRACUNIT;                                            // gravity
    flags3_ex: 0;                                                 // flags3_ex
    flags4_ex: 0;                                                 // flags4_ex
   ),

   (    // MT_ARTIFLY
    name: 'Wings Of Wrath';
    inheritsfrom: -1;                                             // inheritsfrom
    doomednum: 83;                                                // doomednum
    spawnstate: Ord(S_ARTI_SOAR1);                                // spawnstate
    spawnhealth: 1000;                                            // spawnhealth
    seestate: Ord(S_NULL);                                        // seestate
    seesound: Ord(sfx_None);                                      // seesound
    reactiontime: 8;                                              // reactiontime
    attacksound: Ord(sfx_None);                                   // attacksound
    painstate: Ord(S_NULL);                                       // painstate
    painchance: 0;                                                // painchance
    painsound: Ord(sfx_None);                                     // painsound
    meleestate: Ord(S_NULL);                                      // meleestate
    missilestate: Ord(S_NULL);                                    // missilestate
    crashstate: Ord(S_NULL);                                      // crashstate
    deathstate: Ord(S_NULL);                                      // deathstate
    xdeathstate: Ord(S_NULL);                                     // xdeathstate
    deathsound: Ord(sfx_None);                                    // deathsound
    speed: 0;                                                     // speed
    radius: 20 * FRACUNIT;                                        // radius
    height: 16 * FRACUNIT;                                        // height
    mass: 100;                                                    // mass
    damage: 0;                                                    // damage
    activesound: Ord(sfx_None);                                   // activesound
    flags: MF_SPECIAL or MF_COUNTITEM;                            // flags
    flags2: MF2_FLOATBOB;                                         // flags2
    pushfactor: DEFPUSHFACTOR;                                    // pushfactor
    scale: FRACUNIT;                                              // scale
    gravity: FRACUNIT;                                            // gravity
    flags3_ex: 0;                                                 // flags3_ex
    flags4_ex: 0;                                                 // flags4_ex
   ),

   (    // MT_ARTIINVULNERABILITY
    name: 'Ring of Invulnerability';
    inheritsfrom: -1;                                             // inheritsfrom
    doomednum: 84;                                                // doomednum
    spawnstate: Ord(S_ARTI_INVU1);                                // spawnstate
    spawnhealth: 1000;                                            // spawnhealth
    seestate: Ord(S_NULL);                                        // seestate
    seesound: Ord(sfx_None);                                      // seesound
    reactiontime: 8;                                              // reactiontime
    attacksound: Ord(sfx_None);                                   // attacksound
    painstate: Ord(S_NULL);                                       // painstate
    painchance: 0;                                                // painchance
    painsound: Ord(sfx_None);                                     // painsound
    meleestate: Ord(S_NULL);                                      // meleestate
    missilestate: Ord(S_NULL);                                    // missilestate
    crashstate: Ord(S_NULL);                                      // crashstate
    deathstate: Ord(S_NULL);                                      // deathstate
    xdeathstate: Ord(S_NULL);                                     // xdeathstate
    deathsound: Ord(sfx_None);                                    // deathsound
    speed: 0;                                                     // speed
    radius: 20 * FRACUNIT;                                        // radius
    height: 16 * FRACUNIT;                                        // height
    mass: 100;                                                    // mass
    damage: 0;                                                    // damage
    activesound: Ord(sfx_None);                                   // activesound
    flags: MF_SPECIAL or MF_COUNTITEM;                            // flags
    flags2: MF2_FLOATBOB;                                         // flags2
    pushfactor: DEFPUSHFACTOR;                                    // pushfactor
    scale: FRACUNIT;                                              // scale
    gravity: FRACUNIT;                                            // gravity
    flags3_ex: 0;                                                 // flags3_ex
    flags4_ex: 0;                                                 // flags4_ex
   ),

   (    // MT_ARTITOMEOFPOWER
    name: 'Tome of Power';
    inheritsfrom: -1;                                             // inheritsfrom
    doomednum: 86;                                                // doomednum
    spawnstate: Ord(S_ARTI_PWBK1);                                // spawnstate
    spawnhealth: 1000;                                            // spawnhealth
    seestate: Ord(S_NULL);                                        // seestate
    seesound: Ord(sfx_None);                                      // seesound
    reactiontime: 8;                                              // reactiontime
    attacksound: Ord(sfx_None);                                   // attacksound
    painstate: Ord(S_NULL);                                       // painstate
    painchance: 0;                                                // painchance
    painsound: Ord(sfx_None);                                     // painsound
    meleestate: Ord(S_NULL);                                      // meleestate
    missilestate: Ord(S_NULL);                                    // missilestate
    crashstate: Ord(S_NULL);                                      // crashstate
    deathstate: Ord(S_NULL);                                      // deathstate
    xdeathstate: Ord(S_NULL);                                     // xdeathstate
    deathsound: Ord(sfx_None);                                    // deathsound
    speed: 0;                                                     // speed
    radius: 20 * FRACUNIT;                                        // radius
    height: 16 * FRACUNIT;                                        // height
    mass: 100;                                                    // mass
    damage: 0;                                                    // damage
    activesound: Ord(sfx_None);                                   // activesound
    flags: MF_SPECIAL or MF_COUNTITEM;                            // flags
    flags2: MF2_FLOATBOB;                                         // flags2
    pushfactor: DEFPUSHFACTOR;                                    // pushfactor
    scale: FRACUNIT;                                              // scale
    gravity: FRACUNIT;                                            // gravity
    flags3_ex: 0;                                                 // flags3_ex
    flags4_ex: 0;                                                 // flags4_ex
   ),

   (    // MT_ARTIEGG
    name: 'Morph Ovum';
    inheritsfrom: -1;                                             // inheritsfrom
    doomednum: 30;                                                // doomednum
    spawnstate: Ord(S_ARTI_EGGC1);                                // spawnstate
    spawnhealth: 1000;                                            // spawnhealth
    seestate: Ord(S_NULL);                                        // seestate
    seesound: Ord(sfx_None);                                      // seesound
    reactiontime: 8;                                              // reactiontime
    attacksound: Ord(sfx_None);                                   // attacksound
    painstate: Ord(S_NULL);                                       // painstate
    painchance: 0;                                                // painchance
    painsound: Ord(sfx_None);                                     // painsound
    meleestate: Ord(S_NULL);                                      // meleestate
    missilestate: Ord(S_NULL);                                    // missilestate
    crashstate: Ord(S_NULL);                                      // crashstate
    deathstate: Ord(S_NULL);                                      // deathstate
    xdeathstate: Ord(S_NULL);                                     // xdeathstate
    deathsound: Ord(sfx_None);                                    // deathsound
    speed: 0;                                                     // speed
    radius: 20 * FRACUNIT;                                        // radius
    height: 16 * FRACUNIT;                                        // height
    mass: 100;                                                    // mass
    damage: 0;                                                    // damage
    activesound: Ord(sfx_None);                                   // activesound
    flags: MF_SPECIAL or MF_COUNTITEM;                            // flags
    flags2: MF2_FLOATBOB;                                         // flags2
    pushfactor: DEFPUSHFACTOR;                                    // pushfactor
    scale: FRACUNIT;                                              // scale
    gravity: FRACUNIT;                                            // gravity
    flags3_ex: 0;                                                 // flags3_ex
    flags4_ex: 0;                                                 // flags4_ex
   ),

   (    // MT_EGGFX
    name: 'MT_EGGFX';
    inheritsfrom: -1;                                             // inheritsfrom
    doomednum: -1;                                                // doomednum
    spawnstate: Ord(S_EGGFX1);                                    // spawnstate
    spawnhealth: 1000;                                            // spawnhealth
    seestate: Ord(S_NULL);                                        // seestate
    seesound: 0;                                                  // seesound
    reactiontime: 8;                                              // reactiontime
    attacksound: Ord(sfx_None);                                   // attacksound
    painstate: Ord(S_NULL);                                       // painstate
    painchance: 0;                                                // painchance
    painsound: Ord(sfx_None);                                     // painsound
    meleestate: Ord(S_NULL);                                      // meleestate
    missilestate: Ord(S_NULL);                                    // missilestate
    crashstate: Ord(S_NULL);                                      // crashstate
    deathstate: Ord(S_EGGFXI1_1);                                 // deathstate
    xdeathstate: Ord(S_NULL);                                     // xdeathstate
    deathsound: 0;                                                // deathsound
    speed: 18 * FRACUNIT;                                         // speed
    radius: 8 * FRACUNIT;                                         // radius
    height: 8 * FRACUNIT;                                         // height
    mass: 100;                                                    // mass
    damage: 1;                                                    // damage
    activesound: Ord(sfx_None);                                   // activesound
    flags: MF_NOBLOCKMAP or MF_MISSILE or MF_DROPOFF or MF_NOGRAVITY;    // flags
    flags2: MF2_NOTELEPORT;                                       // flags2
    pushfactor: DEFPUSHFACTOR;                                    // pushfactor
    scale: FRACUNIT;                                              // scale
    gravity: FRACUNIT;                                            // gravity
    flags3_ex: 0;                                                 // flags3_ex
    flags4_ex: 0;                                                 // flags4_ex
   ),

   (    // MT_ARTISUPERHEAL
    name: 'Mystic Urn';
    inheritsfrom: -1;                                             // inheritsfrom
    doomednum: 32;                                                // doomednum
    spawnstate: Ord(S_ARTI_SPHL1);                                // spawnstate
    spawnhealth: 1000;                                            // spawnhealth
    seestate: Ord(S_NULL);                                        // seestate
    seesound: Ord(sfx_None);                                      // seesound
    reactiontime: 8;                                              // reactiontime
    attacksound: Ord(sfx_None);                                   // attacksound
    painstate: Ord(S_NULL);                                       // painstate
    painchance: 0;                                                // painchance
    painsound: Ord(sfx_None);                                     // painsound
    meleestate: Ord(S_NULL);                                      // meleestate
    missilestate: Ord(S_NULL);                                    // missilestate
    crashstate: Ord(S_NULL);                                      // crashstate
    deathstate: Ord(S_NULL);                                      // deathstate
    xdeathstate: Ord(S_NULL);                                     // xdeathstate
    deathsound: Ord(sfx_None);                                    // deathsound
    speed: 0;                                                     // speed
    radius: 20 * FRACUNIT;                                        // radius
    height: 16 * FRACUNIT;                                        // height
    mass: 100;                                                    // mass
    damage: 0;                                                    // damage
    activesound: Ord(sfx_None);                                   // activesound
    flags: MF_SPECIAL or MF_COUNTITEM;                            // flags
    flags2: MF2_FLOATBOB;                                         // flags2
    pushfactor: DEFPUSHFACTOR;                                    // pushfactor
    scale: FRACUNIT;                                              // scale
    gravity: FRACUNIT;                                            // gravity
    flags3_ex: 0;                                                 // flags3_ex
    flags4_ex: 0;                                                 // flags4_ex
   ),

   (    // MT_MISC4
    name: 'Torch';
    inheritsfrom: -1;                                             // inheritsfrom
    doomednum: 33;                                                // doomednum
    spawnstate: Ord(S_ARTI_TRCH1);                                // spawnstate
    spawnhealth: 1000;                                            // spawnhealth
    seestate: Ord(S_NULL);                                        // seestate
    seesound: Ord(sfx_None);                                      // seesound
    reactiontime: 8;                                              // reactiontime
    attacksound: Ord(sfx_None);                                   // attacksound
    painstate: Ord(S_NULL);                                       // painstate
    painchance: 0;                                                // painchance
    painsound: Ord(sfx_None);                                     // painsound
    meleestate: Ord(S_NULL);                                      // meleestate
    missilestate: Ord(S_NULL);                                    // missilestate
    crashstate: Ord(S_NULL);                                      // crashstate
    deathstate: Ord(S_NULL);                                      // deathstate
    xdeathstate: Ord(S_NULL);                                     // xdeathstate
    deathsound: Ord(sfx_None);                                    // deathsound
    speed: 0;                                                     // speed
    radius: 20 * FRACUNIT;                                        // radius
    height: 16 * FRACUNIT;                                        // height
    mass: 100;                                                    // mass
    damage: 0;                                                    // damage
    activesound: Ord(sfx_None);                                   // activesound
    flags: MF_SPECIAL or MF_COUNTITEM;                            // flags
    flags2: MF2_FLOATBOB;                                         // flags2
    pushfactor: DEFPUSHFACTOR;                                    // pushfactor
    scale: FRACUNIT;                                              // scale
    gravity: FRACUNIT;                                            // gravity
    flags3_ex: 0;                                                 // flags3_ex
    flags4_ex: 0;                                                 // flags4_ex
   ),

   (    // MT_MISC5
    name: 'Time Bomb Of The Ancients';
    inheritsfrom: -1;                                             // inheritsfrom
    doomednum: 34;                                                // doomednum
    spawnstate: Ord(S_ARTI_FBMB1);                                // spawnstate
    spawnhealth: 1000;                                            // spawnhealth
    seestate: Ord(S_NULL);                                        // seestate
    seesound: Ord(sfx_None);                                      // seesound
    reactiontime: 8;                                              // reactiontime
    attacksound: Ord(sfx_None);                                   // attacksound
    painstate: Ord(S_NULL);                                       // painstate
    painchance: 0;                                                // painchance
    painsound: Ord(sfx_None);                                     // painsound
    meleestate: Ord(S_NULL);                                      // meleestate
    missilestate: Ord(S_NULL);                                    // missilestate
    crashstate: Ord(S_NULL);                                      // crashstate
    deathstate: Ord(S_NULL);                                      // deathstate
    xdeathstate: Ord(S_NULL);                                     // xdeathstate
    deathsound: Ord(sfx_None);                                    // deathsound
    speed: 0;                                                     // speed
    radius: 20 * FRACUNIT;                                        // radius
    height: 16 * FRACUNIT;                                        // height
    mass: 100;                                                    // mass
    damage: 0;                                                    // damage
    activesound: Ord(sfx_None);                                   // activesound
    flags: MF_SPECIAL or MF_COUNTITEM;                            // flags
    flags2: MF2_FLOATBOB;                                         // flags2
    pushfactor: DEFPUSHFACTOR;                                    // pushfactor
    scale: FRACUNIT;                                              // scale
    gravity: FRACUNIT;                                            // gravity
    flags3_ex: 0;                                                 // flags3_ex
    flags4_ex: 0;                                                 // flags4_ex
   ),

   (    // MT_FIREBOMB
    name: 'MT_FIREBOMB';
    inheritsfrom: -1;                                             // inheritsfrom
    doomednum: -1;                                                // doomednum
    spawnstate: Ord(S_FIREBOMB1);                                 // spawnstate
    spawnhealth: 1000;                                            // spawnhealth
    seestate: Ord(S_NULL);                                        // seestate
    seesound: Ord(sfx_None);                                      // seesound
    reactiontime: 8;                                              // reactiontime
    attacksound: Ord(sfx_None);                                   // attacksound
    painstate: Ord(S_NULL);                                       // painstate
    painchance: 0;                                                // painchance
    painsound: Ord(sfx_None);                                     // painsound
    meleestate: Ord(S_NULL);                                      // meleestate
    missilestate: Ord(S_NULL);                                    // missilestate
    crashstate: Ord(S_NULL);                                      // crashstate
    deathstate: Ord(S_NULL);                                      // deathstate
    xdeathstate: Ord(S_NULL);                                     // xdeathstate
    deathsound: Ord(sfx_phohit);                                  // deathsound
    speed: 0;                                                     // speed
    radius: 20 * FRACUNIT;                                        // radius
    height: 16 * FRACUNIT;                                        // height
    mass: 100;                                                    // mass
    damage: 0;                                                    // damage
    activesound: Ord(sfx_None);                                   // activesound
    flags: MF_NOGRAVITY or MF_SHADOW;                             // flags
    flags2: 0;                                                    // flags2
    flags2_ex: MF2_EX_DONOTRENDERSHADOW;                          // flags2_ex
    pushfactor: DEFPUSHFACTOR;                                    // pushfactor
    scale: FRACUNIT;                                              // scale
    gravity: FRACUNIT;                                            // gravity
    flags3_ex: 0;                                                 // flags3_ex
    flags4_ex: 0;                                                 // flags4_ex
   ),

   (    // MT_ARTITELEPORT
    name: 'Chaos Device';
    inheritsfrom: -1;                                             // inheritsfrom
    doomednum: 36;                                                // doomednum
    spawnstate: Ord(S_ARTI_ATLP1);                                // spawnstate
    spawnhealth: 1000;                                            // spawnhealth
    seestate: Ord(S_NULL);                                        // seestate
    seesound: Ord(sfx_None);                                      // seesound
    reactiontime: 8;                                              // reactiontime
    attacksound: Ord(sfx_None);                                   // attacksound
    painstate: Ord(S_NULL);                                       // painstate
    painchance: 0;                                                // painchance
    painsound: Ord(sfx_None);                                     // painsound
    meleestate: Ord(S_NULL);                                      // meleestate
    missilestate: Ord(S_NULL);                                    // missilestate
    crashstate: Ord(S_NULL);                                      // crashstate
    deathstate: Ord(S_NULL);                                      // deathstate
    xdeathstate: Ord(S_NULL);                                     // xdeathstate
    deathsound: Ord(sfx_None);                                    // deathsound
    speed: 0;                                                     // speed
    radius: 20 * FRACUNIT;                                        // radius
    height: 16 * FRACUNIT;                                        // height
    mass: 100;                                                    // mass
    damage: 0;                                                    // damage
    activesound: Ord(sfx_None);                                   // activesound
    flags: MF_SPECIAL or MF_COUNTITEM;                            // flags
    flags2: MF2_FLOATBOB;                                         // flags2
    pushfactor: DEFPUSHFACTOR;                                    // pushfactor
    scale: FRACUNIT;                                              // scale
    gravity: FRACUNIT;                                            // gravity
    flags3_ex: 0;                                                 // flags3_ex
    flags4_ex: 0;                                                 // flags4_ex
   ),

   (    // MT_POD
    name: 'Gasbag';
    inheritsfrom: -1;                                             // inheritsfrom
    doomednum: 2035;                                              // doomednum
    spawnstate: Ord(S_POD_WAIT1);                                 // spawnstate
    spawnhealth: 45;                                              // spawnhealth
    seestate: Ord(S_NULL);                                        // seestate
    seesound: Ord(sfx_None);                                      // seesound
    reactiontime: 8;                                              // reactiontime
    attacksound: Ord(sfx_None);                                   // attacksound
    painstate: Ord(S_POD_PAIN1);                                  // painstate
    painchance: 255;                                              // painchance
    painsound: Ord(sfx_None);                                     // painsound
    meleestate: Ord(S_NULL);                                      // meleestate
    missilestate: Ord(S_NULL);                                    // missilestate
    crashstate: Ord(S_NULL);                                      // crashstate
    deathstate: Ord(S_POD_DIE1);                                  // deathstate
    xdeathstate: Ord(S_NULL);                                     // xdeathstate
    deathsound: Ord(sfx_podexp);                                  // deathsound
    speed: 0;                                                     // speed
    radius: 16 * FRACUNIT;                                        // radius
    height: 54 * FRACUNIT;                                        // height
    mass: 100;                                                    // mass
    damage: 0;                                                    // damage
    activesound: Ord(sfx_None);                                   // activesound
    flags: MF_SOLID or MF_NOBLOOD or MF_SHOOTABLE or MF_DROPOFF;    // flags
    flags2: MF2_WINDTHRUST or MF2_PUSHABLE or MF2_SLIDE or MF2_PASSMOBJ or MF2_TELESTOMP;   // flags2
    pushfactor: DEFPUSHFACTOR;                                    // pushfactor
    scale: FRACUNIT;                                              // scale
    gravity: FRACUNIT;                                            // gravity
    flags3_ex: 0;                                                 // flags3_ex
    flags4_ex: 0;                                                 // flags4_ex
   ),

   (    // MT_PODGOO
    name: 'MT_PODGOO';
    inheritsfrom: -1;                                             // inheritsfrom
    doomednum: -1;                                                // doomednum
    spawnstate: Ord(S_PODGOO1);                                   // spawnstate
    spawnhealth: 1000;                                            // spawnhealth
    seestate: Ord(S_NULL);                                        // seestate
    seesound: Ord(sfx_None);                                      // seesound
    reactiontime: 8;                                              // reactiontime
    attacksound: Ord(sfx_None);                                   // attacksound
    painstate: Ord(S_NULL);                                       // painstate
    painchance: 0;                                                // painchance
    painsound: Ord(sfx_None);                                     // painsound
    meleestate: Ord(S_NULL);                                      // meleestate
    missilestate: Ord(S_NULL);                                    // missilestate
    crashstate: Ord(S_NULL);                                      // crashstate
    deathstate: Ord(S_PODGOOX);                                   // deathstate
    xdeathstate: Ord(S_NULL);                                     // xdeathstate
    deathsound: Ord(sfx_None);                                    // deathsound
    speed: 0;                                                     // speed
    radius: 2 * FRACUNIT;                                         // radius
    height: 4 * FRACUNIT;                                         // height
    mass: 100;                                                    // mass
    damage: 0;                                                    // damage
    activesound: Ord(sfx_None);                                   // activesound
    flags: MF_NOBLOCKMAP or MF_MISSILE or MF_DROPOFF;             // flags
    flags2: MF2_NOTELEPORT or MF2_LOGRAV or MF2_CANNOTPUSH;       // flags2
    pushfactor: DEFPUSHFACTOR;                                    // pushfactor
    scale: FRACUNIT;                                              // scale
    gravity: FRACUNIT;                                            // gravity
    flags3_ex: 0;                                                 // flags3_ex
    flags4_ex: 0;                                                 // flags4_ex
   ),

   (    // MT_PODGENERATOR
    name: 'Gasbag Generator';
    inheritsfrom: -1;                                             // inheritsfrom
    doomednum: 43;                                                // doomednum
    spawnstate: Ord(S_PODGENERATOR);                              // spawnstate
    spawnhealth: 1000;                                            // spawnhealth
    seestate: Ord(S_NULL);                                        // seestate
    seesound: Ord(sfx_None);                                      // seesound
    reactiontime: 8;                                              // reactiontime
    attacksound: Ord(sfx_None);                                   // attacksound
    painstate: Ord(S_NULL);                                       // painstate
    painchance: 0;                                                // painchance
    painsound: Ord(sfx_None);                                     // painsound
    meleestate: Ord(S_NULL);                                      // meleestate
    missilestate: Ord(S_NULL);                                    // missilestate
    crashstate: Ord(S_NULL);                                      // crashstate
    deathstate: Ord(S_NULL);                                      // deathstate
    xdeathstate: Ord(S_NULL);                                     // xdeathstate
    deathsound: Ord(sfx_None);                                    // deathsound
    speed: 0;                                                     // speed
    radius: 20 * FRACUNIT;                                        // radius
    height: 16 * FRACUNIT;                                        // height
    mass: 100;                                                    // mass
    damage: 0;                                                    // damage
    activesound: Ord(sfx_None);                                   // activesound
    flags: MF_NOBLOCKMAP or MF_NOSECTOR;                          // flags
    flags2: 0;                                                    // flags2
    pushfactor: DEFPUSHFACTOR;                                    // pushfactor
    scale: FRACUNIT;                                              // scale
    gravity: FRACUNIT;                                            // gravity
    flags3_ex: 0;                                                 // flags3_ex
    flags4_ex: 0;                                                 // flags4_ex
   ),

   (    // MT_SPLASH
    name: 'MT_SPLASH';
    inheritsfrom: -1;                                             // inheritsfrom
    doomednum: -1;                                                // doomednum
    spawnstate: Ord(S_SPLASH1);                                   // spawnstate
    spawnhealth: 1000;                                            // spawnhealth
    seestate: Ord(S_NULL);                                        // seestate
    seesound: Ord(sfx_None);                                      // seesound
    reactiontime: 8;                                              // reactiontime
    attacksound: Ord(sfx_None);                                   // attacksound
    painstate: Ord(S_NULL);                                       // painstate
    painchance: 0;                                                // painchance
    painsound: Ord(sfx_None);                                     // painsound
    meleestate: Ord(S_NULL);                                      // meleestate
    missilestate: Ord(S_NULL);                                    // missilestate
    crashstate: Ord(S_NULL);                                      // crashstate
    deathstate: Ord(S_SPLASHX);                                   // deathstate
    xdeathstate: Ord(S_NULL);                                     // xdeathstate
    deathsound: Ord(sfx_None);                                    // deathsound
    speed: 0;                                                     // speed
    radius: 2 * FRACUNIT;                                         // radius
    height: 4 * FRACUNIT;                                         // height
    mass: 100;                                                    // mass
    damage: 0;                                                    // damage
    activesound: Ord(sfx_None);                                   // activesound
    flags: MF_NOBLOCKMAP or MF_MISSILE or MF_DROPOFF;             // flags
    flags2: MF2_NOTELEPORT or MF2_LOGRAV or MF2_CANNOTPUSH;       // flags2
    flags2_ex: MF2_EX_DONOTRENDERSHADOW;                          // flags2_ex
    pushfactor: DEFPUSHFACTOR;                                    // pushfactor
    scale: FRACUNIT;                                              // scale
    gravity: FRACUNIT;                                            // gravity
    flags3_ex: 0;                                                 // flags3_ex
    flags4_ex: 0;                                                 // flags4_ex
   ),

   (    // MT_SPLASHBASE
    name: 'MT_SPLASHBASE';
    inheritsfrom: -1;                                             // inheritsfrom
    doomednum: -1;                                                // doomednum
    spawnstate: Ord(S_SPLASHBASE1);                               // spawnstate
    spawnhealth: 1000;                                            // spawnhealth
    seestate: Ord(S_NULL);                                        // seestate
    seesound: Ord(sfx_None);                                      // seesound
    reactiontime: 8;                                              // reactiontime
    attacksound: Ord(sfx_None);                                   // attacksound
    painstate: Ord(S_NULL);                                       // painstate
    painchance: 0;                                                // painchance
    painsound: Ord(sfx_None);                                     // painsound
    meleestate: Ord(S_NULL);                                      // meleestate
    missilestate: Ord(S_NULL);                                    // missilestate
    crashstate: Ord(S_NULL);                                      // crashstate
    deathstate: Ord(S_NULL);                                      // deathstate
    xdeathstate: Ord(S_NULL);                                     // xdeathstate
    deathsound: Ord(sfx_None);                                    // deathsound
    speed: 0;                                                     // speed
    radius: 20 * FRACUNIT;                                        // radius
    height: 16 * FRACUNIT;                                        // height
    mass: 100;                                                    // mass
    damage: 0;                                                    // damage
    activesound: Ord(sfx_None);                                   // activesound
    flags: MF_NOBLOCKMAP;                                         // flags
    flags2: 0;                                                    // flags2
    flags2_ex: MF2_EX_DONOTRENDERSHADOW;                          // flags2_ex
    pushfactor: DEFPUSHFACTOR;                                    // pushfactor
    scale: FRACUNIT;                                              // scale
    gravity: FRACUNIT;                                            // gravity
    flags3_ex: 0;                                                 // flags3_ex
    flags4_ex: 0;                                                 // flags4_ex
   ),

   (    // MT_LAVASPLASH
    name: 'MT_LAVASPLASH';
    inheritsfrom: -1;                                             // inheritsfrom
    doomednum: -1;                                                // doomednum
    spawnstate: Ord(S_LAVASPLASH1);                               // spawnstate
    spawnhealth: 1000;                                            // spawnhealth
    seestate: Ord(S_NULL);                                        // seestate
    seesound: Ord(sfx_None);                                      // seesound
    reactiontime: 8;                                              // reactiontime
    attacksound: Ord(sfx_None);                                   // attacksound
    painstate: Ord(S_NULL);                                       // painstate
    painchance: 0;                                                // painchance
    painsound: Ord(sfx_None);                                     // painsound
    meleestate: Ord(S_NULL);                                      // meleestate
    missilestate: Ord(S_NULL);                                    // missilestate
    crashstate: Ord(S_NULL);                                      // crashstate
    deathstate: Ord(S_NULL);                                      // deathstate
    xdeathstate: Ord(S_NULL);                                     // xdeathstate
    deathsound: Ord(sfx_None);                                    // deathsound
    speed: 0;                                                     // speed
    radius: 20 * FRACUNIT;                                        // radius
    height: 16 * FRACUNIT;                                        // height
    mass: 100;                                                    // mass
    damage: 0;                                                    // damage
    activesound: Ord(sfx_None);                                   // activesound
    flags: MF_NOBLOCKMAP;                                         // flags
    flags2: 0;                                                    // flags2
    flags2_ex: MF2_EX_DONOTRENDERSHADOW;                          // flags2_ex
    pushfactor: DEFPUSHFACTOR;                                    // pushfactor
    scale: FRACUNIT;                                              // scale
    gravity: FRACUNIT;                                            // gravity
    flags3_ex: 0;                                                 // flags3_ex
    flags4_ex: 0;                                                 // flags4_ex
   ),

   (    // MT_LAVASMOKE
    name: 'MT_LAVASMOKE';
    inheritsfrom: -1;                                             // inheritsfrom
    doomednum: -1;                                                // doomednum
    spawnstate: Ord(S_LAVASMOKE1);                                // spawnstate
    spawnhealth: 1000;                                            // spawnhealth
    seestate: Ord(S_NULL);                                        // seestate
    seesound: Ord(sfx_None);                                      // seesound
    reactiontime: 8;                                              // reactiontime
    attacksound: Ord(sfx_None);                                   // attacksound
    painstate: Ord(S_NULL);                                       // painstate
    painchance: 0;                                                // painchance
    painsound: Ord(sfx_None);                                     // painsound
    meleestate: Ord(S_NULL);                                      // meleestate
    missilestate: Ord(S_NULL);                                    // missilestate
    crashstate: Ord(S_NULL);                                      // crashstate
    deathstate: Ord(S_NULL);                                      // deathstate
    xdeathstate: Ord(S_NULL);                                     // xdeathstate
    deathsound: Ord(sfx_None);                                    // deathsound
    speed: 0;                                                     // speed
    radius: 20 * FRACUNIT;                                        // radius
    height: 16 * FRACUNIT;                                        // height
    mass: 100;                                                    // mass
    damage: 0;                                                    // damage
    activesound: Ord(sfx_None);                                   // activesound
    flags: MF_NOBLOCKMAP or MF_NOGRAVITY or MF_SHADOW;            // flags
    flags2: 0;                                                    // flags2
    flags2_ex: MF2_EX_DONOTRENDERSHADOW;                          // flags2_ex
    pushfactor: DEFPUSHFACTOR;                                    // pushfactor
    scale: FRACUNIT;                                              // scale
    gravity: FRACUNIT;                                            // gravity
    flags3_ex: 0;                                                 // flags3_ex
    flags4_ex: 0;                                                 // flags4_ex
   ),

   (    // MT_SLUDGECHUNK
    name: 'MT_SLUDGECHUNK';
    inheritsfrom: -1;                                             // inheritsfrom
    doomednum: -1;                                                // doomednum
    spawnstate: Ord(S_SLUDGECHUNK1);                              // spawnstate
    spawnhealth: 1000;                                            // spawnhealth
    seestate: Ord(S_NULL);                                        // seestate
    seesound: Ord(sfx_None);                                      // seesound
    reactiontime: 8;                                              // reactiontime
    attacksound: Ord(sfx_None);                                   // attacksound
    painstate: Ord(S_NULL);                                       // painstate
    painchance: 0;                                                // painchance
    painsound: Ord(sfx_None);                                     // painsound
    meleestate: Ord(S_NULL);                                      // meleestate
    missilestate: Ord(S_NULL);                                    // missilestate
    crashstate: Ord(S_NULL);                                      // crashstate
    deathstate: Ord(S_SLUDGECHUNKX);                              // deathstate
    xdeathstate: Ord(S_NULL);                                     // xdeathstate
    deathsound: Ord(sfx_None);                                    // deathsound
    speed: 0;                                                     // speed
    radius: 2 * FRACUNIT;                                         // radius
    height: 4 * FRACUNIT;                                         // height
    mass: 100;                                                    // mass
    damage: 0;                                                    // damage
    activesound: Ord(sfx_None);                                   // activesound
    flags: MF_NOBLOCKMAP or MF_MISSILE or MF_DROPOFF;             // flags
    flags2: MF2_NOTELEPORT or MF2_LOGRAV or MF2_CANNOTPUSH;       // flags2
    flags2_ex: MF2_EX_DONOTRENDERSHADOW;                          // flags2_ex
    pushfactor: DEFPUSHFACTOR;                                    // pushfactor
    scale: FRACUNIT;                                              // scale
    gravity: FRACUNIT;                                            // gravity
    flags3_ex: 0;                                                 // flags3_ex
    flags4_ex: 0;                                                 // flags4_ex
   ),

   (    // MT_SLUDGESPLASH
    name: 'MT_SLUDGESPLASH';
    inheritsfrom: -1;                                             // inheritsfrom
    doomednum: -1;                                                // doomednum
    spawnstate: Ord(S_SLUDGESPLASH1);                             // spawnstate
    spawnhealth: 1000;                                            // spawnhealth
    seestate: Ord(S_NULL);                                        // seestate
    seesound: Ord(sfx_None);                                      // seesound
    reactiontime: 8;                                              // reactiontime
    attacksound: Ord(sfx_None);                                   // attacksound
    painstate: Ord(S_NULL);                                       // painstate
    painchance: 0;                                                // painchance
    painsound: Ord(sfx_None);                                     // painsound
    meleestate: Ord(S_NULL);                                      // meleestate
    missilestate: Ord(S_NULL);                                    // missilestate
    crashstate: Ord(S_NULL);                                      // crashstate
    deathstate: Ord(S_NULL);                                      // deathstate
    xdeathstate: Ord(S_NULL);                                     // xdeathstate
    deathsound: Ord(sfx_None);                                    // deathsound
    speed: 0;                                                     // speed
    radius: 20 * FRACUNIT;                                        // radius
    height: 16 * FRACUNIT;                                        // height
    mass: 100;                                                    // mass
    damage: 0;                                                    // damage
    activesound: Ord(sfx_None);                                   // activesound
    flags: MF_NOBLOCKMAP;                                         // flags
    flags2: 0;                                                    // flags2
    flags2_ex: MF2_EX_DONOTRENDERSHADOW;                          // flags2_ex
    pushfactor: DEFPUSHFACTOR;                                    // pushfactor
    scale: FRACUNIT;                                              // scale
    gravity: FRACUNIT;                                            // gravity
    flags3_ex: 0;                                                 // flags3_ex
    flags4_ex: 0;                                                 // flags4_ex
   ),

   (    // MT_SKULLHANG70
    name: 'Hanging Skull';
    inheritsfrom: -1;                                             // inheritsfrom
    doomednum: 17;                                                // doomednum
    spawnstate: Ord(S_SKULLHANG70_1);                             // spawnstate
    spawnhealth: 1000;                                            // spawnhealth
    seestate: Ord(S_NULL);                                        // seestate
    seesound: Ord(sfx_None);                                      // seesound
    reactiontime: 8;                                              // reactiontime
    attacksound: Ord(sfx_None);                                   // attacksound
    painstate: Ord(S_NULL);                                       // painstate
    painchance: 0;                                                // painchance
    painsound: Ord(sfx_None);                                     // painsound
    meleestate: Ord(S_NULL);                                      // meleestate
    missilestate: Ord(S_NULL);                                    // missilestate
    crashstate: Ord(S_NULL);                                      // crashstate
    deathstate: Ord(S_NULL);                                      // deathstate
    xdeathstate: Ord(S_NULL);                                     // xdeathstate
    deathsound: Ord(sfx_None);                                    // deathsound
    speed: 0;                                                     // speed
    radius: 20 * FRACUNIT;                                        // radius
    height: 70 * FRACUNIT;                                        // height
    mass: 100;                                                    // mass
    damage: 0;                                                    // damage
    activesound: Ord(sfx_None);                                   // activesound
    flags: MF_SPAWNCEILING or MF_NOGRAVITY;                       // flags
    flags2: 0;                                                    // flags2
    pushfactor: DEFPUSHFACTOR;                                    // pushfactor
    scale: FRACUNIT;                                              // scale
    gravity: FRACUNIT;                                            // gravity
    flags3_ex: 0;                                                 // flags3_ex
    flags4_ex: 0;                                                 // flags4_ex
   ),

   (    // MT_SKULLHANG60
    name: 'Hanging Skull 2';
    inheritsfrom: -1;                                             // inheritsfrom
    doomednum: 24;                                                // doomednum
    spawnstate: Ord(S_SKULLHANG60_1);                             // spawnstate
    spawnhealth: 1000;                                            // spawnhealth
    seestate: Ord(S_NULL);                                        // seestate
    seesound: Ord(sfx_None);                                      // seesound
    reactiontime: 8;                                              // reactiontime
    attacksound: Ord(sfx_None);                                   // attacksound
    painstate: Ord(S_NULL);                                       // painstate
    painchance: 0;                                                // painchance
    painsound: Ord(sfx_None);                                     // painsound
    meleestate: Ord(S_NULL);                                      // meleestate
    missilestate: Ord(S_NULL);                                    // missilestate
    crashstate: Ord(S_NULL);                                      // crashstate
    deathstate: Ord(S_NULL);                                      // deathstate
    xdeathstate: Ord(S_NULL);                                     // xdeathstate
    deathsound: Ord(sfx_None);                                    // deathsound
    speed: 0;                                                     // speed
    radius: 20 * FRACUNIT;                                        // radius
    height: 60 * FRACUNIT;                                        // height
    mass: 100;                                                    // mass
    damage: 0;                                                    // damage
    activesound: Ord(sfx_None);                                   // activesound
    flags: MF_SPAWNCEILING or MF_NOGRAVITY;                       // flags
    flags2: 0;                                                    // flags2
    pushfactor: DEFPUSHFACTOR;                                    // pushfactor
    scale: FRACUNIT;                                              // scale
    gravity: FRACUNIT;                                            // gravity
    flags3_ex: 0;                                                 // flags3_ex
    flags4_ex: 0;                                                 // flags4_ex
   ),

   (    // MT_SKULLHANG45
    name: 'Hanging Skull 3';
    inheritsfrom: -1;                                             // inheritsfrom
    doomednum: 25;                                                // doomednum
    spawnstate: Ord(S_SKULLHANG45_1);                             // spawnstate
    spawnhealth: 1000;                                            // spawnhealth
    seestate: Ord(S_NULL);                                        // seestate
    seesound: Ord(sfx_None);                                      // seesound
    reactiontime: 8;                                              // reactiontime
    attacksound: Ord(sfx_None);                                   // attacksound
    painstate: Ord(S_NULL);                                       // painstate
    painchance: 0;                                                // painchance
    painsound: Ord(sfx_None);                                     // painsound
    meleestate: Ord(S_NULL);                                      // meleestate
    missilestate: Ord(S_NULL);                                    // missilestate
    crashstate: Ord(S_NULL);                                      // crashstate
    deathstate: Ord(S_NULL);                                      // deathstate
    xdeathstate: Ord(S_NULL);                                     // xdeathstate
    deathsound: Ord(sfx_None);                                    // deathsound
    speed: 0;                                                     // speed
    radius: 20 * FRACUNIT;                                        // radius
    height: 45 * FRACUNIT;                                        // height
    mass: 100;                                                    // mass
    damage: 0;                                                    // damage
    activesound: Ord(sfx_None);                                   // activesound
    flags: MF_SPAWNCEILING or MF_NOGRAVITY;                       // flags
    flags2: 0;                                                    // flags2
    pushfactor: DEFPUSHFACTOR;                                    // pushfactor
    scale: FRACUNIT;                                              // scale
    gravity: FRACUNIT;                                            // gravity
    flags3_ex: 0;                                                 // flags3_ex
    flags4_ex: 0;                                                 // flags4_ex
   ),

   (    // MT_SKULLHANG35
    name: 'Hanging Skull 4';
    inheritsfrom: -1;                                             // inheritsfrom
    doomednum: 26;                                                // doomednum
    spawnstate: Ord(S_SKULLHANG35_1);                             // spawnstate
    spawnhealth: 1000;                                            // spawnhealth
    seestate: Ord(S_NULL);                                        // seestate
    seesound: Ord(sfx_None);                                      // seesound
    reactiontime: 8;                                              // reactiontime
    attacksound: Ord(sfx_None);                                   // attacksound
    painstate: Ord(S_NULL);                                       // painstate
    painchance: 0;                                                // painchance
    painsound: Ord(sfx_None);                                     // painsound
    meleestate: Ord(S_NULL);                                      // meleestate
    missilestate: Ord(S_NULL);                                    // missilestate
    crashstate: Ord(S_NULL);                                      // crashstate
    deathstate: Ord(S_NULL);                                      // deathstate
    xdeathstate: Ord(S_NULL);                                     // xdeathstate
    deathsound: Ord(sfx_None);                                    // deathsound
    speed: 0;                                                     // speed
    radius: 20 * FRACUNIT;                                        // radius
    height: 35 * FRACUNIT;                                        // height
    mass: 100;                                                    // mass
    damage: 0;                                                    // damage
    activesound: Ord(sfx_None);                                   // activesound
    flags: MF_SPAWNCEILING or MF_NOGRAVITY;                       // flags
    flags2: 0;                                                    // flags2
    pushfactor: DEFPUSHFACTOR;                                    // pushfactor
    scale: FRACUNIT;                                              // scale
    gravity: FRACUNIT;                                            // gravity
    flags3_ex: 0;                                                 // flags3_ex
    flags4_ex: 0;                                                 // flags4_ex
   ),

   (    // MT_CHANDELIER
    name: 'Chandelier';
    inheritsfrom: -1;                                             // inheritsfrom
    doomednum: 28;                                                // doomednum
    spawnstate: Ord(S_CHANDELIER1);                               // spawnstate
    spawnhealth: 1000;                                            // spawnhealth
    seestate: Ord(S_NULL);                                        // seestate
    seesound: Ord(sfx_None);                                      // seesound
    reactiontime: 8;                                              // reactiontime
    attacksound: Ord(sfx_None);                                   // attacksound
    painstate: Ord(S_NULL);                                       // painstate
    painchance: 0;                                                // painchance
    painsound: Ord(sfx_None);                                     // painsound
    meleestate: Ord(S_NULL);                                      // meleestate
    missilestate: Ord(S_NULL);                                    // missilestate
    crashstate: Ord(S_NULL);                                      // crashstate
    deathstate: Ord(S_NULL);                                      // deathstate
    xdeathstate: Ord(S_NULL);                                     // xdeathstate
    deathsound: Ord(sfx_None);                                    // deathsound
    speed: 0;                                                     // speed
    radius: 20 * FRACUNIT;                                        // radius
    height: 60 * FRACUNIT;                                        // height
    mass: 100;                                                    // mass
    damage: 0;                                                    // damage
    activesound: Ord(sfx_None);                                   // activesound
    flags: MF_SPAWNCEILING or MF_NOGRAVITY;                       // flags
    flags2: 0;                                                    // flags2
    pushfactor: DEFPUSHFACTOR;                                    // pushfactor
    scale: FRACUNIT;                                              // scale
    gravity: FRACUNIT;                                            // gravity
    flags3_ex: 0;                                                 // flags3_ex
    flags4_ex: 0;                                                 // flags4_ex
   ),

   (    // MT_SERPTORCH
    name: 'Serpent Torch';
    inheritsfrom: -1;                                             // inheritsfrom
    doomednum: 27;                                                // doomednum
    spawnstate: Ord(S_SERPTORCH1);                                // spawnstate
    spawnhealth: 1000;                                            // spawnhealth
    seestate: Ord(S_NULL);                                        // seestate
    seesound: Ord(sfx_None);                                      // seesound
    reactiontime: 8;                                              // reactiontime
    attacksound: Ord(sfx_None);                                   // attacksound
    painstate: Ord(S_NULL);                                       // painstate
    painchance: 0;                                                // painchance
    painsound: Ord(sfx_None);                                     // painsound
    meleestate: Ord(S_NULL);                                      // meleestate
    missilestate: Ord(S_NULL);                                    // missilestate
    crashstate: Ord(S_NULL);                                      // crashstate
    deathstate: Ord(S_NULL);                                      // deathstate
    xdeathstate: Ord(S_NULL);                                     // xdeathstate
    deathsound: Ord(sfx_None);                                    // deathsound
    speed: 0;                                                     // speed
    radius: 12 * FRACUNIT;                                        // radius
    height: 54 * FRACUNIT;                                        // height
    mass: 100;                                                    // mass
    damage: 0;                                                    // damage
    activesound: Ord(sfx_None);                                   // activesound
    flags: MF_SOLID;                                              // flags
    flags2: 0;                                                    // flags2
    pushfactor: DEFPUSHFACTOR;                                    // pushfactor
    scale: FRACUNIT;                                              // scale
    gravity: FRACUNIT;                                            // gravity
    flags3_ex: 0;                                                 // flags3_ex
    flags4_ex: 0;                                                 // flags4_ex
   ),

   (    // MT_SMALLPILLAR
    name: 'Small Pillar';
    inheritsfrom: -1;                                             // inheritsfrom
    doomednum: 29;                                                // doomednum
    spawnstate: Ord(S_SMALLPILLAR);                               // spawnstate
    spawnhealth: 1000;                                            // spawnhealth
    seestate: Ord(S_NULL);                                        // seestate
    seesound: Ord(sfx_None);                                      // seesound
    reactiontime: 8;                                              // reactiontime
    attacksound: Ord(sfx_None);                                   // attacksound
    painstate: Ord(S_NULL);                                       // painstate
    painchance: 0;                                                // painchance
    painsound: Ord(sfx_None);                                     // painsound
    meleestate: Ord(S_NULL);                                      // meleestate
    missilestate: Ord(S_NULL);                                    // missilestate
    crashstate: Ord(S_NULL);                                      // crashstate
    deathstate: Ord(S_NULL);                                      // deathstate
    xdeathstate: Ord(S_NULL);                                     // xdeathstate
    deathsound: Ord(sfx_None);                                    // deathsound
    speed: 0;                                                     // speed
    radius: 16 * FRACUNIT;                                        // radius
    height: 34 * FRACUNIT;                                        // height
    mass: 100;                                                    // mass
    damage: 0;                                                    // damage
    activesound: Ord(sfx_None);                                   // activesound
    flags: MF_SOLID;                                              // flags
    flags2: 0;                                                    // flags2
    pushfactor: DEFPUSHFACTOR;                                    // pushfactor
    scale: FRACUNIT;                                              // scale
    gravity: FRACUNIT;                                            // gravity
    flags3_ex: 0;                                                 // flags3_ex
    flags4_ex: 0;                                                 // flags4_ex
   ),

   (    // MT_STALAGMITESMALL
    name: 'Small Stalagmite';
    inheritsfrom: -1;                                             // inheritsfrom
    doomednum: 37;                                                // doomednum
    spawnstate: Ord(S_STALAGMITESMALL);                           // spawnstate
    spawnhealth: 1000;                                            // spawnhealth
    seestate: Ord(S_NULL);                                        // seestate
    seesound: Ord(sfx_None);                                      // seesound
    reactiontime: 8;                                              // reactiontime
    attacksound: Ord(sfx_None);                                   // attacksound
    painstate: Ord(S_NULL);                                       // painstate
    painchance: 0;                                                // painchance
    painsound: Ord(sfx_None);                                     // painsound
    meleestate: Ord(S_NULL);                                      // meleestate
    missilestate: Ord(S_NULL);                                    // missilestate
    crashstate: Ord(S_NULL);                                      // crashstate
    deathstate: Ord(S_NULL);                                      // deathstate
    xdeathstate: Ord(S_NULL);                                     // xdeathstate
    deathsound: Ord(sfx_None);                                    // deathsound
    speed: 0;                                                     // speed
    radius: 8 * FRACUNIT;                                         // radius
    height: 32 * FRACUNIT;                                        // height
    mass: 100;                                                    // mass
    damage: 0;                                                    // damage
    activesound: Ord(sfx_None);                                   // activesound
    flags: MF_SOLID;                                              // flags
    flags2: 0;                                                    // flags2
    pushfactor: DEFPUSHFACTOR;                                    // pushfactor
    scale: FRACUNIT;                                              // scale
    gravity: FRACUNIT;                                            // gravity
    flags3_ex: 0;                                                 // flags3_ex
    flags4_ex: 0;                                                 // flags4_ex
   ),

   (    // MT_STALAGMITELARGE
    name: 'Large Stalagmite';
    inheritsfrom: -1;                                             // inheritsfrom
    doomednum: 38;                                                // doomednum
    spawnstate: Ord(S_STALAGMITELARGE);                           // spawnstate
    spawnhealth: 1000;                                            // spawnhealth
    seestate: Ord(S_NULL);                                        // seestate
    seesound: Ord(sfx_None);                                      // seesound
    reactiontime: 8;                                              // reactiontime
    attacksound: Ord(sfx_None);                                   // attacksound
    painstate: Ord(S_NULL);                                       // painstate
    painchance: 0;                                                // painchance
    painsound: Ord(sfx_None);                                     // painsound
    meleestate: Ord(S_NULL);                                      // meleestate
    missilestate: Ord(S_NULL);                                    // missilestate
    crashstate: Ord(S_NULL);                                      // crashstate
    deathstate: Ord(S_NULL);                                      // deathstate
    xdeathstate: Ord(S_NULL);                                     // xdeathstate
    deathsound: Ord(sfx_None);                                    // deathsound
    speed: 0;                                                     // speed
    radius: 12 * FRACUNIT;                                        // radius
    height: 64 * FRACUNIT;                                        // height
    mass: 100;                                                    // mass
    damage: 0;                                                    // damage
    activesound: Ord(sfx_None);                                   // activesound
    flags: MF_SOLID;                                              // flags
    flags2: 0;                                                    // flags2
    pushfactor: DEFPUSHFACTOR;                                    // pushfactor
    scale: FRACUNIT;                                              // scale
    gravity: FRACUNIT;                                            // gravity
    flags3_ex: 0;                                                 // flags3_ex
    flags4_ex: 0;                                                 // flags4_ex
   ),

   (    // MT_STALACTITESMALL
    name: 'Small Stalactite';
    inheritsfrom: -1;                                             // inheritsfrom
    doomednum: 39;                                                // doomednum
    spawnstate: Ord(S_STALACTITESMALL);                           // spawnstate
    spawnhealth: 1000;                                            // spawnhealth
    seestate: Ord(S_NULL);                                        // seestate
    seesound: Ord(sfx_None);                                      // seesound
    reactiontime: 8;                                              // reactiontime
    attacksound: Ord(sfx_None);                                   // attacksound
    painstate: Ord(S_NULL);                                       // painstate
    painchance: 0;                                                // painchance
    painsound: Ord(sfx_None);                                     // painsound
    meleestate: Ord(S_NULL);                                      // meleestate
    missilestate: Ord(S_NULL);                                    // missilestate
    crashstate: Ord(S_NULL);                                      // crashstate
    deathstate: Ord(S_NULL);                                      // deathstate
    xdeathstate: Ord(S_NULL);                                     // xdeathstate
    deathsound: Ord(sfx_None);                                    // deathsound
    speed: 0;                                                     // speed
    radius: 8 * FRACUNIT;                                         // radius
    height: 36 * FRACUNIT;                                        // height
    mass: 100;                                                    // mass
    damage: 0;                                                    // damage
    activesound: Ord(sfx_None);                                   // activesound
    flags: MF_SOLID or MF_SPAWNCEILING or MF_NOGRAVITY;           // flags
    flags2: 0;                                                    // flags2
    pushfactor: DEFPUSHFACTOR;                                    // pushfactor
    scale: FRACUNIT;                                              // scale
    gravity: FRACUNIT;                                            // gravity
    flags3_ex: 0;                                                 // flags3_ex
    flags4_ex: 0;                                                 // flags4_ex
   ),

   (    // MT_STALACTITELARGE
    name: 'Large Stalactite';
    inheritsfrom: -1;                                             // inheritsfrom
    doomednum: 40;                                                // doomednum
    spawnstate: Ord(S_STALACTITELARGE);                           // spawnstate
    spawnhealth: 1000;                                            // spawnhealth
    seestate: Ord(S_NULL);                                        // seestate
    seesound: Ord(sfx_None);                                      // seesound
    reactiontime: 8;                                              // reactiontime
    attacksound: Ord(sfx_None);                                   // attacksound
    painstate: Ord(S_NULL);                                       // painstate
    painchance: 0;                                                // painchance
    painsound: Ord(sfx_None);                                     // painsound
    meleestate: Ord(S_NULL);                                      // meleestate
    missilestate: Ord(S_NULL);                                    // missilestate
    crashstate: Ord(S_NULL);                                      // crashstate
    deathstate: Ord(S_NULL);                                      // deathstate
    xdeathstate: Ord(S_NULL);                                     // xdeathstate
    deathsound: Ord(sfx_None);                                    // deathsound
    speed: 0;                                                     // speed
    radius: 12 * FRACUNIT;                                        // radius
    height: 68 * FRACUNIT;                                        // height
    mass: 100;                                                    // mass
    damage: 0;                                                    // damage
    activesound: Ord(sfx_None);                                   // activesound
    flags: MF_SOLID or MF_SPAWNCEILING or MF_NOGRAVITY;           // flags
    flags2: 0;                                                    // flags2
    pushfactor: DEFPUSHFACTOR;                                    // pushfactor
    scale: FRACUNIT;                                              // scale
    gravity: FRACUNIT;                                            // gravity
    flags3_ex: 0;                                                 // flags3_ex
    flags4_ex: 0;                                                 // flags4_ex
   ),

   (    // MT_MISC6
    name: 'Fire Brazier';
    inheritsfrom: -1;                                             // inheritsfrom
    doomednum: 76;                                                // doomednum
    spawnstate: Ord(S_FIREBRAZIER1);                              // spawnstate
    spawnhealth: 1000;                                            // spawnhealth
    seestate: Ord(S_NULL);                                        // seestate
    seesound: Ord(sfx_None);                                      // seesound
    reactiontime: 8;                                              // reactiontime
    attacksound: Ord(sfx_None);                                   // attacksound
    painstate: Ord(S_NULL);                                       // painstate
    painchance: 0;                                                // painchance
    painsound: Ord(sfx_None);                                     // painsound
    meleestate: Ord(S_NULL);                                      // meleestate
    missilestate: Ord(S_NULL);                                    // missilestate
    crashstate: Ord(S_NULL);                                      // crashstate
    deathstate: Ord(S_NULL);                                      // deathstate
    xdeathstate: Ord(S_NULL);                                     // xdeathstate
    deathsound: Ord(sfx_None);                                    // deathsound
    speed: 0;                                                     // speed
    radius: 16 * FRACUNIT;                                        // radius
    height: 44 * FRACUNIT;                                        // height
    mass: 100;                                                    // mass
    damage: 0;                                                    // damage
    activesound: Ord(sfx_None);                                   // activesound
    flags: MF_SOLID;                                              // flags
    flags2: 0;                                                    // flags2
    pushfactor: DEFPUSHFACTOR;                                    // pushfactor
    scale: FRACUNIT;                                              // scale
    gravity: FRACUNIT;                                            // gravity
    flags3_ex: 0;                                                 // flags3_ex
    flags4_ex: 0;                                                 // flags4_ex
   ),

   (    // MT_BARREL
    name: 'Barrel';
    inheritsfrom: -1;                                             // inheritsfrom
    doomednum: 44;                                                // doomednum
    spawnstate: Ord(S_BARREL);                                    // spawnstate
    spawnhealth: 1000;                                            // spawnhealth
    seestate: Ord(S_NULL);                                        // seestate
    seesound: Ord(sfx_None);                                      // seesound
    reactiontime: 8;                                              // reactiontime
    attacksound: Ord(sfx_None);                                   // attacksound
    painstate: Ord(S_NULL);                                       // painstate
    painchance: 0;                                                // painchance
    painsound: Ord(sfx_None);                                     // painsound
    meleestate: Ord(S_NULL);                                      // meleestate
    missilestate: Ord(S_NULL);                                    // missilestate
    crashstate: Ord(S_NULL);                                      // crashstate
    deathstate: Ord(S_NULL);                                      // deathstate
    xdeathstate: Ord(S_NULL);                                     // xdeathstate
    deathsound: Ord(sfx_None);                                    // deathsound
    speed: 0;                                                     // speed
    radius: 12 * FRACUNIT;                                        // radius
    height: 32 * FRACUNIT;                                        // height
    mass: 100;                                                    // mass
    damage: 0;                                                    // damage
    activesound: Ord(sfx_None);                                   // activesound
    flags: MF_SOLID;                                              // flags
    flags2: 0;                                                    // flags2
    pushfactor: DEFPUSHFACTOR;                                    // pushfactor
    scale: FRACUNIT;                                              // scale
    gravity: FRACUNIT;                                            // gravity
    flags3_ex: 0;                                                 // flags3_ex
    flags4_ex: 0;                                                 // flags4_ex
   ),

   (    // MT_MISC7
    name: 'Brown Pillar';
    inheritsfrom: -1;                                             // inheritsfrom
    doomednum: 47;                                                // doomednum
    spawnstate: Ord(S_BRPILLAR);                                  // spawnstate
    spawnhealth: 1000;                                            // spawnhealth
    seestate: Ord(S_NULL);                                        // seestate
    seesound: Ord(sfx_None);                                      // seesound
    reactiontime: 8;                                              // reactiontime
    attacksound: Ord(sfx_None);                                   // attacksound
    painstate: Ord(S_NULL);                                       // painstate
    painchance: 0;                                                // painchance
    painsound: Ord(sfx_None);                                     // painsound
    meleestate: Ord(S_NULL);                                      // meleestate
    missilestate: Ord(S_NULL);                                    // missilestate
    crashstate: Ord(S_NULL);                                      // crashstate
    deathstate: Ord(S_NULL);                                      // deathstate
    xdeathstate: Ord(S_NULL);                                     // xdeathstate
    deathsound: Ord(sfx_None);                                    // deathsound
    speed: 0;                                                     // speed
    radius: 14 * FRACUNIT;                                        // radius
    height: 128 * FRACUNIT;                                       // height
    mass: 100;                                                    // mass
    damage: 0;                                                    // damage
    activesound: Ord(sfx_None);                                   // activesound
    flags: MF_SOLID;                                              // flags
    flags2: 0;                                                    // flags2
    pushfactor: DEFPUSHFACTOR;                                    // pushfactor
    scale: FRACUNIT;                                              // scale
    gravity: FRACUNIT;                                            // gravity
    flags3_ex: 0;                                                 // flags3_ex
    flags4_ex: 0;                                                 // flags4_ex
   ),

   (    // MT_MISC8
    name: 'Moss';
    inheritsfrom: -1;                                             // inheritsfrom
    doomednum: 48;                                                // doomednum
    spawnstate: Ord(S_MOSS1);                                     // spawnstate
    spawnhealth: 1000;                                            // spawnhealth
    seestate: Ord(S_NULL);                                        // seestate
    seesound: Ord(sfx_None);                                      // seesound
    reactiontime: 8;                                              // reactiontime
    attacksound: Ord(sfx_None);                                   // attacksound
    painstate: Ord(S_NULL);                                       // painstate
    painchance: 0;                                                // painchance
    painsound: Ord(sfx_None);                                     // painsound
    meleestate: Ord(S_NULL);                                      // meleestate
    missilestate: Ord(S_NULL);                                    // missilestate
    crashstate: Ord(S_NULL);                                      // crashstate
    deathstate: Ord(S_NULL);                                      // deathstate
    xdeathstate: Ord(S_NULL);                                     // xdeathstate
    deathsound: Ord(sfx_None);                                    // deathsound
    speed: 0;                                                     // speed
    radius: 20 * FRACUNIT;                                        // radius
    height: 23 * FRACUNIT;                                        // height
    mass: 100;                                                    // mass
    damage: 0;                                                    // damage
    activesound: Ord(sfx_None);                                   // activesound
    flags: MF_SPAWNCEILING or MF_NOGRAVITY;                       // flags
    flags2: 0;                                                    // flags2
    pushfactor: DEFPUSHFACTOR;                                    // pushfactor
    scale: FRACUNIT;                                              // scale
    gravity: FRACUNIT;                                            // gravity
    flags3_ex: 0;                                                 // flags3_ex
    flags4_ex: 0;                                                 // flags4_ex
   ),

   (    // MT_MISC9
    name: 'Moss 2';
    inheritsfrom: -1;                                             // inheritsfrom
    doomednum: 49;                                                // doomednum
    spawnstate: Ord(S_MOSS2);                                     // spawnstate
    spawnhealth: 1000;                                            // spawnhealth
    seestate: Ord(S_NULL);                                        // seestate
    seesound: Ord(sfx_None);                                      // seesound
    reactiontime: 8;                                              // reactiontime
    attacksound: Ord(sfx_None);                                   // attacksound
    painstate: Ord(S_NULL);                                       // painstate
    painchance: 0;                                                // painchance
    painsound: Ord(sfx_None);                                     // painsound
    meleestate: Ord(S_NULL);                                      // meleestate
    missilestate: Ord(S_NULL);                                    // missilestate
    crashstate: Ord(S_NULL);                                      // crashstate
    deathstate: Ord(S_NULL);                                      // deathstate
    xdeathstate: Ord(S_NULL);                                     // xdeathstate
    deathsound: Ord(sfx_None);                                    // deathsound
    speed: 0;                                                     // speed
    radius: 20 * FRACUNIT;                                        // radius
    height: 27 * FRACUNIT;                                        // height
    mass: 100;                                                    // mass
    damage: 0;                                                    // damage
    activesound: Ord(sfx_None);                                   // activesound
    flags: MF_SPAWNCEILING or MF_NOGRAVITY;                       // flags
    flags2: 0;                                                    // flags2
    pushfactor: DEFPUSHFACTOR;                                    // pushfactor
    scale: FRACUNIT;                                              // scale
    gravity: FRACUNIT;                                            // gravity
    flags3_ex: 0;                                                 // flags3_ex
    flags4_ex: 0;                                                 // flags4_ex
   ),

   (    // MT_MISC10
    name: 'Wall Torch';
    inheritsfrom: -1;                                             // inheritsfrom
    doomednum: 50;                                                // doomednum
    spawnstate: Ord(S_WALLTORCH1);                                // spawnstate
    spawnhealth: 1000;                                            // spawnhealth
    seestate: Ord(S_NULL);                                        // seestate
    seesound: Ord(sfx_None);                                      // seesound
    reactiontime: 8;                                              // reactiontime
    attacksound: Ord(sfx_None);                                   // attacksound
    painstate: Ord(S_NULL);                                       // painstate
    painchance: 0;                                                // painchance
    painsound: Ord(sfx_None);                                     // painsound
    meleestate: Ord(S_NULL);                                      // meleestate
    missilestate: Ord(S_NULL);                                    // missilestate
    crashstate: Ord(S_NULL);                                      // crashstate
    deathstate: Ord(S_NULL);                                      // deathstate
    xdeathstate: Ord(S_NULL);                                     // xdeathstate
    deathsound: Ord(sfx_None);                                    // deathsound
    speed: 0;                                                     // speed
    radius: 20 * FRACUNIT;                                        // radius
    height: 16 * FRACUNIT;                                        // height
    mass: 100;                                                    // mass
    damage: 0;                                                    // damage
    activesound: Ord(sfx_None);                                   // activesound
    flags: MF_NOGRAVITY;                                          // flags
    flags2: 0;                                                    // flags2
    pushfactor: DEFPUSHFACTOR;                                    // pushfactor
    scale: FRACUNIT;                                              // scale
    gravity: FRACUNIT;                                            // gravity
    flags3_ex: 0;                                                 // flags3_ex
    flags4_ex: 0;                                                 // flags4_ex
   ),

   (    // MT_MISC11
    name: 'Hanging Corpse';
    inheritsfrom: -1;                                             // inheritsfrom
    doomednum: 51;                                                // doomednum
    spawnstate: Ord(S_HANGINGCORPSE);                             // spawnstate
    spawnhealth: 1000;                                            // spawnhealth
    seestate: Ord(S_NULL);                                        // seestate
    seesound: Ord(sfx_None);                                      // seesound
    reactiontime: 8;                                              // reactiontime
    attacksound: Ord(sfx_None);                                   // attacksound
    painstate: Ord(S_NULL);                                       // painstate
    painchance: 0;                                                // painchance
    painsound: Ord(sfx_None);                                     // painsound
    meleestate: Ord(S_NULL);                                      // meleestate
    missilestate: Ord(S_NULL);                                    // missilestate
    crashstate: Ord(S_NULL);                                      // crashstate
    deathstate: Ord(S_NULL);                                      // deathstate
    xdeathstate: Ord(S_NULL);                                     // xdeathstate
    deathsound: Ord(sfx_None);                                    // deathsound
    speed: 0;                                                     // speed
    radius: 8 * FRACUNIT;                                         // radius
    height: 104 * FRACUNIT;                                       // height
    mass: 100;                                                    // mass
    damage: 0;                                                    // damage
    activesound: Ord(sfx_None);                                   // activesound
    flags: MF_SOLID or MF_SPAWNCEILING or MF_NOGRAVITY;           // flags
    flags2: 0;                                                    // flags2
    pushfactor: DEFPUSHFACTOR;                                    // pushfactor
    scale: FRACUNIT;                                              // scale
    gravity: FRACUNIT;                                            // gravity
    flags3_ex: 0;                                                 // flags3_ex
    flags4_ex: 0;                                                 // flags4_ex
   ),

   (    // MT_KEYGIZMOBLUE
    name: 'Blue Key Marker';
    inheritsfrom: -1;                                             // inheritsfrom
    doomednum: 94;                                                // doomednum
    spawnstate: Ord(S_KEYGIZMO1);                                 // spawnstate
    spawnhealth: 1000;                                            // spawnhealth
    seestate: Ord(S_NULL);                                        // seestate
    seesound: Ord(sfx_None);                                      // seesound
    reactiontime: 8;                                              // reactiontime
    attacksound: Ord(sfx_None);                                   // attacksound
    painstate: Ord(S_NULL);                                       // painstate
    painchance: 0;                                                // painchance
    painsound: Ord(sfx_None);                                     // painsound
    meleestate: Ord(S_NULL);                                      // meleestate
    missilestate: Ord(S_NULL);                                    // missilestate
    crashstate: Ord(S_NULL);                                      // crashstate
    deathstate: Ord(S_NULL);                                      // deathstate
    xdeathstate: Ord(S_NULL);                                     // xdeathstate
    deathsound: Ord(sfx_None);                                    // deathsound
    speed: 0;                                                     // speed
    radius: 16 * FRACUNIT;                                        // radius
    height: 50 * FRACUNIT;                                        // height
    mass: 100;                                                    // mass
    damage: 0;                                                    // damage
    activesound: Ord(sfx_None);                                   // activesound
    flags: MF_SOLID;                                              // flags
    flags2: 0;                                                    // flags2
    pushfactor: DEFPUSHFACTOR;                                    // pushfactor
    scale: FRACUNIT;                                              // scale
    gravity: FRACUNIT;                                            // gravity
    flags3_ex: 0;                                                 // flags3_ex
    flags4_ex: 0;                                                 // flags4_ex
   ),

   (    // MT_KEYGIZMOGREEN
    name: 'Green Key Marker';
    inheritsfrom: -1;                                             // inheritsfrom
    doomednum: 95;                                                // doomednum
    spawnstate: Ord(S_KEYGIZMO1);                                 // spawnstate
    spawnhealth: 1000;                                            // spawnhealth
    seestate: Ord(S_NULL);                                        // seestate
    seesound: Ord(sfx_None);                                      // seesound
    reactiontime: 8;                                              // reactiontime
    attacksound: Ord(sfx_None);                                   // attacksound
    painstate: Ord(S_NULL);                                       // painstate
    painchance: 0;                                                // painchance
    painsound: Ord(sfx_None);                                     // painsound
    meleestate: Ord(S_NULL);                                      // meleestate
    missilestate: Ord(S_NULL);                                    // missilestate
    crashstate: Ord(S_NULL);                                      // crashstate
    deathstate: Ord(S_NULL);                                      // deathstate
    xdeathstate: Ord(S_NULL);                                     // xdeathstate
    deathsound: Ord(sfx_None);                                    // deathsound
    speed: 0;                                                     // speed
    radius: 16 * FRACUNIT;                                        // radius
    height: 50 * FRACUNIT;                                        // height
    mass: 100;                                                    // mass
    damage: 0;                                                    // damage
    activesound: Ord(sfx_None);                                   // activesound
    flags: MF_SOLID;                                              // flags
    flags2: 0;                                                    // flags2
    pushfactor: DEFPUSHFACTOR;                                    // pushfactor
    scale: FRACUNIT;                                              // scale
    gravity: FRACUNIT;                                            // gravity
    flags3_ex: 0;                                                 // flags3_ex
    flags4_ex: 0;                                                 // flags4_ex
   ),

   (    // MT_KEYGIZMOYELLOW
    name: 'Yellow Key Marker';
    inheritsfrom: -1;                                             // inheritsfrom
    doomednum: 96;                                                // doomednum
    spawnstate: Ord(S_KEYGIZMO1);                                 // spawnstate
    spawnhealth: 1000;                                            // spawnhealth
    seestate: Ord(S_NULL);                                        // seestate
    seesound: Ord(sfx_None);                                      // seesound
    reactiontime: 8;                                              // reactiontime
    attacksound: Ord(sfx_None);                                   // attacksound
    painstate: Ord(S_NULL);                                       // painstate
    painchance: 0;                                                // painchance
    painsound: Ord(sfx_None);                                     // painsound
    meleestate: Ord(S_NULL);                                      // meleestate
    missilestate: Ord(S_NULL);                                    // missilestate
    crashstate: Ord(S_NULL);                                      // crashstate
    deathstate: Ord(S_NULL);                                      // deathstate
    xdeathstate: Ord(S_NULL);                                     // xdeathstate
    deathsound: Ord(sfx_None);                                    // deathsound
    speed: 0;                                                     // speed
    radius: 16 * FRACUNIT;                                        // radius
    height: 50 * FRACUNIT;                                        // height
    mass: 100;                                                    // mass
    damage: 0;                                                    // damage
    activesound: Ord(sfx_None);                                   // activesound
    flags: MF_SOLID;                                              // flags
    flags2: 0;                                                    // flags2
    pushfactor: DEFPUSHFACTOR;                                    // pushfactor
    scale: FRACUNIT;                                              // scale
    gravity: FRACUNIT;                                            // gravity
    flags3_ex: 0;                                                 // flags3_ex
    flags4_ex: 0;                                                 // flags4_ex
   ),

   (    // MT_KEYGIZMOFLOAT
    name: 'MT_KEYGIZMOFLOAT';
    inheritsfrom: -1;                                             // inheritsfrom
    doomednum: -1;                                                // doomednum
    spawnstate: Ord(S_KGZ_START);                                 // spawnstate
    spawnhealth: 1000;                                            // spawnhealth
    seestate: Ord(S_NULL);                                        // seestate
    seesound: Ord(sfx_None);                                      // seesound
    reactiontime: 8;                                              // reactiontime
    attacksound: Ord(sfx_None);                                   // attacksound
    painstate: Ord(S_NULL);                                       // painstate
    painchance: 0;                                                // painchance
    painsound: Ord(sfx_None);                                     // painsound
    meleestate: Ord(S_NULL);                                      // meleestate
    missilestate: Ord(S_NULL);                                    // missilestate
    crashstate: Ord(S_NULL);                                      // crashstate
    deathstate: Ord(S_NULL);                                      // deathstate
    xdeathstate: Ord(S_NULL);                                     // xdeathstate
    deathsound: Ord(sfx_None);                                    // deathsound
    speed: 0;                                                     // speed
    radius: 16 * FRACUNIT;                                        // radius
    height: 16 * FRACUNIT;                                        // height
    mass: 100;                                                    // mass
    damage: 0;                                                    // damage
    activesound: Ord(sfx_None);                                   // activesound
    flags: MF_SOLID or MF_NOGRAVITY;                              // flags
    flags2: 0;                                                    // flags2
    pushfactor: DEFPUSHFACTOR;                                    // pushfactor
    scale: FRACUNIT;                                              // scale
    gravity: FRACUNIT;                                            // gravity
    flags3_ex: 0;                                                 // flags3_ex
    flags4_ex: 0;                                                 // flags4_ex
   ),

   (    // MT_MISC12
    name: 'Volcano';
    inheritsfrom: -1;                                             // inheritsfrom
    doomednum: 87;                                                // doomednum
    spawnstate: Ord(S_VOLCANO1);                                  // spawnstate
    spawnhealth: 1000;                                            // spawnhealth
    seestate: Ord(S_NULL);                                        // seestate
    seesound: Ord(sfx_None);                                      // seesound
    reactiontime: 8;                                              // reactiontime
    attacksound: Ord(sfx_None);                                   // attacksound
    painstate: Ord(S_NULL);                                       // painstate
    painchance: 0;                                                // painchance
    painsound: Ord(sfx_None);                                     // painsound
    meleestate: Ord(S_NULL);                                      // meleestate
    missilestate: Ord(S_NULL);                                    // missilestate
    crashstate: Ord(S_NULL);                                      // crashstate
    deathstate: Ord(S_NULL);                                      // deathstate
    xdeathstate: Ord(S_NULL);                                     // xdeathstate
    deathsound: Ord(sfx_None);                                    // deathsound
    speed: 0;                                                     // speed
    radius: 12 * FRACUNIT;                                        // radius
    height: 20 * FRACUNIT;                                        // height
    mass: 100;                                                    // mass
    damage: 0;                                                    // damage
    activesound: Ord(sfx_None);                                   // activesound
    flags: MF_SOLID;                                              // flags
    flags2: 0;                                                    // flags2
    pushfactor: DEFPUSHFACTOR;                                    // pushfactor
    scale: FRACUNIT;                                              // scale
    gravity: FRACUNIT;                                            // gravity
    flags3_ex: 0;                                                 // flags3_ex
    flags4_ex: 0;                                                 // flags4_ex
   ),

   (    // MT_VOLCANOBLAST
    name: 'MT_VOLCANOBLAST';
    inheritsfrom: -1;                                             // inheritsfrom
    doomednum: -1;                                                // doomednum
    spawnstate: Ord(S_VOLCANOBALL1);                              // spawnstate
    spawnhealth: 1000;                                            // spawnhealth
    seestate: Ord(S_NULL);                                        // seestate
    seesound: Ord(sfx_None);                                      // seesound
    reactiontime: 8;                                              // reactiontime
    attacksound: Ord(sfx_None);                                   // attacksound
    painstate: Ord(S_NULL);                                       // painstate
    painchance: 0;                                                // painchance
    painsound: Ord(sfx_None);                                     // painsound
    meleestate: Ord(S_NULL);                                      // meleestate
    missilestate: Ord(S_NULL);                                    // missilestate
    crashstate: Ord(S_NULL);                                      // crashstate
    deathstate: Ord(S_VOLCANOBALLX1);                             // deathstate
    xdeathstate: Ord(S_NULL);                                     // xdeathstate
    deathsound: Ord(sfx_volhit);                                  // deathsound
    speed: 2 * FRACUNIT;                                          // speed
    radius: 8 * FRACUNIT;                                         // radius
    height: 8 * FRACUNIT;                                         // height
    mass: 100;                                                    // mass
    damage: 2;                                                    // damage
    activesound: Ord(sfx_None);                                   // activesound
    flags: MF_NOBLOCKMAP or MF_MISSILE or MF_DROPOFF;             // flags
    flags2: MF2_LOGRAV or MF2_NOTELEPORT or MF2_FIREDAMAGE;       // flags2
    pushfactor: DEFPUSHFACTOR;                                    // pushfactor
    scale: FRACUNIT;                                              // scale
    gravity: FRACUNIT;                                            // gravity
    flags3_ex: 0;                                                 // flags3_ex
    flags4_ex: 0;                                                 // flags4_ex
   ),

   (    // MT_VOLCANOTBLAST
    name: 'MT_VOLCANOTBLAST';
    inheritsfrom: -1;                                             // inheritsfrom
    doomednum: -1;                                                // doomednum
    spawnstate: Ord(S_VOLCANOTBALL1);                             // spawnstate
    spawnhealth: 1000;                                            // spawnhealth
    seestate: Ord(S_NULL);                                        // seestate
    seesound: Ord(sfx_None);                                      // seesound
    reactiontime: 8;                                              // reactiontime
    attacksound: Ord(sfx_None);                                   // attacksound
    painstate: Ord(S_NULL);                                       // painstate
    painchance: 0;                                                // painchance
    painsound: Ord(sfx_None);                                     // painsound
    meleestate: Ord(S_NULL);                                      // meleestate
    missilestate: Ord(S_NULL);                                    // missilestate
    crashstate: Ord(S_NULL);                                      // crashstate
    deathstate: Ord(S_VOLCANOTBALLX1);                            // deathstate
    xdeathstate: Ord(S_NULL);                                     // xdeathstate
    deathsound: Ord(sfx_None);                                    // deathsound
    speed: 2 * FRACUNIT;                                          // speed
    radius: 8 * FRACUNIT;                                         // radius
    height: 6 * FRACUNIT;                                         // height
    mass: 100;                                                    // mass
    damage: 1;                                                    // damage
    activesound: Ord(sfx_None);                                   // activesound
    flags: MF_NOBLOCKMAP or MF_MISSILE or MF_DROPOFF;             // flags
    flags2: MF2_LOGRAV or MF2_NOTELEPORT or MF2_FIREDAMAGE;       // flags2
    flags2_ex: MF2_EX_DONOTRENDERSHADOW;                          // flags2_ex
    pushfactor: DEFPUSHFACTOR;                                    // pushfactor
    scale: FRACUNIT;                                              // scale
    gravity: FRACUNIT;                                            // gravity
    flags3_ex: 0;                                                 // flags3_ex
    flags4_ex: 0;                                                 // flags4_ex
   ),

   (    // MT_TELEGLITGEN
    name: 'Teleport Glitter';
    inheritsfrom: -1;                                             // inheritsfrom
    doomednum: 74;                                                // doomednum
    spawnstate: Ord(S_TELEGLITGEN1);                              // spawnstate
    spawnhealth: 1000;                                            // spawnhealth
    seestate: Ord(S_NULL);                                        // seestate
    seesound: Ord(sfx_None);                                      // seesound
    reactiontime: 8;                                              // reactiontime
    attacksound: Ord(sfx_None);                                   // attacksound
    painstate: Ord(S_NULL);                                       // painstate
    painchance: 0;                                                // painchance
    painsound: Ord(sfx_None);                                     // painsound
    meleestate: Ord(S_NULL);                                      // meleestate
    missilestate: Ord(S_NULL);                                    // missilestate
    crashstate: Ord(S_NULL);                                      // crashstate
    deathstate: Ord(S_NULL);                                      // deathstate
    xdeathstate: Ord(S_NULL);                                     // xdeathstate
    deathsound: Ord(sfx_None);                                    // deathsound
    speed: 0;                                                     // speed
    radius: 20 * FRACUNIT;                                        // radius
    height: 16 * FRACUNIT;                                        // height
    mass: 100;                                                    // mass
    damage: 0;                                                    // damage
    activesound: Ord(sfx_None);                                   // activesound
    flags: MF_NOBLOCKMAP or MF_NOGRAVITY or MF_NOSECTOR;          // flags
    flags2: 0;                                                    // flags2
    pushfactor: DEFPUSHFACTOR;                                    // pushfactor
    scale: FRACUNIT;                                              // scale
    gravity: FRACUNIT;                                            // gravity
    flags3_ex: 0;                                                 // flags3_ex
    flags4_ex: 0;                                                 // flags4_ex
   ),

   (    // MT_TELEGLITGEN2
    name: 'Teleport Glitter Exit';
    inheritsfrom: -1;                                             // inheritsfrom
    doomednum: 52;                                                // doomednum
    spawnstate: Ord(S_TELEGLITGEN2);                              // spawnstate
    spawnhealth: 1000;                                            // spawnhealth
    seestate: Ord(S_NULL);                                        // seestate
    seesound: Ord(sfx_None);                                      // seesound
    reactiontime: 8;                                              // reactiontime
    attacksound: Ord(sfx_None);                                   // attacksound
    painstate: Ord(S_NULL);                                       // painstate
    painchance: 0;                                                // painchance
    painsound: Ord(sfx_None);                                     // painsound
    meleestate: Ord(S_NULL);                                      // meleestate
    missilestate: Ord(S_NULL);                                    // missilestate
    crashstate: Ord(S_NULL);                                      // crashstate
    deathstate: Ord(S_NULL);                                      // deathstate
    xdeathstate: Ord(S_NULL);                                     // xdeathstate
    deathsound: Ord(sfx_None);                                    // deathsound
    speed: 0;                                                     // speed
    radius: 20 * FRACUNIT;                                        // radius
    height: 16 * FRACUNIT;                                        // height
    mass: 100;                                                    // mass
    damage: 0;                                                    // damage
    activesound: Ord(sfx_None);                                   // activesound
    flags: MF_NOBLOCKMAP or MF_NOGRAVITY or MF_NOSECTOR;          // flags
    flags2: 0;                                                    // flags2
    pushfactor: DEFPUSHFACTOR;                                    // pushfactor
    scale: FRACUNIT;                                              // scale
    gravity: FRACUNIT;                                            // gravity
    flags3_ex: 0;                                                 // flags3_ex
    flags4_ex: 0;                                                 // flags4_ex
   ),

   (    // MT_TELEGLITTER
    name: 'MT_TELEGLITTER';
    inheritsfrom: -1;                                             // inheritsfrom
    doomednum: -1;                                                // doomednum
    spawnstate: Ord(S_TELEGLITTER1_1);                            // spawnstate
    spawnhealth: 1000;                                            // spawnhealth
    seestate: Ord(S_NULL);                                        // seestate
    seesound: Ord(sfx_None);                                      // seesound
    reactiontime: 8;                                              // reactiontime
    attacksound: Ord(sfx_None);                                   // attacksound
    painstate: Ord(S_NULL);                                       // painstate
    painchance: 0;                                                // painchance
    painsound: Ord(sfx_None);                                     // painsound
    meleestate: Ord(S_NULL);                                      // meleestate
    missilestate: Ord(S_NULL);                                    // missilestate
    crashstate: Ord(S_NULL);                                      // crashstate
    deathstate: Ord(S_NULL);                                      // deathstate
    xdeathstate: Ord(S_NULL);                                     // xdeathstate
    deathsound: Ord(sfx_None);                                    // deathsound
    speed: 0;                                                     // speed
    radius: 20 * FRACUNIT;                                        // radius
    height: 16 * FRACUNIT;                                        // height
    mass: 100;                                                    // mass
    damage: 0;                                                    // damage
    activesound: Ord(sfx_None);                                   // activesound
    flags: MF_NOBLOCKMAP or MF_NOGRAVITY or MF_MISSILE;           // flags
    flags2: 0;                                                    // flags2
    pushfactor: DEFPUSHFACTOR;                                    // pushfactor
    scale: FRACUNIT;                                              // scale
    gravity: FRACUNIT;                                            // gravity
    flags3_ex: 0;                                                 // flags3_ex
    flags4_ex: 0;                                                 // flags4_ex
   ),

   (    // MT_TELEGLITTER2
    name: 'MT_TELEGLITTER2';
    inheritsfrom: -1;                                             // inheritsfrom
    doomednum: -1;                                                // doomednum
    spawnstate: Ord(S_TELEGLITTER2_1);                            // spawnstate
    spawnhealth: 1000;                                            // spawnhealth
    seestate: Ord(S_NULL);                                        // seestate
    seesound: Ord(sfx_None);                                      // seesound
    reactiontime: 8;                                              // reactiontime
    attacksound: Ord(sfx_None);                                   // attacksound
    painstate: Ord(S_NULL);                                       // painstate
    painchance: 0;                                                // painchance
    painsound: Ord(sfx_None);                                     // painsound
    meleestate: Ord(S_NULL);                                      // meleestate
    missilestate: Ord(S_NULL);                                    // missilestate
    crashstate: Ord(S_NULL);                                      // crashstate
    deathstate: Ord(S_NULL);                                      // deathstate
    xdeathstate: Ord(S_NULL);                                     // xdeathstate
    deathsound: Ord(sfx_None);                                    // deathsound
    speed: 0;                                                     // speed
    radius: 20 * FRACUNIT;                                        // radius
    height: 16 * FRACUNIT;                                        // height
    mass: 100;                                                    // mass
    damage: 0;                                                    // damage
    activesound: Ord(sfx_None);                                   // activesound
    flags: MF_NOBLOCKMAP or MF_NOGRAVITY or MF_MISSILE;           // flags
    flags2: 0;                                                    // flags2
    pushfactor: DEFPUSHFACTOR;                                    // pushfactor
    scale: FRACUNIT;                                              // scale
    gravity: FRACUNIT;                                            // gravity
    flags3_ex: 0;                                                 // flags3_ex
    flags4_ex: 0;                                                 // flags4_ex
   ),

   (    // MT_TFOG
    name: 'MT_TFOG';
    inheritsfrom: -1;                                             // inheritsfrom
    doomednum: -1;                                                // doomednum
    spawnstate: Ord(S_TFOG1);                                     // spawnstate
    spawnhealth: 1000;                                            // spawnhealth
    seestate: Ord(S_NULL);                                        // seestate
    seesound: Ord(sfx_None);                                      // seesound
    reactiontime: 8;                                              // reactiontime
    attacksound: Ord(sfx_None);                                   // attacksound
    painstate: Ord(S_NULL);                                       // painstate
    painchance: 0;                                                // painchance
    painsound: Ord(sfx_None);                                     // painsound
    meleestate: Ord(S_NULL);                                      // meleestate
    missilestate: Ord(S_NULL);                                    // missilestate
    crashstate: Ord(S_NULL);                                      // crashstate
    deathstate: Ord(S_NULL);                                      // deathstate
    xdeathstate: Ord(S_NULL);                                     // xdeathstate
    deathsound: Ord(sfx_None);                                    // deathsound
    speed: 0;                                                     // speed
    radius: 20 * FRACUNIT;                                        // radius
    height: 16 * FRACUNIT;                                        // height
    mass: 100;                                                    // mass
    damage: 0;                                                    // damage
    activesound: Ord(sfx_None);                                   // activesound
    flags: MF_NOBLOCKMAP or MF_NOGRAVITY;                         // flags
    flags2: 0;                                                    // flags2
    flags2_ex: MF2_EX_DONOTRENDERSHADOW;                          // flags2_ex
    pushfactor: DEFPUSHFACTOR;                                    // pushfactor
    scale: FRACUNIT;                                              // scale
    gravity: FRACUNIT;                                            // gravity
    flags3_ex: 0;                                                 // flags3_ex
    flags4_ex: 0;                                                 // flags4_ex
   ),

   (    // MT_TELEPORTMAN
    name: 'Teleport Landing';
    inheritsfrom: -1;                                             // inheritsfrom
    doomednum: 14;                                                // doomednum
    spawnstate: Ord(S_NULL);                                      // spawnstate
    spawnhealth: 1000;                                            // spawnhealth
    seestate: Ord(S_NULL);                                        // seestate
    seesound: Ord(sfx_None);                                      // seesound
    reactiontime: 8;                                              // reactiontime
    attacksound: Ord(sfx_None);                                   // attacksound
    painstate: Ord(S_NULL);                                       // painstate
    painchance: 0;                                                // painchance
    painsound: Ord(sfx_None);                                     // painsound
    meleestate: Ord(S_NULL);                                      // meleestate
    missilestate: Ord(S_NULL);                                    // missilestate
    crashstate: Ord(S_NULL);                                      // crashstate
    deathstate: Ord(S_NULL);                                      // deathstate
    xdeathstate: Ord(S_NULL);                                     // xdeathstate
    deathsound: Ord(sfx_None);                                    // deathsound
    speed: 0;                                                     // speed
    radius: 20 * FRACUNIT;                                        // radius
    height: 16 * FRACUNIT;                                        // height
    mass: 100;                                                    // mass
    damage: 0;                                                    // damage
    activesound: Ord(sfx_None);                                   // activesound
    flags: MF_NOBLOCKMAP or MF_NOSECTOR;                          // flags
    flags2: 0;                                                    // flags2
    pushfactor: DEFPUSHFACTOR;                                    // pushfactor
    scale: FRACUNIT;                                              // scale
    gravity: FRACUNIT;                                            // gravity
    flags3_ex: 0;                                                 // flags3_ex
    flags4_ex: 0;                                                 // flags4_ex
   ),

   (    // MT_STAFFPUFF
    name: 'MT_STAFFPUFF';
    inheritsfrom: -1;                                             // inheritsfrom
    doomednum: -1;                                                // doomednum
    spawnstate: Ord(S_STAFFPUFF1);                                // spawnstate
    spawnhealth: 1000;                                            // spawnhealth
    seestate: Ord(S_NULL);                                        // seestate
    seesound: Ord(sfx_None);                                      // seesound
    reactiontime: 8;                                              // reactiontime
    attacksound: Ord(sfx_stfhit);                                 // attacksound
    painstate: Ord(S_NULL);                                       // painstate
    painchance: 0;                                                // painchance
    painsound: Ord(sfx_None);                                     // painsound
    meleestate: Ord(S_NULL);                                      // meleestate
    missilestate: Ord(S_NULL);                                    // missilestate
    crashstate: Ord(S_NULL);                                      // crashstate
    deathstate: Ord(S_NULL);                                      // deathstate
    xdeathstate: Ord(S_NULL);                                     // xdeathstate
    deathsound: Ord(sfx_None);                                    // deathsound
    speed: 0;                                                     // speed
    radius: 20 * FRACUNIT;                                        // radius
    height: 16 * FRACUNIT;                                        // height
    mass: 100;                                                    // mass
    damage: 0;                                                    // damage
    activesound: Ord(sfx_None);                                   // activesound
    flags: MF_NOBLOCKMAP or MF_NOGRAVITY;                         // flags
    flags2: 0;                                                    // flags2
    flags2_ex: MF2_EX_DONOTRENDERSHADOW;                          // flags2_ex
    pushfactor: DEFPUSHFACTOR;                                    // pushfactor
    scale: FRACUNIT;                                              // scale
    gravity: FRACUNIT;                                            // gravity
    flags3_ex: 0;                                                 // flags3_ex
    flags4_ex: 0;                                                 // flags4_ex
   ),

   (    // MT_STAFFPUFF2
    name: 'MT_STAFFPUFF2';
    inheritsfrom: -1;                                             // inheritsfrom
    doomednum: -1;                                                // doomednum
    spawnstate: Ord(S_STAFFPUFF2_1);                              // spawnstate
    spawnhealth: 1000;                                            // spawnhealth
    seestate: Ord(S_NULL);                                        // seestate
    seesound: Ord(sfx_None);                                      // seesound
    reactiontime: 8;                                              // reactiontime
    attacksound: Ord(sfx_stfpow);                                 // attacksound
    painstate: Ord(S_NULL);                                       // painstate
    painchance: 0;                                                // painchance
    painsound: Ord(sfx_None);                                     // painsound
    meleestate: Ord(S_NULL);                                      // meleestate
    missilestate: Ord(S_NULL);                                    // missilestate
    crashstate: Ord(S_NULL);                                      // crashstate
    deathstate: Ord(S_NULL);                                      // deathstate
    xdeathstate: Ord(S_NULL);                                     // xdeathstate
    deathsound: Ord(sfx_None);                                    // deathsound
    speed: 0;                                                     // speed
    radius: 20 * FRACUNIT;                                        // radius
    height: 16 * FRACUNIT;                                        // height
    mass: 100;                                                    // mass
    damage: 0;                                                    // damage
    activesound: Ord(sfx_None);                                   // activesound
    flags: MF_NOBLOCKMAP or MF_NOGRAVITY;                         // flags
    flags2: 0;                                                    // flags2
    flags2_ex: MF2_EX_DONOTRENDERSHADOW;                          // flags2_ex
    pushfactor: DEFPUSHFACTOR;                                    // pushfactor
    scale: FRACUNIT;                                              // scale
    gravity: FRACUNIT;                                            // gravity
    flags3_ex: 0;                                                 // flags3_ex
    flags4_ex: 0;                                                 // flags4_ex
   ),

   (    // MT_BEAKPUFF
    name: 'MT_BEAKPUFF';
    inheritsfrom: -1;                                             // inheritsfrom
    doomednum: -1;                                                // doomednum
    spawnstate: Ord(S_STAFFPUFF1);                                // spawnstate
    spawnhealth: 1000;                                            // spawnhealth
    seestate: Ord(S_NULL);                                        // seestate
    seesound: Ord(sfx_None);                                      // seesound
    reactiontime: 8;                                              // reactiontime
    attacksound: Ord(sfx_chicatk);                                // attacksound
    painstate: Ord(S_NULL);                                       // painstate
    painchance: 0;                                                // painchance
    painsound: Ord(sfx_None);                                     // painsound
    meleestate: Ord(S_NULL);                                      // meleestate
    missilestate: Ord(S_NULL);                                    // missilestate
    crashstate: Ord(S_NULL);                                      // crashstate
    deathstate: Ord(S_NULL);                                      // deathstate
    xdeathstate: Ord(S_NULL);                                     // xdeathstate
    deathsound: Ord(sfx_None);                                    // deathsound
    speed: 0;                                                     // speed
    radius: 20 * FRACUNIT;                                        // radius
    height: 16 * FRACUNIT;                                        // height
    mass: 100;                                                    // mass
    damage: 0;                                                    // damage
    activesound: Ord(sfx_None);                                   // activesound
    flags: MF_NOBLOCKMAP or MF_NOGRAVITY;                         // flags
    flags2: 0;                                                    // flags2
    flags2_ex: MF2_EX_DONOTRENDERSHADOW;                          // flags2_ex
    pushfactor: DEFPUSHFACTOR;                                    // pushfactor
    scale: FRACUNIT;                                              // scale
    gravity: FRACUNIT;                                            // gravity
    flags3_ex: 0;                                                 // flags3_ex
    flags4_ex: 0;                                                 // flags4_ex
   ),

   (    // MT_MISC13
    name: 'Gauntlets Of The Necromancer';
    inheritsfrom: -1;                                             // inheritsfrom
    doomednum: 2005;                                              // doomednum
    spawnstate: Ord(S_WGNT);                                      // spawnstate
    spawnhealth: 1000;                                            // spawnhealth
    seestate: Ord(S_NULL);                                        // seestate
    seesound: Ord(sfx_None);                                      // seesound
    reactiontime: 8;                                              // reactiontime
    attacksound: Ord(sfx_None);                                   // attacksound
    painstate: Ord(S_NULL);                                       // painstate
    painchance: 0;                                                // painchance
    painsound: Ord(sfx_None);                                     // painsound
    meleestate: Ord(S_NULL);                                      // meleestate
    missilestate: Ord(S_NULL);                                    // missilestate
    crashstate: Ord(S_NULL);                                      // crashstate
    deathstate: Ord(S_NULL);                                      // deathstate
    xdeathstate: Ord(S_NULL);                                     // xdeathstate
    deathsound: Ord(sfx_None);                                    // deathsound
    speed: 0;                                                     // speed
    radius: 20 * FRACUNIT;                                        // radius
    height: 16 * FRACUNIT;                                        // height
    mass: 100;                                                    // mass
    damage: 0;                                                    // damage
    activesound: Ord(sfx_None);                                   // activesound
    flags: MF_SPECIAL;                                            // flags
    flags2: 0;                                                    // flags2
    pushfactor: DEFPUSHFACTOR;                                    // pushfactor
    scale: FRACUNIT;                                              // scale
    gravity: FRACUNIT;                                            // gravity
    flags3_ex: 0;                                                 // flags3_ex
    flags4_ex: 0;                                                 // flags4_ex
   ),

   (    // MT_GAUNTLETPUFF1
    name: 'MT_GAUNTLETPUFF1';
    inheritsfrom: -1;                                             // inheritsfrom
    doomednum: -1;                                                // doomednum
    spawnstate: Ord(S_GAUNTLETPUFF1_1);                           // spawnstate
    spawnhealth: 1000;                                            // spawnhealth
    seestate: Ord(S_NULL);                                        // seestate
    seesound: Ord(sfx_None);                                      // seesound
    reactiontime: 8;                                              // reactiontime
    attacksound: Ord(sfx_None);                                   // attacksound
    painstate: Ord(S_NULL);                                       // painstate
    painchance: 0;                                                // painchance
    painsound: Ord(sfx_None);                                     // painsound
    meleestate: Ord(S_NULL);                                      // meleestate
    missilestate: Ord(S_NULL);                                    // missilestate
    crashstate: Ord(S_NULL);                                      // crashstate
    deathstate: Ord(S_NULL);                                      // deathstate
    xdeathstate: Ord(S_NULL);                                     // xdeathstate
    deathsound: Ord(sfx_None);                                    // deathsound
    speed: 0;                                                     // speed
    radius: 20 * FRACUNIT;                                        // radius
    height: 16 * FRACUNIT;                                        // height
    mass: 100;                                                    // mass
    damage: 0;                                                    // damage
    activesound: Ord(sfx_None);                                   // activesound
    flags: MF_NOBLOCKMAP or MF_NOGRAVITY or MF_SHADOW;            // flags
    flags2: 0;                                                    // flags2
    flags2_ex: MF2_EX_DONOTRENDERSHADOW;                          // flags2_ex
    pushfactor: DEFPUSHFACTOR;                                    // pushfactor
    scale: FRACUNIT;                                              // scale
    gravity: FRACUNIT;                                            // gravity
    flags3_ex: 0;                                                 // flags3_ex
    flags4_ex: 0;                                                 // flags4_ex
   ),

   (    // MT_GAUNTLETPUFF2
    name: 'MT_GAUNTLETPUFF2';
    inheritsfrom: -1;                                             // inheritsfrom
    doomednum: -1;                                                // doomednum
    spawnstate: Ord(S_GAUNTLETPUFF2_1);                           // spawnstate
    spawnhealth: 1000;                                            // spawnhealth
    seestate: Ord(S_NULL);                                        // seestate
    seesound: Ord(sfx_None);                                      // seesound
    reactiontime: 8;                                              // reactiontime
    attacksound: Ord(sfx_None);                                   // attacksound
    painstate: Ord(S_NULL);                                       // painstate
    painchance: 0;                                                // painchance
    painsound: Ord(sfx_None);                                     // painsound
    meleestate: Ord(S_NULL);                                      // meleestate
    missilestate: Ord(S_NULL);                                    // missilestate
    crashstate: Ord(S_NULL);                                      // crashstate
    deathstate: Ord(S_NULL);                                      // deathstate
    xdeathstate: Ord(S_NULL);                                     // xdeathstate
    deathsound: Ord(sfx_None);                                    // deathsound
    speed: 0;                                                     // speed
    radius: 20 * FRACUNIT;                                        // radius
    height: 16 * FRACUNIT;                                        // height
    mass: 100;                                                    // mass
    damage: 0;                                                    // damage
    activesound: Ord(sfx_None);                                   // activesound
    flags: MF_NOBLOCKMAP or MF_NOGRAVITY or MF_SHADOW;            // flags
    flags2: 0;                                                    // flags2
    flags2_ex: MF2_EX_DONOTRENDERSHADOW;                          // flags2_ex
    pushfactor: DEFPUSHFACTOR;                                    // pushfactor
    scale: FRACUNIT;                                              // scale
    gravity: FRACUNIT;                                            // gravity
    flags3_ex: 0;                                                 // flags3_ex
    flags4_ex: 0;                                                 // flags4_ex
   ),

   (    // MT_MISC14
    name: 'Dragon Claw';
    inheritsfrom: -1;                                             // inheritsfrom
    doomednum: 53;                                                // doomednum
    spawnstate: Ord(S_BLSR);                                      // spawnstate
    spawnhealth: 1000;                                            // spawnhealth
    seestate: Ord(S_NULL);                                        // seestate
    seesound: Ord(sfx_None);                                      // seesound
    reactiontime: 8;                                              // reactiontime
    attacksound: Ord(sfx_None);                                   // attacksound
    painstate: Ord(S_NULL);                                       // painstate
    painchance: 0;                                                // painchance
    painsound: Ord(sfx_None);                                     // painsound
    meleestate: Ord(S_NULL);                                      // meleestate
    missilestate: Ord(S_NULL);                                    // missilestate
    crashstate: Ord(S_NULL);                                      // crashstate
    deathstate: Ord(S_NULL);                                      // deathstate
    xdeathstate: Ord(S_NULL);                                     // xdeathstate
    deathsound: Ord(sfx_None);                                    // deathsound
    speed: 0;                                                     // speed
    radius: 20 * FRACUNIT;                                        // radius
    height: 16 * FRACUNIT;                                        // height
    mass: 100;                                                    // mass
    damage: 0;                                                    // damage
    activesound: Ord(sfx_None);                                   // activesound
    flags: MF_SPECIAL;                                            // flags
    flags2: 0;                                                    // flags2
    pushfactor: DEFPUSHFACTOR;                                    // pushfactor
    scale: FRACUNIT;                                              // scale
    gravity: FRACUNIT;                                            // gravity
    flags3_ex: 0;                                                 // flags3_ex
    flags4_ex: 0;                                                 // flags4_ex
   ),

   (    // MT_BLASTERFX1
    name: 'MT_BLASTERFX1';
    inheritsfrom: -1;                                             // inheritsfrom
    doomednum: -1;                                                // doomednum
    spawnstate: Ord(S_BLASTERFX1_1);                              // spawnstate
    spawnhealth: 1000;                                            // spawnhealth
    seestate: Ord(S_NULL);                                        // seestate
    seesound: Ord(sfx_None);                                      // seesound
    reactiontime: 8;                                              // reactiontime
    attacksound: Ord(sfx_None);                                   // attacksound
    painstate: Ord(S_NULL);                                       // painstate
    painchance: 0;                                                // painchance
    painsound: Ord(sfx_None);                                     // painsound
    meleestate: Ord(S_NULL);                                      // meleestate
    missilestate: Ord(S_NULL);                                    // missilestate
    crashstate: Ord(S_NULL);                                      // crashstate
    deathstate: Ord(S_BLASTERFXI1_1);                             // deathstate
    xdeathstate: Ord(S_NULL);                                     // xdeathstate
    deathsound: Ord(sfx_blshit);                                  // deathsound
    speed: 184 * FRACUNIT;                                        // speed
    radius: 12 * FRACUNIT;                                        // radius
    height: 8 * FRACUNIT;                                         // height
    mass: 100;                                                    // mass
    damage: 2;                                                    // damage
    activesound: Ord(sfx_None);                                   // activesound
    flags: MF_NOBLOCKMAP or MF_MISSILE or MF_DROPOFF or MF_NOGRAVITY;    // flags
    flags2: MF2_NOTELEPORT;                                       // flags2
    pushfactor: DEFPUSHFACTOR;                                    // pushfactor
    scale: FRACUNIT;                                              // scale
    gravity: FRACUNIT;                                            // gravity
    flags3_ex: 0;                                                 // flags3_ex
    flags4_ex: 0;                                                 // flags4_ex
   ),

   (    // MT_BLASTERSMOKE
    name: 'MT_BLASTERSMOKE';
    inheritsfrom: -1;                                             // inheritsfrom
    doomednum: -1;                                                // doomednum
    spawnstate: Ord(S_BLASTERSMOKE1);                             // spawnstate
    spawnhealth: 1000;                                            // spawnhealth
    seestate: Ord(S_NULL);                                        // seestate
    seesound: Ord(sfx_None);                                      // seesound
    reactiontime: 8;                                              // reactiontime
    attacksound: Ord(sfx_None);                                   // attacksound
    painstate: Ord(S_NULL);                                       // painstate
    painchance: 0;                                                // painchance
    painsound: Ord(sfx_None);                                     // painsound
    meleestate: Ord(S_NULL);                                      // meleestate
    missilestate: Ord(S_NULL);                                    // missilestate
    crashstate: Ord(S_NULL);                                      // crashstate
    deathstate: Ord(S_NULL);                                      // deathstate
    xdeathstate: Ord(S_NULL);                                     // xdeathstate
    deathsound: Ord(sfx_None);                                    // deathsound
    speed: 0;                                                     // speed
    radius: 20 * FRACUNIT;                                        // radius
    height: 16 * FRACUNIT;                                        // height
    mass: 100;                                                    // mass
    damage: 0;                                                    // damage
    activesound: Ord(sfx_None);                                   // activesound
    flags: MF_NOBLOCKMAP or MF_NOGRAVITY or MF_SHADOW;            // flags
    flags2: MF2_NOTELEPORT or MF2_CANNOTPUSH;                     // flags2
    flags2_ex: MF2_EX_DONOTRENDERSHADOW;                          // flags2_ex
    pushfactor: DEFPUSHFACTOR;                                    // pushfactor
    scale: FRACUNIT;                                              // scale
    gravity: FRACUNIT;                                            // gravity
    flags3_ex: 0;                                                 // flags3_ex
    flags4_ex: 0;                                                 // flags4_ex
   ),

   (    // MT_RIPPER
    name: 'MT_RIPPER';
    inheritsfrom: -1;                                             // inheritsfrom
    doomednum: -1;                                                // doomednum
    spawnstate: Ord(S_RIPPER1);                                   // spawnstate
    spawnhealth: 1000;                                            // spawnhealth
    seestate: Ord(S_NULL);                                        // seestate
    seesound: 0;                                                  // seesound
    reactiontime: 8;                                              // reactiontime
    attacksound: Ord(sfx_None);                                   // attacksound
    painstate: Ord(S_NULL);                                       // painstate
    painchance: 0;                                                // painchance
    painsound: Ord(sfx_None);                                     // painsound
    meleestate: Ord(S_NULL);                                      // meleestate
    missilestate: Ord(S_NULL);                                    // missilestate
    crashstate: Ord(S_NULL);                                      // crashstate
    deathstate: Ord(S_RIPPERX1);                                  // deathstate
    xdeathstate: Ord(S_NULL);                                     // xdeathstate
    deathsound: Ord(sfx_hrnhit);                                  // deathsound
    speed: 14 * FRACUNIT;                                         // speed
    radius: 8 * FRACUNIT;                                         // radius
    height: 6 * FRACUNIT;                                         // height
    mass: 100;                                                    // mass
    damage: 1;                                                    // damage
    activesound: Ord(sfx_None);                                   // activesound
    flags: MF_NOBLOCKMAP or MF_MISSILE or MF_DROPOFF or MF_NOGRAVITY;    // flags
    flags2: MF2_NOTELEPORT or MF2_RIP;                            // flags2
    pushfactor: DEFPUSHFACTOR;                                    // pushfactor
    scale: FRACUNIT;                                              // scale
    gravity: FRACUNIT;                                            // gravity
    flags3_ex: 0;                                                 // flags3_ex
    flags4_ex: 0;                                                 // flags4_ex
   ),

   (    // MT_BLASTERPUFF1
    name: 'MT_BLASTERPUFF1';
    inheritsfrom: -1;                                             // inheritsfrom
    doomednum: -1;                                                // doomednum
    spawnstate: Ord(S_BLASTERPUFF1_1);                            // spawnstate
    spawnhealth: 1000;                                            // spawnhealth
    seestate: Ord(S_NULL);                                        // seestate
    seesound: Ord(sfx_None);                                      // seesound
    reactiontime: 8;                                              // reactiontime
    attacksound: Ord(sfx_None);                                   // attacksound
    painstate: Ord(S_NULL);                                       // painstate
    painchance: 0;                                                // painchance
    painsound: Ord(sfx_None);                                     // painsound
    meleestate: Ord(S_NULL);                                      // meleestate
    missilestate: Ord(S_NULL);                                    // missilestate
    crashstate: Ord(S_NULL);                                      // crashstate
    deathstate: Ord(S_NULL);                                      // deathstate
    xdeathstate: Ord(S_NULL);                                     // xdeathstate
    deathsound: Ord(sfx_None);                                    // deathsound
    speed: 0;                                                     // speed
    radius: 20 * FRACUNIT;                                        // radius
    height: 16 * FRACUNIT;                                        // height
    mass: 100;                                                    // mass
    damage: 0;                                                    // damage
    activesound: Ord(sfx_None);                                   // activesound
    flags: MF_NOBLOCKMAP or MF_NOGRAVITY;                         // flags
    flags2: 0;                                                    // flags2
    flags2_ex: MF2_EX_DONOTRENDERSHADOW;                          // flags2_ex
    pushfactor: DEFPUSHFACTOR;                                    // pushfactor
    scale: FRACUNIT;                                              // scale
    gravity: FRACUNIT;                                            // gravity
    flags3_ex: 0;                                                 // flags3_ex
    flags4_ex: 0;                                                 // flags4_ex
   ),

   (    // MT_BLASTERPUFF2
    name: 'MT_BLASTERPUFF2';
    inheritsfrom: -1;                                             // inheritsfrom
    doomednum: -1;                                                // doomednum
    spawnstate: Ord(S_BLASTERPUFF2_1);                            // spawnstate
    spawnhealth: 1000;                                            // spawnhealth
    seestate: Ord(S_NULL);                                        // seestate
    seesound: Ord(sfx_None);                                      // seesound
    reactiontime: 8;                                              // reactiontime
    attacksound: Ord(sfx_None);                                   // attacksound
    painstate: Ord(S_NULL);                                       // painstate
    painchance: 0;                                                // painchance
    painsound: Ord(sfx_None);                                     // painsound
    meleestate: Ord(S_NULL);                                      // meleestate
    missilestate: Ord(S_NULL);                                    // missilestate
    crashstate: Ord(S_NULL);                                      // crashstate
    deathstate: Ord(S_NULL);                                      // deathstate
    xdeathstate: Ord(S_NULL);                                     // xdeathstate
    deathsound: Ord(sfx_None);                                    // deathsound
    speed: 0;                                                     // speed
    radius: 20 * FRACUNIT;                                        // radius
    height: 16 * FRACUNIT;                                        // height
    mass: 100;                                                    // mass
    damage: 0;                                                    // damage
    activesound: Ord(sfx_None);                                   // activesound
    flags: MF_NOBLOCKMAP or MF_NOGRAVITY;                         // flags
    flags2: 0;                                                    // flags2
    flags2_ex: MF2_EX_DONOTRENDERSHADOW;                          // flags2_ex
    pushfactor: DEFPUSHFACTOR;                                    // pushfactor
    scale: FRACUNIT;                                              // scale
    gravity: FRACUNIT;                                            // gravity
    flags3_ex: 0;                                                 // flags3_ex
    flags4_ex: 0;                                                 // flags4_ex
   ),

   (    // MT_WMACE
    name: 'Firemace';
    inheritsfrom: -1;                                             // inheritsfrom
    doomednum: 2002;                                              // doomednum
    spawnstate: Ord(S_WMCE);                                      // spawnstate
    spawnhealth: 1000;                                            // spawnhealth
    seestate: Ord(S_NULL);                                        // seestate
    seesound: Ord(sfx_None);                                      // seesound
    reactiontime: 8;                                              // reactiontime
    attacksound: Ord(sfx_None);                                   // attacksound
    painstate: Ord(S_NULL);                                       // painstate
    painchance: 0;                                                // painchance
    painsound: Ord(sfx_None);                                     // painsound
    meleestate: Ord(S_NULL);                                      // meleestate
    missilestate: Ord(S_NULL);                                    // missilestate
    crashstate: Ord(S_NULL);                                      // crashstate
    deathstate: Ord(S_NULL);                                      // deathstate
    xdeathstate: Ord(S_NULL);                                     // xdeathstate
    deathsound: Ord(sfx_None);                                    // deathsound
    speed: 0;                                                     // speed
    radius: 20 * FRACUNIT;                                        // radius
    height: 16 * FRACUNIT;                                        // height
    mass: 100;                                                    // mass
    damage: 0;                                                    // damage
    activesound: Ord(sfx_None);                                   // activesound
    flags: MF_SPECIAL;                                            // flags
    flags2: 0;                                                    // flags2
    pushfactor: DEFPUSHFACTOR;                                    // pushfactor
    scale: FRACUNIT;                                              // scale
    gravity: FRACUNIT;                                            // gravity
    flags3_ex: 0;                                                 // flags3_ex
    flags4_ex: 0;                                                 // flags4_ex
   ),

   (    //
    name: 'MT_MACEFX1';
    inheritsfrom: -1;                                             // inheritsfrom
    doomednum: -1;                                                // doomednum
    spawnstate: Ord(S_MACEFX1_1);                                 // spawnstate
    spawnhealth: 1000;                                            // spawnhealth
    seestate: Ord(S_NULL);                                        // seestate
    seesound: Ord(sfx_lobsht);                                    // seesound
    reactiontime: 8;                                              // reactiontime
    attacksound: Ord(sfx_None);                                   // attacksound
    painstate: Ord(S_NULL);                                       // painstate
    painchance: 0;                                                // painchance
    painsound: Ord(sfx_None);                                     // painsound
    meleestate: Ord(S_NULL);                                      // meleestate
    missilestate: Ord(S_NULL);                                    // missilestate
    crashstate: Ord(S_NULL);                                      // crashstate
    deathstate: Ord(S_MACEFXI1_1);                                // deathstate
    xdeathstate: Ord(S_NULL);                                     // xdeathstate
    deathsound: 0;                                                // deathsound
    speed: 20 * FRACUNIT;                                         // speed
    radius: 8 * FRACUNIT;                                         // radius
    height: 6 * FRACUNIT;                                         // height
    mass: 100;                                                    // mass
    damage: 2;                                                    // damage
    activesound: Ord(sfx_None);                                   // activesound
    flags: MF_NOBLOCKMAP or MF_MISSILE or MF_DROPOFF or MF_NOGRAVITY;    // flags
    flags2: MF2_FLOORBOUNCE or MF2_THRUGHOST or MF2_NOTELEPORT;    // flags2
    flags2_ex: MF2_EX_DONOTRENDERSHADOW;                          // flags2_ex
    pushfactor: DEFPUSHFACTOR;                                    // pushfactor
    scale: FRACUNIT;                                              // scale
    gravity: FRACUNIT;                                            // gravity
    flags3_ex: 0;                                                 // flags3_ex
    flags4_ex: 0;                                                 // flags4_ex
   ),

   (    // MT_MACEFX2
    name: 'MT_MACEFX2';
    inheritsfrom: -1;                                             // inheritsfrom
    doomednum: -1;                                                // doomednum
    spawnstate: Ord(S_MACEFX2_1);                                 // spawnstate
    spawnhealth: 1000;                                            // spawnhealth
    seestate: Ord(S_NULL);                                        // seestate
    seesound: 0;                                                  // seesound
    reactiontime: 8;                                              // reactiontime
    attacksound: Ord(sfx_None);                                   // attacksound
    painstate: Ord(S_NULL);                                       // painstate
    painchance: 0;                                                // painchance
    painsound: Ord(sfx_None);                                     // painsound
    meleestate: Ord(S_NULL);                                      // meleestate
    missilestate: Ord(S_NULL);                                    // missilestate
    crashstate: Ord(S_NULL);                                      // crashstate
    deathstate: Ord(S_MACEFXI2_1);                                // deathstate
    xdeathstate: Ord(S_NULL);                                     // xdeathstate
    deathsound: 0;                                                // deathsound
    speed: 10 * FRACUNIT;                                         // speed
    radius: 8 * FRACUNIT;                                         // radius
    height: 6 * FRACUNIT;                                         // height
    mass: 100;                                                    // mass
    damage: 6;                                                    // damage
    activesound: Ord(sfx_None);                                   // activesound
    flags: MF_NOBLOCKMAP or MF_MISSILE or MF_DROPOFF;             // flags
    flags2: MF2_LOGRAV or MF2_FLOORBOUNCE or MF2_THRUGHOST or MF2_NOTELEPORT;   // flags2
    flags2_ex: MF2_EX_DONOTRENDERSHADOW;                          // flags2_ex
    pushfactor: DEFPUSHFACTOR;                                    // pushfactor
    scale: FRACUNIT;                                              // scale
    gravity: FRACUNIT;                                            // gravity
    flags3_ex: 0;                                                 // flags3_ex
    flags4_ex: 0;                                                 // flags4_ex
   ),

   (    // MT_MACEFX3
    name: 'MT_MACEFX3';
    inheritsfrom: -1;                                             // inheritsfrom
    doomednum: -1;                                                // doomednum
    spawnstate: Ord(S_MACEFX3_1);                                 // spawnstate
    spawnhealth: 1000;                                            // spawnhealth
    seestate: Ord(S_NULL);                                        // seestate
    seesound: 0;                                                  // seesound
    reactiontime: 8;                                              // reactiontime
    attacksound: Ord(sfx_None);                                   // attacksound
    painstate: Ord(S_NULL);                                       // painstate
    painchance: 0;                                                // painchance
    painsound: Ord(sfx_None);                                     // painsound
    meleestate: Ord(S_NULL);                                      // meleestate
    missilestate: Ord(S_NULL);                                    // missilestate
    crashstate: Ord(S_NULL);                                      // crashstate
    deathstate: Ord(S_MACEFXI1_1);                                // deathstate
    xdeathstate: Ord(S_NULL);                                     // xdeathstate
    deathsound: 0;                                                // deathsound
    speed: 7 * FRACUNIT;                                          // speed
    radius: 8 * FRACUNIT;                                         // radius
    height: 6 * FRACUNIT;                                         // height
    mass: 100;                                                    // mass
    damage: 4;                                                    // damage
    activesound: Ord(sfx_None);                                   // activesound
    flags: MF_NOBLOCKMAP or MF_MISSILE or MF_DROPOFF;             // flags
    flags2: MF2_LOGRAV or MF2_FLOORBOUNCE or MF2_THRUGHOST or MF2_NOTELEPORT;   // flags2
    flags2_ex: MF2_EX_DONOTRENDERSHADOW;                          // flags2_ex
    pushfactor: DEFPUSHFACTOR;                                    // pushfactor
    scale: FRACUNIT;                                              // scale
    gravity: FRACUNIT;                                            // gravity
    flags3_ex: 0;                                                 // flags3_ex
    flags4_ex: 0;                                                 // flags4_ex
   ),

   (    // MT_MACEFX4
    name: 'MT_MACEFX4';
    inheritsfrom: -1;                                             // inheritsfrom
    doomednum: -1;                                                // doomednum
    spawnstate: Ord(S_MACEFX4_1);                                 // spawnstate
    spawnhealth: 1000;                                            // spawnhealth
    seestate: Ord(S_NULL);                                        // seestate
    seesound: 0;                                                  // seesound
    reactiontime: 8;                                              // reactiontime
    attacksound: Ord(sfx_None);                                   // attacksound
    painstate: Ord(S_NULL);                                       // painstate
    painchance: 0;                                                // painchance
    painsound: Ord(sfx_None);                                     // painsound
    meleestate: Ord(S_NULL);                                      // meleestate
    missilestate: Ord(S_NULL);                                    // missilestate
    crashstate: Ord(S_NULL);                                      // crashstate
    deathstate: Ord(S_MACEFXI4_1);                                // deathstate
    xdeathstate: Ord(S_NULL);                                     // xdeathstate
    deathsound: 0;                                                // deathsound
    speed: 7 * FRACUNIT;                                          // speed
    radius: 8 * FRACUNIT;                                         // radius
    height: 6 * FRACUNIT;                                         // height
    mass: 100;                                                    // mass
    damage: 18;                                                   // damage
    activesound: Ord(sfx_None);                                   // activesound
    flags: MF_NOBLOCKMAP or MF_MISSILE or MF_DROPOFF;             // flags
    flags2: MF2_LOGRAV or MF2_FLOORBOUNCE or MF2_THRUGHOST or MF2_TELESTOMP;   // flags2
    flags2_ex: MF2_EX_DONOTRENDERSHADOW;                          // flags2_ex
    pushfactor: DEFPUSHFACTOR;                                    // pushfactor
    scale: FRACUNIT;                                              // scale
    gravity: FRACUNIT;                                            // gravity
    flags3_ex: 0;                                                 // flags3_ex
    flags4_ex: 0;                                                 // flags4_ex
   ),

   (    // MT_WSKULLROD
    name: 'Hellstaff';
    inheritsfrom: -1;                                             // inheritsfrom
    doomednum: 2004;                                              // doomednum
    spawnstate: Ord(S_WSKL);                                      // spawnstate
    spawnhealth: 1000;                                            // spawnhealth
    seestate: Ord(S_NULL);                                        // seestate
    seesound: Ord(sfx_None);                                      // seesound
    reactiontime: 8;                                              // reactiontime
    attacksound: Ord(sfx_None);                                   // attacksound
    painstate: Ord(S_NULL);                                       // painstate
    painchance: 0;                                                // painchance
    painsound: Ord(sfx_None);                                     // painsound
    meleestate: Ord(S_NULL);                                      // meleestate
    missilestate: Ord(S_NULL);                                    // missilestate
    crashstate: Ord(S_NULL);                                      // crashstate
    deathstate: Ord(S_NULL);                                      // deathstate
    xdeathstate: Ord(S_NULL);                                     // xdeathstate
    deathsound: Ord(sfx_None);                                    // deathsound
    speed: 0;                                                     // speed
    radius: 20 * FRACUNIT;                                        // radius
    height: 16 * FRACUNIT;                                        // height
    mass: 100;                                                    // mass
    damage: 0;                                                    // damage
    activesound: Ord(sfx_None);                                   // activesound
    flags: MF_SPECIAL;                                            // flags
    flags2: 0;                                                    // flags2
    pushfactor: DEFPUSHFACTOR;                                    // pushfactor
    scale: FRACUNIT;                                              // scale
    gravity: FRACUNIT;                                            // gravity
    flags3_ex: 0;                                                 // flags3_ex
    flags4_ex: 0;                                                 // flags4_ex
   ),

   (    // MT_HORNRODFX1
    name: 'MT_HORNRODFX1';
    inheritsfrom: -1;                                             // inheritsfrom
    doomednum: -1;                                                // doomednum
    spawnstate: Ord(S_HRODFX1_1);                                 // spawnstate
    spawnhealth: 1000;                                            // spawnhealth
    seestate: Ord(S_NULL);                                        // seestate
    seesound: Ord(sfx_hrnsht);                                    // seesound
    reactiontime: 8;                                              // reactiontime
    attacksound: Ord(sfx_None);                                   // attacksound
    painstate: Ord(S_NULL);                                       // painstate
    painchance: 0;                                                // painchance
    painsound: Ord(sfx_None);                                     // painsound
    meleestate: Ord(S_NULL);                                      // meleestate
    missilestate: Ord(S_NULL);                                    // missilestate
    crashstate: Ord(S_NULL);                                      // crashstate
    deathstate: Ord(S_HRODFXI1_1);                                // deathstate
    xdeathstate: Ord(S_NULL);                                     // xdeathstate
    deathsound: Ord(sfx_hrnhit);                                  // deathsound
    speed: 22 * FRACUNIT;                                         // speed
    radius: 12 * FRACUNIT;                                        // radius
    height: 8 * FRACUNIT;                                         // height
    mass: 100;                                                    // mass
    damage: 3;                                                    // damage
    activesound: Ord(sfx_None);                                   // activesound
    flags: MF_NOBLOCKMAP or MF_MISSILE or MF_DROPOFF or MF_NOGRAVITY;    // flags
    flags2: MF2_WINDTHRUST or MF2_NOTELEPORT;                     // flags2
    flags2_ex: MF2_EX_DONOTRENDERSHADOW;                          // flags2_ex
    pushfactor: DEFPUSHFACTOR;                                    // pushfactor
    scale: FRACUNIT;                                              // scale
    gravity: FRACUNIT;                                            // gravity
    flags3_ex: 0;                                                 // flags3_ex
    flags4_ex: 0;                                                 // flags4_ex
   ),

   (    // MT_HORNRODFX2
    name: 'MT_HORNRODFX2';
    inheritsfrom: -1;                                             // inheritsfrom
    doomednum: -1;                                                // doomednum
    spawnstate: Ord(S_HRODFX2_1);                                 // spawnstate
    spawnhealth: 4*35;                                            // spawnhealth
    seestate: Ord(S_NULL);                                        // seestate
    seesound: Ord(sfx_hrnsht);                                    // seesound
    reactiontime: 8;                                              // reactiontime
    attacksound: Ord(sfx_None);                                   // attacksound
    painstate: Ord(S_NULL);                                       // painstate
    painchance: 0;                                                // painchance
    painsound: Ord(sfx_None);                                     // painsound
    meleestate: Ord(S_NULL);                                      // meleestate
    missilestate: Ord(S_NULL);                                    // missilestate
    crashstate: Ord(S_NULL);                                      // crashstate
    deathstate: Ord(S_HRODFXI2_1);                                // deathstate
    xdeathstate: Ord(S_NULL);                                     // xdeathstate
    deathsound: Ord(sfx_ramphit);                                 // deathsound
    speed: 22 * FRACUNIT;                                         // speed
    radius: 12 * FRACUNIT;                                        // radius
    height: 8 * FRACUNIT;                                         // height
    mass: 100;                                                    // mass
    damage: 10;                                                   // damage
    activesound: Ord(sfx_None);                                   // activesound
    flags: MF_NOBLOCKMAP or MF_MISSILE or MF_DROPOFF or MF_NOGRAVITY;    // flags
    flags2: MF2_NOTELEPORT;                                       // flags2
    flags2_ex: MF2_EX_DONOTRENDERSHADOW;                          // flags2_ex
    pushfactor: DEFPUSHFACTOR;                                    // pushfactor
    scale: FRACUNIT;                                              // scale
    gravity: FRACUNIT;                                            // gravity
    flags3_ex: 0;                                                 // flags3_ex
    flags4_ex: 0;                                                 // flags4_ex
   ),

   (    // MT_RAINPLR1
    name: 'MT_RAINPLR1';
    inheritsfrom: -1;                                             // inheritsfrom
    doomednum: -1;                                                // doomednum
    spawnstate: Ord(S_RAINPLR1_1);                                // spawnstate
    spawnhealth: 1000;                                            // spawnhealth
    seestate: Ord(S_NULL);                                        // seestate
    seesound: 0;                                                  // seesound
    reactiontime: 8;                                              // reactiontime
    attacksound: Ord(sfx_None);                                   // attacksound
    painstate: Ord(S_NULL);                                       // painstate
    painchance: 0;                                                // painchance
    painsound: Ord(sfx_None);                                     // painsound
    meleestate: Ord(S_NULL);                                      // meleestate
    missilestate: Ord(S_NULL);                                    // missilestate
    crashstate: Ord(S_NULL);                                      // crashstate
    deathstate: Ord(S_RAINPLR1X_1);                               // deathstate
    xdeathstate: Ord(S_NULL);                                     // xdeathstate
    deathsound: 0;                                                // deathsound
    speed: 12 * FRACUNIT;                                         // speed
    radius: 5 * FRACUNIT;                                         // radius
    height: 12 * FRACUNIT;                                        // height
    mass: 100;                                                    // mass
    damage: 5;                                                    // damage
    activesound: Ord(sfx_None);                                   // activesound
    flags: MF_NOBLOCKMAP or MF_MISSILE or MF_DROPOFF or MF_NOGRAVITY;    // flags
    flags2: MF2_NOTELEPORT;                                       // flags2
    pushfactor: DEFPUSHFACTOR;                                    // pushfactor
    scale: FRACUNIT;                                              // scale
    gravity: FRACUNIT;                                            // gravity
    flags3_ex: 0;                                                 // flags3_ex
    flags4_ex: 0;                                                 // flags4_ex
   ),

   (    // MT_RAINPLR2
    name: 'MT_RAINPLR2';
    inheritsfrom: -1;                                             // inheritsfrom
    doomednum: -1;                                                // doomednum
    spawnstate: Ord(S_RAINPLR2_1);                                // spawnstate
    spawnhealth: 1000;                                            // spawnhealth
    seestate: Ord(S_NULL);                                        // seestate
    seesound: 0;                                                  // seesound
    reactiontime: 8;                                              // reactiontime
    attacksound: Ord(sfx_None);                                   // attacksound
    painstate: Ord(S_NULL);                                       // painstate
    painchance: 0;                                                // painchance
    painsound: Ord(sfx_None);                                     // painsound
    meleestate: Ord(S_NULL);                                      // meleestate
    missilestate: Ord(S_NULL);                                    // missilestate
    crashstate: Ord(S_NULL);                                      // crashstate
    deathstate: Ord(S_RAINPLR2X_1);                               // deathstate
    xdeathstate: Ord(S_NULL);                                     // xdeathstate
    deathsound: 0;                                                // deathsound
    speed: 12 * FRACUNIT;                                         // speed
    radius: 5 * FRACUNIT;                                         // radius
    height: 12 * FRACUNIT;                                        // height
    mass: 100;                                                    // mass
    damage: 5;                                                    // damage
    activesound: Ord(sfx_None);                                   // activesound
    flags: MF_NOBLOCKMAP or MF_MISSILE or MF_DROPOFF or MF_NOGRAVITY;    // flags
    flags2: MF2_NOTELEPORT;                                       // flags2
    pushfactor: DEFPUSHFACTOR;                                    // pushfactor
    scale: FRACUNIT;                                              // scale
    gravity: FRACUNIT;                                            // gravity
    flags3_ex: 0;                                                 // flags3_ex
    flags4_ex: 0;                                                 // flags4_ex
   ),

   (    // MT_RAINPLR3
    name: 'MT_RAINPLR3';
    inheritsfrom: -1;                                             // inheritsfrom
    doomednum: -1;                                                // doomednum
    spawnstate: Ord(S_RAINPLR3_1);                                // spawnstate
    spawnhealth: 1000;                                            // spawnhealth
    seestate: Ord(S_NULL);                                        // seestate
    seesound: 0;                                                  // seesound
    reactiontime: 8;                                              // reactiontime
    attacksound: Ord(sfx_None);                                   // attacksound
    painstate: Ord(S_NULL);                                       // painstate
    painchance: 0;                                                // painchance
    painsound: Ord(sfx_None);                                     // painsound
    meleestate: Ord(S_NULL);                                      // meleestate
    missilestate: Ord(S_NULL);                                    // missilestate
    crashstate: Ord(S_NULL);                                      // crashstate
    deathstate: Ord(S_RAINPLR3X_1);                               // deathstate
    xdeathstate: Ord(S_NULL);                                     // xdeathstate
    deathsound: 0;                                                // deathsound
    speed: 12 * FRACUNIT;                                         // speed
    radius: 5 * FRACUNIT;                                         // radius
    height: 12 * FRACUNIT;                                        // height
    mass: 100;                                                    // mass
    damage: 5;                                                    // damage
    activesound: Ord(sfx_None);                                   // activesound
    flags: MF_NOBLOCKMAP or MF_MISSILE or MF_DROPOFF or MF_NOGRAVITY;    // flags
    flags2: MF2_NOTELEPORT;                                       // flags2
    pushfactor: DEFPUSHFACTOR;                                    // pushfactor
    scale: FRACUNIT;                                              // scale
    gravity: FRACUNIT;                                            // gravity
    flags3_ex: 0;                                                 // flags3_ex
    flags4_ex: 0;                                                 // flags4_ex
   ),

   (    // MT_RAINPLR4
    name: 'MT_RAINPLR4';
    inheritsfrom: -1;                                             // inheritsfrom
    doomednum: -1;                                                // doomednum
    spawnstate: Ord(S_RAINPLR4_1);                                // spawnstate
    spawnhealth: 1000;                                            // spawnhealth
    seestate: Ord(S_NULL);                                        // seestate
    seesound: 0;                                                  // seesound
    reactiontime: 8;                                              // reactiontime
    attacksound: Ord(sfx_None);                                   // attacksound
    painstate: Ord(S_NULL);                                       // painstate
    painchance: 0;                                                // painchance
    painsound: Ord(sfx_None);                                     // painsound
    meleestate: Ord(S_NULL);                                      // meleestate
    missilestate: Ord(S_NULL);                                    // missilestate
    crashstate: Ord(S_NULL);                                      // crashstate
    deathstate: Ord(S_RAINPLR4X_1);                               // deathstate
    xdeathstate: Ord(S_NULL);                                     // xdeathstate
    deathsound: 0;                                                // deathsound
    speed: 12 * FRACUNIT;                                         // speed
    radius: 5 * FRACUNIT;                                         // radius
    height: 12 * FRACUNIT;                                        // height
    mass: 100;                                                    // mass
    damage: 5;                                                    // damage
    activesound: Ord(sfx_None);                                   // activesound
    flags: MF_NOBLOCKMAP or MF_MISSILE or MF_DROPOFF or MF_NOGRAVITY;    // flags
    flags2: MF2_NOTELEPORT;                                       // flags2
    pushfactor: DEFPUSHFACTOR;                                    // pushfactor
    scale: FRACUNIT;                                              // scale
    gravity: FRACUNIT;                                            // gravity
    flags3_ex: 0;                                                 // flags3_ex
    flags4_ex: 0;                                                 // flags4_ex
   ),

   (    // MT_GOLDWANDFX1
    name: 'MT_GOLDWANDFX1';
    inheritsfrom: -1;                                             // inheritsfrom
    doomednum: -1;                                                // doomednum
    spawnstate: Ord(S_GWANDFX1_1);                                // spawnstate
    spawnhealth: 1000;                                            // spawnhealth
    seestate: Ord(S_NULL);                                        // seestate
    seesound: 0;                                                  // seesound
    reactiontime: 8;                                              // reactiontime
    attacksound: Ord(sfx_None);                                   // attacksound
    painstate: Ord(S_NULL);                                       // painstate
    painchance: 0;                                                // painchance
    painsound: Ord(sfx_None);                                     // painsound
    meleestate: Ord(S_NULL);                                      // meleestate
    missilestate: Ord(S_NULL);                                    // missilestate
    crashstate: Ord(S_NULL);                                      // crashstate
    deathstate: Ord(S_GWANDFXI1_1);                               // deathstate
    xdeathstate: Ord(S_NULL);                                     // xdeathstate
    deathsound: Ord(sfx_gldhit);                                  // deathsound
    speed: 22 * FRACUNIT;                                         // speed
    radius: 10 * FRACUNIT;                                        // radius
    height: 6 * FRACUNIT;                                         // height
    mass: 100;                                                    // mass
    damage: 2;                                                    // damage
    activesound: Ord(sfx_None);                                   // activesound
    flags: MF_NOBLOCKMAP or MF_MISSILE or MF_DROPOFF or MF_NOGRAVITY;    // flags
    flags2: MF2_NOTELEPORT;                                       // flags2
    flags2_ex: MF2_EX_DONOTRENDERSHADOW;                          // flags2_ex
    pushfactor: DEFPUSHFACTOR;                                    // pushfactor
    scale: FRACUNIT;                                              // scale
    gravity: FRACUNIT;                                            // gravity
    flags3_ex: 0;                                                 // flags3_ex
    flags4_ex: 0;                                                 // flags4_ex
   ),

   (    // MT_GOLDWANDFX2
    name: 'MT_GOLDWANDFX2';
    inheritsfrom: -1;                                             // inheritsfrom
    doomednum: -1;                                                // doomednum
    spawnstate: Ord(S_GWANDFX2_1);                                // spawnstate
    spawnhealth: 1000;                                            // spawnhealth
    seestate: Ord(S_NULL);                                        // seestate
    seesound: 0;                                                  // seesound
    reactiontime: 8;                                              // reactiontime
    attacksound: Ord(sfx_None);                                   // attacksound
    painstate: Ord(S_NULL);                                       // painstate
    painchance: 0;                                                // painchance
    painsound: Ord(sfx_None);                                     // painsound
    meleestate: Ord(S_NULL);                                      // meleestate
    missilestate: Ord(S_NULL);                                    // missilestate
    crashstate: Ord(S_NULL);                                      // crashstate
    deathstate: Ord(S_GWANDFXI1_1);                               // deathstate
    xdeathstate: Ord(S_NULL);                                     // xdeathstate
    deathsound: 0;                                                // deathsound
    speed: 18 * FRACUNIT;                                         // speed
    radius: 10 * FRACUNIT;                                        // radius
    height: 6 * FRACUNIT;                                         // height
    mass: 100;                                                    // mass
    damage: 1;                                                    // damage
    activesound: Ord(sfx_None);                                   // activesound
    flags: MF_NOBLOCKMAP or MF_MISSILE or MF_DROPOFF or MF_NOGRAVITY;    // flags
    flags2: MF2_NOTELEPORT;                                       // flags2
    flags2_ex: MF2_EX_DONOTRENDERSHADOW;                          // flags2_ex
    pushfactor: DEFPUSHFACTOR;                                    // pushfactor
    scale: FRACUNIT;                                              // scale
    gravity: FRACUNIT;                                            // gravity
    flags3_ex: 0;                                                 // flags3_ex
    flags4_ex: 0;                                                 // flags4_ex
   ),

   (    // MT_GOLDWANDPUFF1
    name: 'MT_GOLDWANDPUFF1';
    inheritsfrom: -1;                                             // inheritsfrom
    doomednum: -1;                                                // doomednum
    spawnstate: Ord(S_GWANDPUFF1_1);                              // spawnstate
    spawnhealth: 1000;                                            // spawnhealth
    seestate: Ord(S_NULL);                                        // seestate
    seesound: Ord(sfx_None);                                      // seesound
    reactiontime: 8;                                              // reactiontime
    attacksound: Ord(sfx_None);                                   // attacksound
    painstate: Ord(S_NULL);                                       // painstate
    painchance: 0;                                                // painchance
    painsound: Ord(sfx_None);                                     // painsound
    meleestate: Ord(S_NULL);                                      // meleestate
    missilestate: Ord(S_NULL);                                    // missilestate
    crashstate: Ord(S_NULL);                                      // crashstate
    deathstate: Ord(S_NULL);                                      // deathstate
    xdeathstate: Ord(S_NULL);                                     // xdeathstate
    deathsound: Ord(sfx_None);                                    // deathsound
    speed: 0;                                                     // speed
    radius: 20 * FRACUNIT;                                        // radius
    height: 16 * FRACUNIT;                                        // height
    mass: 100;                                                    // mass
    damage: 0;                                                    // damage
    activesound: Ord(sfx_None);                                   // activesound
    flags: MF_NOBLOCKMAP or MF_NOGRAVITY;                         // flags
    flags2: 0;                                                    // flags2
    flags2_ex: MF2_EX_DONOTRENDERSHADOW;                          // flags2_ex
    pushfactor: DEFPUSHFACTOR;                                    // pushfactor
    scale: FRACUNIT;                                              // scale
    gravity: FRACUNIT;                                            // gravity
    flags3_ex: 0;                                                 // flags3_ex
    flags4_ex: 0;                                                 // flags4_ex
   ),

   (    // MT_GOLDWANDPUFF2
    name: 'MT_GOLDWANDPUFF2';
    inheritsfrom: -1;                                             // inheritsfrom
    doomednum: -1;                                                // doomednum
    spawnstate: Ord(S_GWANDFXI1_1);                               // spawnstate
    spawnhealth: 1000;                                            // spawnhealth
    seestate: Ord(S_NULL);                                        // seestate
    seesound: Ord(sfx_None);                                      // seesound
    reactiontime: 8;                                              // reactiontime
    attacksound: Ord(sfx_None);                                   // attacksound
    painstate: Ord(S_NULL);                                       // painstate
    painchance: 0;                                                // painchance
    painsound: Ord(sfx_None);                                     // painsound
    meleestate: Ord(S_NULL);                                      // meleestate
    missilestate: Ord(S_NULL);                                    // missilestate
    crashstate: Ord(S_NULL);                                      // crashstate
    deathstate: Ord(S_NULL);                                      // deathstate
    xdeathstate: Ord(S_NULL);                                     // xdeathstate
    deathsound: Ord(sfx_None);                                    // deathsound
    speed: 0;                                                     // speed
    radius: 20 * FRACUNIT;                                        // radius
    height: 16 * FRACUNIT;                                        // height
    mass: 100;                                                    // mass
    damage: 0;                                                    // damage
    activesound: Ord(sfx_None);                                   // activesound
    flags: MF_NOBLOCKMAP or MF_NOGRAVITY;                         // flags
    flags2: 0;                                                    // flags2
    flags2_ex: MF2_EX_DONOTRENDERSHADOW;                          // flags2_ex
    pushfactor: DEFPUSHFACTOR;                                    // pushfactor
    scale: FRACUNIT;                                              // scale
    gravity: FRACUNIT;                                            // gravity
    flags3_ex: 0;                                                 // flags3_ex
    flags4_ex: 0;                                                 // flags4_ex
   ),

   (    // MT_WPHOENIXROD
    name: 'Phoenix Rod';
    inheritsfrom: -1;                                             // inheritsfrom
    doomednum: 2003;                                              // doomednum
    spawnstate: Ord(S_WPHX);                                      // spawnstate
    spawnhealth: 1000;                                            // spawnhealth
    seestate: Ord(S_NULL);                                        // seestate
    seesound: Ord(sfx_None);                                      // seesound
    reactiontime: 8;                                              // reactiontime
    attacksound: Ord(sfx_None);                                   // attacksound
    painstate: Ord(S_NULL);                                       // painstate
    painchance: 0;                                                // painchance
    painsound: Ord(sfx_None);                                     // painsound
    meleestate: Ord(S_NULL);                                      // meleestate
    missilestate: Ord(S_NULL);                                    // missilestate
    crashstate: Ord(S_NULL);                                      // crashstate
    deathstate: Ord(S_NULL);                                      // deathstate
    xdeathstate: Ord(S_NULL);                                     // xdeathstate
    deathsound: Ord(sfx_None);                                    // deathsound
    speed: 0;                                                     // speed
    radius: 20 * FRACUNIT;                                        // radius
    height: 16 * FRACUNIT;                                        // height
    mass: 100;                                                    // mass
    damage: 0;                                                    // damage
    activesound: Ord(sfx_None);                                   // activesound
    flags: MF_SPECIAL;                                            // flags
    flags2: 0;                                                    // flags2
    pushfactor: DEFPUSHFACTOR;                                    // pushfactor
    scale: FRACUNIT;                                              // scale
    gravity: FRACUNIT;                                            // gravity
    flags3_ex: 0;                                                 // flags3_ex
    flags4_ex: 0;                                                 // flags4_ex
   ),

   (    // MT_PHOENIXFX1
    name: 'MT_PHOENIXFX1';
    inheritsfrom: -1;                                             // inheritsfrom
    doomednum: -1;                                                // doomednum
    spawnstate: Ord(S_PHOENIXFX1_1);                              // spawnstate
    spawnhealth: 1000;                                            // spawnhealth
    seestate: Ord(S_NULL);                                        // seestate
    seesound: Ord(sfx_phosht);                                    // seesound
    reactiontime: 8;                                              // reactiontime
    attacksound: Ord(sfx_None);                                   // attacksound
    painstate: Ord(S_NULL);                                       // painstate
    painchance: 0;                                                // painchance
    painsound: Ord(sfx_None);                                     // painsound
    meleestate: Ord(S_NULL);                                      // meleestate
    missilestate: Ord(S_NULL);                                    // missilestate
    crashstate: Ord(S_NULL);                                      // crashstate
    deathstate: Ord(S_PHOENIXFXI1_1);                             // deathstate
    xdeathstate: Ord(S_NULL);                                     // xdeathstate
    deathsound: Ord(sfx_phohit);                                  // deathsound
    speed: 20 * FRACUNIT;                                         // speed
    radius: 11 * FRACUNIT;                                        // radius
    height: 8 * FRACUNIT;                                         // height
    mass: 100;                                                    // mass
    damage: 20;                                                   // damage
    activesound: Ord(sfx_None);                                   // activesound
    flags: MF_NOBLOCKMAP or MF_MISSILE or MF_DROPOFF or MF_NOGRAVITY;    // flags
    flags2: MF2_THRUGHOST or MF2_NOTELEPORT;                      // flags2
    flags2_ex: MF2_EX_DONOTRENDERSHADOW;                          // flags2_ex
    pushfactor: DEFPUSHFACTOR;                                    // pushfactor
    scale: FRACUNIT;                                              // scale
    gravity: FRACUNIT;                                            // gravity
    flags3_ex: 0;                                                 // flags3_ex
    flags4_ex: 0;                                                 // flags4_ex
   ),

   (    // MT_PHOENIXPUFF
    name: 'MT_PHOENIXPUFF';
    inheritsfrom: -1;                                             // inheritsfrom
    doomednum: -1;                                                // doomednum
    spawnstate: Ord(S_PHOENIXPUFF1);                              // spawnstate
    spawnhealth: 1000;                                            // spawnhealth
    seestate: Ord(S_NULL);                                        // seestate
    seesound: Ord(sfx_None);                                      // seesound
    reactiontime: 8;                                              // reactiontime
    attacksound: Ord(sfx_None);                                   // attacksound
    painstate: Ord(S_NULL);                                       // painstate
    painchance: 0;                                                // painchance
    painsound: Ord(sfx_None);                                     // painsound
    meleestate: Ord(S_NULL);                                      // meleestate
    missilestate: Ord(S_NULL);                                    // missilestate
    crashstate: Ord(S_NULL);                                      // crashstate
    deathstate: Ord(S_NULL);                                      // deathstate
    xdeathstate: Ord(S_NULL);                                     // xdeathstate
    deathsound: Ord(sfx_None);                                    // deathsound
    speed: 0;                                                     // speed
    radius: 20 * FRACUNIT;                                        // radius
    height: 16 * FRACUNIT;                                        // height
    mass: 100;                                                    // mass
    damage: 0;                                                    // damage
    activesound: Ord(sfx_None);                                   // activesound
    flags: MF_NOBLOCKMAP or MF_NOGRAVITY or MF_SHADOW;            // flags
    flags2: MF2_NOTELEPORT or MF2_CANNOTPUSH;                     // flags2
    flags2_ex: MF2_EX_DONOTRENDERSHADOW;                          // flags2_ex
    pushfactor: DEFPUSHFACTOR;                                    // pushfactor
    scale: FRACUNIT;                                              // scale
    gravity: FRACUNIT;                                            // gravity
    flags3_ex: 0;                                                 // flags3_ex
    flags4_ex: 0;                                                 // flags4_ex
   ),

   (    // MT_PHOENIXFX2
    name: 'MT_PHOENIXFX2';
    inheritsfrom: -1;                                             // inheritsfrom
    doomednum: -1;                                                // doomednum
    spawnstate: Ord(S_PHOENIXFX2_1);                              // spawnstate
    spawnhealth: 1000;                                            // spawnhealth
    seestate: Ord(S_NULL);                                        // seestate
    seesound: 0;                                                  // seesound
    reactiontime: 8;                                              // reactiontime
    attacksound: Ord(sfx_None);                                   // attacksound
    painstate: Ord(S_NULL);                                       // painstate
    painchance: 0;                                                // painchance
    painsound: Ord(sfx_None);                                     // painsound
    meleestate: Ord(S_NULL);                                      // meleestate
    missilestate: Ord(S_NULL);                                    // missilestate
    crashstate: Ord(S_NULL);                                      // crashstate
    deathstate: Ord(S_PHOENIXFXI2_1);                             // deathstate
    xdeathstate: Ord(S_NULL);                                     // xdeathstate
    deathsound: 0;                                                // deathsound
    speed: 10 * FRACUNIT;                                         // speed
    radius: 6 * FRACUNIT;                                         // radius
    height: 8 * FRACUNIT;                                         // height
    mass: 100;                                                    // mass
    damage: 2;                                                    // damage
    activesound: Ord(sfx_None);                                   // activesound
    flags: MF_NOBLOCKMAP or MF_MISSILE or MF_DROPOFF or MF_NOGRAVITY;    // flags
    flags2: MF2_NOTELEPORT or MF2_FIREDAMAGE;                     // flags2
    flags2_ex: MF2_EX_DONOTRENDERSHADOW;                          // flags2_ex
    pushfactor: DEFPUSHFACTOR;                                    // pushfactor
    scale: FRACUNIT;                                              // scale
    gravity: FRACUNIT;                                            // gravity
    flags3_ex: 0;                                                 // flags3_ex
    flags4_ex: 0;                                                 // flags4_ex
   ),

   (    // MT_MISC15
    name: 'Ethereal Crossbow';
    inheritsfrom: -1;                                             // inheritsfrom
    doomednum: 2001;                                              // doomednum
    spawnstate: Ord(S_WBOW);                                      // spawnstate
    spawnhealth: 1000;                                            // spawnhealth
    seestate: Ord(S_NULL);                                        // seestate
    seesound: Ord(sfx_None);                                      // seesound
    reactiontime: 8;                                              // reactiontime
    attacksound: Ord(sfx_None);                                   // attacksound
    painstate: Ord(S_NULL);                                       // painstate
    painchance: 0;                                                // painchance
    painsound: Ord(sfx_None);                                     // painsound
    meleestate: Ord(S_NULL);                                      // meleestate
    missilestate: Ord(S_NULL);                                    // missilestate
    crashstate: Ord(S_NULL);                                      // crashstate
    deathstate: Ord(S_NULL);                                      // deathstate
    xdeathstate: Ord(S_NULL);                                     // xdeathstate
    deathsound: Ord(sfx_None);                                    // deathsound
    speed: 0;                                                     // speed
    radius: 20 * FRACUNIT;                                        // radius
    height: 16 * FRACUNIT;                                        // height
    mass: 100;                                                    // mass
    damage: 0;                                                    // damage
    activesound: Ord(sfx_None);                                   // activesound
    flags: MF_SPECIAL;                                            // flags
    flags2: 0;                                                    // flags2
    pushfactor: DEFPUSHFACTOR;                                    // pushfactor
    scale: FRACUNIT;                                              // scale
    gravity: FRACUNIT;                                            // gravity
    flags3_ex: 0;                                                 // flags3_ex
    flags4_ex: 0;                                                 // flags4_ex
   ),

   (    // MT_CRBOWFX1
    name: 'MT_CRBOWFX1';
    inheritsfrom: -1;                                             // inheritsfrom
    doomednum: -1;                                                // doomednum
    spawnstate: Ord(S_CRBOWFX1);                                  // spawnstate
    spawnhealth: 1000;                                            // spawnhealth
    seestate: Ord(S_NULL);                                        // seestate
    seesound: Ord(sfx_bowsht);                                    // seesound
    reactiontime: 8;                                              // reactiontime
    attacksound: Ord(sfx_None);                                   // attacksound
    painstate: Ord(S_NULL);                                       // painstate
    painchance: 0;                                                // painchance
    painsound: Ord(sfx_None);                                     // painsound
    meleestate: Ord(S_NULL);                                      // meleestate
    missilestate: Ord(S_NULL);                                    // missilestate
    crashstate: Ord(S_NULL);                                      // crashstate
    deathstate: Ord(S_CRBOWFXI1_1);                               // deathstate
    xdeathstate: Ord(S_NULL);                                     // xdeathstate
    deathsound: Ord(sfx_hrnhit);                                  // deathsound
    speed: 30 * FRACUNIT;                                         // speed
    radius: 11 * FRACUNIT;                                        // radius
    height: 8 * FRACUNIT;                                         // height
    mass: 100;                                                    // mass
    damage: 10;                                                   // damage
    activesound: Ord(sfx_None);                                   // activesound
    flags: MF_NOBLOCKMAP or MF_MISSILE or MF_DROPOFF or MF_NOGRAVITY;    // flags
    flags2: MF2_NOTELEPORT;                                       // flags2
    flags2_ex: MF2_EX_DONOTRENDERSHADOW;                          // flags2_ex
    pushfactor: DEFPUSHFACTOR;                                    // pushfactor
    scale: FRACUNIT;                                              // scale
    gravity: FRACUNIT;                                            // gravity
    flags3_ex: 0;                                                 // flags3_ex
    flags4_ex: 0;                                                 // flags4_ex
   ),

   (    // MT_CRBOWFX2
    name: 'MT_CRBOWFX2';
    inheritsfrom: -1;                                             // inheritsfrom
    doomednum: -1;                                                // doomednum
    spawnstate: Ord(S_CRBOWFX2);                                  // spawnstate
    spawnhealth: 1000;                                            // spawnhealth
    seestate: Ord(S_NULL);                                        // seestate
    seesound: Ord(sfx_bowsht);                                    // seesound
    reactiontime: 8;                                              // reactiontime
    attacksound: Ord(sfx_None);                                   // attacksound
    painstate: Ord(S_NULL);                                       // painstate
    painchance: 0;                                                // painchance
    painsound: Ord(sfx_None);                                     // painsound
    meleestate: Ord(S_NULL);                                      // meleestate
    missilestate: Ord(S_NULL);                                    // missilestate
    crashstate: Ord(S_NULL);                                      // crashstate
    deathstate: Ord(S_CRBOWFXI1_1);                               // deathstate
    xdeathstate: Ord(S_NULL);                                     // xdeathstate
    deathsound: Ord(sfx_hrnhit);                                  // deathsound
    speed: 32 * FRACUNIT;                                         // speed
    radius: 11 * FRACUNIT;                                        // radius
    height: 8 * FRACUNIT;                                         // height
    mass: 100;                                                    // mass
    damage: 6;                                                    // damage
    activesound: Ord(sfx_None);                                   // activesound
    flags: MF_NOBLOCKMAP or MF_MISSILE or MF_DROPOFF or MF_NOGRAVITY;    // flags
    flags2: MF2_NOTELEPORT;                                       // flags2
    flags2_ex: MF2_EX_DONOTRENDERSHADOW;                          // flags2_ex
    pushfactor: DEFPUSHFACTOR;                                    // pushfactor
    scale: FRACUNIT;                                              // scale
    gravity: FRACUNIT;                                            // gravity
    flags3_ex: 0;                                                 // flags3_ex
    flags4_ex: 0;                                                 // flags4_ex
   ),

   (    // MT_CRBOWFX3
    name: 'MT_CRBOWFX3';
    inheritsfrom: -1;                                             // inheritsfrom
    doomednum: -1;                                                // doomednum
    spawnstate: Ord(S_CRBOWFX3);                                  // spawnstate
    spawnhealth: 1000;                                            // spawnhealth
    seestate: Ord(S_NULL);                                        // seestate
    seesound: 0;                                                  // seesound
    reactiontime: 8;                                              // reactiontime
    attacksound: Ord(sfx_None);                                   // attacksound
    painstate: Ord(S_NULL);                                       // painstate
    painchance: 0;                                                // painchance
    painsound: Ord(sfx_None);                                     // painsound
    meleestate: Ord(S_NULL);                                      // meleestate
    missilestate: Ord(S_NULL);                                    // missilestate
    crashstate: Ord(S_NULL);                                      // crashstate
    deathstate: Ord(S_CRBOWFXI3_1);                               // deathstate
    xdeathstate: Ord(S_NULL);                                     // xdeathstate
    deathsound: Ord(sfx_hrnhit);                                  // deathsound
    speed: 20 * FRACUNIT;                                         // speed
    radius: 11 * FRACUNIT;                                        // radius
    height: 8 * FRACUNIT;                                         // height
    mass: 100;                                                    // mass
    damage: 2;                                                    // damage
    activesound: Ord(sfx_None);                                   // activesound
    flags: MF_NOBLOCKMAP or MF_MISSILE or MF_DROPOFF or MF_NOGRAVITY;    // flags
    flags2: MF2_WINDTHRUST or MF2_THRUGHOST or MF2_NOTELEPORT;    // flags2
    flags2_ex: MF2_EX_DONOTRENDERSHADOW;                          // flags2_ex
    pushfactor: DEFPUSHFACTOR;                                    // pushfactor
    scale: FRACUNIT;                                              // scale
    gravity: FRACUNIT;                                            // gravity
    flags3_ex: 0;                                                 // flags3_ex
    flags4_ex: 0;                                                 // flags4_ex
   ),

   (    // MT_CRBOWFX4
    name: 'MT_CRBOWFX4';
    inheritsfrom: -1;                                             // inheritsfrom
    doomednum: -1;                                                // doomednum
    spawnstate: Ord(S_CRBOWFX4_1);                                // spawnstate
    spawnhealth: 1000;                                            // spawnhealth
    seestate: Ord(S_NULL);                                        // seestate
    seesound: Ord(sfx_None);                                      // seesound
    reactiontime: 8;                                              // reactiontime
    attacksound: Ord(sfx_None);                                   // attacksound
    painstate: Ord(S_NULL);                                       // painstate
    painchance: 0;                                                // painchance
    painsound: Ord(sfx_None);                                     // painsound
    meleestate: Ord(S_NULL);                                      // meleestate
    missilestate: Ord(S_NULL);                                    // missilestate
    crashstate: Ord(S_NULL);                                      // crashstate
    deathstate: Ord(S_NULL);                                      // deathstate
    xdeathstate: Ord(S_NULL);                                     // xdeathstate
    deathsound: Ord(sfx_None);                                    // deathsound
    speed: 0;                                                     // speed
    radius: 20 * FRACUNIT;                                        // radius
    height: 16 * FRACUNIT;                                        // height
    mass: 100;                                                    // mass
    damage: 0;                                                    // damage
    activesound: Ord(sfx_None);                                   // activesound
    flags: MF_NOBLOCKMAP;                                         // flags
    flags2: MF2_LOGRAV;                                           // flags2
    flags2_ex: MF2_EX_DONOTRENDERSHADOW;                          // flags2_ex
    pushfactor: DEFPUSHFACTOR;                                    // pushfactor
    scale: FRACUNIT;                                              // scale
    gravity: FRACUNIT;                                            // gravity
    flags3_ex: 0;                                                 // flags3_ex
    flags4_ex: 0;                                                 // flags4_ex
   ),

   (    // MT_BLOOD
    name: 'MT_BLOOD';
    inheritsfrom: -1;                                             // inheritsfrom
    doomednum: -1;                                                // doomednum
    spawnstate: Ord(S_BLOOD1);                                    // spawnstate
    spawnhealth: 1000;                                            // spawnhealth
    seestate: Ord(S_NULL);                                        // seestate
    seesound: Ord(sfx_None);                                      // seesound
    reactiontime: 8;                                              // reactiontime
    attacksound: Ord(sfx_None);                                   // attacksound
    painstate: Ord(S_NULL);                                       // painstate
    painchance: 0;                                                // painchance
    painsound: Ord(sfx_None);                                     // painsound
    meleestate: Ord(S_NULL);                                      // meleestate
    missilestate: Ord(S_NULL);                                    // missilestate
    crashstate: Ord(S_NULL);                                      // crashstate
    deathstate: Ord(S_NULL);                                      // deathstate
    xdeathstate: Ord(S_NULL);                                     // xdeathstate
    deathsound: Ord(sfx_None);                                    // deathsound
    speed: 0;                                                     // speed
    radius: 20 * FRACUNIT;                                        // radius
    height: 16 * FRACUNIT;                                        // height
    mass: 100;                                                    // mass
    damage: 0;                                                    // damage
    activesound: Ord(sfx_None);                                   // activesound
    flags: MF_NOBLOCKMAP;                                         // flags
    flags2: 0;                                                    // flags2
    flags2_ex: MF2_EX_DONOTRENDERSHADOW;                          // flags2_ex
    pushfactor: DEFPUSHFACTOR;                                    // pushfactor
    scale: FRACUNIT;                                              // scale
    gravity: FRACUNIT;                                            // gravity
    flags3_ex: 0;                                                 // flags3_ex
    flags4_ex: 0;                                                 // flags4_ex
   ),

   (    // MT_BLOODSPLATTER
    name: 'MT_BLOODSPLATTER';
    inheritsfrom: -1;                                             // inheritsfrom
    doomednum: -1;                                                // doomednum
    spawnstate: Ord(S_BLOODSPLATTER1);                            // spawnstate
    spawnhealth: 1000;                                            // spawnhealth
    seestate: Ord(S_NULL);                                        // seestate
    seesound: Ord(sfx_None);                                      // seesound
    reactiontime: 8;                                              // reactiontime
    attacksound: Ord(sfx_None);                                   // attacksound
    painstate: Ord(S_NULL);                                       // painstate
    painchance: 0;                                                // painchance
    painsound: Ord(sfx_None);                                     // painsound
    meleestate: Ord(S_NULL);                                      // meleestate
    missilestate: Ord(S_NULL);                                    // missilestate
    crashstate: Ord(S_NULL);                                      // crashstate
    deathstate: Ord(S_BLOODSPLATTERX);                            // deathstate
    xdeathstate: Ord(S_NULL);                                     // xdeathstate
    deathsound: Ord(sfx_None);                                    // deathsound
    speed: 0;                                                     // speed
    radius: 2 * FRACUNIT;                                         // radius
    height: 4 * FRACUNIT;                                         // height
    mass: 100;                                                    // mass
    damage: 0;                                                    // damage
    activesound: Ord(sfx_None);                                   // activesound
    flags: MF_NOBLOCKMAP or MF_MISSILE or MF_DROPOFF;             // flags
    flags2: MF2_NOTELEPORT or MF2_CANNOTPUSH;                     // flags2
    flags2_ex: MF2_EX_DONOTRENDERSHADOW;                          // flags2_ex
    pushfactor: DEFPUSHFACTOR;                                    // pushfactor
    scale: FRACUNIT;                                              // scale
    gravity: FRACUNIT;                                            // gravity
    flags3_ex: 0;                                                 // flags3_ex
    flags4_ex: 0;                                                 // flags4_ex
   ),

   (    // MT_PLAYER
    name: 'MT_PLAYER';
    inheritsfrom: -1;                                             // inheritsfrom
    doomednum: -1;                                                // doomednum
    spawnstate: Ord(S_PLAY);                                      // spawnstate
    spawnhealth: 100;                                             // spawnhealth
    seestate: Ord(S_PLAY_RUN1);                                   // seestate
    seesound: Ord(sfx_None);                                      // seesound
    reactiontime: 0;                                              // reactiontime
    attacksound: Ord(sfx_None);                                   // attacksound
    painstate: Ord(S_PLAY_PAIN);                                  // painstate
    painchance: 255;                                              // painchance
    painsound: Ord(sfx_plrpai);                                   // painsound
    meleestate: Ord(S_NULL);                                      // meleestate
    missilestate: Ord(S_PLAY_ATK1);                               // missilestate
    crashstate: Ord(S_NULL);                                      // crashstate
    deathstate: Ord(S_PLAY_DIE1);                                 // deathstate
    xdeathstate: Ord(S_PLAY_XDIE1);                               // xdeathstate
    deathsound: Ord(sfx_plrdth);                                  // deathsound
    speed: 0;                                                     // speed
    radius: 16 * FRACUNIT;                                        // radius
    height: 56 * FRACUNIT;                                        // height
    mass: 100;                                                    // mass
    damage: 0;                                                    // damage
    activesound: Ord(sfx_None);                                   // activesound
    flags: MF_SOLID or MF_SHOOTABLE or MF_DROPOFF or MF_PICKUP or MF_NOTDMATCH;    // flags
    flags2: MF2_WINDTHRUST or MF2_FOOTCLIP or MF2_SLIDE or MF2_PASSMOBJ or MF2_TELESTOMP;   // flags2
    pushfactor: DEFPUSHFACTOR;                                    // pushfactor
    scale: FRACUNIT;                                              // scale
    gravity: FRACUNIT;                                            // gravity
    flags3_ex: 0;                                                 // flags3_ex
    flags4_ex: 0;                                                 // flags4_ex
   ),

   (    // MT_BLOODYSKULL
    name: 'MT_BLOODYSKULL';
    inheritsfrom: -1;                                             // inheritsfrom
    doomednum: -1;                                                // doomednum
    spawnstate: Ord(S_BLOODYSKULL1);                              // spawnstate
    spawnhealth: 1000;                                            // spawnhealth
    seestate: Ord(S_NULL);                                        // seestate
    seesound: Ord(sfx_None);                                      // seesound
    reactiontime: 8;                                              // reactiontime
    attacksound: Ord(sfx_None);                                   // attacksound
    painstate: Ord(S_NULL);                                       // painstate
    painchance: 0;                                                // painchance
    painsound: Ord(sfx_None);                                     // painsound
    meleestate: Ord(S_NULL);                                      // meleestate
    missilestate: Ord(S_NULL);                                    // missilestate
    crashstate: Ord(S_NULL);                                      // crashstate
    deathstate: Ord(S_NULL);                                      // deathstate
    xdeathstate: Ord(S_NULL);                                     // xdeathstate
    deathsound: Ord(sfx_None);                                    // deathsound
    speed: 0;                                                     // speed
    radius: 4 * FRACUNIT;                                         // radius
    height: 4 * FRACUNIT;                                         // height
    mass: 100;                                                    // mass
    damage: 0;                                                    // damage
    activesound: Ord(sfx_None);                                   // activesound
    flags: MF_NOBLOCKMAP or MF_DROPOFF;                           // flags
    flags2: MF2_LOGRAV or MF2_CANNOTPUSH;                         // flags2
    pushfactor: DEFPUSHFACTOR;                                    // pushfactor
    scale: FRACUNIT;                                              // scale
    gravity: FRACUNIT;                                            // gravity
    flags3_ex: 0;                                                 // flags3_ex
    flags4_ex: 0;                                                 // flags4_ex
   ),

   (    // MT_CHICPLAYER
    name: 'MT_CHICPLAYER';
    inheritsfrom: -1;                                             // inheritsfrom
    doomednum: -1;                                                // doomednum
    spawnstate: Ord(S_CHICPLAY);                                  // spawnstate
    spawnhealth: 100;                                             // spawnhealth
    seestate: Ord(S_CHICPLAY_RUN1);                               // seestate
    seesound: Ord(sfx_None);                                      // seesound
    reactiontime: 0;                                              // reactiontime
    attacksound: Ord(sfx_None);                                   // attacksound
    painstate: Ord(S_CHICPLAY_PAIN);                              // painstate
    painchance: 255;                                              // painchance
    painsound: Ord(sfx_chicpai);                                  // painsound
    meleestate: Ord(S_NULL);                                      // meleestate
    missilestate: Ord(S_CHICPLAY_ATK1);                           // missilestate
    crashstate: Ord(S_NULL);                                      // crashstate
    deathstate: Ord(S_CHICKEN_DIE1);                              // deathstate
    xdeathstate: Ord(S_NULL);                                     // xdeathstate
    deathsound: Ord(sfx_chicdth);                                 // deathsound
    speed: 0;                                                     // speed
    radius: 16 * FRACUNIT;                                        // radius
    height: 24 * FRACUNIT;                                        // height
    mass: 100;                                                    // mass
    damage: 0;                                                    // damage
    activesound: Ord(sfx_None);                                   // activesound
    flags: MF_SOLID or MF_SHOOTABLE or MF_DROPOFF or MF_NOTDMATCH;    // flags
    flags2: MF2_WINDTHRUST or MF2_SLIDE or MF2_PASSMOBJ or MF2_FOOTCLIP or MF2_LOGRAV or MF2_TELESTOMP;   // flags2
    pushfactor: DEFPUSHFACTOR;                                    // pushfactor
    scale: FRACUNIT;                                              // scale
    gravity: FRACUNIT;                                            // gravity
    flags3_ex: 0;                                                 // flags3_ex
    flags4_ex: 0;                                                 // flags4_ex
   ),

   (    // MT_CHICKEN
    name: 'MT_CHICKEN';
    inheritsfrom: -1;                                             // inheritsfrom
    doomednum: -1;                                                // doomednum
    spawnstate: Ord(S_CHICKEN_LOOK1);                             // spawnstate
    spawnhealth: 10;                                              // spawnhealth
    seestate: Ord(S_CHICKEN_WALK1);                               // seestate
    seesound: Ord(sfx_chicpai);                                   // seesound
    reactiontime: 8;                                              // reactiontime
    attacksound: Ord(sfx_chicatk);                                // attacksound
    painstate: Ord(S_CHICKEN_PAIN1);                              // painstate
    painchance: 200;                                              // painchance
    painsound: Ord(sfx_chicpai);                                  // painsound
    meleestate: Ord(S_CHICKEN_ATK1);                              // meleestate
    missilestate: 0;                                              // missilestate
    crashstate: Ord(S_NULL);                                      // crashstate
    deathstate: Ord(S_CHICKEN_DIE1);                              // deathstate
    xdeathstate: Ord(S_NULL);                                     // xdeathstate
    deathsound: Ord(sfx_chicdth);                                 // deathsound
    speed: 4;                                                     // speed
    radius: 9 * FRACUNIT;                                         // radius
    height: 22 * FRACUNIT;                                        // height
    mass: 40;                                                     // mass
    damage: 0;                                                    // damage
    activesound: Ord(sfx_chicact);                                // activesound
    flags: MF_SOLID or MF_SHOOTABLE or MF_COUNTKILL or MF_DROPOFF;    // flags
    flags2: MF2_WINDTHRUST or MF2_FOOTCLIP or MF2_PASSMOBJ;       // flags2
    pushfactor: DEFPUSHFACTOR;                                    // pushfactor
    scale: FRACUNIT;                                              // scale
    gravity: FRACUNIT;                                            // gravity
    flags3_ex: 0;                                                 // flags3_ex
    flags4_ex: 0;                                                 // flags4_ex
   ),

   (    // MT_FEATHER
    name: 'MT_FEATHER';
    inheritsfrom: -1;                                             // inheritsfrom
    doomednum: -1;                                                // doomednum
    spawnstate: Ord(S_FEATHER1);                                  // spawnstate
    spawnhealth: 1000;                                            // spawnhealth
    seestate: Ord(S_NULL);                                        // seestate
    seesound: Ord(sfx_None);                                      // seesound
    reactiontime: 8;                                              // reactiontime
    attacksound: Ord(sfx_None);                                   // attacksound
    painstate: Ord(S_NULL);                                       // painstate
    painchance: 0;                                                // painchance
    painsound: Ord(sfx_None);                                     // painsound
    meleestate: Ord(S_NULL);                                      // meleestate
    missilestate: Ord(S_NULL);                                    // missilestate
    crashstate: Ord(S_NULL);                                      // crashstate
    deathstate: Ord(S_FEATHERX);                                  // deathstate
    xdeathstate: Ord(S_NULL);                                     // xdeathstate
    deathsound: Ord(sfx_None);                                    // deathsound
    speed: 0;                                                     // speed
    radius: 2 * FRACUNIT;                                         // radius
    height: 4 * FRACUNIT;                                         // height
    mass: 100;                                                    // mass
    damage: 0;                                                    // damage
    activesound: Ord(sfx_None);                                   // activesound
    flags: MF_NOBLOCKMAP or MF_MISSILE or MF_DROPOFF;             // flags
    flags2: MF2_NOTELEPORT or MF2_LOGRAV or MF2_CANNOTPUSH or MF2_WINDTHRUST;   // flags2
    pushfactor: DEFPUSHFACTOR;                                    // pushfactor
    scale: FRACUNIT;                                              // scale
    gravity: FRACUNIT;                                            // gravity
    flags3_ex: 0;                                                 // flags3_ex
    flags4_ex: 0;                                                 // flags4_ex
   ),

   (    // MT_MUMMY
    name: 'Golem';
    inheritsfrom: -1;                                             // inheritsfrom
    doomednum: 68;                                                // doomednum
    spawnstate: Ord(S_MUMMY_LOOK1);                               // spawnstate
    spawnhealth: 80;                                              // spawnhealth
    seestate: Ord(S_MUMMY_WALK1);                                 // seestate
    seesound: Ord(sfx_mumsit);                                    // seesound
    reactiontime: 8;                                              // reactiontime
    attacksound: Ord(sfx_mumat1);                                 // attacksound
    painstate: Ord(S_MUMMY_PAIN1);                                // painstate
    painchance: 128;                                              // painchance
    painsound: Ord(sfx_mumpai);                                   // painsound
    meleestate: Ord(S_MUMMY_ATK1);                                // meleestate
    missilestate: 0;                                              // missilestate
    crashstate: Ord(S_NULL);                                      // crashstate
    deathstate: Ord(S_MUMMY_DIE1);                                // deathstate
    xdeathstate: Ord(S_NULL);                                     // xdeathstate
    deathsound: Ord(sfx_mumdth);                                  // deathsound
    speed: 12;                                                    // speed
    radius: 22 * FRACUNIT;                                        // radius
    height: 62 * FRACUNIT;                                        // height
    mass: 75;                                                     // mass
    damage: 0;                                                    // damage
    activesound: Ord(sfx_mumact);                                 // activesound
    flags: MF_SOLID or MF_SHOOTABLE or MF_COUNTKILL;              // flags
    flags2: MF2_FOOTCLIP or MF2_PASSMOBJ;                         // flags2
    pushfactor: DEFPUSHFACTOR;                                    // pushfactor
    scale: FRACUNIT;                                              // scale
    gravity: FRACUNIT;                                            // gravity
    flags3_ex: 0;                                                 // flags3_ex
    flags4_ex: 0;                                                 // flags4_ex
   ),

   (    // MT_MUMMYLEADER
    name: 'Nitrogolem';
    inheritsfrom: -1;                                             // inheritsfrom
    doomednum: 45;                                                // doomednum
    spawnstate: Ord(S_MUMMY_LOOK1);                               // spawnstate
    spawnhealth: 100;                                             // spawnhealth
    seestate: Ord(S_MUMMY_WALK1);                                 // seestate
    seesound: Ord(sfx_mumsit);                                    // seesound
    reactiontime: 8;                                              // reactiontime
    attacksound: Ord(sfx_mumat1);                                 // attacksound
    painstate: Ord(S_MUMMY_PAIN1);                                // painstate
    painchance: 64;                                               // painchance
    painsound: Ord(sfx_mumpai);                                   // painsound
    meleestate: Ord(S_MUMMY_ATK1);                                // meleestate
    missilestate: Ord(S_MUMMYL_ATK1);                             // missilestate
    crashstate: Ord(S_NULL);                                      // crashstate
    deathstate: Ord(S_MUMMY_DIE1);                                // deathstate
    xdeathstate: Ord(S_NULL);                                     // xdeathstate
    deathsound: Ord(sfx_mumdth);                                  // deathsound
    speed: 12;                                                    // speed
    radius: 22 * FRACUNIT;                                        // radius
    height: 62 * FRACUNIT;                                        // height
    mass: 75;                                                     // mass
    damage: 0;                                                    // damage
    activesound: Ord(sfx_mumact);                                 // activesound
    flags: MF_SOLID or MF_SHOOTABLE or MF_COUNTKILL;              // flags
    flags2: MF2_FOOTCLIP or MF2_PASSMOBJ;                         // flags2
    pushfactor: DEFPUSHFACTOR;                                    // pushfactor
    scale: FRACUNIT;                                              // scale
    gravity: FRACUNIT;                                            // gravity
    flags3_ex: 0;                                                 // flags3_ex
    flags4_ex: 0;                                                 // flags4_ex
   ),

   (    // MT_MUMMYGHOST
    name: 'Golem Ghost';
    inheritsfrom: -1;                                             // inheritsfrom
    doomednum: 69;                                                // doomednum
    spawnstate: Ord(S_MUMMY_LOOK1);                               // spawnstate
    spawnhealth: 80;                                              // spawnhealth
    seestate: Ord(S_MUMMY_WALK1);                                 // seestate
    seesound: Ord(sfx_mumsit);                                    // seesound
    reactiontime: 8;                                              // reactiontime
    attacksound: Ord(sfx_mumat1);                                 // attacksound
    painstate: Ord(S_MUMMY_PAIN1);                                // painstate
    painchance: 128;                                              // painchance
    painsound: Ord(sfx_mumpai);                                   // painsound
    meleestate: Ord(S_MUMMY_ATK1);                                // meleestate
    missilestate: 0;                                              // missilestate
    crashstate: Ord(S_NULL);                                      // crashstate
    deathstate: Ord(S_MUMMY_DIE1);                                // deathstate
    xdeathstate: Ord(S_NULL);                                     // xdeathstate
    deathsound: Ord(sfx_mumdth);                                  // deathsound
    speed: 12;                                                    // speed
    radius: 22 * FRACUNIT;                                        // radius
    height: 62 * FRACUNIT;                                        // height
    mass: 75;                                                     // mass
    damage: 0;                                                    // damage
    activesound: Ord(sfx_mumact);                                 // activesound
    flags: MF_SOLID or MF_SHOOTABLE or MF_COUNTKILL or MF_SHADOW;    // flags
    flags2: MF2_FOOTCLIP or MF2_PASSMOBJ;                         // flags2
    pushfactor: DEFPUSHFACTOR;                                    // pushfactor
    scale: FRACUNIT;                                              // scale
    gravity: FRACUNIT;                                            // gravity
    flags3_ex: 0;                                                 // flags3_ex
    flags4_ex: 0;                                                 // flags4_ex
   ),

   (    // MT_MUMMYLEADERGHOST
    name: 'Nitrogolem Ghost';
    inheritsfrom: -1;                                             // inheritsfrom
    doomednum: 46;                                                // doomednum
    spawnstate: Ord(S_MUMMY_LOOK1);                               // spawnstate
    spawnhealth: 100;                                             // spawnhealth
    seestate: Ord(S_MUMMY_WALK1);                                 // seestate
    seesound: Ord(sfx_mumsit);                                    // seesound
    reactiontime: 8;                                              // reactiontime
    attacksound: Ord(sfx_mumat1);                                 // attacksound
    painstate: Ord(S_MUMMY_PAIN1);                                // painstate
    painchance: 64;                                               // painchance
    painsound: Ord(sfx_mumpai);                                   // painsound
    meleestate: Ord(S_MUMMY_ATK1);                                // meleestate
    missilestate: Ord(S_MUMMYL_ATK1);                             // missilestate
    crashstate: Ord(S_NULL);                                      // crashstate
    deathstate: Ord(S_MUMMY_DIE1);                                // deathstate
    xdeathstate: Ord(S_NULL);                                     // xdeathstate
    deathsound: Ord(sfx_mumdth);                                  // deathsound
    speed: 12;                                                    // speed
    radius: 22 * FRACUNIT;                                        // radius
    height: 62 * FRACUNIT;                                        // height
    mass: 75;                                                     // mass
    damage: 0;                                                    // damage
    activesound: Ord(sfx_mumact);                                 // activesound
    flags: MF_SOLID or MF_SHOOTABLE or MF_COUNTKILL or MF_SHADOW;    // flags
    flags2: MF2_FOOTCLIP or MF2_PASSMOBJ;                         // flags2
    pushfactor: DEFPUSHFACTOR;                                    // pushfactor
    scale: FRACUNIT;                                              // scale
    gravity: FRACUNIT;                                            // gravity
    flags3_ex: 0;                                                 // flags3_ex
    flags4_ex: 0;                                                 // flags4_ex
   ),

   (    // MT_MUMMYSOUL
    name: 'MT_MUMMYSOUL';
    inheritsfrom: -1;                                             // inheritsfrom
    doomednum: -1;                                                // doomednum
    spawnstate: Ord(S_MUMMY_SOUL1);                               // spawnstate
    spawnhealth: 1000;                                            // spawnhealth
    seestate: Ord(S_NULL);                                        // seestate
    seesound: Ord(sfx_None);                                      // seesound
    reactiontime: 8;                                              // reactiontime
    attacksound: Ord(sfx_None);                                   // attacksound
    painstate: Ord(S_NULL);                                       // painstate
    painchance: 0;                                                // painchance
    painsound: Ord(sfx_None);                                     // painsound
    meleestate: Ord(S_NULL);                                      // meleestate
    missilestate: Ord(S_NULL);                                    // missilestate
    crashstate: Ord(S_NULL);                                      // crashstate
    deathstate: Ord(S_NULL);                                      // deathstate
    xdeathstate: Ord(S_NULL);                                     // xdeathstate
    deathsound: Ord(sfx_None);                                    // deathsound
    speed: 0;                                                     // speed
    radius: 20 * FRACUNIT;                                        // radius
    height: 16 * FRACUNIT;                                        // height
    mass: 100;                                                    // mass
    damage: 0;                                                    // damage
    activesound: Ord(sfx_None);                                   // activesound
    flags: MF_NOBLOCKMAP or MF_NOGRAVITY;                         // flags
    flags2: 0;                                                    // flags2
    pushfactor: DEFPUSHFACTOR;                                    // pushfactor
    scale: FRACUNIT;                                              // scale
    gravity: FRACUNIT;                                            // gravity
    flags3_ex: 0;                                                 // flags3_ex
    flags4_ex: 0;                                                 // flags4_ex
   ),

   (    // MT_MUMMYFX1
    name: 'MT_MUMMYFX1';
    inheritsfrom: -1;                                             // inheritsfrom
    doomednum: -1;                                                // doomednum
    spawnstate: Ord(S_MUMMYFX1_1);                                // spawnstate
    spawnhealth: 1000;                                            // spawnhealth
    seestate: Ord(S_NULL);                                        // seestate
    seesound: 0;                                                  // seesound
    reactiontime: 8;                                              // reactiontime
    attacksound: Ord(sfx_None);                                   // attacksound
    painstate: Ord(S_NULL);                                       // painstate
    painchance: 0;                                                // painchance
    painsound: Ord(sfx_None);                                     // painsound
    meleestate: Ord(S_NULL);                                      // meleestate
    missilestate: Ord(S_NULL);                                    // missilestate
    crashstate: Ord(S_NULL);                                      // crashstate
    deathstate: Ord(S_MUMMYFXI1_1);                               // deathstate
    xdeathstate: Ord(S_NULL);                                     // xdeathstate
    deathsound: 0;                                                // deathsound
    speed: 9 * FRACUNIT;                                          // speed
    radius: 8 * FRACUNIT;                                         // radius
    height: 14 * FRACUNIT;                                        // height
    mass: 100;                                                    // mass
    damage: 4;                                                    // damage
    activesound: Ord(sfx_None);                                   // activesound
    flags: MF_NOBLOCKMAP or MF_MISSILE or MF_DROPOFF or MF_NOGRAVITY;    // flags
    flags2: MF2_NOTELEPORT;                                       // flags2
    pushfactor: DEFPUSHFACTOR;                                    // pushfactor
    scale: FRACUNIT;                                              // scale
    gravity: FRACUNIT;                                            // gravity
    flags3_ex: 0;                                                 // flags3_ex
    flags4_ex: 0;                                                 // flags4_ex
   ),

   (    // MT_BEAST
    name: 'Weredragon';
    inheritsfrom: -1;                                             // inheritsfrom
    doomednum: 70;                                                // doomednum
    spawnstate: Ord(S_BEAST_LOOK1);                               // spawnstate
    spawnhealth: 220;                                             // spawnhealth
    seestate: Ord(S_BEAST_WALK1);                                 // seestate
    seesound: Ord(sfx_bstsit);                                    // seesound
    reactiontime: 8;                                              // reactiontime
    attacksound: Ord(sfx_bstatk);                                 // attacksound
    painstate: Ord(S_BEAST_PAIN1);                                // painstate
    painchance: 100;                                              // painchance
    painsound: Ord(sfx_bstpai);                                   // painsound
    meleestate: 0;                                                // meleestate
    missilestate: Ord(S_BEAST_ATK1);                              // missilestate
    crashstate: Ord(S_NULL);                                      // crashstate
    deathstate: Ord(S_BEAST_DIE1);                                // deathstate
    xdeathstate: Ord(S_BEAST_XDIE1);                              // xdeathstate
    deathsound: Ord(sfx_bstdth);                                  // deathsound
    speed: 14;                                                    // speed
    radius: 32 * FRACUNIT;                                        // radius
    height: 74 * FRACUNIT;                                        // height
    mass: 200;                                                    // mass
    damage: 0;                                                    // damage
    activesound: Ord(sfx_bstact);                                 // activesound
    flags: MF_SOLID or MF_SHOOTABLE or MF_COUNTKILL;              // flags
    flags2: MF2_FOOTCLIP or MF2_PASSMOBJ;                         // flags2
    pushfactor: DEFPUSHFACTOR;                                    // pushfactor
    scale: FRACUNIT;                                              // scale
    gravity: FRACUNIT;                                            // gravity
    flags3_ex: 0;                                                 // flags3_ex
    flags4_ex: 0;                                                 // flags4_ex
   ),

   (    // MT_BEASTBALL
    name: 'MT_BEASTBALL';
    inheritsfrom: -1;                                             // inheritsfrom
    doomednum: -1;                                                // doomednum
    spawnstate: Ord(S_BEASTBALL1);                                // spawnstate
    spawnhealth: 1000;                                            // spawnhealth
    seestate: Ord(S_NULL);                                        // seestate
    seesound: 0;                                                  // seesound
    reactiontime: 8;                                              // reactiontime
    attacksound: Ord(sfx_None);                                   // attacksound
    painstate: Ord(S_NULL);                                       // painstate
    painchance: 0;                                                // painchance
    painsound: Ord(sfx_None);                                     // painsound
    meleestate: Ord(S_NULL);                                      // meleestate
    missilestate: Ord(S_NULL);                                    // missilestate
    crashstate: Ord(S_NULL);                                      // crashstate
    deathstate: Ord(S_BEASTBALLX1);                               // deathstate
    xdeathstate: Ord(S_NULL);                                     // xdeathstate
    deathsound: 0;                                                // deathsound
    speed: 12 * FRACUNIT;                                         // speed
    radius: 9 * FRACUNIT;                                         // radius
    height: 8 * FRACUNIT;                                         // height
    mass: 100;                                                    // mass
    damage: 4;                                                    // damage
    activesound: Ord(sfx_None);                                   // activesound
    flags: MF_NOBLOCKMAP or MF_MISSILE or MF_DROPOFF or MF_NOGRAVITY;    // flags
    flags2: MF2_WINDTHRUST or MF2_NOTELEPORT;                     // flags2
    pushfactor: DEFPUSHFACTOR;                                    // pushfactor
    scale: FRACUNIT;                                              // scale
    gravity: FRACUNIT;                                            // gravity
    flags3_ex: 0;                                                 // flags3_ex
    flags4_ex: 0;                                                 // flags4_ex
   ),

   (    // MT_BURNBALL
    name: 'MT_BURNBALL';
    inheritsfrom: -1;                                             // inheritsfrom
    doomednum: -1;                                                // doomednum
    spawnstate: Ord(S_BURNBALL1);                                 // spawnstate
    spawnhealth: 1000;                                            // spawnhealth
    seestate: Ord(S_NULL);                                        // seestate
    seesound: 0;                                                  // seesound
    reactiontime: 8;                                              // reactiontime
    attacksound: Ord(sfx_None);                                   // attacksound
    painstate: Ord(S_NULL);                                       // painstate
    painchance: 0;                                                // painchance
    painsound: Ord(sfx_None);                                     // painsound
    meleestate: Ord(S_NULL);                                      // meleestate
    missilestate: Ord(S_NULL);                                    // missilestate
    crashstate: Ord(S_NULL);                                      // crashstate
    deathstate: Ord(S_BEASTBALLX1);                               // deathstate
    xdeathstate: Ord(S_NULL);                                     // xdeathstate
    deathsound: 0;                                                // deathsound
    speed: 10 * FRACUNIT;                                         // speed
    radius: 6 * FRACUNIT;                                         // radius
    height: 8 * FRACUNIT;                                         // height
    mass: 100;                                                    // mass
    damage: 2;                                                    // damage
    activesound: Ord(sfx_None);                                   // activesound
    flags: MF_NOBLOCKMAP or MF_NOGRAVITY or MF_MISSILE;           // flags
    flags2: MF2_NOTELEPORT;                                       // flags2
    pushfactor: DEFPUSHFACTOR;                                    // pushfactor
    scale: FRACUNIT;                                              // scale
    gravity: FRACUNIT;                                            // gravity
    flags3_ex: 0;                                                 // flags3_ex
    flags4_ex: 0;                                                 // flags4_ex
   ),

   (    // MT_BURNBALLFB
    name: 'MT_BURNBALLFB';
    inheritsfrom: -1;                                             // inheritsfrom
    doomednum: -1;                                                // doomednum
    spawnstate: Ord(S_BURNBALLFB1);                               // spawnstate
    spawnhealth: 1000;                                            // spawnhealth
    seestate: Ord(S_NULL);                                        // seestate
    seesound: 0;                                                  // seesound
    reactiontime: 8;                                              // reactiontime
    attacksound: Ord(sfx_None);                                   // attacksound
    painstate: Ord(S_NULL);                                       // painstate
    painchance: 0;                                                // painchance
    painsound: Ord(sfx_None);                                     // painsound
    meleestate: Ord(S_NULL);                                      // meleestate
    missilestate: Ord(S_NULL);                                    // missilestate
    crashstate: Ord(S_NULL);                                      // crashstate
    deathstate: Ord(S_BEASTBALLX1);                               // deathstate
    xdeathstate: Ord(S_NULL);                                     // xdeathstate
    deathsound: 0;                                                // deathsound
    speed: 10 * FRACUNIT;                                         // speed
    radius: 6 * FRACUNIT;                                         // radius
    height: 8 * FRACUNIT;                                         // height
    mass: 100;                                                    // mass
    damage: 2;                                                    // damage
    activesound: Ord(sfx_None);                                   // activesound
    flags: MF_NOBLOCKMAP or MF_NOGRAVITY or MF_MISSILE;           // flags
    flags2: MF2_NOTELEPORT;                                       // flags2
    pushfactor: DEFPUSHFACTOR;                                    // pushfactor
    scale: FRACUNIT;                                              // scale
    gravity: FRACUNIT;                                            // gravity
    flags3_ex: 0;                                                 // flags3_ex
    flags4_ex: 0;                                                 // flags4_ex
   ),

   (    // MT_PUFFY
    name: 'MT_PUFFY';
    inheritsfrom: -1;                                             // inheritsfrom
    doomednum: -1;                                                // doomednum
    spawnstate: Ord(S_PUFFY1);                                    // spawnstate
    spawnhealth: 1000;                                            // spawnhealth
    seestate: Ord(S_NULL);                                        // seestate
    seesound: 0;                                                  // seesound
    reactiontime: 8;                                              // reactiontime
    attacksound: Ord(sfx_None);                                   // attacksound
    painstate: Ord(S_NULL);                                       // painstate
    painchance: 0;                                                // painchance
    painsound: Ord(sfx_None);                                     // painsound
    meleestate: Ord(S_NULL);                                      // meleestate
    missilestate: Ord(S_NULL);                                    // missilestate
    crashstate: Ord(S_NULL);                                      // crashstate
    deathstate: Ord(S_PUFFY1);                                    // deathstate
    xdeathstate: Ord(S_NULL);                                     // xdeathstate
    deathsound: 0;                                                // deathsound
    speed: 10 * FRACUNIT;                                         // speed
    radius: 6 * FRACUNIT;                                         // radius
    height: 8 * FRACUNIT;                                         // height
    mass: 100;                                                    // mass
    damage: 2;                                                    // damage
    activesound: Ord(sfx_None);                                   // activesound
    flags: MF_NOBLOCKMAP or MF_NOGRAVITY or MF_MISSILE;           // flags
    flags2: MF2_NOTELEPORT;                                       // flags2
    pushfactor: DEFPUSHFACTOR;                                    // pushfactor
    scale: FRACUNIT;                                              // scale
    gravity: FRACUNIT;                                            // gravity
    flags3_ex: 0;                                                 // flags3_ex
    flags4_ex: 0;                                                 // flags4_ex
   ),

   (    // MT_SNAKE
    name: 'Ophidian';
    inheritsfrom: -1;                                             // inheritsfrom
    doomednum: 92;                                                // doomednum
    spawnstate: Ord(S_SNAKE_LOOK1);                               // spawnstate
    spawnhealth: 280;                                             // spawnhealth
    seestate: Ord(S_SNAKE_WALK1);                                 // seestate
    seesound: Ord(sfx_snksit);                                    // seesound
    reactiontime: 8;                                              // reactiontime
    attacksound: Ord(sfx_snkatk);                                 // attacksound
    painstate: Ord(S_SNAKE_PAIN1);                                // painstate
    painchance: 48;                                               // painchance
    painsound: Ord(sfx_snkpai);                                   // painsound
    meleestate: 0;                                                // meleestate
    missilestate: Ord(S_SNAKE_ATK1);                              // missilestate
    crashstate: Ord(S_NULL);                                      // crashstate
    deathstate: Ord(S_SNAKE_DIE1);                                // deathstate
    xdeathstate: Ord(S_NULL);                                     // xdeathstate
    deathsound: Ord(sfx_snkdth);                                  // deathsound
    speed: 10;                                                    // speed
    radius: 22 * FRACUNIT;                                        // radius
    height: 70 * FRACUNIT;                                        // height
    mass: 100;                                                    // mass
    damage: 0;                                                    // damage
    activesound: Ord(sfx_snkact);                                 // activesound
    flags: MF_SOLID or MF_SHOOTABLE or MF_COUNTKILL;              // flags
    flags2: MF2_FOOTCLIP or MF2_PASSMOBJ;                         // flags2
    pushfactor: DEFPUSHFACTOR;                                    // pushfactor
    scale: FRACUNIT;                                              // scale
    gravity: FRACUNIT;                                            // gravity
    flags3_ex: 0;                                                 // flags3_ex
    flags4_ex: 0;                                                 // flags4_ex
   ),

   (    // MT_SNAKEPRO_A
    name: 'MT_SNAKEPRO_A';
    inheritsfrom: -1;                                             // inheritsfrom
    doomednum: -1;                                                // doomednum
    spawnstate: Ord(S_SNAKEPRO_A1);                               // spawnstate
    spawnhealth: 1000;                                            // spawnhealth
    seestate: Ord(S_NULL);                                        // seestate
    seesound: 0;                                                  // seesound
    reactiontime: 8;                                              // reactiontime
    attacksound: Ord(sfx_None);                                   // attacksound
    painstate: Ord(S_NULL);                                       // painstate
    painchance: 0;                                                // painchance
    painsound: Ord(sfx_None);                                     // painsound
    meleestate: Ord(S_NULL);                                      // meleestate
    missilestate: Ord(S_NULL);                                    // missilestate
    crashstate: Ord(S_NULL);                                      // crashstate
    deathstate: Ord(S_SNAKEPRO_AX1);                              // deathstate
    xdeathstate: Ord(S_NULL);                                     // xdeathstate
    deathsound: 0;                                                // deathsound
    speed: 14 * FRACUNIT;                                         // speed
    radius: 12 * FRACUNIT;                                        // radius
    height: 8 * FRACUNIT;                                         // height
    mass: 100;                                                    // mass
    damage: 1;                                                    // damage
    activesound: Ord(sfx_None);                                   // activesound
    flags: MF_NOBLOCKMAP or MF_MISSILE or MF_DROPOFF or MF_NOGRAVITY;    // flags
    flags2: MF2_WINDTHRUST or MF2_NOTELEPORT;                     // flags2
    pushfactor: DEFPUSHFACTOR;                                    // pushfactor
    scale: FRACUNIT;                                              // scale
    gravity: FRACUNIT;                                            // gravity
    flags3_ex: 0;                                                 // flags3_ex
    flags4_ex: 0;                                                 // flags4_ex
   ),

   (    // MT_SNAKEPRO_B
    name: 'MT_SNAKEPRO_B';
    inheritsfrom: -1;                                             // inheritsfrom
    doomednum: -1;                                                // doomednum
    spawnstate: Ord(S_SNAKEPRO_B1);                               // spawnstate
    spawnhealth: 1000;                                            // spawnhealth
    seestate: Ord(S_NULL);                                        // seestate
    seesound: 0;                                                  // seesound
    reactiontime: 8;                                              // reactiontime
    attacksound: Ord(sfx_None);                                   // attacksound
    painstate: Ord(S_NULL);                                       // painstate
    painchance: 0;                                                // painchance
    painsound: Ord(sfx_None);                                     // painsound
    meleestate: Ord(S_NULL);                                      // meleestate
    missilestate: Ord(S_NULL);                                    // missilestate
    crashstate: Ord(S_NULL);                                      // crashstate
    deathstate: Ord(S_SNAKEPRO_BX1);                              // deathstate
    xdeathstate: Ord(S_NULL);                                     // xdeathstate
    deathsound: 0;                                                // deathsound
    speed: 14 * FRACUNIT;                                         // speed
    radius: 12 * FRACUNIT;                                        // radius
    height: 8 * FRACUNIT;                                         // height
    mass: 100;                                                    // mass
    damage: 3;                                                    // damage
    activesound: Ord(sfx_None);                                   // activesound
    flags: MF_NOBLOCKMAP or MF_MISSILE or MF_DROPOFF or MF_NOGRAVITY;    // flags
    flags2: MF2_NOTELEPORT;                                       // flags2
    pushfactor: DEFPUSHFACTOR;                                    // pushfactor
    scale: FRACUNIT;                                              // scale
    gravity: FRACUNIT;                                            // gravity
    flags3_ex: 0;                                                 // flags3_ex
    flags4_ex: 0;                                                 // flags4_ex
   ),

   (    // MT_HEAD
    name: 'Iron Lich';
    inheritsfrom: -1;                                             // inheritsfrom
    doomednum: 6;                                                 // doomednum
    spawnstate: Ord(S_HEAD_LOOK);                                 // spawnstate
    spawnhealth: 700;                                             // spawnhealth
    seestate: Ord(S_HEAD_FLOAT);                                  // seestate
    seesound: Ord(sfx_hedsit);                                    // seesound
    reactiontime: 8;                                              // reactiontime
    attacksound: Ord(sfx_hedat1);                                 // attacksound
    painstate: Ord(S_HEAD_PAIN1);                                 // painstate
    painchance: 32;                                               // painchance
    painsound: Ord(sfx_hedpai);                                   // painsound
    meleestate: 0;                                                // meleestate
    missilestate: Ord(S_HEAD_ATK1);                               // missilestate
    crashstate: Ord(S_NULL);                                      // crashstate
    deathstate: Ord(S_HEAD_DIE1);                                 // deathstate
    xdeathstate: Ord(S_NULL);                                     // xdeathstate
    deathsound: Ord(sfx_heddth);                                  // deathsound
    speed: 6;                                                     // speed
    radius: 40 * FRACUNIT;                                        // radius
    height: 72 * FRACUNIT;                                        // height
    mass: 325;                                                    // mass
    damage: 0;                                                    // damage
    activesound: Ord(sfx_hedact);                                 // activesound
    flags: MF_SOLID or MF_SHOOTABLE or MF_COUNTKILL or MF_NOBLOOD;    // flags
    flags2: MF2_PASSMOBJ;                                         // flags2
    pushfactor: DEFPUSHFACTOR;                                    // pushfactor
    scale: FRACUNIT;                                              // scale
    gravity: FRACUNIT;                                            // gravity
    flags3_ex: 0;                                                 // flags3_ex
    flags4_ex: 0;                                                 // flags4_ex
   ),

   (    // MT_HEADFX1
    name: 'MT_HEADFX1';
    inheritsfrom: -1;                                             // inheritsfrom
    doomednum: -1;                                                // doomednum
    spawnstate: Ord(S_HEADFX1_1);                                 // spawnstate
    spawnhealth: 1000;                                            // spawnhealth
    seestate: Ord(S_NULL);                                        // seestate
    seesound: 0;                                                  // seesound
    reactiontime: 8;                                              // reactiontime
    attacksound: Ord(sfx_None);                                   // attacksound
    painstate: Ord(S_NULL);                                       // painstate
    painchance: 0;                                                // painchance
    painsound: Ord(sfx_None);                                     // painsound
    meleestate: Ord(S_NULL);                                      // meleestate
    missilestate: Ord(S_NULL);                                    // missilestate
    crashstate: Ord(S_NULL);                                      // crashstate
    deathstate: Ord(S_HEADFXI1_1);                                // deathstate
    xdeathstate: Ord(S_NULL);                                     // xdeathstate
    deathsound: 0;                                                // deathsound
    speed: 13 * FRACUNIT;                                         // speed
    radius: 12 * FRACUNIT;                                        // radius
    height: 6 * FRACUNIT;                                         // height
    mass: 100;                                                    // mass
    damage: 1;                                                    // damage
    activesound: Ord(sfx_None);                                   // activesound
    flags: MF_NOBLOCKMAP or MF_MISSILE or MF_DROPOFF or MF_NOGRAVITY;    // flags
    flags2: MF2_NOTELEPORT or MF2_THRUGHOST;                      // flags2
    pushfactor: DEFPUSHFACTOR;                                    // pushfactor
    scale: FRACUNIT;                                              // scale
    gravity: FRACUNIT;                                            // gravity
    flags3_ex: 0;                                                 // flags3_ex
    flags4_ex: 0;                                                 // flags4_ex
   ),

   (    // MT_HEADFX2
    name: 'MT_HEADFX2';
    inheritsfrom: -1;                                             // inheritsfrom
    doomednum: -1;                                                // doomednum
    spawnstate: Ord(S_HEADFX2_1);                                 // spawnstate
    spawnhealth: 1000;                                            // spawnhealth
    seestate: Ord(S_NULL);                                        // seestate
    seesound: 0;                                                  // seesound
    reactiontime: 8;                                              // reactiontime
    attacksound: Ord(sfx_None);                                   // attacksound
    painstate: Ord(S_NULL);                                       // painstate
    painchance: 0;                                                // painchance
    painsound: Ord(sfx_None);                                     // painsound
    meleestate: Ord(S_NULL);                                      // meleestate
    missilestate: Ord(S_NULL);                                    // missilestate
    crashstate: Ord(S_NULL);                                      // crashstate
    deathstate: Ord(S_HEADFXI2_1);                                // deathstate
    xdeathstate: Ord(S_NULL);                                     // xdeathstate
    deathsound: 0;                                                // deathsound
    speed: 8 * FRACUNIT;                                          // speed
    radius: 12 * FRACUNIT;                                        // radius
    height: 6 * FRACUNIT;                                         // height
    mass: 100;                                                    // mass
    damage: 3;                                                    // damage
    activesound: Ord(sfx_None);                                   // activesound
    flags: MF_NOBLOCKMAP or MF_MISSILE or MF_DROPOFF or MF_NOGRAVITY;    // flags
    flags2: MF2_NOTELEPORT;                                       // flags2
    pushfactor: DEFPUSHFACTOR;                                    // pushfactor
    scale: FRACUNIT;                                              // scale
    gravity: FRACUNIT;                                            // gravity
    flags3_ex: 0;                                                 // flags3_ex
    flags4_ex: 0;                                                 // flags4_ex
   ),

   (    // MT_HEADFX3
    name: 'MT_HEADFX3';
    inheritsfrom: -1;                                             // inheritsfrom
    doomednum: -1;                                                // doomednum
    spawnstate: Ord(S_HEADFX3_1);                                 // spawnstate
    spawnhealth: 1000;                                            // spawnhealth
    seestate: Ord(S_NULL);                                        // seestate
    seesound: 0;                                                  // seesound
    reactiontime: 8;                                              // reactiontime
    attacksound: Ord(sfx_None);                                   // attacksound
    painstate: Ord(S_NULL);                                       // painstate
    painchance: 0;                                                // painchance
    painsound: Ord(sfx_None);                                     // painsound
    meleestate: Ord(S_NULL);                                      // meleestate
    missilestate: Ord(S_NULL);                                    // missilestate
    crashstate: Ord(S_NULL);                                      // crashstate
    deathstate: Ord(S_HEADFXI3_1);                                // deathstate
    xdeathstate: Ord(S_NULL);                                     // xdeathstate
    deathsound: 0;                                                // deathsound
    speed: 10 * FRACUNIT;                                         // speed
    radius: 14 * FRACUNIT;                                        // radius
    height: 12 * FRACUNIT;                                        // height
    mass: 100;                                                    // mass
    damage: 5;                                                    // damage
    activesound: Ord(sfx_None);                                   // activesound
    flags: MF_NOBLOCKMAP or MF_MISSILE or MF_DROPOFF or MF_NOGRAVITY;    // flags
    flags2: MF2_WINDTHRUST or MF2_NOTELEPORT;                     // flags2
    pushfactor: DEFPUSHFACTOR;                                    // pushfactor
    scale: FRACUNIT;                                              // scale
    gravity: FRACUNIT;                                            // gravity
    flags3_ex: 0;                                                 // flags3_ex
    flags4_ex: 0;                                                 // flags4_ex
   ),

   (    // MT_WHIRLWIND
    name: 'MT_WHIRLWIND';
    inheritsfrom: -1;                                             // inheritsfrom
    doomednum: -1;                                                // doomednum
    spawnstate: Ord(S_HEADFX4_1);                                 // spawnstate
    spawnhealth: 1000;                                            // spawnhealth
    seestate: Ord(S_NULL);                                        // seestate
    seesound: 0;                                                  // seesound
    reactiontime: 8;                                              // reactiontime
    attacksound: Ord(sfx_None);                                   // attacksound
    painstate: Ord(S_NULL);                                       // painstate
    painchance: 0;                                                // painchance
    painsound: Ord(sfx_None);                                     // painsound
    meleestate: Ord(S_NULL);                                      // meleestate
    missilestate: Ord(S_NULL);                                    // missilestate
    crashstate: Ord(S_NULL);                                      // crashstate
    deathstate: Ord(S_HEADFXI4_1);                                // deathstate
    xdeathstate: Ord(S_NULL);                                     // xdeathstate
    deathsound: 0;                                                // deathsound
    speed: 10 * FRACUNIT;                                         // speed
    radius: 16 * FRACUNIT;                                        // radius
    height: 74 * FRACUNIT;                                        // height
    mass: 100;                                                    // mass
    damage: 1;                                                    // damage
    activesound: Ord(sfx_None);                                   // activesound
    flags: MF_NOBLOCKMAP or MF_MISSILE or MF_DROPOFF or MF_NOGRAVITY or MF_SHADOW;    // flags
    flags2: MF2_NOTELEPORT;                                       // flags2
    pushfactor: DEFPUSHFACTOR;                                    // pushfactor
    scale: FRACUNIT;                                              // scale
    gravity: FRACUNIT;                                            // gravity
    flags3_ex: 0;                                                 // flags3_ex
    flags4_ex: 0;                                                 // flags4_ex
   ),

   (    // MT_CLINK
    name: 'Sabreclaw';
    inheritsfrom: -1;                                             // inheritsfrom
    doomednum: 90;                                                // doomednum
    spawnstate: Ord(S_CLINK_LOOK1);                               // spawnstate
    spawnhealth: 150;                                             // spawnhealth
    seestate: Ord(S_CLINK_WALK1);                                 // seestate
    seesound: Ord(sfx_clksit);                                    // seesound
    reactiontime: 8;                                              // reactiontime
    attacksound: Ord(sfx_clkatk);                                 // attacksound
    painstate: Ord(S_CLINK_PAIN1);                                // painstate
    painchance: 32;                                               // painchance
    painsound: Ord(sfx_clkpai);                                   // painsound
    meleestate: Ord(S_CLINK_ATK1);                                // meleestate
    missilestate: 0;                                              // missilestate
    crashstate: Ord(S_NULL);                                      // crashstate
    deathstate: Ord(S_CLINK_DIE1);                                // deathstate
    xdeathstate: Ord(S_NULL);                                     // xdeathstate
    deathsound: Ord(sfx_clkdth);                                  // deathsound
    speed: 14;                                                    // speed
    radius: 20 * FRACUNIT;                                        // radius
    height: 64 * FRACUNIT;                                        // height
    mass: 75;                                                     // mass
    damage: 0;                                                    // damage
    activesound: Ord(sfx_clkact);                                 // activesound
    flags: MF_SOLID or MF_SHOOTABLE or MF_COUNTKILL or MF_NOBLOOD;    // flags
    flags2: MF2_FOOTCLIP or MF2_PASSMOBJ;                         // flags2
    pushfactor: DEFPUSHFACTOR;                                    // pushfactor
    scale: FRACUNIT;                                              // scale
    gravity: FRACUNIT;                                            // gravity
    flags3_ex: 0;                                                 // flags3_ex
    flags4_ex: 0;                                                 // flags4_ex
   ),

   (    // MT_WIZARD
    name: 'Disciple Of D''Sparil';
    inheritsfrom: -1;                                             // inheritsfrom
    doomednum: 15;                                                // doomednum
    spawnstate: Ord(S_WIZARD_LOOK1);                              // spawnstate
    spawnhealth: 180;                                             // spawnhealth
    seestate: Ord(S_WIZARD_WALK1);                                // seestate
    seesound: Ord(sfx_wizsit);                                    // seesound
    reactiontime: 8;                                              // reactiontime
    attacksound: Ord(sfx_wizatk);                                 // attacksound
    painstate: Ord(S_WIZARD_PAIN1);                               // painstate
    painchance: 64;                                               // painchance
    painsound: Ord(sfx_wizpai);                                   // painsound
    meleestate: 0;                                                // meleestate
    missilestate: Ord(S_WIZARD_ATK1);                             // missilestate
    crashstate: Ord(S_NULL);                                      // crashstate
    deathstate: Ord(S_WIZARD_DIE1);                               // deathstate
    xdeathstate: Ord(S_NULL);                                     // xdeathstate
    deathsound: Ord(sfx_wizdth);                                  // deathsound
    speed: 12;                                                    // speed
    radius: 16 * FRACUNIT;                                        // radius
    height: 68 * FRACUNIT;                                        // height
    mass: 100;                                                    // mass
    damage: 0;                                                    // damage
    activesound: Ord(sfx_wizact);                                 // activesound
    flags: MF_SOLID or MF_SHOOTABLE or MF_COUNTKILL or MF_FLOAT or MF_NOGRAVITY;    // flags
    flags2: MF2_PASSMOBJ;                                         // flags2
    pushfactor: DEFPUSHFACTOR;                                    // pushfactor
    scale: FRACUNIT;                                              // scale
    gravity: FRACUNIT;                                            // gravity
    flags3_ex: 0;                                                 // flags3_ex
    flags4_ex: 0;                                                 // flags4_ex
   ),

   (    // MT_WIZFX1
    name: 'MT_WIZFX1';
    inheritsfrom: -1;                                             // inheritsfrom
    doomednum: -1;                                                // doomednum
    spawnstate: Ord(S_WIZFX1_1);                                  // spawnstate
    spawnhealth: 1000;                                            // spawnhealth
    seestate: Ord(S_NULL);                                        // seestate
    seesound: 0;                                                  // seesound
    reactiontime: 8;                                              // reactiontime
    attacksound: Ord(sfx_None);                                   // attacksound
    painstate: Ord(S_NULL);                                       // painstate
    painchance: 0;                                                // painchance
    painsound: Ord(sfx_None);                                     // painsound
    meleestate: Ord(S_NULL);                                      // meleestate
    missilestate: Ord(S_NULL);                                    // missilestate
    crashstate: Ord(S_NULL);                                      // crashstate
    deathstate: Ord(S_WIZFXI1_1);                                 // deathstate
    xdeathstate: Ord(S_NULL);                                     // xdeathstate
    deathsound: 0;                                                // deathsound
    speed: 18 * FRACUNIT;                                         // speed
    radius: 10 * FRACUNIT;                                        // radius
    height: 6 * FRACUNIT;                                         // height
    mass: 100;                                                    // mass
    damage: 3;                                                    // damage
    activesound: Ord(sfx_None);                                   // activesound
    flags: MF_NOBLOCKMAP or MF_MISSILE or MF_DROPOFF or MF_NOGRAVITY;    // flags
    flags2: MF2_NOTELEPORT;                                       // flags2
    pushfactor: DEFPUSHFACTOR;                                    // pushfactor
    scale: FRACUNIT;                                              // scale
    gravity: FRACUNIT;                                            // gravity
    flags3_ex: 0;                                                 // flags3_ex
    flags4_ex: 0;                                                 // flags4_ex
   ),

   (    // MT_IMP
    name: 'Gargoyle';
    inheritsfrom: -1;                                             // inheritsfrom
    doomednum: 66;                                                // doomednum
    spawnstate: Ord(S_IMP_LOOK1);                                 // spawnstate
    spawnhealth: 40;                                              // spawnhealth
    seestate: Ord(S_IMP_FLY1);                                    // seestate
    seesound: Ord(sfx_impsit);                                    // seesound
    reactiontime: 8;                                              // reactiontime
    attacksound: Ord(sfx_impat1);                                 // attacksound
    painstate: Ord(S_IMP_PAIN1);                                  // painstate
    painchance: 200;                                              // painchance
    painsound: Ord(sfx_imppai);                                   // painsound
    meleestate: Ord(S_IMP_MEATK1);                                // meleestate
    missilestate: Ord(S_IMP_MSATK1_1);                            // missilestate
    crashstate: Ord(S_IMP_CRASH1);                                // crashstate
    deathstate: Ord(S_IMP_DIE1);                                  // deathstate
    xdeathstate: Ord(S_IMP_XDIE1);                                // xdeathstate
    deathsound: Ord(sfx_impdth);                                  // deathsound
    speed: 10;                                                    // speed
    radius: 16 * FRACUNIT;                                        // radius
    height: 36 * FRACUNIT;                                        // height
    mass: 50;                                                     // mass
    damage: 0;                                                    // damage
    activesound: Ord(sfx_impact);                                 // activesound
    flags: MF_SOLID or MF_SHOOTABLE or MF_FLOAT or MF_NOGRAVITY or MF_COUNTKILL;    // flags
    flags2: MF2_SPAWNFLOAT or MF2_PASSMOBJ;                       // flags2
    pushfactor: DEFPUSHFACTOR;                                    // pushfactor
    scale: FRACUNIT;                                              // scale
    gravity: FRACUNIT;                                            // gravity
    flags3_ex: 0;                                                 // flags3_ex
    flags4_ex: 0;                                                 // flags4_ex
   ),

   (    // MT_IMPLEADER
    name: 'Fire Gargoyle';
    inheritsfrom: -1;                                             // inheritsfrom
    doomednum: 5;                                                 // doomednum
    spawnstate: Ord(S_IMP_LOOK1);                                 // spawnstate
    spawnhealth: 80;                                              // spawnhealth
    seestate: Ord(S_IMP_FLY1);                                    // seestate
    seesound: Ord(sfx_impsit);                                    // seesound
    reactiontime: 8;                                              // reactiontime
    attacksound: Ord(sfx_impat2);                                 // attacksound
    painstate: Ord(S_IMP_PAIN1);                                  // painstate
    painchance: 200;                                              // painchance
    painsound: Ord(sfx_imppai);                                   // painsound
    meleestate: 0;                                                // meleestate
    missilestate: Ord(S_IMP_MSATK2_1);                            // missilestate
    crashstate: Ord(S_IMP_CRASH1);                                // crashstate
    deathstate: Ord(S_IMP_DIE1);                                  // deathstate
    xdeathstate: Ord(S_IMP_XDIE1);                                // xdeathstate
    deathsound: Ord(sfx_impdth);                                  // deathsound
    speed: 10;                                                    // speed
    radius: 16 * FRACUNIT;                                        // radius
    height: 36 * FRACUNIT;                                        // height
    mass: 50;                                                     // mass
    damage: 0;                                                    // damage
    activesound: Ord(sfx_impact);                                 // activesound
    flags: MF_SOLID or MF_SHOOTABLE or MF_FLOAT or MF_NOGRAVITY or MF_COUNTKILL;    // flags
    flags2: MF2_SPAWNFLOAT or MF2_PASSMOBJ;                       // flags2
    pushfactor: DEFPUSHFACTOR;                                    // pushfactor
    scale: FRACUNIT;                                              // scale
    gravity: FRACUNIT;                                            // gravity
    flags3_ex: 0;                                                 // flags3_ex
    flags4_ex: 0;                                                 // flags4_ex
   ),

   (    // MT_IMPCHUNK1
    name: 'MT_IMPCHUNK1';
    inheritsfrom: -1;                                             // inheritsfrom
    doomednum: -1;                                                // doomednum
    spawnstate: Ord(S_IMP_CHUNKA1);                               // spawnstate
    spawnhealth: 1000;                                            // spawnhealth
    seestate: Ord(S_NULL);                                        // seestate
    seesound: Ord(sfx_None);                                      // seesound
    reactiontime: 8;                                              // reactiontime
    attacksound: Ord(sfx_None);                                   // attacksound
    painstate: Ord(S_NULL);                                       // painstate
    painchance: 0;                                                // painchance
    painsound: Ord(sfx_None);                                     // painsound
    meleestate: Ord(S_NULL);                                      // meleestate
    missilestate: Ord(S_NULL);                                    // missilestate
    crashstate: Ord(S_NULL);                                      // crashstate
    deathstate: Ord(S_NULL);                                      // deathstate
    xdeathstate: Ord(S_NULL);                                     // xdeathstate
    deathsound: Ord(sfx_None);                                    // deathsound
    speed: 0;                                                     // speed
    radius: 20 * FRACUNIT;                                        // radius
    height: 16 * FRACUNIT;                                        // height
    mass: 100;                                                    // mass
    damage: 0;                                                    // damage
    activesound: Ord(sfx_None);                                   // activesound
    flags: MF_NOBLOCKMAP;                                         // flags
    flags2: 0;                                                    // flags2
    pushfactor: DEFPUSHFACTOR;                                    // pushfactor
    scale: FRACUNIT;                                              // scale
    gravity: FRACUNIT;                                            // gravity
    flags3_ex: 0;                                                 // flags3_ex
    flags4_ex: 0;                                                 // flags4_ex
   ),

   (    // MT_IMPCHUNK2
    name: 'MT_IMPCHUNK2';
    inheritsfrom: -1;                                             // inheritsfrom
    doomednum: -1;                                                // doomednum
    spawnstate: Ord(S_IMP_CHUNKB1);                               // spawnstate
    spawnhealth: 1000;                                            // spawnhealth
    seestate: Ord(S_NULL);                                        // seestate
    seesound: Ord(sfx_None);                                      // seesound
    reactiontime: 8;                                              // reactiontime
    attacksound: Ord(sfx_None);                                   // attacksound
    painstate: Ord(S_NULL);                                       // painstate
    painchance: 0;                                                // painchance
    painsound: Ord(sfx_None);                                     // painsound
    meleestate: Ord(S_NULL);                                      // meleestate
    missilestate: Ord(S_NULL);                                    // missilestate
    crashstate: Ord(S_NULL);                                      // crashstate
    deathstate: Ord(S_NULL);                                      // deathstate
    xdeathstate: Ord(S_NULL);                                     // xdeathstate
    deathsound: Ord(sfx_None);                                    // deathsound
    speed: 0;                                                     // speed
    radius: 20 * FRACUNIT;                                        // radius
    height: 16 * FRACUNIT;                                        // height
    mass: 100;                                                    // mass
    damage: 0;                                                    // damage
    activesound: Ord(sfx_None);                                   // activesound
    flags: MF_NOBLOCKMAP;                                         // flags
    flags2: 0;                                                    // flags2
    pushfactor: DEFPUSHFACTOR;                                    // pushfactor
    scale: FRACUNIT;                                              // scale
    gravity: FRACUNIT;                                            // gravity
    flags3_ex: 0;                                                 // flags3_ex
    flags4_ex: 0;                                                 // flags4_ex
   ),

   (    // MT_IMPBALL
    name: 'MT_IMPBALL';
    inheritsfrom: -1;                                             // inheritsfrom
    doomednum: -1;                                                // doomednum
    spawnstate: Ord(S_IMPFX1);                                    // spawnstate
    spawnhealth: 1000;                                            // spawnhealth
    seestate: Ord(S_NULL);                                        // seestate
    seesound: 0;                                                  // seesound
    reactiontime: 8;                                              // reactiontime
    attacksound: Ord(sfx_None);                                   // attacksound
    painstate: Ord(S_NULL);                                       // painstate
    painchance: 0;                                                // painchance
    painsound: Ord(sfx_None);                                     // painsound
    meleestate: Ord(S_NULL);                                      // meleestate
    missilestate: Ord(S_NULL);                                    // missilestate
    crashstate: Ord(S_NULL);                                      // crashstate
    deathstate: Ord(S_IMPFXI1);                                   // deathstate
    xdeathstate: Ord(S_NULL);                                     // xdeathstate
    deathsound: 0;                                                // deathsound
    speed: 10 * FRACUNIT;                                         // speed
    radius: 8 * FRACUNIT;                                         // radius
    height: 8 * FRACUNIT;                                         // height
    mass: 100;                                                    // mass
    damage: 1;                                                    // damage
    activesound: Ord(sfx_None);                                   // activesound
    flags: MF_NOBLOCKMAP or MF_MISSILE or MF_DROPOFF or MF_NOGRAVITY;    // flags
    flags2: MF2_WINDTHRUST or MF2_NOTELEPORT;                     // flags2
    pushfactor: DEFPUSHFACTOR;                                    // pushfactor
    scale: FRACUNIT;                                              // scale
    gravity: FRACUNIT;                                            // gravity
    flags3_ex: 0;                                                 // flags3_ex
    flags4_ex: 0;                                                 // flags4_ex
   ),

   (    // MT_KNIGHT
    name: 'Undead Warrior';
    inheritsfrom: -1;                                             // inheritsfrom
    doomednum: 64;                                                // doomednum
    spawnstate: Ord(S_KNIGHT_STND1);                              // spawnstate
    spawnhealth: 200;                                             // spawnhealth
    seestate: Ord(S_KNIGHT_WALK1);                                // seestate
    seesound: Ord(sfx_kgtsit);                                    // seesound
    reactiontime: 8;                                              // reactiontime
    attacksound: Ord(sfx_kgtatk);                                 // attacksound
    painstate: Ord(S_KNIGHT_PAIN1);                               // painstate
    painchance: 100;                                              // painchance
    painsound: Ord(sfx_kgtpai);                                   // painsound
    meleestate: Ord(S_KNIGHT_ATK1);                               // meleestate
    missilestate: Ord(S_KNIGHT_ATK1);                             // missilestate
    crashstate: Ord(S_NULL);                                      // crashstate
    deathstate: Ord(S_KNIGHT_DIE1);                               // deathstate
    xdeathstate: Ord(S_NULL);                                     // xdeathstate
    deathsound: Ord(sfx_kgtdth);                                  // deathsound
    speed: 12;                                                    // speed
    radius: 24 * FRACUNIT;                                        // radius
    height: 78 * FRACUNIT;                                        // height
    mass: 150;                                                    // mass
    damage: 0;                                                    // damage
    activesound: Ord(sfx_kgtact);                                 // activesound
    flags: MF_SOLID or MF_SHOOTABLE or MF_COUNTKILL;              // flags
    flags2: MF2_FOOTCLIP or MF2_PASSMOBJ;                         // flags2
    pushfactor: DEFPUSHFACTOR;                                    // pushfactor
    scale: FRACUNIT;                                              // scale
    gravity: FRACUNIT;                                            // gravity
    flags3_ex: 0;                                                 // flags3_ex
    flags4_ex: 0;                                                 // flags4_ex
   ),

   (    // MT_KNIGHTGHOST
    name: 'Undead Warrior Ghost';
    inheritsfrom: -1;                                             // inheritsfrom
    doomednum: 65;                                                // doomednum
    spawnstate: Ord(S_KNIGHT_STND1);                              // spawnstate
    spawnhealth: 200;                                             // spawnhealth
    seestate: Ord(S_KNIGHT_WALK1);                                // seestate
    seesound: Ord(sfx_kgtsit);                                    // seesound
    reactiontime: 8;                                              // reactiontime
    attacksound: Ord(sfx_kgtatk);                                 // attacksound
    painstate: Ord(S_KNIGHT_PAIN1);                               // painstate
    painchance: 100;                                              // painchance
    painsound: Ord(sfx_kgtpai);                                   // painsound
    meleestate: Ord(S_KNIGHT_ATK1);                               // meleestate
    missilestate: Ord(S_KNIGHT_ATK1);                             // missilestate
    crashstate: Ord(S_NULL);                                      // crashstate
    deathstate: Ord(S_KNIGHT_DIE1);                               // deathstate
    xdeathstate: Ord(S_NULL);                                     // xdeathstate
    deathsound: Ord(sfx_kgtdth);                                  // deathsound
    speed: 12;                                                    // speed
    radius: 24 * FRACUNIT;                                        // radius
    height: 78 * FRACUNIT;                                        // height
    mass: 150;                                                    // mass
    damage: 0;                                                    // damage
    activesound: Ord(sfx_kgtact);                                 // activesound
    flags: MF_SOLID or MF_SHOOTABLE or MF_COUNTKILL or MF_SHADOW;    // flags
    flags2: MF2_FOOTCLIP or MF2_PASSMOBJ;                         // flags2
    pushfactor: DEFPUSHFACTOR;                                    // pushfactor
    scale: FRACUNIT;                                              // scale
    gravity: FRACUNIT;                                            // gravity
    flags3_ex: 0;                                                 // flags3_ex
    flags4_ex: 0;                                                 // flags4_ex
   ),

   (    // MT_KNIGHTAXE
    name: 'MT_KNIGHTAXE';
    inheritsfrom: -1;                                             // inheritsfrom
    doomednum: -1;                                                // doomednum
    spawnstate: Ord(S_SPINAXE1);                                  // spawnstate
    spawnhealth: 1000;                                            // spawnhealth
    seestate: Ord(S_NULL);                                        // seestate
    seesound: 0;                                                  // seesound
    reactiontime: 8;                                              // reactiontime
    attacksound: Ord(sfx_None);                                   // attacksound
    painstate: Ord(S_NULL);                                       // painstate
    painchance: 0;                                                // painchance
    painsound: Ord(sfx_None);                                     // painsound
    meleestate: Ord(S_NULL);                                      // meleestate
    missilestate: Ord(S_NULL);                                    // missilestate
    crashstate: Ord(S_NULL);                                      // crashstate
    deathstate: Ord(S_SPINAXEX1);                                 // deathstate
    xdeathstate: Ord(S_NULL);                                     // xdeathstate
    deathsound: Ord(sfx_hrnhit);                                  // deathsound
    speed: 9 * FRACUNIT;                                          // speed
    radius: 10 * FRACUNIT;                                        // radius
    height: 8 * FRACUNIT;                                         // height
    mass: 100;                                                    // mass
    damage: 2;                                                    // damage
    activesound: Ord(sfx_None);                                   // activesound
    flags: MF_NOBLOCKMAP or MF_MISSILE or MF_DROPOFF or MF_NOGRAVITY;    // flags
    flags2: MF2_WINDTHRUST or MF2_NOTELEPORT or MF2_THRUGHOST;    // flags2
    pushfactor: DEFPUSHFACTOR;                                    // pushfactor
    scale: FRACUNIT;                                              // scale
    gravity: FRACUNIT;                                            // gravity
    flags3_ex: 0;                                                 // flags3_ex
    flags4_ex: 0;                                                 // flags4_ex
   ),

   (    // MT_REDAXE
    name: 'MT_REDAXE';
    inheritsfrom: -1;                                             // inheritsfrom
    doomednum: -1;                                                // doomednum
    spawnstate: Ord(S_REDAXE1);                                   // spawnstate
    spawnhealth: 1000;                                            // spawnhealth
    seestate: Ord(S_NULL);                                        // seestate
    seesound: 0;                                                  // seesound
    reactiontime: 8;                                              // reactiontime
    attacksound: Ord(sfx_None);                                   // attacksound
    painstate: Ord(S_NULL);                                       // painstate
    painchance: 0;                                                // painchance
    painsound: Ord(sfx_None);                                     // painsound
    meleestate: Ord(S_NULL);                                      // meleestate
    missilestate: Ord(S_NULL);                                    // missilestate
    crashstate: Ord(S_NULL);                                      // crashstate
    deathstate: Ord(S_REDAXEX1);                                  // deathstate
    xdeathstate: Ord(S_NULL);                                     // xdeathstate
    deathsound: Ord(sfx_hrnhit);                                  // deathsound
    speed: 9 * FRACUNIT;                                          // speed
    radius: 10 * FRACUNIT;                                        // radius
    height: 8 * FRACUNIT;                                         // height
    mass: 100;                                                    // mass
    damage: 7;                                                    // damage
    activesound: Ord(sfx_None);                                   // activesound
    flags: MF_NOBLOCKMAP or MF_MISSILE or MF_DROPOFF or MF_NOGRAVITY;    // flags
    flags2: MF2_NOTELEPORT or MF2_THRUGHOST;                      // flags2
    pushfactor: DEFPUSHFACTOR;                                    // pushfactor
    scale: FRACUNIT;                                              // scale
    gravity: FRACUNIT;                                            // gravity
    flags3_ex: 0;                                                 // flags3_ex
    flags4_ex: 0;                                                 // flags4_ex
   ),

   (    // MT_SORCERER1
    name: 'D''Sparil';
    inheritsfrom: -1;                                             // inheritsfrom
    doomednum: 7;                                                 // doomednum
    spawnstate: Ord(S_SRCR1_LOOK1);                               // spawnstate
    spawnhealth: 2000;                                            // spawnhealth
    seestate: Ord(S_SRCR1_WALK1);                                 // seestate
    seesound: Ord(sfx_sbtsit);                                    // seesound
    reactiontime: 8;                                              // reactiontime
    attacksound: Ord(sfx_sbtatk);                                 // attacksound
    painstate: Ord(S_SRCR1_PAIN1);                                // painstate
    painchance: 56;                                               // painchance
    painsound: Ord(sfx_sbtpai);                                   // painsound
    meleestate: 0;                                                // meleestate
    missilestate: Ord(S_SRCR1_ATK1);                              // missilestate
    crashstate: Ord(S_NULL);                                      // crashstate
    deathstate: Ord(S_SRCR1_DIE1);                                // deathstate
    xdeathstate: Ord(S_NULL);                                     // xdeathstate
    deathsound: Ord(sfx_sbtdth);                                  // deathsound
    speed: 16;                                                    // speed
    radius: 28 * FRACUNIT;                                        // radius
    height: 100 * FRACUNIT;                                       // height
    mass: 800;                                                    // mass
    damage: 0;                                                    // damage
    activesound: Ord(sfx_sbtact);                                 // activesound
    flags: MF_SOLID or MF_SHOOTABLE or MF_COUNTKILL;              // flags
    flags2: MF2_FOOTCLIP or MF2_PASSMOBJ or MF2_BOSS;             // flags2
    pushfactor: DEFPUSHFACTOR;                                    // pushfactor
    scale: FRACUNIT;                                              // scale
    gravity: FRACUNIT;                                            // gravity
    flags3_ex: 0;                                                 // flags3_ex
    flags4_ex: 0;                                                 // flags4_ex
   ),

   (    // MT_SRCRFX1
    name: 'MT_SRCRFX1';
    inheritsfrom: -1;                                             // inheritsfrom
    doomednum: -1;                                                // doomednum
    spawnstate: Ord(S_SRCRFX1_1);                                 // spawnstate
    spawnhealth: 1000;                                            // spawnhealth
    seestate: Ord(S_NULL);                                        // seestate
    seesound: 0;                                                  // seesound
    reactiontime: 8;                                              // reactiontime
    attacksound: Ord(sfx_None);                                   // attacksound
    painstate: Ord(S_NULL);                                       // painstate
    painchance: 0;                                                // painchance
    painsound: Ord(sfx_None);                                     // painsound
    meleestate: Ord(S_NULL);                                      // meleestate
    missilestate: Ord(S_NULL);                                    // missilestate
    crashstate: Ord(S_NULL);                                      // crashstate
    deathstate: Ord(S_SRCRFXI1_1);                                // deathstate
    xdeathstate: Ord(S_NULL);                                     // xdeathstate
    deathsound: 0;                                                // deathsound
    speed: 20 * FRACUNIT;                                         // speed
    radius: 10 * FRACUNIT;                                        // radius
    height: 10 * FRACUNIT;                                        // height
    mass: 100;                                                    // mass
    damage: 10;                                                   // damage
    activesound: Ord(sfx_None);                                   // activesound
    flags: MF_NOBLOCKMAP or MF_MISSILE or MF_DROPOFF or MF_NOGRAVITY;    // flags
    flags2: MF2_NOTELEPORT or MF2_FIREDAMAGE;                     // flags2
    pushfactor: DEFPUSHFACTOR;                                    // pushfactor
    scale: FRACUNIT;                                              // scale
    gravity: FRACUNIT;                                            // gravity
    flags3_ex: 0;                                                 // flags3_ex
    flags4_ex: 0;                                                 // flags4_ex
   ),

   (    // MT_SORCERER2
    name: 'MT_SORCERER2';
    inheritsfrom: -1;                                             // inheritsfrom
    doomednum: -1;                                                // doomednum
    spawnstate: Ord(S_SOR2_LOOK1);                                // spawnstate
    spawnhealth: 3500;                                            // spawnhealth
    seestate: Ord(S_SOR2_WALK1);                                  // seestate
    seesound: Ord(sfx_sorsit);                                    // seesound
    reactiontime: 8;                                              // reactiontime
    attacksound: Ord(sfx_soratk);                                 // attacksound
    painstate: Ord(S_SOR2_PAIN1);                                 // painstate
    painchance: 32;                                               // painchance
    painsound: Ord(sfx_sorpai);                                   // painsound
    meleestate: 0;                                                // meleestate
    missilestate: Ord(S_SOR2_ATK1);                               // missilestate
    crashstate: Ord(S_NULL);                                      // crashstate
    deathstate: Ord(S_SOR2_DIE1);                                 // deathstate
    xdeathstate: Ord(S_NULL);                                     // xdeathstate
    deathsound: 0;                                                // deathsound
    speed: 14;                                                    // speed
    radius: 16 * FRACUNIT;                                        // radius
    height: 70 * FRACUNIT;                                        // height
    mass: 300;                                                    // mass
    damage: 0;                                                    // damage
    activesound: Ord(sfx_soract);                                 // activesound
    flags: MF_SOLID or MF_SHOOTABLE or MF_COUNTKILL or MF_DROPOFF;    // flags
    flags2: MF2_FOOTCLIP or MF2_PASSMOBJ or MF2_BOSS;             // flags2
    pushfactor: DEFPUSHFACTOR;                                    // pushfactor
    scale: FRACUNIT;                                              // scale
    gravity: FRACUNIT;                                            // gravity
    flags3_ex: 0;                                                 // flags3_ex
    flags4_ex: 0;                                                 // flags4_ex
   ),

   (    // MT_SOR2FX1
    name: 'MT_SOR2FX1';
    inheritsfrom: -1;                                             // inheritsfrom
    doomednum: -1;                                                // doomednum
    spawnstate: Ord(S_SOR2FX1_1);                                 // spawnstate
    spawnhealth: 1000;                                            // spawnhealth
    seestate: Ord(S_NULL);                                        // seestate
    seesound: 0;                                                  // seesound
    reactiontime: 8;                                              // reactiontime
    attacksound: Ord(sfx_None);                                   // attacksound
    painstate: Ord(S_NULL);                                       // painstate
    painchance: 0;                                                // painchance
    painsound: Ord(sfx_None);                                     // painsound
    meleestate: Ord(S_NULL);                                      // meleestate
    missilestate: Ord(S_NULL);                                    // missilestate
    crashstate: Ord(S_NULL);                                      // crashstate
    deathstate: Ord(S_SOR2FXI1_1);                                // deathstate
    xdeathstate: Ord(S_NULL);                                     // xdeathstate
    deathsound: 0;                                                // deathsound
    speed: 20 * FRACUNIT;                                         // speed
    radius: 10 * FRACUNIT;                                        // radius
    height: 6 * FRACUNIT;                                         // height
    mass: 100;                                                    // mass
    damage: 1;                                                    // damage
    activesound: Ord(sfx_None);                                   // activesound
    flags: MF_NOBLOCKMAP or MF_MISSILE or MF_DROPOFF or MF_NOGRAVITY;    // flags
    flags2: MF2_NOTELEPORT;                                       // flags2
    pushfactor: DEFPUSHFACTOR;                                    // pushfactor
    scale: FRACUNIT;                                              // scale
    gravity: FRACUNIT;                                            // gravity
    flags3_ex: 0;                                                 // flags3_ex
    flags4_ex: 0;                                                 // flags4_ex
   ),

   (    // MT_SOR2FXSPARK
    name: 'MT_SOR2FXSPARK';
    inheritsfrom: -1;                                             // inheritsfrom
    doomednum: -1;                                                // doomednum
    spawnstate: Ord(S_SOR2FXSPARK1);                              // spawnstate
    spawnhealth: 1000;                                            // spawnhealth
    seestate: Ord(S_NULL);                                        // seestate
    seesound: Ord(sfx_None);                                      // seesound
    reactiontime: 8;                                              // reactiontime
    attacksound: Ord(sfx_None);                                   // attacksound
    painstate: Ord(S_NULL);                                       // painstate
    painchance: 0;                                                // painchance
    painsound: Ord(sfx_None);                                     // painsound
    meleestate: Ord(S_NULL);                                      // meleestate
    missilestate: Ord(S_NULL);                                    // missilestate
    crashstate: Ord(S_NULL);                                      // crashstate
    deathstate: Ord(S_NULL);                                      // deathstate
    xdeathstate: Ord(S_NULL);                                     // xdeathstate
    deathsound: Ord(sfx_None);                                    // deathsound
    speed: 0;                                                     // speed
    radius: 20 * FRACUNIT;                                        // radius
    height: 16 * FRACUNIT;                                        // height
    mass: 100;                                                    // mass
    damage: 0;                                                    // damage
    activesound: Ord(sfx_None);                                   // activesound
    flags: MF_NOBLOCKMAP or MF_NOGRAVITY;                         // flags
    flags2: MF2_NOTELEPORT or MF2_CANNOTPUSH;                     // flags2
    pushfactor: DEFPUSHFACTOR;                                    // pushfactor
    scale: FRACUNIT;                                              // scale
    gravity: FRACUNIT;                                            // gravity
    flags3_ex: 0;                                                 // flags3_ex
    flags4_ex: 0;                                                 // flags4_ex
   ),

   (    // MT_SOR2FX2
    name: 'MT_SOR2FX2';
    inheritsfrom: -1;                                             // inheritsfrom
    doomednum: -1;                                                // doomednum
    spawnstate: Ord(S_SOR2FX2_1);                                 // spawnstate
    spawnhealth: 1000;                                            // spawnhealth
    seestate: Ord(S_NULL);                                        // seestate
    seesound: 0;                                                  // seesound
    reactiontime: 8;                                              // reactiontime
    attacksound: Ord(sfx_None);                                   // attacksound
    painstate: Ord(S_NULL);                                       // painstate
    painchance: 0;                                                // painchance
    painsound: Ord(sfx_None);                                     // painsound
    meleestate: Ord(S_NULL);                                      // meleestate
    missilestate: Ord(S_NULL);                                    // missilestate
    crashstate: Ord(S_NULL);                                      // crashstate
    deathstate: Ord(S_SOR2FXI2_1);                                // deathstate
    xdeathstate: Ord(S_NULL);                                     // xdeathstate
    deathsound: 0;                                                // deathsound
    speed: 6 * FRACUNIT;                                          // speed
    radius: 10 * FRACUNIT;                                        // radius
    height: 6 * FRACUNIT;                                         // height
    mass: 100;                                                    // mass
    damage: 10;                                                   // damage
    activesound: Ord(sfx_None);                                   // activesound
    flags: MF_NOBLOCKMAP or MF_MISSILE or MF_DROPOFF or MF_NOGRAVITY;    // flags
    flags2: MF2_NOTELEPORT;                                       // flags2
    pushfactor: DEFPUSHFACTOR;                                    // pushfactor
    scale: FRACUNIT;                                              // scale
    gravity: FRACUNIT;                                            // gravity
    flags3_ex: 0;                                                 // flags3_ex
    flags4_ex: 0;                                                 // flags4_ex
   ),

   (    // MT_SOR2TELEFADE
    name: 'MT_SOR2TELEFADE';
    inheritsfrom: -1;                                             // inheritsfrom
    doomednum: -1;                                                // doomednum
    spawnstate: Ord(S_SOR2TELEFADE1);                             // spawnstate
    spawnhealth: 1000;                                            // spawnhealth
    seestate: Ord(S_NULL);                                        // seestate
    seesound: Ord(sfx_None);                                      // seesound
    reactiontime: 8;                                              // reactiontime
    attacksound: Ord(sfx_None);                                   // attacksound
    painstate: Ord(S_NULL);                                       // painstate
    painchance: 0;                                                // painchance
    painsound: Ord(sfx_None);                                     // painsound
    meleestate: Ord(S_NULL);                                      // meleestate
    missilestate: Ord(S_NULL);                                    // missilestate
    crashstate: Ord(S_NULL);                                      // crashstate
    deathstate: Ord(S_NULL);                                      // deathstate
    xdeathstate: Ord(S_NULL);                                     // xdeathstate
    deathsound: Ord(sfx_None);                                    // deathsound
    speed: 0;                                                     // speed
    radius: 20 * FRACUNIT;                                        // radius
    height: 16 * FRACUNIT;                                        // height
    mass: 100;                                                    // mass
    damage: 0;                                                    // damage
    activesound: Ord(sfx_None);                                   // activesound
    flags: MF_NOBLOCKMAP;                                         // flags
    flags2: 0;                                                    // flags2
    pushfactor: DEFPUSHFACTOR;                                    // pushfactor
    scale: FRACUNIT;                                              // scale
    gravity: FRACUNIT;                                            // gravity
    flags3_ex: 0;                                                 // flags3_ex
    flags4_ex: 0;                                                 // flags4_ex
   ),

   (    // MT_MINOTAUR
    name: 'Maulotaur';
    inheritsfrom: -1;                                             // inheritsfrom
    doomednum: 9;                                                 // doomednum
    spawnstate: Ord(S_MNTR_LOOK1);                                // spawnstate
    spawnhealth: 3000;                                            // spawnhealth
    seestate: Ord(S_MNTR_WALK1);                                  // seestate
    seesound: Ord(sfx_minsit);                                    // seesound
    reactiontime: 8;                                              // reactiontime
    attacksound: Ord(sfx_minat1);                                 // attacksound
    painstate: Ord(S_MNTR_PAIN1);                                 // painstate
    painchance: 25;                                               // painchance
    painsound: Ord(sfx_minpai);                                   // painsound
    meleestate: Ord(S_MNTR_ATK1_1);                               // meleestate
    missilestate: Ord(S_MNTR_ATK2_1);                             // missilestate
    crashstate: Ord(S_NULL);                                      // crashstate
    deathstate: Ord(S_MNTR_DIE1);                                 // deathstate
    xdeathstate: Ord(S_NULL);                                     // xdeathstate
    deathsound: Ord(sfx_mindth);                                  // deathsound
    speed: 16;                                                    // speed
    radius: 28 * FRACUNIT;                                        // radius
    height: 100 * FRACUNIT;                                       // height
    mass: 800;                                                    // mass
    damage: 7;                                                    // damage
    activesound: Ord(sfx_minact);                                 // activesound
    flags: MF_SOLID or MF_SHOOTABLE or MF_COUNTKILL or MF_DROPOFF;    // flags
    flags2: MF2_FOOTCLIP or MF2_PASSMOBJ or MF2_BOSS;             // flags2
    pushfactor: DEFPUSHFACTOR;                                    // pushfactor
    scale: FRACUNIT;                                              // scale
    gravity: FRACUNIT;                                            // gravity
    flags3_ex: 0;                                                 // flags3_ex
    flags4_ex: 0;                                                 // flags4_ex
   ),

   (    // MT_MNTRFX1
    name: 'Flaming Pellets ranged attack';
    inheritsfrom: -1;                                             // inheritsfrom
    doomednum: -1;                                                // doomednum
    spawnstate: Ord(S_MNTRFX1_1);                                 // spawnstate
    spawnhealth: 1000;                                            // spawnhealth
    seestate: Ord(S_NULL);                                        // seestate
    seesound: 0;                                                  // seesound
    reactiontime: 8;                                              // reactiontime
    attacksound: Ord(sfx_None);                                   // attacksound
    painstate: Ord(S_NULL);                                       // painstate
    painchance: 0;                                                // painchance
    painsound: Ord(sfx_None);                                     // painsound
    meleestate: Ord(S_NULL);                                      // meleestate
    missilestate: Ord(S_NULL);                                    // missilestate
    crashstate: Ord(S_NULL);                                      // crashstate
    deathstate: Ord(S_MNTRFXI1_1);                                // deathstate
    xdeathstate: Ord(S_NULL);                                     // xdeathstate
    deathsound: 0;                                                // deathsound
    speed: 20 * FRACUNIT;                                         // speed
    radius: 10 * FRACUNIT;                                        // radius
    height: 6 * FRACUNIT;                                         // height
    mass: 100;                                                    // mass
    damage: 3;                                                    // damage
    activesound: Ord(sfx_None);                                   // activesound
    flags: MF_NOBLOCKMAP or MF_MISSILE or MF_DROPOFF or MF_NOGRAVITY;    // flags
    flags2: MF2_NOTELEPORT or MF2_FIREDAMAGE;                     // flags2
    pushfactor: DEFPUSHFACTOR;                                    // pushfactor
    scale: FRACUNIT;                                              // scale
    gravity: FRACUNIT;                                            // gravity
    flags3_ex: 0;                                                 // flags3_ex
    flags4_ex: 0;                                                 // flags4_ex
   ),

   (    // MT_MNTRFX2
    name: 'Ground Flame ranged attack';
    inheritsfrom: -1;                                             // inheritsfrom
    doomednum: -1;                                                // doomednum
    spawnstate: Ord(S_MNTRFX2_1);                                 // spawnstate
    spawnhealth: 1000;                                            // spawnhealth
    seestate: Ord(S_NULL);                                        // seestate
    seesound: 0;                                                  // seesound
    reactiontime: 8;                                              // reactiontime
    attacksound: Ord(sfx_None);                                   // attacksound
    painstate: Ord(S_NULL);                                       // painstate
    painchance: 0;                                                // painchance
    painsound: Ord(sfx_None);                                     // painsound
    meleestate: Ord(S_NULL);                                      // meleestate
    missilestate: Ord(S_NULL);                                    // missilestate
    crashstate: Ord(S_NULL);                                      // crashstate
    deathstate: Ord(S_MNTRFXI2_1);                                // deathstate
    xdeathstate: Ord(S_NULL);                                     // xdeathstate
    deathsound: Ord(sfx_phohit);                                  // deathsound
    speed: 14 * FRACUNIT;                                         // speed
    radius: 5 * FRACUNIT;                                         // radius
    height: 12 * FRACUNIT;                                        // height
    mass: 100;                                                    // mass
    damage: 4;                                                    // damage
    activesound: Ord(sfx_None);                                   // activesound
    flags: MF_NOBLOCKMAP or MF_MISSILE or MF_DROPOFF or MF_NOGRAVITY;    // flags
    flags2: MF2_NOTELEPORT or MF2_FIREDAMAGE;                     // flags2
    pushfactor: DEFPUSHFACTOR;                                    // pushfactor
    scale: FRACUNIT;                                              // scale
    gravity: FRACUNIT;                                            // gravity
    flags3_ex: 0;                                                 // flags3_ex
    flags4_ex: 0;                                                 // flags4_ex
   ),

   (    // MT_MNTRFX3
    name: 'MT_MNTRFX3';
    inheritsfrom: -1;                                             // inheritsfrom
    doomednum: -1;                                                // doomednum
    spawnstate: Ord(S_MNTRFX3_1);                                 // spawnstate
    spawnhealth: 1000;                                            // spawnhealth
    seestate: Ord(S_NULL);                                        // seestate
    seesound: 0;                                                  // seesound
    reactiontime: 8;                                              // reactiontime
    attacksound: Ord(sfx_None);                                   // attacksound
    painstate: Ord(S_NULL);                                       // painstate
    painchance: 0;                                                // painchance
    painsound: Ord(sfx_None);                                     // painsound
    meleestate: Ord(S_NULL);                                      // meleestate
    missilestate: Ord(S_NULL);                                    // missilestate
    crashstate: Ord(S_NULL);                                      // crashstate
    deathstate: Ord(S_MNTRFXI2_1);                                // deathstate
    xdeathstate: Ord(S_NULL);                                     // xdeathstate
    deathsound: Ord(sfx_phohit);                                  // deathsound
    speed: 0;                                                     // speed
    radius: 8 * FRACUNIT;                                         // radius
    height: 16 * FRACUNIT;                                        // height
    mass: 100;                                                    // mass
    damage: 4;                                                    // damage
    activesound: Ord(sfx_None);                                   // activesound
    flags: MF_NOBLOCKMAP or MF_MISSILE or MF_DROPOFF or MF_NOGRAVITY;    // flags
    flags2: MF2_NOTELEPORT or MF2_FIREDAMAGE;                     // flags2
    pushfactor: DEFPUSHFACTOR;                                    // pushfactor
    scale: FRACUNIT;                                              // scale
    gravity: FRACUNIT;                                            // gravity
    flags3_ex: 0;                                                 // flags3_ex
    flags4_ex: 0;                                                 // flags4_ex
   ),

   (    // MT_AKYY
    name: 'Green Key';
    inheritsfrom: -1;                                             // inheritsfrom
    doomednum: 73;                                                // doomednum
    spawnstate: Ord(S_AKYY1);                                     // spawnstate
    spawnhealth: 1000;                                            // spawnhealth
    seestate: Ord(S_NULL);                                        // seestate
    seesound: Ord(sfx_None);                                      // seesound
    reactiontime: 8;                                              // reactiontime
    attacksound: Ord(sfx_None);                                   // attacksound
    painstate: Ord(S_NULL);                                       // painstate
    painchance: 0;                                                // painchance
    painsound: Ord(sfx_None);                                     // painsound
    meleestate: Ord(S_NULL);                                      // meleestate
    missilestate: Ord(S_NULL);                                    // missilestate
    crashstate: Ord(S_NULL);                                      // crashstate
    deathstate: Ord(S_NULL);                                      // deathstate
    xdeathstate: Ord(S_NULL);                                     // xdeathstate
    deathsound: Ord(sfx_None);                                    // deathsound
    speed: 0;                                                     // speed
    radius: 20 * FRACUNIT;                                        // radius
    height: 16 * FRACUNIT;                                        // height
    mass: 100;                                                    // mass
    damage: 0;                                                    // damage
    activesound: Ord(sfx_None);                                   // activesound
    flags: MF_SPECIAL or MF_NOTDMATCH;                            // flags
    flags2: 0;                                                    // flags2
    pushfactor: DEFPUSHFACTOR;                                    // pushfactor
    scale: FRACUNIT;                                              // scale
    gravity: FRACUNIT;                                            // gravity
    flags3_ex: 0;                                                 // flags3_ex
    flags4_ex: 0;                                                 // flags4_ex
   ),

   (    // MT_BKYY
    name: 'Blue Key';
    inheritsfrom: -1;                                             // inheritsfrom
    doomednum: 79;                                                // doomednum
    spawnstate: Ord(S_BKYY1);                                     // spawnstate
    spawnhealth: 1000;                                            // spawnhealth
    seestate: Ord(S_NULL);                                        // seestate
    seesound: Ord(sfx_None);                                      // seesound
    reactiontime: 8;                                              // reactiontime
    attacksound: Ord(sfx_None);                                   // attacksound
    painstate: Ord(S_NULL);                                       // painstate
    painchance: 0;                                                // painchance
    painsound: Ord(sfx_None);                                     // painsound
    meleestate: Ord(S_NULL);                                      // meleestate
    missilestate: Ord(S_NULL);                                    // missilestate
    crashstate: Ord(S_NULL);                                      // crashstate
    deathstate: Ord(S_NULL);                                      // deathstate
    xdeathstate: Ord(S_NULL);                                     // xdeathstate
    deathsound: Ord(sfx_None);                                    // deathsound
    speed: 0;                                                     // speed
    radius: 20 * FRACUNIT;                                        // radius
    height: 16 * FRACUNIT;                                        // height
    mass: 100;                                                    // mass
    damage: 0;                                                    // damage
    activesound: Ord(sfx_None);                                   // activesound
    flags: MF_SPECIAL or MF_NOTDMATCH;                            // flags
    flags2: 0;                                                    // flags2
    pushfactor: DEFPUSHFACTOR;                                    // pushfactor
    scale: FRACUNIT;                                              // scale
    gravity: FRACUNIT;                                            // gravity
    flags3_ex: 0;                                                 // flags3_ex
    flags4_ex: 0;                                                 // flags4_ex
   ),

   (    // MT_CKEY
    name: 'Yellow Key';
    inheritsfrom: -1;                                             // inheritsfrom
    doomednum: 80;                                                // doomednum
    spawnstate: Ord(S_CKYY1);                                     // spawnstate
    spawnhealth: 1000;                                            // spawnhealth
    seestate: Ord(S_NULL);                                        // seestate
    seesound: Ord(sfx_None);                                      // seesound
    reactiontime: 8;                                              // reactiontime
    attacksound: Ord(sfx_None);                                   // attacksound
    painstate: Ord(S_NULL);                                       // painstate
    painchance: 0;                                                // painchance
    painsound: Ord(sfx_None);                                     // painsound
    meleestate: Ord(S_NULL);                                      // meleestate
    missilestate: Ord(S_NULL);                                    // missilestate
    crashstate: Ord(S_NULL);                                      // crashstate
    deathstate: Ord(S_NULL);                                      // deathstate
    xdeathstate: Ord(S_NULL);                                     // xdeathstate
    deathsound: Ord(sfx_None);                                    // deathsound
    speed: 0;                                                     // speed
    radius: 20 * FRACUNIT;                                        // radius
    height: 16 * FRACUNIT;                                        // height
    mass: 100;                                                    // mass
    damage: 0;                                                    // damage
    activesound: Ord(sfx_None);                                   // activesound
    flags: MF_SPECIAL or MF_NOTDMATCH;                            // flags
    flags2: 0;                                                    // flags2
    pushfactor: DEFPUSHFACTOR;                                    // pushfactor
    scale: FRACUNIT;                                              // scale
    gravity: FRACUNIT;                                            // gravity
    flags3_ex: 0;                                                 // flags3_ex
    flags4_ex: 0;                                                 // flags4_ex
   ),

   (    // MT_AMGWNDWIMPY
    name: 'Wand Crystal';
    inheritsfrom: -1;                                             // inheritsfrom
    doomednum: 10;                                                // doomednum
    spawnstate: Ord(S_AMG1);                                      // spawnstate
    spawnhealth: AMMO_GWND_WIMPY;                                 // spawnhealth
    seestate: Ord(S_NULL);                                        // seestate
    seesound: Ord(sfx_None);                                      // seesound
    reactiontime: 8;                                              // reactiontime
    attacksound: Ord(sfx_None);                                   // attacksound
    painstate: Ord(S_NULL);                                       // painstate
    painchance: 0;                                                // painchance
    painsound: Ord(sfx_None);                                     // painsound
    meleestate: Ord(S_NULL);                                      // meleestate
    missilestate: Ord(S_NULL);                                    // missilestate
    crashstate: Ord(S_NULL);                                      // crashstate
    deathstate: Ord(S_NULL);                                      // deathstate
    xdeathstate: Ord(S_NULL);                                     // xdeathstate
    deathsound: Ord(sfx_None);                                    // deathsound
    speed: 0;                                                     // speed
    radius: 20 * FRACUNIT;                                        // radius
    height: 16 * FRACUNIT;                                        // height
    mass: 100;                                                    // mass
    damage: 0;                                                    // damage
    activesound: Ord(sfx_None);                                   // activesound
    flags: MF_SPECIAL;                                            // flags
    flags2: 0;                                                    // flags2
    pushfactor: DEFPUSHFACTOR;                                    // pushfactor
    scale: FRACUNIT;                                              // scale
    gravity: FRACUNIT;                                            // gravity
    flags3_ex: 0;                                                 // flags3_ex
    flags4_ex: 0;                                                 // flags4_ex
   ),

   (    // MT_AMGWNDHEFTY
    name: 'Crystal Geode';
    inheritsfrom: -1;                                             // inheritsfrom
    doomednum: 12;                                                // doomednum
    spawnstate: Ord(S_AMG2_1);                                    // spawnstate
    spawnhealth: AMMO_GWND_HEFTY;                                 // spawnhealth
    seestate: Ord(S_NULL);                                        // seestate
    seesound: Ord(sfx_None);                                      // seesound
    reactiontime: 8;                                              // reactiontime
    attacksound: Ord(sfx_None);                                   // attacksound
    painstate: Ord(S_NULL);                                       // painstate
    painchance: 0;                                                // painchance
    painsound: Ord(sfx_None);                                     // painsound
    meleestate: Ord(S_NULL);                                      // meleestate
    missilestate: Ord(S_NULL);                                    // missilestate
    crashstate: Ord(S_NULL);                                      // crashstate
    deathstate: Ord(S_NULL);                                      // deathstate
    xdeathstate: Ord(S_NULL);                                     // xdeathstate
    deathsound: Ord(sfx_None);                                    // deathsound
    speed: 0;                                                     // speed
    radius: 20 * FRACUNIT;                                        // radius
    height: 16 * FRACUNIT;                                        // height
    mass: 100;                                                    // mass
    damage: 0;                                                    // damage
    activesound: Ord(sfx_None);                                   // activesound
    flags: MF_SPECIAL;                                            // flags
    flags2: 0;                                                    // flags2
    pushfactor: DEFPUSHFACTOR;                                    // pushfactor
    scale: FRACUNIT;                                              // scale
    gravity: FRACUNIT;                                            // gravity
    flags3_ex: 0;                                                 // flags3_ex
    flags4_ex: 0;                                                 // flags4_ex
   ),

   (    // MT_AMMACEWIMPY
    name: 'Mace Spheres';
    inheritsfrom: -1;                                             // inheritsfrom
    doomednum: 13;                                                // doomednum
    spawnstate: Ord(S_AMM1);                                      // spawnstate
    spawnhealth: AMMO_MACE_WIMPY;                                 // spawnhealth
    seestate: Ord(S_NULL);                                        // seestate
    seesound: Ord(sfx_None);                                      // seesound
    reactiontime: 8;                                              // reactiontime
    attacksound: Ord(sfx_None);                                   // attacksound
    painstate: Ord(S_NULL);                                       // painstate
    painchance: 0;                                                // painchance
    painsound: Ord(sfx_None);                                     // painsound
    meleestate: Ord(S_NULL);                                      // meleestate
    missilestate: Ord(S_NULL);                                    // missilestate
    crashstate: Ord(S_NULL);                                      // crashstate
    deathstate: Ord(S_NULL);                                      // deathstate
    xdeathstate: Ord(S_NULL);                                     // xdeathstate
    deathsound: Ord(sfx_None);                                    // deathsound
    speed: 0;                                                     // speed
    radius: 20 * FRACUNIT;                                        // radius
    height: 16 * FRACUNIT;                                        // height
    mass: 100;                                                    // mass
    damage: 0;                                                    // damage
    activesound: Ord(sfx_None);                                   // activesound
    flags: MF_SPECIAL;                                            // flags
    flags2: 0;                                                    // flags2
    pushfactor: DEFPUSHFACTOR;                                    // pushfactor
    scale: FRACUNIT;                                              // scale
    gravity: FRACUNIT;                                            // gravity
    flags3_ex: 0;                                                 // flags3_ex
    flags4_ex: 0;                                                 // flags4_ex
   ),

   (    // MT_AMMACEHEFTY
    name: 'Pile Of Mace Spheres';
    inheritsfrom: -1;                                             // inheritsfrom
    doomednum: 16;                                                // doomednum
    spawnstate: Ord(S_AMM2);                                      // spawnstate
    spawnhealth: AMMO_MACE_HEFTY;                                 // spawnhealth
    seestate: Ord(S_NULL);                                        // seestate
    seesound: Ord(sfx_None);                                      // seesound
    reactiontime: 8;                                              // reactiontime
    attacksound: Ord(sfx_None);                                   // attacksound
    painstate: Ord(S_NULL);                                       // painstate
    painchance: 0;                                                // painchance
    painsound: Ord(sfx_None);                                     // painsound
    meleestate: Ord(S_NULL);                                      // meleestate
    missilestate: Ord(S_NULL);                                    // missilestate
    crashstate: Ord(S_NULL);                                      // crashstate
    deathstate: Ord(S_NULL);                                      // deathstate
    xdeathstate: Ord(S_NULL);                                     // xdeathstate
    deathsound: Ord(sfx_None);                                    // deathsound
    speed: 0;                                                     // speed
    radius: 20 * FRACUNIT;                                        // radius
    height: 16 * FRACUNIT;                                        // height
    mass: 100;                                                    // mass
    damage: 0;                                                    // damage
    activesound: Ord(sfx_None);                                   // activesound
    flags: MF_SPECIAL;                                            // flags
    flags2: 0;                                                    // flags2
    pushfactor: DEFPUSHFACTOR;                                    // pushfactor
    scale: FRACUNIT;                                              // scale
    gravity: FRACUNIT;                                            // gravity
    flags3_ex: 0;                                                 // flags3_ex
    flags4_ex: 0;                                                 // flags4_ex
   ),

   (    // MT_AMCBOWWIMPY
    name: 'Ethereal Arrows';
    inheritsfrom: -1;                                             // inheritsfrom
    doomednum: 18;                                                // doomednum
    spawnstate: Ord(S_AMC1);                                      // spawnstate
    spawnhealth: AMMO_CBOW_WIMPY;                                 // spawnhealth
    seestate: Ord(S_NULL);                                        // seestate
    seesound: Ord(sfx_None);                                      // seesound
    reactiontime: 8;                                              // reactiontime
    attacksound: Ord(sfx_None);                                   // attacksound
    painstate: Ord(S_NULL);                                       // painstate
    painchance: 0;                                                // painchance
    painsound: Ord(sfx_None);                                     // painsound
    meleestate: Ord(S_NULL);                                      // meleestate
    missilestate: Ord(S_NULL);                                    // missilestate
    crashstate: Ord(S_NULL);                                      // crashstate
    deathstate: Ord(S_NULL);                                      // deathstate
    xdeathstate: Ord(S_NULL);                                     // xdeathstate
    deathsound: Ord(sfx_None);                                    // deathsound
    speed: 0;                                                     // speed
    radius: 20 * FRACUNIT;                                        // radius
    height: 16 * FRACUNIT;                                        // height
    mass: 100;                                                    // mass
    damage: 0;                                                    // damage
    activesound: Ord(sfx_None);                                   // activesound
    flags: MF_SPECIAL;                                            // flags
    flags2: 0;                                                    // flags2
    pushfactor: DEFPUSHFACTOR;                                    // pushfactor
    scale: FRACUNIT;                                              // scale
    gravity: FRACUNIT;                                            // gravity
    flags3_ex: 0;                                                 // flags3_ex
    flags4_ex: 0;                                                 // flags4_ex
   ),

   (    // MT_AMCBOWHEFTY
    name: 'Quiver Of Ethereal Arrows';
    inheritsfrom: -1;                                             // inheritsfrom
    doomednum: 19;                                                // doomednum
    spawnstate: Ord(S_AMC2_1);                                    // spawnstate
    spawnhealth: AMMO_CBOW_HEFTY;                                 // spawnhealth
    seestate: Ord(S_NULL);                                        // seestate
    seesound: Ord(sfx_None);                                      // seesound
    reactiontime: 8;                                              // reactiontime
    attacksound: Ord(sfx_None);                                   // attacksound
    painstate: Ord(S_NULL);                                       // painstate
    painchance: 0;                                                // painchance
    painsound: Ord(sfx_None);                                     // painsound
    meleestate: Ord(S_NULL);                                      // meleestate
    missilestate: Ord(S_NULL);                                    // missilestate
    crashstate: Ord(S_NULL);                                      // crashstate
    deathstate: Ord(S_NULL);                                      // deathstate
    xdeathstate: Ord(S_NULL);                                     // xdeathstate
    deathsound: Ord(sfx_None);                                    // deathsound
    speed: 0;                                                     // speed
    radius: 20 * FRACUNIT;                                        // radius
    height: 16 * FRACUNIT;                                        // height
    mass: 100;                                                    // mass
    damage: 0;                                                    // damage
    activesound: Ord(sfx_None);                                   // activesound
    flags: MF_SPECIAL;                                            // flags
    flags2: 0;                                                    // flags2
    pushfactor: DEFPUSHFACTOR;                                    // pushfactor
    scale: FRACUNIT;                                              // scale
    gravity: FRACUNIT;                                            // gravity
    flags3_ex: 0;                                                 // flags3_ex
    flags4_ex: 0;                                                 // flags4_ex
   ),

   (    // MT_AMSKRDWIMPY
    name: 'Lesser Runes';
    inheritsfrom: -1;                                             // inheritsfrom
    doomednum: 20;                                                // doomednum
    spawnstate: Ord(S_AMS1_1);                                    // spawnstate
    spawnhealth: AMMO_SKRD_WIMPY;                                 // spawnhealth
    seestate: Ord(S_NULL);                                        // seestate
    seesound: Ord(sfx_None);                                      // seesound
    reactiontime: 8;                                              // reactiontime
    attacksound: Ord(sfx_None);                                   // attacksound
    painstate: Ord(S_NULL);                                       // painstate
    painchance: 0;                                                // painchance
    painsound: Ord(sfx_None);                                     // painsound
    meleestate: Ord(S_NULL);                                      // meleestate
    missilestate: Ord(S_NULL);                                    // missilestate
    crashstate: Ord(S_NULL);                                      // crashstate
    deathstate: Ord(S_NULL);                                      // deathstate
    xdeathstate: Ord(S_NULL);                                     // xdeathstate
    deathsound: Ord(sfx_None);                                    // deathsound
    speed: 0;                                                     // speed
    radius: 20 * FRACUNIT;                                        // radius
    height: 16 * FRACUNIT;                                        // height
    mass: 100;                                                    // mass
    damage: 0;                                                    // damage
    activesound: Ord(sfx_None);                                   // activesound
    flags: MF_SPECIAL;                                            // flags
    flags2: 0;                                                    // flags2
    pushfactor: DEFPUSHFACTOR;                                    // pushfactor
    scale: FRACUNIT;                                              // scale
    gravity: FRACUNIT;                                            // gravity
    flags3_ex: 0;                                                 // flags3_ex
    flags4_ex: 0;                                                 // flags4_ex
   ),

   (    // MT_AMSKRDHEFTY
    name: 'Greater Runes';
    inheritsfrom: -1;                                             // inheritsfrom
    doomednum: 21;                                                // doomednum
    spawnstate: Ord(S_AMS2_1);                                    // spawnstate
    spawnhealth: AMMO_SKRD_HEFTY;                                 // spawnhealth
    seestate: Ord(S_NULL);                                        // seestate
    seesound: Ord(sfx_None);                                      // seesound
    reactiontime: 8;                                              // reactiontime
    attacksound: Ord(sfx_None);                                   // attacksound
    painstate: Ord(S_NULL);                                       // painstate
    painchance: 0;                                                // painchance
    painsound: Ord(sfx_None);                                     // painsound
    meleestate: Ord(S_NULL);                                      // meleestate
    missilestate: Ord(S_NULL);                                    // missilestate
    crashstate: Ord(S_NULL);                                      // crashstate
    deathstate: Ord(S_NULL);                                      // deathstate
    xdeathstate: Ord(S_NULL);                                     // xdeathstate
    deathsound: Ord(sfx_None);                                    // deathsound
    speed: 0;                                                     // speed
    radius: 20 * FRACUNIT;                                        // radius
    height: 16 * FRACUNIT;                                        // height
    mass: 100;                                                    // mass
    damage: 0;                                                    // damage
    activesound: Ord(sfx_None);                                   // activesound
    flags: MF_SPECIAL;                                            // flags
    flags2: 0;                                                    // flags2
    pushfactor: DEFPUSHFACTOR;                                    // pushfactor
    scale: FRACUNIT;                                              // scale
    gravity: FRACUNIT;                                            // gravity
    flags3_ex: 0;                                                 // flags3_ex
    flags4_ex: 0;                                                 // flags4_ex
   ),

   (    // MT_AMPHRDWIMPY
    name: 'Flame Orb';
    inheritsfrom: -1;                                             // inheritsfrom
    doomednum: 22;                                                // doomednum
    spawnstate: Ord(S_AMP1_1);                                    // spawnstate
    spawnhealth: AMMO_PHRD_WIMPY;                                 // spawnhealth
    seestate: Ord(S_NULL);                                        // seestate
    seesound: Ord(sfx_None);                                      // seesound
    reactiontime: 8;                                              // reactiontime
    attacksound: Ord(sfx_None);                                   // attacksound
    painstate: Ord(S_NULL);                                       // painstate
    painchance: 0;                                                // painchance
    painsound: Ord(sfx_None);                                     // painsound
    meleestate: Ord(S_NULL);                                      // meleestate
    missilestate: Ord(S_NULL);                                    // missilestate
    crashstate: Ord(S_NULL);                                      // crashstate
    deathstate: Ord(S_NULL);                                      // deathstate
    xdeathstate: Ord(S_NULL);                                     // xdeathstate
    deathsound: Ord(sfx_None);                                    // deathsound
    speed: 0;                                                     // speed
    radius: 20 * FRACUNIT;                                        // radius
    height: 16 * FRACUNIT;                                        // height
    mass: 100;                                                    // mass
    damage: 0;                                                    // damage
    activesound: Ord(sfx_None);                                   // activesound
    flags: MF_SPECIAL;                                            // flags
    flags2: 0;                                                    // flags2
    pushfactor: DEFPUSHFACTOR;                                    // pushfactor
    scale: FRACUNIT;                                              // scale
    gravity: FRACUNIT;                                            // gravity
    flags3_ex: 0;                                                 // flags3_ex
    flags4_ex: 0;                                                 // flags4_ex
   ),

   (    // MT_AMPHRDHEFTY
    name: 'Inferno Orb';
    inheritsfrom: -1;                                             // inheritsfrom
    doomednum: 23;                                                // doomednum
    spawnstate: Ord(S_AMP2_1);                                    // spawnstate
    spawnhealth: AMMO_PHRD_HEFTY;                                 // spawnhealth
    seestate: Ord(S_NULL);                                        // seestate
    seesound: Ord(sfx_None);                                      // seesound
    reactiontime: 8;                                              // reactiontime
    attacksound: Ord(sfx_None);                                   // attacksound
    painstate: Ord(S_NULL);                                       // painstate
    painchance: 0;                                                // painchance
    painsound: Ord(sfx_None);                                     // painsound
    meleestate: Ord(S_NULL);                                      // meleestate
    missilestate: Ord(S_NULL);                                    // missilestate
    crashstate: Ord(S_NULL);                                      // crashstate
    deathstate: Ord(S_NULL);                                      // deathstate
    xdeathstate: Ord(S_NULL);                                     // xdeathstate
    deathsound: Ord(sfx_None);                                    // deathsound
    speed: 0;                                                     // speed
    radius: 20 * FRACUNIT;                                        // radius
    height: 16 * FRACUNIT;                                        // height
    mass: 100;                                                    // mass
    damage: 0;                                                    // damage
    activesound: Ord(sfx_None);                                   // activesound
    flags: MF_SPECIAL;                                            // flags
    flags2: 0;                                                    // flags2
    pushfactor: DEFPUSHFACTOR;                                    // pushfactor
    scale: FRACUNIT;                                              // scale
    gravity: FRACUNIT;                                            // gravity
    flags3_ex: 0;                                                 // flags3_ex
    flags4_ex: 0;                                                 // flags4_ex
   ),

   (    // MT_AMBLSRWIMPY
    name: 'Claw Orb';
    inheritsfrom: -1;                                             // inheritsfrom
    doomednum: 54;                                                // doomednum
    spawnstate: Ord(S_AMB1_1);                                    // spawnstate
    spawnhealth: AMMO_BLSR_WIMPY;                                 // spawnhealth
    seestate: Ord(S_NULL);                                        // seestate
    seesound: Ord(sfx_None);                                      // seesound
    reactiontime: 8;                                              // reactiontime
    attacksound: Ord(sfx_None);                                   // attacksound
    painstate: Ord(S_NULL);                                       // painstate
    painchance: 0;                                                // painchance
    painsound: Ord(sfx_None);                                     // painsound
    meleestate: Ord(S_NULL);                                      // meleestate
    missilestate: Ord(S_NULL);                                    // missilestate
    crashstate: Ord(S_NULL);                                      // crashstate
    deathstate: Ord(S_NULL);                                      // deathstate
    xdeathstate: Ord(S_NULL);                                     // xdeathstate
    deathsound: Ord(sfx_None);                                    // deathsound
    speed: 0;                                                     // speed
    radius: 20 * FRACUNIT;                                        // radius
    height: 16 * FRACUNIT;                                        // height
    mass: 100;                                                    // mass
    damage: 0;                                                    // damage
    activesound: Ord(sfx_None);                                   // activesound
    flags: MF_SPECIAL;                                            // flags
    flags2: 0;                                                    // flags2
    pushfactor: DEFPUSHFACTOR;                                    // pushfactor
    scale: FRACUNIT;                                              // scale
    gravity: FRACUNIT;                                            // gravity
    flags3_ex: 0;                                                 // flags3_ex
    flags4_ex: 0;                                                 // flags4_ex
   ),

   (    // MT_AMBLSRHEFTY
    name: 'Energy Orb';
    inheritsfrom: -1;                                             // inheritsfrom
    doomednum: 55;                                                // doomednum
    spawnstate: Ord(S_AMB2_1);                                    // spawnstate
    spawnhealth: AMMO_BLSR_HEFTY;                                 // spawnhealth
    seestate: Ord(S_NULL);                                        // seestate
    seesound: Ord(sfx_None);                                      // seesound
    reactiontime: 8;                                              // reactiontime
    attacksound: Ord(sfx_None);                                   // attacksound
    painstate: Ord(S_NULL);                                       // painstate
    painchance: 0;                                                // painchance
    painsound: Ord(sfx_None);                                     // painsound
    meleestate: Ord(S_NULL);                                      // meleestate
    missilestate: Ord(S_NULL);                                    // missilestate
    crashstate: Ord(S_NULL);                                      // crashstate
    deathstate: Ord(S_NULL);                                      // deathstate
    xdeathstate: Ord(S_NULL);                                     // xdeathstate
    deathsound: Ord(sfx_None);                                    // deathsound
    speed: 0;                                                     // speed
    radius: 20 * FRACUNIT;                                        // radius
    height: 16 * FRACUNIT;                                        // height
    mass: 100;                                                    // mass
    damage: 0;                                                    // damage
    activesound: Ord(sfx_None);                                   // activesound
    flags: MF_SPECIAL;                                            // flags
    flags2: 0;                                                    // flags2
    pushfactor: DEFPUSHFACTOR;                                    // pushfactor
    scale: FRACUNIT;                                              // scale
    gravity: FRACUNIT;                                            // gravity
    flags3_ex: 0;                                                 // flags3_ex
    flags4_ex: 0;                                                 // flags4_ex
   ),

   (    // MT_SOUNDWIND
    name: 'Wind';
    inheritsfrom: -1;                                             // inheritsfrom
    doomednum: 42;                                                // doomednum
    spawnstate: Ord(S_SND_WIND);                                  // spawnstate
    spawnhealth: 1000;                                            // spawnhealth
    seestate: Ord(S_NULL);                                        // seestate
    seesound: Ord(sfx_None);                                      // seesound
    reactiontime: 8;                                              // reactiontime
    attacksound: Ord(sfx_None);                                   // attacksound
    painstate: Ord(S_NULL);                                       // painstate
    painchance: 0;                                                // painchance
    painsound: Ord(sfx_None);                                     // painsound
    meleestate: Ord(S_NULL);                                      // meleestate
    missilestate: Ord(S_NULL);                                    // missilestate
    crashstate: Ord(S_NULL);                                      // crashstate
    deathstate: Ord(S_NULL);                                      // deathstate
    xdeathstate: Ord(S_NULL);                                     // xdeathstate
    deathsound: Ord(sfx_None);                                    // deathsound
    speed: 0;                                                     // speed
    radius: 20 * FRACUNIT;                                        // radius
    height: 16 * FRACUNIT;                                        // height
    mass: 100;                                                    // mass
    damage: 0;                                                    // damage
    activesound: Ord(sfx_None);                                   // activesound
    flags: MF_NOBLOCKMAP or MF_NOSECTOR;                          // flags
    flags2: 0;                                                    // flags2
    pushfactor: DEFPUSHFACTOR;                                    // pushfactor
    scale: FRACUNIT;                                              // scale
    gravity: FRACUNIT;                                            // gravity
    flags3_ex: 0;                                                 // flags3_ex
    flags4_ex: 0;                                                 // flags4_ex
   ),

   (    // MT_SOUNDWATERFALL
    name: 'Waterfall';
    inheritsfrom: -1;                                             // inheritsfrom
    doomednum: 41;                                                // doomednum
    spawnstate: Ord(S_SND_WATERFALL);                             // spawnstate
    spawnhealth: 1000;                                            // spawnhealth
    seestate: Ord(S_NULL);                                        // seestate
    seesound: Ord(sfx_None);                                      // seesound
    reactiontime: 8;                                              // reactiontime
    attacksound: Ord(sfx_None);                                   // attacksound
    painstate: Ord(S_NULL);                                       // painstate
    painchance: 0;                                                // painchance
    painsound: Ord(sfx_None);                                     // painsound
    meleestate: Ord(S_NULL);                                      // meleestate
    missilestate: Ord(S_NULL);                                    // missilestate
    crashstate: Ord(S_NULL);                                      // crashstate
    deathstate: Ord(S_NULL);                                      // deathstate
    xdeathstate: Ord(S_NULL);                                     // xdeathstate
    deathsound: Ord(sfx_None);                                    // deathsound
    speed: 0;                                                     // speed
    radius: 20 * FRACUNIT;                                        // radius
    height: 16 * FRACUNIT;                                        // height
    mass: 100;                                                    // mass
    damage: 0;                                                    // damage
    activesound: Ord(sfx_None);                                   // activesound
    flags: MF_NOBLOCKMAP or MF_NOSECTOR;                          // flags
    flags2: 0;                                                    // flags2
    pushfactor: DEFPUSHFACTOR;                                    // pushfactor
    scale: FRACUNIT;                                              // scale
    gravity: FRACUNIT;                                            // gravity
    flags3_ex: 0;                                                 // flags3_ex
    flags4_ex: 0;                                                 // flags4_ex
   )

  );

procedure Info_Init(const usethinkers: boolean);
var
  i: integer;
begin
  Info_InitDnLookUp;
  if states = nil then
  begin
    states := malloc(Ord(DO_NUMSTATES) * SizeOf(state_t));
    memcpy(states, @DO_states, Ord(DO_NUMSTATES) * SizeOf(state_t));
  end;

  if sprnames = nil then
  begin
    sprnames := malloc(Ord(DO_NUMSPRITES) * 4 + 4);
    for i := 0 to Ord(DO_NUMSPRITES) - 1 do
      sprnames[i] := Ord(DO_sprnames[i][1]) +
                     Ord(DO_sprnames[i][2]) shl 8 +
                     Ord(DO_sprnames[i][3]) shl 16 +
                     Ord(DO_sprnames[i][4]) shl 24;
    sprnames[Ord(DO_NUMSPRITES)] := 0;
  end;

  if mobjinfo = nil then
  begin
    mobjinfo := malloc(Ord(DO_NUMMOBJTYPES) * SizeOf(mobjinfo_t));
    memcpy(mobjinfo, @DO_mobjinfo, Ord(DO_NUMMOBJTYPES) * SizeOf(mobjinfo_t));
  end;

  if not usethinkers then
  begin
    Info_SaveActions;
    for i := 0 to Ord(DO_NUMSTATES) - 1 do
      states[i].action.acp1 := nil;
    exit;
  end;

  if Info_RestoreActions then
    exit;

  states[Ord(S_FREETARGMOBJ)].action.acp1 := @A_FreeTargMobj;
  states[Ord(S_HIDESPECIAL2)].action.acp1 := @A_RestoreSpecialThing1;
  states[Ord(S_HIDESPECIAL11)].action.acp1 := @A_RestoreSpecialThing2;
  states[Ord(S_DORMANTARTI11)].action.acp1 := @A_HideThing;
  states[Ord(S_DORMANTARTI12)].action.acp1 := @A_UnHideThing;
  states[Ord(S_DORMANTARTI21)].action.acp1 := @A_RestoreArtifact;
  states[Ord(S_FIREBOMB5)].action.acp1 := @A_Scream;
  states[Ord(S_FIREBOMB6)].action.acp1 := @A_Explode;
  states[Ord(S_POD_PAIN1)].action.acp1 := @A_PodPain;
  states[Ord(S_POD_DIE1)].action.acp1 := @A_RemovePod;
  states[Ord(S_POD_DIE2)].action.acp1 := @A_Scream;
  states[Ord(S_POD_DIE3)].action.acp1 := @A_Explode;
  states[Ord(S_PODGENERATOR)].action.acp1 := @A_MakePod;
  states[Ord(S_KEYGIZMO2)].action.acp1 := @A_InitKeyGizmo;
  states[Ord(S_VOLCANO2)].action.acp1 := @A_VolcanoSet;
  states[Ord(S_VOLCANO9)].action.acp1 := @A_VolcanoBlast;
  states[Ord(S_VOLCANOBALL1)].action.acp1 := @A_BeastPuff;
  states[Ord(S_VOLCANOBALL2)].action.acp1 := @A_BeastPuff;
  states[Ord(S_VOLCANOBALLX1)].action.acp1 := @A_VolcBallImpact;
  states[Ord(S_TELEGLITGEN1)].action.acp1 := @A_SpawnTeleGlitter;
  states[Ord(S_TELEGLITGEN2)].action.acp1 := @A_SpawnTeleGlitter2;
  states[Ord(S_TELEGLITTER1_2)].action.acp1 := @A_AccTeleGlitter;
  states[Ord(S_TELEGLITTER1_4)].action.acp1 := @A_AccTeleGlitter;
  states[Ord(S_TELEGLITTER2_2)].action.acp1 := @A_AccTeleGlitter;
  states[Ord(S_TELEGLITTER2_4)].action.acp1 := @A_AccTeleGlitter;
  states[Ord(S_LIGHTDONE)].action.acp1 := @A_Light0;
  states[Ord(S_STAFFREADY)].action.acp1 := @A_WeaponReady;
  states[Ord(S_STAFFDOWN)].action.acp1 := @A_Lower;
  states[Ord(S_STAFFUP)].action.acp1 := @A_Raise;
  states[Ord(S_STAFFREADY2_1)].action.acp1 := @A_WeaponReady;
  states[Ord(S_STAFFREADY2_2)].action.acp1 := @A_WeaponReady;
  states[Ord(S_STAFFREADY2_3)].action.acp1 := @A_WeaponReady;
  states[Ord(S_STAFFDOWN2)].action.acp1 := @A_Lower;
  states[Ord(S_STAFFUP2)].action.acp1 := @A_Raise;
  states[Ord(S_STAFFATK1_2)].action.acp1 := @A_StaffAttackPL1;
  states[Ord(S_STAFFATK1_3)].action.acp1 := @A_ReFire;
  states[Ord(S_STAFFATK2_2)].action.acp1 := @A_StaffAttackPL2;
  states[Ord(S_STAFFATK2_3)].action.acp1 := @A_ReFire;
  states[Ord(S_BEAKREADY)].action.acp1 := @A_BeakReady;
  states[Ord(S_BEAKDOWN)].action.acp1 := @A_Lower;
  states[Ord(S_BEAKUP)].action.acp1 := @A_BeakRaise;
  states[Ord(S_BEAKATK1_1)].action.acp1 := @A_BeakAttackPL1;
  states[Ord(S_BEAKATK2_1)].action.acp1 := @A_BeakAttackPL2;
  states[Ord(S_GAUNTLETREADY)].action.acp1 := @A_WeaponReady;
  states[Ord(S_GAUNTLETDOWN)].action.acp1 := @A_Lower;
  states[Ord(S_GAUNTLETUP)].action.acp1 := @A_Raise;
  states[Ord(S_GAUNTLETREADY2_1)].action.acp1 := @A_WeaponReady;
  states[Ord(S_GAUNTLETREADY2_2)].action.acp1 := @A_WeaponReady;
  states[Ord(S_GAUNTLETREADY2_3)].action.acp1 := @A_WeaponReady;
  states[Ord(S_GAUNTLETDOWN2)].action.acp1 := @A_Lower;
  states[Ord(S_GAUNTLETUP2)].action.acp1 := @A_Raise;
  states[Ord(S_GAUNTLETATK1_3)].action.acp1 := @A_GauntletAttack;
  states[Ord(S_GAUNTLETATK1_4)].action.acp1 := @A_GauntletAttack;
  states[Ord(S_GAUNTLETATK1_5)].action.acp1 := @A_GauntletAttack;
  states[Ord(S_GAUNTLETATK1_6)].action.acp1 := @A_ReFire;
  states[Ord(S_GAUNTLETATK1_7)].action.acp1 := @A_Light0;
  states[Ord(S_GAUNTLETATK2_3)].action.acp1 := @A_GauntletAttack;
  states[Ord(S_GAUNTLETATK2_4)].action.acp1 := @A_GauntletAttack;
  states[Ord(S_GAUNTLETATK2_5)].action.acp1 := @A_GauntletAttack;
  states[Ord(S_GAUNTLETATK2_6)].action.acp1 := @A_ReFire;
  states[Ord(S_GAUNTLETATK2_7)].action.acp1 := @A_Light0;
  states[Ord(S_BLASTERREADY)].action.acp1 := @A_WeaponReady;
  states[Ord(S_BLASTERDOWN)].action.acp1 := @A_Lower;
  states[Ord(S_BLASTERUP)].action.acp1 := @A_Raise;
  states[Ord(S_BLASTERATK1_3)].action.acp1 := @A_FireBlasterPL1;
  states[Ord(S_BLASTERATK1_6)].action.acp1 := @A_ReFire;
  states[Ord(S_BLASTERATK2_3)].action.acp1 := @A_FireBlasterPL2;
  states[Ord(S_BLASTERATK2_6)].action.acp1 := @A_ReFire;
  states[Ord(S_BLASTERFXI1_1)].action.acp1 := @A_SpawnRippers;
  states[Ord(S_MACEREADY)].action.acp1 := @A_WeaponReady;
  states[Ord(S_MACEDOWN)].action.acp1 := @A_Lower;
  states[Ord(S_MACEUP)].action.acp1 := @A_Raise;
  states[Ord(S_MACEATK1_2)].action.acp1 := @A_FireMacePL1;
  states[Ord(S_MACEATK1_3)].action.acp1 := @A_FireMacePL1;
  states[Ord(S_MACEATK1_4)].action.acp1 := @A_FireMacePL1;
  states[Ord(S_MACEATK1_5)].action.acp1 := @A_FireMacePL1;
  states[Ord(S_MACEATK1_6)].action.acp1 := @A_ReFire;
  states[Ord(S_MACEATK2_2)].action.acp1 := @A_FireMacePL2;
  states[Ord(S_MACEATK2_4)].action.acp1 := @A_ReFire;
  states[Ord(S_MACEFX1_1)].action.acp1 := @A_MacePL1Check;
  states[Ord(S_MACEFX1_2)].action.acp1 := @A_MacePL1Check;
  states[Ord(S_MACEFXI1_1)].action.acp1 := @A_MaceBallImpact;
  states[Ord(S_MACEFXI2_1)].action.acp1 := @A_MaceBallImpact2;
  states[Ord(S_MACEFXI4_1)].action.acp1 := @A_DeathBallImpact;
  states[Ord(S_HORNRODREADY)].action.acp1 := @A_WeaponReady;
  states[Ord(S_HORNRODDOWN)].action.acp1 := @A_Lower;
  states[Ord(S_HORNRODUP)].action.acp1 := @A_Raise;
  states[Ord(S_HORNRODATK1_1)].action.acp1 := @A_FireSkullRodPL1;
  states[Ord(S_HORNRODATK1_2)].action.acp1 := @A_FireSkullRodPL1;
  states[Ord(S_HORNRODATK1_3)].action.acp1 := @A_ReFire;
  states[Ord(S_HORNRODATK2_5)].action.acp1 := @A_FireSkullRodPL2;
  states[Ord(S_HORNRODATK2_9)].action.acp1 := @A_ReFire;
  states[Ord(S_HRODFX2_2)].action.acp1 := @A_SkullRodPL2Seek;
  states[Ord(S_HRODFX2_4)].action.acp1 := @A_SkullRodPL2Seek;
  states[Ord(S_HRODFXI2_1)].action.acp1 := @A_AddPlayerRain;
  states[Ord(S_HRODFXI2_7)].action.acp1 := @A_HideInCeiling;
  states[Ord(S_HRODFXI2_8)].action.acp1 := @A_SkullRodStorm;
  states[Ord(S_RAINPLR1X_1)].action.acp1 := @A_RainImpact;
  states[Ord(S_RAINPLR2X_1)].action.acp1 := @A_RainImpact;
  states[Ord(S_RAINPLR3X_1)].action.acp1 := @A_RainImpact;
  states[Ord(S_RAINPLR4X_1)].action.acp1 := @A_RainImpact;
  states[Ord(S_GOLDWANDREADY)].action.acp1 := @A_WeaponReady;
  states[Ord(S_GOLDWANDDOWN)].action.acp1 := @A_Lower;
  states[Ord(S_GOLDWANDUP)].action.acp1 := @A_Raise;
  states[Ord(S_GOLDWANDATK1_2)].action.acp1 := @A_FireGoldWandPL1;
  states[Ord(S_GOLDWANDATK1_4)].action.acp1 := @A_ReFire;
  states[Ord(S_GOLDWANDATK2_2)].action.acp1 := @A_FireGoldWandPL2;
  states[Ord(S_GOLDWANDATK2_4)].action.acp1 := @A_ReFire;
  states[Ord(S_PHOENIXREADY)].action.acp1 := @A_WeaponReady;
  states[Ord(S_PHOENIXDOWN)].action.acp1 := @A_Lower;
  states[Ord(S_PHOENIXUP)].action.acp1 := @A_Raise;
  states[Ord(S_PHOENIXATK1_2)].action.acp1 := @A_FirePhoenixPL1;
  states[Ord(S_PHOENIXATK1_5)].action.acp1 := @A_ReFire;
  states[Ord(S_PHOENIXATK2_1)].action.acp1 := @A_InitPhoenixPL2;
  states[Ord(S_PHOENIXATK2_2)].action.acp1 := @A_FirePhoenixPL2;
  states[Ord(S_PHOENIXATK2_3)].action.acp1 := @A_ReFire;
  states[Ord(S_PHOENIXATK2_4)].action.acp1 := @A_ShutdownPhoenixPL2;
  states[Ord(S_PHOENIXFX1_1)].action.acp1 := @A_PhoenixPuff;
  states[Ord(S_PHOENIXFXI1_1)].action.acp1 := @A_Explode;
  states[Ord(S_PHOENIXFX2_6)].action.acp1 := @A_FlameEnd;
  states[Ord(S_PHOENIXFXI2_2)].action.acp1 := @A_FloatPuff;
  states[Ord(S_CRBOW1)].action.acp1 := @A_WeaponReady;
  states[Ord(S_CRBOW2)].action.acp1 := @A_WeaponReady;
  states[Ord(S_CRBOW3)].action.acp1 := @A_WeaponReady;
  states[Ord(S_CRBOW4)].action.acp1 := @A_WeaponReady;
  states[Ord(S_CRBOW5)].action.acp1 := @A_WeaponReady;
  states[Ord(S_CRBOW6)].action.acp1 := @A_WeaponReady;
  states[Ord(S_CRBOW7)].action.acp1 := @A_WeaponReady;
  states[Ord(S_CRBOW8)].action.acp1 := @A_WeaponReady;
  states[Ord(S_CRBOW9)].action.acp1 := @A_WeaponReady;
  states[Ord(S_CRBOW10)].action.acp1 := @A_WeaponReady;
  states[Ord(S_CRBOW11)].action.acp1 := @A_WeaponReady;
  states[Ord(S_CRBOW12)].action.acp1 := @A_WeaponReady;
  states[Ord(S_CRBOW13)].action.acp1 := @A_WeaponReady;
  states[Ord(S_CRBOW14)].action.acp1 := @A_WeaponReady;
  states[Ord(S_CRBOW15)].action.acp1 := @A_WeaponReady;
  states[Ord(S_CRBOW16)].action.acp1 := @A_WeaponReady;
  states[Ord(S_CRBOW17)].action.acp1 := @A_WeaponReady;
  states[Ord(S_CRBOW18)].action.acp1 := @A_WeaponReady;
  states[Ord(S_CRBOWDOWN)].action.acp1 := @A_Lower;
  states[Ord(S_CRBOWUP)].action.acp1 := @A_Raise;
  states[Ord(S_CRBOWATK1_1)].action.acp1 := @A_FireCrossbowPL1;
  states[Ord(S_CRBOWATK1_8)].action.acp1 := @A_ReFire;
  states[Ord(S_CRBOWATK2_1)].action.acp1 := @A_FireCrossbowPL2;
  states[Ord(S_CRBOWATK2_8)].action.acp1 := @A_ReFire;
  states[Ord(S_CRBOWFX2)].action.acp1 := @A_BoltSpark;
  states[Ord(S_PLAY_PAIN2)].action.acp1 := @A_Pain;
  states[Ord(S_PLAY_DIE2)].action.acp1 := @A_Scream;
  states[Ord(S_PLAY_DIE5)].action.acp1 := @A_NoBlocking;
  states[Ord(S_PLAY_DIE9)].action.acp1 := @A_AddPlayerCorpse;
  states[Ord(S_PLAY_XDIE1)].action.acp1 := @A_Scream;
  states[Ord(S_PLAY_XDIE2)].action.acp1 := @A_SkullPop;
  states[Ord(S_PLAY_XDIE3)].action.acp1 := @A_NoBlocking;
  states[Ord(S_PLAY_XDIE9)].action.acp1 := @A_AddPlayerCorpse;
  states[Ord(S_PLAY_FDTH1)].action.acp1 := @A_FlameSnd;
  states[Ord(S_PLAY_FDTH4)].action.acp1 := @A_Scream;
  states[Ord(S_PLAY_FDTH7)].action.acp1 := @A_FlameSnd;
  states[Ord(S_PLAY_FDTH15)].action.acp1 := @A_NoBlocking;
  states[Ord(S_PLAY_FDTH19)].action.acp1 := @A_CheckBurnGone;
  states[Ord(S_BLOODYSKULL1)].action.acp1 := @A_CheckSkullFloor;
  states[Ord(S_BLOODYSKULL2)].action.acp1 := @A_CheckSkullFloor;
  states[Ord(S_BLOODYSKULL3)].action.acp1 := @A_CheckSkullFloor;
  states[Ord(S_BLOODYSKULL4)].action.acp1 := @A_CheckSkullFloor;
  states[Ord(S_BLOODYSKULL5)].action.acp1 := @A_CheckSkullFloor;
  states[Ord(S_BLOODYSKULLX1)].action.acp1 := @A_CheckSkullDone;
  states[Ord(S_CHICPLAY_PAIN)].action.acp1 := @A_Feathers;
  states[Ord(S_CHICPLAY_PAIN2)].action.acp1 := @A_Pain;
  states[Ord(S_CHICKEN_LOOK1)].action.acp1 := @A_ChicLook;
  states[Ord(S_CHICKEN_LOOK2)].action.acp1 := @A_ChicLook;
  states[Ord(S_CHICKEN_WALK1)].action.acp1 := @A_ChicChase;
  states[Ord(S_CHICKEN_WALK2)].action.acp1 := @A_ChicChase;
  states[Ord(S_CHICKEN_PAIN1)].action.acp1 := @A_Feathers;
  states[Ord(S_CHICKEN_PAIN2)].action.acp1 := @A_ChicPain;
  states[Ord(S_CHICKEN_ATK1)].action.acp1 := @A_FaceTarget;
  states[Ord(S_CHICKEN_ATK2)].action.acp1 := @A_ChicAttack;
  states[Ord(S_CHICKEN_DIE1)].action.acp1 := @A_Scream;
  states[Ord(S_CHICKEN_DIE2)].action.acp1 := @A_Feathers;
  states[Ord(S_CHICKEN_DIE4)].action.acp1 := @A_NoBlocking;
  states[Ord(S_MUMMY_LOOK1)].action.acp1 := @A_Look;
  states[Ord(S_MUMMY_LOOK2)].action.acp1 := @A_Look;
  states[Ord(S_MUMMY_WALK1)].action.acp1 := @A_Chase;
  states[Ord(S_MUMMY_WALK2)].action.acp1 := @A_Chase;
  states[Ord(S_MUMMY_WALK3)].action.acp1 := @A_Chase;
  states[Ord(S_MUMMY_WALK4)].action.acp1 := @A_Chase;
  states[Ord(S_MUMMY_ATK1)].action.acp1 := @A_FaceTarget;
  states[Ord(S_MUMMY_ATK2)].action.acp1 := @A_MummyAttack;
  states[Ord(S_MUMMY_ATK3)].action.acp1 := @A_FaceTarget;
  states[Ord(S_MUMMYL_ATK1)].action.acp1 := @A_FaceTarget;
  states[Ord(S_MUMMYL_ATK2)].action.acp1 := @A_FaceTarget;
  states[Ord(S_MUMMYL_ATK3)].action.acp1 := @A_FaceTarget;
  states[Ord(S_MUMMYL_ATK4)].action.acp1 := @A_FaceTarget;
  states[Ord(S_MUMMYL_ATK5)].action.acp1 := @A_FaceTarget;
  states[Ord(S_MUMMYL_ATK6)].action.acp1 := @A_MummyAttack2;
  states[Ord(S_MUMMY_PAIN2)].action.acp1 := @A_Pain;
  states[Ord(S_MUMMY_DIE2)].action.acp1 := @A_Scream;
  states[Ord(S_MUMMY_DIE3)].action.acp1 := @A_MummySoul;
  states[Ord(S_MUMMY_DIE5)].action.acp1 := @A_NoBlocking;
  states[Ord(S_MUMMYFX1_1)].action.acp1 := @A_ContMobjSound;
  states[Ord(S_MUMMYFX1_2)].action.acp1 := @A_MummyFX1Seek;
  states[Ord(S_MUMMYFX1_4)].action.acp1 := @A_MummyFX1Seek;
  states[Ord(S_BEAST_LOOK1)].action.acp1 := @A_Look;
  states[Ord(S_BEAST_LOOK2)].action.acp1 := @A_Look;
  states[Ord(S_BEAST_WALK1)].action.acp1 := @A_Chase;
  states[Ord(S_BEAST_WALK2)].action.acp1 := @A_Chase;
  states[Ord(S_BEAST_WALK3)].action.acp1 := @A_Chase;
  states[Ord(S_BEAST_WALK4)].action.acp1 := @A_Chase;
  states[Ord(S_BEAST_WALK5)].action.acp1 := @A_Chase;
  states[Ord(S_BEAST_WALK6)].action.acp1 := @A_Chase;
  states[Ord(S_BEAST_ATK1)].action.acp1 := @A_FaceTarget;
  states[Ord(S_BEAST_ATK2)].action.acp1 := @A_BeastAttack;
  states[Ord(S_BEAST_PAIN2)].action.acp1 := @A_Pain;
  states[Ord(S_BEAST_DIE2)].action.acp1 := @A_Scream;
  states[Ord(S_BEAST_DIE6)].action.acp1 := @A_NoBlocking;
  states[Ord(S_BEAST_XDIE2)].action.acp1 := @A_Scream;
  states[Ord(S_BEAST_XDIE6)].action.acp1 := @A_NoBlocking;
  states[Ord(S_BEASTBALL1)].action.acp1 := @A_BeastPuff;
  states[Ord(S_BEASTBALL2)].action.acp1 := @A_BeastPuff;
  states[Ord(S_BEASTBALL3)].action.acp1 := @A_BeastPuff;
  states[Ord(S_BEASTBALL4)].action.acp1 := @A_BeastPuff;
  states[Ord(S_BEASTBALL5)].action.acp1 := @A_BeastPuff;
  states[Ord(S_BEASTBALL6)].action.acp1 := @A_BeastPuff;
  states[Ord(S_SNAKE_LOOK1)].action.acp1 := @A_Look;
  states[Ord(S_SNAKE_LOOK2)].action.acp1 := @A_Look;
  states[Ord(S_SNAKE_WALK1)].action.acp1 := @A_Chase;
  states[Ord(S_SNAKE_WALK2)].action.acp1 := @A_Chase;
  states[Ord(S_SNAKE_WALK3)].action.acp1 := @A_Chase;
  states[Ord(S_SNAKE_WALK4)].action.acp1 := @A_Chase;
  states[Ord(S_SNAKE_ATK1)].action.acp1 := @A_FaceTarget;
  states[Ord(S_SNAKE_ATK2)].action.acp1 := @A_FaceTarget;
  states[Ord(S_SNAKE_ATK3)].action.acp1 := @A_SnakeAttack;
  states[Ord(S_SNAKE_ATK4)].action.acp1 := @A_SnakeAttack;
  states[Ord(S_SNAKE_ATK5)].action.acp1 := @A_SnakeAttack;
  states[Ord(S_SNAKE_ATK6)].action.acp1 := @A_FaceTarget;
  states[Ord(S_SNAKE_ATK7)].action.acp1 := @A_FaceTarget;
  states[Ord(S_SNAKE_ATK8)].action.acp1 := @A_FaceTarget;
  states[Ord(S_SNAKE_ATK9)].action.acp1 := @A_SnakeAttack2;
  states[Ord(S_SNAKE_PAIN2)].action.acp1 := @A_Pain;
  states[Ord(S_SNAKE_DIE2)].action.acp1 := @A_Scream;
  states[Ord(S_SNAKE_DIE7)].action.acp1 := @A_NoBlocking;
  states[Ord(S_HEAD_LOOK)].action.acp1 := @A_Look;
  states[Ord(S_HEAD_FLOAT)].action.acp1 := @A_Chase;
  states[Ord(S_HEAD_ATK1)].action.acp1 := @A_FaceTarget;
  states[Ord(S_HEAD_ATK2)].action.acp1 := @A_HeadAttack;
  states[Ord(S_HEAD_PAIN2)].action.acp1 := @A_Pain;
  states[Ord(S_HEAD_DIE2)].action.acp1 := @A_Scream;
  states[Ord(S_HEAD_DIE5)].action.acp1 := @A_NoBlocking;
  states[Ord(S_HEAD_DIE7)].action.acp1 := @A_BossDeath;
  states[Ord(S_HEADFXI1_1)].action.acp1 := @A_HeadIceImpact;
  states[Ord(S_HEADFX3_1)].action.acp1 := @A_HeadFireGrow;
  states[Ord(S_HEADFX3_2)].action.acp1 := @A_HeadFireGrow;
  states[Ord(S_HEADFX3_3)].action.acp1 := @A_HeadFireGrow;
  states[Ord(S_HEADFX4_5)].action.acp1 := @A_WhirlwindSeek;
  states[Ord(S_HEADFX4_6)].action.acp1 := @A_WhirlwindSeek;
  states[Ord(S_HEADFX4_7)].action.acp1 := @A_WhirlwindSeek;
  states[Ord(S_CLINK_LOOK1)].action.acp1 := @A_Look;
  states[Ord(S_CLINK_LOOK2)].action.acp1 := @A_Look;
  states[Ord(S_CLINK_WALK1)].action.acp1 := @A_Chase;
  states[Ord(S_CLINK_WALK2)].action.acp1 := @A_Chase;
  states[Ord(S_CLINK_WALK3)].action.acp1 := @A_Chase;
  states[Ord(S_CLINK_WALK4)].action.acp1 := @A_Chase;
  states[Ord(S_CLINK_ATK1)].action.acp1 := @A_FaceTarget;
  states[Ord(S_CLINK_ATK2)].action.acp1 := @A_FaceTarget;
  states[Ord(S_CLINK_ATK3)].action.acp1 := @A_ClinkAttack;
  states[Ord(S_CLINK_PAIN2)].action.acp1 := @A_Pain;
  states[Ord(S_CLINK_DIE3)].action.acp1 := @A_Scream;
  states[Ord(S_CLINK_DIE4)].action.acp1 := @A_NoBlocking;
  states[Ord(S_WIZARD_LOOK1)].action.acp1 := @A_Look;
  states[Ord(S_WIZARD_LOOK2)].action.acp1 := @A_Look;
  states[Ord(S_WIZARD_WALK1)].action.acp1 := @A_Chase;
  states[Ord(S_WIZARD_WALK2)].action.acp1 := @A_Chase;
  states[Ord(S_WIZARD_WALK3)].action.acp1 := @A_Chase;
  states[Ord(S_WIZARD_WALK4)].action.acp1 := @A_Chase;
  states[Ord(S_WIZARD_WALK5)].action.acp1 := @A_Chase;
  states[Ord(S_WIZARD_WALK6)].action.acp1 := @A_Chase;
  states[Ord(S_WIZARD_WALK7)].action.acp1 := @A_Chase;
  states[Ord(S_WIZARD_WALK8)].action.acp1 := @A_Chase;
  states[Ord(S_WIZARD_ATK1)].action.acp1 := @A_WizAtk1;
  states[Ord(S_WIZARD_ATK2)].action.acp1 := @A_WizAtk2;
  states[Ord(S_WIZARD_ATK3)].action.acp1 := @A_WizAtk1;
  states[Ord(S_WIZARD_ATK4)].action.acp1 := @A_WizAtk2;
  states[Ord(S_WIZARD_ATK5)].action.acp1 := @A_WizAtk1;
  states[Ord(S_WIZARD_ATK6)].action.acp1 := @A_WizAtk2;
  states[Ord(S_WIZARD_ATK7)].action.acp1 := @A_WizAtk1;
  states[Ord(S_WIZARD_ATK8)].action.acp1 := @A_WizAtk2;
  states[Ord(S_WIZARD_ATK9)].action.acp1 := @A_WizAtk3;
  states[Ord(S_WIZARD_PAIN1)].action.acp1 := @A_GhostOff;
  states[Ord(S_WIZARD_PAIN2)].action.acp1 := @A_Pain;
  states[Ord(S_WIZARD_DIE1)].action.acp1 := @A_GhostOff;
  states[Ord(S_WIZARD_DIE2)].action.acp1 := @A_Scream;
  states[Ord(S_WIZARD_DIE5)].action.acp1 := @A_NoBlocking;
  states[Ord(S_IMP_LOOK1)].action.acp1 := @A_Look;
  states[Ord(S_IMP_LOOK2)].action.acp1 := @A_Look;
  states[Ord(S_IMP_LOOK3)].action.acp1 := @A_Look;
  states[Ord(S_IMP_LOOK4)].action.acp1 := @A_Look;
  states[Ord(S_IMP_FLY1)].action.acp1 := @A_Chase;
  states[Ord(S_IMP_FLY2)].action.acp1 := @A_Chase;
  states[Ord(S_IMP_FLY3)].action.acp1 := @A_Chase;
  states[Ord(S_IMP_FLY4)].action.acp1 := @A_Chase;
  states[Ord(S_IMP_FLY5)].action.acp1 := @A_Chase;
  states[Ord(S_IMP_FLY6)].action.acp1 := @A_Chase;
  states[Ord(S_IMP_FLY7)].action.acp1 := @A_Chase;
  states[Ord(S_IMP_FLY8)].action.acp1 := @A_Chase;
  states[Ord(S_IMP_MEATK1)].action.acp1 := @A_FaceTarget;
  states[Ord(S_IMP_MEATK2)].action.acp1 := @A_FaceTarget;
  states[Ord(S_IMP_MEATK3)].action.acp1 := @A_ImpMeAttack;
  states[Ord(S_IMP_MSATK1_1)].action.acp1 := @A_FaceTarget;
  states[Ord(S_IMP_MSATK1_2)].action.acp1 := @A_ImpMsAttack;
  states[Ord(S_IMP_MSATK2_1)].action.acp1 := @A_FaceTarget;
  states[Ord(S_IMP_MSATK2_2)].action.acp1 := @A_FaceTarget;
  states[Ord(S_IMP_MSATK2_3)].action.acp1 := @A_ImpMsAttack2;
  states[Ord(S_IMP_PAIN2)].action.acp1 := @A_Pain;
  states[Ord(S_IMP_DIE1)].action.acp1 := @A_ImpDeath;
  states[Ord(S_IMP_XDIE1)].action.acp1 := @A_ImpXDeath1;
  states[Ord(S_IMP_XDIE4)].action.acp1 := @A_ImpXDeath2;
  states[Ord(S_IMP_CRASH1)].action.acp1 := @A_ImpExplode;
  states[Ord(S_IMP_CRASH2)].action.acp1 := @A_Scream;
  states[Ord(S_KNIGHT_STND1)].action.acp1 := @A_Look;
  states[Ord(S_KNIGHT_STND2)].action.acp1 := @A_Look;
  states[Ord(S_KNIGHT_WALK1)].action.acp1 := @A_Chase;
  states[Ord(S_KNIGHT_WALK2)].action.acp1 := @A_Chase;
  states[Ord(S_KNIGHT_WALK3)].action.acp1 := @A_Chase;
  states[Ord(S_KNIGHT_WALK4)].action.acp1 := @A_Chase;
  states[Ord(S_KNIGHT_ATK1)].action.acp1 := @A_FaceTarget;
  states[Ord(S_KNIGHT_ATK2)].action.acp1 := @A_FaceTarget;
  states[Ord(S_KNIGHT_ATK3)].action.acp1 := @A_KnightAttack;
  states[Ord(S_KNIGHT_ATK4)].action.acp1 := @A_FaceTarget;
  states[Ord(S_KNIGHT_ATK5)].action.acp1 := @A_FaceTarget;
  states[Ord(S_KNIGHT_ATK6)].action.acp1 := @A_KnightAttack;
  states[Ord(S_KNIGHT_PAIN2)].action.acp1 := @A_Pain;
  states[Ord(S_KNIGHT_DIE2)].action.acp1 := @A_Scream;
  states[Ord(S_KNIGHT_DIE4)].action.acp1 := @A_NoBlocking;
  states[Ord(S_SPINAXE1)].action.acp1 := @A_ContMobjSound;
  states[Ord(S_REDAXE1)].action.acp1 := @A_DripBlood;
  states[Ord(S_REDAXE2)].action.acp1 := @A_DripBlood;
  states[Ord(S_SRCR1_LOOK1)].action.acp1 := @A_Look;
  states[Ord(S_SRCR1_LOOK2)].action.acp1 := @A_Look;
  states[Ord(S_SRCR1_WALK1)].action.acp1 := @A_Sor1Chase;
  states[Ord(S_SRCR1_WALK2)].action.acp1 := @A_Sor1Chase;
  states[Ord(S_SRCR1_WALK3)].action.acp1 := @A_Sor1Chase;
  states[Ord(S_SRCR1_WALK4)].action.acp1 := @A_Sor1Chase;
  states[Ord(S_SRCR1_PAIN1)].action.acp1 := @A_Sor1Pain;
  states[Ord(S_SRCR1_ATK1)].action.acp1 := @A_FaceTarget;
  states[Ord(S_SRCR1_ATK2)].action.acp1 := @A_FaceTarget;
  states[Ord(S_SRCR1_ATK3)].action.acp1 := @A_Srcr1Attack;
  states[Ord(S_SRCR1_ATK4)].action.acp1 := @A_FaceTarget;
  states[Ord(S_SRCR1_ATK5)].action.acp1 := @A_FaceTarget;
  states[Ord(S_SRCR1_ATK6)].action.acp1 := @A_FaceTarget;
  states[Ord(S_SRCR1_ATK7)].action.acp1 := @A_Srcr1Attack;
  states[Ord(S_SRCR1_DIE2)].action.acp1 := @A_Scream;
  states[Ord(S_SRCR1_DIE8)].action.acp1 := @A_SorZap;
  states[Ord(S_SRCR1_DIE12)].action.acp1 := @A_SorZap;
  states[Ord(S_SRCR1_DIE17)].action.acp1 := @A_SorcererRise;
  states[Ord(S_SOR2_RISE3)].action.acp1 := @A_SorRise;
  states[Ord(S_SOR2_RISE7)].action.acp1 := @A_SorSightSnd;
  states[Ord(S_SOR2_LOOK1)].action.acp1 := @A_Look;
  states[Ord(S_SOR2_LOOK2)].action.acp1 := @A_Look;
  states[Ord(S_SOR2_WALK1)].action.acp1 := @A_Chase;
  states[Ord(S_SOR2_WALK2)].action.acp1 := @A_Chase;
  states[Ord(S_SOR2_WALK3)].action.acp1 := @A_Chase;
  states[Ord(S_SOR2_WALK4)].action.acp1 := @A_Chase;
  states[Ord(S_SOR2_PAIN2)].action.acp1 := @A_Pain;
  states[Ord(S_SOR2_ATK1)].action.acp1 := @A_Srcr2Decide;
  states[Ord(S_SOR2_ATK2)].action.acp1 := @A_FaceTarget;
  states[Ord(S_SOR2_ATK3)].action.acp1 := @A_Srcr2Attack;
  states[Ord(S_SOR2_DIE1)].action.acp1 := @A_Sor2DthInit;
  states[Ord(S_SOR2_DIE3)].action.acp1 := @A_SorDSph;
  states[Ord(S_SOR2_DIE6)].action.acp1 := @A_Sor2DthLoop;
  states[Ord(S_SOR2_DIE7)].action.acp1 := @A_SorDExp;
  states[Ord(S_SOR2_DIE10)].action.acp1 := @A_NoBlocking;
  states[Ord(S_SOR2_DIE11)].action.acp1 := @A_SorDBon;
  states[Ord(S_SOR2_DIE15)].action.acp1 := @A_BossDeath;
  states[Ord(S_SOR2FX1_1)].action.acp1 := @A_BlueSpark;
  states[Ord(S_SOR2FX1_2)].action.acp1 := @A_BlueSpark;
  states[Ord(S_SOR2FX1_3)].action.acp1 := @A_BlueSpark;
  states[Ord(S_SOR2FXI1_1)].action.acp1 := @A_Explode;
  states[Ord(S_SOR2FX2_2)].action.acp1 := @A_GenWizard;
  states[Ord(S_MNTR_LOOK1)].action.acp1 := @A_Look;
  states[Ord(S_MNTR_LOOK2)].action.acp1 := @A_Look;
  states[Ord(S_MNTR_WALK1)].action.acp1 := @A_Chase;
  states[Ord(S_MNTR_WALK2)].action.acp1 := @A_Chase;
  states[Ord(S_MNTR_WALK3)].action.acp1 := @A_Chase;
  states[Ord(S_MNTR_WALK4)].action.acp1 := @A_Chase;
  states[Ord(S_MNTR_ATK1_1)].action.acp1 := @A_FaceTarget;
  states[Ord(S_MNTR_ATK1_2)].action.acp1 := @A_FaceTarget;
  states[Ord(S_MNTR_ATK1_3)].action.acp1 := @A_MinotaurAtk1;
  states[Ord(S_MNTR_ATK2_1)].action.acp1 := @A_MinotaurDecide;
  states[Ord(S_MNTR_ATK2_2)].action.acp1 := @A_FaceTarget;
  states[Ord(S_MNTR_ATK2_3)].action.acp1 := @A_MinotaurAtk2;
  states[Ord(S_MNTR_ATK3_1)].action.acp1 := @A_FaceTarget;
  states[Ord(S_MNTR_ATK3_2)].action.acp1 := @A_FaceTarget;
  states[Ord(S_MNTR_ATK3_3)].action.acp1 := @A_MinotaurAtk3;
  states[Ord(S_MNTR_ATK4_1)].action.acp1 := @A_MinotaurCharge;
  states[Ord(S_MNTR_PAIN2)].action.acp1 := @A_Pain;
  states[Ord(S_MNTR_DIE3)].action.acp1 := @A_Scream;
  states[Ord(S_MNTR_DIE8)].action.acp1 := @A_NoBlocking;
  states[Ord(S_MNTR_DIE15)].action.acp1 := @A_BossDeath;
  states[Ord(S_MNTRFX2_1)].action.acp1 := @A_MntrFloorFire;
  states[Ord(S_MNTRFXI2_1)].action.acp1 := @A_Explode;
  states[Ord(S_SND_WIND)].action.acp1 := @A_ESound;
  states[Ord(S_SND_WATERFALL)].action.acp1 := @A_ESound;

end;

end.

