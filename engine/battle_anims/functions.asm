DoBattleAnimFrame:
	ld hl, BATTLEANIMSTRUCT_FUNCTION
	add hl, bc
	ld e, [hl]
	ld d, 0
	ld hl, .Jumptable
	add hl, de
	add hl, de
	add hl, de
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, e
	jmp FarCall_hl

.Jumptable:
; entries correspond to BATTLE_ANIM_FUNC_* constants
	table_width 3, DoBattleAnimFrame.Jumptable
	dba BattleAnimFunc_Null
	dba BattleAnimFunc_MoveFromUserToTarget
	dba BattleAnimFunc_MoveFromUserToTargetAndDisappear
	dba BattleAnimFunc_MoveInCircle
	dba BattleAnimFunc_MoveWaveToTarget
	dba BattleAnimFunc_ThrowFromUserToTarget
	dba BattleAnimFunc_ThrowFromUserToTargetAndDisappear
	dba BattleAnimFunc_Drop
	dba BattleAnimFunc_MoveFromUserToTargetSpinAround
	dba BattleAnimFunc_Shake
	dba BattleAnimFunc_FireBlast
	dba BattleAnimFunc_RazorLeaf
	dba BattleAnimFunc_Bubble
	dba BattleAnimFunc_Surf
	dba BattleAnimFunc_Sing
	dba BattleAnimFunc_WaterGun
	dba BattleAnimFunc_Ember
	dba BattleAnimFunc_Powder
	dba BattleAnimFunc_PokeBall
	dba BattleAnimFunc_PokeBallBlocked
	dba BattleAnimFunc_Recover
	dba BattleAnimFunc_ThunderWave
	dba BattleAnimFunc_Clamp_Encore
	dba BattleAnimFunc_Bite
	dba BattleAnimFunc_SolarBeam
	dba BattleAnimFunc_Gust
	dba BattleAnimFunc_RazorWind
	dba BattleAnimFunc_Kick
	dba BattleAnimFunc_Absorb
	dba BattleAnimFunc_Egg
	dba BattleAnimFunc_MoveUp
	dba BattleAnimFunc_Wrap
	dba BattleAnimFunc_LeechSeed
	dba BattleAnimFunc_Sound
	dba BattleAnimFunc_ConfuseRay
	dba BattleAnimFunc_Dizzy
	dba BattleAnimFunc_Amnesia
	dba BattleAnimFunc_FloatUp
	dba BattleAnimFunc_Dig
	dba BattleAnimFunc_String
	dba BattleAnimFunc_Paralyzed
	dba BattleAnimFunc_SpiralDescent
	dba BattleAnimFunc_PoisonGas
	dba BattleAnimFunc_Horn
	dba BattleAnimFunc_Needle
	dba BattleAnimFunc_PetalDance
	dba BattleAnimFunc_ThiefPayday
	dba BattleAnimFunc_AbsorbCircle
	dba BattleAnimFunc_Bonemerang
	dba BattleAnimFunc_Shiny
	dba BattleAnimFunc_SkyAttack
	dba BattleAnimFunc_GrowthSwordsDance
	dba BattleAnimFunc_SmokeFlameWheel
	dba BattleAnimFunc_PresentSmokescreen
	dba BattleAnimFunc_StrengthSeismicToss
	dba BattleAnimFunc_SpeedLine
	dba BattleAnimFunc_Sludge
	dba BattleAnimFunc_MetronomeHand
	dba BattleAnimFunc_MetronomeSparkleSketch
	dba BattleAnimFunc_Agility
	dba BattleAnimFunc_SacredFire
	dba BattleAnimFunc_SafeguardProtect
	dba BattleAnimFunc_LockOnMindReader
	dba BattleAnimFunc_Spikes
	dba BattleAnimFunc_HealBellNotes
	dba BattleAnimFunc_BatonPass
	dba BattleAnimFunc_Conversion
	dba BattleAnimFunc_EncoreBellyDrum
	dba BattleAnimFunc_SwaggerMorningSun
	dba BattleAnimFunc_HiddenPower
	dba BattleAnimFunc_Curse
	dba BattleAnimFunc_PerishSong
	dba BattleAnimFunc_RapidSpin
	dba BattleAnimFunc_RainSandstorm
	dba BattleAnimFunc_AnimObjB0
	dba BattleAnimFunc_PsychUp
	dba BattleAnimFunc_AncientPower
	dba BattleAnimFunc_RockSmash
	dba BattleAnimFunc_Cotton
	; New Functions
	dba BattleAnimFunc_BubbleSplash
	dba BattleAnimFunc_RadialMoveOut
	dba BattleAnimFunc_RadialMoveOut_CP_BG
	dba BattleAnimFunc_RadialMoveOut_Slow
	dba BattleAnimFunc_RadialMoveOut_VerySlow
	dba BattleAnimFunc_RadialMoveOut_Fast
	dba BattleAnimFunc_RadialMoveOut_VeryFast_NoStop
	dba BattleAnimFunc_RadialMoveIn
	dba BattleAnimFunc_ObjectHover
	dba BattleAnimFunc_RockTomb
	dba BattleAnimFunc_AirCutter
	dba BattleAnimFunc_RadialMoveOut_SlowShort
	assert_table_length NUM_BATTLE_ANIM_FUNCS

PUSHS ; push the current section onto the stack.

; The functions in the following section require the
; BattleAnimFunc_ThrowFromUserToTarget Function as a
; dependency, so please keep them in the same section.

SECTION "BattleAnimFunc_ThrowFromUserToTarget", ROMX

BattleAnimFunc_ThrowFromUserToTarget:
	; If x coord at $88 or beyond, abort.
	ld hl, BATTLEANIMSTRUCT_XCOORD
	add hl, bc
	ld a, [hl]
	cp $88
	ret nc
	; Move right 2 pixels
	add $2
	ld [hl], a
	; Move down 1 pixel
	ld hl, BATTLEANIMSTRUCT_YCOORD
	add hl, bc
	dec [hl]
	; Decrease var1 and hold onto its previous value (argument of the sine function)
	ld hl, BATTLEANIMSTRUCT_VAR1
	add hl, bc
	ld a, [hl]
	dec [hl]
	; Get param (amplitude of the sine function)
	ld hl, BATTLEANIMSTRUCT_PARAM
	add hl, bc
	ld d, [hl]
	xcall Sine
	; Store the sine result in the Y offset
	ld hl, BATTLEANIMSTRUCT_YOFFSET
	add hl, bc
	ld [hl], a
	; Carry flag denotes success
	scf
	ret

BattleAnimFunc_ThrowFromUserToTargetAndDisappear:
	call BattleAnimFunc_ThrowFromUserToTarget
	ret c
	jmp DeinitBattleAnimation

BattleAnimFunc_PokeBall:
	call BattleAnim_AnonJumptable
.anon_dw
	dw .zero
	dw .one
	dw DoNothing ; .two
	dw .three
	dw .four
	dw DoNothing ; .five
	dw .six
	dw .seven
	dw .eight
	dw DoNothing ; .nine
	dw .ten
	dw .eleven
.zero ; init
	call GetBallAnimPal
	jmp BattleAnim_IncAnonJumptableIndex

.one
	call BattleAnimFunc_ThrowFromUserToTarget
	ret c
	ld hl, BATTLEANIMSTRUCT_YOFFSET
	add hl, bc
	ld a, [hl]
	ld hl, BATTLEANIMSTRUCT_YCOORD
	add hl, bc
	add [hl]
	ld [hl], a
	ld a, BATTLE_ANIM_FRAMESET_POKE_BALL_3
	call ReinitBattleAnimFrameset
	jmp BattleAnim_IncAnonJumptableIndex

.three
	call BattleAnim_IncAnonJumptableIndex
	ld a, BATTLE_ANIM_FRAMESET_POKE_BALL_1
	call ReinitBattleAnimFrameset
	ld hl, BATTLEANIMSTRUCT_VAR1
	add hl, bc
	xor a
	ld [hli], a
	ld [hl], $10
.four
	ld hl, BATTLEANIMSTRUCT_VAR1
	add hl, bc
	ld a, [hli]
	ld d, [hl]
	xcall Sine
	ld hl, BATTLEANIMSTRUCT_YOFFSET
	add hl, bc
	ld [hl], a
	ld hl, BATTLEANIMSTRUCT_VAR1
	add hl, bc
	dec [hl]
	ld a, [hl]
	and $1f
	ret nz
	ld [hl], a
	ld hl, BATTLEANIMSTRUCT_VAR2
	add hl, bc
	ld a, [hl]
	sub $4
	ld [hl], a
	ret nz
	ld a, BATTLE_ANIM_FRAMESET_POKE_BALL_4
	call ReinitBattleAnimFrameset
	jmp BattleAnim_IncAnonJumptableIndex

.six
	ld a, BATTLE_ANIM_FRAMESET_POKE_BALL_5
	call ReinitBattleAnimFrameset
	ld hl, BATTLEANIMSTRUCT_JUMPTABLE_INDEX
	add hl, bc
	dec [hl]
	ret

.seven
	call GetBallAnimPal
	ld a, BATTLE_ANIM_FRAMESET_POKE_BALL_2
	call ReinitBattleAnimFrameset
	call BattleAnim_IncAnonJumptableIndex
	ld hl, BATTLEANIMSTRUCT_VAR2
	add hl, bc
	ld [hl], $20
.eight
.ten
	ld hl, BATTLEANIMSTRUCT_VAR1
	add hl, bc
	ld a, [hli]
	ld d, [hl]
	xcall Sine
	ld hl, BATTLEANIMSTRUCT_YOFFSET
	add hl, bc
	ld [hl], a
	ld hl, BATTLEANIMSTRUCT_VAR1
	add hl, bc
	dec [hl]
	ld a, [hl]
	and $1f
	jr z, .eleven
	and $f
	ret nz
	jmp BattleAnim_IncAnonJumptableIndex

.eleven
	jmp DeinitBattleAnimation

BattleAnimFunc_PokeBallBlocked:
	call BattleAnim_AnonJumptable
.anon_dw
	dw .zero
	dw .one
	dw .two
.zero
	call GetBallAnimPal
	jmp BattleAnim_IncAnonJumptableIndex

.one
	ld hl, BATTLEANIMSTRUCT_XCOORD
	add hl, bc
	ld a, [hl]
	cp $70
	jmp c, BattleAnimFunc_ThrowFromUserToTarget
	call BattleAnim_IncAnonJumptableIndex
.two
	ld hl, BATTLEANIMSTRUCT_YCOORD
	add hl, bc
	ld a, [hl]
	cp $80
	jr nc, .done
	add $4
	ld [hl], a
	ld hl, BATTLEANIMSTRUCT_XCOORD
	add hl, bc
	dec [hl]
	dec [hl]
	ret

.done
	jmp DeinitBattleAnimation

; Needed by PokeBall Functions
GetBallAnimPal:
	ld hl, BATTLEANIMSTRUCT_PALETTE
	add hl, bc
	ld [hl], PAL_BATTLE_OB_RED
	ret


; The functions in the following section require the
; BattleAnimFunc_MoveInCircle Function as a dependency,
; so please keep them in the same section.

SECTION "BattleAnimFunc_MoveInCircle", ROMX

BattleAnimFunc_MoveInCircle:
; Slow circular motion. Examples: Thundershock, Flamethrower
; Obj Param: Distance from center (masked with $7F). Bit 7 causes object to start on other side of the circle
	call BattleAnim_AnonJumptable
.anon_dw
	dw .zero
	dw .one
.zero
	call BattleAnim_IncAnonJumptableIndex
	ld hl, BATTLEANIMSTRUCT_PARAM
	add hl, bc
	bit 7, [hl]
	ld a, $0 ; no-optimize a = 0
	jr z, .got_starting_position
	ld a, $20
.got_starting_position
	ld hl, BATTLEANIMSTRUCT_VAR1
	add hl, bc
	ld [hl], a
	ld hl, BATTLEANIMSTRUCT_PARAM
	add hl, bc
	ld a, [hl]
	and $7f
	ld [hl], a
.one
	ld hl, BATTLEANIMSTRUCT_VAR1
	add hl, bc
	ld a, [hl]
	ld hl, BATTLEANIMSTRUCT_PARAM
	add hl, bc
	ld d, [hl]
	push af
	push de
	xcall Sine
	ld hl, BATTLEANIMSTRUCT_YOFFSET
	add hl, bc
	ld [hl], a
	pop de
	pop af
	xcall Cosine
	ld hl, BATTLEANIMSTRUCT_XOFFSET
	add hl, bc
	ld [hl], a
	ld hl, BATTLEANIMSTRUCT_VAR1
	add hl, bc
	inc [hl]
	ret

BattleAnimFunc_RazorWind:
	call BattleAnimFunc_MoveInCircle
	; Causes object to skip ahead the circular motion every frame
	ld hl, BATTLEANIMSTRUCT_VAR1
	add hl, bc
	ld a, [hl]
	add $f
	ld [hl], a
	ret


; The functions in the following section require the
; BattleAnimFunc_SpiralDescent Function as a dependency,
; so please keep them in the same section.

SECTION "BattleAnimFunc_SpiralDescent", ROMX

BattleAnimFunc_SpiralDescent:
	ld hl, BATTLEANIMSTRUCT_VAR1
	add hl, bc
	ld a, [hl]
	ld d, $18
	push af
	push de
	xcall Sine
	sra a
	sra a
	sra a
	ld hl, BATTLEANIMSTRUCT_VAR2
	add hl, bc
	add [hl]
	ld hl, BATTLEANIMSTRUCT_YOFFSET
	add hl, bc
	ld [hl], a
	pop de
	pop af
	xcall Cosine
	ld hl, BATTLEANIMSTRUCT_XOFFSET
	add hl, bc
	ld [hl], a
	ld hl, BATTLEANIMSTRUCT_VAR1
	add hl, bc
	inc [hl]
	ld a, [hl]
	and $7
	ret nz
	ld hl, BATTLEANIMSTRUCT_VAR2
	add hl, bc
	ld a, [hl]
	cp $28
	jr nc, .delete
	inc [hl]
	ret

.delete
	jmp DeinitBattleAnimation

BattleAnimFunc_PoisonGas:
	call BattleAnim_AnonJumptable
.anon_dw
	dw .zero
	dw BattleAnimFunc_SpiralDescent

.zero:
	ld hl, BATTLEANIMSTRUCT_XCOORD
	add hl, bc
	ld a, [hl]
	cp $84
	jr nc, .next
	inc [hl]
	ld hl, BATTLEANIMSTRUCT_VAR1
	add hl, bc
	ld a, [hl]
	inc [hl]
	ld d, $18
	xcall Cosine
	ld hl, BATTLEANIMSTRUCT_XOFFSET
	add hl, bc
	ld [hl], a
	ld hl, BATTLEANIMSTRUCT_XCOORD
	add hl, bc
	ld a, [hl]
	and $1
	ret nz
	ld hl, BATTLEANIMSTRUCT_YCOORD
	add hl, bc
	dec [hl]
	ret

.next
	jmp BattleAnim_IncAnonJumptableIndex


; All Functions below this line don't have outside dependencies
; and are placed within their own tiny sections. If you need
; to reference another function, please place them within the
; same section.

SECTION "BattleAnimFunc_Null", ROMX

BattleAnimFunc_Null:
	call BattleAnim_AnonJumptable
.anon_dw
	dw DoNothing ; .zero
	dw .one
.one
	jmp DeinitBattleAnimation

SECTION "BattleAnimFunc_MoveWaveToTarget", ROMX

BattleAnimFunc_MoveWaveToTarget:
; Wave motion from one mon to another. Obj is cleared when it reaches x coord $88. Examples: Shadow Ball, Dragon Rage
	ld hl, BATTLEANIMSTRUCT_XCOORD
	add hl, bc
	ld a, [hl]
	cp $88
	jmp nc, DeinitBattleAnimation
	add $2
	ld [hl], a
	ld hl, BATTLEANIMSTRUCT_YCOORD
	add hl, bc
	dec [hl]
	ld hl, BATTLEANIMSTRUCT_VAR1
	add hl, bc
	ld a, [hl]
	inc [hl]
	inc [hl]
	inc [hl]
	inc [hl]
	ld d, $10
	push af
	push de
	xcall Sine
	ld hl, BATTLEANIMSTRUCT_YOFFSET
	add hl, bc
	ld [hl], a
	pop de
	pop af
	xcall Cosine
	ld hl, BATTLEANIMSTRUCT_XOFFSET
	add hl, bc
	sra a
	sra a
	sra a
	sra a
	ld [hl], a
	ret

