package states;

import backend.WeekData;
import backend.Highscore;
import backend.Song;

import flixel.group.FlxGroup;
import flixel.graphics.FlxGraphic;

import objects.MenuItem;
import objects.MenuCharacter;

import substates.GameplayChangersSubstate;
import substates.ResetScoreSubState;
import states.MainMenuState;

class StoryMenuState extends MusicBeatState
{
	public static var weekCompleted:Map<String, Bool> = new Map<String, Bool>();

	var scoreText:FlxText;

	private static var lastDifficultyName:String = '';
	var curDifficulty:Int = 1;

	var txtWeekTitle:FlxText;
	var bgSprite:FlxSprite;

	private static var curWeek:Int = 0;

	var txtTracklist:FlxText;

	var difficultyShit:FlxText;

	var grpWeekText:FlxTypedGroup<MenuItem>;
	var grpWeekCharacters:FlxTypedGroup<MenuCharacter>;

	var grpLocks:FlxTypedGroup<FlxSprite>;

	var difficultySelectors:FlxGroup;
	var sprDifficulty:FlxSprite;
	var leftArrow:FlxSprite;
	var rightArrow:FlxSprite;
	var stupidLock:FlxSprite;
	var fuckyouiantgivinup:Bool = true;

	var loadedWeeks:Array<WeekData> = [];

	override function create()
	{

		Paths.clearStoredMemory();
		Paths.clearUnusedMemory();

		var ui_tex = Paths.getSparrowAtlas('menuthingies/storymenu/SM_SelecctionStuffs');

		PlayState.isFNFVerse = false;
		PlayState.isStoryMode = true;
		WeekData.reloadWeekFiles(true, false);
		if(curWeek >= WeekData.weeksList.length) curWeek = 0;
		persistentUpdate = persistentDraw = true;

		scoreText = new FlxText(FlxG.width - 100, 10, 0, "SCORE: 49324858", 36);
		//scoreText.alignment(RIGHT);
		scoreText.setFormat(Paths.font("phantom.ttf"), 32, LEFT);

		txtWeekTitle = new FlxText(10, 10, 0, "", 0);
		txtWeekTitle.setFormat(Paths.font("phantom.ttf"), 32, 0xFFe55777, LEFT);

		difficultyShit = new FlxText(FlxG.width - 300, 10, 0, "Mode: yourmom", 32);
		difficultyShit.setFormat(Paths.font("phantom.ttf"), 32, 0xFFe55777, RIGHT);

		var rankText:FlxText = new FlxText(0, 10);
		rankText.text = 'ARE YOU LOOKING AT THE FILES?';
		rankText.setFormat(Paths.font("phantom.ttf"), 32);
		rankText.size = scoreText.size;
		rankText.screenCenter(X);

		var coolThing:FlxSprite = new FlxSprite(0);
		coolThing.frames = Paths.getSparrowAtlas('menuthingies/storymenu/SM_Coolthing');
		coolThing.screenCenter();
		coolThing.animation.addByPrefix('anim', 'UIThing', 24);
		coolThing.animation.play('anim');
		coolThing.antialiasing = ClientPrefs.data.antialiasing;
		var bgYellow:FlxSprite = new FlxSprite(0, 0).makeGraphic(FlxG.width, 386, 0xFFF9CF51);
		bgSprite = new FlxSprite(0, 84);
		bgSprite.antialiasing = ClientPrefs.data.antialiasing;
		add(bgYellow);
		add(bgSprite);
		//add(grpWeekCharacters);
		add(coolThing);
		

		grpWeekText = new FlxTypedGroup<MenuItem>();
		add(grpWeekText);

		var blackBarThingie:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, 56, FlxColor.BLACK);
		//add(blackBarThingie);

		grpWeekCharacters = new FlxTypedGroup<MenuCharacter>();

