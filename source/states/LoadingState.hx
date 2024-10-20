package states;

import lime.app.Promise;
import lime.app.Future;

import flixel.FlxState;

import openfl.utils.Assets;
import lime.utils.Assets as LimeAssets;
import lime.utils.AssetLibrary;
import lime.utils.AssetManifest;

import backend.StageData;

import haxe.io.Path;

class LoadingState extends MusicBeatState
{
	inline static var MIN_TIME = 1.0;

	// Browsers will load create(), you can make your song load a custom directory there
	// If you're compiling to desktop (or something that doesn't use NO_PRELOAD_ALL), search for getNextState instead
	// I'd recommend doing it on both actually lol
	
	// TO DO: Make this easier
	
	var target:FlxState;
	var stopMusic = false;
	var directory:String;
	var callbacks:MultiCallback;
	var targetShit:Float = 0;
	var luckything:Int = 0;
	var tipshit:Array<String> =[
		"If you see a monster with yellow eyes, hide in the dark immediately.",
		"To win, you have to press all the notes.",
		"Press SPACE when the game tells you to.",
		"Haxe poopoo kaki",
		"This is the extension of how much I give a shit.",
		"Shelby for the love of god stop dying",
		"Hello! This is the part where I kill you.",
		"I shitted everywhere and ran out of tips",
		"Oh! Veetuhmeens.",
		"Don't die.",
		"Scary dolls are spooky",
		"When in doubt, use targetY",
		"This is not a tip, you will die.",
		"Who the fuck is Giga Ni-",
		"If you see this then you have eyes",
		'"I GOT A CRUCIFIX AT DOOR THWEHLVHEH?" -Fridox, 2023',
		"Someone stop this criminal (yes you've been robbed)",
		"We had to sell the tips because of budget cuts",
		"Fridox will get bitches when PDUIBI 7 drops",
		"Watch Object Cycles when it comes out for the love of god",
		"Oh hello, who are you?",
		"Look Bob, a visitor!",
		"Remember to breathe every now and then.",
		"Adding bloody eyes to your character doesn't make it scary",
		"Era Uma Vez…",
		"Valios",
		"Don't take the fun out of his game.",
		"Type Enzo in any song to get a COOL secret!!1!1",
		"Somewhere, letters. Type his name.",
		"Fridox whenever he needs to add new credits be like",
		"Shut it",
		"Hey kid want a weiner in your mouth",
		"Does anybody even read tips?",
		"This whole loading screen idea was born for accident",
		"The Peak Voice Of A Diva",
		"Want botplay? Code it yourself.",
		"Sub 2 Lorigamer87 so we can get a plush thanks",
		"People who take care of chicken are literally chicken tenders.",
		"This mod is sponsored by Opera GX",
		"The vent. The vent Fridox. The vent.",
		"If you have no health, you lose the song.",
		"This mod is an fnf mod. Crazy, right?",
		"you look like a uhmmmmmm you look like a ummmmm you look like a mmmmmmmm you look like a ummmmmmmmmmmmmmmm",
		"I think @MatPatGT will enjoy dissecting this frame by frame 👀",
		"wiki mfs in shambles rn they gotta add all these loading tips."
	];

	function new(target:FlxState, stopMusic:Bool, directory:String)
	{
		super();
		this.target = target;
		this.stopMusic = stopMusic;
		this.directory = directory;
	}

	var funkay:FlxSprite;
	var loadBar:FlxSprite;
	var tip:FlxText;
	override function create()
	{

		var leDate = Date.now();
		if (leDate.getMonth() == 10)
			tipshit.push("IT IS A SPOOKY MONTH!");
		else
			trace(leDate.getMonth());

		var leDate = Date.now();
		if (leDate.getDate() == 25 && leDate.getMonth() == 12)
			tipshit.push("IT IS KRIMA!!!!!");
		else
			trace(leDate.getDate() + "/" + leDate.getMonth());
		
		if(FlxG.save.data.snName != null)
		{
			tipshit.push("Hey " + FlxG.save.data.snName +  ", are you a beta cuck? -Lumi");
		}
		else
		{
			tipshit.push("Hey User, are you a beta cuck? -Lumi");
		}

		tipshit.push("THIS IS THE 1/" + (tipshit.length + 1) + " TIP SCREEN THAT NO ONE GIVES A FUCK ABOUT!");

		var bg:FlxSprite = new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, 0xffcaff4d);
		bg.antialiasing = ClientPrefs.data.antialiasing;
		add(bg);

