package states;

import flixel.FlxObject;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import lime.app.Application;
import states.editors.MasterEditorMenu;
import options.OptionsState;
import flash.system.System;

class MainMenuState extends MusicBeatState
{
	public static var psychEngineVersion:String = '0.7.2h'; // This is also used for Discord RPC
	public static var curSelected:Int = 0;

	var menuItems:FlxTypedGroup<FlxSprite>;
	var creditsbutton:FlxSprite;
	var namebutton:FlxSprite;
	var earlybutton:FlxSprite;
	var clickable:FlxSprite;
	var funnies:FlxSprite;
	var logoBl:FlxSprite;

	var optionShit:Array<String> = [
		'story_mode',
		'freeplay',
		//#if MODS_ALLOWED 'mods', #end
		//#if ACHIEVEMENTS_ALLOWED 'awards', #end
		//#if !switch 'donate', #end
		'options',
		'more_bangers',
	];

	var magenta:FlxSprite;
	var camFollow:FlxObject;
	var menuItem:FlxSprite;

	var menuasound:Bool = true;
	var menuasound1:Bool = true;
	var menuasound2:Bool = true;
	var menuasound3:Bool = true;
	var creditasound:Bool = true;
	var nameasound:Bool = true;
	var endasound:Bool = true;
	var clickasound:Bool = true;
	var weentwer:FlxTween;
	var tweenter:FlxTween;
	var randomShit:Int = FlxG.random.int(1, 9);
	var postGame:Bool = false;
	var deathbutton:FlxSprite;
	var vignette2:FlxSprite;