		grpLocks = new FlxTypedGroup<FlxSprite>();
		add(grpLocks);

		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		var num:Int = 0;
		for (i in 0...WeekData.weeksList.length)
		{
			var weekFile:WeekData = WeekData.weeksLoaded.get(WeekData.weeksList[i]);
			var isLocked:Bool = weekIsLocked(WeekData.weeksList[i]);
			if(!isLocked || !weekFile.hiddenUntilUnlocked)
			{
				loadedWeeks.push(weekFile);
				WeekData.setDirectoryFromWeek(weekFile);
				var weekThing:MenuItem = new MenuItem(0, bgSprite.y + 8234575, WeekData.weeksList[i]);
				weekThing.y = (1000);
				//weekThing.targetY = num;
				//grpWeekText.add(weekThing);

				weekThing.screenCenter(X);
				// weekThing.updateHitbox();

				// Needs an offset thingie
				num++;
			}
		}

		WeekData.setDirectoryFromWeek(loadedWeeks[0]);
		var charArray:Array<String> = loadedWeeks[0].weekCharacters;
		for (char in 0...3)
		{
			var weekCharacterThing:MenuCharacter = new MenuCharacter((FlxG.width * 0.25) * (1 + char) - 150, charArray[char]);
			weekCharacterThing.y += 70;
			grpWeekCharacters.add(weekCharacterThing);
		}

		difficultySelectors = new FlxGroup();
		add(difficultySelectors);

		leftArrow = new FlxSprite(500, 0);
		leftArrow.antialiasing = ClientPrefs.data.antialiasing;
		leftArrow.frames = ui_tex;
		leftArrow.animation.addByPrefix('idle', "LeftArrow0");
		leftArrow.animation.addByPrefix('press', "LeftArrowSelect");
		leftArrow.animation.play('idle');
		difficultySelectors.add(leftArrow);

		Difficulty.resetList();
		if(lastDifficultyName == '')
		{
			lastDifficultyName = Difficulty.getDefault();
		}
		curDifficulty = Math.round(Math.max(0, Difficulty.defaultList.indexOf(lastDifficultyName)));
		
		sprDifficulty = new FlxSprite(leftArrow.x + leftArrow.width + 10, leftArrow.y);
		sprDifficulty.antialiasing = ClientPrefs.data.antialiasing;
		difficultySelectors.add(sprDifficulty);

		rightArrow = new FlxSprite(0, leftArrow.y);
		rightArrow.antialiasing = ClientPrefs.data.antialiasing;
		rightArrow.frames = ui_tex;
		rightArrow.animation.addByPrefix('idle', 'RightArrow0');
		rightArrow.animation.addByPrefix('press', "RightArrowSelect", 24, false);
		rightArrow.animation.play('idle');
		difficultySelectors.add(rightArrow);

		var tracksSprite:FlxSprite = new FlxSprite(FlxG.width * 0.07, bgSprite.y + 425).loadGraphic(Paths.image('Menu_Tracks'));
		tracksSprite.antialiasing = ClientPrefs.data.antialiasing;
		//add(tracksSprite);

		txtTracklist = new FlxText(FlxG.width * 0.05, tracksSprite.y + 60, 0, "", 32);
		txtTracklist.alignment = CENTER;
		txtTracklist.font = rankText.font;
		txtTracklist.color = 0xFFe55777;
		//add(txtTracklist);
		// add(rankText);
		add(txtWeekTitle);

		changeWeek();
		changeDifficulty();


		leftArrow.x = 362;
		sprDifficulty.x = (leftArrow.x + leftArrow.width + 10);
		rightArrow.x = (sprDifficulty.x + sprDifficulty.width + 10);


