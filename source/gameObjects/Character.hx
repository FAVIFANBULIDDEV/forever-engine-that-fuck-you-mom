package gameObjects;

/**
	The character class initialises any and all characters that exist within gameplay. For now, the character class will
	stay the same as it was in the original source of the game. I'll most likely make some changes afterwards though!
**/
import flixel.FlxG;
import flixel.addons.util.FlxSimplex;
import flixel.animation.FlxBaseAnimation;
import flixel.graphics.frames.FlxAtlasFrames;
import gameObjects.userInterface.HealthIcon;
import meta.*;
import meta.data.*;
import meta.data.dependency.FNFSprite;
import meta.state.PlayState;
import openfl.utils.Assets as OpenFlAssets;
import haxe.Json;
import haxe.format.JsonParser;

using StringTools;

// This does nothing atm
typedef CharacterFile = {
	var image:String;
	var healthIcon:String;
	var healthColor:String;

	var pos:String;
	var flip:Bool;
	var no_antialiasing:Bool;
}

typedef CharacterData =
{
	var offsetX:Float;
	var offsetY:Float;
	var camOffsetX:Float;
	var camOffsetY:Float;
	var quickDancer:Bool;
}

class Character extends FNFSprite
{
	public var debugMode:Bool = false;

	public var isPlayer:Bool = false;
	public var curCharacter:String = 'bf';

	public var barColor:Int;

	public var holdTimer:Float = 0;

	public var characterData:CharacterData;
	public var adjustPos:Bool = true;

	public function new(?isPlayer:Bool = false)
	{
		super(x, y);
		this.isPlayer = isPlayer;
		barColor = isPlayer ? 0xFF66FF33 : 0xFFFF0000;
	}

