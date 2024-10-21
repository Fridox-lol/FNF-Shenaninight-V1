package states;

import backend.InputFormatter;
import flixel.FlxObject;
import flixel.input.keyboard.FlxKey;
import flixel.util.FlxSave;
import flash.system.System;
import flixel.tweens.FlxTween;
import states.MainMenuState;
import flixel.addons.effects.chainable.FlxEffectSprite;
import flixel.addons.effects.chainable.FlxGlitchEffect;
#if VIDEOS_ALLOWED
#if (hxCodec >= "3.0.0") import hxcodec.flixel.FlxVideo as VideoHandler;
#elseif (hxCodec >= "2.6.1") import hxcodec.VideoHandler as VideoHandler;
#elseif (hxCodec == "2.6.0") import VideoHandler;
#else import vlc.MP4Handler as VideoHandler; #end
#end

class NameMenuState extends MusicBeatState
{
    var nameText:FlxText;
    var underscores:FlxSprite;
    var confirm:FlxSprite;
    var snName:String;
    var flash:FlxSprite;
    var socool:FlxEffectSprite;
    var glitchy:FlxGlitchEffect;
    var glitchiness:Float = 0;
    /* var hewhoshallnotbenamed:Array<String> = [
        'JOHN',
        'MEEBIES',
        'VOLDEMORT'
    ]; */

    var genAlpha:Array<String> = [
        "SKIBIDI",
        "SIGMA",
        "RIZZ",
        "GYATT",
        "OHIO",
        "GRONK",
        "EDGE",
        "GRIMACE"
    ];

    var slurs:Array<String> = [ //THIS IS FOR THE SOLE PURPOSE OF BANNING PEOPLE FROM TYPING SLURS IN THE NAMES MENU.
        "SLURTEST",
        "NIGGA",
        "NIGGER",
        "NIGGAS",
        "NIGGERS",
        "FAGGOT",
        "FAG",
        "RETARD",
        "RETARDED",
        "TRANNY",
        "CRACKER",
        "NEGROID",
        "CRACKA",
        "HITLER"
    ];
    var devs:Array<String> = [
        "LORI",
        "FRIDOX",
        "DONKEY",
        "SHELBY",
        "MEGANN",
        "SHEEPSWEEP",
        "ATTACKVAN",
        "SOGAMER",
        "ENZO",
        "CAIO",
        "HARU",
        "CTSANS",
        "FLAIN",
        "REDE",
        "BUATEDS",
        "AUDREY",
        "EMZY"
    ];
    var blackOut:FlxSprite;
    var nafrox:FlxSprite;

