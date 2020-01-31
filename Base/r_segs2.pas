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
//  DESCRIPTION:
//   Seg rendering loops, fixed point & double precision 
//
//------------------------------------------------------------------------------
//  Site  : http://sourceforge.net/projects/delphidoom/
//------------------------------------------------------------------------------

{$I Doom32.inc}

unit r_segs2;

interface

uses
  d_delphi,
  m_fixed,
  r_defs;

var
  rw_scale_dbl: double;
  rw_scalestep_dbl: double;

  worldhigh_dbl: double;
  worldlow_dbl: double;

  pixhigh_dbl: double;
  pixlow_dbl: double;
  pixhighstep_dbl: double;
  pixlowstep_dbl: double;

  topfrac_dbl: double;
  topstep_dbl: double;

  bottomfrac_dbl: double;
  bottomstep_dbl: double;

procedure R_CalcSectors;

procedure R_PrecalcSegs;

function R_DistToSeg(const seg: Pseg_t): fixed_t;

function R_CalcSegOffset(const seg: Pseg_t): fixed_t;

// JVAL 20180110
// Screen orientation for drawsegs and vissprites
procedure R_SetUpDrawSegLists;

procedure R_GetDrawsegsForVissprite(const fvis: Pvissprite_t; var fdrawsegs: Pdrawsegsbuffer_t; var fcnt: integer);

procedure R_GetDrawsegsForRange(x1, x2: integer; var fdrawsegs: Pdrawsegsbuffer_t; var fcnt: integer);

type
  drawsegfunc_t = procedure(const pds: Pdrawseg_t);

var
  f_RenderSegLoop_dbl_3dFloors_Vis: drawsegfunc_t;
  f_RenderSegLoop_dbl_Vis: drawsegfunc_t;
  f_RenderSegLoop_dbl_3dFloors: drawsegfunc_t;
  f_RenderSegLoop_dbl: PProcedure;
  f_RenderSegLoop_3dFloors_Vis: drawsegfunc_t;
  f_RenderSegLoop_Vis: drawsegfunc_t;
  f_RenderSegLoop_3dFloors: drawsegfunc_t;
  f_RenderSegLoop: PProcedure;

procedure R_SetDrawSegFunctions;

implementation

uses
  doomtype,
  doomdef,
  p_setup,
  r_bsp,
  r_column,
  r_tallcolumn,
  r_data,
  r_draw,
  r_segs,
  r_plane,
  r_main,
  r_hires,
  r_cache_walls,
  r_wall8,
  r_wall32,
  r_3dfloors,
  r_range,
  r_zbuffer,
{$IFDEF DEBUG}
  r_debug,
{$ENDIF}
  tables;

//
// R_RenderSegLoop
// Draws zero, one, or two textures (and possibly a masked
//  texture) for walls.
// Can draw or mark the starting pixel of floor and ceiling
//  textures.
// CALLED: CORE LOOPING ROUTINE.
//
procedure R_RenderSegLoop8;
{$UNDEF FLOORS3D}
{$UNDEF FLOORS3DVIS}
{$UNDEF RENDERSEGOPTIMIZED}
{$UNDEF USEDOUBLE}
{$UNDEF USEZBUFFER}
{$UNDEF TALL_WALL}
{$I R_RenderSegLoop8.inc}

procedure R_RenderSegLoop8Optimized;
{$UNDEF FLOORS3D}
{$UNDEF FLOORS3DVIS}
{$DEFINE RENDERSEGOPTIMIZED}
{$UNDEF USEDOUBLE}
{$UNDEF USEZBUFFER}
{$UNDEF TALL_WALL}
{$I R_RenderSegLoop8.inc}

procedure R_RenderSegLoop32;
{$UNDEF FLOORS3D}
{$UNDEF FLOORS3DVIS}
{$UNDEF RENDERSEGOPTIMIZED}
{$UNDEF USEDOUBLE}
{$UNDEF USEZBUFFER}
{$UNDEF TALL_WALL}
{$I R_RenderSegLoop32.inc}

procedure R_RenderSegLoop32Optimized;
{$UNDEF FLOORS3D}
{$UNDEF FLOORS3DVIS}
{$DEFINE RENDERSEGOPTIMIZED}
{$UNDEF USEDOUBLE}
{$UNDEF USEZBUFFER}
{$UNDEF TALL_WALL}
{$I R_RenderSegLoop32.inc}

procedure R_RenderSegLoop8_dbl;
{$UNDEF FLOORS3D}
{$UNDEF FLOORS3DVIS}
{$UNDEF RENDERSEGOPTIMIZED}
{$DEFINE USEDOUBLE}
{$UNDEF USEZBUFFER}
{$UNDEF TALL_WALL}
{$I R_RenderSegLoop8.inc}

procedure R_RenderSegLoop8Optimized_dbl;
{$UNDEF FLOORS3D}
{$UNDEF FLOORS3DVIS}
{$DEFINE RENDERSEGOPTIMIZED}
{$DEFINE USEDOUBLE}
{$UNDEF USEZBUFFER}
{$UNDEF TALL_WALL}
{$I R_RenderSegLoop8.inc}

procedure R_RenderSegLoop32_dbl;
{$UNDEF FLOORS3D}
{$UNDEF FLOORS3DVIS}
{$UNDEF RENDERSEGOPTIMIZED}
{$DEFINE USEDOUBLE}
{$UNDEF USEZBUFFER}
{$UNDEF TALL_WALL}
{$I R_RenderSegLoop32.inc}

procedure R_RenderSegLoop32Optimized_dbl;
{$UNDEF FLOORS3D}
{$UNDEF FLOORS3DVIS}
{$DEFINE RENDERSEGOPTIMIZED}
{$DEFINE USEDOUBLE}
{$UNDEF USEZBUFFER}
{$UNDEF TALL_WALL}
{$I R_RenderSegLoop32.inc}

procedure R_RenderSegLoop8_3dFloors(const pds: Pdrawseg_t);
{$DEFINE FLOORS3D}
{$UNDEF FLOORS3DVIS}
{$UNDEF RENDERSEGOPTIMIZED}
{$UNDEF USEDOUBLE}
{$UNDEF USEZBUFFER}
{$UNDEF TALL_WALL}
{$I R_RenderSegLoop8.inc}

procedure R_RenderSegLoop8Optimized_3dFloors(const pds: Pdrawseg_t);
{$DEFINE FLOORS3D}
{$UNDEF FLOORS3DVIS}
{$DEFINE RENDERSEGOPTIMIZED}
{$UNDEF USEDOUBLE}
{$UNDEF USEZBUFFER}
{$UNDEF TALL_WALL}
{$I R_RenderSegLoop8.inc}

procedure R_RenderSegLoop32_3dFloors(const pds: Pdrawseg_t);
{$DEFINE FLOORS3D}
{$UNDEF FLOORS3DVIS}
{$UNDEF RENDERSEGOPTIMIZED}
{$UNDEF USEDOUBLE}
{$UNDEF USEZBUFFER}
{$UNDEF TALL_WALL}
{$I R_RenderSegLoop32.inc}

procedure R_RenderSegLoop32Optimized_3dFloors(const pds: Pdrawseg_t);
{$DEFINE FLOORS3D}
{$UNDEF FLOORS3DVIS}
{$DEFINE RENDERSEGOPTIMIZED}
{$UNDEF USEDOUBLE}
{$UNDEF USEZBUFFER}
{$UNDEF TALL_WALL}
{$I R_RenderSegLoop32.inc}

procedure R_RenderSegLoop8_dbl_3dFloors(const pds: Pdrawseg_t);
{$DEFINE FLOORS3D}
{$UNDEF FLOORS3DVIS}
{$UNDEF RENDERSEGOPTIMIZED}
{$DEFINE USEDOUBLE}
{$UNDEF USEZBUFFER}
{$UNDEF TALL_WALL}
{$I R_RenderSegLoop8.inc}

procedure R_RenderSegLoop8Optimized_dbl_3dFloors(const pds: Pdrawseg_t);
{$DEFINE FLOORS3D}
{$UNDEF FLOORS3DVIS}
{$DEFINE RENDERSEGOPTIMIZED}
{$DEFINE USEDOUBLE}
{$UNDEF USEZBUFFER}
{$UNDEF TALL_WALL}
{$I R_RenderSegLoop8.inc}

procedure R_RenderSegLoop32_dbl_3dFloors(const pds: Pdrawseg_t);
{$DEFINE FLOORS3D}
{$UNDEF FLOORS3DVIS}
{$UNDEF RENDERSEGOPTIMIZED}
{$DEFINE USEDOUBLE}
{$UNDEF USEZBUFFER}
{$UNDEF TALL_WALL}
{$I R_RenderSegLoop32.inc}

procedure R_RenderSegLoop32Optimized_dbl_3dFloors(const pds: Pdrawseg_t);
{$DEFINE FLOORS3D}
{$UNDEF FLOORS3DVIS}
{$DEFINE RENDERSEGOPTIMIZED}
{$DEFINE USEDOUBLE}
{$UNDEF USEZBUFFER}
{$UNDEF TALL_WALL}
{$I R_RenderSegLoop32.inc}

////////////////////////////////////////////////////////////////////////////////
procedure R_RenderSegLoop8_Vis(const pds: Pdrawseg_t);
{$UNDEF FLOORS3D}
{$DEFINE FLOORS3DVIS}
{$UNDEF RENDERSEGOPTIMIZED}
{$UNDEF USEDOUBLE}
{$UNDEF USEZBUFFER}
{$UNDEF TALL_WALL}
{$I R_RenderSegLoop8.inc}

procedure R_RenderSegLoop8Optimized_Vis(const pds: Pdrawseg_t);
{$UNDEF FLOORS3D}
{$DEFINE FLOORS3DVIS}
{$DEFINE RENDERSEGOPTIMIZED}
{$UNDEF USEDOUBLE}
{$UNDEF USEZBUFFER}
{$UNDEF TALL_WALL}
{$I R_RenderSegLoop8.inc}