	public function setCharacter(x:Float, y:Float, character:String):Character
	{
		curCharacter = character;
		var tex:FlxAtlasFrames;
		antialiasing = true;

		characterData = {
			offsetY: 0,
			offsetX: 0,
			camOffsetY: 0,
			camOffsetX: 0,
			quickDancer: false
		};

		switch (curCharacter)
		{
			case 'gf':
				// GIRLFRIEND CODE
				tex = Paths.getSparrowAtlas('characters/sprites/GF_assets');
				frames = tex;
				animation.addByPrefix('cheer', 'GF Cheer', 24, false);
				animation.addByPrefix('singLEFT', 'GF left note', 24, false);
				animation.addByPrefix('singRIGHT', 'GF Right Note', 24, false);
				animation.addByPrefix('singUP', 'GF Up Note', 24, false);
				animation.addByPrefix('singDOWN', 'GF Down Note', 24, false);
				animation.addByIndices('sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
				animation.addByIndices('hairBlow', "GF Dancing Beat Hair blowing", [0, 1, 2, 3], "", 24);
				animation.addByIndices('hairFall', "GF Dancing Beat Hair Landing", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], "", 24, false);
				animation.addByPrefix('scared', 'GF FEAR', 24);

				playAnim('danceRight');
				barColor = 0xFFA5004D;
			case 'gf-christmas':
				tex = Paths.getSparrowAtlas('characters/sprites/gfChristmas');
				frames = tex;
				animation.addByPrefix('cheer', 'GF Cheer', 24, false);
				animation.addByPrefix('singLEFT', 'GF left note', 24, false);
				animation.addByPrefix('singRIGHT', 'GF Right Note', 24, false);
				animation.addByPrefix('singUP', 'GF Up Note', 24, false);
				animation.addByPrefix('singDOWN', 'GF Down Note', 24, false);
				animation.addByIndices('sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
				animation.addByIndices('hairBlow', "GF Dancing Beat Hair blowing", [0, 1, 2, 3], "", 24);
				animation.addByIndices('hairFall', "GF Dancing Beat Hair Landing", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], "", 24, false);
				animation.addByPrefix('scared', 'GF FEAR', 24);

				playAnim('danceRight');
				barColor = 0xFFA5004D;
			case 'gf-car':
				tex = Paths.getSparrowAtlas('characters/sprites/gfCar');
				frames = tex;
				animation.addByIndices('singUP', 'GF Dancing Beat Hair blowing CAR', [0], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat Hair blowing CAR', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat Hair blowing CAR', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24,
					false);

				addOffset('danceLeft', 0);
				addOffset('danceRight', 0);

				playAnim('danceRight');
				barColor = 0xFFA5004D;
			case 'gf-pixel':
				tex = Paths.getSparrowAtlas('characters/sprites/gfPixel');
				frames = tex;
				animation.addByIndices('singUP', 'GF IDLE', [2], "", 24, false);
				animation.addByIndices('danceLeft', 'GF IDLE', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF IDLE', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);

				addOffset('danceLeft', 0);
				addOffset('danceRight', 0);

				playAnim('danceRight');

				setGraphicSize(Std.int(width * PlayState.daPixelZoom));
				updateHitbox();
				antialiasing = false;
				barColor = 0xFFA5004D;
			case 'gf-tankmen':
				frames = Paths.getSparrowAtlas('characters/sprites/gfTankmen');

				animation.addByIndices('sad', 'GF Crying at Gunpoint', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing at Gunpoint', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing at Gunpoint', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);

				playAnim('danceRight');
				barColor = 0xFFA5004D;
			case 'dad':
				// DAD ANIMATION LOADING CODE
				tex = Paths.getSparrowAtlas('characters/sprites/DADDY_DEAREST');
				frames = tex;
				animation.addByPrefix('idle', 'Dad idle dance', 24, false);
				animation.addByPrefix('singUP', 'Dad Sing Note UP', 24);
				animation.addByPrefix('singRIGHT', 'Dad Sing Note RIGHT', 24);
				animation.addByPrefix('singDOWN', 'Dad Sing Note DOWN', 24);
				animation.addByPrefix('singLEFT', 'Dad Sing Note LEFT', 24);

				playAnim('idle');
				barColor = 0xFFAF66CE;
			case 'spooky':
				tex = Paths.getSparrowAtlas('characters/sprites/spooky_kids_assets');
				frames = tex;
				animation.addByPrefix('singUP', 'spooky UP NOTE', 24, false);
				animation.addByPrefix('singDOWN', 'spooky DOWN note', 24, false);
				animation.addByPrefix('singLEFT', 'note sing left', 24, false);
				animation.addByPrefix('singRIGHT', 'spooky sing right', 24, false);
				animation.addByIndices('danceLeft', 'spooky dance idle', [0, 2, 6], "", 12, false);
				animation.addByIndices('danceRight', 'spooky dance idle', [8, 10, 12, 14], "", 12, false);

				characterData.quickDancer = true;

				playAnim('danceRight');
				barColor = 0xFF2E492D;
			case 'mom':
				tex = Paths.getSparrowAtlas('characters/sprites/Mom_Assets');
				frames = tex;

				animation.addByPrefix('idle', "Mom Idle", 24, false);
				animation.addByPrefix('singUP', "Mom Up Pose", 24, false);
				animation.addByPrefix('singDOWN', "MOM DOWN POSE", 24, false);
				animation.addByPrefix('singLEFT', 'Mom Left Pose', 24, false);
				// ANIMATION IS CALLED MOM LEFT POSE BUT ITS FOR THE RIGHT
				// CUZ DAVE IS DUMB!

				// maybe youre just dumb for not telling him to name it that
				// dw im also dumb
				animation.addByPrefix('singRIGHT', 'Mom Pose Left', 24, false);

				playAnim('idle');

				characterData.camOffsetY = 100;
				barColor = 0xFFD8558E;
			case 'mom-car':
				tex = Paths.getSparrowAtlas('characters/sprites/momCar');
				frames = tex;

				animation.addByPrefix('idle', "Mom Idle", 24, false);
				animation.addByIndices('idlePost', 'Mom Idle', [10, 11, 12, 13], "", 24, true);
				animation.addByPrefix('singUP', "Mom Up Pose", 24, false);
				animation.addByPrefix('singDOWN', "MOM DOWN POSE", 24, false);
				animation.addByPrefix('singLEFT', 'Mom Left Pose', 24, false);
				// ANIMATION IS CALLED MOM LEFT POSE BUT ITS FOR THE RIGHT
				// CUZ DAVE IS DUMB!
				animation.addByPrefix('singRIGHT', 'Mom Pose Left', 24, false);

				playAnim('idle');
				barColor = 0xFFD8558E;
			case 'monster':
				tex = Paths.getSparrowAtlas('characters/sprites/Monster_Assets');
				frames = tex;
				animation.addByPrefix('idle', 'monster idle', 24, false);
				animation.addByPrefix('singUP', 'monster up note', 24, false);
				animation.addByPrefix('singDOWN', 'monster down', 24, false);
				animation.addByPrefix('singLEFT', 'Monster Right note', 24, false);
				animation.addByPrefix('singRIGHT', 'Monster left note', 24, false);

				playAnim('idle');
				barColor = 0xFFF3FF6E;
			case 'monster-christmas':
				tex = Paths.getSparrowAtlas('characters/sprites/monsterChristmas');
				frames = tex;
				animation.addByPrefix('idle', 'monster idle', 24, false);
				animation.addByPrefix('singUP', 'monster up note', 24, false);
				animation.addByPrefix('singDOWN', 'monster down', 24, false);
				animation.addByPrefix('singRIGHT', 'Monster left note', 24, false);
				animation.addByPrefix('singLEFT', 'Monster Right note', 24, false);

				playAnim('idle');
				barColor = 0xFFF3FF6E;
			case 'pico':
				tex = Paths.getSparrowAtlas('characters/sprites/Pico_FNF_assetss');
				frames = tex;
				animation.addByPrefix('idle', "Pico Idle Dance", 24, false);
				animation.addByPrefix('singUP', 'pico Up note0', 24, false);
				animation.addByPrefix('singDOWN', 'Pico Down Note0', 24, false);
				if (isPlayer)
				{
					animation.addByPrefix('singLEFT', 'Pico NOTE LEFT0', 24, false);
					animation.addByPrefix('singRIGHT', 'Pico Note Right0', 24, false);
					animation.addByPrefix('singRIGHTmiss', 'Pico Note Right Miss', 24, false);
					animation.addByPrefix('singLEFTmiss', 'Pico NOTE LEFT miss', 24, false);
				}
				else
				{
					// Need to be flipped! REDO THIS LATER!
					animation.addByPrefix('singLEFT', 'Pico Note Right0', 24, false);
					animation.addByPrefix('singRIGHT', 'Pico NOTE LEFT0', 24, false);
					animation.addByPrefix('singRIGHTmiss', 'Pico NOTE LEFT miss', 24, false);
					animation.addByPrefix('singLEFTmiss', 'Pico Note Right Miss', 24, false);
				}

				animation.addByPrefix('singUPmiss', 'pico Up note miss', 24);
				animation.addByPrefix('singDOWNmiss', 'Pico Down Note MISS', 24);

				playAnim('idle');

				flipX = true;
				barColor = 0xFFB7D855;
			case 'bf':
				frames = Paths.getSparrowAtlas('characters/sprites/BOYFRIEND');

				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);
				animation.addByPrefix('hey', 'BF HEY', 24, false);
				animation.addByPrefix('scared', 'BF idle shaking', 24);

				playAnim('idle');

				flipX = true;

				characterData.offsetY = 70;
				barColor = 0xFF31B0D1;
			/*
				case 'bf-og':
					frames = Paths.getSparrowAtlas('characters/sprites/og/BOYFRIEND');

					animation.addByPrefix('idle', 'BF idle dance', 24, false);
					animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
					animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
					animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
					animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
					animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
					animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
					animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
					animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);
					animation.addByPrefix('hey', 'BF HEY', 24, false);
					animation.addByPrefix('scared', 'BF idle shaking', 24);
					animation.addByPrefix('firstDeath', "BF dies", 24, false);
					animation.addByPrefix('deathLoop', "BF Dead Loop", 24, true);
					animation.addByPrefix('deathConfirm', "BF Dead confirm", 24, false);

					playAnim('idle');

					flipX = true;
			 */

			case 'bf-dead':
				frames = Paths.getSparrowAtlas('characters/sprites/BF_DEATH');

				animation.addByPrefix('firstDeath', "BF dies", 24, false);
				animation.addByPrefix('deathLoop', "BF Dead Loop", 24, true);
				animation.addByPrefix('deathConfirm', "BF Dead confirm", 24, false);

				playAnim('firstDeath');

				flipX = true;

			case 'bf-holding-gf':
				frames = Paths.getSparrowAtlas('characters/sprites/bfAndGF');

				animation.addByPrefix('idle', 'BF idle dance w gf', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);

				playAnim('idle');

				flipX = true;
				barColor = 0xFF31B0D1;
			case 'bf-holding-gf-dead':
				frames = Paths.getSparrowAtlas('characters/sprites/bfHoldingGF-DEAD');

				animation.addByPrefix('firstDeath', "BF Dies with GF", 24, false);
				animation.addByPrefix('deathLoop', "BF Dead with GF Loop", 24, true);
				animation.addByPrefix('deathConfirm', "RETRY confirm holding gf", 24, false);

				playAnim('firstDeath');

			case 'bf-christmas':
				var tex = Paths.getSparrowAtlas('characters/sprites/bfChristmas');
				frames = tex;
				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);
				animation.addByPrefix('hey', 'BF HEY', 24, false);

				playAnim('idle');

				flipX = true;
				barColor = 0xFF31B0D1;
			case 'bf-car':
				var tex = Paths.getSparrowAtlas('characters/sprites/bfCar');
				frames = tex;
				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByIndices('idlePost', 'BF idle dance', [8, 9, 10, 11, 12, 13, 14], "", 24, true);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);

