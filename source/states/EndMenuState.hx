package states;

import objects.AttachedSprite;
import flixel.FlxState;

class EndMenuState extends MusicBeatState
{
    var curPage:Int = 1;
    var book:FlxSprite;

	override public function create()
	{
        book = new FlxSprite().loadGraphic(Paths.image('menuthingies/end/page_1'));
		book.antialiasing = ClientPrefs.data.antialiasing;
		book.scrollFactor.set(0);
		book.updateHitbox();
		book.screenCenter();
		add(book);
		super.create();
	}

	override public function update(elapsed:Float)
	{

        if(controls.UI_LEFT_P)
        {
            changePage(-1);
            if(curPage > 1)
            {
                FlxG.sound.play(Paths.sound('turn_' + FlxG.random.int(1, 3)));
            }
        }
        if(controls.UI_RIGHT_P)
        {
            changePage(1);
            if(curPage < 5)
            {
                FlxG.sound.play(Paths.sound('turn_' + FlxG.random.int(1, 3)));
            }
        }
        if (controls.BACK)
			{
				FlxG.sound.play(Paths.sound('cancelMenu'));
				MusicBeatState.switchState(new MainMenuState());
                FlxG.sound.playMusic(Paths.music('freakyMenuPost'), 0.7);
			}
		super.update(elapsed);
	}

    function changePage(change:Int = 0)
    {
        curPage += change;
        if(curPage > 5)
            curPage = 5;
        if(curPage < 1)
            curPage = 1;
        trace(curPage);
        if(curPage > 0 && curPage < 6)
            {
                book.loadGraphic(Paths.image('menuthingies/end/page_' + curPage));
            }
    }
}