procedure R_RenderSegLoop32_Vis(const pds: Pdrawseg_t);
{$UNDEF FLOORS3D}
{$DEFINE FLOORS3DVIS}
{$UNDEF RENDERSEGOPTIMIZED}
{$UNDEF USEDOUBLE}
{$UNDEF USEZBUFFER}
{$UNDEF TALL_WALL}
{$I R_RenderSegLoop32.inc}

procedure R_RenderSegLoop32Optimized_Vis(const pds: Pdrawseg_t);
{$UNDEF FLOORS3D}
{$DEFINE FLOORS3DVIS}
{$DEFINE RENDERSEGOPTIMIZED}
{$UNDEF USEDOUBLE}
{$UNDEF USEZBUFFER}
{$UNDEF TALL_WALL}
{$I R_RenderSegLoop32.inc}

procedure R_RenderSegLoop8_dbl_Vis(const pds: Pdrawseg_t);
{$UNDEF FLOORS3D}
{$DEFINE FLOORS3DVIS}
{$UNDEF RENDERSEGOPTIMIZED}
{$DEFINE USEDOUBLE}
{$UNDEF USEZBUFFER}
{$UNDEF TALL_WALL}
{$I R_RenderSegLoop8.inc}

procedure R_RenderSegLoop8Optimized_dbl_Vis(const pds: Pdrawseg_t);
{$UNDEF FLOORS3D}
{$DEFINE FLOORS3DVIS}
{$DEFINE RENDERSEGOPTIMIZED}
{$DEFINE USEDOUBLE}
{$UNDEF USEZBUFFER}
{$UNDEF TALL_WALL}
{$I R_RenderSegLoop8.inc}

procedure R_RenderSegLoop32_dbl_Vis(const pds: Pdrawseg_t);
{$UNDEF FLOORS3D}
{$DEFINE FLOORS3DVIS}
{$UNDEF RENDERSEGOPTIMIZED}
{$DEFINE USEDOUBLE}
{$UNDEF USEZBUFFER}
{$UNDEF TALL_WALL}
{$I R_RenderSegLoop32.inc}

procedure R_RenderSegLoop32Optimized_dbl_Vis(const pds: Pdrawseg_t);
{$UNDEF FLOORS3D}
{$DEFINE FLOORS3DVIS}
{$DEFINE RENDERSEGOPTIMIZED}
{$DEFINE USEDOUBLE}
{$UNDEF USEZBUFFER}
{$UNDEF TALL_WALL}
{$I R_RenderSegLoop32.inc}

procedure R_RenderSegLoop8_3dFloors_Vis(const pds: Pdrawseg_t);
{$DEFINE FLOORS3D}
{$DEFINE FLOORS3DVIS}
{$UNDEF RENDERSEGOPTIMIZED}
{$UNDEF USEDOUBLE}
{$UNDEF USEZBUFFER}
{$UNDEF TALL_WALL}
{$I R_RenderSegLoop8.inc}

procedure R_RenderSegLoop8Optimized_3dFloors_Vis(const pds: Pdrawseg_t);
{$DEFINE FLOORS3D}
{$DEFINE FLOORS3DVIS}
{$DEFINE RENDERSEGOPTIMIZED}
{$UNDEF USEDOUBLE}
{$UNDEF USEZBUFFER}
{$UNDEF TALL_WALL}
{$I R_RenderSegLoop8.inc}

procedure R_RenderSegLoop32_3dFloors_Vis(const pds: Pdrawseg_t);
{$DEFINE FLOORS3D}
{$DEFINE FLOORS3DVIS}
{$UNDEF RENDERSEGOPTIMIZED}
{$UNDEF USEDOUBLE}
{$UNDEF USEZBUFFER}
{$UNDEF TALL_WALL}
{$I R_RenderSegLoop32.inc}

procedure R_RenderSegLoop32Optimized_3dFloors_Vis(const pds: Pdrawseg_t);
{$DEFINE FLOORS3D}
{$DEFINE FLOORS3DVIS}
{$DEFINE RENDERSEGOPTIMIZED}
{$UNDEF USEDOUBLE}
{$UNDEF USEZBUFFER}
{$UNDEF TALL_WALL}
{$I R_RenderSegLoop32.inc}

procedure R_RenderSegLoop8_dbl_3dFloors_Vis(const pds: Pdrawseg_t);
{$DEFINE FLOORS3D}
{$DEFINE FLOORS3DVIS}
{$UNDEF RENDERSEGOPTIMIZED}
{$DEFINE USEDOUBLE}
{$UNDEF USEZBUFFER}
{$UNDEF TALL_WALL}
{$I R_RenderSegLoop8.inc}

procedure R_RenderSegLoop8Optimized_dbl_3dFloors_Vis(const pds: Pdrawseg_t);
{$DEFINE FLOORS3D}
{$DEFINE FLOORS3DVIS}
{$DEFINE RENDERSEGOPTIMIZED}
{$DEFINE USEDOUBLE}
{$UNDEF USEZBUFFER}
{$UNDEF TALL_WALL}
{$I R_RenderSegLoop8.inc}

procedure R_RenderSegLoop32_dbl_3dFloors_Vis(const pds: Pdrawseg_t);
{$DEFINE FLOORS3D}
{$DEFINE FLOORS3DVIS}
{$UNDEF RENDERSEGOPTIMIZED}
{$DEFINE USEDOUBLE}
{$UNDEF USEZBUFFER}
{$UNDEF TALL_WALL}
{$I R_RenderSegLoop32.inc}

procedure R_RenderSegLoop32Optimized_dbl_3dFloors_Vis(const pds: Pdrawseg_t);
{$DEFINE FLOORS3D}
{$DEFINE FLOORS3DVIS}
{$DEFINE RENDERSEGOPTIMIZED}
{$DEFINE USEDOUBLE}
{$UNDEF USEZBUFFER}
{$UNDEF TALL_WALL}
{$I R_RenderSegLoop32.inc}

procedure R_RenderSegLoop8_Z;
{$UNDEF FLOORS3D}
{$UNDEF FLOORS3DVIS}
{$UNDEF RENDERSEGOPTIMIZED}
{$UNDEF USEDOUBLE}
{$DEFINE USEZBUFFER}
{$UNDEF TALL_WALL}
{$I R_RenderSegLoop8.inc}

procedure R_RenderSegLoop8Optimized_Z;
{$UNDEF FLOORS3D}
{$UNDEF FLOORS3DVIS}
{$DEFINE RENDERSEGOPTIMIZED}
{$UNDEF USEDOUBLE}
{$DEFINE USEZBUFFER}
{$UNDEF TALL_WALL}
{$I R_RenderSegLoop8.inc}

procedure R_RenderSegLoop32_Z;
{$UNDEF FLOORS3D}
{$UNDEF FLOORS3DVIS}
{$UNDEF RENDERSEGOPTIMIZED}
{$UNDEF USEDOUBLE}
{$DEFINE USEZBUFFER}
{$UNDEF TALL_WALL}
{$I R_RenderSegLoop32.inc}

procedure R_RenderSegLoop32Optimized_Z;
{$UNDEF FLOORS3D}
{$UNDEF FLOORS3DVIS}
{$DEFINE RENDERSEGOPTIMIZED}
{$UNDEF USEDOUBLE}
{$DEFINE USEZBUFFER}
{$UNDEF TALL_WALL}
{$I R_RenderSegLoop32.inc}

procedure R_RenderSegLoop8_dbl_Z;
{$UNDEF FLOORS3D}
{$UNDEF FLOORS3DVIS}
{$UNDEF RENDERSEGOPTIMIZED}
{$DEFINE USEDOUBLE}
{$DEFINE USEZBUFFER}
{$UNDEF TALL_WALL}
{$I R_RenderSegLoop8.inc}

procedure R_RenderSegLoop8Optimized_dbl_Z;
{$UNDEF FLOORS3D}
{$UNDEF FLOORS3DVIS}
{$DEFINE RENDERSEGOPTIMIZED}
{$DEFINE USEDOUBLE}
{$DEFINE USEZBUFFER}
{$UNDEF TALL_WALL}
{$I R_RenderSegLoop8.inc}

procedure R_RenderSegLoop32_dbl_Z;
{$UNDEF FLOORS3D}
{$UNDEF FLOORS3DVIS}
{$UNDEF RENDERSEGOPTIMIZED}
{$DEFINE USEDOUBLE}
{$DEFINE USEZBUFFER}
{$UNDEF TALL_WALL}
{$I R_RenderSegLoop32.inc}

procedure R_RenderSegLoop32Optimized_dbl_Z;
{$UNDEF FLOORS3D}
{$UNDEF FLOORS3DVIS}
{$DEFINE RENDERSEGOPTIMIZED}
{$DEFINE USEDOUBLE}
{$DEFINE USEZBUFFER}
{$UNDEF TALL_WALL}
{$I R_RenderSegLoop32.inc}

procedure R_RenderSegLoop8_3dFloors_Z(const pds: Pdrawseg_t);
{$DEFINE FLOORS3D}
{$UNDEF FLOORS3DVIS}
{$UNDEF RENDERSEGOPTIMIZED}
{$UNDEF USEDOUBLE}
{$DEFINE USEZBUFFER}
{$UNDEF TALL_WALL}
{$I R_RenderSegLoop8.inc}

procedure R_RenderSegLoop8Optimized_3dFloors_Z(const pds: Pdrawseg_t);
{$DEFINE FLOORS3D}
{$UNDEF FLOORS3DVIS}
{$DEFINE RENDERSEGOPTIMIZED}
{$UNDEF USEDOUBLE}
{$DEFINE USEZBUFFER}
{$UNDEF TALL_WALL}
{$I R_RenderSegLoop8.inc}

procedure R_RenderSegLoop32_3dFloors_Z(const pds: Pdrawseg_t);
{$DEFINE FLOORS3D}
{$UNDEF FLOORS3DVIS}
{$UNDEF RENDERSEGOPTIMIZED}
{$UNDEF USEDOUBLE}
{$DEFINE USEZBUFFER}
{$UNDEF TALL_WALL}
{$I R_RenderSegLoop32.inc}