SECTION "BattleAnimFunc_MoveFromUserToTarget", ROMX

BattleAnimFunc_MoveFromUserToTarget:
; Moves object diagonally at a ~30° angle towards opponent and stops when it reaches x coord $84. Obj Param changes the speed
	call BattleAnim_AnonJumptable
.anon_dw
	dw .zero
	dw .one
.one
	jmp DeinitBattleAnimation

.zero
	ld hl, BATTLEANIMSTRUCT_XCOORD
	add hl, bc
	ld a, [hl]
	cp $84
	ret nc
	ld hl, BATTLEANIMSTRUCT_PARAM
	add hl, bc
	ld a, [hl]
	jmp BattleAnim_StepToTarget

SECTION "BattleAnimFunc_MoveFromUserToTargetAndDisappear", ROMX

BattleAnimFunc_MoveFromUserToTargetAndDisappear:
; Same as BattleAnimFunc_01 but objs are cleared when they reach x coord $84
	ld hl, BATTLEANIMSTRUCT_XCOORD
	add hl, bc
	ld a, [hl]
	cp $84
	jr nc, .done
	ld hl, BATTLEANIMSTRUCT_PARAM
	add hl, bc
	ld a, [hl]
	jmp BattleAnim_StepToTarget

.done
	jmp DeinitBattleAnimation

SECTION "BattleAnimFunc_Ember", ROMX

BattleAnimFunc_Ember:
	call BattleAnim_AnonJumptable
.anon_dw
	dw .zero
	dw .one
	dw .two
	dw .three
	dw DoNothing ; .four
.zero
	ld hl, BATTLEANIMSTRUCT_PARAM
	add hl, bc
	ld a, [hl]
	swap a
	and $f
	ld hl, BATTLEANIMSTRUCT_JUMPTABLE_INDEX
	add hl, bc
	ld [hl], a
	ret

.one
	ld hl, BATTLEANIMSTRUCT_XCOORD
	add hl, bc
	ld a, [hl]
	cp $88
	ret nc
	ld hl, BATTLEANIMSTRUCT_PARAM
	add hl, bc
	ld a, [hl]
	jmp BattleAnim_StepToTarget

.two
	jmp DeinitBattleAnimation

.three
	call BattleAnim_IncAnonJumptableIndex
	ld a, BATTLE_ANIM_FRAMESET_FLAMETHROWER
	jmp ReinitBattleAnimFrameset

SECTION "BattleAnimFunc_Drop", ROMX

BattleAnimFunc_Drop:
; Drops obj. The Obj Param dictates how fast it is (lower value is faster) and how long it stays bouncing (lower value is longer). Example: Rock Slide
	call BattleAnim_AnonJumptable
.anon_dw
	dw .zero
	dw .one
.zero
	call BattleAnim_IncAnonJumptableIndex
	ld hl, BATTLEANIMSTRUCT_VAR1
	add hl, bc
	ld a, $30
	ld [hli], a
	ld [hl], $48
.one
	ld hl, BATTLEANIMSTRUCT_VAR1
	add hl, bc
	ld a, [hli]
	ld d, [hl]
	xcall Sine
	ld hl, BATTLEANIMSTRUCT_YOFFSET
	add hl, bc
	ld [hl], a
	ld hl, BATTLEANIMSTRUCT_VAR1
	add hl, bc
	inc [hl]
	ld a, [hl]
	and $3f
	ret nz
	ld hl, BATTLEANIMSTRUCT_VAR1
	add hl, bc
	ld [hl], $20
	ld hl, BATTLEANIMSTRUCT_VAR2
	add hl, bc
	ld a, [hl]
	ld hl, BATTLEANIMSTRUCT_PARAM
	add hl, bc
	sub [hl]
	jr z, .done
	jr c, .done
	ld hl, BATTLEANIMSTRUCT_VAR2
	add hl, bc
	ld [hl], a
	ret

.done
	jmp DeinitBattleAnimation

SECTION "BattleAnimFunc_MoveFromUserToTargetSpinAround", ROMX

BattleAnimFunc_MoveFromUserToTargetSpinAround:
; Object moves from user to target target and spins around it once. Example: Fire Spin, Swift
	call BattleAnim_AnonJumptable
.anon_dw
	dw .zero
	dw .one
	dw .two
	dw .three
.zero
	ld hl, BATTLEANIMSTRUCT_XCOORD
	add hl, bc
	ld a, [hl]
	cp $80
	jr c, .SetCoords
	call BattleAnim_IncAnonJumptableIndex
.one
	call BattleAnim_IncAnonJumptableIndex
	ld hl, BATTLEANIMSTRUCT_VAR1
	add hl, bc
	ld [hl], $0
.two
	ld hl, BATTLEANIMSTRUCT_VAR1
	add hl, bc
	ld a, [hl]
	cp $40
	jr nc, .loop_back
	ld hl, BATTLEANIMSTRUCT_VAR1
	add hl, bc
	ld a, [hl]
	ld d, $18
	xcall Cosine
	sub $18
	sra a
	ld hl, BATTLEANIMSTRUCT_YOFFSET
	add hl, bc
	ld [hl], a
	ld hl, BATTLEANIMSTRUCT_VAR1
	add hl, bc
	ld a, [hl]
	ld d, $18
	xcall Sine
	ld hl, BATTLEANIMSTRUCT_XOFFSET
	add hl, bc
	ld [hl], a
	ld hl, BATTLEANIMSTRUCT_PARAM
	add hl, bc
	ld a, [hl]
	and $f
	ld hl, BATTLEANIMSTRUCT_VAR1
	add hl, bc
	add [hl]
	ld [hl], a
	ret

.loop_back
	ld hl, BATTLEANIMSTRUCT_PARAM
	add hl, bc
	ld a, [hl]
	and $f0
	jr z, .finish
	sub $10
	ld d, a
	ld a, [hl]
	and $f
	or d
	ld [hl], a
	ld hl, BATTLEANIMSTRUCT_JUMPTABLE_INDEX
	add hl, bc
	dec [hl]
	ret

.finish
	call BattleAnim_IncAnonJumptableIndex
.three
	ld hl, BATTLEANIMSTRUCT_XCOORD
	add hl, bc
	ld a, [hl]
	cp $b0
	jmp nc, DeinitBattleAnimation
; fallthrough
.SetCoords:
	ld hl, BATTLEANIMSTRUCT_PARAM
	add hl, bc
	ld a, [hl]
	and $f
	ld hl, BATTLEANIMSTRUCT_XCOORD
	add hl, bc
	add [hl]
	ld [hl], a
	ld hl, BATTLEANIMSTRUCT_PARAM
	add hl, bc
	ld a, [hl]
	and $f
	ld e, a
	srl e
	ld hl, BATTLEANIMSTRUCT_YCOORD
	add hl, bc
.loop
	dec [hl]
	dec e
	jr nz, .loop
	ret

SECTION "BattleAnimFunc_Shake", ROMX

BattleAnimFunc_Shake:
; Object switches position side to side. Obj Param defines how far to move it. Example: Dynamic Punch
; Some objects use this function with a Param of 0
	call BattleAnim_AnonJumptable
.anon_dw
	dw .zero
	dw .one
	dw .two
.zero
	call BattleAnim_IncAnonJumptableIndex
	ld hl, BATTLEANIMSTRUCT_VAR1
	add hl, bc
	ld [hl], $0
	ld hl, BATTLEANIMSTRUCT_PARAM
	add hl, bc
	ld a, [hl]
	and $f
	ld hl, BATTLEANIMSTRUCT_XOFFSET
	add hl, bc
	ld [hl], a
.one
	ld hl, BATTLEANIMSTRUCT_VAR1
	add hl, bc
	ld a, [hl]
	and a
	jr z, .done_one
	dec [hl]
	ret

.done_one
	ld hl, BATTLEANIMSTRUCT_PARAM
	add hl, bc
	ld a, [hl]
	swap a
	and $f
	ld hl, BATTLEANIMSTRUCT_VAR1
	add hl, bc
	ld [hl], a
	ld hl, BATTLEANIMSTRUCT_XOFFSET
	add hl, bc
	ld a, [hl]
	cpl
	inc a
	ld [hl], a
	ret

.two
	jmp DeinitBattleAnimation

SECTION "BattleAnimFunc_FireBlast", ROMX

BattleAnimFunc_FireBlast:
	call BattleAnim_AnonJumptable
.anon_dw
	dw .zero
	dw .one
	dw .two
	dw .three
	dw .four
	dw .five
	dw DoNothing ; .six
	dw .seven
	dw .eight
	dw .nine
.zero
	ld hl, BATTLEANIMSTRUCT_PARAM
	add hl, bc
	ld a, [hl]
	ld hl, BATTLEANIMSTRUCT_JUMPTABLE_INDEX
	add hl, bc
	ld [hl], a
	cp $7
	jr z, .seven
	ld a, BATTLE_ANIM_FRAMESET_BURNED
	jmp ReinitBattleAnimFrameset

.seven
	ld hl, BATTLEANIMSTRUCT_XCOORD
	add hl, bc
	ld a, [hl]
	cp $88
	jr nc, .set_up_eight
	add $2
	ld [hl], a
	ld hl, BATTLEANIMSTRUCT_YCOORD
	add hl, bc
	dec [hl]
	ret

.set_up_eight
	call BattleAnim_IncAnonJumptableIndex
	ld a, BATTLE_ANIM_FRAMESET_EMBER
	call ReinitBattleAnimFrameset
.eight
	ld hl, BATTLEANIMSTRUCT_VAR1
	add hl, bc
	ld a, [hl]
	ld d, $10
	push af
	push de
	xcall Sine
	ld hl, BATTLEANIMSTRUCT_YOFFSET
	add hl, bc
	ld [hl], a
	pop de
	pop af
	xcall Cosine
	ld hl, BATTLEANIMSTRUCT_XOFFSET
	add hl, bc
	ld [hl], a
	ld hl, BATTLEANIMSTRUCT_VAR1
	add hl, bc
	inc [hl]
	ret

.nine
	jmp DeinitBattleAnimation

.one
	; Flame that moves upward
	ld hl, BATTLEANIMSTRUCT_YOFFSET
	add hl, bc
	dec [hl]
	ret

.four
	; Flame that moves down and left
	ld hl, BATTLEANIMSTRUCT_YOFFSET
	add hl, bc
	inc [hl]
.two
	; Flame that moves left
	ld hl, BATTLEANIMSTRUCT_XOFFSET
	add hl, bc
	dec [hl]
	ret

.five
	; Flame that moves down and right
	ld hl, BATTLEANIMSTRUCT_YOFFSET
	add hl, bc
	inc [hl]
.three
	; Flame that moves right
	ld hl, BATTLEANIMSTRUCT_XOFFSET
	add hl, bc
	inc [hl]
	ret

SECTION "BattleAnimFunc_RazorLeaf", ROMX

BattleAnimFunc_RazorLeaf:
	call BattleAnim_AnonJumptable
.anon_dw
	dw .zero
	dw .one
	dw .two
	dw .three
	dw .four
	dw .five
	dw .six
	dw .seven
	dw .eight
.zero
	call BattleAnim_IncAnonJumptableIndex
	ld hl, BATTLEANIMSTRUCT_VAR1
	add hl, bc
	ld [hl], $40
.one
	ld hl, BATTLEANIMSTRUCT_VAR1
	add hl, bc
	ld a, [hl]
	cp $30
	jr nc, .sine_cosine
	call BattleAnim_IncAnonJumptableIndex
	xor a
	ld hl, BATTLEANIMSTRUCT_VAR1
	add hl, bc
	ld [hli], a
	ld [hl], a
	ld a, BATTLE_ANIM_FRAMESET_RAZOR_LEAF_2
	call ReinitBattleAnimFrameset
	ld hl, BATTLEANIMSTRUCT_PARAM
	add hl, bc
	bit 6, [hl]
	ret z
	ld hl, BATTLEANIMSTRUCT_FRAME
	add hl, bc
	ld [hl], $5
	ret

.sine_cosine
	ld hl, BATTLEANIMSTRUCT_PARAM
	add hl, bc
	ld a, [hl]
	and $3f
	ld d, a
	ld hl, BATTLEANIMSTRUCT_VAR1
	add hl, bc
	ld a, [hl]
	dec [hl]
	xcall Sine
	ld hl, BATTLEANIMSTRUCT_YOFFSET
	add hl, bc
	ld [hl], a
	call BattleAnim_ScatterHorizontal
	ld hl, BATTLEANIMSTRUCT_VAR2
	add hl, bc
	ld a, [hl]
	ld hl, BATTLEANIMSTRUCT_XCOORD
	add hl, bc
	ld h, [hl]
	ld l, a
	add hl, de
	ld e, l
	ld d, h
	ld hl, BATTLEANIMSTRUCT_XCOORD
	add hl, bc
	ld [hl], d
	ld hl, BATTLEANIMSTRUCT_VAR2
	add hl, bc
	ld [hl], e
	ret

.two
	ld hl, BATTLEANIMSTRUCT_YOFFSET
	add hl, bc
	ld a, [hl]
	cp $20
	jmp z, DeinitBattleAnimation
	ld hl, BATTLEANIMSTRUCT_VAR1
	add hl, bc
	ld a, [hl]
	ld d, $10
	xcall Sine
	ld hl, BATTLEANIMSTRUCT_XOFFSET
	add hl, bc
	ld [hl], a
	ld hl, BATTLEANIMSTRUCT_PARAM
	add hl, bc
	bit 6, [hl]
	jr nz, .decrease
	ld hl, BATTLEANIMSTRUCT_VAR1
	add hl, bc
	inc [hl]
	jr .finish

.decrease
	ld hl, BATTLEANIMSTRUCT_VAR1
	add hl, bc
	dec [hl]
.finish
	ld de, $80
	ld hl, BATTLEANIMSTRUCT_VAR2
	add hl, bc
	ld a, [hl]
	ld hl, BATTLEANIMSTRUCT_YOFFSET
	add hl, bc
	ld h, [hl]
	ld l, a
	add hl, de
	ld e, l
	ld d, h
	ld hl, BATTLEANIMSTRUCT_YOFFSET
	add hl, bc
	ld [hl], d
	ld hl, BATTLEANIMSTRUCT_VAR2
	add hl, bc
	ld [hl], e
	ret

.three
	ld a, BATTLE_ANIM_FRAMESET_RAZOR_LEAF_1
	call ReinitBattleAnimFrameset
	ld hl, BATTLEANIMSTRUCT_OAMFLAGS
	add hl, bc
	res 5, [hl]
.four
.five
.six
.seven
	jmp BattleAnim_IncAnonJumptableIndex

.eight
	ld hl, BATTLEANIMSTRUCT_XCOORD
	add hl, bc
	ld a, [hl]
	cp $c0
	ret nc
	ld a, $8
	jmp BattleAnim_StepToTarget

SECTION "BattleAnimFunc_RockSmash", ROMX

BattleAnimFunc_RockSmash:
; Object moves at an arc
; Obj Param: Bit 7 makes arc flip horizontally
;            Bit 6 defines offset from base frameset FRAMESET_19
;            Rest defines arc radius
	call BattleAnim_AnonJumptable
.anon_dw
	dw .zero
	dw .one
.zero
	ld hl, BATTLEANIMSTRUCT_PARAM
	add hl, bc
	ld a, [hl]
	and $40
	rlca
	rlca
	add BATTLE_ANIM_FRAMESET_BIG_ROCK_STAR_HEART
	ld hl, BATTLEANIMSTRUCT_FRAMESET_ID
	add hl, bc
	ld [hl], a
.after_frameset
	call BattleAnim_IncAnonJumptableIndex
	ld hl, BATTLEANIMSTRUCT_VAR1
	add hl, bc
	ld [hl], $40
.one
	ld hl, BATTLEANIMSTRUCT_VAR1
	add hl, bc
	ld a, [hl]
	cp $30
	jmp c, DeinitBattleAnimation
	ld hl, BATTLEANIMSTRUCT_PARAM
	add hl, bc
	ld a, [hl]
	and $3f
	ld d, a
	ld hl, BATTLEANIMSTRUCT_VAR1
	add hl, bc
	ld a, [hl]
	dec [hl]
	xcall Sine
	ld hl, BATTLEANIMSTRUCT_YOFFSET
	add hl, bc
	ld [hl], a
	call BattleAnim_ScatterHorizontal
	ld hl, BATTLEANIMSTRUCT_VAR2
	add hl, bc
	ld a, [hl]
	ld hl, BATTLEANIMSTRUCT_XCOORD
	add hl, bc
	ld h, [hl]
	ld l, a
	add hl, de
	ld e, l
	ld d, h
	ld hl, BATTLEANIMSTRUCT_XCOORD
	add hl, bc
	ld [hl], d
	ld hl, BATTLEANIMSTRUCT_VAR2
	add hl, bc
	ld [hl], e
	ret

