package states;

import flixel.FlxObject;
import states.MainMenuState;

class MoreBangersState extends MusicBeatState
{
    var instructionsText:FlxText;
    var menuItems:FlxTypedGroup<FlxSprite>;
    public static var curSelected:Int = 0;

    var optionShit:Array<String> = [
		'Nafr',
		'Brid',
		'Sim',
	];

    

    override function create()
    {
        var bg:FlxSprite = new FlxSprite(0, -45);
		bg.frames = Paths.getSparrowAtlas('menuthingies/morebangers/bg');
		bg.antialiasing = ClientPrefs.data.antialiasing;
		bg.animation.addByPrefix('bganim', 'more bangers bg', 24);
		bg.animation.play('bganim');
		bg.updateHitbox();
		add(bg);

        var omid:FlxSprite = new FlxSprite(0, 50);
		omid.frames = Paths.getSparrowAtlas('menuthingies/morebangers/OMIDText');
		omid.antialiasing = ClientPrefs.data.antialiasing;
		omid.animation.addByPrefix('omidanim', 'Others', 24);
		omid.animation.play('omidanim');
		omid.updateHitbox();
		omid.screenCenter(X);
		add(omid);

        instructionsText = new FlxText(0, omid.height + 100,
        "Select a cartridge to \ngo to the download page! \n(some mods aren't playable yet!)");
		instructionsText.scrollFactor.set();
		instructionsText.setFormat(Paths.font("phantom.ttf"), 24, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        // instructionsText.screenCenter(X);
		add(instructionsText);
        instructionsText.screenCenter(X);

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

        for (i in 0...optionShit.length)
            {
                //var offset:Float = 108 - (Math.max(optionShit.length, 4) - 4) * 80;
                var menuItem:FlxSprite = new FlxSprite(0, 400);
                menuItem.antialiasing = ClientPrefs.data.antialiasing;
                menuItem.frames = Paths.getSparrowAtlas('menuthingies/morebangers/' + optionShit[i] + 'Cart');
                menuItem.animation.addByPrefix('anim', "Cartdridge", 24);
                menuItem.animation.play('anim');
                menuItems.add(menuItem);
                menuItem.scrollFactor.set(0);
                menuItem.updateHitbox();
                // menuItem.screenCenter(Y);
                menuItem.x = (i * menuItem.width + 40);
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
		if (!selectedSomethin)
            {
                if (controls.UI_LEFT_P)
                    changeItem(-1);
    
                if (controls.UI_RIGHT_P)
                    changeItem(1);
    
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
    
                if (controls.ACCEPT)
                {
                    switch (optionShit[curSelected])
                    {
                            case 'Nafr':
                                CoolUtil.browserLoad('https://gamejolt.com/games/vsnafrox/811022');
                            case 'Brid':
                                CoolUtil.browserLoad('https://gamejolt.com/games/bridgiet/758712');
                            case 'Sim':
                                CoolUtil.browserLoad('https://gamejolt.com/games/MonkeyNightFunkinAlpha/838072');
                    }
                }
            }

        super.update(elapsed);
    }

    function changeItem(huh:Int = 0)
        {
            FlxG.sound.play(Paths.sound('scrollMenu'));
            FlxTween.tween(menuItems.members[curSelected], {y:400, alpha: 0.5}, 0.4, {
                ease: FlxEase.quadOut,
            });
    
            curSelected += huh;
    
            if (curSelected >= menuItems.length)
                curSelected = 0;
            if (curSelected < 0)
                curSelected = menuItems.length - 1;
    
                FlxTween.tween(menuItems.members[curSelected], {y:395, alpha: 1}, 0.4, {
                    ease: FlxEase.quadOut,
                });
        }
}