		funkay = new FlxSprite(0, 0).loadGraphic(Paths.getPath('images/loadingscreens/image_' + FlxG.random.int(1, 7) + '.png', IMAGE));
		funkay.setGraphicSize(0, FlxG.height);
		funkay.updateHitbox();
		add(funkay);
		funkay.antialiasing = ClientPrefs.data.antialiasing;
		funkay.scrollFactor.set();
		funkay.screenCenter();

		if(FlxG.random.int(1, 1000) == 1000)
			funkay.loadGraphic(Paths.getPath('images/loadingscreens/unknown.png', IMAGE));

		tip = new FlxText(0, FlxG.height - 64, 0, "Tip: " + tipshit[FlxG.random.int(0, (tipshit.length - 1))], 12);
		tip.scrollFactor.set();
		tip.setFormat(Paths.font("phantom.ttf"), 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(tip);

		var loadBarBG:FlxSprite = new FlxSprite(0, FlxG.height - 25).makeGraphic(FlxG.width, 50, 0xff000000);
		loadBarBG.screenCenter(X);
		add(loadBarBG);

		var loadBarBG2:FlxSprite = new FlxSprite(0, FlxG.height - 20).makeGraphic(FlxG.width, 20, 0xffffffff);
		loadBarBG2.screenCenter(X);
		add(loadBarBG2);

		loadBar = new FlxSprite(0, FlxG.height - 20).makeGraphic(FlxG.width, 20, 0xffff16d2);
		loadBar.screenCenter(X);
		add(loadBar);
		
		initSongsManifest().onComplete
		(
			function (lib)
			{
				callbacks = new MultiCallback(onLoad);
				var introComplete = callbacks.add("introComplete");
				/* if (PlayState.SONG != null) {
					checkLoadSong(getSongPath());
					if (PlayState.SONG.needsVoices)
						checkLoadSong(getVocalPath());
				}   */
				if(directory != null && directory.length > 0 && directory != 'shared') {
					checkLibrary('week_assets');
				}

				var fadeTime = 0.5;
				FlxG.camera.fade(FlxG.camera.bgColor, fadeTime, true);
				new FlxTimer().start(fadeTime + MIN_TIME, function(_) introComplete());
			}
		);
	}
	
	function checkLoadSong(path:String)
	{
		if (!Assets.cache.hasSound(path))
		{
			var library = Assets.getLibrary("songs");
			final symbolPath = path.split(":").pop();
			// @:privateAccess
			// library.types.set(symbolPath, SOUND);
			// @:privateAccess
			// library.pathGroups.set(symbolPath, [library.__cacheBreak(symbolPath)]);
			var callback = callbacks.add("song:" + path);
			Assets.loadSound(path).onComplete(function (_) { callback(); });
		}
	}
	
	function checkLibrary(library:String) {
		trace(Assets.hasLibrary(library));
		if (Assets.getLibrary(library) == null)
		{
			@:privateAccess
			if (!LimeAssets.libraryPaths.exists(library))
				throw new haxe.Exception("Missing library: " + library);

			var callback = callbacks.add("library:" + library);
			Assets.loadLibrary(library).onComplete(function (_) { callback(); });
		}
	}
	
	override function update(elapsed:Float)
	{
		super.update(elapsed);
		funkay.setGraphicSize(Std.int(FlxG.width + 0.9 * (funkay.width - FlxG.width)));
		funkay.updateHitbox();
		if(controls.ACCEPT)
		{
			FlxG.sound.play(Paths.sound('scrollMenu'));
			tip.text = "Tip: " + tipshit[FlxG.random.int(0, (tipshit.length - 1))];
			funkay.loadGraphic(Paths.getPath('images/loadingscreens/image_' + FlxG.random.int(1, 7) + '.png', IMAGE));
			funkay.setGraphicSize(Std.int(funkay.width + 60));
			funkay.updateHitbox();
		}

		if(callbacks != null) {
			targetShit = FlxMath.remapToRange(callbacks.numRemaining / callbacks.length, 1, 0, 0, 1);
			loadBar.scale.x += 0.5 * (targetShit - loadBar.scale.x);
		}
	}
	
	function onLoad()
	{
		if (stopMusic && FlxG.sound.music != null)
			FlxG.sound.music.stop();
		
		MusicBeatState.switchState(target);
	}
	
