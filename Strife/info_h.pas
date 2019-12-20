//------------------------------------------------------------------------------
//
//  DelphiStrife: A modified and improved Strife source port for Windows.
//
//  Based on:
//    - Linux Doom by "id Software"
//    - Chocolate Strife by "Simon Howard"
//    - DelphiDoom by "Jim Valavanis"
//
//  Copyright (C) 1993-1996 by id Software, Inc.
//  Copyright (C) 2005 Simon Howard
//  Copyright (C) 2010 James Haley, Samuel Villarreal
//  Copyright (C) 2004-2019 by Jim Valavanis
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
//    Thing frame/state LUT.
//
//------------------------------------------------------------------------------
//  Site  : http://sourceforge.net/projects/delphidoom/
//------------------------------------------------------------------------------

{$I Doom32.inc}

unit info_h;

interface

uses
  d_delphi,
  d_think,
  r_renderstyle,
  sc_params;

type
  spritenum_t = (
    SPR_PLAY, // 0
    SPR_PNCH, // 1
    SPR_WAVE, // 2
    SPR_RBPY, // 3
    SPR_TRGT, // 4
    SPR_XBOW, // 5
    SPR_MMIS, // 6
    SPR_RIFG, // 7
    SPR_RIFF, // 8
    SPR_FLMT, // 9
    SPR_FLMF, // 10
    SPR_BLST, // 11
    SPR_BLSF, // 12
    SPR_GREN, // 13
    SPR_GREF, // 14
    SPR_SIGH, // 15
    SPR_SIGF, // 16
    SPR_POW1, // 17
    SPR_POW2, // 18
    SPR_POW3, // 19
    SPR_ZAP1, // 20
    SPR_SPRY, // 21
    SPR_BLOD, // 22
    SPR_PUFY, // 23
    SPR_SHT1, // 24
    SPR_SHT2, // 25
    SPR_GRIN, // 26
    SPR_GRAP, // 27
    SPR_UBAM, // 28
    SPR_BNG2, // 29
    SPR_BNG4, // 30
    SPR_BNG3, // 31
    SPR_FLBE, // 32
    SPR_XPRK, // 33
    SPR_OCLW, // 34
    SPR_CCLW, // 35
    SPR_TEND, // 36
    SPR_MICR, // 37
    SPR_MISS, // 38
    SPR_AROW, // 39
    SPR_ARWP, // 40
    SPR_TORP, // 41
    SPR_THIT, // 42
    SPR_TWAV, // 43
    SPR_MISL, // 44
    SPR_TFOG, // 45
    SPR_IFOG, // 46
    SPR_SHRD, // 47
    SPR_RGIB, // 48
    SPR_MRYS, // 49
    SPR_MRNO, // 50
    SPR_MRST, // 51
    SPR_MRLK, // 52
    SPR_MRBD, // 53
    SPR_MRPN, // 54
    SPR_MRGT, // 55
    SPR_BURN, // 56
    SPR_DISR, // 57
    SPR_PEAS, // 58
    SPR_GIBS, // 59
    SPR_AGRD, // 60
    SPR_ARMR, // 61
    SPR_SACR, // 62
    SPR_TNK1, // 63
    SPR_TNK2, // 64
    SPR_TNK3, // 65
    SPR_TNK4, // 66
    SPR_TNK5, // 67
    SPR_TNK6, // 68
    SPR_NEAL, // 69
    SPR_BEGR, // 70
    SPR_HMN1, // 71
    SPR_LEDR, // 72
    SPR_LEAD, // 73
    SPR_ROB1, // 74
    SPR_PGRD, // 75
    SPR_ROB2, // 76
    SPR_MLDR, // 77
    SPR_ORCL, // 78
    SPR_PRST, // 79
    SPR_PDED, // 80
    SPR_ALN1, // 81
    SPR_AL1P, // 82
    SPR_NODE, // 83
    SPR_MTHD, // 84
    SPR_MNAM, // 85
    SPR_MNAL, // 86
    SPR_MDTH, // 87
    SPR_NEST, // 88
    SPR_PODD, // 89
    SPR_ZAP6, // 90
    SPR_ZOT3, // 91
    SPR_ZAP7, // 92
    SPR_ZOT1, // 93
    SPR_ZAP5, // 94
    SPR_ZOT2, // 95
    SPR_SEWR, // 96
    SPR_SPID, // 97
    SPR_ROB3, // 98
    SPR_RBB3, // 99
    SPR_PRGR, // 100
    SPR_BASE, // 
    SPR_FRBL, // 
    SPR_KLAX, // 
    SPR_TURT, // 
    SPR_BALL, // 105
    SPR_PSTN, // 
    SPR_SECR, // 
    SPR_TARG, // 
    SPR_RING, // 
    SPR_EARS, // 110
    SPR_COMM, // 
    SPR_BOOM, // 
    SPR_RATT, // 
    SPR_HOGN, // 
    SPR_DEAD, // 115
    SPR_SBAN, // 
    SPR_BOTR, // 
    SPR_HATR, // 
    SPR_TOPR, // 
    SPR_COUP, // 120
    SPR_BUBB, // 
    SPR_BUBF, // 
    SPR_BUBC, // 
    SPR_ASPR, // 
    SPR_SPDL, // 125
    SPR_TOKN, // 
    SPR_OTOK, // 
    SPR_HELT, // 
    SPR_GUNT, // 
    SPR_FULL, // 130
    SPR_MEAT, // 
    SPR_JUNK, // 
    SPR_FFOT, // 
    SPR_DIE1, // 
    SPR_BEAC, // 135
    SPR_ARM1, // 
    SPR_ARM2, // 
    SPR_BARW, // 
    SPR_BART, // 
    SPR_LAMP, // 140
    SPR_LANT, // 
    SPR_BARL, // 
    SPR_BOWL, // 
    SPR_BRAZ, // 
    SPR_TRCH, // 145
    SPR_LTRH, // 
    SPR_LMPC, // 
    SPR_LOGS, // 
    SPR_TRHO, // 
    SPR_WATR, // 150
    SPR_MUGG, // 
    SPR_FUSL, // 
    SPR_CRD1, // 
    SPR_CRD2, // 
    SPR_TPAS, // 155
    SPR_KY1G, // 
    SPR_KY2S, // 
    SPR_KY3B, // 
    SPR_HAND, // 
    SPR_CRYS, // 160
    SPR_PRIS, // 
    SPR_PWR1, // 
    SPR_PWR2, // 
    SPR_PWR3, // 
    SPR_ORAC, // 165
    SPR_GYID, // 
    SPR_FUBR, // 
    SPR_WARE, // 
    SPR_RCRY, // 
    SPR_BCRY, // 170
    SPR_CHAP, // 
    SPR_TUNL, // 
    SPR_BLTK, // 
    SPR_SECK, // 
    SPR_MINE, // 175
    SPR_REBL, // 
    SPR_PROC, // 
    SPR_ANKH, // 
    SPR_GOID, // 
    SPR_STMP, // 180
    SPR_MDKT, // 
    SPR_COIN, // 
    SPR_CRED, // 
    SPR_SACK, // 
    SPR_CHST, // 185
    SPR_SHD1, // 
    SPR_MASK, // 
    SPR_UNIF, // 
    SPR_OFIC, // 
    SPR_PMAP, // 190
    SPR_PMUP, // 
    SPR_BLIT, // 
    SPR_BBOX, // 
    SPR_MSSL, // 
    SPR_ROKT, // 195
    SPR_BRY1, // 
    SPR_CPAC, // 
    SPR_PQRL, // 
    SPR_XQRL, // 
    SPR_GRN1, // 200
    SPR_GRN2, // 
    SPR_BKPK, // 
    SPR_RELC, // 
    SPR_RIFL, // 
    SPR_FLAM, // 205
    SPR_BFLM, // 
    SPR_MMSL, // 
    SPR_TRPD, // 
    SPR_GRND, // 
    SPR_CBOW, // 210
    SPR_SIGL, // 
    SPR_LITE, // 
    SPR_CNDL, // 
    SPR_CLBR, // 
    SPR_LITS, // 215
    SPR_LITB, // 
    SPR_LITG, // 
    SPR_ROK1, // 
    SPR_ROK2, // 
    SPR_ROK3, // 220
    SPR_ROK4, // 
    SPR_LOGG, // 
    SPR_RUB1, // 
    SPR_RUB2, // 
    SPR_RUB3, // 225
    SPR_RUB4, // 
    SPR_RUB5, // 
    SPR_RUB6, // 
    SPR_RUB7, // 
    SPR_RUB8, // 230
    SPR_CHAN, // 
    SPR_STAT, // 
    SPR_DSTA, // 
    SPR_CRAB, // 
    SPR_CAGE, // 235
    SPR_TREE, // 
    SPR_TRE1, // 
    SPR_BUSH, // 
    SPR_SHRB, // 
    SPR_STAK, // 240
    SPR_BAR1, // 
    SPR_VASE, // 
    SPR_STOL, // 
    SPR_POT1, // 
    SPR_TUB1, // 245
    SPR_ANVL, // 
    SPR_TLMP, // 
    SPR_TRAY, // 
    SPR_APOW, // 
    SPR_AFED, // 250
    SPR_DRIP, // 
    SPR_CDRP, // 
    SPR_SPLH, // 
    SPR_WTFT, // 
    SPR_HERT, // 
    SPR_TELP, // 
    SPR_MONI, // 
    SPR_STEL, // 
    SPR_STLA, // 
    SPR_STLE, // 260
    SPR_HUGE, // 261
    SPR_STLG, // 262

    // DelphiStrife specific
    SPR_SPSH, // Water Splash
    SPR_LVAS, // Lava Splash
    SPR_SLDG, // Sludge Splage
    SPR_SLDN, // Nukage Splash

    SPR_DD01, // Green Blood
    SPR_DD02, // Blue Blood

    SPR_TNT1,

    DO_NUMSPRITES
  );

  statenum_t = (
    S_NULL,     // 00
    S_PNCH_00,      // 01
    S_WAVE_00,      // 02
    S_WAVE_01,      // 03
    S_WAVE_02,      // 04
    S_WAVE_03,      // 05
    S_RBPY_00,      // 06
    S_RBPY_01,      // 07
    S_RBPY_02,      // 08
    S_RBPY_03,      // 09
    S_TRGT_00,      // 10
    S_TRGT_01,      // 11
    S_TRGT_02,      // 12
    S_PNCH_01,      // 13
    S_PNCH_02,      // 14
    S_PNCH_03,      // 15
    S_PNCH_04,      // 16
    S_PNCH_05,      // 17
    S_PNCH_06,      // 18
    S_PNCH_07,      // 19
    S_PNCH_08,      // 20
    S_XBOW_00,      // 21
    S_XBOW_01,      // 22
    S_XBOW_02,      // 23
    S_XBOW_03,      // 24
    S_XBOW_04,      // 25
    S_XBOW_05,      // 26
    S_XBOW_06,      // 27
    S_XBOW_07,      // 28
    S_XBOW_08,      // 29
    S_XBOW_09,      // 30
    S_XBOW_10,      // 31
    S_XBOW_11,      // 32
    S_XBOW_12,      // 33
    S_XBOW_13,      // 34
    S_XBOW_14,      // 35
    S_XBOW_15,      // 36
    S_XBOW_16,      // 37
    S_XBOW_17,      // 38
    S_XBOW_18,      // 39
    S_XBOW_19,      // 40
    S_XBOW_20,      // 41
    S_XBOW_21,      // 42
    S_XBOW_22,      // 43
    S_MMIS_00,      // 44
    S_MMIS_01,      // 45
    S_MMIS_02,      // 46
    S_MMIS_03,      // 47
    S_MMIS_04,      // 48
    S_MMIS_05,      // 49
    S_MMIS_06,      // 50
    S_MMIS_07,      // 51
    S_MMIS_08,      // 52
    S_MMIS_09,      // 53
    S_RIFG_00,      // 54
    S_RIFG_01,      // 55
    S_RIFG_02,      // 56
    S_RIFF_00,      // 57
    S_RIFF_01,      // 58
    S_RIFG_03,      // 59
    S_RIFG_04,      // 60
    S_RIFG_05,      // 61
    S_FLMT_00,      // 62
    S_FLMT_01,      // 63
    S_FLMT_02,      // 64
    S_FLMT_03,      // 65
    S_FLMF_00,      // 66
    S_FLMF_01,      // 67
    S_BLST_00,      // 68
    S_BLST_01,      // 69
    S_BLST_02,      // 70
    S_BLST_03,      // 71
    S_BLST_04,      // 72
    S_BLST_05,      // 73
    S_BLSF_00,      // 74
    S_BLST_06,      // 75
    S_BLST_07,      // 76
    S_BLST_08,      // 77
    S_BLST_09,      // 78
    S_BLST_10,      // 79
    S_BLST_11,      // 80
    S_BLST_12,      // 81
    S_BLST_13,      // 82
    S_BLST_14,      // 83
    S_BLST_15,      // 84
    S_BLST_16,      // 85
    S_BLST_17,      // 86
    S_BLST_18,      // 87
    S_BLST_19,      // 88
    S_BLST_20,      // 89
    S_BLSF_01,      // 90
    S_BLST_21,      // 91
    S_BLST_22,      // 92
    S_BLST_23,      // 93
    S_BLST_24,      // 94
    S_GREN_00,      // 95
    S_GREN_01,      // 96
    S_GREN_02,      // 97
    S_GREN_03,      // 98
    S_GREN_04,      // 99
    S_GREN_05,      // 100
    S_GREN_06,      // 101
    S_GREN_07,      // 102
    S_GREF_00,      // 103
    S_GREF_01,      // 104
    S_GREF_02,      // 105
    S_GREN_08,      // 106
    S_GREN_09,      // 107
    S_GREN_10,      // 108
    S_GREN_11,      // 109
    S_GREN_12,      // 110
    S_GREN_13,      // 111
    S_GREN_14,      // 112
    S_GREN_15,      // 113
    S_GREF_03,      // 114
    S_GREF_04,      // 115
    S_GREF_05,      // 116
    S_SIGH_00,      // 117
    S_SIGH_01,      // 118
    S_SIGH_02,      // 119
    S_SIGH_03,      // 120
    S_SIGH_04,      // 121
    S_SIGH_05,      // 122
    S_SIGH_06,      // 123
    S_SIGH_07,      // 124
    S_SIGH_08,      // 125
    S_SIGH_09,      // 126
    S_SIGH_10,      // 127
    S_SIGF_00,      // 128
    S_SIGF_01,      // 129
    S_SIGF_02,      // 130
    S_POW1_00,      // 131
    S_POW1_01,      // 132
    S_POW1_02,      // 133
    S_POW1_03,      // 134
    S_POW1_04,      // 135
    S_POW1_05,      // 136
    S_POW1_06,      // 137
    S_POW1_07,      // 138
    S_POW1_08,      // 139
    S_POW1_09,      // 140
    S_POW2_00,      // 141
    S_POW2_01,      // 142
    S_POW2_02,      // 143
    S_POW2_03,      // 144
    S_POW3_00,      // 145
    S_POW3_01,      // 146
    S_POW3_02,      // 147
    S_POW3_03,      // 148
    S_POW3_04,      // 149
    S_POW3_05,      // 150
    S_POW3_06,      // 151
    S_POW3_07,      // 152
    S_ZAP1_00,      // 153
    S_ZAP1_01,      // 154
    S_ZAP1_02,      // 155
    S_ZAP1_03,      // 156
    S_ZAP1_04,      // 157
    S_ZAP1_05,      // 158
    S_ZAP1_06,      // 159
    S_ZAP1_07,      // 160
    S_ZAP1_08,      // 161
    S_ZAP1_09,      // 162
    S_ZAP1_10,      // 163
    S_ZAP1_11,      // 164
    S_SPRY_00,      // 165
    S_SPRY_01,      // 166
    S_SPRY_02,      // 167
    S_SPRY_03,      // 168
    S_SPRY_04,      // 169
    S_SPRY_05,      // 170
    S_SPRY_06,      // 171
    S_BLOD_00,      // 172
    S_BLOD_01,      // 173
    S_BLOD_02,      // 174
    S_PUFY_00,      // 175
    S_PUFY_01,      // 176
    S_PUFY_02,      // 177
    S_PUFY_03,      // 178
    S_SHT1_00,      // 179
    S_SHT1_01,      // 180
    S_SHT2_00,      // 181
    S_SHT2_01,      // 182
    S_GRIN_00,      // 183
    S_GRIN_01,      // 184
    S_GRAP_00,      // 185
    S_GRAP_01,      // 186
    S_UBAM_00,      // 187
    S_UBAM_01,      // 188
    S_BNG2_00,      // 189
    S_BNG2_01,      // 190
    S_BNG2_02,      // 191
    S_BNG2_03,      // 192
    S_BNG2_04,      // 193
    S_BNG2_05,      // 194
    S_BNG2_06,      // 195
    S_BNG2_07,      // 196
    S_BNG2_08,      // 197
    S_BNG4_00,      // 198
    S_BNG4_01,      // 199
    S_BNG4_02,      // 200
    S_BNG4_03,      // 201
    S_BNG4_04,      // 202
    S_BNG4_05,      // 203
    S_BNG4_06,      // 204
    S_BNG4_07,      // 205
    S_BNG4_08,      // 206
    S_BNG4_09,      // 207
    S_BNG4_10,      // 208
    S_BNG4_11,      // 209
    S_BNG4_12,      // 210
    S_BNG4_13,      // 211
    S_BNG3_00,      // 212
    S_BNG3_01,      // 213
    S_BNG3_02,      // 214
    S_BNG3_03,      // 215
    S_BNG3_04,      // 216
    S_BNG3_05,      // 217
    S_BNG3_06,      // 218
    S_BNG3_07,      // 219
    S_BNG3_08,      // 220
    S_BNG3_09,      // 221
    S_BNG3_10,      // 222
    S_FLBE_00,      // 223
    S_FLBE_01,      // 224
    S_FLBE_02,      // 225
    S_FLBE_03,      // 226
    S_FLBE_04,      // 227
    S_FLBE_05,      // 228
    S_FLBE_06,      // 229
    S_FLBE_07,      // 230
    S_FLBE_08,      // 231
    S_FLBE_09,      // 232
    S_FLBE_10,      // 233
    S_XPRK_00,      // 234
    S_OCLW_00,      // 235
    S_CCLW_00,      // 236
    S_TEND_00,      // 237
    S_MICR_00,      // 238
    S_MISS_00,      // 239
    S_MISS_01,      // 240
    S_AROW_00,      // 241
    S_ARWP_00,      // 242
    S_AROW_01,      // 243
    S_TORP_00,      // 244
    S_TORP_01,      // 245
    S_TORP_02,      // 246
    S_TORP_03,      // 247
    S_THIT_00,      // 248
    S_THIT_01,      // 249
    S_THIT_02,      // 250
    S_THIT_03,      // 251
    S_THIT_04,      // 252
    S_TWAV_00,      // 253
    S_TWAV_01,      // 254
    S_TWAV_02,      // 255
    S_MISL_00,      // 256
    S_MISL_01,      // 257
    S_MISL_02,      // 258
    S_MISL_03,      // 259
    S_MISL_04,      // 260
    S_MISL_05,      // 261
    S_MISL_06,      // 262
    S_MISL_07,      // 263
    S_TFOG_00,      // 264
    S_TFOG_01,      // 265
    S_TFOG_02,      // 266
    S_TFOG_03,      // 267
    S_TFOG_04,      // 268
    S_TFOG_05,      // 269
    S_TFOG_06,      // 270
    S_TFOG_07,      // 271
    S_TFOG_08,      // 272
    S_TFOG_09,      // 273
    S_IFOG_00,      // 274
    S_IFOG_01,      // 275
    S_IFOG_02,      // 276
    S_IFOG_03,      // 277
    S_IFOG_04,      // 278
    S_IFOG_05,      // 279
    S_IFOG_06,      // 280
    S_SHRD_00,      // 281
    S_SHRD_01,      // 282
    S_SHRD_02,      // 283
    S_SHRD_03,      // 284
    S_SHRD_04,      // 285
    S_SHRD_05,      // 286
    S_PLAY_00,      // 287
    S_PLAY_01,      // 288
    S_PLAY_02,      // 289
    S_PLAY_03,      // 290
    S_PLAY_04,      // 291
    S_PLAY_05,      // 292
    S_PLAY_06,      // 293
    S_PLAY_07,      // 294
    S_PLAY_08,      // 295
    S_PLAY_09,      // 296
    S_PLAY_10,      // 297
    S_PLAY_11,      // 298
    S_PLAY_12,      // 299
    S_PLAY_13,      // 300
    S_PLAY_14,      // 301
    S_PLAY_15,      // 302
    S_PLAY_16,      // 303
    S_PLAY_17,      // 304
    S_PLAY_18,      // 305
    S_RGIB_00,      // 306
    S_RGIB_01,      // 307
    S_RGIB_02,      // 308
    S_RGIB_03,      // 309
    S_RGIB_04,      // 310
    S_RGIB_05,      // 311
    S_RGIB_06,      // 312
    S_RGIB_07,      // 313
    S_MRYS_00,      // 314
    S_MRNO_00,      // 315
    S_MRNO_01,      // 316
    S_MRNO_02,      // 317
    S_MRNO_03,      // 318
    S_MRNO_04,      // 319
    S_MRST_00,      // 320
    S_MRLK_00,      // 321
    S_MRLK_01,      // 322
    S_MRBD_00,      // 323
    S_MRBD_01,      // 324
    S_MRBD_02,      // 325
    S_MRBD_03,      // 326
    S_MRBD_04,      // 327
    S_MRBD_05,      // 328
    S_MRBD_06,      // 329
    S_MRBD_07,      // 330
    S_MRBD_08,      // 331
    S_MRBD_09,      // 332
    S_MRPN_00,      // 333
    S_MRPN_01,      // 334
    S_MRPN_02,      // 335
    S_MRPN_03,      // 336
    S_MRPN_04,      // 337
    S_MRPN_05,      // 338
    S_MRPN_06,      // 339
    S_MRGT_00,      // 340
    S_MRGT_01,      // 341
    S_MRGT_02,      // 342
    S_MRGT_03,      // 343
    S_MRGT_04,      // 344
    S_MRGT_05,      // 345
    S_MRGT_06,      // 346
    S_MRGT_07,      // 347
    S_MRGT_08,      // 348
    S_BURN_00,      // 349
    S_BURN_01,      // 350
    S_BURN_02,      // 351
    S_BURN_03,      // 352
    S_BURN_04,      // 353
    S_BURN_05,      // 354
    S_BURN_06,      // 355
    S_BURN_07,      // 356
    S_BURN_08,      // 357
    S_BURN_09,      // 358
    S_BURN_10,      // 359
    S_BURN_11,      // 360
    S_BURN_12,      // 361
    S_BURN_13,      // 362
    S_BURN_14,      // 363
    S_BURN_15,      // 364
    S_BURN_16,      // 365
    S_BURN_17,      // 366
    S_BURN_18,      // 367
    S_BURN_19,      // 368
    S_BURN_20,      // 369
    S_BURN_21,      // 370
    S_BURN_22,      // 371
    S_BURN_23,      // 372
    S_DISR_00,      // 373
    S_DISR_01,      // 374
    S_DISR_02,      // 375
    S_DISR_03,      // 376
    S_DISR_04,      // 377
    S_DISR_05,      // 378
    S_DISR_06,      // 379
    S_DISR_07,      // 380
    S_DISR_08,      // 381
    S_DISR_09,      // 382
    S_PEAS_00,      // 383
    S_PEAS_01,      // 384
    S_PEAS_02,      // 385
    S_PEAS_03,      // 386
    S_PEAS_04,      // 387
    S_PEAS_05,      // 388
    S_PEAS_06,      // 389
    S_PEAS_07,      // 390
    S_PEAS_08,      // 391
    S_PEAS_09,      // 392
    S_PEAS_10,      // 393
    S_PEAS_11,      // 394
    S_PEAS_12,      // 395
    S_PEAS_13,      // 396
    S_PEAS_14,      // 397
    S_PEAS_15,      // 398
    S_PEAS_16,      // 399
    S_PEAS_17,      // 400
    S_PEAS_18,      // 401
    S_PEAS_19,      // 402
    S_PEAS_20,      // 403
    S_PEAS_21,      // 404
    S_PEAS_22,      // 405
    S_PEAS_23,      // 406
    S_PEAS_24,      // 407
    S_GIBS_00,      // 408
    S_GIBS_01,      // 409
    S_GIBS_02,      // 410
    S_GIBS_03,      // 411
    S_GIBS_04,      // 412
    S_GIBS_05,      // 413
    S_GIBS_06,      // 414
    S_GIBS_07,      // 415
    S_GIBS_08,      // 416
    S_GIBS_09,      // 417
    S_PEAS_25,      // 418
    S_AGRD_00,      // 419
    S_ARMR_00,      // 420
    S_ARMR_01,      // 421
    S_PLAY_19,      // 422
    S_SACR_00,      // 423
    S_TNK1_00,      // 424
    S_TNK1_01,      // 425
    S_TNK1_02,      // 426
    S_TNK2_00,      // 427
    S_TNK2_01,      // 428
    S_TNK2_02,      // 429
    S_TNK3_00,      // 430
    S_TNK3_01,      // 431
    S_TNK3_02,      // 432
    S_TNK4_00,      // 433
    S_TNK4_01,      // 434
    S_TNK4_02,      // 435
    S_TNK5_00,      // 436
    S_TNK5_01,      // 437
    S_TNK5_02,      // 438
    S_TNK6_00,      // 439
    S_TNK6_01,      // 440
    S_TNK6_02,      // 441
    S_NEAL_00,      // 442
    S_NEAL_01,      // 443
    S_NEAL_02,      // 444
    S_NEAL_03,      // 445
    S_NEAL_04,      // 446
    S_NEAL_05,      // 447
    S_NEAL_06,      // 448
    S_NEAL_07,      // 449
    S_NEAL_08,      // 450
    S_NEAL_09,      // 451
    S_NEAL_10,      // 452
    S_NEAL_11,      // 453
    S_NEAL_12,      // 454
    S_NEAL_13,      // 455
    S_BEGR_00,      // 456
    S_BEGR_01,      // 457
    S_BEGR_02,      // 458
    S_BEGR_03,      // 459
    S_BEGR_04,      // 460
    S_BEGR_05,      // 461
    S_BEGR_06,      // 462
    S_BEGR_07,      // 463
    S_BEGR_08,      // 464
    S_BEGR_09,      // 465
    S_BEGR_10,      // 466
    S_BEGR_11,      // 467
    S_BEGR_12,      // 468
    S_BEGR_13,      // 469
    S_BEGR_14,      // 470
    S_BEGR_15,      // 471
    S_BEGR_16,      // 472
    S_BEGR_17,      // 473
    S_BEGR_18,      // 474
    S_BEGR_19,      // 475
    S_BEGR_20,      // 476
    S_BEGR_21,      // 477
    S_BEGR_22,      // 478
    S_HMN1_00,      // 479
    S_HMN1_01,      // 480
    S_HMN1_02,      // 481
    S_HMN1_03,      // 482
    S_HMN1_04,      // 483
    S_HMN1_05,      // 484
    S_HMN1_06,      // 485
    S_HMN1_07,      // 486
    S_HMN1_08,      // 487
    S_HMN1_09,      // 488
    S_HMN1_10,      // 489
    S_HMN1_11,      // 490
    S_HMN1_12,      // 491
    S_HMN1_13,      // 492
    S_HMN1_14,      // 493
    S_HMN1_15,      // 494
    S_HMN1_16,      // 495
    S_HMN1_17,      // 496
    S_HMN1_18,      // 497
    S_HMN1_19,      // 498
    S_HMN1_20,      // 499
    S_HMN1_21,      // 500
    S_HMN1_22,      // 501
    S_HMN1_23,      // 502
    S_HMN1_24,      // 503
    S_HMN1_25,      // 504
    S_HMN1_26,      // 505
    S_HMN1_27,      // 506
    S_HMN1_28,      // 507
    S_HMN1_29,      // 508
    S_HMN1_30,      // 509
    S_HMN1_31,      // 510
    S_RGIB_08,      // 511
    S_RGIB_09,      // 512
    S_RGIB_10,      // 513
    S_RGIB_11,      // 514
    S_RGIB_12,      // 515
    S_RGIB_13,      // 516
    S_RGIB_14,      // 517
    S_RGIB_15,      // 518
    S_LEDR_00,      // 519
    S_LEDR_01,      // 520
    S_LEDR_02,      // 521
    S_LEAD_00,      // 522
    S_LEAD_01,      // 523
    S_LEAD_02,      // 524
    S_LEAD_03,      // 525
    S_LEAD_04,      // 526
    S_LEAD_05,      // 527
    S_LEAD_06,      // 528
    S_LEAD_07,      // 529
    S_LEAD_08,      // 530
    S_LEAD_09,      // 531
    S_LEAD_10,      // 532
    S_LEAD_11,      // 533
    S_LEAD_12,      // 534
    S_LEAD_13,      // 535
    S_LEAD_14,      // 536
    S_LEAD_15,      // 537
    S_LEAD_16,      // 538
    S_LEAD_17,      // 539
    S_LEAD_18,      // 540
    S_LEAD_19,      // 541
    S_LEAD_20,      // 542
    S_LEAD_21,      // 543
    S_LEAD_22,      // 544
    S_LEAD_23,      // 545
    S_LEAD_24,      // 546
    S_LEAD_25,      // 547
    S_LEAD_26,      // 548
    S_LEAD_27,      // 549
    S_LEAD_28,      // 550
    S_LEAD_29,      // 551
    S_LEAD_30,      // 552
    S_LEAD_31,      // 553
    S_LEAD_32,      // 554
    S_LEAD_33,      // 555
    S_LEAD_34,      // 556
    S_LEAD_35,      // 557
    S_LEAD_36,      // 558
    S_LEAD_37,      // 559
    S_PUFY_04,      // 560
    S_PUFY_05,      // 561
    S_PUFY_06,      // 562
    S_PUFY_07,      // 563
    S_PUFY_08,      // 564
    S_MICR_01,      // 565
    S_MICR_02,      // 566
    S_ROB1_00,      // 567
    S_ROB1_01,      // 568
    S_ROB1_02,      // 569
    S_ROB1_03,      // 570
    S_ROB1_04,      // 571
    S_ROB1_05,      // 572
    S_ROB1_06,      // 573
    S_ROB1_07,      // 574
    S_ROB1_08,      // 575
    S_ROB1_09,      // 576
    S_ROB1_10,      // 577
    S_ROB1_11,      // 578
    S_ROB1_12,      // 579
    S_ROB1_13,      // 580
    S_ROB1_14,      // 581
    S_ROB1_15,      // 582
    S_ROB1_16,      // 583
    S_ROB1_17,      // 584
    S_ROB1_18,      // 585
    S_ROB1_19,      // 586
    S_ROB1_20,      // 587
    S_ROB1_21,      // 588
    S_ROB1_22,      // 589
    S_ROB1_23,      // 590
    S_ROB1_24,      // 591
    S_ROB1_25,      // 592
    S_ROB1_26,      // 593
    S_ROB1_27,      // 594
    S_ROB1_28,      // 595
    S_ROB1_29,      // 596
    S_ROB1_30,      // 597
    S_ROB1_31,      // 598
    S_ROB1_32,      // 599
    S_AGRD_01,      // 600
    S_AGRD_02,      // 601
    S_AGRD_03,      // 602
    S_AGRD_04,      // 603
    S_AGRD_05,      // 604
    S_AGRD_06,      // 605
    S_AGRD_07,      // 606
    S_AGRD_08,      // 607
    S_AGRD_09,      // 608
    S_AGRD_10,      // 609
    S_AGRD_11,      // 610
    S_AGRD_12,      // 611
    S_AGRD_13,      // 612
    S_AGRD_14,      // 613
    S_AGRD_15,      // 614
    S_AGRD_16,      // 615
    S_AGRD_17,      // 616
    S_AGRD_18,      // 617
    S_AGRD_19,      // 618
    S_AGRD_20,      // 619
    S_AGRD_21,      // 620
    S_AGRD_22,      // 621
    S_AGRD_23,      // 622
    S_AGRD_24,      // 623
    S_AGRD_25,      // 624
    S_AGRD_26,      // 625
    S_AGRD_27,      // 626
    S_AGRD_28,      // 627
    S_AGRD_29,      // 628
    S_AGRD_30,      // 629
    S_AGRD_31,      // 630
    S_GIBS_10,      // 631
    S_GIBS_11,      // 632
    S_GIBS_12,      // 633
    S_GIBS_13,      // 634
    S_GIBS_14,      // 635
    S_GIBS_15,      // 636
    S_GIBS_16,      // 637
    S_GIBS_17,      // 638
    S_GIBS_18,      // 639
    S_GIBS_19,      // 640
    S_GIBS_20,      // 641
    S_GIBS_21,      // 642
    S_PGRD_00,      // 643
    S_PGRD_01,      // 644
    S_PGRD_02,      // 645
    S_PGRD_03,      // 646
    S_PGRD_04,      // 647
    S_PGRD_05,      // 648
    S_PGRD_06,      // 649
    S_PGRD_07,      // 650
    S_PGRD_08,      // 651
    S_PGRD_09,      // 652
    S_PGRD_10,      // 653
    S_PGRD_11,      // 654
    S_PGRD_12,      // 655
    S_PGRD_13,      // 656
    S_PGRD_14,      // 657
    S_PGRD_15,      // 658
    S_PGRD_16,      // 659
    S_PGRD_17,      // 660
    S_PGRD_18,      // 661
    S_PGRD_19,      // 662
    S_PGRD_20,      // 663
    S_PGRD_21,      // 664
    S_PGRD_22,      // 665
    S_PGRD_23,      // 666
    S_PGRD_24,      // 667
    S_PGRD_25,      // 668
    S_PGRD_26,      // 669
    S_PGRD_27,      // 670
    S_PGRD_28,      // 671
    S_PGRD_29,      // 672
    S_PGRD_30,      // 673
    S_PGRD_31,      // 674
    S_PGRD_32,      // 675
    S_PGRD_33,      // 676
    S_PGRD_34,      // 677
    S_PGRD_35,      // 678
    S_PGRD_36,      // 679
    S_PGRD_37,      // 680
    S_ROB2_00,      // 681
    S_ROB2_01,      // 682
    S_ROB2_02,      // 683
    S_ROB2_03,      // 684
    S_ROB2_04,      // 685
    S_ROB2_05,      // 686
    S_ROB2_06,      // 687
    S_ROB2_07,      // 688
    S_ROB2_08,      // 689
    S_ROB2_09,      // 690
    S_ROB2_10,      // 691
    S_ROB2_11,      // 692
    S_ROB2_12,      // 693
    S_ROB2_13,      // 694
    S_ROB2_14,      // 695
    S_ROB2_15,      // 696
    S_ROB2_16,      // 697
    S_ROB2_17,      // 698
    S_ROB2_18,      // 699
    S_ROB2_19,      // 700
    S_ROB2_20,      // 701
    S_ROB2_21,      // 702
    S_ROB2_22,      // 703
    S_ROB2_23,      // 704
    S_ROB2_24,      // 705
    S_ROB2_25,      // 706
    S_ROB2_26,      // 707
    S_ROB2_27,      // 708
    S_ROB2_28,      // 709
    S_ROB2_29,      // 710
    S_MLDR_00,      // 711
    S_MLDR_01,      // 712
    S_MLDR_02,      // 713
    S_MLDR_03,      // 714
    S_MLDR_04,      // 715
    S_MLDR_05,      // 716
    S_MLDR_06,      // 717
    S_MLDR_07,      // 718
    S_MLDR_08,      // 719
    S_MLDR_09,      // 720
    S_MLDR_10,      // 721
    S_MLDR_11,      // 722
    S_MLDR_12,      // 723
    S_MLDR_13,      // 724
    S_MLDR_14,      // 725
    S_MLDR_15,      // 726
    S_MLDR_16,      // 727
    S_MLDR_17,      // 728
    S_MLDR_18,      // 729
    S_MLDR_19,      // 730
    S_MLDR_20,      // 731
    S_MLDR_21,      // 732
    S_MLDR_22,      // 733
    S_MLDR_23,      // 734
    S_MLDR_24,      // 735
    S_MLDR_25,      // 736
    S_MLDR_26,      // 737
    S_MLDR_27,      // 738
    S_ORCL_00,      // 739
    S_ORCL_01,      // 740
    S_ORCL_02,      // 741
    S_ORCL_03,      // 742
    S_ORCL_04,      // 743
    S_ORCL_05,      // 744
    S_ORCL_06,      // 745
    S_ORCL_07,      // 746
    S_ORCL_08,      // 747
    S_ORCL_09,      // 748
    S_ORCL_10,      // 749
    S_ORCL_11,      // 750
    S_ORCL_12,      // 751
    S_ORCL_13,      // 752
    S_ORCL_14,      // 753
    S_ORCL_15,      // 754
    S_ORCL_16,      // 755
    S_PRST_00,      // 756
    S_PRST_01,      // 757
    S_PRST_02,      // 758
    S_PRST_03,      // 759
    S_PRST_04,      // 760
    S_PRST_05,      // 761
    S_PRST_06,      // 762
    S_PRST_07,      // 763
    S_PRST_08,      // 764
    S_PRST_09,      // 765
    S_PRST_10,      // 766
    S_PRST_11,      // 767
    S_PRST_12,      // 768
    S_PRST_13,      // 769
    S_PRST_14,      // 770
    S_PRST_15,      // 771
    S_PDED_00,      // 772
    S_PDED_01,      // 773
    S_PDED_02,      // 774
    S_PDED_03,      // 775
    S_PDED_04,      // 776
    S_PDED_05,      // 777
    S_PDED_06,      // 778
    S_PDED_07,      // 779
    S_PDED_08,      // 780
    S_PDED_09,      // 781
    S_PDED_10,      // 782
    S_PDED_11,      // 783
    S_PDED_12,      // 784
    S_PDED_13,      // 785
    S_PDED_14,      // 786
    S_PDED_15,      // 787
    S_PDED_16,      // 788
    S_PDED_17,      // 789
    S_PDED_18,      // 790
    S_PDED_19,      // 791
    S_PDED_20,      // 792
    S_PDED_21,      // 793
    S_PDED_22,      // 794
    S_PDED_23,      // 795
    S_ALN1_00,      // 796
    S_ALN1_01,      // 797
    S_ALN1_02,      // 798
    S_ALN1_03,      // 799
    S_ALN1_04,      // 800
    S_ALN1_05,      // 801
    S_ALN1_06,      // 802
    S_ALN1_07,      // 803
    S_ALN1_08,      // 804
    S_ALN1_09,      // 805
    S_ALN1_10,      // 806
    S_ALN1_11,      // 807
    S_ALN1_12,      // 808
    S_ALN1_13,      // 809
    S_ALN1_14,      // 810
    S_ALN1_15,      // 811
    S_ALN1_16,      // 812
    S_ALN1_17,      // 813
    S_ALN1_18,      // 814
    S_ALN1_19,      // 815
    S_AL1P_00,      // 816
    S_AL1P_01,      // 817
    S_AL1P_02,      // 818
    S_AL1P_03,      // 819
    S_AL1P_04,      // 820
    S_AL1P_05,      // 821
    S_AL1P_06,      // 822
    S_AL1P_07,      // 823
    S_AL1P_08,      // 824
    S_AL1P_09,      // 825
    S_AL1P_10,      // 826
    S_AL1P_11,      // 827
    S_AL1P_12,      // 828
    S_AL1P_13,      // 829
    S_AL1P_14,      // 830
    S_AL1P_15,      // 831
    S_AL1P_16,      // 832
    S_AL1P_17,      // 833
    S_NODE_00,      // 834
    S_NODE_01,      // 835
    S_NODE_02,      // 836
    S_NODE_03,      // 837
    S_NODE_04,      // 838
    S_NODE_05,      // 839
    S_NODE_06,      // 840
    S_MTHD_00,      // 841
    S_MTHD_01,      // 842
    S_MTHD_02,      // 843
    S_MTHD_03,      // 844
    S_MTHD_04,      // 845
    S_MTHD_05,      // 846
    S_MTHD_06,      // 847
    S_MTHD_07,      // 848
    S_MTHD_08,      // 849
    S_MTHD_09,      // 850
    S_MTHD_10,      // 851
    S_ALN1_20,      // 852
    S_ALN1_21,      // 853
    S_ALN1_22,      // 854
    S_ALN1_23,      // 855
    S_ALN1_24,      // 856
    S_ALN1_25,      // 857
    S_ALN1_26,      // 858
    S_ALN1_27,      // 859
    S_ALN1_28,      // 860
    S_ALN1_29,      // 861
    S_ALN1_30,      // 862
    S_ALN1_31,      // 863
    S_ALN1_32,      // 864
    S_ALN1_33,      // 865
    S_ALN1_34,      // 866
    S_ALN1_35,      // 867
    S_ALN1_36,      // 868
    S_ALN1_37,      // 869
    S_ALN1_38,      // 870
    S_ALN1_39,      // 871
    S_ALN1_40,      // 872
    S_ALN1_41,      // 873
    S_ALN1_42,      // 874
    S_ALN1_43,      // 875
    S_ALN1_44,      // 876
    S_ALN1_45,      // 877
    S_ALN1_46,      // 878
    S_ALN1_47,      // 879
    S_ALN1_48,      // 880
    S_ALN1_49,      // 881
    S_ALN1_50,      // 882
    S_ALN1_51,      // 883
    S_ALN1_52,      // 884
    S_ALN1_53,      // 885
    S_ALN1_54,      // 886
    S_ALN1_55,      // 887
    S_ALN1_56,      // 888
    S_ALN1_57,      // 889
    S_MNAM_00,      // 890
    S_MNAM_01,      // 891
    S_MNAM_02,      // 892
    S_MNAM_03,      // 893
    S_MNAM_04,      // 894
    S_MNAM_05,      // 895
    S_MNAM_06,      // 896
    S_MNAM_07,      // 897
    S_MNAM_08,      // 898
    S_MNAM_09,      // 899
    S_MNAM_10,      // 900
    S_MNAM_11,      // 901
    S_MNAL_00,      // 902
    S_MNAL_01,      // 903
    S_MNAL_02,      // 904
    S_MNAL_03,      // 905
    S_MNAL_04,      // 906
    S_MNAL_05,      // 907
    S_MNAL_06,      // 908
    S_MNAL_07,      // 909
    S_MNAL_08,      // 910
    S_MNAL_09,      // 911
    S_MNAL_10,      // 912
    S_MNAL_11,      // 913
    S_MNAL_12,      // 914
    S_MNAL_13,      // 915
    S_MNAL_14,      // 916
    S_MNAL_15,      // 917
    S_MNAL_16,      // 918
    S_MNAL_17,      // 919
    S_MNAL_18,      // 920
    S_MNAL_19,      // 921
    S_MNAL_20,      // 922
    S_MNAL_21,      // 923
    S_MNAL_22,      // 924
    S_MNAL_23,      // 925
    S_MNAL_24,      // 926
    S_MNAL_25,      // 927
    S_MNAL_26,      // 928
    S_MNAL_27,      // 929
    S_MNAL_28,      // 930
    S_MNAL_29,      // 931
    S_MNAL_30,      // 932
    S_MNAL_31,      // 933
    S_MNAL_32,      // 934
    S_MNAL_33,      // 935
    S_MNAL_34,      // 936
    S_MNAL_35,      // 937
    S_MNAL_36,      // 938
    S_MNAL_37,      // 939
    S_MNAL_38,      // 940
    S_MNAL_39,      // 941
    S_MNAL_40,      // 942
    S_MDTH_00,      // 943
    S_MDTH_01,      // 944
    S_MDTH_02,      // 945
    S_MDTH_03,      // 946
    S_MDTH_04,      // 947
    S_MDTH_05,      // 948
    S_MDTH_06,      // 949
    S_MDTH_07,      // 950
    S_MDTH_08,      // 951
    S_MDTH_09,      // 952
    S_MDTH_10,      // 953
    S_MDTH_11,      // 954
    S_MDTH_12,      // 955
    S_MDTH_13,      // 956
    S_MDTH_14,      // 957
    S_NEST_00,      // 958
    S_PODD_00,      // 959
    S_PODD_01,      // 960
    S_PODD_02,      // 961
    S_PODD_03,      // 962
    S_PODD_04,      // 963
    S_PODD_05,      // 964
    S_ZAP6_00,      // 965
    S_ZAP6_01,      // 966
    S_ZAP6_02,      // 967
    S_ZOT3_00,      // 968
    S_ZOT3_01,      // 969
    S_ZOT3_02,      // 970
    S_ZOT3_03,      // 971
    S_ZOT3_04,      // 972
    S_ZAP6_03,      // 973
    S_ZAP6_04,      // 974
    S_ZAP6_05,      // 975
    S_ZAP7_00,      // 976
    S_ZAP7_01,      // 977
    S_ZAP7_02,      // 978
    S_ZAP7_03,      // 979
    S_ZAP7_04,      // 980
    S_ZOT1_00,      // 981
    S_ZOT1_01,      // 982
    S_ZOT1_02,      // 983
    S_ZOT1_03,      // 984
    S_ZOT1_04,      // 985
    S_ZAP5_00,      // 986
    S_ZAP5_01,      // 987
    S_ZAP5_02,      // 988
    S_ZAP5_03,      // 989
    S_ZOT2_00,      // 990
    S_ZOT2_01,      // 991
    S_ZOT2_02,      // 992
    S_ZOT2_03,      // 993
    S_ZOT2_04,      // 994
    S_SEWR_00,      // 995
    S_SEWR_01,      // 996
    S_SEWR_02,      // 997
    S_SEWR_03,      // 998
    S_SEWR_04,      // 999
    S_SEWR_05,      // 1000
    S_SEWR_06,      // 1001
    S_SEWR_07,      // 1002
    S_SEWR_08,      // 1003
    S_SEWR_09,      // 1004
    S_SEWR_10,      // 1005
    S_SEWR_11,      // 1006
    S_SEWR_12,      // 1007
    S_SEWR_13,      // 1008
    S_SPID_00,      // 1009
    S_SPID_01,      // 1010
    S_SPID_02,      // 1011
    S_SPID_03,      // 1012
    S_SPID_04,      // 1013
    S_SPID_05,      // 1014
    S_SPID_06,      // 1015
    S_SPID_07,      // 1016
    S_SPID_08,      // 1017
    S_SPID_09,      // 1018
    S_SPID_10,      // 1019
    S_SPID_11,      // 1020
    S_SPID_12,      // 1021
    S_SPID_13,      // 1022
    S_SPID_14,      // 1023
    S_SPID_15,      // 1024
    S_SPID_16,      // 1025
    S_SPID_17,      // 1026
    S_SPID_18,      // 1027
    S_SPID_19,      // 1028
    S_SPID_20,      // 1029
    S_SPID_21,      // 1030
    S_SPID_22,      // 1031
    S_SPID_23,      // 1032
    S_SPID_24,      // 1033
    S_SPID_25,      // 1034
    S_SPID_26,      // 1035
    S_SPID_27,      // 1036
    S_SPID_28,      // 1037
    S_SPID_29,      // 1038
    S_SPID_30,      // 1039
    S_SPID_31,      // 1040
    S_SPID_32,      // 1041
    S_SPID_33,      // 1042
    S_SPID_34,      // 1043
    S_SPID_35,      // 1044
    S_SPID_36,      // 1045
    S_SPID_37,      // 1046
    S_ROB3_00,      // 1047
    S_ROB3_01,      // 1048
    S_ROB3_02,      // 1049
    S_ROB3_03,      // 1050
    S_ROB3_04,      // 1051
    S_ROB3_05,      // 1052
    S_ROB3_06,      // 1053
    S_ROB3_07,      // 1054
    S_ROB3_08,      // 1055
    S_ROB3_09,      // 1056
    S_ROB3_10,      // 1057
    S_ROB3_11,      // 1058
    S_ROB3_12,      // 1059
    S_ROB3_13,      // 1060
    S_ROB3_14,      // 1061
    S_ROB3_15,      // 1062
    S_ROB3_16,      // 1063
    S_ROB3_17,      // 1064
    S_ROB3_18,      // 1065
    S_ROB3_19,      // 1066
    S_ROB3_20,      // 1067
    S_ROB3_21,      // 1068
    S_ROB3_22,      // 1069
    S_ROB3_23,      // 1070
    S_ROB3_24,      // 1071
    S_ROB3_25,      // 1072
    S_ROB3_26,      // 1073
    S_ROB3_27,      // 1074
    S_ROB3_28,      // 1075
    S_ROB3_29,      // 1076
    S_ROB3_30,      // 1077
    S_ROB3_31,      // 1078
    S_ROB3_32,      // 1079
    S_ROB3_33,      // 1080
    S_ROB3_34,      // 1081
    S_ROB3_35,      // 1082
    S_ROB3_36,      // 1083
    S_ROB3_37,      // 1084
    S_RBB3_00,      // 1085
    S_RBB3_01,      // 1086
    S_RBB3_02,      // 1087
    S_RBB3_03,      // 1088
    S_RBB3_04,      // 1089
    S_RBB3_05,      // 1090
    S_RBB3_06,      // 1091
    S_RBB3_07,      // 1092
    S_PRGR_00,      // 1093
    S_PRGR_01,      // 1094
    S_PRGR_02,      // 1095
    S_PRGR_03,      // 1096
    S_PRGR_04,      // 1097
    S_PRGR_05,      // 1098
    S_PRGR_06,      // 1099
    S_PRGR_07,      // 1100
    S_PRGR_08,      // 1101
    S_PRGR_09,      // 1102
    S_PRGR_10,      // 1103
    S_PRGR_11,      // 1104
    S_PRGR_12,      // 1105
    S_PRGR_13,      // 1106
    S_PRGR_14,      // 1107
    S_PRGR_15,      // 1108
    S_PRGR_16,      // 1109
    S_PRGR_17,      // 1110
    S_PRGR_18,      // 1111
    S_PRGR_19,      // 1112
    S_PRGR_20,      // 1113
    S_PRGR_21,      // 1114
    S_PRGR_22,      // 1115
    S_PRGR_23,      // 1116
    S_PRGR_24,      // 1117
    S_PRGR_25,      // 1118
    S_PRGR_26,      // 1119
    S_PRGR_27,      // 1120
    S_PRGR_28,      // 1121
    S_PRGR_29,      // 1122
    S_PRGR_30,      // 1123
    S_PRGR_31,      // 1124
    S_PRGR_32,      // 1125
    S_PRGR_33,      // 1126
    S_BASE_00,      // 1127
    S_BASE_01,      // 1128
    S_BASE_02,      // 1129
    S_BASE_03,      // 1130
    S_BASE_04,      // 1131
    S_BASE_05,      // 1132
    S_BASE_06,      // 1133
    S_BASE_07,      // 1134
    S_FRBL_00,      // 1135
    S_FRBL_01,      // 1136
    S_FRBL_02,      // 1137
    S_FRBL_03,      // 1138
    S_FRBL_04,      // 1139
    S_FRBL_05,      // 1140
    S_FRBL_06,      // 1141
    S_FRBL_07,      // 1142
    S_FRBL_08,      // 1143
    S_KLAX_00,      // 1144
    S_KLAX_01,      // 1145
    S_KLAX_02,      // 1146
    S_TURT_00,      // 1147
    S_TURT_01,      // 1148
    S_TURT_02,      // 1149
    S_TURT_03,      // 1150
    S_TURT_04,      // 1151
    S_BALL_00,      // 1152
    S_BALL_01,      // 1153
    S_BALL_02,      // 1154
    S_BALL_03,      // 1155
    S_BALL_04,      // 1156
    S_TURT_05,      // 1157
    S_PSTN_00,      // 1158
    S_PSTN_01,      // 1159
    S_PSTN_02,      // 1160
    S_PSTN_03,      // 1161
    S_PSTN_04,      // 1162
    S_PSTN_05,      // 1163
    S_PSTN_06,      // 1164
    S_PSTN_07,      // 1165
    S_PSTN_08,      // 1166
    S_PSTN_09,      // 1167
    S_PSTN_10,      // 1168
    S_SECR_00,      // 1169
    S_SECR_01,      // 1170
    S_SECR_02,      // 1171
    S_SECR_03,      // 1172
    S_SECR_04,      // 1173
    S_SECR_05,      // 1174
    S_SECR_06,      // 1175
    S_SECR_07,      // 1176
    S_SECR_08,      // 1177
    S_SECR_09,      // 1178
    S_SECR_10,      // 1179
    S_SECR_11,      // 1180
    S_SECR_12,      // 1181
    S_SECR_13,      // 1182
    S_SECR_14,      // 1183
    S_SECR_15,      // 1184
    S_XPRK_01,      // 1185
    S_XPRK_02,      // 1186
    S_TARG_00,      // 1187
    S_RING_00,      // 1188
    S_EARS_00,      // 1189
    S_COMM_00,      // 1190
    S_BOOM_00,      // 1191
    S_BOOM_01,      // 1192
    S_BOOM_02,      // 1193
    S_BOOM_03,      // 1194
    S_BOOM_04,      // 1195
    S_BOOM_05,      // 1196
    S_BOOM_06,      // 1197
    S_BOOM_07,      // 1198
    S_BOOM_08,      // 1199
    S_BOOM_09,      // 1200
    S_BOOM_10,      // 1201
    S_BOOM_11,      // 1202
    S_BOOM_12,      // 1203
    S_BOOM_13,      // 1204
    S_BOOM_14,      // 1205
    S_BOOM_15,      // 1206
    S_BOOM_16,      // 1207
    S_BOOM_17,      // 1208
    S_BOOM_18,      // 1209
    S_BOOM_19,      // 1210
    S_BOOM_20,      // 1211
    S_BOOM_21,      // 1212
    S_BOOM_22,      // 1213
    S_BOOM_23,      // 1214
    S_BOOM_24,      // 1215
    S_RATT_00,      // 1216
    S_RATT_01,      // 1217
    S_RATT_02,      // 1218
    S_RATT_03,      // 1219
    S_RATT_04,      // 1220
    S_RATT_05,      // 1221
    S_RATT_06,      // 1222
    S_HOGN_00,      // 1223
    S_HOGN_01,      // 1224
    S_HOGN_02,      // 1225
    S_DEAD_00,      // 1226
    S_SBAN_00,      // 1227
    S_BOTR_00,      // 1228
    S_HATR_00,      // 1229
    S_TOPR_00,      // 1230
    S_COUP_00,      // 1231
    S_COUP_01,      // 1232
    S_COUP_02,      // 1233
    S_BUBB_00,      // 1234
    S_BUBF_00,      // 1235
    S_BUBC_00,      // 1236
    S_ASPR_00,      // 1237
    S_SPDL_00,      // 1238
    S_SPDL_01,      // 1239
    S_SPDL_02,      // 1240
    S_TOKN_00,      // 1241
    S_OTOK_00,      // 1242
    S_HELT_00,      // 1243
    S_GUNT_00,      // 1244
    S_FULL_00,      // 1245
    S_FULL_01,      // 1246
    S_MEAT_00,      // 1247
    S_MEAT_01,      // 1248
    S_MEAT_02,      // 1249
    S_MEAT_03,      // 1250
    S_MEAT_04,      // 1251
    S_MEAT_05,      // 1252
    S_MEAT_06,      // 1253
    S_MEAT_07,      // 1254
    S_MEAT_08,      // 1255
    S_MEAT_09,      // 1256
    S_MEAT_10,      // 1257
    S_MEAT_11,      // 1258
    S_MEAT_12,      // 1259
    S_MEAT_13,      // 1260
    S_MEAT_14,      // 1261
    S_MEAT_15,      // 1262
    S_MEAT_16,      // 1263
    S_MEAT_17,      // 1264
    S_MEAT_18,      // 1265
    S_MEAT_19,      // 1266
    S_JUNK_00,      // 1267
    S_JUNK_01,      // 1268
    S_JUNK_02,      // 1269
    S_JUNK_03,      // 1270
    S_JUNK_04,      // 1271
    S_JUNK_05,      // 1272
    S_JUNK_06,      // 1273
    S_JUNK_07,      // 1274
    S_JUNK_08,      // 1275
    S_JUNK_09,      // 1276
    S_JUNK_10,      // 1277
    S_JUNK_11,      // 1278
    S_JUNK_12,      // 1279
    S_JUNK_13,      // 1280
    S_JUNK_14,      // 1281
    S_JUNK_15,      // 1282
    S_JUNK_16,      // 1283
    S_JUNK_17,      // 1284
    S_JUNK_18,      // 1285
    S_JUNK_19,      // 1286
    S_FFOT_00,      // 1287
    S_FFOT_01,      // 1288
    S_FFOT_02,      // 1289
    S_FFOT_03,      // 1290
    S_DIE1_00,      // 1291
    S_BEAC_00,      // 1292
    S_BEAC_01,      // 1293
    S_BEAC_02,      // 1294
    S_ARM1_00,      // 1295
    S_ARM2_00,      // 1296
    S_BARW_00,      // 1297
    S_BARW_01,      // 1298
    S_BARW_02,      // 1299
    S_BARW_03,      // 1300
    S_BARW_04,      // 1301
    S_BARW_05,      // 1302
    S_BARW_06,      // 1303
    S_BARW_07,      // 1304
    S_BART_00,      // 1305
    S_BART_01,      // 1306
    S_BART_02,      // 1307
    S_BART_03,      // 1308
    S_BART_04,      // 1309
    S_BART_05,      // 1310
    S_BART_06,      // 1311
    S_BART_07,      // 1312
    S_BART_08,      // 1313
    S_BART_09,      // 1314
    S_BART_10,      // 1315
    S_BART_11,      // 1316
    S_LAMP_00,      // 1317
    S_LANT_00,      // 1318
    S_BARL_00,      // 1319
    S_BARL_01,      // 1320
    S_BARL_02,      // 1321
    S_BARL_03,      // 1322
    S_BOWL_00,      // 1323
    S_BOWL_01,      // 1324
    S_BOWL_02,      // 1325
    S_BOWL_03,      // 1326
    S_BRAZ_00,      // 1327
    S_BRAZ_01,      // 1328
    S_BRAZ_02,      // 1329
    S_BRAZ_03,      // 1330
    S_TRCH_00,      // 1331
    S_TRCH_01,      // 1332
    S_TRCH_02,      // 1333
    S_TRCH_03,      // 1334
    S_LTRH_00,      // 1335
    S_LTRH_01,      // 1336
    S_LTRH_02,      // 1337
    S_LTRH_03,      // 1338
    S_LMPC_00,      // 1339
    S_LMPC_01,      // 1340
    S_LMPC_02,      // 1341
    S_LMPC_03,      // 1342
    S_LOGS_00,      // 1343
    S_LOGS_01,      // 1344
    S_LOGS_02,      // 1345
    S_LOGS_03,      // 1346
    S_TRHO_00,      // 1347
    S_WATR_00,      // 1348
    S_MUGG_00,      // 1349
    S_FUSL_00,      // 1350
    S_CRD1_00,      // 1351
    S_CRD2_00,      // 1352
    S_TPAS_00,      // 1353
    S_KY1G_00,      // 1354
    S_KY2S_00,      // 1355
    S_KY3B_00,      // 1356
    S_HAND_00,      // 1357
    S_CRYS_00,      // 1358
    S_CRYS_01,      // 1359
    S_CRYS_02,      // 1360
    S_CRYS_03,      // 1361
    S_CRYS_04,      // 1362
    S_CRYS_05,      // 1363
    S_PRIS_00,      // 1364
    S_PWR1_00,      // 1365
    S_PWR2_00,      // 1366
    S_PWR3_00,      // 1367
    S_ORAC_00,      // 1368
    S_GYID_00,      // 1369
    S_FUBR_00,      // 1370
    S_WARE_00,      // 1371
    S_RCRY_00,      // 1372
    S_BCRY_00,      // 1373
    S_CHAP_00,      // 1374
    S_TUNL_00,      // 1375
    S_BLTK_00,      // 1376
    S_SECK_00,      // 1377
    S_MINE_00,      // 1378
    S_REBL_00,      // 1379
    S_PROC_00,      // 1380
    S_ANKH_00,      // 1381
    S_GOID_00,      // 1382
    S_STMP_00,      // 1383
    S_MDKT_00,      // 1384
    S_COIN_00,      // 1385
    S_CRED_00,      // 1386
    S_SACK_00,      // 1387
    S_CHST_00,      // 1388
    S_SHD1_00,      // 1389
    S_SHD1_01,      // 1390
    S_SHD1_02,      // 1391
    S_SHD1_03,      // 1392
    S_MASK_00,      // 1393
    S_UNIF_00,      // 1394
    S_OFIC_00,      // 1395
    S_PMAP_00,      // 1396
    S_PMAP_01,      // 1397
    S_PMUP_00,      // 1398
    S_PMUP_01,      // 1399
    S_BLIT_00,      // 1400
    S_BBOX_00,      // 1401
    S_MSSL_00,      // 1402
    S_ROKT_00,      // 1403
    S_BRY1_00,      // 1404
    S_BRY1_01,      // 1405
    S_CPAC_00,      // 1406
    S_CPAC_01,      // 1407
    S_PQRL_00,      // 1408
    S_XQRL_00,      // 1409
    S_GRN1_00,      // 1410
    S_GRN2_00,      // 1411
    S_BKPK_00,      // 1412
    S_RELC_00,      // 1413
    S_RIFL_00,      // 1414
    S_RIFL_01,      // 1415
    S_FLAM_00,      // 1416
    S_BFLM_00,      // 1417
    S_MMSL_00,      // 1418
    S_TRPD_00,      // 1419
    S_GRND_00,      // 1420
    S_CBOW_00,      // 1421
    S_SIGL_00,      // 1422
    S_SIGL_01,      // 1423
    S_SIGL_02,      // 1424
    S_SIGL_03,      // 1425
    S_SIGL_04,      // 1426
    S_LITE_00,      // 1427
    S_CNDL_00,      // 1428
    S_CLBR_00,      // 1429
    S_LITS_00,      // 1430
    S_LITB_00,      // 1431
    S_LITG_00,      // 1432
    S_ROK1_00,      // 1433
    S_ROK2_00,      // 1434
    S_ROK3_00,      // 1435
    S_ROK4_00,      // 1436
    S_LOGG_00,      // 1437
    S_LOGG_01,      // 1438
    S_LOGG_02,      // 1439
    S_LOGG_03,      // 1440
    S_RUB1_00,      // 1441
    S_RUB2_00,      // 1442
    S_RUB3_00,      // 1443
    S_RUB4_00,      // 1444
    S_RUB5_00,      // 1445
    S_RUB6_00,      // 1446
    S_RUB7_00,      // 1447
    S_RUB8_00,      // 1448
    S_CHAN_00,      // 1449
    S_STAT_00,      // 1450
    S_DSTA_00,      // 1451
    S_CRAB_00,      // 1452
    S_CAGE_00,      // 1453
    S_TREE_00,      // 1454
    S_TREE_01,      // 1455
    S_TREE_02,      // 1456
    S_TRE1_00,      // 1457
    S_BUSH_00,      // 1458
    S_SHRB_00,      // 1459
    S_STAK_00,      // 1460
    S_BAR1_00,      // 1461
    S_VASE_00,      // 1462
    S_VASE_01,      // 1463
    S_STOL_00,      // 1464
    S_POT1_00,      // 1465
    S_TUB1_00,      // 1466
    S_ANVL_00,      // 1467
    S_TLMP_00,      // 1468
    S_TLMP_01,      // 1469
    S_TRAY_00,      // 1470
    S_APOW_00,      // 1471
    S_AFED_00,      // 1472
    S_DRIP_00,      // 1473
    S_DRIP_01,      // 1474
    S_DRIP_02,      // 1475
    S_DRIP_03,      // 1476
    S_DRIP_04,      // 1477
    S_DRIP_05,      // 1478
    S_DRIP_06,      // 1479
    S_DRIP_07,      // 1480
    S_CDRP_00,      // 1481
    S_CDRP_01,      // 1482
    S_CDRP_02,      // 1483
    S_CDRP_03,      // 1484
    S_SPLH_00,      // 1485
    S_SPLH_01,      // 1486
    S_SPLH_02,      // 1487
    S_SPLH_03,      // 1488
    S_SPLH_04,      // 1489
    S_SPLH_05,      // 1490
    S_SPLH_06,      // 1491
    S_SPLH_07,      // 1492
    S_WTFT_00,      // 1493
    S_WTFT_01,      // 1494
    S_WTFT_02,      // 1495
    S_WTFT_03,      // 1496
    S_HERT_00,      // 1497
    S_HERT_01,      // 1498
    S_HERT_02,      // 1499
    S_TELP_00,      // 1500
    S_TELP_01,      // 1501
    S_TELP_02,      // 1502
    S_TELP_03,      // 1503
    S_MONI_00,      // 1504
    S_STEL_00,      // 1505
    S_STLA_00,      // 1506
    S_STLE_00,      // 1507
    S_HUGE_00,      // 1508
    S_HUGE_01,      // 1509
    S_HUGE_02,      // 1510
    S_HUGE_03,      // 1511
    S_STLG_00,      // 1512
    S_STLG_01,      // 1513
    S_STLG_02,      // 1514
    S_STLG_03,      // 1515
    S_STLG_04,      // 1516
    S_STLG_05,      // 1517

    S_SPLASH1,
    S_SPLASH2,
    S_SPLASH3,
    S_SPLASH4,
    S_SPLASHX,
    S_SPLASHBASE1,
    S_SPLASHBASE2,
    S_SPLASHBASE3,
    S_SPLASHBASE4,
    S_SPLASHBASE5,
    S_SPLASHBASE6,
    S_SPLASHBASE7,
    S_LAVASPLASH1,
    S_LAVASPLASH2,
    S_LAVASPLASH3,
    S_LAVASPLASH4,
    S_LAVASPLASH5,
    S_LAVASPLASH6,
    S_LAVASMOKE1,
    S_LAVASMOKE2,
    S_LAVASMOKE3,
    S_LAVASMOKE4,
    S_LAVASMOKE5,
    S_SLUDGECHUNK1,
    S_SLUDGECHUNK2,
    S_SLUDGECHUNK3,
    S_SLUDGECHUNK4,
    S_SLUDGECHUNKX,
    S_SLUDGESPLASH1,
    S_SLUDGESPLASH2,
    S_SLUDGESPLASH3,
    S_SLUDGESPLASH4,
    S_NUKAGECHUNK1,
    S_NUKAGECHUNK2,
    S_NUKAGECHUNK3,
    S_NUKAGECHUNK4,
    S_NUKAGECHUNKX,
    S_NUKAGESPLASH1,
    S_NUKAGESPLASH2,
    S_NUKAGESPLASH3,
    S_NUKAGESPLASH4,

    S_GREENBLOOD1,
    S_GREENBLOOD2,
    S_GREENBLOOD3,
    S_BLUEBLOOD1,
    S_BLUEBLOOD2,
    S_BLUEBLOOD3,

    S_TNT1,


    DO_NUMSTATES
  );

