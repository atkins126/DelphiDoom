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
//  Easy mapping slope
//
//------------------------------------------------------------------------------
//  Site  : http://sourceforge.net/projects/delphidoom/
//------------------------------------------------------------------------------

{$I Doom32.inc}

unit p_easyslope;

interface

uses
  doomdata,
  p_mobj_h;

const
  MT_RAISEFLOORTOANGLE = 1150;
  MT_LOWERFLOORTOANGLE = 1151;
  MT_RAISECEILINGTOANGLE = 1152;
  MT_LOWERCEILINGTOANGLE = 1153;
  MT_VERTEXRAISEFLOORTOANGLE = 1154;
  MT_VERTEXLOWERFLOORTOANGLE = 1155;
  MT_VERTEXRAISECEILINGTOANGLE = 1156;
  MT_VERTEXLOWERCEILINGTOANGLE = 1157;

function P_IsEasySlopeItem(const doomdnum: integer): boolean;

procedure P_EasySlopeInit;

procedure P_EasySlopeExecute;

function P_SpawnEasySlopeThing(mthing: Pmapthing_t): Pmobj_t;

implementation

uses
  d_delphi,
  d_think,
  m_fixed,
  p_setup,
  p_tick,
  p_mobj,
  p_slopes,
  r_defs;

function P_IsEasySlopeItem(const doomdnum: integer): boolean;
begin
  if (doomdnum = MT_RAISEFLOORTOANGLE) or (doomdnum = MT_LOWERFLOORTOANGLE) or
     (doomdnum = MT_RAISECEILINGTOANGLE) or (doomdnum = MT_LOWERCEILINGTOANGLE) or
     (doomdnum = MT_VERTEXRAISEFLOORTOANGLE) or (doomdnum = MT_VERTEXLOWERFLOORTOANGLE) or
     (doomdnum = MT_VERTEXRAISECEILINGTOANGLE) or (doomdnum = MT_VERTEXLOWERCEILINGTOANGLE) then
  begin
    result := true;
    exit;
  end;
  result := false;
end;

var
  numslopeitems: integer = 0;

type
  slopeitem_t = record
    numfloorcontrols: integer;
    floorcontrols: array[0..2] of Pmobj_t;
    floorvertexes: array[0..2] of Pvertex_t;
    numceilingcontrols: integer;
    ceilingcontrols: array[0..2] of Pmobj_t;
    ceilingvertexes: array[0..2] of Pvertex_t;
  end;
  Pslopeitem_t = ^slopeitem_t;
  slopeitem_tArray = array[0..$FFF] of slopeitem_t;
  Pslopeitem_tArray = ^slopeitem_tArray;

procedure P_EasySlopeInit;
begin
  numslopeitems := 0;
end;

function P_FindClosestSectorPoint(const secid: integer; const mo: Pmobj_t): Pvertex_t;
var
  dist, mindist: integer;
  i: integer;
  sec: Psector_t;

  function _pointdistance(const v: Pvertex_t): integer;
  var
    dx, dy: integer;
  begin
    dx := v.x div FRACUNIT - mo.x div FRACUNIT;
    dy := v.y div FRACUNIT - mo.y div FRACUNIT;
    result := dx * dx + dy * dy;
  end;

begin
  result := nil;
  sec := @sectors[secid];
  mindist := MAXINT;
  for i := 0 to sec.linecount - 1 do
  begin
    dist := _pointdistance(sec.lines[i].v1);
    if dist < mindist then
    begin
      mindist := dist;
      result := sec.lines[i].v1;
    end;
    dist := _pointdistance(sec.lines[i].v2);
    if dist < mindist then
    begin
      mindist := dist;
      result := sec.lines[i].v2;
    end;
  end;
end;

procedure calc_plane(
  const x1, y1, z1: float;
  const x2, y2, z2: float;
  const x3, y3, z3: float;
  out fa, fb, fc, fd: float);
var
  a1, b1, c1: float;
  a2, b2, c2: float;
begin
  a1 := x2 - x1;
  b1 := y2 - y1;
  c1 := z2 - z1;
  a2 := x3 - x1;
  b2 := y3 - y1;
  c2 := z3 - z1;
  fa := b1 * c2 - b2 * c1;
  fb := a2 * c1 - a1 * c2;
  fc := a1 * b2 - b1 * a2;
  fd := (- fa * x1 - fb * y1 - fc * z1);
end;

function calcz(const secid: integer; const mo: Pmobj_t; const default: fixed_t = 0): fixed_t;
var
  sec: Psector_t;
