package backend;

#if ACHIEVEMENTS_ALLOWED
import objects.AchievementPopup;
import haxe.Exception;
import haxe.Json;

#if LUA_ALLOWED
import psychlua.FunkinLua;
#end

typedef Achievement =
{
	var name:String;
	var description:String;
	@:optional var hidden:Bool;
	@:optional var maxScore:Float;
	@:optional var maxDecimals:Int;

	//handled automatically, ignore these two
	@:optional var mod:String;
	@:optional var ID:Int; 
}

class Achievements {
	public static function init()
	{ // createAchievement('',				{name: "", description: ""});
		createAchievement('friday_night_play',				{name: "Freaky on a Shenani Night", description: "Play on a Shenani Night.", hidden: true});
		createAchievement('week1_nomiss',					{name: "Shatterer", description: "Beat Chapter 1 in Canon Mode with no Misses."});
		createAchievement('week2_nomiss',					{name: "The Meme Is Not Funny Anymore", description: "Beat Chapter 2 with no Misses."});
		createAchievement('week3_nomiss',					{name: "Bested 'Em", description: "Beat Chapter 3 with no Misses."});
		createAchievement('week4_nomiss',					{name: "Dagger Up Your Ass", description: "Beat Chapter 4 with no Misses."});
		createAchievement('week5_nomiss',					{name: "Speakin' In Gunshots", description: "Beat Chapter 5 with no Misses."});
		createAchievement('week6_nomiss',					{name: "God Slayer", description: "Beat Chapter 6 with no Misses."});
		createAchievement('week1_nomiss_throw',				{name: "Don't Forget The Old Times", description: "Beat Chapter 1 in Throwback Mode with no misses."});
		createAchievement('duro',							{name: "Damn He Really Is Hard", description: "Play 'Duro'."});
		createAchievement('sogamma',						{name: "So Much Gaming", description: "Play 'Sogamma'."});
		createAchievement('controllerPlay',					{name: "Nintendo Approved", description: "Have you ever tried playing with a controller?"});
		createAchievement('sofrido',						{name: "No Longer Sofrido", description: "Find and click Menino Sofrido in one of the backgrounds."});
		createAchievement('ur_suck',						{name: "Blud thinks he's good at this", description: "Die over 100 times.", maxScore: 100, maxDecimals: 0});
		createAchievement('death_by_tortilla',				{name: "How To NOT Funk", description: "Prove your absolute skills by dying in the goddamn TUTORIAL."});
		createAchievement('firstName',						{name: "Fuck Your Old Name", description: "Give yourself a name in the names menu."});
		createAchievement('ur_good',						{name: "Bones Breaker", description: "Complete a Song with a rating of 100%."});
		createAchievement('ur_bad',							{name: "I Have No Words That How You Suck", description: "Complete a Song with a rating lower than 20%."});
		createAchievement('noice',							{name: "Hehe Funni", description: "Get a 69% accuracy in any song."});
		createAchievement('failure',						{name: "What A Shenani-Failure", description: "Get an accuracy of 10% or lower in any song, this is absolutely terrible!"});
		createAchievement('you_cheated',					{name: "How", description: "Enable Botplay (somehow???)"});
		createAchievement('close_call',						{name: "Close Call", description: "Beat a boss fight song with only 1 HP left."});
		createAchievement('bad_wifi',						{name: "McDonald's Wifi", description: "Beat Devchattin' with the worst fps possible."});
		createAchievement('creativity',						{name: "Creativity At Its Finest", description: "Name yourself A."});
		createAchievement('dont_steal',						{name: "Identity Fraud", description: "Name yourself as one of the devs."});
		createAchievement('namebeat0001',					{name: "Self Titled", description: "Beat the mod named as anyone of the Shenanigoonies."});
		createAchievement('namebeat0002',					{name: "OHHHH YOU'RE GOOD AT THIS", description: "Beat the mod named as Simontincs."});
		createAchievement('namebeat0003',					{name: "Take That Dagger And Shove It Up The Sky", description: "Beat the mod named as Dylan."});
		createAchievement('namebeat0004',					{name: "Did You Just Kill Yourself", description: "Beat the mod named as Galaxtor."});
		createAchievement('namebeat0005',					{name: "That's It I'm Telling", description: "Beat the mod named as either Laptox or Stari."});
		createAchievement('all_of_em',						{name: "Shenani Platinum", description: "Prove your supremacy by 100%ing a stupid mod of a beep boop game. Now go outside.", hidden: true});
		
		//dont delete this thing below
		_originalLength = _sortID + 1;
	}