BattleAnimFunc_BubbleSplash:
	call BattleAnim_AnonJumptable

	dw BattleAnimFunc_RockSmash.after_frameset
	dw BattleAnimFunc_RockSmash.one

SECTION "BattleAnimFunc_Bubble", ROMX

BattleAnimFunc_Bubble:
	call BattleAnim_AnonJumptable
.anon_dw
	dw .zero
	dw .one
	dw .two
.zero
	call BattleAnim_IncAnonJumptableIndex
	ld hl, BATTLEANIMSTRUCT_VAR1
	add hl, bc
	ld [hl], $c
.one
	ld hl, BATTLEANIMSTRUCT_VAR1
	add hl, bc
	ld a, [hl]
	and a
	jr z, .next
	dec [hl]
	ld hl, BATTLEANIMSTRUCT_PARAM
	add hl, bc
	ld a, [hl]
	jmp BattleAnim_StepToTarget

.next
	call BattleAnim_IncAnonJumptableIndex
	ld hl, BATTLEANIMSTRUCT_VAR1
	add hl, bc
	ld [hl], $0
	ld a, BATTLE_ANIM_FRAMESET_PULSING_BUBBLE
	call ReinitBattleAnimFrameset
.two
	ld hl, BATTLEANIMSTRUCT_XCOORD
	add hl, bc
	ld a, [hl]
	cp $98
	jr nc, .okay
	ld hl, BATTLEANIMSTRUCT_VAR1
	add hl, bc
	ld a, [hl]
	ld hl, BATTLEANIMSTRUCT_XCOORD
	add hl, bc
	ld h, [hl]
	ld l, a
	ld de, $60
	add hl, de
	ld e, l
	ld d, h
	ld hl, BATTLEANIMSTRUCT_VAR1
	add hl, bc
	ld [hl], e
	ld hl, BATTLEANIMSTRUCT_XCOORD
	add hl, bc
	ld [hl], d
.okay
	ld hl, BATTLEANIMSTRUCT_YCOORD
	add hl, bc
	ld a, [hl]
	cp $20
	ret c
	ld hl, BATTLEANIMSTRUCT_PARAM
	add hl, bc
	ld a, [hl]
	and $f0
	ld e, a
	ld d, $ff
	ld hl, BATTLEANIMSTRUCT_VAR2
	add hl, bc
	ld a, [hl]
	ld hl, BATTLEANIMSTRUCT_YCOORD
	add hl, bc
	ld h, [hl]
	ld l, a
	add hl, de
	ld e, l
	ld d, h
	ld hl, BATTLEANIMSTRUCT_VAR2
	add hl, bc
	ld [hl], e
	ld hl, BATTLEANIMSTRUCT_YCOORD
	add hl, bc
	ld [hl], d
	ret

SECTION "BattleAnimFunc_Surf", ROMX

BattleAnimFunc_Surf:
	call BattleAnim_AnonJumptable
.anon_dw
	dw .zero
	dw .one
	dw DoNothing ; .two
	dw .three
	dw .four
.zero
	call BattleAnim_IncAnonJumptableIndex
	ld hl, rIE
	set LCD_STAT, [hl]
	ld a, LOW(rSCY)
	ldh [hLCDCPointer], a
	ld a, $58
	ldh [hLYOverrideStart], a
	ld a, $5e
	ldh [hLYOverrideEnd], a
	ret

.one
	ld hl, BATTLEANIMSTRUCT_PARAM
	add hl, bc
	ld e, [hl]
	ld hl, BATTLEANIMSTRUCT_YCOORD
	add hl, bc
	ld a, [hl]
	cp e
	jr nc, .move
	call BattleAnim_IncAnonJumptableIndex
	xor a
	ldh [hLYOverrideStart], a
	ret

.move
	dec a
	ld [hl], a
	ld hl, BATTLEANIMSTRUCT_VAR1
	add hl, bc
	ld a, [hl]
	ld d, $10
	xcall Sine
	ld hl, BATTLEANIMSTRUCT_YOFFSET
	add hl, bc
	ld [hl], a
	ld hl, BATTLEANIMSTRUCT_YCOORD
	add hl, bc
	add [hl]
	sub $10
	ret c
	ldh [hLYOverrideStart], a
	ld hl, BATTLEANIMSTRUCT_XOFFSET
	add hl, bc
	ld a, [hl]
	inc a
	and $7
	ld [hl], a
	ld hl, BATTLEANIMSTRUCT_VAR1
	add hl, bc
	inc [hl]
	inc [hl]
	ret

.three
	ld hl, BATTLEANIMSTRUCT_YCOORD
	add hl, bc
	ld a, [hl]
	cp $70
	jr c, .move_down
	ld hl, rIE
	res LCD_STAT, [hl]
	xor a
	ldh [hLCDCPointer], a
	ldh [hLYOverrideStart], a
	ldh [hLYOverrideEnd], a
.four
	jmp DeinitBattleAnimation

.move_down
	inc a
	inc a
	ld [hl], a
	sub $10
	ret c
	ldh [hLYOverrideStart], a
	ret

SECTION "BattleAnimFunc_Sing", ROMX

BattleAnimFunc_Sing:
	call BattleAnim_AnonJumptable
.anon_dw
	dw .zero
	dw .one

.zero
	call BattleAnim_IncAnonJumptableIndex
	ld hl, BATTLEANIMSTRUCT_PARAM
	add hl, bc
	ld a, BATTLE_ANIM_FRAMESET_MUSIC_NOTE_1
	assert BATTLE_ANIM_FRAMESET_MUSIC_NOTE_1 + 1 == BATTLE_ANIM_FRAMESET_MUSIC_NOTE_2 \
		&& BATTLE_ANIM_FRAMESET_MUSIC_NOTE_2 + 1 == BATTLE_ANIM_FRAMESET_MUSIC_NOTE_3
	add [hl]
	call ReinitBattleAnimFrameset

.one
	ld hl, BATTLEANIMSTRUCT_XCOORD
	add hl, bc
	ld a, [hl]
	cp $b8
	jmp nc, DeinitBattleAnimation
	ld a, $2
	call BattleAnim_StepToTarget
	ld hl, BATTLEANIMSTRUCT_VAR1
	add hl, bc
	ld a, [hl]
	dec [hl]
	ld d, $8
	xcall Sine
	ld hl, BATTLEANIMSTRUCT_YOFFSET
	add hl, bc
	ld [hl], a
	ret

SECTION "BattleAnimFunc_WaterGun", ROMX

BattleAnimFunc_WaterGun:
	call BattleAnim_AnonJumptable
.anon_dw
	dw .zero
	dw .one
	dw .two
	dw DoNothing ; .three

.zero
	call BattleAnim_IncAnonJumptableIndex
.one
	ld hl, BATTLEANIMSTRUCT_YCOORD
	add hl, bc
	ld a, [hl]
	cp $30
	jr c, .run_down
	ld a, $2
	call BattleAnim_StepToTarget
	ld hl, BATTLEANIMSTRUCT_VAR1
	add hl, bc
	ld a, [hl]
	dec [hl]
	ld d, $8
	xcall Sine
	ld hl, BATTLEANIMSTRUCT_YOFFSET
	add hl, bc
	ld [hl], a
	ret

.run_down
	call BattleAnim_IncAnonJumptableIndex
	ld a, BATTLE_ANIM_FRAMESET_WATER_GUN_2
	call ReinitBattleAnimFrameset
	ld hl, BATTLEANIMSTRUCT_YOFFSET
	add hl, bc
	ld [hl], $0
	ld hl, BATTLEANIMSTRUCT_YCOORD
	add hl, bc
	ld [hl], $30
	ld hl, BATTLEANIMSTRUCT_OAMFLAGS
	add hl, bc
	ld a, [hl]
	and $1
	ld [hl], a
.two
	ld hl, BATTLEANIMSTRUCT_YOFFSET
	add hl, bc
	ld a, [hl]
	cp $18
	jr nc, .splash
	inc [hl]
	ret

.splash
	call BattleAnim_IncAnonJumptableIndex
	ld a, BATTLE_ANIM_FRAMESET_WATER_GUN_3
	jmp ReinitBattleAnimFrameset

SECTION "BattleAnimFunc_Powder", ROMX

BattleAnimFunc_Powder:
; Obj moves down and disappears at x coord $38
	ld hl, BATTLEANIMSTRUCT_YOFFSET
	add hl, bc
	ld a, [hl]
	cp $38
	jmp nc, DeinitBattleAnimation
	ld a, [hl]
	ld hl, BATTLEANIMSTRUCT_VAR1
	add hl, bc
	ld l, [hl]
	ld h, a
	ld de, $80
	add hl, de
	ld e, l
	ld d, h
	ld hl, BATTLEANIMSTRUCT_VAR1
	add hl, bc
	ld [hl], e
	ld hl, BATTLEANIMSTRUCT_YOFFSET
	add hl, bc
	ld [hl], d
	; Shakes object back and forth 16 pixels
	ld hl, BATTLEANIMSTRUCT_XOFFSET
	add hl, bc
	ld a, [hl]
	xor $10
	ld [hl], a
	ret

SECTION "BattleAnimFunc_Recover", ROMX

BattleAnimFunc_Recover:
; Obj moves in an ever shrinking circle. Obj Param defines initial position in the circle
	call BattleAnim_AnonJumptable
.anon_dw
	dw .zero
	dw .one

.zero
	call BattleAnim_IncAnonJumptableIndex
	ld hl, BATTLEANIMSTRUCT_PARAM
	add hl, bc
	ld a, [hl]
	and $f0
	ld hl, BATTLEANIMSTRUCT_VAR2
	add hl, bc
	ld [hl], a
	ld hl, BATTLEANIMSTRUCT_PARAM
	add hl, bc
	ld a, [hl]
	and $f
	add a
	add a
	add a
	ld hl, BATTLEANIMSTRUCT_VAR1
	add hl, bc
	ld [hl], a
	ld hl, BATTLEANIMSTRUCT_PARAM
	add hl, bc
	ld [hl], $1
.one
	ld hl, BATTLEANIMSTRUCT_VAR2
	add hl, bc
	ld a, [hl]
	and a
	jmp z, DeinitBattleAnimation
	ld hl, BATTLEANIMSTRUCT_VAR1
	add hl, bc
	ld a, [hl]
	inc [hl]
	ld hl, BATTLEANIMSTRUCT_VAR2
	add hl, bc
	ld d, [hl]
	push af
	push de
	xcall Sine
	ld hl, BATTLEANIMSTRUCT_YOFFSET
	add hl, bc
	ld [hl], a
	pop de
	pop af
	xcall Cosine
	ld hl, BATTLEANIMSTRUCT_XOFFSET
	add hl, bc
	ld [hl], a
	ld hl, BATTLEANIMSTRUCT_PARAM
	add hl, bc
	ld a, [hl]
	xor $1
	ld [hl], a
	ret z
	ld hl, BATTLEANIMSTRUCT_VAR2
	add hl, bc
	dec [hl]
	ret

SECTION "BattleAnimFunc_ThunderWave", ROMX

BattleAnimFunc_ThunderWave:
	call BattleAnim_AnonJumptable
.anon_dw
	dw DoNothing ; .zero
	dw .one
	dw DoNothing ; .two
	dw .three

.one
	call BattleAnim_IncAnonJumptableIndex
	ld a, BATTLE_ANIM_FRAMESET_THUNDER_WAVE_EXTRA
	jmp ReinitBattleAnimFrameset

.three
	jmp DeinitBattleAnimation

SECTION "BattleAnimFunc_Clamp_Encore", ROMX

BattleAnimFunc_Clamp_Encore:
; Claps two objects together, twice. Also used by Encore
; Second object's frameset and position relative to first are both defined via this function
; Obj Param: Distance from center (masked with $7F). Bit 7 flips object horizontally by switching to a different frameset
	call BattleAnim_AnonJumptable
.anon_dw
	dw .zero
	dw .one
	dw .two
	dw .three
	dw .four
	dw .five
	dw .six

.zero
	call BattleAnim_IncAnonJumptableIndex
	ld hl, BATTLEANIMSTRUCT_FRAMESET_ID
	add hl, bc
	ld a, [hl]
	ld hl, BATTLEANIMSTRUCT_VAR2
	add hl, bc
	ld [hl], a
	ld hl, BATTLEANIMSTRUCT_PARAM
	add hl, bc
	bit 7, [hl]
	jr nz, .flipped
	ld hl, BATTLEANIMSTRUCT_VAR1
	add hl, bc
	ld [hl], $10
	jr .got_sine_start

.flipped
	ld hl, BATTLEANIMSTRUCT_VAR1
	add hl, bc
	ld [hl], $30
.got_sine_start
	ld hl, BATTLEANIMSTRUCT_PARAM
	add hl, bc
	ld a, [hl]
	and $7f
	ld [hl], a
.one
	ld hl, BATTLEANIMSTRUCT_VAR1
	add hl, bc
	ld a, [hl]
	ld hl, BATTLEANIMSTRUCT_PARAM
	add hl, bc
	ld d, [hl]
	xcall Sine
	ld hl, BATTLEANIMSTRUCT_XOFFSET
	add hl, bc
	ld [hl], a
	bit 7, a
	jr nz, .load_no_inc
	ld hl, BATTLEANIMSTRUCT_VAR2
	add hl, bc
	ld a, [hl]
	assert BATTLE_ANIM_FRAMESET_CLAMP + 1 ==  BATTLE_ANIM_FRAMESET_CLAMP_FLIPPED
	assert BATTLE_ANIM_FRAMESET_ENCORE_HAND + 1 == BATTLE_ANIM_FRAMESET_ENCORE_HAND_FLIPPED
	inc a
	jr .reinit

.load_no_inc
	ld hl, BATTLEANIMSTRUCT_VAR2
	add hl, bc
	ld a, [hl] ; BATTLE_ANIM_FRAMESET_CLAMP or BATTLE_ANIM_FRAMESET_ENCORE_HAND
.reinit
	call ReinitBattleAnimFrameset
	ld hl, BATTLEANIMSTRUCT_VAR1
	add hl, bc
	inc [hl]
	ld a, [hl]
	and $1f
	ret nz
.two
.three
.four
.five
	jmp BattleAnim_IncAnonJumptableIndex

.six
	ld hl, BATTLEANIMSTRUCT_JUMPTABLE_INDEX
	add hl, bc
	ld [hl], $1
	ret

SECTION "BattleAnimFunc_Bite", ROMX

BattleAnimFunc_Bite:
; Claps two objects together (vertically), twice
; Second object's frameset and position relative to first are both defined via this function
; Obj Param: Distance from center (masked with $7F). Bit 7 flips object vertically by switching to a different frameset
	call BattleAnim_AnonJumptable
.anon_dw
	dw .zero
	dw .one
	dw .two
	dw .three
	dw .four
	dw .five
	dw .six

.zero
	call BattleAnim_IncAnonJumptableIndex
	ld hl, BATTLEANIMSTRUCT_PARAM
	add hl, bc
	bit 7, [hl]
	jr nz, .flipped
	ld hl, BATTLEANIMSTRUCT_VAR1
	add hl, bc
	ld [hl], $10
	jr .got_sine_start

.flipped
	ld hl, BATTLEANIMSTRUCT_VAR1
	add hl, bc
	ld [hl], $30
.got_sine_start
	ld hl, BATTLEANIMSTRUCT_PARAM
	add hl, bc
	ld a, [hl]
	and $7f
	ld [hl], a

.one
	ld hl, BATTLEANIMSTRUCT_VAR1
	add hl, bc
	ld a, [hl]
	ld hl, BATTLEANIMSTRUCT_PARAM
	add hl, bc
	ld d, [hl]
	xcall Sine
	ld hl, BATTLEANIMSTRUCT_YOFFSET
	add hl, bc
	ld [hl], a
	bit 7, a
	ld a, BATTLE_ANIM_FRAMESET_BITE_2
	jr z, .got_frameset
	ld a, BATTLE_ANIM_FRAMESET_BITE_1
.got_frameset
	call ReinitBattleAnimFrameset
	ld hl, BATTLEANIMSTRUCT_VAR1
	add hl, bc
	inc [hl]
	inc [hl]
	ld a, [hl]
	and $1f
	ret nz