	override function create()
	{
		Conductor.bpm = 110;

		FlxG.camera.zoom = 0.5;
		FlxG.mouse.visible = true;

		#if MODS_ALLOWED
		Mods.pushGlobalMods();
		#end
		Mods.loadTopMod();

		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		persistentUpdate = persistentDraw = true;

		if(FlxG.save.data.achievementsUnlocked != null)
			postGame = FlxG.save.data.achievementsUnlocked.contains("all_of_em");

		if((StoryMenuState.weekCompleted.exists("week5") || StoryMenuState.weekCompleted.get("week5")) && (!StoryMenuState.weekCompleted.exists("week6") || !StoryMenuState.weekCompleted.get("week6")))
			FlxG.sound.playMusic(Paths.music('freakierMenu'), 0.7);


		var cursor:FlxSprite;
		cursor = new FlxSprite();
		cursor.makeGraphic(15, 15, FlxColor.TRANSPARENT);
		cursor.loadGraphic(Paths.image('cursor'));
		FlxG.mouse.load(cursor.pixels);

		trace(postGame);
		trace(FlxG.save.data.achievementsUnlocked);

		var bg:FlxSprite = new FlxSprite();
		if(FlxG.save.data.achievementsUnlocked != null)
			if(postGame)
				bg.frames = Paths.getSparrowAtlas('menuthingies/bg_gold');
			else
				bg.frames = Paths.getSparrowAtlas('menuthingies/bg');
		else
			bg.frames = Paths.getSparrowAtlas('menuthingies/bg');
		bg.antialiasing = ClientPrefs.data.antialiasing;
		bg.scrollFactor.set(0);
		//bg.setGraphicSize(Std.int(bg.width * 1.175));
		bg.animation.addByPrefix('bganim', 'BG Anim with logo instance 1', 24);
		bg.animation.play('bganim');
		bg.updateHitbox();
		//bg.screenCenter();
		add(bg);

		logoBl = new FlxSprite(50, 110);
		if(FlxG.save.data.achievementsUnlocked != null)
			if(postGame)
				logoBl.frames = Paths.getSparrowAtlas('logoBumpinGold');
			else
				logoBl.frames = Paths.getSparrowAtlas('logoBumpin');
		else
			logoBl.frames = Paths.getSparrowAtlas('logoBumpin');
		logoBl.antialiasing = ClientPrefs.data.antialiasing;
		logoBl.setGraphicSize(Std.int(logoBl.width / 2));
		logoBl.animation.addByPrefix('bump', 'logo bumpin', 24);
		logoBl.animation.play('bump');
		logoBl.updateHitbox();
		add(logoBl);

		camFollow = new FlxObject(0, 0, 1, 1);
		add(camFollow);

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		for (i in 0...optionShit.length)
		{
			//var offset:Float = 108 - (Math.max(optionShit.length, 4) - 4) * 80;
			menuItem = new FlxSprite(0, (i * 180));
			menuItem.antialiasing = ClientPrefs.data.antialiasing;
			menuItem.frames = Paths.getSparrowAtlas('menuthingies/buttons');
			menuItem.animation.addByPrefix('idle', optionShit[i] + " idle", 24);
			menuItem.animation.addByPrefix('selected', optionShit[i] + " select", 24);
			menuItem.animation.play('idle');
			menuItem.x = FlxG.width - menuItem.width;
			menuItems.add(menuItem);
			menuItem.scrollFactor.set(0);
			menuItem.updateHitbox();
			//menuItem.screenCenter(X);
		}
		if((StoryMenuState.weekCompleted.exists("week5") || StoryMenuState.weekCompleted.get("week5")) && randomShit == 5)
		{
			randomShit = 10;
		}

		funnies = new FlxSprite(25, 350);
		funnies.antialiasing = ClientPrefs.data.antialiasing;
		funnies.frames = Paths.getSparrowAtlas('menuthingies/funnies/funny_' + randomShit);
		funnies.animation.addByPrefix('anim', 'funny_' + randomShit, 24);
		funnies.animation.play('anim');
		funnies.updateHitbox();
		if (randomShit == 3 || randomShit == 4)
		{
			funnies.x = 125;
			funnies.y = 400;
		}
		else if (randomShit == 5)
		{
			FlxG.sound.playMusic(Paths.music('DylanAmbience'));
			funnies.x = 200;
			funnies.y = 440;
		}
		else if (randomShit == 9)
		{
			funnies.x = 100;
			funnies.y = 469;
		} 
		else if (randomShit >= 6 && randomShit != 8 && randomShit != 10)
		{
			funnies.y = 420; //noice
		}
		else if (randomShit == 10)
		{
			funnies.x = 199;
			funnies.y = 455;
		}
		add(funnies);

		var lineouts:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuthingies/lineouts'));
		lineouts.antialiasing = ClientPrefs.data.antialiasing;
		lineouts.scrollFactor.set(0);
		lineouts.updateHitbox();
		lineouts.screenCenter();
		add(lineouts);

		deathbutton = new FlxSprite(0, FlxG.height / 2).loadGraphic(Paths.image('menuthingies/death'));
		deathbutton.antialiasing = ClientPrefs.data.antialiasing;
		deathbutton.scrollFactor.set(0);
		deathbutton.updateHitbox();
		add(deathbutton);

		creditsbutton = new FlxSprite(0);
		creditsbutton.antialiasing = ClientPrefs.data.antialiasing;
		creditsbutton.frames = Paths.getSparrowAtlas('menuthingies/credits_button');
		creditsbutton.x = (menuItem.x - creditsbutton.width);
		creditsbutton.y = (-50);
		creditsbutton.animation.addByPrefix('idle', 'credits_idle');
		creditsbutton.animation.addByPrefix('select', 'credits_select');
		creditsbutton.animation.play('idle');
		add(creditsbutton);
		creditsbutton.scrollFactor.set(0);

		namebutton = new FlxSprite(0);
		namebutton.antialiasing = ClientPrefs.data.antialiasing;
		namebutton.frames = Paths.getSparrowAtlas('menuthingies/name_button');
		namebutton.y = (creditsbutton.y + 40);
		namebutton.animation.addByPrefix('idle', 'name idle');
		namebutton.animation.addByPrefix('select', 'name select');
		namebutton.animation.play('idle');
		add(namebutton);
		namebutton.scrollFactor.set(0);

		clickable = new FlxSprite(0);
		clickable.antialiasing = ClientPrefs.data.antialiasing;
		clickable.frames = Paths.getSparrowAtlas('menuthingies/clickable_trophy');
		clickable.animation.addByPrefix('idle', 'achievements instance 1');
		add(clickable);
		clickable.x = ((FlxG.width / 2) - (clickable.width) - 25);
		clickable.y = ((FlxG.height) - (clickable.height) - 10);
		clickable.scrollFactor.set(0);
		if(FlxG.save.data.achievementsUnlocked == null)
		{
			clickable.x = 10000;
		}

		earlybutton = new FlxSprite(menuItem.x - 175, creditsbutton.height - 50);
		earlybutton.antialiasing = ClientPrefs.data.antialiasing;
		earlybutton.frames = Paths.getSparrowAtlas('menuthingies/the_end');
		earlybutton.animation.addByPrefix('idle', 'end idle');
		earlybutton.animation.addByPrefix('select', 'end select');
		earlybutton.animation.play('idle');
		if(FlxG.save.data.achievementsUnlocked != null)
			if(postGame)
			{
				add(earlybutton);
				clickable.x = ((FlxG.width / 2) - (clickable.width) - 25);
				clickable.y = ((FlxG.height) - (clickable.height) - 10);
			}
			else
			{
				earlybutton.x = 10000;
			}
		else
		{
			earlybutton.x = 10000;
		}
		earlybutton.alpha = 0.75;
		earlybutton.scrollFactor.set(0);

		var curName:FlxText = new FlxText(12, FlxG.height - 64, 0, "You don't have a name, go set up one!", 12);
		curName.scrollFactor.set();
		curName.setFormat(Paths.font("phantom.ttf"), 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(curName);
		if (FlxG.save.data.snName != null) // null day 3
			{
				if (FlxG.save.data.snName.length > 0)
					{
						if (FlxG.save.data.snName != "OFELIA") //play outcore
							{
								curName.text = "Name: '" + FlxG.save.data.snName + "'";
							}

					}
			}
		var psychVer:FlxText = new FlxText(12, FlxG.height - 44, 0, "Psych Engine v" + psychEngineVersion, 12);
		psychVer.scrollFactor.set();
		psychVer.setFormat(Paths.font("phantom.ttf"), 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(psychVer);
		var fnfVer:FlxText = new FlxText(12, FlxG.height - 24, 0, "The Shenani Night v" + Application.current.meta.get('version'), 12);
		fnfVer.scrollFactor.set();
		fnfVer.setFormat(Paths.font("phantom.ttf"), 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(fnfVer);

		var almostdone:FlxText = new FlxText(12, FlxG.height / 2, 0, "You aren't quite done yet... \nBeat any song to \nunlock the last achievement!", 12);
		almostdone.scrollFactor.set();
		almostdone.setFormat(Paths.font("phantom.ttf"), 24, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		if(FlxG.save.data.achievementsUnlocked != null)
			if (FlxG.save.data.achievementsUnlocked.length == 29)
				add(almostdone);

		#if ACHIEVEMENTS_ALLOWED
		// Unlocks "Freaky on a Friday Night" achievement if it's a Friday and between 18:00 PM and 23:59 PM
		var leDate = Date.now();
		if (leDate.getDay() == 5 && leDate.getHours() >= 18)
			Achievements.unlock('friday_night_play');

		#if MODS_ALLOWED
		Achievements.reloadList();
		#end
		#end

		var vignette:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuthingies/vignette'));
		vignette.antialiasing = ClientPrefs.data.antialiasing;
		vignette.scrollFactor.set(0);
		vignette.updateHitbox();
		vignette.screenCenter();
		if (randomShit == 5)
			add(vignette);

		vignette2 = new FlxSprite().loadGraphic(Paths.image('menuthingies/vignette'));
		vignette2.antialiasing = ClientPrefs.data.antialiasing;
		vignette2.scrollFactor.set(0);
		vignette2.updateHitbox();
		vignette2.screenCenter();
		add(vignette2);
		vignette2.alpha = 0;

		var overlay:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuthingies/overlay'));
		overlay.antialiasing = ClientPrefs.data.antialiasing;
		overlay.scrollFactor.set(0);
		overlay.updateHitbox();
		overlay.screenCenter();
		overlay.blend = ADD;
		overlay.alpha = 0.5;
		if(FlxG.save.data.achievementsUnlocked != null)
			if(postGame)
				add(overlay);

		if(FlxG.random.int(1, 1000) != 69) //i had to
			deathbutton.x = 69420;

		super.create();
	}

	var selectedSomethin:Bool = false;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * elapsed;
			if (FreeplayState.vocals != null)
				FreeplayState.vocals.volume += 0.5 * elapsed;
		}

		FlxG.camera.zoom = FlxMath.lerp(1, FlxG.camera.zoom, FlxMath.bound(1 - (elapsed * 3.125 /* * camZoomingDecay * playbackRate */), 0, 1));

		#if debug
		trace("funnies: " + funnies.x + ", " + funnies.y);
		// trace("logo: " + logoBl.x + ", " + logoBl.y);
		#end

		if (!selectedSomethin)
		{

			for (i in 0...optionShit.length)
			{
				if (FlxG.mouse.overlaps(menuItems.members[i])) {

					curSelected == i;
					// FlxG.sound.play(Paths.sound('scrollMenu'));
					

					menuItems.members[i].animation.play('selected');
				}
				else
				{
					menuItems.members[i].animation.play('idle');
				}

			}

			if (FlxG.mouse.overlaps(menuItems.members[0])) {
				if (menuasound)
					{
						FlxG.sound.play(Paths.sound('scrollMenu'));
						menuasound = false;
						trace(menuasound);
						return;
					}
			}
			else
			{
				menuasound = true;
				trace(menuasound);
			}

			if (FlxG.mouse.overlaps(menuItems.members[1])) {
				if (menuasound1)
					{
						FlxG.sound.play(Paths.sound('scrollMenu'));
						menuasound1 = false;
						trace(menuasound1);
						return;
					}
			}
			else
			{
				menuasound1 = true;
				trace(menuasound1);
			}

			if (FlxG.mouse.overlaps(menuItems.members[2])) {
				if (menuasound2)
					{
						FlxG.sound.play(Paths.sound('scrollMenu'));
						menuasound2 = false;
						trace(menuasound2);
						return;
					}
			}
			else
			{
				menuasound2 = true;
				trace(menuasound2);
			}

			if (FlxG.mouse.overlaps(menuItems.members[3])) {
				if (menuasound3)
					{
						FlxG.sound.play(Paths.sound('scrollMenu'));
						menuasound3 = false;
						trace(menuasound3);
						return;
					}
			}
			else
			{
				menuasound3 = true;
				trace(menuasound3);
			}

				
				//this took so long help me

				if (FlxG.mouse.overlaps(creditsbutton))
				{

					creditsbutton.animation.play('select');
					if (creditasound)
						{
							creditasound = false;
							FlxG.sound.play(Paths.sound('scrollMenu'));
						}
				}
				else
				{
					creditasound = true;
					creditsbutton.animation.play('idle');
				}

				if (FlxG.mouse.overlaps(namebutton))
				{
	
					namebutton.animation.play('select');
					if (nameasound)
						{
							nameasound = false;
							FlxG.sound.play(Paths.sound('scrollMenu'));
						}
				}
				else
				{
					nameasound = true;
					namebutton.animation.play('idle');
				}
				if (FlxG.mouse.overlaps(earlybutton))
					{
		
						earlybutton.animation.play('select');
						if (endasound)
							{
								endasound = false;
								FlxG.sound.play(Paths.sound('scrollMenu'));
							}
					}
					else
					{
						endasound = true;
						earlybutton.animation.play('idle');
					}
				if (FlxG.mouse.overlaps(clickable))
				{
					if(tweenter != null)
						tweenter.cancel();
					weentwer = FlxTween.tween(clickable, {alpha: 1}, 0.4, {
						ease: FlxEase.quadOut,
					});
					clickable.updateHitbox();
					clickable.animation.play('idle');
					if (clickasound)
						{
							clickasound = false;
							FlxG.sound.play(Paths.sound('scrollMenu'));
						}
				}
				else
				{
					clickasound = true;
					clickable.animation.stop();
					if(weentwer != null)
						weentwer.cancel();
					tweenter = FlxTween.tween(clickable, {alpha: 0.5}, 0.4, {
						ease: FlxEase.quadOut,
					});
					clickable.updateHitbox();
				}
			if (controls.BACK)
			{
				selectedSomethin = true;
				FlxG.sound.play(Paths.sound('cancelMenu'));
				MusicBeatState.switchState(new TitleState());
			}
			for (i in 0...optionShit.length)
			{
				if (FlxG.mouse.justPressed && (FlxG.mouse.overlaps(menuItems.members[i]) && !FlxG.mouse.overlaps(creditsbutton)))
				{
					FlxG.camera.flash(ClientPrefs.data.flashing ? FlxColor.WHITE : 0x18FFFFFF, 1);
					FlxG.sound.play(Paths.sound('confirmMenu'));
						if (optionShit[curSelected] == 'donate')
						{
							CoolUtil.browserLoad('https://ninja-muffin24.itch.io/funkin');
						}
						else
						{
							selectedSomethin = true;	

							new FlxTimer().start(1, function(tmr:FlxTimer)
							{
								switch (optionShit[i])
								{
									case 'story_mode':
										MusicBeatState.switchState(new StoryMenuState());
									case 'freeplay':
										MusicBeatState.switchState(new FreeplaySelectState());
										if(randomShit != 5)
										{
											FlxG.sound.playMusic(Paths.music('saateotu'), 0.7);
										}

									#if MODS_ALLOWED
									case 'mods':
										MusicBeatState.switchState(new ModsMenuState());
									#end

									#if ACHIEVEMENTS_ALLOWED
									case 'awards':
										MusicBeatState.switchState(new AchievementsMenuState());
									#end

									case 'options':
										MusicBeatState.switchState(new OptionsState());
										OptionsState.onPlayState = false;
										if (PlayState.SONG != null)
										{
											PlayState.SONG.arrowSkin = null;
											PlayState.SONG.splashSkin = null;
											PlayState.stageUI = 'normal';
										}
										case 'more_bangers':
											MusicBeatState.switchState(new MoreBangersState());
								}
						});
						}
					

					for (i in 0...menuItems.members.length)
					{
						if (i == curSelected)
							continue;
					}
				}
				if (FlxG.mouse.justPressed && FlxG.mouse.overlaps(creditsbutton))
				{
					FlxG.camera.flash(ClientPrefs.data.flashing ? FlxColor.WHITE : 0x18FFFFFF, 1);
					FlxG.sound.play(Paths.sound('confirmMenu'));
					selectedSomethin = true;
					new FlxTimer().start(1, function(tmr:FlxTimer)
					{
						MusicBeatState.switchState(new CreditsState());
						if(randomShit != 5)
							{
								FlxG.sound.playMusic(Paths.music('creditsMenuMusic'), 0.7);
							}
					});
				}

				if (FlxG.mouse.justPressed && FlxG.mouse.overlaps(earlybutton))
					{
						FlxG.camera.flash(ClientPrefs.data.flashing ? FlxColor.WHITE : 0x18FFFFFF, 1);
						FlxG.sound.play(Paths.sound('confirmMenu'));
						selectedSomethin = true;
						new FlxTimer().start(1, function(tmr:FlxTimer)
						{
							MusicBeatState.switchState(new EndMenuState());
							if(randomShit != 5)
								{
									FlxG.sound.playMusic(Paths.music('hazbinhotelreference'), 0.7);
								}
						});
					}

				if (FlxG.mouse.justPressed && FlxG.mouse.overlaps(namebutton))
					{
						FlxG.camera.flash(ClientPrefs.data.flashing ? FlxColor.WHITE : 0x18FFFFFF, 1);
						FlxG.sound.play(Paths.sound('confirmMenu'));
						selectedSomethin = true;
						new FlxTimer().start(1, function(tmr:FlxTimer)
						{
							MusicBeatState.switchState(new NameMenuState());
							if(randomShit != 5)
								{
									FlxG.sound.playMusic(Paths.music('nameMenuFunnyMusic'), 0.7);
								}
						});
					}

					if (FlxG.mouse.justPressed && FlxG.mouse.overlaps(clickable))
						{
							FlxG.camera.flash(ClientPrefs.data.flashing ? FlxColor.WHITE : 0x18FFFFFF, 1);
							FlxG.sound.play(Paths.sound('confirmMenu'));
							selectedSomethin = true;
							new FlxTimer().start(1, function(tmr:FlxTimer)
							{
								MusicBeatState.switchState(new AchievementsMenuState());
								if(randomShit != 5)
									{
										FlxG.sound.playMusic(Paths.music('shenaniawards'), 0.7);
									}
							});
						}

					if (FlxG.mouse.justPressed && FlxG.mouse.overlaps(deathbutton))
					{
						FlxG.sound.music.stop();
						FlxG.sound.play(Paths.sound('deathbutton'));
						FlxTween.tween(vignette2, {alpha: 1}, 7);
						new FlxTimer().start(7, function(tmr:FlxTimer)
						{
							System.exit(0);
						});
					}
			}
			#if debug
			if (controls.justPressed('debug_1'))
			{
				selectedSomethin = true;
				MusicBeatState.switchState(new MasterEditorMenu());
			}
			#end
		}
	

		super.update(elapsed);
	}

}