		super.create();
		
	}

	override function closeSubState() {
		persistentUpdate = true;
		changeWeek();
		super.closeSubState();
	}

	override function update(elapsed:Float)
	{
		var ui_tex = Paths.getSparrowAtlas('menuthingies/storymenu/SM_SelecctionStuffs');
		if (curWeek == 1)
			{
				add(difficultyShit);
			}
			else
			{
				remove(difficultyShit);
			}
		var difficultyName:String = 'Canon';
		lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, FlxMath.bound(elapsed * 30, 0, 1)));
		if(Math.abs(intendedScore - lerpScore) < 10) lerpScore = intendedScore;
		
		if (curDifficulty <= 2)
		{
			if (lastDifficultyName == 'Normal')
			{
				difficultyName = "Canon";
			}
			else if (lastDifficultyName == 'Hard')
			{
				difficultyName = "Throwback";
			}
			else if (lastDifficultyName == 'Easy')
			{
				difficultyName = "Simple";
			}
		}
		difficultyShit.text = "Mode: " + difficultyName;

		// FlxG.watch.addQuick('font', scoreText.font);

		if (!movedBack && !selectedWeek)
		{
			var upP = controls.UI_LEFT_P;
			var downP = controls.UI_RIGHT_P;
			if (upP)
			{
				changeWeek(-1);
				FlxG.sound.play(Paths.sound('scrollMenu'));
			}

			if (downP)
			{
				changeWeek(1);
				FlxG.sound.play(Paths.sound('scrollMenu'));
			}

			if(FlxG.mouse.wheel != 0)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
				changeWeek(-FlxG.mouse.wheel);
				changeDifficulty();
			}

			if (controls.UI_RIGHT)
				rightArrow.animation.play('press')
			else
				rightArrow.animation.play('idle');

			if (controls.UI_LEFT)
				leftArrow.animation.play('press');
			else
				leftArrow.animation.play('idle');

			if (controls.UI_UP_P)
				changeDifficulty(1);
			else if (controls.UI_DOWN_P)
				changeDifficulty(-1);
			else if (upP || downP)
				changeDifficulty();

			if(FlxG.keys.justPressed.CONTROL)
			{
				persistentUpdate = false;
				openSubState(new GameplayChangersSubstate());
			}
			else if(controls.RESET)
			{
				persistentUpdate = false;
				openSubState(new ResetScoreSubState('', curDifficulty, '', curWeek));
				//FlxG.sound.play(Paths.sound('scrollMenu'));
			}
			else if (controls.ACCEPT)
			{
				selectWeek();
			}
		}

		if (controls.BACK && !movedBack && !selectedWeek)
		{
			FlxG.sound.play(Paths.sound('cancelMenu'));
			movedBack = true;
			MusicBeatState.switchState(new MainMenuState());
			if(FlxG.save.data.achievementsUnlocked != null)
							{
								if(FlxG.save.data.achievementsUnlocked.length == 30)
								{
									FlxG.sound.playMusic(Paths.music('freakyMenuPost'), 0.7);
									// trace("CONGRATULATIONS. YOU DID EVERYTHING. NOW GO TOUCH GRASS PLEASE THANK YOU");
								}
								else
								{
									FlxG.sound.playMusic(Paths.music('freakyMenu'), 0.7);
								}
							}
							else
							{
								FlxG.sound.playMusic(Paths.music('freakyMenu'), 0.7);
							}
		}

		sprDifficulty.setGraphicSize(Std.int(sprDifficulty.width - 10));

		if(txtWeekTitle.width >= leftArrow.x)
		{
			leftArrow.x = (txtWeekTitle.x + txtWeekTitle.width + 25);
			sprDifficulty.x = (leftArrow.x + leftArrow.width + 10);
			rightArrow.x = (sprDifficulty.x + sprDifficulty.width + 10);
			//stupidLock.x = (sprDifficulty.x + (sprDifficulty.width / 2));
		}

		rightArrow.x = (sprDifficulty.x + sprDifficulty.width + 10);

		var songArray:Array<String> = [];
		var leWeek:WeekData = loadedWeeks[curWeek];
		WeekData.setDirectoryFromWeek(leWeek);
		
		bgSprite.visible = true;
		var assetName:String = leWeek.weekBackground;
		if(assetName == null || assetName.length < 1) {
			bgSprite.visible = false;
		} else {
			if (lastDifficultyName == 'Hard' && curDifficulty <= 2 && curWeek == 1)
			{
				bgSprite.loadGraphic(Paths.image('menubackgrounds/menu_' + assetName + '_throwback'));
			}
			else
			{
				bgSprite.loadGraphic(Paths.image('menubackgrounds/menu_' + assetName));
			}
		}

		super.update(elapsed);
		grpLocks.forEach(function(lock:FlxSprite)
		{
			lock.y = grpWeekText.members[lock.ID].y;
			lock.visible = (lock.y > FlxG.height / 2);
		});

	}

	var movedBack:Bool = false;
	var selectedWeek:Bool = false;
	var stopspamming:Bool = false;

	function selectWeek()
	{
		if (!weekIsLocked(loadedWeeks[curWeek].fileName))
		{
			// We can't use Dynamic Array .copy() because that crashes HTML5, here's a workaround.
			var songArray:Array<String> = [];
			var leWeek:Array<Dynamic> = loadedWeeks[curWeek].songs;
			for (i in 0...leWeek.length) {
				songArray.push(leWeek[i][0]);
			}

			// Nevermind that's stupid lmao
			try
			{
				PlayState.storyPlaylist = songArray;
				PlayState.isFNFVerse = false;
				PlayState.isStoryMode = true;
				selectedWeek = true;
	
				var diffic = Difficulty.getFilePath(curDifficulty);
				if(diffic == null) diffic = '';
	
				PlayState.storyDifficulty = curDifficulty;
	
				PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0].toLowerCase() + diffic, PlayState.storyPlaylist[0].toLowerCase());
				PlayState.campaignScore = 0;
				PlayState.campaignMisses = 0;
			}
			catch(e:Dynamic)
			{
				trace('ERROR! $e');
				return;
			}
			
			if (stopspamming == false)
			{
				FlxG.sound.play(Paths.sound('confirmMenu'));

				// grpWeekText.members[curWeek].isFlashing = true;
				for (char in grpWeekCharacters.members)
				{
					if (char.character != '' && char.hasConfirmAnimation)
					{
						char.animation.play('confirm');
					}
				}
				stopspamming = true;
			}

			new FlxTimer().start(1, function(tmr:FlxTimer)
			{
				LoadingState.loadAndSwitchState(new PlayState(), true);
				FreeplayState.destroyFreeplayVocals();
			});
			
			#if (MODS_ALLOWED && cpp)
			DiscordClient.loadModRPC();
			#end
		} else {
			FlxG.sound.play(Paths.sound('cancelMenu'));
		}
	}

	var tweenDifficulty:FlxTween;
	function changeDifficulty(change:Int = 0):Void
	{
		curDifficulty += change;

		if (curDifficulty < 0)
			curDifficulty = Difficulty.list.length-1;
		if (curDifficulty >= Difficulty.list.length)
			curDifficulty = 0;

		WeekData.setDirectoryFromWeek(loadedWeeks[curWeek]);

		var diff:String = Difficulty.getString(curDifficulty);
		var newImage:FlxGraphic = Paths.image(Mods.currentModDirectory + 'storymenu/week' + curWeek);
		trace('Difficulty: ' + '"' + curDifficulty + '"');
		

		if(sprDifficulty.graphic != newImage)
		{
			sprDifficulty.loadGraphic(newImage);
			sprDifficulty.alpha = 0;

			if(tweenDifficulty != null) tweenDifficulty.cancel();
			tweenDifficulty = FlxTween.tween(sprDifficulty, {y: leftArrow.y + 15, alpha: 1}, 0.07, {onComplete: function(twn:FlxTween)
			{
				tweenDifficulty = null;
			}});
		}
		lastDifficultyName = diff;

		#if !switch
		intendedScore = Highscore.getWeekScore(loadedWeeks[curWeek].fileName, curDifficulty);
		#end
	}

	var lerpScore:Int = 0;
	var intendedScore:Int = 0;

	function changeWeek(change:Int = 0):Void
	{
		curWeek += change;

		if (curWeek >= loadedWeeks.length)
			curWeek = 0;
		if (curWeek < 0)
			curWeek = loadedWeeks.length - 1;

		var leWeek:WeekData = loadedWeeks[curWeek];
		WeekData.setDirectoryFromWeek(leWeek);

		var leName:String = leWeek.storyName;
		txtWeekTitle.text = leName.toUpperCase();
		

		var bullShit:Int = 0;

		var unlocked:Bool = !weekIsLocked(leWeek.fileName);
		for (item in grpWeekText.members)
		{
			item.targetY = bullShit - curWeek;
			if (item.targetY == Std.int(0) && unlocked)
				item.alpha = 1;
			else
				item.alpha = 0.6;
			bullShit++;
		}

		bgSprite.visible = true;
		var assetName:String = leWeek.weekBackground;
		if(assetName == null || assetName.length < 1) {
			bgSprite.visible = false;
		} else {
			bgSprite.loadGraphic(Paths.image('menubackgrounds/menu_' + assetName));
		}
		PlayState.storyWeek = curWeek;

		Difficulty.loadFromWeek();
		difficultySelectors.visible = unlocked;

		if(Difficulty.list.contains(Difficulty.getDefault()))
			curDifficulty = Math.round(Math.max(0, Difficulty.defaultList.indexOf(Difficulty.getDefault())));
		else
			curDifficulty = 0;

		var ui_tex = Paths.getSparrowAtlas('menuthingies/storymenu/SM_SelecctionStuffs');
		if (weekIsLocked(WeekData.weeksList[curWeek]))
			{	
				stupidLock = new FlxSprite(0, 0);
				stupidLock.antialiasing = ClientPrefs.data.antialiasing;
				stupidLock.frames = ui_tex;
				stupidLock.animation.addByPrefix('anim', 'stupid lock');
				stupidLock.animation.play('anim');
				stupidLock.screenCenter(X);
				add(stupidLock);
				stupidLock.setGraphicSize(Std.int(sprDifficulty.height));
			}
			else
			{
				remove(stupidLock);
			}

		var newPos:Int = Difficulty.list.indexOf(lastDifficultyName);
		//trace('Pos of ' + lastDifficultyName + ' is ' + newPos);
		if(newPos > -1)
		{
			curDifficulty = newPos;
		}

		leftArrow.x = 362;
		sprDifficulty.x = (leftArrow.x + leftArrow.width + 10);
		//stupidLock.x = (sprDifficulty.x + (sprDifficulty.width / 2));

		if (curWeek == 1)
			{
				curDifficulty = 0; // stop making it throwback by default
				trace("PLEASE FOR THE LOVE OF GOD STOP MAKING IT THROWBACK BY DEFAULT");
			}

		updateText();
	}

	function weekIsLocked(name:String):Bool {
		var leWeek:WeekData = WeekData.weeksLoaded.get(name);
		return (!leWeek.startUnlocked && leWeek.weekBefore.length > 0 && (!weekCompleted.exists(leWeek.weekBefore) || !weekCompleted.get(leWeek.weekBefore)));
	}

	function updateText()
	{
		var weekArray:Array<String> = loadedWeeks[curWeek].weekCharacters;
		for (i in 0...grpWeekCharacters.length) {
			grpWeekCharacters.members[i].changeCharacter(weekArray[i]);
		}

		var leWeek:WeekData = loadedWeeks[curWeek];
		var stringThing:Array<String> = [];
		for (i in 0...leWeek.songs.length) {
			stringThing.push(leWeek.songs[i][0]);
		}

		txtTracklist.text = '';
		for (i in 0...stringThing.length)
		{
			txtTracklist.text += stringThing[i] + '\n';
		}

		txtTracklist.text = txtTracklist.text.toUpperCase();

		txtTracklist.screenCenter(X);
		txtTracklist.x -= FlxG.width * 0.35;

		#if !switch
		intendedScore = Highscore.getWeekScore(loadedWeeks[curWeek].fileName, curDifficulty);
		#end
	}
}
