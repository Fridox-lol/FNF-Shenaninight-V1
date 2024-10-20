package states;

import flixel.FlxSubState;

import flixel.effects.FlxFlicker;
import lime.app.Application;
import flixel.addons.transition.FlxTransitionableState;

class FlashingState extends MusicBeatState
{
	public static var leftState:Bool = false;

	var warnText:FlxText;
	override function create()
	{
		super.create();

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

		warnText = new FlxText(0, 0, FlxG.width,
			"WARNING: The mod you're about to play contains:\n
			Flashing Lights
			Mild Visual Imagery (Blood 'n flesh lol)
			Mild Language
			Deez Nuts
			Memes\n
			If you suffer from epilepsy, don't like visual imagery, or anything else, PLAYING THIS MOD IS NOT RECOMMENDED.
			
			Press ENTER to disable MOST of the flashing lights or press Esc to ignore.
			
			FNF is not a kids game, go outside.",
			32);
		warnText.setFormat(Paths.font("phantom.ttf"), 32, FlxColor.WHITE, CENTER);
		warnText.screenCenter(Y);
		warnText.x = 25;
		add(warnText);
	}

	override function update(elapsed:Float)
	{
		if(!leftState) {
			var back:Bool = controls.BACK;
			if (controls.ACCEPT || back) {
				leftState = true;
				FlxTransitionableState.skipNextTransIn = true;
				FlxTransitionableState.skipNextTransOut = true;
				if(!back) {
					ClientPrefs.data.flashing = false;
					ClientPrefs.saveSettings();
					FlxG.sound.play(Paths.sound('loriannouncer'));
					FlxFlicker.flicker(warnText, 1, 0.1, false, true, function(flk:FlxFlicker) {
						new FlxTimer().start(0.5, function (tmr:FlxTimer) {
							MusicBeatState.switchState(new TitleState());
						});
					});
				} else {
					FlxG.sound.play(Paths.sound('loriannouncer'));
					FlxTween.tween(warnText, {alpha: 0}, 1, {
						onComplete: function (twn:FlxTween) {
							MusicBeatState.switchState(new TitleState());
						}
					});
				}
			}
		}
		super.update(elapsed);
	}
}