procedure R_RenderSegLoop32Optimized_3dFloors_Z(const pds: Pdrawseg_t);
{$DEFINE FLOORS3D}
{$UNDEF FLOORS3DVIS}
{$DEFINE RENDERSEGOPTIMIZED}
{$UNDEF USEDOUBLE}
{$DEFINE USEZBUFFER}
{$UNDEF TALL_WALL}
{$I R_RenderSegLoop32.inc}

procedure R_RenderSegLoop8_dbl_3dFloors_Z(const pds: Pdrawseg_t);
{$DEFINE FLOORS3D}
{$UNDEF FLOORS3DVIS}
{$UNDEF RENDERSEGOPTIMIZED}
{$DEFINE USEDOUBLE}
{$DEFINE USEZBUFFER}
{$UNDEF TALL_WALL}
{$I R_RenderSegLoop8.inc}

procedure R_RenderSegLoop8Optimized_dbl_3dFloors_Z(const pds: Pdrawseg_t);
{$DEFINE FLOORS3D}
{$UNDEF FLOORS3DVIS}
{$DEFINE RENDERSEGOPTIMIZED}
{$DEFINE USEDOUBLE}
{$DEFINE USEZBUFFER}
{$UNDEF TALL_WALL}
{$I R_RenderSegLoop8.inc}

procedure R_RenderSegLoop32_dbl_3dFloors_Z(const pds: Pdrawseg_t);
{$DEFINE FLOORS3D}
{$UNDEF FLOORS3DVIS}
{$UNDEF RENDERSEGOPTIMIZED}
{$DEFINE USEDOUBLE}
{$DEFINE USEZBUFFER}
{$UNDEF TALL_WALL}
{$I R_RenderSegLoop32.inc}

procedure R_RenderSegLoop32Optimized_dbl_3dFloors_Z(const pds: Pdrawseg_t);
{$DEFINE FLOORS3D}
{$UNDEF FLOORS3DVIS}
{$DEFINE RENDERSEGOPTIMIZED}
{$DEFINE USEDOUBLE}
{$DEFINE USEZBUFFER}
{$UNDEF TALL_WALL}
{$I R_RenderSegLoop32.inc}

////////////////////////////////////////////////////////////////////////////////
procedure R_RenderSegLoop8_Vis_Z(const pds: Pdrawseg_t);
{$UNDEF FLOORS3D}
{$DEFINE FLOORS3DVIS}
{$UNDEF RENDERSEGOPTIMIZED}
{$UNDEF USEDOUBLE}
{$DEFINE USEZBUFFER}
{$UNDEF TALL_WALL}
{$I R_RenderSegLoop8.inc}

procedure R_RenderSegLoop8Optimized_Vis_Z(const pds: Pdrawseg_t);
{$UNDEF FLOORS3D}
{$DEFINE FLOORS3DVIS}
{$DEFINE RENDERSEGOPTIMIZED}
{$UNDEF USEDOUBLE}
{$DEFINE USEZBUFFER}
{$UNDEF TALL_WALL}
{$I R_RenderSegLoop8.inc}

procedure R_RenderSegLoop32_Vis_Z(const pds: Pdrawseg_t);
{$UNDEF FLOORS3D}
{$DEFINE FLOORS3DVIS}
{$UNDEF RENDERSEGOPTIMIZED}
{$UNDEF USEDOUBLE}
{$DEFINE USEZBUFFER}
{$UNDEF TALL_WALL}
{$I R_RenderSegLoop32.inc}

procedure R_RenderSegLoop32Optimized_Vis_Z(const pds: Pdrawseg_t);
{$UNDEF FLOORS3D}
{$DEFINE FLOORS3DVIS}
{$DEFINE RENDERSEGOPTIMIZED}
{$UNDEF USEDOUBLE}
{$DEFINE USEZBUFFER}
{$UNDEF TALL_WALL}
{$I R_RenderSegLoop32.inc}

procedure R_RenderSegLoop8_dbl_Vis_Z(const pds: Pdrawseg_t);
{$UNDEF FLOORS3D}
{$DEFINE FLOORS3DVIS}
{$UNDEF RENDERSEGOPTIMIZED}
{$DEFINE USEDOUBLE}
{$DEFINE USEZBUFFER}
{$UNDEF TALL_WALL}
{$I R_RenderSegLoop8.inc}

procedure R_RenderSegLoop8Optimized_dbl_Vis_Z(const pds: Pdrawseg_t);
{$UNDEF FLOORS3D}
{$DEFINE FLOORS3DVIS}
{$DEFINE RENDERSEGOPTIMIZED}
{$DEFINE USEDOUBLE}
{$DEFINE USEZBUFFER}
{$UNDEF TALL_WALL}
{$I R_RenderSegLoop8.inc}

procedure R_RenderSegLoop32_dbl_Vis_Z(const pds: Pdrawseg_t);
{$UNDEF FLOORS3D}
{$DEFINE FLOORS3DVIS}
{$UNDEF RENDERSEGOPTIMIZED}
{$DEFINE USEDOUBLE}
{$DEFINE USEZBUFFER}
{$UNDEF TALL_WALL}
{$I R_RenderSegLoop32.inc}

procedure R_RenderSegLoop32Optimized_dbl_Vis_Z(const pds: Pdrawseg_t);
{$UNDEF FLOORS3D}
{$DEFINE FLOORS3DVIS}
{$DEFINE RENDERSEGOPTIMIZED}
{$DEFINE USEDOUBLE}
{$DEFINE USEZBUFFER}
{$UNDEF TALL_WALL}
{$I R_RenderSegLoop32.inc}

procedure R_RenderSegLoop8_3dFloors_Vis_Z(const pds: Pdrawseg_t);
{$DEFINE FLOORS3D}
{$DEFINE FLOORS3DVIS}
{$UNDEF RENDERSEGOPTIMIZED}
{$UNDEF USEDOUBLE}
{$DEFINE USEZBUFFER}
{$UNDEF TALL_WALL}
{$I R_RenderSegLoop8.inc}

procedure R_RenderSegLoop8Optimized_3dFloors_Vis_Z(const pds: Pdrawseg_t);
{$DEFINE FLOORS3D}
{$DEFINE FLOORS3DVIS}
{$DEFINE RENDERSEGOPTIMIZED}
{$UNDEF USEDOUBLE}
{$DEFINE USEZBUFFER}
{$UNDEF TALL_WALL}
{$I R_RenderSegLoop8.inc}

procedure R_RenderSegLoop32_3dFloors_Vis_Z(const pds: Pdrawseg_t);
{$DEFINE FLOORS3D}
{$DEFINE FLOORS3DVIS}
{$UNDEF RENDERSEGOPTIMIZED}
{$UNDEF USEDOUBLE}
{$DEFINE USEZBUFFER}
{$UNDEF TALL_WALL}
{$I R_RenderSegLoop32.inc}

procedure R_RenderSegLoop32Optimized_3dFloors_Vis_Z(const pds: Pdrawseg_t);
{$DEFINE FLOORS3D}
{$DEFINE FLOORS3DVIS}
{$DEFINE RENDERSEGOPTIMIZED}
{$UNDEF USEDOUBLE}
{$DEFINE USEZBUFFER}
{$UNDEF TALL_WALL}
{$I R_RenderSegLoop32.inc}

procedure R_RenderSegLoop8_dbl_3dFloors_Vis_Z(const pds: Pdrawseg_t);
{$DEFINE FLOORS3D}
{$DEFINE FLOORS3DVIS}
{$UNDEF RENDERSEGOPTIMIZED}
{$DEFINE USEDOUBLE}
{$DEFINE USEZBUFFER}
{$UNDEF TALL_WALL}
{$I R_RenderSegLoop8.inc}

procedure R_RenderSegLoop8Optimized_dbl_3dFloors_Vis_Z(const pds: Pdrawseg_t);
{$DEFINE FLOORS3D}
{$DEFINE FLOORS3DVIS}
{$DEFINE RENDERSEGOPTIMIZED}
{$DEFINE USEDOUBLE}
{$DEFINE USEZBUFFER}
{$UNDEF TALL_WALL}
{$I R_RenderSegLoop8.inc}

procedure R_RenderSegLoop32_dbl_3dFloors_Vis_Z(const pds: Pdrawseg_t);
{$DEFINE FLOORS3D}
{$DEFINE FLOORS3DVIS}
{$UNDEF RENDERSEGOPTIMIZED}
{$DEFINE USEDOUBLE}
{$DEFINE USEZBUFFER}
{$UNDEF TALL_WALL}
{$I R_RenderSegLoop32.inc}

procedure R_RenderSegLoop32Optimized_dbl_3dFloors_Vis_Z(const pds: Pdrawseg_t);
{$DEFINE FLOORS3D}
{$DEFINE FLOORS3DVIS}
{$DEFINE RENDERSEGOPTIMIZED}
{$DEFINE USEDOUBLE}
{$DEFINE USEZBUFFER}
{$UNDEF TALL_WALL}
{$I R_RenderSegLoop32.inc}

////////////////////////////////////////////////////////////////////////////////
procedure R_RenderSegLoop8_TW;
{$UNDEF FLOORS3D}
{$UNDEF FLOORS3DVIS}
{$UNDEF RENDERSEGOPTIMIZED}
{$UNDEF USEDOUBLE}
{$UNDEF USEZBUFFER}
{$DEFINE TALL_WALL}
{$I R_RenderSegLoop8.inc}

procedure R_RenderSegLoop8Optimized_TW;
{$UNDEF FLOORS3D}
{$UNDEF FLOORS3DVIS}
{$DEFINE RENDERSEGOPTIMIZED}
{$UNDEF USEDOUBLE}
{$UNDEF USEZBUFFER}
{$DEFINE TALL_WALL}
{$I R_RenderSegLoop8.inc}