	public static var achievements:Map<String, Achievement> = new Map<String, Achievement>();
	public static var variables:Map<String, Float> = [];
	public static var achievementsUnlocked:Array<String> = [];
	private static var _firstLoad:Bool = true;

	public static function get(name:String):Achievement
		return achievements.get(name);
	public static function exists(name:String):Bool
		return achievements.exists(name);

	public static function load():Void
	{
		if(!_firstLoad) return;

		if(_originalLength < 0) init();

		if(FlxG.save.data != null) {
			if(FlxG.save.data.achievementsUnlocked != null)
				achievementsUnlocked = FlxG.save.data.achievementsUnlocked;

			var savedMap:Map<String, Float> = cast FlxG.save.data.achievementsVariables;
			if(savedMap != null)
			{
				for (key => value in savedMap)
				{
					variables.set(key, value);
				}
			}
			_firstLoad = false;
		}
	}

	public static function save():Void
	{
		FlxG.save.data.achievementsUnlocked = achievementsUnlocked;
		FlxG.save.data.achievementsVariables = variables;
	}
	
	public static function getScore(name:String):Float
		return _scoreFunc(name, 0);

	public static function setScore(name:String, value:Float, saveIfNotUnlocked:Bool = true):Float
		return _scoreFunc(name, 1, value, saveIfNotUnlocked);

	public static function addScore(name:String, value:Float = 1, saveIfNotUnlocked:Bool = true):Float
		return _scoreFunc(name, 2, value, saveIfNotUnlocked);

	//mode 0 = get, 1 = set, 2 = add
	static function _scoreFunc(name:String, mode:Int = 0, addOrSet:Float = 1, saveIfNotUnlocked:Bool = true):Float
	{
		if(!variables.exists(name))
			variables.set(name, 0);

		if(achievements.exists(name))
		{
			var achievement:Achievement = achievements.get(name);
			if(achievement.maxScore < 1) throw new Exception('Achievement has score disabled or is incorrectly configured: $name');

			if(achievementsUnlocked.contains(name)) return achievement.maxScore;

			var val = addOrSet;
			switch(mode)
			{
				case 0: return variables.get(name); //get
				case 2: val += variables.get(name); //add
			}

			if(val >= achievement.maxScore)
			{
				unlock(name);
				val = achievement.maxScore;
			}
			variables.set(name, val);

			Achievements.save();
			if(saveIfNotUnlocked || val >= achievement.maxScore) FlxG.save.flush();
			return val;
		}
		return -1;
	}

	static var _lastUnlock:Int = -999;
	public static function unlock(name:String, autoStartPopup:Bool = true):String {
		if(!achievements.exists(name))
		{
			FlxG.log.error('Achievement "$name" does not exists!');
			throw new Exception('Achievement "$name" does not exists!');
			return null;
		}

		if(Achievements.isUnlocked(name)) return null;

		trace('Completed achievement "$name"');
		achievementsUnlocked.push(name);

		// earrape prevention
		var time:Int = openfl.Lib.getTimer();
		if(Math.abs(time - _lastUnlock) >= 100) //If last unlocked happened in less than 100 ms (0.1s) ago, then don't play sound
		{
			if (name == 'all_of_em')
			{
				FlxG.sound.play(Paths.sound('FinalAchievementObtained'), 0.8);
			}
			else
			{
				FlxG.sound.play(Paths.sound('achievementObtainedSound'), 0.8);
			}
			_lastUnlock = time;
		}

		Achievements.save();
		FlxG.save.flush();

		if(autoStartPopup) startPopup(name);
		return name;
	}

	inline public static function isUnlocked(name:String)
		return achievementsUnlocked.contains(name);

	@:allow(objects.AchievementPopup)
	private static var _popups:Array<AchievementPopup> = [];

	public static var showingPopups(get, never):Bool;
	public static function get_showingPopups()
		return _popups.length > 0;

	public static function startPopup(achieve:String, endFunc:Void->Void = null) {
		for (popup in _popups)
		{
			if(popup == null) continue;
			popup.intendedY += 150;
		}

		var newPop:AchievementPopup = new AchievementPopup(achieve, endFunc);
		_popups.push(newPop);
		//trace('Giving achievement ' + achieve);
	}

	// Map sorting cuz haxe is physically incapable of doing that by itself
	static var _sortID = 0;
	static var _originalLength = -1;
	public static function createAchievement(name:String, data:Achievement, ?mod:String = null)
	{
		data.ID = _sortID;
		data.mod = mod;
		achievements.set(name, data);
		_sortID++;
	}