begin
  if mo = nil then
  begin
    result := default;
    exit;
  end;
  if secid >= 0 then
    sec := @sectors[secid]
  else
    sec := PsubSector_t(mo.subsector).sector;
  case mo.spawnpoint._type of
    MT_RAISEFLOORTOANGLE, MT_VERTEXRAISEFLOORTOANGLE:
      result := sec.floorheight + mo.spawnpoint.angle * FRACUNIT;
    MT_LOWERFLOORTOANGLE, MT_VERTEXLOWERFLOORTOANGLE:
      result := sec.floorheight - mo.spawnpoint.angle * FRACUNIT;
    MT_RAISECEILINGTOANGLE, MT_VERTEXRAISECEILINGTOANGLE:
      result := sec.ceilingheight + mo.spawnpoint.angle * FRACUNIT;
    MT_LOWERCEILINGTOANGLE, MT_VERTEXLOWERCEILINGTOANGLE:
      result := sec.ceilingheight - mo.spawnpoint.angle * FRACUNIT
  else
    result := sec.floorheight; // Unreachable code
  end;
end;

procedure P_EasySlopeExecute3Points;
var
  slopeinfo: Pslopeitem_tArray;
  th: Pthinker_t;
  mo: Pmobj_t;
  secid: integer;
  VV: array[0..2] of Pvertex_t;
  fa, fb, fc, fd: float;
begin
  if numslopeitems < 3 then
    exit;
  slopeinfo := mallocz(numsectors * SizeOf(slopeitem_t));

  th := thinkercap.next;
  while th <> @thinkercap do
  begin
    if @th._function.acp1 = @P_MobjThinker then
    begin
      mo := Pmobj_t(th);
      if (mo.spawnpoint._type = MT_RAISEFLOORTOANGLE) or (mo.spawnpoint._type = MT_LOWERFLOORTOANGLE) then
      begin
        secid := Psubsector_t(mo.subsector).sector.iSectorID;
        if slopeinfo[secid].numfloorcontrols < 3 then
        begin
          slopeinfo[secid].floorcontrols[slopeinfo[secid].numfloorcontrols] := mo;
          inc(slopeinfo[secid].numfloorcontrols);
        end;
      end
      else if (mo.spawnpoint._type = MT_RAISECEILINGTOANGLE) or (mo.spawnpoint._type = MT_LOWERCEILINGTOANGLE) then
      begin
        secid := Psubsector_t(mo.subsector).sector.iSectorID;
        if slopeinfo[secid].numceilingcontrols < 3 then
        begin
          slopeinfo[secid].ceilingcontrols[slopeinfo[secid].numceilingcontrols] := mo;
          inc(slopeinfo[secid].numceilingcontrols);
        end;
      end;
    end;
    th := th.next;
  end;

  for secid := 0 to numsectors - 1 do
  begin
    if slopeinfo[secid].numfloorcontrols = 3 then
    begin
      VV[0] := P_FindClosestSectorPoint(secid, slopeinfo[secid].floorcontrols[0]);
      VV[1] := P_FindClosestSectorPoint(secid, slopeinfo[secid].floorcontrols[1]);
      VV[2] := P_FindClosestSectorPoint(secid, slopeinfo[secid].floorcontrols[2]);
      calc_plane(
        VV[0].x / FRACUNIT, VV[0].y / FRACUNIT, calcz(secid, slopeinfo[secid].floorcontrols[0]) / FRACUNIT,
        VV[1].x / FRACUNIT, VV[1].y / FRACUNIT, calcz(secid, slopeinfo[secid].floorcontrols[1]) / FRACUNIT,
        VV[2].x / FRACUNIT, VV[2].y / FRACUNIT, calcz(secid, slopeinfo[secid].floorcontrols[2]) / FRACUNIT,
        fa, fb, fc, fd
      );
      sectors[secid].fa := fa;
      sectors[secid].fb := fb;
      sectors[secid].fic := 1 / fc;
      sectors[secid].fd := fd;
      sectors[secid].renderflags := sectors[secid].renderflags or SRF_SLOPEFLOOR;
      P_SlopesAlignPlane(@sectors[secid], nil, SRF_SLOPEFLOOR, false);
      sectors[secid].slopeline := sectors[secid].lines[0];
      sectors[secid].slopeline.renderflags := sectors[secid].slopeline.renderflags or LRF_SLOPED;
    end;
    if slopeinfo[secid].numceilingcontrols = 3 then
    begin
      VV[0] := P_FindClosestSectorPoint(secid, slopeinfo[secid].ceilingcontrols[0]);
      VV[1] := P_FindClosestSectorPoint(secid, slopeinfo[secid].ceilingcontrols[1]);
      VV[2] := P_FindClosestSectorPoint(secid, slopeinfo[secid].ceilingcontrols[2]);
      calc_plane(
        VV[0].x / FRACUNIT, VV[0].y / FRACUNIT, calcz(secid, slopeinfo[secid].ceilingcontrols[0]) / FRACUNIT,
        VV[1].x / FRACUNIT, VV[1].y / FRACUNIT, calcz(secid, slopeinfo[secid].ceilingcontrols[1]) / FRACUNIT,
        VV[2].x / FRACUNIT, VV[2].y / FRACUNIT, calcz(secid, slopeinfo[secid].ceilingcontrols[2]) / FRACUNIT,
        fa, fb, fc, fd
      );
      sectors[secid].ca := fa;
      sectors[secid].cb := fb;
      sectors[secid].cic := 1 / fc;
      sectors[secid].cd := fd;
      sectors[secid].renderflags := sectors[secid].renderflags or SRF_SLOPECEILING;
      P_SlopesAlignPlane(@sectors[secid], nil, SRF_SLOPECEILING, false);
      sectors[secid].slopeline := sectors[secid].lines[0];
      sectors[secid].slopeline.renderflags := sectors[secid].slopeline.renderflags or LRF_SLOPED;
    end;
  end;

  memfree(pointer(slopeinfo), numsectors * SizeOf(slopeitem_t));