				playAnim('idle');

				flipX = true;
				barColor = 0xFF31B0D1;
			case 'bf-pixel':
				frames = Paths.getSparrowAtlas('characters/sprites/bfPixel');
				animation.addByPrefix('idle', 'BF IDLE', 24, false);
				animation.addByPrefix('singUP', 'BF UP NOTE', 24, false);
				animation.addByPrefix('singLEFT', 'BF LEFT NOTE', 24, false);
				animation.addByPrefix('singRIGHT', 'BF RIGHT NOTE', 24, false);
				animation.addByPrefix('singDOWN', 'BF DOWN NOTE', 24, false);
				animation.addByPrefix('singUPmiss', 'BF UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF DOWN MISS', 24, false);

				setGraphicSize(Std.int(width * 6));
				updateHitbox();

				playAnim('idle');

				width -= 100;
				height -= 100;

				antialiasing = false;

				flipX = true;
				barColor = 0xFF31B0D1;
			case 'bf-pixel-dead':
				frames = Paths.getSparrowAtlas('characters/sprites/bfPixelsDEAD');
				animation.addByPrefix('singUP', "BF Dies pixel", 24, false);
				animation.addByPrefix('firstDeath', "BF Dies pixel", 24, false);
				animation.addByPrefix('deathLoop', "Retry Loop", 24, true);
				animation.addByPrefix('deathConfirm', "RETRY CONFIRM", 24, false);
				animation.play('firstDeath');