type
  state_t = record
{$IFDEF OPTIMIZE_FOR_SIZE}
    sprite: smallint;
    frame: integer;
    tics: smallint;
{$ELSE}
    sprite: integer;
    frame: integer;
    tics: integer;
{$ENDIF}
    action: actionf_t;
    nextstate: statenum_t;
    misc1: integer;
    misc2: integer;
    params: TCustomParamList;
    dlights: TDNumberList;
{$IFDEF OPENGL}
    models: TDNumberList;
{$ENDIF}
    voxels: TDNumberList;
{$IFNDEF OPENGL}
    voxelradius: integer;
{$ENDIF}
  end;
  Pstate_t = ^state_t;

type
  mobjtype_t = (
    MT_FIELDGUARD,      //000
    MT_PLAYER,          //001
    MT_SHOPKEEPER_W,    //002
    MT_SHOPKEEPER_B,    //003
    MT_SHOPKEEPER_A,    //004
    MT_SHOPKEEPER_M,    //005
    MT_PEASANT2_A,      //006
    MT_PEASANT2_B,      //007
    MT_PEASANT2_C,      //008
    MT_PEASANT5_A,      //009
    MT_PEASANT5_B,      //010
    MT_PEASANT5_C,      //011
    MT_PEASANT4_A,      //012
    MT_PEASANT4_B,      //013
    MT_PEASANT4_C,      //014
    MT_PEASANT6_A,      //015
    MT_PEASANT6_B,      //016
    MT_PEASANT6_C,      //017
    MT_PEASANT3_A,      //018
    MT_PEASANT3_B,      //019
    MT_PEASANT3_C,      //020
    MT_PEASANT8_A,      //021
    MT_PEASANT8_B,      //022
    MT_PEASANT8_C,      //023
    MT_PEASANT7_A,      //024
    MT_PEASANT7_B,      //025
    MT_PEASANT7_C,      //026
    MT_PEASANT1,        //027
    MT_ZOMBIE,          //028
    MT_BECOMING,        //029
    MT_ZOMBIESPAWNER,   //030
    MT_HUGE_TANK_1,     //031
    MT_HUGE_TANK_2,     //032
    MT_HUGE_TANK_3,     //033
    MT_TANK_4,          //034
    MT_TANK_5,          //035
    MT_TANK_6,          //036
    MT_KNEELING_GUY,    //037
    MT_BEGGAR1,         //038
    MT_BEGGAR2,         //039
    MT_BEGGAR3,         //040
    MT_BEGGAR4,         //041
    MT_BEGGAR5,         //042
    MT_REBEL1,          //043
    MT_REBEL2,          //044
    MT_REBEL3,          //045
    MT_REBEL4,          //046
    MT_REBEL5,          //047
    MT_REBEL6,          //048
    MT_RLEADER,         //049
    MT_RLEADER2,        //050
    MT_MISSILESMOKE,    //051
    MT_REAVER,          //052
    MT_GUARD1,          //053
    MT_GUARD2,          //054
    MT_GUARD3,          //055
    MT_GUARD4,          //056
    MT_GUARD5,          //057
    MT_GUARD6,          //058
    MT_GUARD7,          //059
    MT_GUARD8,          //060
    MT_SHADOWGUARD,     //061
    MT_PGUARD,          //062
    MT_CRUSADER,        //063
    MT_BISHOP,          //064
    MT_ORACLE,          //065
    MT_PRIEST,          //066
    MT_SPECTRE_A,       //067
    MT_NODE,            //068
    MT_SPECTREHEAD,     //069
    MT_SPECTRE_B,       //070
    MT_SPECTRE_C,       //071
    MT_SPECTRE_D,       //072
    MT_SPECTRE_E,       //073
    MT_ENTITY,          //074
    MT_SUBENTITY,       //075
    MT_NEST,            //076
    MT_POD,             //077
    MT_SIGIL_B_SHOT,    //078
    MT_SIGIL_SB_SHOT,   //079
    MT_SIGIL_C_SHOT,    //080
    MT_SIGIL_SC_SHOT,   //081
    MT_SIGIL_E_OFFSHOOT,//082
    MT_SIGIL_TRAIL,     //083
    MT_SIGIL_E_SHOT,    //084
    MT_SIGIL_SE_SHOT,   //085
    MT_SIGIL_A_ZAP_LEFT,//086
    MT_SIGIL_A_ZAP_RIGHT, //087
    MT_SIGIL_A_GROUND,  //088
    MT_SIGIL_D_SHOT,    //089
    MT_SIGIL_SD_SHOT,   //090
    MT_SENTINEL,        //091
    MT_STALKER,         //092
    MT_INQUISITOR,      //093
    MT_INQARM,          //094
    MT_PROGRAMMER,      //095
    MT_PROGRAMMERBASE,  //096
    MT_HOOKSHOT,        //097
    MT_CHAINSHOT,       //098
    MT_MINIMISSLE,      //099
    MT_C_MISSILE,       //100
    MT_SEEKMISSILE,     //101
    MT_ELECARROW,       //102
    MT_POISARROW,       //103
    MT_R_LASER,         //104
    MT_L_LASER,         //105
    MT_HEGRENADE,       //106
    MT_PGRENADE,        //107
    MT_INQGRENADE,      //108
    MT_PFLAME,          //109
    MT_TORPEDO,         //110
    MT_TORPEDOSPREAD,   //111
    MT_SFIREBALL,       //112
    MT_C_FLAME,         //113
    MT_STRIFEPUFF3,     //114
    MT_STRIFEPUFF,      //115
    MT_SPARKPUFF,       //116
    MT_BLOOD_DEATH,     //117
    MT_TFOG,            //118
    MT_IFOG,            //119
    MT_TELEPORTMAN,     //120
    MT_MISC_01,         //121
    MT_TURRET,          //122
    MT_GATE,            //123
    MT_COMPUTER,        //124
    MT_INV_MED1,        //125
    MT_INV_MED2,        //126
    MT_INV_MED3,        //127
    MT_DEGNINORE,       //128
    MT_INV_ARMOR2,      //129
    MT_INV_ARMOR1,      //130
    MT_MISC_22,         //131
    MT_MISC_11,         //132
    MT_KEY_BASE,        //133
    MT_GOVSKEY,         //134
    MT_KEY_TRAVEL,      //135
    MT_KEY_ID_BLUE,     //136
    MT_PRISONKEY,       //137
    MT_KEY_HAND,        //138
    MT_POWER1KEY,       //139
    MT_POWER2KEY,       //140
    MT_POWER3KEY,       //141
    MT_KEY_GOLD,        //142
    MT_KEY_ID_GOLD,     //143
    MT_KEY_SILVER,      //144
    MT_KEY_ORACLE,      //145
    MT_MILITARYID,      //146
    MT_KEY_ORDER,       //147
    MT_KEY_WAREHOUSE,   //148
    MT_KEY_BRASS,       //149
    MT_KEY_RED_CRYSTAL, //150
    MT_KEY_BLUE_CRYSTAL,//151
    MT_KEY_CHAPEL,      //152
    MT_CATACOMBKEY,     //153
    MT_SECURITYKEY,     //154
    MT_KEY_CORE,        //155
    MT_KEY_MAULER,      //156
    MT_KEY_FACTORY,     //157
    MT_KEY_MINE,        //158
    MT_NEWKEY5,         //159
    MT_INV_SHADOWARMOR, //160
    MT_INV_SUIT,        //161
    MT_QUEST_UNIFORM,   //162
    MT_QUEST_GUARD_UNIFORM,     //163
    MT_INV_SUPERMAP,    //164
    MT_INV_RADAR,       //165
    MT_BEACON,          //166
    MT_INV_TARGETER,    //167
    MT_MONY_1,          //168
    MT_MONY_10,         //169
    MT_MONY_25,         //170
    MT_MONY_50,         //171
    MT_MONY_300,        //172
    MT_TOKEN_RING,      //173
    MT_INV_CHALICE,     //174
    MT_TOKEN_EAR,       //175
    MT_INV_COMMUNICATOR,//176
    MT_AGREN,           //177
    MT_APGREN,          //178
    MT_ACLIP,           //179
    MT_AAMMOBOX,        //180
    MT_AMINI,           //181
    MT_AMINIBOX,        //182
    MT_ACELL,           //183
    MT_APCELL,          //184
    MT_APAROW,          //185
    MT_AAROW,           //186
    MT_INV_SATCHEL,     //187
    MT_PULSE,           //188
    MT_RIFLESTAND,      //189
    MT_FLAMETHROWER,    //190
    MT_TOKEN_FLAME_THROWER_PARTS,       //191
    MT_MISSILELAUNCHER, //192
    MT_BLASTER,         //193
    MT_CROSSBOW,        //194
    MT_GRENADELAUNCHER, //195
    MT_SIGIL_A,         //196
    MT_SIGIL_B,         //197
    MT_SIGIL_C,         //198
    MT_SIGIL_D,         //199
    MT_SIGIL_E,         //200
    MT_POWER_CRYSTAL,   //201
    MT_RAT,             //202
    MT_MISC_05,         //203
    MT_MISC_06,         //204
    MT_MISC_15,         //205
    MT_LIGHT14,     //206
    MT_LIGHT13,     //207
    MT_LIGHT12,     //208
    MT_LIGHT18,     //209
    MT_PILLAR2,     //210
    MT_PILLAR3,     //211
    MT_PILLAR4,     //212
    MT_PILLAR5,     //213
    MT_PILLAR6,     //214
    MT_PILLAR7,     //215
    MT_CAVE2,       //216
    MT_CAVE3,       //217
    MT_CAVE4,       //218
    MT_CAVE6,       //219
    MT_CAVE7,       //220
    MT_CAVE5,       //221
    MT_LIGHT2,      //222
    MT_LIGHT3,      //223
    MT_MISC_03,     //224
    MT_MISC_13,     //225
    MT_MISC_02,     //226
    MT_MISC_07,     //227
    MT_BIO2,        //228
    MT_TELEPORTSTAND,   //229
    MT_DEADTHING1,      //230
    MT_DEADTHING2,      //231
    MT_DEADTHING3,      //232
    MT_DEADTHING4,      //233
    MT_DEADTHING5,      //234
    MT_DEADTHING6,      //235
    MT_BIO1,        //236
    MT_GIBS,        //237
    MT_MISC_04,     //238
    MT_LIGHT11,     //239
    MT_LIGHT10,     //240
    MT_LIGHT9,      //241
    MT_LIGHT8,      //242
    MT_MISC_14,     //243
    MT_LIGHT1,      //244
    MT_PILLAR8,     //245
    MT_PILLAR9,     //246
    MT_LIGHT15,     //247
    MT_LIGHT4,      //248
    MT_LIGHT5,      //249
    MT_ROCK1,       //250
    MT_ROCK2,       //251
    MT_ROCK3,       //252
    MT_ROCK4,       //253
    MT_TREE7,       //254
    MT_RUBBLE1,     //255
    MT_RUBBLE2,     //256
    MT_RUBBLE3,     //257
    MT_RUBBLE4,     //258
    MT_RUBBLE5,     //259
    MT_RUBBLE6,     //260
    MT_RUBBLE7,     //261
    MT_RUBBLE8,     //262
    MT_MISC_08,     //263
    MT_LIGHT6,      //264
    MT_LIGHT7,      //265
    MT_TREE2,       //266
    MT_TREE3,       //267
    MT_TREE4,       //268
    MT_TREE1,       //269
    MT_TREE6,       //270
    MT_TREE5,       //271
    MT_CAVE1,       //272
    MT_PILLAR1,     //273
    MT_MISC_10,     //274
    MT_MISC_09,     //275
    MT_MISC_17,     //276
    MT_MISC_18,     //277
    MT_MISC_19,     //278
    MT_MISC_20,     //279
    MT_LIGHT16,     //280
    MT_LIGHT17,     //281
    MT_MISC_21,     //282
    MT_MISC_12,     //283
    MT_MISC_26,     //284
    MT_MISC_23,     //285
    MT_MISC_24,     //286
    MT_MISC_25,     //287
    MT_COUPLING,            //288
    MT_COUPLING_BROKEN,     //289
    MT_PILLAR10,            //290
    MT_PILLAR11,            //291
    MT_PILLAR12,            //292
    MT_PILLAR13,            //293
    MT_LIGHT19,             //294
    MT_MEAT,                //295
    MT_JUNK,                //296
    MT_BURNDROP,            //297
    MT_TOKEN_AMMO,          //298
    MT_TOKEN_HEALTH,        //299
    MT_TOKEN,               //300
    MT_TOKEN_ALARM,         //301
    MT_TOKEN_DOOR1,         //302
    MT_TOKEN_SHOPCLOSE,     //303
    MT_TOKEN_PRISON_PASS,   //304
    MT_TOKEN_DOOR3,         //305
    MT_TOKEN_STAMINA,       //306
    MT_TOKEN_NEW_ACCURACY,  //307
    MT_TOKEN_REPORT,        //308
    MT_TOKEN_TOUGHNESS,     //309
    MT_TOKEN_ACCURACY,      //310
    MT_TOKEN_ORACLE_PASS,   //311
    MT_TOKEN_QUEST1,        //312
    MT_TOKEN_QUEST2,        //313
    MT_TOKEN_QUEST3,        //314
    MT_TOKEN_QUEST4,        //315
    MT_TOKEN_QUEST5,        //316
    MT_TOKEN_QUEST6,        //317
    MT_TOKEN_QUEST7,        //318
    MT_TOKEN_QUEST8,        //319
    MT_TOKEN_QUEST9,        //320
    MT_TOKEN_QUEST10,       //321
    MT_TOKEN_QUEST11,       //322
    MT_TOKEN_QUEST12,       //323
    MT_TOKEN_QUEST13,       //324
    MT_TOKEN_CRYSTAL,       //325
    MT_TOKEN_QUEST15,       //326
    MT_GATEQUEST,           //327
    MT_TOKEN_QUEST17,       //328
    MT_TOKEN_QUEST18,       //329
    MT_TOKEN_QUEST19,       //330
    MT_TOKEN_QUEST20,       //331
    MT_TOKEN_BISHOP,        //332
    MT_TOKEN_QUEST22,       //333
    MT_TOKEN_ORACLE,        //334
    MT_TOKEN_MACIL,         //335
    MT_TOKEN_QUEST25,       //336
    MT_TOKEN_LOREMASTER,    //337
    MT_SECRQUEST,           //338
    MT_TOKEN_QUEST28,       //339
    MT_TOKEN_QUEST29,       //340
    MT_TOKEN_QUEST30,       //341
    MT_TOKEN_QUEST31,       //342
    MT_SLIDESHOW,           //343

    MT_SPLASH,
    MT_SPLASHBASE,
    MT_LAVASPLASH,
    MT_LAVASMOKE,
    MT_SLUDGECHUNK,
    MT_SLUDGESPLASH,
    MT_NUKAGECHUNK,
    MT_NUKAGESPLASH,

    MT_GREENBLOOD,
    MT_BLUEBLOOD,

    MT_PUSH,
    MT_PULL,

    DO_NUMMOBJTYPES
  );