procedure R_RenderSegLoop32_TW;
{$UNDEF FLOORS3D}
{$UNDEF FLOORS3DVIS}
{$UNDEF RENDERSEGOPTIMIZED}
{$UNDEF USEDOUBLE}
{$UNDEF USEZBUFFER}
{$DEFINE TALL_WALL}
{$I R_RenderSegLoop32.inc}

procedure R_RenderSegLoop32Optimized_TW;
{$UNDEF FLOORS3D}
{$UNDEF FLOORS3DVIS}
{$DEFINE RENDERSEGOPTIMIZED}
{$UNDEF USEDOUBLE}
{$UNDEF USEZBUFFER}
{$DEFINE TALL_WALL}
{$I R_RenderSegLoop32.inc}

procedure R_RenderSegLoop8_dbl_TW;
{$UNDEF FLOORS3D}
{$UNDEF FLOORS3DVIS}
{$UNDEF RENDERSEGOPTIMIZED}
{$DEFINE USEDOUBLE}
{$UNDEF USEZBUFFER}
{$DEFINE TALL_WALL}
{$I R_RenderSegLoop8.inc}

procedure R_RenderSegLoop8Optimized_dbl_TW;
{$UNDEF FLOORS3D}
{$UNDEF FLOORS3DVIS}
{$DEFINE RENDERSEGOPTIMIZED}
{$DEFINE USEDOUBLE}
{$UNDEF USEZBUFFER}
{$DEFINE TALL_WALL}
{$I R_RenderSegLoop8.inc}

procedure R_RenderSegLoop32_dbl_TW;
{$UNDEF FLOORS3D}
{$UNDEF FLOORS3DVIS}
{$UNDEF RENDERSEGOPTIMIZED}
{$DEFINE USEDOUBLE}
{$UNDEF USEZBUFFER}
{$DEFINE TALL_WALL}
{$I R_RenderSegLoop32.inc}

procedure R_RenderSegLoop32Optimized_dbl_TW;
{$UNDEF FLOORS3D}
{$UNDEF FLOORS3DVIS}
{$DEFINE RENDERSEGOPTIMIZED}
{$DEFINE USEDOUBLE}
{$UNDEF USEZBUFFER}
{$DEFINE TALL_WALL}
{$I R_RenderSegLoop32.inc}

procedure R_RenderSegLoop8_3dFloors_TW(const pds: Pdrawseg_t);
{$DEFINE FLOORS3D}
{$UNDEF FLOORS3DVIS}
{$UNDEF RENDERSEGOPTIMIZED}
{$UNDEF USEDOUBLE}
{$UNDEF USEZBUFFER}
{$DEFINE TALL_WALL}
{$I R_RenderSegLoop8.inc}

procedure R_RenderSegLoop8Optimized_3dFloors_TW(const pds: Pdrawseg_t);
{$DEFINE FLOORS3D}
{$UNDEF FLOORS3DVIS}
{$DEFINE RENDERSEGOPTIMIZED}
{$UNDEF USEDOUBLE}
{$UNDEF USEZBUFFER}
{$DEFINE TALL_WALL}
{$I R_RenderSegLoop8.inc}

procedure R_RenderSegLoop32_3dFloors_TW(const pds: Pdrawseg_t);
{$DEFINE FLOORS3D}
{$UNDEF FLOORS3DVIS}
{$UNDEF RENDERSEGOPTIMIZED}
{$UNDEF USEDOUBLE}
{$UNDEF USEZBUFFER}
{$DEFINE TALL_WALL}
{$I R_RenderSegLoop32.inc}

procedure R_RenderSegLoop32Optimized_3dFloors_TW(const pds: Pdrawseg_t);
{$DEFINE FLOORS3D}
{$UNDEF FLOORS3DVIS}
{$DEFINE RENDERSEGOPTIMIZED}
{$UNDEF USEDOUBLE}
{$UNDEF USEZBUFFER}
{$DEFINE TALL_WALL}
{$I R_RenderSegLoop32.inc}

procedure R_RenderSegLoop8_dbl_3dFloors_TW(const pds: Pdrawseg_t);
{$DEFINE FLOORS3D}
{$UNDEF FLOORS3DVIS}
{$UNDEF RENDERSEGOPTIMIZED}
{$DEFINE USEDOUBLE}
{$UNDEF USEZBUFFER}
{$DEFINE TALL_WALL}
{$I R_RenderSegLoop8.inc}

procedure R_RenderSegLoop8Optimized_dbl_3dFloors_TW(const pds: Pdrawseg_t);
{$DEFINE FLOORS3D}
{$UNDEF FLOORS3DVIS}
{$DEFINE RENDERSEGOPTIMIZED}
{$DEFINE USEDOUBLE}
{$UNDEF USEZBUFFER}
{$DEFINE TALL_WALL}
{$I R_RenderSegLoop8.inc}

procedure R_RenderSegLoop32_dbl_3dFloors_TW(const pds: Pdrawseg_t);
{$DEFINE FLOORS3D}
{$UNDEF FLOORS3DVIS}
{$UNDEF RENDERSEGOPTIMIZED}
{$DEFINE USEDOUBLE}
{$UNDEF USEZBUFFER}
{$DEFINE TALL_WALL}
{$I R_RenderSegLoop32.inc}

procedure R_RenderSegLoop32Optimized_dbl_3dFloors_TW(const pds: Pdrawseg_t);
{$DEFINE FLOORS3D}
{$UNDEF FLOORS3DVIS}
{$DEFINE RENDERSEGOPTIMIZED}
{$DEFINE USEDOUBLE}
{$UNDEF USEZBUFFER}
{$DEFINE TALL_WALL}
{$I R_RenderSegLoop32.inc}

////////////////////////////////////////////////////////////////////////////////
procedure R_RenderSegLoop8_Vis_TW(const pds: Pdrawseg_t);
{$UNDEF FLOORS3D}
{$DEFINE FLOORS3DVIS}
{$UNDEF RENDERSEGOPTIMIZED}
{$UNDEF USEDOUBLE}
{$UNDEF USEZBUFFER}
{$DEFINE TALL_WALL}
{$I R_RenderSegLoop8.inc}

procedure R_RenderSegLoop8Optimized_Vis_TW(const pds: Pdrawseg_t);
{$UNDEF FLOORS3D}
{$DEFINE FLOORS3DVIS}
{$DEFINE RENDERSEGOPTIMIZED}
{$UNDEF USEDOUBLE}
{$UNDEF USEZBUFFER}
{$DEFINE TALL_WALL}
{$I R_RenderSegLoop8.inc}

procedure R_RenderSegLoop32_Vis_TW(const pds: Pdrawseg_t);
{$UNDEF FLOORS3D}
{$DEFINE FLOORS3DVIS}
{$UNDEF RENDERSEGOPTIMIZED}
{$UNDEF USEDOUBLE}
{$UNDEF USEZBUFFER}
{$DEFINE TALL_WALL}
{$I R_RenderSegLoop32.inc}

procedure R_RenderSegLoop32Optimized_Vis_TW(const pds: Pdrawseg_t);
{$UNDEF FLOORS3D}
{$DEFINE FLOORS3DVIS}
{$DEFINE RENDERSEGOPTIMIZED}
{$UNDEF USEDOUBLE}
{$UNDEF USEZBUFFER}
{$DEFINE TALL_WALL}
{$I R_RenderSegLoop32.inc}

procedure R_RenderSegLoop8_dbl_Vis_TW(const pds: Pdrawseg_t);
{$UNDEF FLOORS3D}
{$DEFINE FLOORS3DVIS}
{$UNDEF RENDERSEGOPTIMIZED}
{$DEFINE USEDOUBLE}
{$UNDEF USEZBUFFER}
{$DEFINE TALL_WALL}
{$I R_RenderSegLoop8.inc}

procedure R_RenderSegLoop8Optimized_dbl_Vis_TW(const pds: Pdrawseg_t);
{$UNDEF FLOORS3D}
{$DEFINE FLOORS3DVIS}
{$DEFINE RENDERSEGOPTIMIZED}
{$DEFINE USEDOUBLE}
{$UNDEF USEZBUFFER}
{$DEFINE TALL_WALL}
{$I R_RenderSegLoop8.inc}

procedure R_RenderSegLoop32_dbl_Vis_TW(const pds: Pdrawseg_t);
{$UNDEF FLOORS3D}
{$DEFINE FLOORS3DVIS}
{$UNDEF RENDERSEGOPTIMIZED}
{$DEFINE USEDOUBLE}
{$UNDEF USEZBUFFER}
{$DEFINE TALL_WALL}
{$I R_RenderSegLoop32.inc}

procedure R_RenderSegLoop32Optimized_dbl_Vis_TW(const pds: Pdrawseg_t);
{$UNDEF FLOORS3D}
{$DEFINE FLOORS3DVIS}
{$DEFINE RENDERSEGOPTIMIZED}
{$DEFINE USEDOUBLE}
{$UNDEF USEZBUFFER}
{$DEFINE TALL_WALL}
{$I R_RenderSegLoop32.inc}

procedure R_RenderSegLoop8_3dFloors_Vis_TW(const pds: Pdrawseg_t);
{$DEFINE FLOORS3D}
{$DEFINE FLOORS3DVIS}
{$UNDEF RENDERSEGOPTIMIZED}
{$UNDEF USEDOUBLE}
{$UNDEF USEZBUFFER}
{$DEFINE TALL_WALL}
{$I R_RenderSegLoop8.inc}

procedure R_RenderSegLoop8Optimized_3dFloors_Vis_TW(const pds: Pdrawseg_t);
{$DEFINE FLOORS3D}
{$DEFINE FLOORS3DVIS}
{$DEFINE RENDERSEGOPTIMIZED}
{$UNDEF USEDOUBLE}
{$UNDEF USEZBUFFER}
{$DEFINE TALL_WALL}
{$I R_RenderSegLoop8.inc}