	override function create()
	{

		Paths.clearStoredMemory();
		Paths.clearUnusedMemory();

		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

        if (FlxG.save.data.snName != null)
        {
            if (FlxG.save.data.snName == "We don't speak his name.")
            {
                FlxG.sound.playMusic(Paths.music('nameMenuNotFunnyMusic'), 0.7);
            }
        }
        

        var cursor:FlxSprite;
		cursor = new FlxSprite();
		cursor.makeGraphic(15, 15, FlxColor.TRANSPARENT);
		cursor.loadGraphic(Paths.image('cursor'));
		FlxG.mouse.load(cursor.pixels);

        FlxG.mouse.visible = true;

        var bg:FlxSprite = new FlxSprite(0);
        bg.frames = Paths.getSparrowAtlas('menuthingies/name/bg');
        bg.antialiasing = ClientPrefs.data.antialiasing;
        bg.animation.addByPrefix('bganim', 'BGAnim', 24);
        bg.animation.play('bganim');
        bg.setGraphicSize(Std.int(bg.width * 1.2));
        bg.scrollFactor.set(2);
        bg.updateHitbox();
        bg.screenCenter();
        add(bg);

		var field:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuthingies/name/name_field'));
		field.antialiasing = ClientPrefs.data.antialiasing;
		field.updateHitbox();
		field.screenCenter();

        if (FlxG.save.data.snName != null)
        {
            if (FlxG.save.data.snName == "We don't speak his name.")
            {
                add(socool = new FlxEffectSprite(field));
                glitchy = new FlxGlitchEffect(4, 10, 0.05);
                socool.effects = [glitchy];
                socool.x = field.x;
                socool.y = field.y;
            }
            else
            {
                add(field);
            }
        }
        else
        {
            add(field);
        }
        

        underscores = new FlxSprite(0).loadGraphic(Paths.image('menuthingies/name/name_field_underscores'));
		underscores.antialiasing = ClientPrefs.data.antialiasing;
		underscores.updateHitbox();
		underscores.screenCenter();
		add(underscores);

        confirm = new FlxSprite(0);
        confirm.frames = Paths.getSparrowAtlas('menuthingies/name/name_button');
        confirm.antialiasing = ClientPrefs.data.antialiasing;
		confirm.animation.addByPrefix('idle', 'button_idle', 24);
        confirm.animation.addByPrefix('select', 'button_select', 24);
		confirm.animation.play('idle');
        confirm.screenCenter(Y);
        confirm.x = (field.x + field.width + 50);
		confirm.updateHitbox();
		add(confirm);

        nameText = new FlxText(357, 0);
        nameText.scrollFactor.set();
        nameText.setFormat(Paths.font("vcr.ttf"), 95, FlxColor.WHITE, CENTER, FlxColor.BLACK);
        nameText.screenCenter(Y);
        add(nameText);

        var text1:FlxText = new FlxText(0, 100, 0, 'CHOOSE YOUR NAME');
        text1.scrollFactor.set();
        text1.setFormat(Paths.font("vcr.ttf"), 80, FlxColor.WHITE, CENTER, FlxColor.BLACK);
        text1.screenCenter(X);
        add(text1);

        var text2:FlxText = new FlxText(0, 500, 0, "(won't affect anything)");
        text2.scrollFactor.set();
        text2.setFormat(Paths.font("vcr.ttf"), 50, FlxColor.WHITE, CENTER, FlxColor.BLACK);
        text2.screenCenter(X);
        add(text2);

        var curName:FlxText = new FlxText(0, FlxG.height - 100, 0, "", 12);
		curName.scrollFactor.set();
		curName.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, CENTER, FlxColor.BLACK);
		add(curName);
		if (FlxG.save.data.snName != null) // null day 3
			{
				if (FlxG.save.data.snName.length > 0)
					{
						if (FlxG.save.data.snName != "OFELIA") //play outcore
							{
								curName.text = "Current name: '" + FlxG.save.data.snName + "'";
							}
					}
			}
            curName.x = (FlxG.width - curName.width) / 2;