end;

function P_FindSectorFromVertex3(v: Pvertex_t; var start: integer): integer;
var
  i, j: integer;
begin
  for i := start + 1 to numsectors - 1 do
    if sectors[i].linecount = 3 then
    begin
      for j := 0 to sectors[i].linecount - 1 do
        if (sectors[i].lines[j].v1 = v) or (sectors[i].lines[j].v2 = v) then
        begin
          result := i;
          start := result;
          exit;
        end;
    end;

  result := -1;
  start := -1;
end;

procedure P_FillControlVertexesFloor(const sec: Psector_t; const it: Pslopeitem_t);
var
  i: integer;
  lst: TDPointerList;
begin
  lst := TDPointerList.Create;
  for i := 0 to it.numfloorcontrols - 1 do
    lst.Add(it.floorvertexes[i]);

  for i := 0 to 2 do
  begin
    if lst.IndexOf(sec.lines[i].v1) < 0 then
    begin
      lst.Add(sec.lines[i].v1);
      if lst.Count = 3 then
        break;
    end;
    if lst.IndexOf(sec.lines[i].v2) < 0 then
    begin
      lst.Add(sec.lines[i].v2);
      if lst.Count = 3 then
        break;
    end;
  end;

  if lst.Count <> 3 then
  begin
    lst.Free; // Ouch!
    exit;
  end;

  for i := it.numfloorcontrols to 2 do
    it.floorvertexes[i] := lst.Pointers[i];
  it.numfloorcontrols := 3;
  
  lst.Free;
end;

procedure P_FillControlVertexesCeiling(const sec: Psector_t; const it: Pslopeitem_t);
var
  i: integer;
  lst: TDPointerList;
begin
  lst := TDPointerList.Create;
  for i := 0 to it.numceilingcontrols - 1 do
    lst.Add(it.ceilingvertexes[i]);

  for i := 0 to 2 do
  begin
    if lst.IndexOf(sec.lines[i].v1) < 0 then
    begin
      lst.Add(sec.lines[i].v1);
      if lst.Count = 3 then
        break;
    end;
    if lst.IndexOf(sec.lines[i].v2) < 0 then
    begin
      lst.Add(sec.lines[i].v2);
      if lst.Count = 3 then
        break;
    end;
  end;

  if lst.Count <> 3 then
  begin
    lst.Free; // Ouch!
    exit;
  end;

  for i := it.numceilingcontrols to 2 do
    it.ceilingvertexes[i] := lst.Pointers[i];
  it.numceilingcontrols := 3;
  
  lst.Free;
end;

procedure P_EasySlopeExecuteVertex;
var
  slopeinfo: Pslopeitem_tArray;
  th: Pthinker_t;
  mo: Pmobj_t;
  s, secid: integer;
  rover: Pvertex_t;
  VV: array[0..2] of Pvertex_t;
  fa, fb, fc, fd: float;