.two
.three
.four
.five
	jmp BattleAnim_IncAnonJumptableIndex

.six
	ld hl, BATTLEANIMSTRUCT_JUMPTABLE_INDEX
	add hl, bc
	ld [hl], $1
	ret

SECTION "BattleAnimFunc_SolarBeam", ROMX

BattleAnimFunc_SolarBeam:
; Solar Beam charge up animation
	call BattleAnim_AnonJumptable
.anon_dw
	dw .zero
	dw .one

.zero
	call BattleAnim_IncAnonJumptableIndex
	ld hl, BATTLEANIMSTRUCT_VAR1
	add hl, bc
	ld a, $28
	ld [hli], a
	ld [hl], $0
.one
	ld hl, BATTLEANIMSTRUCT_PARAM
	add hl, bc
	ld a, [hl]
	ld hl, BATTLEANIMSTRUCT_VAR1
	add hl, bc
	ld d, [hl]
	push af
	push de
	xcall Sine
	ld hl, BATTLEANIMSTRUCT_YOFFSET
	add hl, bc
	ld [hl], a
	pop de
	pop af
	xcall Cosine
	ld hl, BATTLEANIMSTRUCT_XOFFSET
	add hl, bc
	ld [hl], a
	ld hl, BATTLEANIMSTRUCT_VAR1
	add hl, bc
	ld a, [hl]
	and a
	jr z, .zero_radius
	ld d, a
	ld hl, BATTLEANIMSTRUCT_VAR2
	add hl, bc
	ld e, [hl]
	ld hl, -$80
	add hl, de
	ld e, l
	ld d, h
	ld hl, BATTLEANIMSTRUCT_VAR2
	add hl, bc
	ld [hl], e
	ld hl, BATTLEANIMSTRUCT_VAR1
	add hl, bc
	ld [hl], d
	ret

.zero_radius
	jmp DeinitBattleAnimation

SECTION "BattleAnimFunc_Gust", ROMX

BattleAnimFunc_Gust:
	call BattleAnim_AnonJumptable
.anon_dw
	dw .zero
	dw .GustWobble
	dw .two
	dw .GustWobble
	dw .four

.zero
	call BattleAnim_IncAnonJumptableIndex
	ld hl, BATTLEANIMSTRUCT_PARAM
	add hl, bc
	ld [hl], 0
	jr .GustWobble

.two
	ld hl, BATTLEANIMSTRUCT_XCOORD
	add hl, bc
	ld a, [hl]
	cp $88
	jr c, .move
	jmp BattleAnim_IncAnonJumptableIndex

.four
	ld hl, BATTLEANIMSTRUCT_XCOORD
	add hl, bc
	ld a, [hl]
	cp $b8
	jmp nc, DeinitBattleAnimation
; fallthrough
.move
	call .GustWobble
	; Move horizontally every frame
	ld hl, BATTLEANIMSTRUCT_XCOORD
	add hl, bc
	inc [hl]
	ld a, [hl]
	; Move in the vertically every other frame
	and $1
	ret nz
	ld hl, BATTLEANIMSTRUCT_YCOORD
	add hl, bc
	dec [hl]
	ret

.GustWobble:
	; Circular movement where width is retrieved from a list, and height is 1/16 of that
	call .GetGustRadius
	ld hl, BATTLEANIMSTRUCT_VAR1
	add hl, bc
	ld a, [hl]
	push af
	push de
	xcall Sine
	sra a
	sra a
	sra a
	sra a
	ld hl, BATTLEANIMSTRUCT_PARAM
	add hl, bc
	add [hl]
	ld hl, BATTLEANIMSTRUCT_YOFFSET
	add hl, bc
	ld [hl], a
	pop de
	pop af
	xcall Cosine
	ld hl, BATTLEANIMSTRUCT_XOFFSET
	add hl, bc
	ld [hl], a
	ld hl, BATTLEANIMSTRUCT_VAR1
	add hl, bc
	ld a, [hl]
	sub $8
	ld [hl], a
	ld hl, BATTLEANIMSTRUCT_PARAM
	add hl, bc
	ld a, [hl]
	and a
	jr z, .start_wobble
	cp $c2
	jr c, .finish_wobble
.start_wobble
	dec a
	ld [hl], a
	and $7
	ret nz
	ld hl, BATTLEANIMSTRUCT_VAR2
	add hl, bc
	inc [hl]
	ret

.finish_wobble
	xor a
	ld hl, BATTLEANIMSTRUCT_VAR2
	add hl, bc
	ld [hl], a
	ld hl, BATTLEANIMSTRUCT_PARAM
	add hl, bc
	ld [hl], a
	ld hl, BATTLEANIMSTRUCT_XOFFSET
	add hl, bc
	ld [hli], a
	ld [hl], a
	ret

.GetGustRadius:
	ld hl, BATTLEANIMSTRUCT_VAR2
	add hl, bc
	ld e, [hl]
	ld d, 0
	ld hl, .GustOffsets
	add hl, de
	ld d, [hl]
	ret

.GustOffsets:
	db 8, 6, 5, 4, 5, 6, 8, 12, 16

SECTION "BattleAnimFunc_Absorb", ROMX

BattleAnimFunc_Absorb:
; Moves object from target to user and disappears when reaches x coord $30. Example: Absorb, Mega Drain, Leech Seed status
; Obj Param: Speed in the X axis
	ld hl, BATTLEANIMSTRUCT_XCOORD
	add hl, bc
	ld a, [hl]
	cp $30
	jmp c, DeinitBattleAnimation
	ld hl, BATTLEANIMSTRUCT_PARAM
	add hl, bc
	ld a, [hl]
	and $f
	ld e, a
	ld hl, BATTLEANIMSTRUCT_XCOORD
	add hl, bc
	ld a, [hl]
	sub e
	ld [hl], a
	srl e
	ld hl, BATTLEANIMSTRUCT_YCOORD
	add hl, bc
.loop
	inc [hl]
	dec e
	jr nz, .loop
	ret

SECTION "BattleAnimFunc_Wrap", ROMX

BattleAnimFunc_Wrap:
; Plays out object frameset. Use anim_incobj to move to next frameset
	call BattleAnim_AnonJumptable
.anon_dw
	dw DoNothing ; .zero
	dw .one
	dw DoNothing ; .two

.one
	ld hl, BATTLEANIMSTRUCT_FRAMESET_ID
	add hl, bc
	ld a, [hl]
	assert BATTLE_ANIM_FRAMESET_BIND_1 + 1 == BATTLE_ANIM_FRAMESET_BIND_2 \
		&& BATTLE_ANIM_FRAMESET_BIND_2 + 1 == BATTLE_ANIM_FRAMESET_BIND_3 \
		&& BATTLE_ANIM_FRAMESET_BIND_3 + 1 == BATTLE_ANIM_FRAMESET_BIND_4
	inc a
	call ReinitBattleAnimFrameset
	call BattleAnim_IncAnonJumptableIndex
	ld hl, BATTLEANIMSTRUCT_VAR1 ; Unused?
	add hl, bc
	ld [hl], $8
	ret

SECTION "BattleAnimFunc_LeechSeed", ROMX

BattleAnimFunc_LeechSeed:
	call BattleAnim_AnonJumptable
.anon_dw
	dw .zero
	dw .one
	dw .two
	dw DoNothing ; .three
.zero
	call BattleAnim_IncAnonJumptableIndex
	ld hl, BATTLEANIMSTRUCT_VAR2
	add hl, bc
	ld [hl], $40
	ret

.one
	ld hl, BATTLEANIMSTRUCT_VAR2
	add hl, bc
	ld a, [hl]
	cp $20
	jmp nc, BattleAnim_StepThrownToTarget
	ld [hl], $40
	ld a, BATTLE_ANIM_FRAMESET_LEECH_SEED_2
	call ReinitBattleAnimFrameset
	jmp BattleAnim_IncAnonJumptableIndex

.two
	ld hl, BATTLEANIMSTRUCT_VAR2
	add hl, bc
	ld a, [hl]
	and a
	jr z, .flutter
	dec [hl]
	ret

.flutter
	call BattleAnim_IncAnonJumptableIndex
	ld a, BATTLE_ANIM_FRAMESET_LEECH_SEED_3
	jmp ReinitBattleAnimFrameset

SECTION "BattleAnimFunc_Spikes", ROMX

BattleAnimFunc_Spikes:
; Object is thrown at target. After $20 frames it stops and waits another $20 frames then disappear
	call BattleAnim_AnonJumptable
.anon_dw
	dw .zero
	dw .one
	dw DoNothing ; .two

.zero
	call BattleAnim_IncAnonJumptableIndex
	ld hl, BATTLEANIMSTRUCT_VAR2
	add hl, bc
	ld [hl], $40
	ret

.one
	ld hl, BATTLEANIMSTRUCT_VAR2
	add hl, bc
	ld a, [hl]
	cp $20
	jmp nc, BattleAnim_StepThrownToTarget
	jmp BattleAnim_IncAnonJumptableIndex

SECTION "BattleAnimFunc_Kick", ROMX

BattleAnimFunc_Kick:
; Uses anim_setobj for different kick types
	call BattleAnim_AnonJumptable
.anon_dw
	dw DoNothing ; .zero
	dw .one
	dw .two   ; Jump Kick, Hi Jump Kick
	dw .three ; Rolling Kick
	dw .four  ; Rolling Kick (continued)

.one ; Unused?
	ld hl, BATTLEANIMSTRUCT_YCOORD
	add hl, bc
	ld a, [hl]
	cp $30
	jr c, .move_down
	ld hl, BATTLEANIMSTRUCT_JUMPTABLE_INDEX
	add hl, bc
	ld [hl], $0
	ret

.move_down
	add $4
	ld [hl], a
	ret

.two
	ld hl, BATTLEANIMSTRUCT_XCOORD
	add hl, bc
	ld a, [hl]
	cp $98
	ret nc
	inc [hl]
	inc [hl]
	ld hl, BATTLEANIMSTRUCT_OAMFLAGS
	add hl, bc
	set 0, [hl]
	ld hl, BATTLEANIMSTRUCT_FIX_Y
	add hl, bc
	ld [hl], $90
	ld hl, BATTLEANIMSTRUCT_FRAME
	add hl, bc
	ld [hl], $0
	ld hl, BATTLEANIMSTRUCT_DURATION
	add hl, bc
	ld [hl], $2
	ld hl, BATTLEANIMSTRUCT_YCOORD
	add hl, bc
	dec [hl]
	ret

.three
	call BattleAnim_IncAnonJumptableIndex
	ld hl, BATTLEANIMSTRUCT_VAR1
	add hl, bc
	ld [hl], $2c
	ld hl, BATTLEANIMSTRUCT_FRAME
	add hl, bc
	ld [hl], $0
	ld hl, BATTLEANIMSTRUCT_DURATION
	add hl, bc
	ld [hl], $80
.four
	ld hl, BATTLEANIMSTRUCT_XCOORD
	add hl, bc
	ld a, [hl]
	cp $98
	ret nc
	inc [hl]
	inc [hl]
	ld hl, BATTLEANIMSTRUCT_VAR1
	add hl, bc
	ld a, [hl]
	inc [hl]
	ld d, $8
	xcall Sine
	ld hl, BATTLEANIMSTRUCT_YOFFSET
	add hl, bc
	ld [hl], a
	ret

SECTION "BattleAnimFunc_Egg", ROMX

BattleAnimFunc_Egg:
; Used by Egg Bomb and Softboiled
; Obj Param: Defines jumptable starting index
	call BattleAnim_AnonJumptable
.anon_dw
	dw .zero
	dw .one ; Egg Bomb start
	dw .two
	dw .three
	dw DoNothing ; .four ; ret
	dw .five
	dw .six ; Softboiled obj 1 start
	dw .seven
	dw .eight
	dw .nine
	dw DoNothing ; .ten ; ret
	dw .eleven ; Softboiled obj 2 start
	dw .twelve
	dw DoNothing ; .thirteen ; ret

.zero
	; Object starts here then jumps to the jumptable index defined by the Obj Param
	ld hl, BATTLEANIMSTRUCT_VAR1
	add hl, bc
	ld a, $28
	ld [hli], a
	ld [hl], $10 ; BATTLEANIMSTRUCT_VAR2
	ld hl, BATTLEANIMSTRUCT_PARAM
	add hl, bc
	ld a, [hl]
	ld hl, BATTLEANIMSTRUCT_JUMPTABLE_INDEX
	add hl, bc
	ld [hl], a
	ret

.one
	; Initial Egg Bomb arc movement to x coord $40
	ld hl, BATTLEANIMSTRUCT_XCOORD
	add hl, bc
	ld a, [hl]
	cp $40
	jr nc, .egg_bomb_vertical_wave
	inc [hl]
.egg_bomb_vertical_wave
	jmp .EggVerticalWaveMotion

.six
	; Initial Softboiled arc movement to x coord $4b
	ld hl, BATTLEANIMSTRUCT_XCOORD
	add hl, bc
	ld a, [hl]
	cp $4b
	jr nc, .softboiled_vertical_wave
	inc [hl]
.softboiled_vertical_wave
	jmp .EggVerticalWaveMotion

.two
	; Compares the egg's x coord to determine whether to move, wait or end animation
	ld hl, BATTLEANIMSTRUCT_XCOORD
	add hl, bc
	ld a, [hl]
	cp $88
	jr nc, .egg_bomb_done
	and $f
	jr nz, .egg_bomb_step
	ld hl, BATTLEANIMSTRUCT_VAR2
	add hl, bc
	ld [hl], $10
	jmp BattleAnim_IncAnonJumptableIndex ; jumps to three

.egg_bomb_done
	; Increases jumptable index twice to four
	call BattleAnim_IncAnonJumptableIndex
	inc [hl]
	ret

.three
	; Waits in place
	ld hl, BATTLEANIMSTRUCT_VAR2
	add hl, bc
	ld a, [hl]
	and a
	jr z, .done_waiting
	dec [hl]
	ret

.done_waiting
	ld hl, BATTLEANIMSTRUCT_JUMPTABLE_INDEX
	add hl, bc
	dec [hl]
.egg_bomb_step
	; Moves towards the target
	ld hl, BATTLEANIMSTRUCT_XCOORD
	add hl, bc
	inc [hl]
	ld hl, BATTLEANIMSTRUCT_YCOORD
	add hl, bc
	ld d, [hl]
	ld hl, BATTLEANIMSTRUCT_VAR1
	add hl, bc
	ld e, [hl]
	ld hl, -$80
	add hl, de
	ld e, l
	ld d, h
	ld hl, BATTLEANIMSTRUCT_YCOORD
	add hl, bc
	ld [hl], d
	ld hl, BATTLEANIMSTRUCT_VAR1
	add hl, bc
	ld [hl], e
	ret

.five
	; Clears Egg Bomb object via anim_incobj
	jmp DeinitBattleAnimation

.seven
	; Switches Softboiled frameset to egg wobbling
	ld a, BATTLE_ANIM_FRAMESET_EGG_WOBBLE ; Egg wobbling
	call ReinitBattleAnimFrameset
	jmp BattleAnim_IncAnonJumptableIndex

.eight
	; Softboiled object waves slightly side to side
	ld hl, BATTLEANIMSTRUCT_VAR1
	add hl, bc
	ld a, [hl]
	inc [hl]
	inc [hl]
	ld d, $2
	xcall Sine
	ld hl, BATTLEANIMSTRUCT_XOFFSET
	add hl, bc
	ld [hl], a
	ret

.nine
	; First Softboiled BATTLE_ANIM_OBJ_EGG turns into the bottom half frameset
	ld a, BATTLE_ANIM_FRAMESET_EGG_CRACKED_BOTTOM ; Cracked egg bottom
	call ReinitBattleAnimFrameset
	ld hl, BATTLEANIMSTRUCT_YOFFSET
	add hl, bc
	ld [hl], $4
	jmp BattleAnim_IncAnonJumptableIndex

.eleven
	; Second Softboiled BATTLE_ANIM_OBJ_EGG
	ld a, BATTLE_ANIM_FRAMESET_EGG_CRACKED_TOP ; Cracked egg top
	call ReinitBattleAnimFrameset
	call BattleAnim_IncAnonJumptableIndex
	ld hl, BATTLEANIMSTRUCT_VAR1
	add hl, bc
	ld [hl], $40
	ret