	#if MODS_ALLOWED
	public static function reloadList()
	{
		// remove modded achievements
		if((_sortID + 1) > _originalLength)
			for (key => value in achievements)
				if(value.mod != null)
					achievements.remove(key);

		_sortID = _originalLength-1;

		var modLoaded:String = Mods.currentModDirectory;
		Mods.currentModDirectory = null;
		loadAchievementJson(Paths.mods('data/achievements.json'));
		for (i => mod in Mods.parseList().enabled)
		{
			Mods.currentModDirectory = mod;
			loadAchievementJson(Paths.mods('$mod/data/achievements.json'));
		}
		Mods.currentModDirectory = modLoaded;
	}

	inline static function loadAchievementJson(path:String, addMods:Bool = true)
	{
		var retVal:Array<Dynamic> = null;
		if(FileSystem.exists(path)) {
			try {
				var rawJson:String = File.getContent(path).trim();
				if(rawJson != null && rawJson.length > 0) retVal = tjson.TJSON.parse(rawJson); //Json.parse('{"achievements": $rawJson}').achievements;
				
				if(addMods && retVal != null)
				{
					for (i in 0...retVal.length)
					{
						var achieve:Dynamic = retVal[i];
						if(achieve == null)
						{
							var errorTitle = 'Mod name: ' + Mods.currentModDirectory != null ? Mods.currentModDirectory : "None";
							var errorMsg = 'Achievement #${i+1} is invalid.';
							#if windows
							lime.app.Application.current.window.alert(errorMsg, errorTitle);
							#end
							trace('$errorTitle - $errorMsg');
							continue;
						}

						var key:String = achieve.save;
						if(key == null || key.trim().length < 1)
						{
							var errorTitle = 'Error on Achievement: ' + (achieve.name != null ? achieve.name : achieve.save);
							var errorMsg = 'Missing valid "save" value.';
							#if windows
							lime.app.Application.current.window.alert(errorMsg, errorTitle);
							#end
							trace('$errorTitle - $errorMsg');
							continue;
						}
						key = key.trim();
						if(achievements.exists(key)) continue;

						createAchievement(key, achieve, Mods.currentModDirectory);
					}
				}
			} catch(e:Dynamic) {
				var errorTitle = 'Mod name: ' + Mods.currentModDirectory != null ? Mods.currentModDirectory : "None";
				var errorMsg = 'Error loading achievements.json: $e';
				#if windows
				lime.app.Application.current.window.alert(errorMsg, errorTitle);
				#end
				trace('$errorTitle - $errorMsg');
			}
		}
		return retVal;
	}
	#end

	#if LUA_ALLOWED
	public static function addLuaCallbacks(lua:State)
	{
		Lua_helper.add_callback(lua, "getAchievementScore", function(name:String):Float
		{
			if(!achievements.exists(name))
			{
				FunkinLua.luaTrace('getAchievementScore: Couldnt find achievement: $name', false, false, FlxColor.RED);
				return -1;
			}
			return getScore(name);
		});
		Lua_helper.add_callback(lua, "setAchievementScore", function(name:String, ?value:Float = 1, ?saveIfNotUnlocked:Bool = true):Float
		{
			if(!achievements.exists(name))
			{
				FunkinLua.luaTrace('setAchievementScore: Couldnt find achievement: $name', false, false, FlxColor.RED);
				return -1;
			}
			return setScore(name, value, saveIfNotUnlocked);
		});
		Lua_helper.add_callback(lua, "addAchievementScore", function(name:String, ?value:Float = 1, ?saveIfNotUnlocked:Bool = true):Float
		{
			if(!achievements.exists(name))
			{
				FunkinLua.luaTrace('addAchievementScore: Couldnt find achievement: $name', false, false, FlxColor.RED);
				return -1;
			}
			return addScore(name, value, saveIfNotUnlocked);
		});
		Lua_helper.add_callback(lua, "unlockAchievement", function(name:String):Dynamic
		{
			if(!achievements.exists(name))
			{
				FunkinLua.luaTrace('unlockAchievement: Couldnt find achievement: $name', false, false, FlxColor.RED);
				return null;
			}
			return unlock(name);
		});
		Lua_helper.add_callback(lua, "isAchievementUnlocked", function(name:String):Dynamic
		{
			if(!achievements.exists(name))
			{
				FunkinLua.luaTrace('isAchievementUnlocked: Couldnt find achievement: $name', false, false, FlxColor.RED);
				return null;
			}
			return isUnlocked(name);
		});
		Lua_helper.add_callback(lua, "achievementExists", function(name:String) return achievements.exists(name));
	}
	#end
}
#end