procedure R_RenderSegLoop32_3dFloors_Vis_TW(const pds: Pdrawseg_t);
{$DEFINE FLOORS3D}
{$DEFINE FLOORS3DVIS}
{$UNDEF RENDERSEGOPTIMIZED}
{$UNDEF USEDOUBLE}
{$UNDEF USEZBUFFER}
{$DEFINE TALL_WALL}
{$I R_RenderSegLoop32.inc}

procedure R_RenderSegLoop32Optimized_3dFloors_Vis_TW(const pds: Pdrawseg_t);
{$DEFINE FLOORS3D}
{$DEFINE FLOORS3DVIS}
{$DEFINE RENDERSEGOPTIMIZED}
{$UNDEF USEDOUBLE}
{$UNDEF USEZBUFFER}
{$DEFINE TALL_WALL}
{$I R_RenderSegLoop32.inc}

procedure R_RenderSegLoop8_dbl_3dFloors_Vis_TW(const pds: Pdrawseg_t);
{$DEFINE FLOORS3D}
{$DEFINE FLOORS3DVIS}
{$UNDEF RENDERSEGOPTIMIZED}
{$DEFINE USEDOUBLE}
{$UNDEF USEZBUFFER}
{$DEFINE TALL_WALL}
{$I R_RenderSegLoop8.inc}

procedure R_RenderSegLoop8Optimized_dbl_3dFloors_Vis_TW(const pds: Pdrawseg_t);
{$DEFINE FLOORS3D}
{$DEFINE FLOORS3DVIS}
{$DEFINE RENDERSEGOPTIMIZED}
{$DEFINE USEDOUBLE}
{$UNDEF USEZBUFFER}
{$DEFINE TALL_WALL}
{$I R_RenderSegLoop8.inc}

procedure R_RenderSegLoop32_dbl_3dFloors_Vis_TW(const pds: Pdrawseg_t);
{$DEFINE FLOORS3D}
{$DEFINE FLOORS3DVIS}
{$UNDEF RENDERSEGOPTIMIZED}
{$DEFINE USEDOUBLE}
{$UNDEF USEZBUFFER}
{$DEFINE TALL_WALL}
{$I R_RenderSegLoop32.inc}

procedure R_RenderSegLoop32Optimized_dbl_3dFloors_Vis_TW(const pds: Pdrawseg_t);
{$DEFINE FLOORS3D}
{$DEFINE FLOORS3DVIS}
{$DEFINE RENDERSEGOPTIMIZED}
{$DEFINE USEDOUBLE}
{$UNDEF USEZBUFFER}
{$DEFINE TALL_WALL}
{$I R_RenderSegLoop32.inc}

procedure R_RenderSegLoop8_Z_TW;
{$UNDEF FLOORS3D}
{$UNDEF FLOORS3DVIS}
{$UNDEF RENDERSEGOPTIMIZED}
{$UNDEF USEDOUBLE}
{$DEFINE USEZBUFFER}
{$DEFINE TALL_WALL}
{$I R_RenderSegLoop8.inc}

procedure R_RenderSegLoop8Optimized_Z_TW;
{$UNDEF FLOORS3D}
{$UNDEF FLOORS3DVIS}
{$DEFINE RENDERSEGOPTIMIZED}
{$UNDEF USEDOUBLE}
{$DEFINE USEZBUFFER}
{$DEFINE TALL_WALL}
{$I R_RenderSegLoop8.inc}

procedure R_RenderSegLoop32_Z_TW;
{$UNDEF FLOORS3D}
{$UNDEF FLOORS3DVIS}
{$UNDEF RENDERSEGOPTIMIZED}
{$UNDEF USEDOUBLE}
{$DEFINE USEZBUFFER}
{$DEFINE TALL_WALL}
{$I R_RenderSegLoop32.inc}

procedure R_RenderSegLoop32Optimized_Z_TW;
{$UNDEF FLOORS3D}
{$UNDEF FLOORS3DVIS}
{$DEFINE RENDERSEGOPTIMIZED}
{$UNDEF USEDOUBLE}
{$DEFINE USEZBUFFER}
{$DEFINE TALL_WALL}
{$I R_RenderSegLoop32.inc}

procedure R_RenderSegLoop8_dbl_Z_TW;
{$UNDEF FLOORS3D}
{$UNDEF FLOORS3DVIS}
{$UNDEF RENDERSEGOPTIMIZED}
{$DEFINE USEDOUBLE}
{$DEFINE USEZBUFFER}
{$DEFINE TALL_WALL}
{$I R_RenderSegLoop8.inc}

procedure R_RenderSegLoop8Optimized_dbl_Z_TW;
{$UNDEF FLOORS3D}
{$UNDEF FLOORS3DVIS}
{$DEFINE RENDERSEGOPTIMIZED}
{$DEFINE USEDOUBLE}
{$DEFINE USEZBUFFER}
{$DEFINE TALL_WALL}
{$I R_RenderSegLoop8.inc}

procedure R_RenderSegLoop32_dbl_Z_TW;
{$UNDEF FLOORS3D}
{$UNDEF FLOORS3DVIS}
{$UNDEF RENDERSEGOPTIMIZED}
{$DEFINE USEDOUBLE}
{$DEFINE USEZBUFFER}
{$DEFINE TALL_WALL}
{$I R_RenderSegLoop32.inc}

procedure R_RenderSegLoop32Optimized_dbl_Z_TW;
{$UNDEF FLOORS3D}
{$UNDEF FLOORS3DVIS}
{$DEFINE RENDERSEGOPTIMIZED}
{$DEFINE USEDOUBLE}
{$DEFINE USEZBUFFER}
{$DEFINE TALL_WALL}
{$I R_RenderSegLoop32.inc}

procedure R_RenderSegLoop8_3dFloors_Z_TW(const pds: Pdrawseg_t);
{$DEFINE FLOORS3D}
{$UNDEF FLOORS3DVIS}
{$UNDEF RENDERSEGOPTIMIZED}
{$UNDEF USEDOUBLE}
{$DEFINE USEZBUFFER}
{$DEFINE TALL_WALL}
{$I R_RenderSegLoop8.inc}

procedure R_RenderSegLoop8Optimized_3dFloors_Z_TW(const pds: Pdrawseg_t);
{$DEFINE FLOORS3D}
{$UNDEF FLOORS3DVIS}
{$DEFINE RENDERSEGOPTIMIZED}
{$UNDEF USEDOUBLE}
{$DEFINE USEZBUFFER}
{$DEFINE TALL_WALL}
{$I R_RenderSegLoop8.inc}

procedure R_RenderSegLoop32_3dFloors_Z_TW(const pds: Pdrawseg_t);
{$DEFINE FLOORS3D}
{$UNDEF FLOORS3DVIS}
{$UNDEF RENDERSEGOPTIMIZED}
{$UNDEF USEDOUBLE}
{$DEFINE USEZBUFFER}
{$DEFINE TALL_WALL}
{$I R_RenderSegLoop32.inc}

procedure R_RenderSegLoop32Optimized_3dFloors_Z_TW(const pds: Pdrawseg_t);
{$DEFINE FLOORS3D}
{$UNDEF FLOORS3DVIS}
{$DEFINE RENDERSEGOPTIMIZED}
{$UNDEF USEDOUBLE}
{$DEFINE USEZBUFFER}
{$DEFINE TALL_WALL}
{$I R_RenderSegLoop32.inc}

procedure R_RenderSegLoop8_dbl_3dFloors_Z_TW(const pds: Pdrawseg_t);
{$DEFINE FLOORS3D}
{$UNDEF FLOORS3DVIS}
{$UNDEF RENDERSEGOPTIMIZED}
{$DEFINE USEDOUBLE}
{$DEFINE USEZBUFFER}
{$DEFINE TALL_WALL}
{$I R_RenderSegLoop8.inc}

procedure R_RenderSegLoop8Optimized_dbl_3dFloors_Z_TW(const pds: Pdrawseg_t);
{$DEFINE FLOORS3D}
{$UNDEF FLOORS3DVIS}
{$DEFINE RENDERSEGOPTIMIZED}
{$DEFINE USEDOUBLE}
{$DEFINE USEZBUFFER}
{$DEFINE TALL_WALL}
{$I R_RenderSegLoop8.inc}

procedure R_RenderSegLoop32_dbl_3dFloors_Z_TW(const pds: Pdrawseg_t);
{$DEFINE FLOORS3D}
{$UNDEF FLOORS3DVIS}
{$UNDEF RENDERSEGOPTIMIZED}
{$DEFINE USEDOUBLE}
{$DEFINE USEZBUFFER}
{$DEFINE TALL_WALL}
{$I R_RenderSegLoop32.inc}

procedure R_RenderSegLoop32Optimized_dbl_3dFloors_Z_TW(const pds: Pdrawseg_t);
{$DEFINE FLOORS3D}
{$UNDEF FLOORS3DVIS}
{$DEFINE RENDERSEGOPTIMIZED}
{$DEFINE USEDOUBLE}
{$DEFINE USEZBUFFER}
{$DEFINE TALL_WALL}
{$I R_RenderSegLoop32.inc}

////////////////////////////////////////////////////////////////////////////////
procedure R_RenderSegLoop8_Vis_Z_TW(const pds: Pdrawseg_t);
{$UNDEF FLOORS3D}
{$DEFINE FLOORS3DVIS}
{$UNDEF RENDERSEGOPTIMIZED}
{$UNDEF USEDOUBLE}
{$DEFINE USEZBUFFER}
{$DEFINE TALL_WALL}
{$I R_RenderSegLoop8.inc}

procedure R_RenderSegLoop8Optimized_Vis_Z_TW(const pds: Pdrawseg_t);
{$UNDEF FLOORS3D}
{$DEFINE FLOORS3DVIS}
{$DEFINE RENDERSEGOPTIMIZED}
{$UNDEF USEDOUBLE}
{$DEFINE USEZBUFFER}
{$DEFINE TALL_WALL}
{$I R_RenderSegLoop8.inc}