.twelve
	; Top half of egg moves upward for $30 frames
	ld hl, BATTLEANIMSTRUCT_VAR1
	add hl, bc
	ld a, [hl]
	ld d, $20
	xcall Sine
	ld hl, BATTLEANIMSTRUCT_YOFFSET
	add hl, bc
	ld [hl], a
	ld hl, BATTLEANIMSTRUCT_VAR1
	add hl, bc
	ld a, [hl]
	cp $30
	jr c, .done_top_shell
	dec [hl]
	ret

.done_top_shell
	jmp BattleAnim_IncAnonJumptableIndex

.EggVerticalWaveMotion:
	ld hl, BATTLEANIMSTRUCT_VAR1
	add hl, bc
	ld a, [hli]
	ld d, [hl] ; BATTLEANIMSTRUCT_VAR2
	xcall Sine
	ld hl, BATTLEANIMSTRUCT_YOFFSET
	add hl, bc
	ld [hl], a
	ld hl, BATTLEANIMSTRUCT_VAR1
	add hl, bc
	inc [hl]
	ld a, [hl]
	and $3f ; cp 64
	ret nz
	ld hl, BATTLEANIMSTRUCT_VAR1
	add hl, bc
	ld [hl], $20
	ld hl, BATTLEANIMSTRUCT_VAR2
	add hl, bc
	ld a, [hl]
	sub $8
	ld [hl], a
	ret nz
	xor a
	ld hl, BATTLEANIMSTRUCT_VAR1
	add hl, bc
	ld [hli], a
	ld [hl], a
	jmp BattleAnim_IncAnonJumptableIndex

SECTION "BattleAnimFunc_MoveUp", ROMX

BattleAnimFunc_MoveUp:
; Moves object up for 41 frames
; Obj Param: Movement speed
	ld hl, BATTLEANIMSTRUCT_YOFFSET
	add hl, bc
	ld a, [hl]
	and a
	jr z, .move
	cp $d8
	jmp c, DeinitBattleAnimation
; fallthrough
.move
	ld hl, BATTLEANIMSTRUCT_PARAM
	add hl, bc
	ld d, [hl]
	ld hl, BATTLEANIMSTRUCT_YOFFSET
	add hl, bc
	ld a, [hl]
	sub d
	ld [hl], a
	ret

SECTION "BattleAnimFunc_Sound", ROMX

BattleAnimFunc_Sound:
; Moves object back and forth in one of three angles using a sine behavior and disappear after 8 frames. Used in Growl, Snore and Kinesis
; Obj Param: Used to define object angle. How much to increase from base frameset, which is hardcoded as BATTLE_ANIM_FRAMESET_SOUND_1
	call BattleAnim_AnonJumptable
.anon_dw
	dw .zero
	dw .one

.zero
	ldh a, [hBattleTurn]
	and a
	jr z, .got_turn
	; enemy
	ld hl, BATTLEANIMSTRUCT_PARAM
	add hl, bc
	ld a, [hl]
	cpl
	add $3
	ld [hl], a
.got_turn
	call BattleAnim_IncAnonJumptableIndex
	ld hl, BATTLEANIMSTRUCT_VAR1
	add hl, bc
	ld [hl], $8 ; duration
	ld hl, BATTLEANIMSTRUCT_PARAM
	add hl, bc
	ld a, BATTLE_ANIM_FRAMESET_SOUND_1
	assert BATTLE_ANIM_FRAMESET_SOUND_1 + 1 == BATTLE_ANIM_FRAMESET_SOUND_2 \
		&& BATTLE_ANIM_FRAMESET_SOUND_2 + 1 == BATTLE_ANIM_FRAMESET_SOUND_3
	add [hl]
	jmp ReinitBattleAnimFrameset

.one
	ld hl, BATTLEANIMSTRUCT_VAR1
	add hl, bc
	ld a, [hl]
	and a
	jr z, .done_anim
	dec [hl]
	jr .SoundWaveMotion

.done_anim
	jmp DeinitBattleAnimation

.SoundWaveMotion:
	ld hl, BATTLEANIMSTRUCT_VAR2
	add hl, bc
	ld a, [hl]
	inc [hl]
	inc [hl]
	ld d, $10
	xcall Sine
	ld d, a
	ld hl, BATTLEANIMSTRUCT_XOFFSET
	add hl, bc
	ld [hl], a
	ld hl, BATTLEANIMSTRUCT_PARAM
	add hl, bc
	ld a, [hl]
	and a
	jr z, .negative
	dec a
	ret z
	; Obj Param 2
	ld hl, BATTLEANIMSTRUCT_YOFFSET
	add hl, bc
	ld [hl], d
	ret

.negative
	; Obj Param 0
	ld hl, BATTLEANIMSTRUCT_YOFFSET
	add hl, bc
	ld a, d
	cpl
	inc a
	ld [hl], a
	ret

SECTION "BattleAnimFunc_ConfuseRay", ROMX

BattleAnimFunc_ConfuseRay:
; Creates the Confuse Ray object and moves it across the screen until x coord $80
; Moves horizontally every frame and vertically every 3 frames
	call BattleAnim_AnonJumptable
.anon_dw
	dw .zero
	dw .one

.zero
	call BattleAnim_IncAnonJumptableIndex
	ld hl, BATTLEANIMSTRUCT_PARAM
	add hl, bc
	ld a, [hl]
	and $3f
	ld hl, BATTLEANIMSTRUCT_VAR2
	add hl, bc
	ld [hl], a
	ld hl, BATTLEANIMSTRUCT_PARAM
	add hl, bc
	ld a, [hl]
	and $80
	rlca
	ld [hl], a
	assert BATTLE_ANIM_FRAMESET_CONFUSE_RAY_1 + 1 == BATTLE_ANIM_FRAMESET_CONFUSE_RAY_2
	add BATTLE_ANIM_FRAMESET_CONFUSE_RAY_1
	jmp ReinitBattleAnimFrameset

.one
	ld hl, BATTLEANIMSTRUCT_PARAM
	add hl, bc
	ld a, [hl]
	swap a
	ld d, a
	ld hl, BATTLEANIMSTRUCT_VAR2
	add hl, bc
	ld a, [hl]
	inc [hl]
	push af
	push de
	xcall Sine
	ld hl, BATTLEANIMSTRUCT_YOFFSET
	add hl, bc
	ld [hl], a
	pop de
	pop af
	xcall Cosine
	ld hl, BATTLEANIMSTRUCT_XOFFSET
	add hl, bc
	ld [hl], a
	ld hl, BATTLEANIMSTRUCT_XCOORD
	add hl, bc
	ld a, [hl]
	cp $80
	ret nc
	ld hl, BATTLEANIMSTRUCT_VAR2
	add hl, bc
	ld a, [hl]
	and $3
	jr nz, .skip_vertical_movement
	ld hl, BATTLEANIMSTRUCT_YCOORD
	add hl, bc
	dec [hl]
.skip_vertical_movement
	and $1
	ret nz
	ld hl, BATTLEANIMSTRUCT_XCOORD
	add hl, bc
	inc [hl]
	ret

SECTION "BattleAnimFunc_Dizzy", ROMX

BattleAnimFunc_Dizzy:
; Moves object in a circle where the height is 1/4 the width, with the next frameset from base whether moving left or right. Also used for Nightmare
; Obj Param: Defines starting position in the circle (masked with $80). Bit 7 flips it at the start
	call BattleAnim_AnonJumptable
.anon_dw
	dw .zero
	dw .one

.zero
	call BattleAnim_IncAnonJumptableIndex
	ld hl, BATTLEANIMSTRUCT_FRAMESET_ID
	add hl, bc
	ld a, [hl]
	ld hl, BATTLEANIMSTRUCT_VAR1
	add hl, bc
	ld [hl], a
	ld hl, BATTLEANIMSTRUCT_PARAM
	add hl, bc
	ld a, [hl]
	and $80
	rlca
	ld hl, BATTLEANIMSTRUCT_VAR1
	add hl, bc
	assert BATTLE_ANIM_FRAMESET_CHICK_1 + 1 ==  BATTLE_ANIM_FRAMESET_CHICK_2
	assert BATTLE_ANIM_FRAMESET_IMP + 1 == BATTLE_ANIM_FRAMESET_IMP_FLIPPED
	add [hl]
	call ReinitBattleAnimFrameset
	ld hl, BATTLEANIMSTRUCT_PARAM
	add hl, bc
	ld a, [hl]
	and $7f
	ld [hl], a
.one
	ld hl, BATTLEANIMSTRUCT_PARAM
	add hl, bc
	ld a, [hl]
	ld d, $10
	push af
	push de
	xcall Sine
	sra a
	sra a
	ld hl, BATTLEANIMSTRUCT_YOFFSET
	add hl, bc
	ld [hl], a
	pop de
	pop af
	xcall Cosine
	ld hl, BATTLEANIMSTRUCT_XOFFSET
	add hl, bc
	ld [hl], a
	ld hl, BATTLEANIMSTRUCT_PARAM
	add hl, bc
	ld a, [hl]
	inc [hl]
	and $3f
	jr z, .not_flipped
	and $1f
	ret nz
	ld hl, BATTLEANIMSTRUCT_VAR1
	add hl, bc
	ld a, [hl]
	assert BATTLE_ANIM_FRAMESET_CHICK_1 + 1 ==  BATTLE_ANIM_FRAMESET_CHICK_2
	assert BATTLE_ANIM_FRAMESET_IMP + 1 == BATTLE_ANIM_FRAMESET_IMP_FLIPPED
	inc a
	jr .got_frameset

.not_flipped
	ld hl, BATTLEANIMSTRUCT_VAR1
	add hl, bc
	ld a, [hl] ; BATTLE_ANIM_FRAMESET_CHICK_1 or BATTLE_ANIM_FRAMESET_IMP
.got_frameset
	jmp ReinitBattleAnimFrameset

SECTION "BattleAnimFunc_Amnesia", ROMX

BattleAnimFunc_Amnesia:
; Creates 3 objects based on Obj Param
; Obj Param: How much to increase from base frameset, which is hardcoded as BATTLE_ANIM_FRAMESET_AMNESIA_1
; anim_incobj is used to DeInit object (used by Present)
	call BattleAnim_AnonJumptable
.anon_dw
	dw .zero
	dw DoNothing ; .one
	dw .two

.zero
	call BattleAnim_IncAnonJumptableIndex
	ld hl, BATTLEANIMSTRUCT_PARAM
	add hl, bc
	ld a, [hl]
	assert BATTLE_ANIM_FRAMESET_AMNESIA_1 + 1 == BATTLE_ANIM_FRAMESET_AMNESIA_2 \
		&& BATTLE_ANIM_FRAMESET_AMNESIA_2 + 1 == BATTLE_ANIM_FRAMESET_AMNESIA_3_RECOVER
	add BATTLE_ANIM_FRAMESET_AMNESIA_1
	call ReinitBattleAnimFrameset
	ld hl, BATTLEANIMSTRUCT_PARAM
	add hl, bc
	ld e, [hl]
	ld d, 0
	ld hl, .AmnesiaOffsets
	add hl, de
	ld a, [hl]
	ld hl, BATTLEANIMSTRUCT_YOFFSET
	add hl, bc
	ld [hl], a
	ret

.two
	; anim_incobj forces obj to deinit
	jmp DeinitBattleAnimation

.AmnesiaOffsets: ; Hardcoded Y Offsets for each Obj Param
	db $ec, $f8, $00

SECTION "BattleAnimFunc_FloatUp", ROMX

BattleAnimFunc_FloatUp:
; Object moves horizontally in a sine wave, while also moving up. Also used by Charm and the Nightmare status
	ld hl, BATTLEANIMSTRUCT_VAR1
	add hl, bc
	ld a, [hl]
	inc [hl]
	inc [hl]
	ld d, $4
	xcall Sine
	ld hl, BATTLEANIMSTRUCT_XOFFSET
	add hl, bc
	ld [hl], a
	ld hl, BATTLEANIMSTRUCT_YOFFSET
	add hl, bc
	ld d, [hl]
	ld hl, BATTLEANIMSTRUCT_VAR2
	add hl, bc
	ld e, [hl]
	lb hl, -1, $a0
	add hl, de
	ld e, l
	ld d, h
	ld hl, BATTLEANIMSTRUCT_YOFFSET
	add hl, bc
	ld [hl], d
	ld hl, BATTLEANIMSTRUCT_VAR2
	add hl, bc
	ld [hl], e
	ret

SECTION "BattleAnimFunc_Dig", ROMX

BattleAnimFunc_Dig:
; Object moves up then down with a wave motion, while also moving away from the user 1 pixel per frame
	ld hl, BATTLEANIMSTRUCT_VAR1
	add hl, bc
	ld a, [hl]
	dec [hl]
	dec [hl]
	ld d, $10
	xcall Sine
	ld hl, BATTLEANIMSTRUCT_YOFFSET
	add hl, bc
	ld [hl], a
	ld hl, BATTLEANIMSTRUCT_XCOORD
	add hl, bc
	inc [hl]
	ret

SECTION "BattleAnimFunc_String", ROMX

BattleAnimFunc_String:
	call BattleAnim_AnonJumptable
.anon_dw
	dw .zero
	dw DoNothing ; .one

.zero
	call BattleAnim_IncAnonJumptableIndex
	ld hl, BATTLEANIMSTRUCT_PARAM
	add hl, bc
	ld a, [hl]
	and a
	jr nz, .not_param_zero
	; Obj Param 0 flips when used by enemy
	ld hl, BATTLEANIMSTRUCT_OAMFLAGS
	add hl, bc
	set OAM_Y_FLIP, [hl]
.not_param_zero
	assert BATTLE_ANIM_FRAMESET_STRING_SHOT_1 + 1 == BATTLE_ANIM_FRAMESET_STRING_SHOT_2 \
		&& BATTLE_ANIM_FRAMESET_STRING_SHOT_2 + 1 == BATTLE_ANIM_FRAMESET_STRING_SHOT_3
	add BATTLE_ANIM_FRAMESET_STRING_SHOT_1
	jmp ReinitBattleAnimFrameset

SECTION "BattleAnimFunc_Paralyzed", ROMX

BattleAnimFunc_Paralyzed:
; Also used by Disable
; Obj Param: When bit 7 is set, frameset is replaced with flipped version. This bit is discarded and object then moves back and forth between position in lower nybble and upper nybble of Param every other frame
	call BattleAnim_AnonJumptable
.anon_dw
	dw .zero
	dw .one

.zero
	call BattleAnim_IncAnonJumptableIndex
	ld hl, BATTLEANIMSTRUCT_VAR1
	add hl, bc
	ld [hl], $0
	ld hl, BATTLEANIMSTRUCT_PARAM
	add hl, bc
	ld e, [hl]
	ld a, e
	and $70
	swap a
	ld [hl], a
	ld hl, BATTLEANIMSTRUCT_XOFFSET
	add hl, bc
	ld a, e
	and $80
	jr nz, .right
	ld a, e
	and $f
	ld [hl], a
	ret

.right
	ld a, e
	and $f
	cpl
	inc a
	ld [hl], a
	ld a, BATTLE_ANIM_FRAMESET_PARALYZED_FLIPPED
	jmp ReinitBattleAnimFrameset

.one
	ld hl, BATTLEANIMSTRUCT_VAR1
	add hl, bc
	ld a, [hl]
	and a
	jr z, .var1_zero
	dec [hl]
	ret

.var1_zero
	ld hl, BATTLEANIMSTRUCT_PARAM
	add hl, bc
	ld a, [hl]
	ld hl, BATTLEANIMSTRUCT_VAR1
	add hl, bc
	ld [hl], a
	ld hl, BATTLEANIMSTRUCT_XOFFSET
	add hl, bc
	ld a, [hl]
	cpl
	inc a
	ld [hl], a
	ret

SECTION "BattleAnimFunc_PetalDance", ROMX

BattleAnimFunc_PetalDance:
; Object moves downwards in a spiral around the user. Object disappears at y coord $28
	ld hl, BATTLEANIMSTRUCT_VAR1
	add hl, bc
	ld a, [hl]
	ld d, $18
	push af
	push de
	xcall Sine
	sra a
	sra a
	sra a
	ld hl, BATTLEANIMSTRUCT_VAR2
	add hl, bc
	add [hl]
	ld hl, BATTLEANIMSTRUCT_YOFFSET
	add hl, bc
	ld [hl], a
	pop de
	pop af
	xcall Cosine
	ld hl, BATTLEANIMSTRUCT_XOFFSET
	add hl, bc
	ld [hl], a
	ld hl, BATTLEANIMSTRUCT_VAR1
	add hl, bc
	inc [hl]
	ld a, [hl]
	and $3
	ret nz
	ld hl, BATTLEANIMSTRUCT_VAR2
	add hl, bc
	ld a, [hl]
	cp $28
	jr nc, .end
	inc [hl]
	ret

