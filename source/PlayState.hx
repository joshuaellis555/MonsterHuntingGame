package;
import utilities.button.Button;
import card.CardType;
import character.Character;
import monsters.monsterGroup.monsterGroups.DarkPair;
import player.PlayerCharacter;
import utilities.controller.Controller;
import utilities.event.Event;
import utilities.event.MouseEvent;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.math.FlxPoint;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import library.Library;
import player.menu.BattleMenu;
import monsters.monsterGroup.monsterGroups.RhinoGroup;
import monsters.MonsterCharacter;
import monsters.monster.rhino.Rhino;
import utilities.observer.Observer;
import player.Player;
import character.resources.ResourceTypes;
import character.resources.Resources;
import player.playerCharacterClass.Paladin;
import player.playerCharacterClass.Ranger;
import player.playerCharacterClass.Wizard;
import utilities.selection.Selection;
import team.Team;
import utilities.plusInterface.PlusInterface;
import utilities.plusInterface.SpritePlus;
import utilities.plusInterface.SpritePlusTracker;
import player.playerCharacterClass.Fighter;
import utilities.plusInterface.PlusEnum;
import utilities.plusInterface.StatePlus;

class PlayState extends StatePlus
{
	
	var menu:BattleMenu;
	
	var rg:RhinoGroup;
	
	var summonedNext:Bool = false;
	
	override public function create():Void
	{
		//allow variable framerate
		FlxG.fixedTimestep = false;
		super.create();
		
		this.persistentUpdate = true;
		
		//FlxG.camera.antialiasing = true;
		
		//cameras must be activated after runtime
		Library.cameras.backgroundCam.activate();
		Library.cameras.subCam.activate();
		Library.cameras.mainCam.activate();
		Library.cameras.cursorCam.activate();
		
		var background = new FlxSprite();
		background.loadGraphic(AssetPaths.BattleBackgroundUpscaled__png);
		background.camera = Library.cameras.backgroundCam.flxCam();
		background.color = 0xffffffff;
		add(background);
		
		//create teams
		var t1:Team = new Team();
		var t2:Team = new Team();
		var t3:Team = new Team();
		
		//players recieve controlers in the order the players are created
		var p3:Player = new Player(this,FlxColor.YELLOW, new Controller(this));
		var p2:Player = new Player(this,FlxColor.GREEN, new Controller(this));
		var p1:Player = new Player(this, FlxColor.RED, new Controller(this));
		var p4:Player = new Player(this, FlxColor.BLUE, new Controller(this));
		
		///*
		p4.setMenu(new BattleMenu(p4,4));
		var char4:Wizard = new Wizard(Std.int(p4.menu.menuImage.x+240-48), 400, p4);
		char4.setTeam(t1);
		
		p3.setMenu(new BattleMenu(p3,3));
		var char3:Paladin = new Paladin(Std.int(p3.menu.menuImage.x+240-48), 400, p3);
		char3.setTeam(t1);
		//*/
		
		p1.setMenu(new BattleMenu(p1,2));
		var char1:Fighter = new Fighter(Std.int(p1.menu.menuImage.x + 240 - 48), 400, p1);
		char1.setTeam(t1);
		
		///*
		p2.setMenu(new BattleMenu(p2,1));
		var char2:Ranger = new Ranger(Std.int(p2.menu.menuImage.x+240-48), 400, p2);
		char2.setTeam(t1);
		//*/
		
		//the base set of enemies
		rg = new RhinoGroup(this);
		rg.setTeam(t3);
		
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		///*
		//creates another set of enemies when the first dies
		if (rg.dead() && summonedNext == false){
			var dp:DarkPair = new DarkPair(this);
			dp.setTeam(new Team());
			summonedNext = true;
		}
		//*/
	}
}