	static function getSongPath()
	{
		return Paths.inst(PlayState.SONG.song);
		trace(Paths.inst(PlayState.SONG.song));
	}
	
	static function getVocalPath()
	{
		return Paths.voices(PlayState.SONG.song);
		trace(Paths.voices(PlayState.SONG.song));
	}
	
	inline static public function loadAndSwitchState(target:FlxState, stopMusic = false)
	{
		MusicBeatState.switchState(getNextState(target, stopMusic));
	}
	
	static function getNextState(target:FlxState, stopMusic = false):FlxState
	{
		var directory:String = 'shared';
		var weekDir:String = StageData.forceNextDirectory;
		StageData.forceNextDirectory = null;

		if(weekDir != null && weekDir.length > 0 && weekDir != '') directory = weekDir;

		Paths.setCurrentLevel(directory);
		trace('Setting asset folder to ' + directory);
		var loaded:Bool = false;
		if (PlayState.SONG != null) {
			loaded = isSoundLoaded(getSongPath()) && (!PlayState.SONG.needsVoices || isSoundLoaded(getVocalPath())) && isLibraryLoaded('week_assets');
		}
		
		if (!loaded)
			return new LoadingState(target, stopMusic, directory);
		if (stopMusic && FlxG.sound.music != null)
			FlxG.sound.music.stop();
		
		return target;
	}
	
	static function isSoundLoaded(path:String):Bool
	{
		trace(path);
		return Assets.cache.hasSound(path);
	}
	
	static function isLibraryLoaded(library:String):Bool
	{
		return Assets.getLibrary(library) != null;
	}
	
	override function destroy()
	{
		super.destroy();
		
		callbacks = null;
	}
	
	static function initSongsManifest()
	{
		var id = "songs";
		var promise = new Promise<AssetLibrary>();

		var library = LimeAssets.getLibrary(id);

		if (library != null)
		{
			return Future.withValue(library);
		}

		var path = id;
		var rootPath = null;

		@:privateAccess
		var libraryPaths = LimeAssets.libraryPaths;
		if (libraryPaths.exists(id))
		{
			path = libraryPaths[id];
			rootPath = Path.directory(path);
		}
		else
		{
			if (StringTools.endsWith(path, ".bundle"))
			{
				rootPath = path;
				path += "/library.json";
			}
			else
			{
				rootPath = Path.directory(path);
			}
			@:privateAccess
			path = LimeAssets.__cacheBreak(path);
		}

		AssetManifest.loadFromFile(path, rootPath).onComplete(function(manifest)
		{
			if (manifest == null)
			{
				promise.error("Cannot parse asset manifest for library \"" + id + "\"");
				return;
			}

			var library = AssetLibrary.fromManifest(manifest);

			if (library == null)
			{
				promise.error("Cannot open library \"" + id + "\"");
			}
			else
			{
				@:privateAccess
				LimeAssets.libraries.set(id, library);
				library.onChange.add(LimeAssets.onChange.dispatch);
				promise.completeWith(Future.withValue(library));
			}
		}).onError(function(_)
		{
			promise.error("There is no asset library with an ID of \"" + id + "\"");
		});

		return promise.future;
	}
}

class MultiCallback
{
	public var callback:Void->Void;
	public var logId:String = null;
	public var length(default, null) = 0;
	public var numRemaining(default, null) = 0;
	
	var unfired = new Map<String, Void->Void>();
	var fired = new Array<String>();
	
	public function new (callback:Void->Void, logId:String = null)
	{
		this.callback = callback;
		this.logId = logId;
	}
	
	public function add(id = "untitled")
	{
		id = '$length:$id';
		length++;
		numRemaining++;
		var func:Void->Void = null;
		func = function ()
		{
			if (unfired.exists(id))
			{
				unfired.remove(id);
				fired.push(id);
				numRemaining--;
				
				if (logId != null)
					log('fired $id, $numRemaining remaining');
				
				if (numRemaining == 0)
				{
					if (logId != null)
						log('all callbacks fired');
					callback();
				}
			}
			else
				log('already fired $id');
		}
		unfired[id] = func;
		return func;
	}
	
	inline function log(msg):Void
	{
		if (logId != null)
			trace('$logId: $msg');
	}
	
	public function getFired() return fired.copy();
	public function getUnfired() return [for (id in unfired.keys()) id];
}