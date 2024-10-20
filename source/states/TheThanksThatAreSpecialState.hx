package states;

import flixel.FlxState;

class TheThanksThatAreSpecialState extends MusicBeatState
{
	var filepath:String = 'menuthingies/credits/specialthanks/';
	var thetextintheboxatthebottom:FlxText;
	var page:FlxSprite;
	var simontincs:FlxSprite;
	var psychward:FlxSprite;
	var impostor:FlxSprite;
	var latenightcitytales:FlxSprite;

	override public function create()
	{
		var bg:FlxSprite = new FlxSprite();
		bg.antialiasing = ClientPrefs.data.antialiasing;
		bg.loadGraphic(Paths.image(filepath + 'credits_bg'));
		bg.screenCenter();
		add(bg);

		var specthankslogo:FlxSprite = new FlxSprite(50, 20);
		specthankslogo.antialiasing = ClientPrefs.data.antialiasing;
		specthankslogo.frames = Paths.getSparrowAtlas(filepath + 'SpecialThanksText');
		specthankslogo.animation.addByPrefix('anim', 'SpecialText', 24);
		specthankslogo.animation.play('anim');
		add(specthankslogo);
		
		simontincs = new FlxSprite(50, specthankslogo.height + 100);
		simontincs.antialiasing = ClientPrefs.data.antialiasing;
		simontincs.loadGraphic(Paths.image(filepath + 'simontincs'));
		add(simontincs);

		psychward = new FlxSprite(50, simontincs.y + 100);
		psychward.antialiasing = ClientPrefs.data.antialiasing;
		psychward.loadGraphic(Paths.image(filepath + 'psychward'));
		add(psychward);

		impostor = new FlxSprite(50, psychward.y + 100);
		impostor.antialiasing = ClientPrefs.data.antialiasing;
		impostor.loadGraphic(Paths.image(filepath + 'impostor'));
		add(impostor);

		latenightcitytales = new FlxSprite(50, impostor.y + 100);
		latenightcitytales.antialiasing = ClientPrefs.data.antialiasing;
		latenightcitytales.loadGraphic(Paths.image(filepath + 'latenightcitytales'));
		add(latenightcitytales);

		var theboxatthebottom:FlxSprite = new FlxSprite(50, 20);
		theboxatthebottom.antialiasing = ClientPrefs.data.antialiasing;
		theboxatthebottom.frames = Paths.getSparrowAtlas(filepath + 'specialCreditsBox');
		theboxatthebottom.animation.addByPrefix('anim', 'textBox', 24);
		theboxatthebottom.animation.play('anim');
		add(theboxatthebottom);
		theboxatthebottom.x = (FlxG.width - theboxatthebottom.width);
		theboxatthebottom.y = (FlxG.height - theboxatthebottom.height);

		thetextintheboxatthebottom = new FlxText(theboxatthebottom.x + 75, theboxatthebottom.y + 50, 500, 'Hover over one of the people to view their contribution');
		thetextintheboxatthebottom.setFormat(Paths.font("phantom.ttf"), 25, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(thetextintheboxatthebottom);

		page = new FlxSprite(-64, 530).loadGraphic(Paths.image(filepath + 'credits_page_turn'));
		page.antialiasing = ClientPrefs.data.antialiasing;
		page.setGraphicSize(Std.int(page.width / 2));
		add(page);

		super.create();
	}

	override public function update(elapsed:Float)
	{
		if (FlxG.mouse.overlaps(simontincs))
		{
			thetextintheboxatthebottom.text = 'Made Liro and the HUD in Infyltratour in Contact';
		}
		else if (FlxG.mouse.overlaps(psychward))
		{
			thetextintheboxatthebottom.text = 'Helped us with a lot of source coding';
		}
		else if (FlxG.mouse.overlaps(impostor))
		{
			thetextintheboxatthebottom.text = 'Made all the Among Us songs BGs';
		}
		else if (FlxG.mouse.overlaps(latenightcitytales))
		{
			thetextintheboxatthebottom.text = 'Created Limu\'s character and the BG used in Aquaphobia';
		}

		if (FlxG.mouse.justPressed && FlxG.mouse.overlaps(page))
			{
				FlxG.sound.play(Paths.sound('turn_' + FlxG.random.int(1, 3)));
				MusicBeatState.switchState(new CreditsState());
			}
		super.update(elapsed);
	}
}