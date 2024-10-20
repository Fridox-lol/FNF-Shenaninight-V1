package states;

import flixel.FlxObject;
import states.MainMenuState;

class FreeplaySelectState extends MusicBeatState
{
    var optionShit:Array<String> = [
        'MainStory',
        'FNFVerseMode',
	];

    var menuItems:FlxTypedGroup<FlxSprite>;

    public static var curSelected:Int = 0;

    override function create()
    {
        
        FlxG.mouse.visible = true;

        var cursor:FlxSprite;
		cursor = new FlxSprite();
		cursor.makeGraphic(15, 15, FlxColor.TRANSPARENT);
		cursor.loadGraphic(Paths.image('cursor'));
		FlxG.mouse.load(cursor.pixels);

        var bg:FlxSprite = new FlxSprite(0);
		bg.frames = Paths.getSparrowAtlas('menuthingies/freeplae/BG');
		bg.antialiasing = ClientPrefs.data.antialiasing;
		bg.animation.addByPrefix('bganim', 'BGAnim', 24);
		bg.animation.play('bganim');
        bg.setGraphicSize(Std.int(bg.width * 1.2));
        bg.scrollFactor.set(2);
		bg.updateHitbox();
        bg.screenCenter();
		add(bg);

        var sts:FlxSprite = new FlxSprite(0, 25);
		sts.frames = Paths.getSparrowAtlas('menuthingies/freeplae/STSText');
		sts.antialiasing = ClientPrefs.data.antialiasing;
		sts.animation.addByPrefix('stsanim', 'UpperText', 24);
		sts.animation.play('stsanim');
		sts.updateHitbox();
        //sts.scrollFactor.set(1);
		sts.screenCenter(X);
		add(sts);

        var epictext:FlxSprite = new FlxSprite(0, 360).loadGraphic(Paths.image('menuthingies/freeplae/epic_text'));
		epictext.antialiasing = ClientPrefs.data.antialiasing;
		epictext.updateHitbox();
		epictext.screenCenter(X);
        epictext.scrollFactor.set(0);
		add(epictext);

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

        for (i in 0...optionShit.length)
            {
                //var offset:Float = 108 - (Math.max(optionShit.length, 4) - 4) * 80;
                var menuItem:FlxSprite = new FlxSprite(0, 170);
                menuItem.antialiasing = ClientPrefs.data.antialiasing;
                menuItem.frames = Paths.getSparrowAtlas('menuthingies/freeplae/' + optionShit[i] + 'Button');
                menuItem.animation.addByPrefix('anim', optionShit[i], 24);
                menuItem.animation.play('anim');
                menuItems.add(menuItem);
                menuItem.scrollFactor.set(1.5);
                menuItem.updateHitbox();
                // menuItem.screenCenter(Y);
                menuItem.x = (i * menuItem.width + 180);
                if (menuItems.members[i] != menuItems.members[curSelected])
                    {
                        menuItems.members[i].alpha = 0.5;
                    }
                else
                    {
                        menuItems.members[i].alpha = 1;
                    }
            }

        super.create();
    }

    var selectedSomethin:Bool = false;

    override function update(elapsed:Float)
        {

		    FlxG.camera.scroll.x = FlxMath.lerp(FlxG.camera.scroll.x, (FlxG.mouse.screenX-(FlxG.width/2)) * 0.015, (1/30)*240*elapsed);
		    FlxG.camera.scroll.y = FlxMath.lerp(FlxG.camera.scroll.y, (FlxG.mouse.screenY-6-(FlxG.height/2)) * 0.015, (1/30)*240*elapsed);
            if (!selectedSomethin)
                {
                    for (i in 0...optionShit.length)
                        {
                            if (FlxG.mouse.overlaps(menuItems.members[i])) {
            
                                // FlxG.sound.play(Paths.sound('scrollMenu'));
            
                                if (curSelected >= menuItems.length)
                                    curSelected = 0;
                                if (curSelected < 0)
                                    curSelected = menuItems.length - 1;
            
            
                                FlxTween.tween(menuItems.members[i], {y:165, alpha: 1}, 0.4, {
                                    ease: FlxEase.quadOut,
                                });
                            }
                            else
                            {
                                FlxTween.tween(menuItems.members[i], {y:170, alpha: 0.5}, 0.4, {
                                    ease: FlxEase.quadOut,
                                });
                            }
                            //this took so long help me
                        }
        
                    if (controls.BACK)
                    {
                        selectedSomethin = true;
                        FlxG.sound.play(Paths.sound('cancelMenu'));
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
        
                    for (i in 0...optionShit.length)
                        {
                            if (FlxG.mouse.justPressed && FlxG.mouse.overlaps(menuItems.members[i]))
                            {
                        
                                switch (optionShit[i])
                                {
                                        case 'MainStory':
                                            MusicBeatState.switchState(new FreeplayState());
                                        case 'FNFVerseMode':
                                            MusicBeatState.switchState(new FNFVerseState());
                                            
                                }
                            }
                        }
                }
            
    
            super.update(elapsed);
        }

    function changeItem(huh:Int = 0)
        {
            FlxG.sound.play(Paths.sound('scrollMenu'));
            FlxTween.tween(menuItems.members[curSelected], {y:170, alpha: 0.5}, 0.4, {
                ease: FlxEase.quadOut,
            });
    
            curSelected += huh;
    
            if (curSelected >= menuItems.length)
                curSelected = 0;
            if (curSelected < 0)
                curSelected = menuItems.length - 1;
    
                FlxTween.tween(menuItems.members[curSelected], {y:165, alpha: 1}, 0.4, {
                    ease: FlxEase.quadOut,
                });
        }
}