				// pixel bullshit
				setGraphicSize(Std.int(width * 6));
				updateHitbox();
				antialiasing = false;
				flipX = true;

				characterData.offsetY = 180;

			case 'senpai':
				frames = Paths.getSparrowAtlas('characters/sprites/senpai');
				animation.addByPrefix('idle', 'Senpai Idle', 24, false);
				animation.addByPrefix('singUP', 'SENPAI UP NOTE', 24, false);
				animation.addByPrefix('singLEFT', 'SENPAI LEFT NOTE', 24, false);
				animation.addByPrefix('singRIGHT', 'SENPAI RIGHT NOTE', 24, false);
				animation.addByPrefix('singDOWN', 'SENPAI DOWN NOTE', 24, false);

				playAnim('idle');

				setGraphicSize(Std.int(width * 6));
				updateHitbox();

				antialiasing = false;

				characterData.camOffsetY = -330;
				characterData.camOffsetX = -200;
				barColor = 0xFFFFAA6F;
			case 'senpai-angry':
				frames = Paths.getSparrowAtlas('characters/sprites/senpai');
				animation.addByPrefix('idle', 'Angry Senpai Idle', 24, false);
				animation.addByPrefix('singUP', 'Angry Senpai UP NOTE', 24, false);
				animation.addByPrefix('singLEFT', 'Angry Senpai LEFT NOTE', 24, false);
				animation.addByPrefix('singRIGHT', 'Angry Senpai RIGHT NOTE', 24, false);
				animation.addByPrefix('singDOWN', 'Angry Senpai DOWN NOTE', 24, false);