.end
	jmp DeinitBattleAnimation

SECTION "BattleAnimFunc_SmokeFlameWheel", ROMX

BattleAnimFunc_SmokeFlameWheel:
; Object spins around target while also moving upward until it disappears at x coord $e8
; Obj Param: Defines where the object starts in the circle
	ld hl, BATTLEANIMSTRUCT_PARAM
	add hl, bc
	ld a, [hl]
	ld d, $18
	push af
	push de
	xcall Sine
	sra a
	sra a
	sra a
	ld hl, BATTLEANIMSTRUCT_VAR2
	add hl, bc
	add [hl]
	ld hl, BATTLEANIMSTRUCT_YOFFSET
	add hl, bc
	ld [hl], a
	pop de
	pop af
	xcall Cosine
	ld hl, BATTLEANIMSTRUCT_XOFFSET
	add hl, bc
	ld [hl], a
	ld hl, BATTLEANIMSTRUCT_PARAM
	add hl, bc
	inc [hl]
	inc [hl]
	ld a, [hl]
	and $7
	ret nz
	ld hl, BATTLEANIMSTRUCT_VAR2
	add hl, bc
	ld a, [hl]
	cp $e8
	jr z, .done
	dec [hl]
	ret

.done
	jmp DeinitBattleAnimation

SECTION "BattleAnimFunc_SacredFire", ROMX

BattleAnimFunc_SacredFire:
; Moves object in a circle where the height is 1/8 the width, while also moving upward 2 pixels per frame for 24 frames after which it disappears
; Obj Param: Is used internally only
	ld hl, BATTLEANIMSTRUCT_PARAM
	add hl, bc
	ld a, [hl]
	ld d, $18
	push af
	push de
	xcall Sine
	sra a
	sra a
	sra a
	ld hl, BATTLEANIMSTRUCT_VAR2
	add hl, bc
	add [hl]
	ld hl, BATTLEANIMSTRUCT_YOFFSET
	add hl, bc
	ld [hl], a
	pop de
	pop af
	xcall Cosine
	ld hl, BATTLEANIMSTRUCT_XOFFSET
	add hl, bc
	ld [hl], a
	ld hl, BATTLEANIMSTRUCT_PARAM
	add hl, bc
	inc [hl]
	inc [hl]
	ld a, [hl]
	and $3
	ret nz
	ld hl, BATTLEANIMSTRUCT_VAR2
	add hl, bc
	ld a, [hl]
	cp $d0
	jr z, .done
	dec [hl]
	dec [hl]
	ret

.done
	jmp DeinitBattleAnimation

SECTION "BattleAnimFunc_PresentSmokescreen", ROMX

BattleAnimFunc_PresentSmokescreen:
; Object bounces from user to target and stops at x coord $6c. Uses anim_incobj to clear object
; Obj Param: Defined but not used
	call BattleAnim_AnonJumptable
.anon_dw
	dw .zero
	dw .one
	dw .two

.zero
	call BattleAnim_IncAnonJumptableIndex
	ld hl, BATTLEANIMSTRUCT_VAR1
	add hl, bc
	ld [hl], $34
	ld hl, BATTLEANIMSTRUCT_VAR2
	add hl, bc
	ld [hl], $10
.one
	ld hl, BATTLEANIMSTRUCT_XCOORD
	add hl, bc
	ld a, [hl]
	cp $6c
	ret nc
	ld a, $2
	call BattleAnim_StepToTarget
	ld hl, BATTLEANIMSTRUCT_VAR1
	add hl, bc
	ld a, [hl]
	ld hl, BATTLEANIMSTRUCT_VAR2
	add hl, bc
	ld d, [hl]
	xcall Sine
	bit 7, a
	jr nz, .negative
	cpl
	inc a
.negative
	ld hl, BATTLEANIMSTRUCT_YOFFSET
	add hl, bc
	ld [hl], a
	ld hl, BATTLEANIMSTRUCT_VAR1
	add hl, bc
	ld a, [hl]
	sub $4
	ld [hl], a
	and $1f
	cp $20
	ret nz
	ld hl, BATTLEANIMSTRUCT_VAR2
	add hl, bc
	srl [hl]
	ret

.two
	jmp DeinitBattleAnimation

SECTION "BattleAnimFunc_Horn", ROMX

BattleAnimFunc_Horn:
	call BattleAnim_AnonJumptable
.anon_dw
	dw .zero
	dw .one
	dw .two
	dw .three

.zero
	ld hl, BATTLEANIMSTRUCT_PARAM
	add hl, bc
	ld a, [hl]
	ld hl, BATTLEANIMSTRUCT_JUMPTABLE_INDEX
	add hl, bc
	ld [hl], a
	ld hl, BATTLEANIMSTRUCT_YCOORD
	add hl, bc
	ld a, [hl]
	ld hl, BATTLEANIMSTRUCT_VAR1
	add hl, bc
	ld [hl], a
	ret

.one
	ld hl, BATTLEANIMSTRUCT_XCOORD
	add hl, bc
	ld a, [hl]
	cp $58
	ret nc
	ld a, $2
	jmp BattleAnim_StepToTarget

.two
	ld hl, BATTLEANIMSTRUCT_VAR2
	add hl, bc
	ld a, [hl]
	cp $20
	jmp nc, DeinitBattleAnimation
; fallthrough
.three
	ld hl, BATTLEANIMSTRUCT_VAR2
	add hl, bc
	ld a, [hl]
	ld d, $8
	xcall Sine
	ld hl, BATTLEANIMSTRUCT_XOFFSET
	add hl, bc
	ld [hl], a
	sra a
	cpl
	inc a
	ld hl, BATTLEANIMSTRUCT_VAR1
	add hl, bc
	add [hl]
	ld hl, BATTLEANIMSTRUCT_YCOORD
	add hl, bc
	ld [hl], a
	ld hl, BATTLEANIMSTRUCT_VAR2
	add hl, bc
	ld a, [hl]
	add $8
	ld [hl], a
	ret

SECTION "BattleAnimFunc_Needle", ROMX

BattleAnimFunc_Needle:
; Moves object towards target, either in a straight line or arc. Stops at x coord $84
; Obj Param: Upper nybble defines the index of the jumptable. Lower nybble defines the speed.
	call BattleAnim_AnonJumptable
.anon_dw
	dw .zero
	dw .one
	dw .two

.zero
	ld hl, BATTLEANIMSTRUCT_PARAM
	add hl, bc
	ld a, [hl]
	and $f0
	swap a
	ld hl, BATTLEANIMSTRUCT_JUMPTABLE_INDEX
	add hl, bc
	ld [hl], a
	ret

.two
	; Pin Missile needle (arc)
	ld hl, BATTLEANIMSTRUCT_VAR1
	add hl, bc
	ld a, [hl]
	ld d, $10
	xcall Sine
	ld hl, BATTLEANIMSTRUCT_YOFFSET
	add hl, bc
	bit 7, a
	jr z, .negative
	ld [hl], a
.negative
	ld hl, BATTLEANIMSTRUCT_VAR1
	add hl, bc
	ld a, [hl]
	sub $4
	ld [hl], a
.one
	; Normal needle (line)
	ld hl, BATTLEANIMSTRUCT_XCOORD
	add hl, bc
	ld a, [hl]
	cp $84
	jmp nc, DeinitBattleAnimation
	ld hl, BATTLEANIMSTRUCT_PARAM
	add hl, bc
	ld a, [hl]
	jmp BattleAnim_StepToTarget

SECTION "BattleAnimFunc_ThiefPayday", ROMX

BattleAnimFunc_ThiefPayday:
; Object drops off target and bounces once on the floor
; Obj Param: Defines every how many frames the object moves horizontally
	call BattleAnim_AnonJumptable
.anon_dw
	dw .zero
	dw .one

.zero
	call BattleAnim_IncAnonJumptableIndex
	ld hl, BATTLEANIMSTRUCT_VAR1
	add hl, bc
	ld [hl], $28
	ld hl, BATTLEANIMSTRUCT_YCOORD
	add hl, bc
	ld a, [hl]
	sub $28
	ld hl, BATTLEANIMSTRUCT_VAR2
	add hl, bc
	ld [hl], a
.one
	ld hl, BATTLEANIMSTRUCT_VAR1
	add hl, bc
	ld a, [hli]
	ld d, [hl]
	xcall Sine
	ld hl, BATTLEANIMSTRUCT_YOFFSET
	add hl, bc
	ld [hl], a
	ld hl, BATTLEANIMSTRUCT_VAR1
	add hl, bc
	ld a, [hl]
	ld hl, BATTLEANIMSTRUCT_PARAM
	add hl, bc
	and [hl]
	jr nz, .var_doesnt_equal_param
	ld hl, BATTLEANIMSTRUCT_XCOORD
	add hl, bc
	dec [hl]
.var_doesnt_equal_param
	ld hl, BATTLEANIMSTRUCT_VAR1
	add hl, bc
	inc [hl]
	ld a, [hl]
	and $3f
	ret nz
	ld hl, BATTLEANIMSTRUCT_VAR1
	add hl, bc
	ld a, $20
	ld [hli], a
	srl [hl]
	ret

SECTION "BattleAnimFunc_AbsorbCircle", ROMX

BattleAnimFunc_AbsorbCircle:
; A circle of objects that starts at the target and moves to the user. It expands until x coord $5a and then shrinks. Once radius reaches 0, the object disappears. Also used by Mimic and Conversion2
; Obj Param: Defines the position in the circle the object starts at
	ld hl, BATTLEANIMSTRUCT_PARAM
	add hl, bc
	ld a, [hl]
	ld hl, BATTLEANIMSTRUCT_VAR1
	add hl, bc
	ld d, [hl]
	push af
	push de
	xcall Sine
	ld hl, BATTLEANIMSTRUCT_YOFFSET
	add hl, bc
	ld [hl], a
	pop de
	pop af
	xcall Cosine
	ld hl, BATTLEANIMSTRUCT_XOFFSET
	add hl, bc
	ld [hl], a
	ld hl, BATTLEANIMSTRUCT_PARAM
	add hl, bc
	inc [hl]
	ld a, [hl]
	and $1
	jr nz, .dont_move_x
	ld hl, BATTLEANIMSTRUCT_XCOORD
	add hl, bc
	dec [hl]
.dont_move_x
	ld hl, BATTLEANIMSTRUCT_PARAM
	add hl, bc
	ld a, [hl]
	and $3
	jr nz, .dont_move_y
	ld hl, BATTLEANIMSTRUCT_YCOORD
	add hl, bc
	inc [hl]
.dont_move_y
	ld hl, BATTLEANIMSTRUCT_XCOORD
	add hl, bc
	ld a, [hl]
	ld hl, BATTLEANIMSTRUCT_VAR1
	add hl, bc
	cp $5a
	jr nc, .increase_radius
	ld a, [hl]
	and a
	jr z, .end
	dec [hl] ; decreases radius
	ret

.increase_radius
	inc [hl]
	ret

.end
	jmp DeinitBattleAnimation

SECTION "BattleAnimFunc_Conversion", ROMX

BattleAnimFunc_Conversion:
; A rotating circle of objects centered at a position. It expands for $40 frames and then shrinks. Once radius reaches 0, the object disappears.
; Obj Param: Defines starting point in the circle
	ld hl, BATTLEANIMSTRUCT_PARAM
	add hl, bc
	ld a, [hl]
	inc [hl]
	ld hl, BATTLEANIMSTRUCT_VAR1
	add hl, bc
	ld d, [hl]
	push af
	push de
	xcall Sine
	ld hl, BATTLEANIMSTRUCT_YOFFSET
	add hl, bc
	ld [hl], a
	pop de
	pop af
	xcall Cosine
	ld hl, BATTLEANIMSTRUCT_XOFFSET
	add hl, bc
	ld [hl], a
	ld hl, BATTLEANIMSTRUCT_VAR2
	add hl, bc
	ld a, [hl]
	inc [hl]
	ld hl, BATTLEANIMSTRUCT_VAR1
	add hl, bc
	cp $40
	jr nc, .shrink
	inc [hl]
	ret

.shrink
	ld a, [hl]
	dec [hl]
	and a
	ret nz
	jmp DeinitBattleAnimation

SECTION "BattleAnimFunc_Bonemerang", ROMX

BattleAnimFunc_Bonemerang:
; Boomerang-like movement from user to target
; Obj Param: Defines position to start at in the circle
	call BattleAnim_AnonJumptable
.anon_dw
	dw .zero
	dw .one

.zero:
	call BattleAnim_IncAnonJumptableIndex
	ld hl, BATTLEANIMSTRUCT_YCOORD
	add hl, bc
	ld a, [hl]
	ld hl, BATTLEANIMSTRUCT_VAR2
	add hl, bc
	ld [hl], a
.one:
	ld hl, BATTLEANIMSTRUCT_PARAM
	add hl, bc
	ld a, [hl]
	ld d, $30
	xcall Sine
	ld hl, BATTLEANIMSTRUCT_VAR2
	add hl, bc
	add [hl]
	ld hl, BATTLEANIMSTRUCT_YCOORD
	add hl, bc
	ld [hl], a
	ld hl, BATTLEANIMSTRUCT_PARAM
	add hl, bc
	ld a, [hl]
	add $8
	ld d, $30
	xcall Cosine
	ld hl, BATTLEANIMSTRUCT_XOFFSET
	add hl, bc
	ld [hl], a
	ld hl, BATTLEANIMSTRUCT_PARAM
	add hl, bc
	inc [hl]
	ret

SECTION "BattleAnimFunc_Shiny", ROMX

BattleAnimFunc_Shiny:
; Puts object in a circle formation of radius $10. Also used by Flash and Light Screen
; Obj Param: Defines where the object starts in the circle
	call BattleAnim_AnonJumptable
.anon_dw
	dw .zero
	dw DoNothing ; .one

.zero:
	call BattleAnim_IncAnonJumptableIndex
	ld hl, BATTLEANIMSTRUCT_PARAM
	add hl, bc
	ld a, [hl]
	ld d, $10
	xcall Sine
	ld hl, BATTLEANIMSTRUCT_YOFFSET
	add hl, bc
	ld [hl], a
	ld hl, BATTLEANIMSTRUCT_PARAM
	add hl, bc
	ld a, [hl]
	ld d, $10
	xcall Cosine
	ld hl, BATTLEANIMSTRUCT_XOFFSET
	add hl, bc
	ld [hl], a
	ld hl, BATTLEANIMSTRUCT_VAR2 ; unused?
	add hl, bc
	ld [hl], $f
	ret

SECTION "BattleAnimFunc_SkyAttack", ROMX

BattleAnimFunc_SkyAttack:
; Uses anim_incobj to move to next step
	call BattleAnim_AnonJumptable
.anon_dw
	dw .zero
	dw .SkyAttack_CyclePalette
	dw .two
	dw .three

.zero
	call BattleAnim_IncAnonJumptableIndex
	ldh a, [hBattleTurn]
	and a
	ld a, $f0
	jr z, .got_var1
	ld a, $cc
.got_var1
	ld hl, BATTLEANIMSTRUCT_VAR1
	add hl, bc
	ld [hl], a
	ret

.two
; Moves towards target and stops at x coord $84
	call .SkyAttack_CyclePalette
	ld hl, BATTLEANIMSTRUCT_XCOORD
	add hl, bc
	ld a, [hl]
	cp $84
	ret nc
	ld a, $4
	jmp BattleAnim_StepToTarget

.three
; Moves towards target and disappears at x coord $d0
	call .SkyAttack_CyclePalette
	ld hl, BATTLEANIMSTRUCT_XCOORD
	add hl, bc
	ld a, [hl]
	cp $d0
	jr nc, .done
	ld a, $4
	jmp BattleAnim_StepToTarget

.done
	jmp DeinitBattleAnimation

.SkyAttack_CyclePalette:
; Cycles wOBP0 pallete
	ld hl, BATTLEANIMSTRUCT_VAR2
	add hl, bc
	ld a, [hl]
	and $7
	inc [hl]
	srl a
	ld e, a
	ld d, 0
	ldh a, [hSGB]
	and a
	jr nz, .sgb
	ld hl, .GBCPals
	jr .got_pals

.sgb
	ld hl, .SGBPals