procedure R_RenderSegLoop32_Vis_Z_TW(const pds: Pdrawseg_t);
{$UNDEF FLOORS3D}
{$DEFINE FLOORS3DVIS}
{$UNDEF RENDERSEGOPTIMIZED}
{$UNDEF USEDOUBLE}
{$DEFINE USEZBUFFER}
{$DEFINE TALL_WALL}
{$I R_RenderSegLoop32.inc}

procedure R_RenderSegLoop32Optimized_Vis_Z_TW(const pds: Pdrawseg_t);
{$UNDEF FLOORS3D}
{$DEFINE FLOORS3DVIS}
{$DEFINE RENDERSEGOPTIMIZED}
{$UNDEF USEDOUBLE}
{$DEFINE USEZBUFFER}
{$DEFINE TALL_WALL}
{$I R_RenderSegLoop32.inc}

procedure R_RenderSegLoop8_dbl_Vis_Z_TW(const pds: Pdrawseg_t);
{$UNDEF FLOORS3D}
{$DEFINE FLOORS3DVIS}
{$UNDEF RENDERSEGOPTIMIZED}
{$DEFINE USEDOUBLE}
{$DEFINE USEZBUFFER}
{$DEFINE TALL_WALL}
{$I R_RenderSegLoop8.inc}

procedure R_RenderSegLoop8Optimized_dbl_Vis_Z_TW(const pds: Pdrawseg_t);
{$UNDEF FLOORS3D}
{$DEFINE FLOORS3DVIS}
{$DEFINE RENDERSEGOPTIMIZED}
{$DEFINE USEDOUBLE}
{$DEFINE USEZBUFFER}
{$DEFINE TALL_WALL}
{$I R_RenderSegLoop8.inc}

procedure R_RenderSegLoop32_dbl_Vis_Z_TW(const pds: Pdrawseg_t);
{$UNDEF FLOORS3D}
{$DEFINE FLOORS3DVIS}
{$UNDEF RENDERSEGOPTIMIZED}
{$DEFINE USEDOUBLE}
{$DEFINE USEZBUFFER}
{$DEFINE TALL_WALL}
{$I R_RenderSegLoop32.inc}

procedure R_RenderSegLoop32Optimized_dbl_Vis_Z_TW(const pds: Pdrawseg_t);
{$UNDEF FLOORS3D}
{$DEFINE FLOORS3DVIS}
{$DEFINE RENDERSEGOPTIMIZED}
{$DEFINE USEDOUBLE}
{$DEFINE USEZBUFFER}
{$DEFINE TALL_WALL}
{$I R_RenderSegLoop32.inc}

procedure R_RenderSegLoop8_3dFloors_Vis_Z_TW(const pds: Pdrawseg_t);
{$DEFINE FLOORS3D}
{$DEFINE FLOORS3DVIS}
{$UNDEF RENDERSEGOPTIMIZED}
{$UNDEF USEDOUBLE}
{$DEFINE USEZBUFFER}
{$DEFINE TALL_WALL}
{$I R_RenderSegLoop8.inc}

procedure R_RenderSegLoop8Optimized_3dFloors_Vis_Z_TW(const pds: Pdrawseg_t);
{$DEFINE FLOORS3D}
{$DEFINE FLOORS3DVIS}
{$DEFINE RENDERSEGOPTIMIZED}
{$UNDEF USEDOUBLE}
{$DEFINE USEZBUFFER}
{$DEFINE TALL_WALL}
{$I R_RenderSegLoop8.inc}

procedure R_RenderSegLoop32_3dFloors_Vis_Z_TW(const pds: Pdrawseg_t);
{$DEFINE FLOORS3D}
{$DEFINE FLOORS3DVIS}
{$UNDEF RENDERSEGOPTIMIZED}
{$UNDEF USEDOUBLE}
{$DEFINE USEZBUFFER}
{$DEFINE TALL_WALL}
{$I R_RenderSegLoop32.inc}

procedure R_RenderSegLoop32Optimized_3dFloors_Vis_Z_TW(const pds: Pdrawseg_t);
{$DEFINE FLOORS3D}
{$DEFINE FLOORS3DVIS}
{$DEFINE RENDERSEGOPTIMIZED}
{$UNDEF USEDOUBLE}
{$DEFINE USEZBUFFER}
{$DEFINE TALL_WALL}
{$I R_RenderSegLoop32.inc}

procedure R_RenderSegLoop8_dbl_3dFloors_Vis_Z_TW(const pds: Pdrawseg_t);
{$DEFINE FLOORS3D}
{$DEFINE FLOORS3DVIS}
{$UNDEF RENDERSEGOPTIMIZED}
{$DEFINE USEDOUBLE}
{$DEFINE USEZBUFFER}
{$DEFINE TALL_WALL}
{$I R_RenderSegLoop8.inc}

procedure R_RenderSegLoop8Optimized_dbl_3dFloors_Vis_Z_TW(const pds: Pdrawseg_t);
{$DEFINE FLOORS3D}
{$DEFINE FLOORS3DVIS}
{$DEFINE RENDERSEGOPTIMIZED}
{$DEFINE USEDOUBLE}
{$DEFINE USEZBUFFER}
{$DEFINE TALL_WALL}
{$I R_RenderSegLoop8.inc}

procedure R_RenderSegLoop32_dbl_3dFloors_Vis_Z_TW(const pds: Pdrawseg_t);
{$DEFINE FLOORS3D}
{$DEFINE FLOORS3DVIS}
{$UNDEF RENDERSEGOPTIMIZED}
{$DEFINE USEDOUBLE}
{$DEFINE USEZBUFFER}
{$DEFINE TALL_WALL}
{$I R_RenderSegLoop32.inc}

procedure R_RenderSegLoop32Optimized_dbl_3dFloors_Vis_Z_TW(const pds: Pdrawseg_t);
{$DEFINE FLOORS3D}
{$DEFINE FLOORS3DVIS}
{$DEFINE RENDERSEGOPTIMIZED}
{$DEFINE USEDOUBLE}
{$DEFINE USEZBUFFER}
{$DEFINE TALL_WALL}
{$I R_RenderSegLoop32.inc}

var
  lowestfloor: fixed_t;
  highestceiling: fixed_t;
  level_needs_tall_walls: boolean;

const
  TALL_WALL_OFFSET = 2048 * FRACUNIT;