				setGraphicSize(Std.int(width * 6));
				updateHitbox();

				antialiasing = false;

				characterData.camOffsetY = -330;
				characterData.camOffsetX = -200;
				barColor = 0xFFFFAA6F;
			case 'spirit':
				frames = Paths.getPackerAtlas('characters/sprites/spirit');
				animation.addByPrefix('idle', "idle spirit_", 24, false);
				animation.addByPrefix('singUP', "up_", 24, false);
				animation.addByPrefix('singRIGHT', "right_", 24, false);
				animation.addByPrefix('singLEFT', "left_", 24, false);
				animation.addByPrefix('singDOWN', "spirit down_", 24, false);

				setGraphicSize(Std.int(width * 6));
				updateHitbox();

				playAnim('idle');

				antialiasing = false;
				characterData.quickDancer = true;

				characterData.camOffsetY = 50;
				characterData.camOffsetX = 100;

			case 'parents-christmas':
				frames = Paths.getSparrowAtlas('characters/sprites/mom_dad_christmas_assets');
				animation.addByPrefix('idle', 'Parent Christmas Idle', 24, false);
				animation.addByPrefix('singUP', 'Parent Up Note Dad', 24, false);
				animation.addByPrefix('singDOWN', 'Parent Down Note Dad', 24, false);
				animation.addByPrefix('singLEFT', 'Parent Left Note Dad', 24, false);
				animation.addByPrefix('singRIGHT', 'Parent Right Note Dad', 24, false);

				animation.addByPrefix('singUP-alt', 'Parent Up Note Mom', 24, false);

				animation.addByPrefix('singDOWN-alt', 'Parent Down Note Mom', 24, false);
				animation.addByPrefix('singLEFT-alt', 'Parent Left Note Mom', 24, false);
				animation.addByPrefix('singRIGHT-alt', 'Parent Right Note Mom', 24, false);

				playAnim('idle');
				barColor = 0xFFD655B6;
			default:
				// set up animations if they aren't already