		super.create();
	}

	override function update(elapsed:Float)
	{
        if (FlxG.sound.music.volume < 0.8)
            {
                FlxG.sound.music.volume += 0.5 * elapsed;
                if (FreeplayState.vocals != null)
                    FreeplayState.vocals.volume += 0.5 * elapsed;
            }

        nameText.text = snName;

        if (FlxG.keys.firstJustPressed() != -1 && Reflect.getProperty(FlxG.keys.justPressed, InputFormatter.getKeyName(FlxG.keys.firstJustPressed()))) {
            if (snName.length <= 0)
            {
                snName = InputFormatter.getKeyName(FlxG.keys.firstJustPressed());
            }
            else
            {
                snName += InputFormatter.getKeyName(FlxG.keys.firstJustPressed());
            }
            FlxG.sound.play(Paths.sound('type' + FlxG.random.int(1, 4)));
        }

        if (FlxG.keys.justPressed.BACKSPACE) snName = snName.substring(0, snName.length - 1);

        if (snName.length > 10)
            {
                snName = snName.substring(0, snName.length - 1);
                FlxG.sound.play(Paths.sound('cancelMenu'));
            }

        if (snName.length > 0) underscores.alpha = 0; else underscores.alpha = 100;

        if (FlxG.mouse.overlaps(confirm))
        {
            confirm.animation.play('select');
        }
        else
        {
            confirm.animation.play('idle');
        }

        if (FlxG.mouse.justPressed && FlxG.mouse.overlaps(confirm)) //eastereggs
        {
            // toby fox ahh coding
                if (genAlpha.contains(snName))
                    {
                        genAlphaConsequence();
                    }

                if (slurs.contains(snName))
                    {
                        slurConsequence();
                    }
                
                else if (snName == "MEEBIES")
                {
                    if (FlxG.save.data.snName != "We don't speak his name.")
                        {
                            FlxG.sound.music.stop();
                            saveName("We don't speak his name.");
                            var him:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuthingies/name/him'));
                            him.antialiasing = ClientPrefs.data.antialiasing;
                            him.updateHitbox();
                            him.screenCenter();
                            add(him);
                            him.setGraphicSize(Std.int(him.width / 2));
                            new FlxTimer().start(1, function(tmr:FlxTimer)
                                {
                                    System.exit(0);
                                });
                        }
                        else
                        {
                            FlxG.sound.play(Paths.sound('cancelMenu'));
                            glitchy.strength += glitchy.strength;
                            glitchiness += 1;
                            FlxG.sound.play(Paths.music('nameMenuNotFunnyMusic'), 0.7);
                            trace(glitchy.strength);
                            FlxG.camera.shake(glitchiness / 500, 69420, null, true);
                            if (glitchiness <= 3)
                            {
                                flashImage('stop1', 'cancelMenu', false);
                            }
                            else if (glitchiness <= 6)
                            {
                                flashImage('stop2', 'cancelMenu', false);
                            }
                            else if (glitchiness <= 9)
                            {
                                flashImage('stop3', 'cancelMenu', false);
                            }
                            else if (glitchiness <= 12)
                            {
                                flashImage('stop4', 'cancelMenu', false);
                                if (glitchiness == 12)
                                {
                                    Sys.command('mshta vbscript:Execute("msgbox ""TheTruth.txt"":close")');
                                    System.exit(0);
                                }
                            }
                        }
                }
                else if (snName == "LILLIAN")
                {
                    flashImage('gf', 'vinehaha', true);
                }
                else if (snName == "PEDRO")
                {
                    flashImage('pedlo', 'vinehaha', true);
                }
                else if (snName == "BREASTS")
                {
                    flashImage('breasts', 'vinehaha', true);
                }
                else if (snName == "GOKU")
                {
                    flashImage('goku', 'vinehaha', true);
                }
                else if (snName == "YOYLECAKE")
                {
                    flashImage('boible', 'yoylecake', true);
                }
                else if (snName == "LUMI")
                {
                    flashImage('lumi', 'e', true);
                }
                else if (snName == "MAFUYU")
                {
                    flashImage('mafuy', 'vinehaha', true);
                }
                else if (snName == "STFU")
                {
                    FlxG.sound.music.stop();
                }
                else if (snName == "BOYFRIEND")
                {
                    FlxG.camera.flash(ClientPrefs.data.flashing ? FlxColor.WHITE : 0x18FFFFFF, 1);
                    FlxG.sound.play(Paths.sound('nameConfirm'));
                    saveName("BITCH");
                    new FlxTimer().start(1, function(tmr:FlxTimer)
                        {
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
                            MusicBeatState.switchState(new MainMenuState());
                        });
                }
                else if (snName == "VOLDEMORT")
                {
                        FlxG.camera.flash(ClientPrefs.data.flashing ? FlxColor.WHITE : 0x18FFFFFF, 1);
                        FlxG.sound.play(Paths.sound('nameConfirm'));
                        saveName("He Who Shall Not Be Named");
                        new FlxTimer().start(1, function(tmr:FlxTimer)
                            {
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
                            });
                }
                else if (snName == "PENISLAND")
                {
                    playVideo("penisland");
                }
                else if (snName == "VACATIONS")
                {
                    playVideo("Vacations To China");
                }
                else if (snName == "SALAMI")
                {
                    playVideo("salami");
                }
                else if (snName == "CRASH")
                {
                        FlxG.sound.music = null;
                        FlxG.sound.music.stop(); //fridox makes a null object reference error on purpose real
                }
                else if (snName == "NAFROX")
                {
                    FlxG.sound.music.stop();
                    blackOut = new FlxSprite();
                    blackOut.makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
                    add(blackOut);
                    blackOut.alpha = 0;
                    FlxTween.tween(blackOut, {alpha: 1}, 1, {ease: FlxEase.quadInOut, onComplete: nafroxShit});
                }
                else if (snName == "A")
                {
                    Achievements.unlock('creativity');
                    defaultSave(true);
                }
                else if (devs.contains(snName))
                {
                    Achievements.unlock('dont_steal');
                    defaultSave(true);
                }
                else if (snName == "WEINER")
                {
                    flashImage('weiner', 'weiner', true);
                }
                else //default
                {
                    defaultSave(true);
                }
        }
        
        if (FlxG.keys.justPressed.ESCAPE)
			{
				FlxG.sound.play(Paths.sound('cancelMenu'));
                if (FlxG.save.data.snName != "We don't speak his name.")
                    {
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
                        MusicBeatState.switchState(new MainMenuState());
                    }
			}
		super.update(elapsed);
	}

    function saveName(name:String)
    {
        Achievements.unlock('firstName');

        FlxG.save.data.snName = name;
        FlxG.save.flush();
    }

    function flashImage(image:String, sound:String, save:Bool)
    {
        flash = new FlxSprite(0).loadGraphic(Paths.image('menuthingies/name/' + image));
        flash.antialiasing = ClientPrefs.data.antialiasing;
        flash.updateHitbox();
        flash.screenCenter();
        add(flash);
        flash.alpha = 1;
        FlxTween.tween(flash, {alpha: 0}, 0.5, {ease: FlxEase.quadInOut});
        FlxG.sound.play(Paths.sound(sound));
        if (save)
            {
                defaultSave(false);
            }
        
    }

    function crash(tween:FlxTween):Void
    {
        System.exit(0);
    }

    function nafroxShit(tween:FlxTween):Void
    {
        nafrox = new FlxSprite(0).loadGraphic(Paths.image('menuthingies/name/nafrox'));
        nafrox.antialiasing = ClientPrefs.data.antialiasing;
        nafrox.updateHitbox();
        nafrox.screenCenter();
        add(nafrox);
        nafrox.alpha = 0;
        FlxG.camera.shake(0.05, 7, null, true);
        FlxTween.tween(nafrox, {alpha: 1}, 7, {ease: FlxEase.quadIn, onComplete: crash});
        FlxG.sound.play(Paths.sound("nafroxstatic"));
    }

    function genAlphaConsequence()
    {
        FlxG.sound.music.stop();
        saveName("NO!");
        var ram:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuthingies/name/ramdotzip'));
        ram.antialiasing = ClientPrefs.data.antialiasing;
        ram.updateHitbox();
        ram.screenCenter();
        add(ram);
        new FlxTimer().start(1, function(tmr:FlxTimer)
            {
                System.exit(0);
            });
    }

    function slurConsequence()
    {
        flashImage("forbiddenName", "cancelMenu", false);
    }

    function playVideo(name:String)
    {
        #if VIDEOS_ALLOWED
        var video:VideoHandler = new VideoHandler();
        video.play(Paths.video(name));
        FlxG.sound.music.stop();
        // FlxG.sound.playMusic(Paths.music('penisland'), 0.7);
        video.onEndReached.add(function()
        {
            video.dispose();
            FlxG.sound.music.stop();
            defaultSave(false);
        }, true);
        #else
        FlxG.log.warn('Platform not supported!');
        #end
    }

    function defaultSave(flash:Bool = true)
        {
            if(genAlpha.contains(snName))
            {
                saveName("NO!");
                trace("IT SAVED AS NO? LET'S FUCKING G-");
            }
            else
            {
                if(flash)
                    {
                        FlxG.camera.flash(ClientPrefs.data.flashing ? FlxColor.WHITE : 0x18FFFFFF, 1);
                        FlxG.sound.play(Paths.sound('nameConfirm'));
                    }
                saveName(snName);
                trace("Saved name as " + snName);
            }
            new FlxTimer().start(1, function(tmr:FlxTimer)
                {
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
                    MusicBeatState.switchState(new MainMenuState());
                });
        }
}