procedure R_SetDrawSegFunctions;
begin
  if level_needs_tall_walls then
  begin
    if videomode = vm32bit then
    begin
      if optimizedcolumnrendering then
      begin
        if zbufferactive then
        begin
          f_RenderSegLoop_dbl_3dFloors_Vis := R_RenderSegLoop32Optimized_dbl_3dFloors_Vis_Z_TW;
          f_RenderSegLoop_dbl_Vis := R_RenderSegLoop32Optimized_dbl_Vis_Z_TW;
          f_RenderSegLoop_dbl_3dFloors := R_RenderSegLoop32Optimized_dbl_3dFloors_Z_TW;
          f_RenderSegLoop_dbl := R_RenderSegLoop32Optimized_dbl_Z_TW;
          f_RenderSegLoop_3dFloors_Vis := R_RenderSegLoop32Optimized_3dFloors_Vis_Z_TW;
          f_RenderSegLoop_Vis := R_RenderSegLoop32Optimized_Vis_Z_TW;
          f_RenderSegLoop_3dFloors := R_RenderSegLoop32Optimized_3dFloors_Z_TW;
          f_RenderSegLoop := R_RenderSegLoop32Optimized_Z_TW;
        end
        else
        begin
          f_RenderSegLoop_dbl_3dFloors_Vis := R_RenderSegLoop32Optimized_dbl_3dFloors_Vis_TW;
          f_RenderSegLoop_dbl_Vis := R_RenderSegLoop32Optimized_dbl_Vis_TW;
          f_RenderSegLoop_dbl_3dFloors := R_RenderSegLoop32Optimized_dbl_3dFloors_TW;
          f_RenderSegLoop_dbl := R_RenderSegLoop32Optimized_dbl_TW;
          f_RenderSegLoop_3dFloors_Vis := R_RenderSegLoop32Optimized_3dFloors_Vis_TW;
          f_RenderSegLoop_Vis := R_RenderSegLoop32Optimized_Vis_TW;
          f_RenderSegLoop_3dFloors := R_RenderSegLoop32Optimized_3dFloors_TW;
          f_RenderSegLoop := R_RenderSegLoop32Optimized_TW;
        end;
      end
      else
      begin
        if zbufferactive then
        begin
          f_RenderSegLoop_dbl_3dFloors_Vis := R_RenderSegLoop32_dbl_3dFloors_Vis_Z_TW;
          f_RenderSegLoop_dbl_Vis := R_RenderSegLoop32_dbl_Vis_Z_TW;
          f_RenderSegLoop_dbl_3dFloors := R_RenderSegLoop32_dbl_3dFloors_Z_TW;
          f_RenderSegLoop_dbl := R_RenderSegLoop32_dbl_Z_TW;
          f_RenderSegLoop_3dFloors_Vis := R_RenderSegLoop32_3dFloors_Vis_Z_TW;
          f_RenderSegLoop_Vis := R_RenderSegLoop32_Vis_Z_TW;
          f_RenderSegLoop_3dFloors := R_RenderSegLoop32_3dFloors_Z_TW;
          f_RenderSegLoop := R_RenderSegLoop32_Z_TW;
        end
        else
        begin
          f_RenderSegLoop_dbl_3dFloors_Vis := R_RenderSegLoop32_dbl_3dFloors_Vis_TW;
          f_RenderSegLoop_dbl_Vis := R_RenderSegLoop32_dbl_Vis_TW;
          f_RenderSegLoop_dbl_3dFloors := R_RenderSegLoop32_dbl_3dFloors_TW;
          f_RenderSegLoop_dbl := R_RenderSegLoop32_dbl_TW;
          f_RenderSegLoop_3dFloors_Vis := R_RenderSegLoop32_3dFloors_Vis_TW;
          f_RenderSegLoop_Vis := R_RenderSegLoop32_Vis_TW;
          f_RenderSegLoop_3dFloors := R_RenderSegLoop32_3dFloors_TW;
          f_RenderSegLoop := R_RenderSegLoop32_TW;
        end;
      end;
    end
    else
    begin
      if optimizedcolumnrendering then
      begin
        if zbufferactive then
        begin
          f_RenderSegLoop_dbl_3dFloors_Vis := R_RenderSegLoop8Optimized_dbl_3dFloors_Vis_Z_TW;
          f_RenderSegLoop_dbl_Vis := R_RenderSegLoop8Optimized_dbl_Vis_Z_TW;
          f_RenderSegLoop_dbl_3dFloors := R_RenderSegLoop8Optimized_dbl_3dFloors_Z_TW;
          f_RenderSegLoop_dbl := R_RenderSegLoop8Optimized_dbl_Z_TW;
          f_RenderSegLoop_3dFloors_Vis := R_RenderSegLoop8Optimized_3dFloors_Vis_Z_TW;
          f_RenderSegLoop_Vis := R_RenderSegLoop8Optimized_Vis_Z_TW;
          f_RenderSegLoop_3dFloors := R_RenderSegLoop8Optimized_3dFloors_Z_TW;
          f_RenderSegLoop := R_RenderSegLoop8Optimized_Z_TW;
        end
        else
        begin
          f_RenderSegLoop_dbl_3dFloors_Vis := R_RenderSegLoop8Optimized_dbl_3dFloors_Vis_TW;
          f_RenderSegLoop_dbl_Vis := R_RenderSegLoop8Optimized_dbl_Vis_TW;
          f_RenderSegLoop_dbl_3dFloors := R_RenderSegLoop8Optimized_dbl_3dFloors_TW;
          f_RenderSegLoop_dbl := R_RenderSegLoop8Optimized_dbl_TW;
          f_RenderSegLoop_3dFloors_Vis := R_RenderSegLoop8Optimized_3dFloors_Vis_TW;
          f_RenderSegLoop_Vis := R_RenderSegLoop8Optimized_Vis_TW;
          f_RenderSegLoop_3dFloors := R_RenderSegLoop8Optimized_3dFloors_TW;
          f_RenderSegLoop := R_RenderSegLoop8Optimized_TW;
        end
      end
      else
      begin
        if zbufferactive then
        begin
          f_RenderSegLoop_dbl_3dFloors_Vis := R_RenderSegLoop8_dbl_3dFloors_Vis_Z_TW;
          f_RenderSegLoop_dbl_Vis := R_RenderSegLoop8_dbl_Vis_Z_TW;
          f_RenderSegLoop_dbl_3dFloors := R_RenderSegLoop8_dbl_3dFloors_Z_TW;
          f_RenderSegLoop_dbl := R_RenderSegLoop8_dbl_Z_TW;
          f_RenderSegLoop_3dFloors_Vis := R_RenderSegLoop8_3dFloors_Vis_Z_TW;
          f_RenderSegLoop_Vis := R_RenderSegLoop8_Vis_Z_TW;
          f_RenderSegLoop_3dFloors := R_RenderSegLoop8_3dFloors_Z_TW;
          f_RenderSegLoop := R_RenderSegLoop8_Z_TW;
        end
        else
        begin
          f_RenderSegLoop_dbl_3dFloors_Vis := R_RenderSegLoop8_dbl_3dFloors_Vis_TW;
          f_RenderSegLoop_dbl_Vis := R_RenderSegLoop8_dbl_Vis_TW;
          f_RenderSegLoop_dbl_3dFloors := R_RenderSegLoop8_dbl_3dFloors_TW;
          f_RenderSegLoop_dbl := R_RenderSegLoop8_dbl_TW;
          f_RenderSegLoop_3dFloors_Vis := R_RenderSegLoop8_3dFloors_Vis_TW;
          f_RenderSegLoop_Vis := R_RenderSegLoop8_Vis_TW;
          f_RenderSegLoop_3dFloors := R_RenderSegLoop8_3dFloors_TW;
          f_RenderSegLoop := R_RenderSegLoop8_TW;
        end;
      end;
    end;
    end
    else
    begin
    if videomode = vm32bit then
    begin
      if optimizedcolumnrendering then
      begin
        if zbufferactive then
        begin
          f_RenderSegLoop_dbl_3dFloors_Vis := R_RenderSegLoop32Optimized_dbl_3dFloors_Vis_Z;
          f_RenderSegLoop_dbl_Vis := R_RenderSegLoop32Optimized_dbl_Vis_Z;
          f_RenderSegLoop_dbl_3dFloors := R_RenderSegLoop32Optimized_dbl_3dFloors_Z;
          f_RenderSegLoop_dbl := R_RenderSegLoop32Optimized_dbl_Z;
          f_RenderSegLoop_3dFloors_Vis := R_RenderSegLoop32Optimized_3dFloors_Vis_Z;
          f_RenderSegLoop_Vis := R_RenderSegLoop32Optimized_Vis_Z;
          f_RenderSegLoop_3dFloors := R_RenderSegLoop32Optimized_3dFloors_Z;
          f_RenderSegLoop := R_RenderSegLoop32Optimized_Z;
        end
        else
        begin
          f_RenderSegLoop_dbl_3dFloors_Vis := R_RenderSegLoop32Optimized_dbl_3dFloors_Vis;
          f_RenderSegLoop_dbl_Vis := R_RenderSegLoop32Optimized_dbl_Vis;
          f_RenderSegLoop_dbl_3dFloors := R_RenderSegLoop32Optimized_dbl_3dFloors;
          f_RenderSegLoop_dbl := R_RenderSegLoop32Optimized_dbl;
          f_RenderSegLoop_3dFloors_Vis := R_RenderSegLoop32Optimized_3dFloors_Vis;
          f_RenderSegLoop_Vis := R_RenderSegLoop32Optimized_Vis;
          f_RenderSegLoop_3dFloors := R_RenderSegLoop32Optimized_3dFloors;
          f_RenderSegLoop := R_RenderSegLoop32Optimized;
        end;
      end
      else
      begin
        if zbufferactive then
        begin
          f_RenderSegLoop_dbl_3dFloors_Vis := R_RenderSegLoop32_dbl_3dFloors_Vis_Z;
          f_RenderSegLoop_dbl_Vis := R_RenderSegLoop32_dbl_Vis_Z;
          f_RenderSegLoop_dbl_3dFloors := R_RenderSegLoop32_dbl_3dFloors_Z;
          f_RenderSegLoop_dbl := R_RenderSegLoop32_dbl_Z;
          f_RenderSegLoop_3dFloors_Vis := R_RenderSegLoop32_3dFloors_Vis_Z;
          f_RenderSegLoop_Vis := R_RenderSegLoop32_Vis_Z;
          f_RenderSegLoop_3dFloors := R_RenderSegLoop32_3dFloors_Z;
          f_RenderSegLoop := R_RenderSegLoop32_Z;
        end
        else
        begin
          f_RenderSegLoop_dbl_3dFloors_Vis := R_RenderSegLoop32_dbl_3dFloors_Vis;
          f_RenderSegLoop_dbl_Vis := R_RenderSegLoop32_dbl_Vis;
          f_RenderSegLoop_dbl_3dFloors := R_RenderSegLoop32_dbl_3dFloors;
          f_RenderSegLoop_dbl := R_RenderSegLoop32_dbl;
          f_RenderSegLoop_3dFloors_Vis := R_RenderSegLoop32_3dFloors_Vis;
          f_RenderSegLoop_Vis := R_RenderSegLoop32_Vis;
          f_RenderSegLoop_3dFloors := R_RenderSegLoop32_3dFloors;
          f_RenderSegLoop := R_RenderSegLoop32;
        end;
      end;
    end
    else
    begin
      if optimizedcolumnrendering then
      begin
        if zbufferactive then
        begin
          f_RenderSegLoop_dbl_3dFloors_Vis := R_RenderSegLoop8Optimized_dbl_3dFloors_Vis_Z;
          f_RenderSegLoop_dbl_Vis := R_RenderSegLoop8Optimized_dbl_Vis_Z;
          f_RenderSegLoop_dbl_3dFloors := R_RenderSegLoop8Optimized_dbl_3dFloors_Z;
          f_RenderSegLoop_dbl := R_RenderSegLoop8Optimized_dbl_Z;
          f_RenderSegLoop_3dFloors_Vis := R_RenderSegLoop8Optimized_3dFloors_Vis_Z;
          f_RenderSegLoop_Vis := R_RenderSegLoop8Optimized_Vis_Z;
          f_RenderSegLoop_3dFloors := R_RenderSegLoop8Optimized_3dFloors_Z;
          f_RenderSegLoop := R_RenderSegLoop8Optimized_Z;
        end
        else
        begin
          f_RenderSegLoop_dbl_3dFloors_Vis := R_RenderSegLoop8Optimized_dbl_3dFloors_Vis;
          f_RenderSegLoop_dbl_Vis := R_RenderSegLoop8Optimized_dbl_Vis;
          f_RenderSegLoop_dbl_3dFloors := R_RenderSegLoop8Optimized_dbl_3dFloors;
          f_RenderSegLoop_dbl := R_RenderSegLoop8Optimized_dbl;
          f_RenderSegLoop_3dFloors_Vis := R_RenderSegLoop8Optimized_3dFloors_Vis;
          f_RenderSegLoop_Vis := R_RenderSegLoop8Optimized_Vis;
          f_RenderSegLoop_3dFloors := R_RenderSegLoop8Optimized_3dFloors;
          f_RenderSegLoop := R_RenderSegLoop8Optimized;
        end
      end
      else
      begin
        if zbufferactive then
        begin
          f_RenderSegLoop_dbl_3dFloors_Vis := R_RenderSegLoop8_dbl_3dFloors_Vis_Z;
          f_RenderSegLoop_dbl_Vis := R_RenderSegLoop8_dbl_Vis_Z;
          f_RenderSegLoop_dbl_3dFloors := R_RenderSegLoop8_dbl_3dFloors_Z;
          f_RenderSegLoop_dbl := R_RenderSegLoop8_dbl_Z;
          f_RenderSegLoop_3dFloors_Vis := R_RenderSegLoop8_3dFloors_Vis_Z;
          f_RenderSegLoop_Vis := R_RenderSegLoop8_Vis_Z;
          f_RenderSegLoop_3dFloors := R_RenderSegLoop8_3dFloors_Z;
          f_RenderSegLoop := R_RenderSegLoop8_Z;
        end
        else
        begin
          f_RenderSegLoop_dbl_3dFloors_Vis := R_RenderSegLoop8_dbl_3dFloors_Vis;
          f_RenderSegLoop_dbl_Vis := R_RenderSegLoop8_dbl_Vis;
          f_RenderSegLoop_dbl_3dFloors := R_RenderSegLoop8_dbl_3dFloors;
          f_RenderSegLoop_dbl := R_RenderSegLoop8_dbl;
          f_RenderSegLoop_3dFloors_Vis := R_RenderSegLoop8_3dFloors_Vis;
          f_RenderSegLoop_Vis := R_RenderSegLoop8_Vis;
          f_RenderSegLoop_3dFloors := R_RenderSegLoop8_3dFloors;
          f_RenderSegLoop := R_RenderSegLoop8;
        end;
      end;
    end;
  end;