.got_pals
	add hl, de
	ld a, [hl]
	ld hl, BATTLEANIMSTRUCT_VAR1
	add hl, bc
	and [hl]
	ld [wOBP0], a
	ret

.GBCPals:
	db $ff, $aa, $55, $aa
.SGBPals:
	db $ff, $ff, $00, $00

SECTION "BattleAnimFunc_GrowthSwordsDance", ROMX

BattleAnimFunc_GrowthSwordsDance:
; Moves object in a circle where the height is 1/8 the width, while also moving upward 2 pixels per frame
; Obj Param: Defines where the object starts in the circle
	ld hl, BATTLEANIMSTRUCT_PARAM
	add hl, bc
	ld a, [hl]
	ld d, $18
	xcall Sine
	sra a
	sra a
	sra a
	ld hl, BATTLEANIMSTRUCT_VAR2
	add hl, bc
	add [hl]
	ld hl, BATTLEANIMSTRUCT_YOFFSET
	add hl, bc
	ld [hl], a
	ld hl, BATTLEANIMSTRUCT_PARAM
	add hl, bc
	ld a, [hl]
	inc [hl]
	ld d, $18
	xcall Cosine
	ld hl, BATTLEANIMSTRUCT_XOFFSET
	add hl, bc
	ld [hl], a
	ld hl, BATTLEANIMSTRUCT_VAR2
	add hl, bc
	dec [hl]
	dec [hl]
	ret

SECTION "BattleAnimFunc_StrengthSeismicToss", ROMX

BattleAnimFunc_StrengthSeismicToss:
; Moves object up for $e0 frames, then shakes it vertically and throws it at the target. Uses anim_incobj to move to final phase
; Obj Param: Defined but not used
	call BattleAnim_AnonJumptable
.anon_dw
	dw .zero
	dw .one
	dw .two

.zero
	ld hl, BATTLEANIMSTRUCT_YOFFSET
	add hl, bc
	ld a, [hl]
	cp $e0
	jr nz, .move_up
	call BattleAnim_IncAnonJumptableIndex
	ld hl, BATTLEANIMSTRUCT_VAR1
	add hl, bc
	ld [hl], $2
	ret

.move_up
	ld d, a
	ld hl, BATTLEANIMSTRUCT_VAR1
	add hl, bc
	ld e, [hl]
	ld hl, -$80
	add hl, de
	ld e, l
	ld d, h
	ld hl, BATTLEANIMSTRUCT_YOFFSET
	add hl, bc
	ld [hl], d
	ld hl, BATTLEANIMSTRUCT_VAR1
	add hl, bc
	ld [hl], e
	ret

.one
	ld hl, BATTLEANIMSTRUCT_VAR2
	add hl, bc
	ld a, [hl]
	and a
	jr z, .switch_position
	dec [hl]
	ret

.switch_position
	ld [hl], $4
	ld hl, BATTLEANIMSTRUCT_VAR1
	add hl, bc
	ld a, [hl]
	cpl
	inc a
	ld [hl], a
	ld hl, BATTLEANIMSTRUCT_YOFFSET
	add hl, bc
	add [hl]
	ld [hl], a
	ret

.two
	ld hl, BATTLEANIMSTRUCT_XCOORD
	add hl, bc
	ld a, [hl]
	cp $84
	jr nc, .done
	ld a, $4
	jmp BattleAnim_StepToTarget

.done
	jmp DeinitBattleAnimation

SECTION "BattleAnimFunc_SpeedLine", ROMX

BattleAnimFunc_SpeedLine:
; Used in moves where the user disappears for a speed-based attack such as Quick Attack, Mach Punch and Extremespeed
	call BattleAnim_AnonJumptable
.anon_dw
	dw .zero
	dw .one

.zero
	call BattleAnim_IncAnonJumptableIndex
	ld hl, BATTLEANIMSTRUCT_PARAM
	add hl, bc
	ld a, [hl]
	and $7f
	assert BATTLE_ANIM_FRAMESET_SPEED_LINE_1 + 1 == BATTLE_ANIM_FRAMESET_SPEED_LINE_2 \
		&& BATTLE_ANIM_FRAMESET_SPEED_LINE_2 + 1 == BATTLE_ANIM_FRAMESET_SPEED_LINE_3
	add BATTLE_ANIM_FRAMESET_SPEED_LINE_1
	call ReinitBattleAnimFrameset
.one
	ld hl, BATTLEANIMSTRUCT_PARAM
	add hl, bc
	bit 7, [hl]
	jr nz, .inverted
	ld hl, BATTLEANIMSTRUCT_XOFFSET
	add hl, bc
	inc [hl]
	ret

.inverted
	ld hl, BATTLEANIMSTRUCT_XOFFSET
	add hl, bc
	dec [hl]
	ret

SECTION "BattleAnimFunc_Sludge", ROMX

BattleAnimFunc_Sludge:
; Object moves upward for $c frames and switches to BATTLE_ANIM_FRAMESET_SLUDGE_BUBBLE_BURST
	call BattleAnim_AnonJumptable
.anon_dw
	dw .zero
	dw .one
	dw .two

.zero
	call BattleAnim_IncAnonJumptableIndex
	ld hl, BATTLEANIMSTRUCT_VAR1
	add hl, bc
	ld [hl], $c
	ret

.one
	ld hl, BATTLEANIMSTRUCT_VAR1
	add hl, bc
	ld a, [hl]
	and a
	jr z, .done
	dec [hl]
	ret

.done
	call BattleAnim_IncAnonJumptableIndex
	ld a, BATTLE_ANIM_FRAMESET_SLUDGE_BUBBLE_BURST
	call ReinitBattleAnimFrameset
.two
	ld hl, BATTLEANIMSTRUCT_YOFFSET
	add hl, bc
	dec [hl]
	ret

SECTION "BattleAnimFunc_MetronomeHand", ROMX

BattleAnimFunc_MetronomeHand:
; Fast circular motion with an x radius of $8 and y radius of $2
	ld hl, BATTLEANIMSTRUCT_VAR1
	add hl, bc
	ld a, [hl]
	inc [hl]
	inc [hl]
	push af
	ld d, $2
	xcall Sine
	ld hl, BATTLEANIMSTRUCT_YOFFSET
	add hl, bc
	ld [hl], a
	pop af
	ld d, $8
	xcall Cosine
	ld hl, BATTLEANIMSTRUCT_XOFFSET
	add hl, bc
	ld [hl], a
	ret

SECTION "BattleAnimFunc_MetronomeSparkleSketch", ROMX

BattleAnimFunc_MetronomeSparkleSketch:
; Sideways wave motion while also moving downward until it disappears at y coord $20
; Obj Param: Only used internally
	ld hl, BATTLEANIMSTRUCT_YOFFSET
	add hl, bc
	ld a, [hl]
	cp $20
	jmp nc, DeinitBattleAnimation
	ld hl, BATTLEANIMSTRUCT_PARAM
	add hl, bc
	ld a, [hl]
	ld d, $8
	xcall Cosine
	ld hl, BATTLEANIMSTRUCT_XOFFSET
	add hl, bc
	ld [hl], a
	ld hl, BATTLEANIMSTRUCT_PARAM
	add hl, bc
	ld a, [hl]
	add $2
	ld [hl], a
	and $7
	ret nz
	ld hl, BATTLEANIMSTRUCT_YOFFSET
	add hl, bc
	inc [hl]
	ret

SECTION "BattleAnimFunc_Agility", ROMX

BattleAnimFunc_Agility:
; Object moves sideways at a speed determined by Obj Param. Can use anim_incobj to make it disappear
	call BattleAnim_AnonJumptable
.anon_dw
	dw .zero
	dw .one

.zero
	ld hl, BATTLEANIMSTRUCT_PARAM
	add hl, bc
	ld a, [hl]
	ld hl, BATTLEANIMSTRUCT_XCOORD
	add hl, bc
	add [hl]
	ld [hl], a
	ret

.one
	jmp DeinitBattleAnimation

SECTION "BattleAnimFunc_SafeguardProtect", ROMX

BattleAnimFunc_SafeguardProtect:
; Moves object in a circle where the width is 1/2 the height
; Obj Param: Defines starting point in circle
	ld hl, BATTLEANIMSTRUCT_PARAM
	add hl, bc
	ld a, [hl]
	ld d, $18
	push af
	push de
	xcall Sine
	ld hl, BATTLEANIMSTRUCT_YOFFSET
	add hl, bc
	ld [hl], a
	pop de
	pop af
	xcall Cosine
	ld hl, BATTLEANIMSTRUCT_XOFFSET
	add hl, bc
	sra a
	ld [hl], a
	ld hl, BATTLEANIMSTRUCT_PARAM
	add hl, bc
	ld a, [hl]
	inc [hl]
	ret

SECTION "BattleAnimFunc_LockOnMindReader", ROMX

BattleAnimFunc_LockOnMindReader:
; Moves objects towards a center position
; Obj Param: Used to define object angle from 0 to 3. Lower nybble defines how much to increase from base frameset while upper nybble defines angle of movement. The object moves for $28 frames, then waits for $10 frames and disappears
	call BattleAnim_AnonJumptable
.anon_dw
	dw .zero
	dw .one
	dw .two

.zero
	call BattleAnim_IncAnonJumptableIndex
	ld hl, BATTLEANIMSTRUCT_VAR1
	add hl, bc
	ld [hl], $28
	ld hl, BATTLEANIMSTRUCT_PARAM
	add hl, bc
	ld a, [hl]
	and $f
	ld hl, BATTLEANIMSTRUCT_FRAMESET_ID
	add hl, bc
	assert BATTLE_ANIM_FRAMESET_LOCK_ON_1 + 1 == BATTLE_ANIM_FRAMESET_LOCK_ON_2 \
		&& BATTLE_ANIM_FRAMESET_LOCK_ON_2 + 1 == BATTLE_ANIM_FRAMESET_LOCK_ON_3 \
		&& BATTLE_ANIM_FRAMESET_LOCK_ON_3 + 1 == BATTLE_ANIM_FRAMESET_LOCK_ON_4
	assert BATTLE_ANIM_FRAMESET_MIND_READER_1 + 1 == BATTLE_ANIM_FRAMESET_MIND_READER_2 \
		&& BATTLE_ANIM_FRAMESET_MIND_READER_2 + 1 == BATTLE_ANIM_FRAMESET_MIND_READER_3 \
		&& BATTLE_ANIM_FRAMESET_MIND_READER_3 + 1 == BATTLE_ANIM_FRAMESET_MIND_READER_4
	add [hl]
	call ReinitBattleAnimFrameset
	ld hl, BATTLEANIMSTRUCT_PARAM
	add hl, bc
	ld a, [hl]
	and $f0
	or $8
	ld [hl], a
.one
	ld hl, BATTLEANIMSTRUCT_VAR1
	add hl, bc
	ld a, [hl]
	and a
	jr z, .done
	dec [hl]
	add $8
	ld d, a
	ld hl, BATTLEANIMSTRUCT_PARAM
	add hl, bc
	ld a, [hl]
	push af
	push de
	xcall Sine
	ld hl, BATTLEANIMSTRUCT_YOFFSET
	add hl, bc
	ld [hl], a
	pop de
	pop af
	xcall Cosine
	ld hl, BATTLEANIMSTRUCT_XOFFSET
	add hl, bc
	ld [hl], a
	ret

.done
	ld [hl], $10
	call BattleAnim_IncAnonJumptableIndex
.two
	ld hl, BATTLEANIMSTRUCT_VAR1
	add hl, bc
	ld a, [hl]
	dec [hl]
	and a
	ret nz
	jmp DeinitBattleAnimation

SECTION "BattleAnimFunc_HealBellNotes", ROMX

BattleAnimFunc_HealBellNotes:
; Object moves horizontally in a sine wave, while also moving left every other frame and downwards for $38 frames after which it disappears
; Obj Param: Defines a frameset offset from FRAMESET_24
	call BattleAnim_AnonJumptable
.anon_dw
	dw .zero
	dw .one

.zero
	call BattleAnim_IncAnonJumptableIndex
	ld hl, BATTLEANIMSTRUCT_PARAM
	add hl, bc
	ld a, BATTLE_ANIM_FRAMESET_MUSIC_NOTE_1
	assert BATTLE_ANIM_FRAMESET_MUSIC_NOTE_1 + 1 == BATTLE_ANIM_FRAMESET_MUSIC_NOTE_2 \
		&& BATTLE_ANIM_FRAMESET_MUSIC_NOTE_2 + 1 == BATTLE_ANIM_FRAMESET_MUSIC_NOTE_3
	add [hl]
	call ReinitBattleAnimFrameset
.one
	ld hl, BATTLEANIMSTRUCT_YOFFSET
	add hl, bc
	ld a, [hl]
	cp $38
	jr nc, .done
	inc [hl]
	ld hl, BATTLEANIMSTRUCT_VAR1
	add hl, bc
	ld a, [hl]
	inc [hl]
	ld d, $18
	xcall Cosine
	ld hl, BATTLEANIMSTRUCT_XOFFSET
	add hl, bc
	ld [hl], a
	ld hl, BATTLEANIMSTRUCT_YCOORD
	add hl, bc
	ld a, [hl]
	and $1
	ret nz
	ld hl, BATTLEANIMSTRUCT_XCOORD
	add hl, bc
	dec [hl]
	ret

.done
	jmp DeinitBattleAnimation

SECTION "BattleAnimFunc_BatonPass", ROMX

BattleAnimFunc_BatonPass:
; Object falls vertically and bounces on the ground
; Obj Param: Defines speed and duration
	ld hl, BATTLEANIMSTRUCT_PARAM
	add hl, bc
	ld a, [hl]
	and a
	ret z
	ld d, a
	ld hl, BATTLEANIMSTRUCT_VAR1
	add hl, bc
	ld a, [hl]
	inc [hl]
	xcall Sine
	bit 7, a
	jr nz, .negative
	cpl
	inc a
.negative
	ld hl, BATTLEANIMSTRUCT_YOFFSET
	add hl, bc
	ld [hl], a
	ld hl, BATTLEANIMSTRUCT_VAR1
	add hl, bc
	ld a, [hl]
	and $1f
	ret nz
	ld hl, BATTLEANIMSTRUCT_PARAM
	add hl, bc
	srl [hl]
	ret

SECTION "BattleAnimFunc_EncoreBellyDrum", ROMX

BattleAnimFunc_EncoreBellyDrum:
; Object moves at an arc for 8 frames and disappears
; Obj Param: Defines starting position in the arc
	ld hl, BATTLEANIMSTRUCT_VAR1
	add hl, bc
	ld a, [hl]
	cp $10
	jr nc, .done
	inc [hl]
	inc [hl]
	ld d, a
	ld hl, BATTLEANIMSTRUCT_PARAM
	add hl, bc
	ld a, [hl]
	push af
	push de
	xcall Sine
	ld hl, BATTLEANIMSTRUCT_YOFFSET
	add hl, bc
	ld [hl], a
	pop de
	pop af
	xcall Cosine
	ld hl, BATTLEANIMSTRUCT_XOFFSET
	add hl, bc
	ld [hl], a
	ret

.done
	jmp DeinitBattleAnimation

SECTION "BattleAnimFunc_SwaggerMorningSun", ROMX

BattleAnimFunc_SwaggerMorningSun:
; Moves object at an angle
; Obj Param: Lower 6 bits define angle of movement and upper 2 bits define speed
	ld hl, BATTLEANIMSTRUCT_PARAM
	add hl, bc
	ld e, [hl]
	ld hl, BATTLEANIMSTRUCT_VAR1
	add hl, bc
	ld d, [hl]
	ld a, e
	and $c0
	rlca
	rlca
	add [hl]
	ld [hl], a
	ld a, e
	and $3f
	push af
	push de
	xcall Sine
	ld hl, BATTLEANIMSTRUCT_YOFFSET
	add hl, bc
	ld [hl], a
	pop de
	pop af
	xcall Cosine
	ld hl, BATTLEANIMSTRUCT_XOFFSET
	add hl, bc
	ld [hl], a
	ret

SECTION "BattleAnimFunc_HiddenPower", ROMX

BattleAnimFunc_HiddenPower:
; Moves object in a ring around position. Uses anim_incobj to move to second phase, where it expands the radius 8 pixels at a time for 13 frames and then disappears
; Obj Param: Defines starting position in circle
	call BattleAnim_AnonJumptable
.anon_dw
	dw .zero
	dw .one
	dw .two

.zero
	ld d, $18
	ld hl, BATTLEANIMSTRUCT_PARAM
	add hl, bc
	ld a, [hl]
	inc [hl]
	jr .step_circle

