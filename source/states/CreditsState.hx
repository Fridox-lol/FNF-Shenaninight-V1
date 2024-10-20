package states;

import objects.AttachedSprite;
import states.MainMenuState;
import flixel.group.FlxGroup;

class CreditsState extends MusicBeatState
{
	var filepath:String = 'menuthingies/credits/';

	var curSelected:Int = -1;

	private var grpOptions:FlxTypedGroup<Alphabet>;
	private var iconArray:Array<AttachedSprite> = [];
	private var creditsStuff:Array<Array<String>> = [];

	var bg:FlxSprite;
	var descText:FlxText;
	var intendedColor:FlxColor;
	var colorTween:FlxTween;
	var descBox:AttachedSprite;
	var creditSprite:FlxSprite;
	var creditsName:FlxSprite;
	var page:FlxSprite;
	var curPage:FlxText;
	var leftArrow:FlxSprite;
	var rightArrow:FlxSprite;

	var offsetThing:Float = -75;

    override function create()
    {

		Paths.clearStoredMemory();
		Paths.clearUnusedMemory();

		var ui_tex = Paths.getSparrowAtlas(filepath + 'Credits_arrows');

		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		FlxG.mouse.visible = true;

		var cursor:FlxSprite;
		cursor = new FlxSprite();
		cursor.makeGraphic(15, 15, FlxColor.TRANSPARENT);
		cursor.loadGraphic(Paths.image('cursor'));
		FlxG.mouse.load(cursor.pixels);

		var bg:FlxSprite = new FlxSprite();
		bg.antialiasing = ClientPrefs.data.antialiasing;
		bg.frames = Paths.getSparrowAtlas(filepath + 'bg');
		bg.animation.addByPrefix('bganim', 'beegee anim');
		bg.animation.play('bganim');
		bg.screenCenter();
		add(bg);

		var sidething:FlxSprite = new FlxSprite();
		sidething.antialiasing = ClientPrefs.data.antialiasing;
		sidething.frames = Paths.getSparrowAtlas(filepath + 'Credits_SideBar');
		sidething.animation.addByPrefix('anim', 'CreditsSideThing');
		sidething.animation.play('anim');
		sidething.x = (sidething.width);
		sidething.setGraphicSize(Std.int(sidething.width * 1.25));
		sidething.screenCenter(Y);
		add(sidething);

		var creditslogo:FlxSprite = new FlxSprite(50, 20);
		creditslogo.antialiasing = ClientPrefs.data.antialiasing;
		creditslogo.frames = Paths.getSparrowAtlas(filepath + 'Credits_BopingText');
		creditslogo.animation.addByPrefix('anim', 'CreditsTextBop', 24);
		creditslogo.animation.play('anim');
		add(creditslogo);

		leftArrow = new FlxSprite(sidething.x + 20, 0);
		leftArrow.antialiasing = ClientPrefs.data.antialiasing;
		leftArrow.frames = ui_tex;
		leftArrow.animation.addByPrefix('idle', 'leftArrow instance 1', 24);
		leftArrow.animation.addByPrefix('press', 'leftArrowSelec', 24);
		leftArrow.animation.play('idle');
		add(leftArrow);

		rightArrow = new FlxSprite(0, leftArrow.y);
		rightArrow.antialiasing = ClientPrefs.data.antialiasing;
		rightArrow.frames = ui_tex;
		rightArrow.animation.addByPrefix('idle', 'rightArrow instance 1', 24);
		rightArrow.animation.addByPrefix('press', 'rightArrowSelec', 24);
		rightArrow.animation.play('idle');
		add(rightArrow);
		rightArrow.x = leftArrow.x + ((leftArrow.width + rightArrow.width) + 10);
		
		creditSprite = new FlxSprite();
		creditSprite.antialiasing = ClientPrefs.data.antialiasing;
		add(creditSprite);

		creditsName = new FlxSprite();
		creditsName.antialiasing = ClientPrefs.data.antialiasing;
		add(creditsName);

		page = new FlxSprite(1090, 530).loadGraphic(Paths.image('menuthingies/credits/credits_page_turn'));
		page.antialiasing = ClientPrefs.data.antialiasing;
		page.setGraphicSize(Std.int(page.width / 2));

		grpOptions = new FlxTypedGroup<Alphabet>();
		add(grpOptions);

		var creditList:Array<Array<String>> = [ //Name - Bio
			// ['',		''] lori don't kill me please
			['lori',	'Hey hey hey! It\'s me! Lori! Back again with another mod! To be brief, I was the lead musician, charter, animator, artist and a coding helper...yeah, I did a lot of stuff for this mod and I\'m SOOOO glad I can finally publish this massive story.\nShenani Night was a joke between us at first but then it evolved to this full blown 30+ songs mod you are about to play (or just played)!\n It was a BLAST to make music, art and coding on this mod, and it\'s not the last one I\'ll work on. At least, for now. And it won\'t be the last I\'ll direct. I\'m sure. \n"There is no meme, get on devchat, modafucka"\n\n-Lori 2023-24'],
			['fridox',	'hi i\'m fridox (not like you didn\'t read the name thing at the top)\nanyways, i made the source code of this mod (it was pain)\nwatch bfdi\n\n"Leemon" -Fridox 2022'],
			['donkey',	'Wassup everybody, I\'m Donkey, one of Lori\'s friends and a person who gave him a lot of ideas and most likely a lot of stress /j\n Anyways, with that out of the way, this mod was an absolute pleasure to see be developed and released, and we all hope you all enjoy it! Thats all from me-\n\n“I\'m here to exist, get the gist” \n-Donkey, 2023'],
			['shelby',	'Hi, I\'m Shelby, I honestly don\'t know wtf I\'m doin\' lol.\nBut it\'s a honor to be a part of this mod.\n\n“This is not a tip, I\'m holding you at gunpoint. You\'ll send me all the pictures of your kitten”\n-Shelby 2023'],
			['megann',	'HIII!! this is megann/V3n0va (Creator Of Elle). I was the voice actor for Girlfriend in Tutorial, which was pretty fun to do actually. My honest opinion about the Shenani Night is that I ABSOLUTELY loved it, it\'s really fun and silly and I absolutely love each one of the songs.\n\n"Bees don\'t attack, they dance." -Megann'],
			['sheepSweep',	'Hi guys im the coolest artist and like i im so awesome that nobody can bveat... me......... play uaka night....\n\n20/03/2025 mark my words'],
			['buateds',	'helo guys i made pufball v2 pls subsribc\n\n"cocaine" -buateds 2024'],
			['rede',	'hi guys i made loir im soo pro ohio grimace \n\n"agora ele vai destruir a garrafa com barata"'],
			['flain',	'just silly a charter\n\n"why sans is bald?"'],
			['sogamer',	'cool mod anyways i made some songs and charts and uh yeah\n\n"im so sogamer rn"'],
			['enzo',	'hi i\'m Enzo i do stuff i guess\ni helped composing offbrand lmao\ni\'m a composer i make music that\'s what a composer does\nPLAY OUTCORE IT\'S FREE!!\n\n"Enzo what the hell are you doing?" - not Enzo 2024'],
			['caio',	'Hi im caio, I made music\nI like potatos, and this mod is peak\n\n"the fuck song" -Caio 2024'],
			['sans',	'Despite having currently found out that this mod existed, the truth is that from what I have seen it looks good and I feel that it is a great step for me to be able to work on one of these projects and even more so one that contains such a peculiar look. "Yo soy joto, yo soy joto y maricón, y mi papá es Fox"'],
			['audrey',		'Hey! Audrey here. I\'m an hispanic multi-genre music producer raised and living in Panama that is trying his very best to upgrade further. I work in many music-related projects and I\'m also a video editor.\nWhile being dedicated at everything I do for my career, I also play around with my humor a bit. Also, everything I do is always free, no charge of anything, I love doing stuff for fun and I will be thankful of it and everything else.\nSoon to quit the FNF community for good, but still helping out others to keep going. "Doing it for the funny, no questions asked."'],
			['emzy',		'i am emzy i make  music.\ni helped on da final song k bai\n\n"MEDUKA FNF" -Emzy 2024']
		];

		for(i in creditList) {
			creditsStuff.push(i);
		}

		for (i in 0...creditsStuff.length)
			{
				var isSelectable:Bool = !unselectableCheck(i);
				var optionText:Alphabet = new Alphabet(FlxG.width / 2, 300, creditsStuff[i][0], !isSelectable);
				optionText.isMenuItem = true;
				optionText.targetY = i;
				optionText.changeX = false;
				optionText.snapToPosition();
				//grpOptions.add(optionText);

				if(isSelectable) {
					if(creditsStuff[i][5] != null)
					{
						Mods.currentModDirectory = creditsStuff[i][5];
					}
	
					var str:String = 'credits/missing_icon';
					if(creditsStuff[i][1] != null && creditsStuff[i][1].length > 0)
					{
						var fileName = 'credits/' + creditsStuff[i][1];
						if (Paths.fileExists('images/$fileName.png', IMAGE)) str = fileName;
						else if (Paths.fileExists('images/$fileName-pixel.png', IMAGE)) str = fileName + '-pixel';
					}
	
					var icon:AttachedSprite = new AttachedSprite(str);
					if(str.endsWith('-pixel')) icon.antialiasing = false;
					icon.xAdd = optionText.width + 10;
					icon.sprTracker = optionText;
		
					// using a FlxGroup is too much fuss!
					iconArray.push(icon);
					//add(icon);
					Mods.currentModDirectory = '';
	
					if(curSelected == -1) curSelected = i;
				}
				else optionText.alignment = CENTERED;
			}
			descBox = new AttachedSprite();
			descBox.makeGraphic(1, 1, FlxColor.BLACK);
			descBox.xAdd = -10;
			descBox.yAdd = -10;
			descBox.alphaMult = 0.6;
			descBox.alpha = 0.6;
			// add(descBox);
	
			descText = new FlxText(800, 0, 460, "", 1);
			descText.setFormat(Paths.font("phantom.ttf"), 16, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			descText.scrollFactor.set();
			descText.borderSize = 2.2;
			descBox.sprTracker = descText;
			add(descText);

			curPage = new FlxText(leftArrow.x - 120, (leftArrow.height / 2) - 8, 460, "10 / 10", 1);
			curPage.setFormat(Paths.font("phantom.ttf"), 23, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			curPage.scrollFactor.set();
			curPage.borderSize = 2.2;
			add(curPage);

			add(page);

			var instructons:FlxSprite = new FlxSprite().loadGraphic(Paths.image(filepath + 'Instructions'));
			instructons.antialiasing = ClientPrefs.data.antialiasing;
			add(instructons);
			instructons.y = (FlxG.height - instructons.height);

		changeSelection();
        super.create();
    }

    override function update(elapsed:Float)
    {
		var upP = controls.UI_LEFT_P;
		var downP = controls.UI_RIGHT_P;
		if (upP)
		{
			FlxG.sound.play(Paths.sound('scrollMenu'));
			changeSelection(-1);
		}

		if (downP)
		{
			FlxG.sound.play(Paths.sound('scrollMenu'));
			changeSelection(1);
		}

		if (controls.UI_RIGHT)
			rightArrow.animation.play('press')
		else
			rightArrow.animation.play('idle');

		if (controls.UI_LEFT)
			leftArrow.animation.play('press');
		else
			leftArrow.animation.play('idle');

		if (controls.BACK)
		{
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
		
		for (i in 0...creditsStuff.length)
			{
				creditSprite.loadGraphic(Paths.image(filepath + "portraits/" + creditsStuff[curSelected][0]));
				creditSprite.width = 400;
				creditSprite.height = Std.int(creditSprite.width * 1.5);
				creditSprite.y = (FlxG.height - 512);
				creditSprite.x = (FlxG.width / 10);

				creditsName.loadGraphic(Paths.image(filepath + creditsStuff[curSelected][0]));
				descText.y = ((creditsName.y + creditsName.height) + 20);
				creditsName.x = (FlxG.width - creditsName.width);
			}
		
			if (FlxG.mouse.justPressed && FlxG.mouse.overlaps(page))
				{
					FlxG.sound.play(Paths.sound('turn_' + FlxG.random.int(1, 3)));
                    MusicBeatState.switchState(new TheThanksThatAreSpecialState());
				}

		curPage.text = (curSelected + 1) + " / " + (creditsStuff.length);

        super.update(elapsed);
    }

	function changeSelection(change:Int = 0)
		{
			FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
			do {
				curSelected += change;
				if (curSelected < 0)
					curSelected = creditsStuff.length - 1;
				if (curSelected >= creditsStuff.length)
					curSelected = 0;
			} while(unselectableCheck(curSelected));
	
			var bullShit:Int = 0;
	
			for (item in grpOptions.members)
			{
				item.targetY = bullShit - curSelected;
				bullShit++;
	
				if(!unselectableCheck(bullShit-1)) {
					item.alpha = 0.6;
					if (item.targetY == 0) {
						item.alpha = 1;
					}
				}
			}
	
			descText.text = creditsStuff[curSelected][1];
	
			descBox.setGraphicSize(Std.int(descText.width + 20), Std.int(descText.height + 25));
			descBox.updateHitbox();
		}

	private function unselectableCheck(num:Int):Bool {
		return creditsStuff[num].length <= 1;
	}
}