end;

procedure R_CalcSectors;
var
  i: integer;
  h: int64;
begin
  lowestfloor := MAXINT;
  highestceiling := MININT;
  for i := 0 to numsectors - 1 do
  begin
    if sectors[i].floorheight < lowestfloor then
      lowestfloor := sectors[i].floorheight;
    if sectors[i].ceilingheight > highestceiling then
      highestceiling := sectors[i].ceilingheight;
  end;
  h := int64(highestceiling) - int64(lowestfloor);
  level_needs_tall_walls := h > TALL_WALL_OFFSET;
end;

procedure R_PrecalcSegs;
var
  i: integer;
  dx, dy: double;
  li: Pseg_t;
begin
  for i := 0 to numsegs - 1 do
  begin
    li := @segs[i];
    dx := li.v2.x - li.v1.x;
    dy := li.v2.y - li.v1.y;
    li.inv_length := 1 / sqrt(dx * dx + dy * dy);
  end;
end;

//
// R_DistToSeg by entryway
//
// https://www.doomworld.com/forum/topic/70288-dynamic-wiggletall-sector-fix-for-fixed-point-software-renderer/?do=findComment&comment=1340433
function R_DistToSeg(const seg: Pseg_t): fixed_t;
var
  dx, dy, dx1, dy1: double;
begin
  if seg.v1.y = seg.v2.y then
  begin
    result := viewy - seg.v1.y;
    if result < 0 then
      result := -result;
    exit;
  end;

  if seg.v1.x = seg.v2.x then
  begin
    result := viewx - seg.v1.x;
    if result < 0 then
      result := -result;
    exit;
  end;

  dx := seg.v2.x - seg.v1.x;
  dy := seg.v2.y - seg.v1.y;
  dx1 := viewx - seg.v1.x;
  dy1 := viewy - seg.v1.y;
  result := round((dy * dx1 - dx * dy1) * seg.inv_length);
  if result < 0 then
    result := -result;
end;

function R_CalcSegOffset(const seg: Pseg_t): fixed_t;
var
  dx, dy, dx1, dy1: double;
begin
  dx := seg.v2.x - seg.v1.x;
  dy := seg.v2.y - seg.v1.y;
  dx1 := viewx - seg.v1.x;
  dy1 := viewy - seg.v1.y;
  result := round((dx * dx1 + dy * dy1) * seg.inv_length);
  if result < 0 then
    result := -result;
end;

// JVAL 20180110
// Split drawseg list to speed up vissprite drawing
const
  NUM_DRAWSEGS_SLICES = 4;
  NUM_DRAWSEGS_SLICES2 = 8;
  MANY_DRAWSEGS = 2048;

type
  ds_slice_t = record
    start, finish: integer;
  end;

var
// Left screen drawsegs
  ldrawsegs: array[0..MAXDRAWSEGS - 1] of Pdrawseg_t;
  lds_p: integer;
// Right screen drawsegs
  rdrawsegs: array[0..MAXDRAWSEGS - 1] of Pdrawseg_t;
  rds_p: integer;
// Further slices
  sdrawsegs: array[0..NUM_DRAWSEGS_SLICES - 1] of array[0..MAXDRAWSEGS - 1] of Pdrawseg_t;
  sds_p: array [0..NUM_DRAWSEGS_SLICES - 1] of integer;
  ds_slices: array[0..NUM_DRAWSEGS_SLICES - 1] of ds_slice_t;
  ds_range: integer;
  s2drawsegs: array[0..NUM_DRAWSEGS_SLICES2 - 1] of array[0..MAXDRAWSEGS - 1] of Pdrawseg_t;
  s2ds_p: array [0..NUM_DRAWSEGS_SLICES2 - 1] of integer;
  ds2_slices: array[0..NUM_DRAWSEGS_SLICES2 - 1] of ds_slice_t;
  ds2_range: integer;

procedure R_SetDrawSegToLists(const pds: Pdrawseg_t);
var
  i: integer;
begin
// Right screen list
  if pds.x2 >= centerx then
  begin
    rdrawsegs[rds_p] := pds;
    inc(rds_p);
  end;

// Left screen list
  if pds.x1 <= centerx then
  begin
    ldrawsegs[lds_p] := pds;
    inc(lds_p);
  end;

// Small lists
  for i := 0 to NUM_DRAWSEGS_SLICES - 1 do
  begin
    if pds.x1 <= ds_slices[i].finish then
      if pds.x2 >= ds_slices[i].start then
      begin
      // Found a small list
      // The pds drawseg is a part of small list
        sdrawsegs[i][sds_p[i]] := pds;
        inc(sds_p[i]);
      end;
  end;

  if ds2_range > 0 then
    for i := 0 to NUM_DRAWSEGS_SLICES2 - 1 do
    begin
      if pds.x1 <= ds2_slices[i].finish then
        if pds.x2 >= ds2_slices[i].start then
        begin
        // Found a small list
        // The pds drawseg is a part of small list
          s2drawsegs[i][s2ds_p[i]] := pds;
          inc(s2ds_p[i]);
        end;
    end;
end;

procedure R_SetUpDrawSegLists;
var
  i: integer;
begin
// Initialize the size of each drawseg list
  lds_p := 0;
  rds_p := 0;

// Create the ds_slices ranges
  for i := 0 to NUM_DRAWSEGS_SLICES - 1 do
    sds_p[i] := 0;
  ds_range := viewwidth div NUM_DRAWSEGS_SLICES;
  ds_slices[0].start := 0;
  for i := 1 to NUM_DRAWSEGS_SLICES - 1 do
    ds_slices[i].start := ds_range * i;
  for i := 0 to NUM_DRAWSEGS_SLICES - 2 do
    ds_slices[i].finish := ds_slices[i + 1].start - 1;
  ds_slices[NUM_DRAWSEGS_SLICES - 1].finish := viewwidth;

// Create the ds2_slices ranges
  if ds_p > MANY_DRAWSEGS then
  begin
    for i := 0 to NUM_DRAWSEGS_SLICES2 - 1 do
      s2ds_p[i] := 0;
    ds2_range := viewwidth div NUM_DRAWSEGS_SLICES2;
    ds2_slices[0].start := 0;
    for i := 1 to NUM_DRAWSEGS_SLICES2 - 1 do
      ds2_slices[i].start := ds2_range * i;
    for i := 0 to NUM_DRAWSEGS_SLICES2 - 2 do
      ds2_slices[i].finish := ds2_slices[i + 1].start - 1;
    ds2_slices[NUM_DRAWSEGS_SLICES2 - 1].finish := viewwidth;
  end
  else
    ds2_range := -1;

// Generate the drawseg lists
  for i := 0 to ds_p - 1 do
    R_SetDrawSegToLists(drawsegs[i]);
end;

procedure R_GetDrawsegsForVissprite(const fvis: Pvissprite_t; var fdrawsegs: Pdrawsegsbuffer_t; var fcnt: integer);
begin
  R_GetDrawsegsForRange(fvis.x1, fvis.x2, fdrawsegs, fcnt);
end;

procedure R_GetDrawsegsForRange(x1, x2: integer; var fdrawsegs: Pdrawsegsbuffer_t; var fcnt: integer);
var
  i: integer;
  tmp: integer;
begin
  if x2 < x1 then
  begin
    tmp := x2;
    x2 := x1;
    x1 := tmp;
  end;

  if x2 - x1 <= ds2_range then // Quickly decide the posibility of fiting in a small list
  begin
    for i := 0 to NUM_DRAWSEGS_SLICES2 - 1 do
    begin
      // Check if we have a hit in a small list
      if x1 >= ds2_slices[i].start then
        if x2 <= ds2_slices[i].finish then
        begin // Found a small list
          fdrawsegs := @s2drawsegs[i];
          fcnt := s2ds_p[i];
          exit;
        end;
    end;
  end;

  if x2 - x1 <= ds_range then // Quickly decide the posibility of fiting in a small list
  begin
    for i := 0 to NUM_DRAWSEGS_SLICES - 1 do
    begin
      // Check if we have a hit in a small list
      if x1 >= ds_slices[i].start then
        if x2 <= ds_slices[i].finish then
        begin // Found a small list
          fdrawsegs := @sdrawsegs[i];
          fcnt := sds_p[i];
          exit;
        end;
    end;
  end;

// Check if we can fit to the left of right list
  if x2 < centerx then
  begin
    fdrawsegs := @ldrawsegs;
    fcnt := lds_p;
    exit;
  end;
  if x1 > centerx then
  begin
    fdrawsegs := @rdrawsegs;
    fcnt := rds_p;
    exit;
  end;

// No fit, use the entire drawseg list :)
  fdrawsegs := @drawsegs;
  fcnt := ds_p;
end;

end.