begin
  if numslopeitems <= 0 then
    exit;

  slopeinfo := mallocz(numsectors * SizeOf(slopeitem_t));

  th := thinkercap.next;
  while th <> @thinkercap do
  begin
    if @th._function.acp1 = @P_MobjThinker then
    begin
      mo := Pmobj_t(th);
      if (mo.spawnpoint._type = MT_VERTEXRAISEFLOORTOANGLE) or (mo.spawnpoint._type = MT_VERTEXLOWERFLOORTOANGLE) then
      begin
        secid := Psubsector_t(mo.subsector).sector.iSectorID;
        rover := P_FindClosestSectorPoint(secid, mo);
        s := -1;
        while P_FindSectorFromVertex3(rover, s) > -1 do
          if slopeinfo[s].numfloorcontrols < 3 then
          begin
            slopeinfo[s].floorcontrols[slopeinfo[s].numfloorcontrols] := mo;
            slopeinfo[s].floorvertexes[slopeinfo[s].numfloorcontrols] := rover;
            inc(slopeinfo[s].numfloorcontrols);
          end;
      end
      else if (mo.spawnpoint._type = MT_VERTEXRAISECEILINGTOANGLE) or (mo.spawnpoint._type = MT_VERTEXLOWERCEILINGTOANGLE) then
      begin
        secid := Psubsector_t(mo.subsector).sector.iSectorID;
        rover := P_FindClosestSectorPoint(secid, mo);
        s := -1;
        while P_FindSectorFromVertex3(rover, s) > -1 do
          if slopeinfo[s].numceilingcontrols < 3 then
          begin
            slopeinfo[s].ceilingcontrols[slopeinfo[secid].numceilingcontrols] := mo;
            slopeinfo[s].ceilingvertexes[slopeinfo[secid].numceilingcontrols] := rover;
            inc(slopeinfo[s].numceilingcontrols);
          end;
      end;
    end;
    th := th.next;
  end;

  for secid := 0 to numsectors - 1 do
  begin
    if slopeinfo[secid].numfloorcontrols > 0 then
    begin
      P_FillControlVertexesFloor(@sectors[secid], @slopeinfo[secid]);
      if slopeinfo[secid].numfloorcontrols = 3 then
      begin
        VV[0] := slopeinfo[secid].floorvertexes[0];
        VV[1] := slopeinfo[secid].floorvertexes[1];
        VV[2] := slopeinfo[secid].floorvertexes[2];
        calc_plane(
          VV[0].x / FRACUNIT, VV[0].y / FRACUNIT, calcz(secid, slopeinfo[secid].floorcontrols[0], sectors[secid].floorheight) / FRACUNIT,
          VV[1].x / FRACUNIT, VV[1].y / FRACUNIT, calcz(secid, slopeinfo[secid].floorcontrols[1], sectors[secid].floorheight) / FRACUNIT,
          VV[2].x / FRACUNIT, VV[2].y / FRACUNIT, calcz(secid, slopeinfo[secid].floorcontrols[2], sectors[secid].floorheight) / FRACUNIT,
          fa, fb, fc, fd
        );
        sectors[secid].fa := fa;
        sectors[secid].fb := fb;
        sectors[secid].fic := 1 / fc;
        sectors[secid].fd := fd;
        sectors[secid].renderflags := sectors[secid].renderflags or SRF_SLOPEFLOOR;
        P_SlopesAlignPlane(@sectors[secid], nil, SRF_SLOPEFLOOR, false);
        sectors[secid].slopeline := sectors[secid].lines[0];
        sectors[secid].slopeline.renderflags := sectors[secid].slopeline.renderflags or LRF_SLOPED;
      end;
    end;
    if slopeinfo[secid].numceilingcontrols > 0 then
    begin
      P_FillControlVertexesCeiling(@sectors[secid], @slopeinfo[secid]);
      if slopeinfo[secid].numceilingcontrols = 3 then
      begin
        VV[0] := slopeinfo[secid].ceilingvertexes[0];
        VV[1] := slopeinfo[secid].ceilingvertexes[1];
        VV[2] := slopeinfo[secid].ceilingvertexes[2];
        calc_plane(
          VV[0].x / FRACUNIT, VV[0].y / FRACUNIT, calcz(secid, slopeinfo[secid].ceilingcontrols[0], sectors[secid].ceilingheight) / FRACUNIT,
          VV[1].x / FRACUNIT, VV[1].y / FRACUNIT, calcz(secid, slopeinfo[secid].ceilingcontrols[1], sectors[secid].ceilingheight) / FRACUNIT,
          VV[2].x / FRACUNIT, VV[2].y / FRACUNIT, calcz(secid, slopeinfo[secid].ceilingcontrols[2], sectors[secid].ceilingheight) / FRACUNIT,
          fa, fb, fc, fd
        );
        sectors[secid].ca := fa;
        sectors[secid].cb := fb;
        sectors[secid].cic := 1 / fc;
        sectors[secid].cd := fd;
        sectors[secid].renderflags := sectors[secid].renderflags or SRF_SLOPECEILING;
        P_SlopesAlignPlane(@sectors[secid], nil, SRF_SLOPECEILING, false);
        sectors[secid].slopeline := sectors[secid].lines[0];
        sectors[secid].slopeline.renderflags := sectors[secid].slopeline.renderflags or LRF_SLOPED;
      end;
    end;
  end;

  memfree(pointer(slopeinfo), numsectors * SizeOf(slopeitem_t));
end;

procedure P_EasySlopeExecute;
begin
  P_EasySlopeExecute3Points;
  P_EasySlopeExecuteVertex;
end;

function P_SpawnEasySlopeThing(mthing: Pmapthing_t): Pmobj_t;
begin
  result := P_SpawnMapThing(mthing);
  inc(numslopeitems);
end;

end.