.one
	call BattleAnim_IncAnonJumptableIndex
	ld hl, BATTLEANIMSTRUCT_VAR1
	add hl, bc
	ld [hl], $18
.two
	ld hl, BATTLEANIMSTRUCT_VAR1
	add hl, bc
	ld a, [hl]
	cp $80
	jr nc, .done
	ld d, a
	add $8
	ld [hl], a
	ld hl, BATTLEANIMSTRUCT_PARAM
	add hl, bc
	ld a, [hl]
	jr .step_circle

.done
	jmp DeinitBattleAnimation

.step_circle
	jmp BattleAnim_StepCircle

SECTION "BattleAnimFunc_Curse", ROMX

BattleAnimFunc_Curse:
; Object moves down and to the left 2 pixels at a time until it reaches x coord $30 and disappears
	call BattleAnim_AnonJumptable
.anon_dw
	dw DoNothing ; .zero
	dw .one

.one
	ld hl, BATTLEANIMSTRUCT_XCOORD
	add hl, bc
	ld a, [hl]
	cp $30
	jr c, .done
	ld hl, BATTLEANIMSTRUCT_XCOORD
	add hl, bc
	dec [hl]
	dec [hl]
	ld hl, BATTLEANIMSTRUCT_YCOORD
	add hl, bc
	inc [hl]
	inc [hl]
	ret

.done
	jmp DeinitBattleAnimation

SECTION "BattleAnimFunc_PerishSong", ROMX

BattleAnimFunc_PerishSong:
; Moves object in a large circle with a x radius of $50 and a y radius 1/4 or that, while also moving downwards
; Obj Param: Defines starting position in the circle
	ld d, $50
	ld hl, BATTLEANIMSTRUCT_PARAM
	add hl, bc
	ld a, [hl]
	inc [hl]
	inc [hl]
	push af
	push de
	xcall Sine
	sra a
	sra a
	ld hl, BATTLEANIMSTRUCT_VAR1
	add hl, bc
	add [hl]
	inc [hl]
	ld hl, BATTLEANIMSTRUCT_YOFFSET
	add hl, bc
	ld [hl], a
	pop de
	pop af
	xcall Cosine
	ld hl, BATTLEANIMSTRUCT_XOFFSET
	add hl, bc
	ld [hl], a
	ret

SECTION "BattleAnimFunc_RapidSpin", ROMX

BattleAnimFunc_RapidSpin:
; Object moves upwards 4 pixels per frame until it disappears at y coord $d0
	ld hl, BATTLEANIMSTRUCT_YOFFSET
	add hl, bc
	ld a, [hl]
	cp $d0
	jr z, .done
	dec [hl]
	dec [hl]
	dec [hl]
	dec [hl]
	ret

.done
	jmp DeinitBattleAnimation

SECTION "BattleAnimFunc_RainSandstorm", ROMX

BattleAnimFunc_RainSandstorm:
; Object moves down 4 pixels at a time and right a variable distance
; Obj Param: Defines variation in the movement
;            $0: 2 pixels horizontal movement
;            $1: 8 pixels horizontal movement
;            $2: 4 pixels horizontal movement
	call BattleAnim_AnonJumptable
.anon_dw
	dw .zero
	dw .one
	dw .two
	dw .three

.zero
	ld hl, BATTLEANIMSTRUCT_PARAM
	add hl, bc
	ld a, [hl]
	ld hl, BATTLEANIMSTRUCT_JUMPTABLE_INDEX
	add hl, bc
	ld [hl], a
	jmp BattleAnim_IncAnonJumptableIndex

.one ; Obj Param 0
	ld hl, BATTLEANIMSTRUCT_YOFFSET
	add hl, bc
	ld a, [hl]
	add $4
	cp $70
	jr c, .dont_reset_y_offset_one
	xor a
.dont_reset_y_offset_one
	ld [hl], a
	ld hl, BATTLEANIMSTRUCT_XOFFSET
	add hl, bc
	inc [hl]
	inc [hl]
	ret

.two ; Obj Param 1
	ld hl, BATTLEANIMSTRUCT_YOFFSET
	add hl, bc
	ld a, [hl]
	add $4
	cp $70
	jr c, .dont_reset_y_offset_two
	xor a
.dont_reset_y_offset_two
	ld [hl], a
	ld hl, BATTLEANIMSTRUCT_XOFFSET
	add hl, bc
	ld a, [hl]
	add $8
	ld [hl], a
	ret

.three ; Obj Param 2
	ld hl, BATTLEANIMSTRUCT_YOFFSET
	add hl, bc
	ld a, [hl]
	add $4
	cp $70
	jr c, .dont_reset_y_offset_three
	xor a
.dont_reset_y_offset_three
	ld [hl], a
	ld hl, BATTLEANIMSTRUCT_XOFFSET
	add hl, bc
	ld a, [hl]
	add $4
	ld [hl], a
	ret

SECTION "BattleAnimFunc_AnimObjB0: ; unuse", ROMX

BattleAnimFunc_AnimObjB0: ; unused
; Used by object BATTLE_ANIM_OBJ_B0, with itself is not used in any animation
; Obj Param: Lower nybble is added to VAR1 while upper nybble is added to XCOORD
	ld hl, BATTLEANIMSTRUCT_XCOORD
	add hl, bc
	ld d, [hl]
	ld hl, BATTLEANIMSTRUCT_VAR1
	add hl, bc
	ld e, [hl]
	ld hl, BATTLEANIMSTRUCT_PARAM
	add hl, bc
	ld a, [hl]
	ld l, a
	and $f0
	ld h, a
	swap a
	or h
	ld h, a
	ld a, l
	and $f
	swap a
	ld l, a
	add hl, de
	ld e, l
	ld d, h
	ld hl, BATTLEANIMSTRUCT_XCOORD
	add hl, bc
	ld [hl], d
	ld hl, BATTLEANIMSTRUCT_VAR1
	add hl, bc
	ld [hl], e
	ret

SECTION "BattleAnimFunc_PsychUp", ROMX

BattleAnimFunc_PsychUp:
; Object moves in a circle
; Obj Param: Defines starting position in the circle
	ld d, $18
	ld hl, BATTLEANIMSTRUCT_PARAM
	add hl, bc
	ld a, [hl]
	inc [hl]
	jmp BattleAnim_StepCircle

SECTION "BattleAnimFunc_Cotton", ROMX

BattleAnimFunc_Cotton:
; Object moves in a circle slowly
; Obj Param: Defines starting position in the circle
	ld d, $18
	ld hl, BATTLEANIMSTRUCT_VAR2
	add hl, bc
	ld a, [hl]
	inc [hl]
	srl a
	ld hl, BATTLEANIMSTRUCT_PARAM
	add hl, bc
	add [hl]
	jmp BattleAnim_StepCircle

SECTION "BattleAnimFunc_AncientPower", ROMX

BattleAnimFunc_AncientPower:
; Object moves up and down in an arc for $20 frames and then disappears
; Obj Param: Defines range of arc motion
	ld hl, BATTLEANIMSTRUCT_VAR1
	add hl, bc
	ld a, [hl]
	cp $20
	jr nc, .done
	inc [hl]
	ld hl, BATTLEANIMSTRUCT_PARAM
	add hl, bc
	ld d, [hl]
	xcall Sine
	cpl
	inc a
	ld hl, BATTLEANIMSTRUCT_YOFFSET
	add hl, bc
	ld [hl], a
	ret

.done
	jmp DeinitBattleAnimation

SECTION "BattleAnimFunc_RadialMoveOut", ROMX

BattleAnimFunc_RadialMoveOut:
	call BattleAnim_AnonJumptable

	dw InitRadial
	dw Step

BattleAnimFunc_RadialMoveOut_CP_BG:
	call BattleAnim_AnonJumptable

	dw InitRadial
	dw Step_CP_BG

BattleAnimFunc_RadialMoveOut_Slow:
	call BattleAnim_AnonJumptable

	dw InitRadial
	dw Step_Slow

BattleAnimFunc_RadialMoveOut_SlowShort:
	call BattleAnim_AnonJumptable

	dw InitRadial
	dw Step_Slow_Short

BattleAnimFunc_RadialMoveOut_VerySlow:
	call BattleAnim_AnonJumptable

	dw InitRadial
	dw Step_VerySlow

BattleAnimFunc_RadialMoveOut_Fast:
	call BattleAnim_AnonJumptable

	dw InitRadial
	dw Step_Fast

BattleAnimFunc_RadialMoveOut_VeryFast_NoStop:
	call BattleAnim_AnonJumptable

	dw InitRadial
	dw Step_VeryFast_NoStop

InitRadial:
	ld hl, BATTLEANIMSTRUCT_VAR2
	add hl, bc
	xor a
	ld [hld], a
	ld [hl], a ; initial position = 0
	call BattleAnim_IncAnonJumptableIndex

Step:
	call Get_Rad_Pos
	ld hl, 6.0 ; speed
	call Set_Rad_Pos
	cp 80 ; final position
	jmp nc, DeinitBattleAnimation
	jr Rad_Move

Step_CP_BG:
	call Get_Rad_Pos
	ld hl, 0.08 ; speed
	call Set_Rad_Pos
	cp 120 ; final position
	jmp nc, DeinitBattleAnimation
	jr Rad_Move

Step_Slow:
	call Get_Rad_Pos
	ld hl, 1.5 ; speed
	call Set_Rad_Pos
	cp 120 ; final position
	jmp nc, DeinitBattleAnimation
	jr Rad_Move

Step_Slow_Short:
	call Get_Rad_Pos
	ld hl, 1.5 ; speed
	call Set_Rad_Pos
	cp 40 ; final position
	jmp nc, DeinitBattleAnimation
	jr Rad_Move

Step_VerySlow:
	call Get_Rad_Pos
	ld hl, 0.5 ; speed
	call Set_Rad_Pos
	cp 120 ; final position
	jmp nc, DeinitBattleAnimation
	jr Rad_Move

Step_Fast:
	call Get_Rad_Pos
	ld hl, 10.0 ; speed
	call Set_Rad_Pos
	cp 160 ; final position
	jmp nc, DeinitBattleAnimation
	jr Rad_Move

Step_VeryFast_NoStop:
	call Get_Rad_Pos
	ld hl, 15.0 ; speed
	call Set_Rad_Pos
	jr Rad_Move

Get_Rad_Pos:
	ld hl, BATTLEANIMSTRUCT_VAR1
	add hl, bc
	ld a, [hli]
	ld e, [hl]
	ld d, a
	ret

Set_Rad_Pos:
	add hl, de
	ld a, h
	ld e, l
	ld hl, BATTLEANIMSTRUCT_VAR1
	add hl, bc
	ld [hli], a
	ld [hl], e
	ret

Rad_Move:
	ld hl, BATTLEANIMSTRUCT_PARAM
	add hl, bc
	ld e, [hl]
	push de
	ld a, e
	xcall Sine
	ld hl, BATTLEANIMSTRUCT_YOFFSET
	add hl, bc
	ld [hl], a
	pop de
	ld a, e
	xcall Cosine
	ld hl, BATTLEANIMSTRUCT_XOFFSET
	add hl, bc
	ld [hl], a
	ret

SECTION "BattleAnimFunc_RadialMoveIn", ROMX

BattleAnimFunc_RadialMoveIn:
	call BattleAnim_AnonJumptable

	dw .zero
	dw .one

.zero
	call BattleAnim_IncAnonJumptableIndex
	ld hl, BATTLEANIMSTRUCT_VAR1
	add hl, bc
	ld a, 40
	ld [hli], a
	ld [hl], 0
.one
	ld hl, BATTLEANIMSTRUCT_PARAM
	add hl, bc
	ld a, [hl]
	ld hl, BATTLEANIMSTRUCT_VAR1
	add hl, bc
	ld d, [hl]
	push af
	push de
	xcall Sine
	ld hl, BATTLEANIMSTRUCT_YOFFSET
	add hl, bc
	ld [hl], a
	pop de
	pop af
	xcall Cosine
	ld hl, BATTLEANIMSTRUCT_XOFFSET
	add hl, bc
	ld [hl], a
	ld hl, BATTLEANIMSTRUCT_VAR1
	add hl, bc
	ld a, [hli]
	ld d, a
	ld e, [hl]
	ld hl, -4.5
	add hl, de
	jmp nc, DeinitBattleAnimation
	ld e, l
	ld d, h
	ld hl, BATTLEANIMSTRUCT_VAR2
	add hl, bc
	ld a, e
	ld [hld], a
	ld [hl], d
	ret

SECTION "BattleAnimFunc_ObjectHover", ROMX

BattleAnimFunc_ObjectHover:
	call BattleAnim_AnonJumptable

	dw .zero
	dw .one
	dw .two
	dw .three

.zero
	ld hl, BATTLEANIMSTRUCT_YOFFSET
	add hl, bc
	ld a, [hl]
	cp -1
	jr nz, .not_done_climbing
	call BattleAnim_IncAnonJumptableIndex
	ld hl, BATTLEANIMSTRUCT_VAR1
	add hl, bc
	ld [hl], 2
	ret

.not_done_climbing
	ld d, a
	ld hl, BATTLEANIMSTRUCT_VAR1
	add hl, bc
	ld e, [hl]
	ld hl, -$80
	add hl, de
	ld e, l
	ld d, h
	ld hl, BATTLEANIMSTRUCT_YOFFSET
	add hl, bc
	ld [hl], d
	ld hl, BATTLEANIMSTRUCT_VAR1
	add hl, bc
	ld [hl], e
	ret

.one
	ld hl, BATTLEANIMSTRUCT_VAR2
	add hl, bc
	ld a, [hl]
	and a
	jr z, .delay_done
	dec [hl]
	ret

.delay_done
	ld [hl], 4
	ld hl, BATTLEANIMSTRUCT_VAR1
	add hl, bc
	ld a, [hl]
	cpl
	inc a
	ld [hl], a
	ld hl, BATTLEANIMSTRUCT_YOFFSET
	add hl, bc
	add [hl]
	ld [hl], a
	ret

.two
	ld hl, BATTLEANIMSTRUCT_XCOORD
	add hl, bc
	ld a, [hl]
	cp $c0
	ret nc
	ld a, 8
	jmp BattleAnim_StepToTarget

.three
	jmp DeinitBattleAnimation

SECTION "BattleAnimFunc_RockTomb", ROMX

BattleAnimFunc_RockTomb:
	call BattleAnim_AnonJumptable

	dw .zero
	dw .one
	dw DoNothing ; .two

.zero
	call BattleAnim_IncAnonJumptableIndex
	ld hl, BATTLEANIMSTRUCT_VAR1
	add hl, bc
	ld a, $30
	ld [hli], a
	ld [hl], $48
.one
	ld hl, BATTLEANIMSTRUCT_VAR1
	add hl, bc
	ld a, [hli]
	ld d, [hl]
	xcall Sine
	ld hl, BATTLEANIMSTRUCT_YOFFSET
	add hl, bc
	ld [hl], a
	ld hl, BATTLEANIMSTRUCT_VAR1
	add hl, bc
	inc [hl]
	ld a, [hl]
	and $3f
	ret nz
	jmp BattleAnim_IncAnonJumptableIndex

SECTION "BattleAnimFunc_AirCutter", ROMX

BattleAnimFunc_AirCutter:
	call BattleAnim_AnonJumptable

	dw .zero
	dw .one
	dw .two

.zero
	ld hl, BATTLEANIMSTRUCT_PARAM
	add hl, bc
	ld a, [hl]
	and $f0
	swap a
	ld hl, BATTLEANIMSTRUCT_JUMPTABLE_INDEX
	add hl, bc
	ld [hl], a
	ret

.two
	ld hl, BATTLEANIMSTRUCT_VAR1
	add hl, bc
	ld a, [hl]
	ld d, $10
	call Sine
	ld hl, BATTLEANIMSTRUCT_YOFFSET
	add hl, bc
	bit 7, a
	jr z, .skip
	ld [hl], a
.skip
	ld hl, BATTLEANIMSTRUCT_VAR1
	add hl, bc
	ld a, [hl]
	sub 4
	ld [hl], a
.one
	ld hl, BATTLEANIMSTRUCT_XCOORD
	add hl, bc
	ld a, [hl]
	cp $e4
	jmp nc, DeinitBattleAnimation
	ld hl, BATTLEANIMSTRUCT_PARAM
	add hl, bc
	ld a, [hl]
	jmp BattleAnim_StepToTarget

POPS ; restore the original section from the stack