const
  MOBJINFONAMESIZE = 32;

type
  mobjinfo_t = record
    name: array[0..MOBJINFONAMESIZE - 1] of char;
    name2: array[0..MOBJINFONAMESIZE - 1] of char;
    inheritsfrom: integer;
    doomednum: integer;
    spawnstate: integer;
    spawnhealth: integer;
    seestate: integer;
    seesound: integer;
    reactiontime: integer;
    attacksound: integer;
    painstate: integer;
    painchance: integer;
    painsound: integer;
    meleestate: integer;
    missilestate: integer;
    deathstate: integer;
    xdeathstate: integer;
    deathsound: integer;
    speed: integer;
    radius: integer;
    height: integer;
    mass: integer;
    damage: integer;
    activesound: integer;
    flags: LongWord;
    flags_ex: LongWord;
    flags2_ex: LongWord;
    raisestate: integer;
    customsound1: integer;
    customsound2: integer;
    customsound3: integer;
    meleesound: integer;
    dropitem: integer;
    missiletype: integer;
    explosiondamage: integer;
    explosionradius: integer;
    meleedamage: integer;
    renderstyle: mobjrenderstyle_t;
    alpha: integer;
    healstate: integer;
    crashstate: integer;
    interactstate: integer;
    missileheight: integer;
    vspeed: integer;  // Initial vertical speed
    pushfactor: integer; // How much can be pushed? 1..FRACUNIT
    scale: integer;
  end;

  Pmobjinfo_t = ^mobjinfo_t;

implementation

end.