				// This isn't made to be good, this is just a temporary code incase the character hasn't been added to
				// code yet. I may update this and make this better but for now this is what there is.
				// There is currently no detection to health bar colors or custom animations.
				var fileNew = curCharacter;
				if (OpenFlAssets.exists(Paths.offsetTxt(fileNew)))
				{
					frames = Paths.getSparrowAtlas('characters/sprites/$curCharacter'); // xml name must go off their character name in game (for instant: bf, gf-car, senpai-angry)
					animation.addByPrefix('idle', 'idle', 24, false); // every single animation name should go off of this.

					animation.addByPrefix('singUP', 'up', 24, false);
					animation.addByPrefix('singDOWN', 'down', 24, false);
					animation.addByPrefix('singLEFT', 'left', 24, false);
					animation.addByPrefix('singRIGHT', 'right', 24, false);
	
					animation.addByPrefix('singUP-alt', 'up alt', 24, false);
					animation.addByPrefix('singDOWN-alt', 'down alt', 24, false);
					animation.addByPrefix('singLEFT-alt', 'left alt', 24, false);
					animation.addByPrefix('singRIGHT-alt', 'right alt', 24, false);

					animation.addByPrefix('singUPmiss', 'up miss', 24, false);
					animation.addByPrefix('singLEFTmiss', 'left miss', 24, false);
					animation.addByPrefix('singRIGHTmiss', 'right miss', 24, false);
					animation.addByPrefix('singDOWNmiss', 'down miss', 24, false);
	
					playAnim('idle');
				}
				else
					return setCharacter(x, y, 'bf');
		}

		// set up offsets cus why not
		// Offsets is pretty much needed lol
		if (OpenFlAssets.exists(Paths.offsetTxt('offsets/' + curCharacter + 'Offsets')))
		{
			var characterOffsets:Array<String> = CoolUtil.coolTextFile(Paths.offsetTxt('offsets/' + curCharacter + 'Offsets'));
			for (i in 0...characterOffsets.length)
			{
				var getterArray:Array<Array<String>> = CoolUtil.getOffsetsFromTxt(Paths.offsetTxt('offsets/' + curCharacter + 'Offsets'));
				addOffset(getterArray[i][0], Std.parseInt(getterArray[i][1]), Std.parseInt(getterArray[i][2]));
			}
		}

		dance();

		if (isPlayer) // fuck you ninjamuffin lmao
		{
			flipX = !flipX;

			// Doesn't flip for BF, since his are already in the right place???
			if (!curCharacter.startsWith('bf'))
				flipLeftRight();
			//
		}
		else if (curCharacter.startsWith('bf'))
			flipLeftRight();

		if (adjustPos)
		{
			x += characterData.offsetX;
			trace('character ${curCharacter} scale ${scale.y}');
			y += (characterData.offsetY - (frameHeight * scale.y));
		}

		this.x = x;
		this.y = y;

		return this;
	}

	function flipLeftRight():Void
	{
		// get the old right sprite
		var oldRight = animation.getByName('singRIGHT').frames;

		// set the right to the left
		animation.getByName('singRIGHT').frames = animation.getByName('singLEFT').frames;

		// set the left to the old right
		animation.getByName('singLEFT').frames = oldRight;

		// insert ninjamuffin screaming I think idk I'm lazy as hell

		if (animation.getByName('singRIGHTmiss') != null)
		{
			var oldMiss = animation.getByName('singRIGHTmiss').frames;
			animation.getByName('singRIGHTmiss').frames = animation.getByName('singLEFTmiss').frames;
			animation.getByName('singLEFTmiss').frames = oldMiss;
		}
	}

	override function update(elapsed:Float)
	{
		if (!isPlayer)
		{
			if (animation.curAnim.name.startsWith('sing'))
			{
				holdTimer += elapsed;
			}

			var dadVar:Float = 4;
			if (holdTimer >= Conductor.stepCrochet * dadVar * 0.001)
			{
				dance();
				holdTimer = 0;
			}
		}

		var curCharSimplified:String = simplifyCharacter();
		switch (curCharSimplified)
		{
			case 'gf':
				if (animation.curAnim.name == 'hairFall' && animation.curAnim.finished)
					playAnim('danceRight');
				if ((animation.curAnim.name.startsWith('sad')) && (animation.curAnim.finished))
					playAnim('danceLeft');
		}

		// Post idle animation (think Week 4 and how the player and mom's hair continues to sway after their idle animations are done!)
		if (animation.curAnim.finished && animation.curAnim.name == 'idle')
		{
			// We look for an animation called 'idlePost' to switch to
			if (animation.getByName('idlePost') != null)
				// (( WE DON'T USE 'PLAYANIM' BECAUSE WE WANT TO FEED OFF OF THE IDLE OFFSETS! ))
				animation.play('idlePost', true, false, 0);
		}

		super.update(elapsed);
	}

	private var danced:Bool = false;

	/**
	 * FOR GF DANCING SHIT
	 */
	public function dance(?forced:Bool = false)
	{
		if (!debugMode)
		{
			var curCharSimplified:String = simplifyCharacter();
			switch (curCharSimplified)
			{
				case 'gf':
					if ((!animation.curAnim.name.startsWith('hair')) && (!animation.curAnim.name.startsWith('sad')))
					{
						danced = !danced;

						if (danced)
							playAnim('danceRight', forced);
						else
							playAnim('danceLeft', forced);
					}
				default:
					// Left/right dancing, think Skid & Pump
					if (animation.getByName('danceLeft') != null && animation.getByName('danceRight') != null)
					{
						danced = !danced;
						if (danced)
							playAnim('danceRight', forced);
						else
							playAnim('danceLeft', forced);
					}
					else
						playAnim('idle', forced);
			}
		}
	}

	override public function playAnim(AnimName:String, Force:Bool = false, Reversed:Bool = false, Frame:Int = 0):Void
	{
		if (animation.getByName(AnimName) != null)
			super.playAnim(AnimName, Force, Reversed, Frame);

		if (curCharacter == 'gf')
		{
			if (AnimName == 'singLEFT')
				danced = true;
			else if (AnimName == 'singRIGHT')
				danced = false;

			if (AnimName == 'singUP' || AnimName == 'singDOWN')
				danced = !danced;
		}
	}

	public function simplifyCharacter():String
	{
		var base = curCharacter;

		if (base.contains('-'))
			base = base.substring(0, base.indexOf('-'));
		return base;
	}
}
