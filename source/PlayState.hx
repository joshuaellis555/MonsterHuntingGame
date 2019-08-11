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
import player.God;
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
		FlxG.fixedTimestep = false;
		super.create();
		
		this.persistentUpdate = true;
		
		// ################### Cameras #######################
		/*
		Cameras.bgCam = new FlxCamera(0, 0, FlxG.width, FlxG.height);
		Cameras.bgCam.antialiasing = true;
		
		Cameras.planetUiCam = new FlxCamera(0, 0, FlxG.width, FlxG.height);
		Cameras.planetUiCam.bgColor = FlxColor.TRANSPARENT;
		Cameras.planetUiCam.antialiasing = true;
		
		Cameras.mapCam = new FlxCamera(0, 0, FlxG.width, FlxG.height);
		Cameras.mapCam.bgColor = FlxColor.TRANSPARENT;
		Cameras.mapCam.antialiasing = true;
		
		Cameras.cursorCam = new FlxCamera(0, 0, FlxG.width, FlxG.height);
		Cameras.cursorCam.bgColor = FlxColor.TRANSPARENT;
		Cameras.cursorCam.antialiasing = true;
		
		Cameras.planetCam = new FlxCamera(0,0,FlxG.width,FlxG.height);
		Cameras.planetCam.bgColor = FlxColor.TRANSPARENT;
		Cameras.planetCam.antialiasing = true;
		
		Cameras.menuCam = new FlxCamera(0, 0, FlxG.width, FlxG.height);
		Cameras.menuCam.bgColor = FlxColor.TRANSPARENT;
		Cameras.menuCam.setScrollBounds(0, FlxG.width, 0, FlxG.height);
		Cameras.menuCam.antialiasing = true;
		
		Cameras.uiCam = new FlxCamera(0, 0, FlxG.width, FlxG.height);
		Cameras.uiCam.bgColor = FlxColor.TRANSPARENT;
		Cameras.uiCam.setScrollBounds(0, FlxG.width, 0, FlxG.height);
		Cameras.uiCam.antialiasing = true;
		*/
		
		FlxG.camera.antialiasing = true;
		
		Library.cameras.backgroundCam.activate();
		Library.cameras.subCam.activate();
		Library.cameras.mainCam.activate();
		Library.cameras.cursorCam.activate();
		
		
		///*
		var background = new FlxSprite();
		background.loadGraphic(AssetPaths.BattleBackgroundUpscaled__png);
		background.camera = Library.cameras.backgroundCam.flxCam();
		background.color = 0xffffffff;
		add(background);
		//*/
		
		/*
		var background = new FlxSprite();
		background.makeGraphic(1920, 1080, FlxColor.WHITE);
		background.camera = Cameras.subCam.flxCam();
		add(background);
		//*/
		
		var t1:Team = new Team();
		var t2:Team = new Team();
		var t3:Team = new Team();
		
		var p1:Player = new Player(this,FlxColor.RED, new Controller(this));
		
		///*
		var p4:Player = new Player(this,FlxColor.BLUE, new Controller(this));
		p4.setMenu(new BattleMenu(p4,4));
		var char4:Wizard = new Wizard(Std.int(p4.menu.menuImage.x+240-48), 400, p4);
		char4.setTeam(t1);
		
		var p3:Player = new Player(this,FlxColor.YELLOW, new Controller(this));
		p3.setMenu(new BattleMenu(p3,3));
		var char3:Paladin = new Paladin(Std.int(p3.menu.menuImage.x+240-48), 400, p3);
		char3.setTeam(t1);
		//*/
		
		p1.setMenu(new BattleMenu(p1,2));
		var char1:Fighter = new Fighter(Std.int(p1.menu.menuImage.x + 240 - 48), 400, p1);
		char1.setTeam(t1);
		
		///*
		var p2:Player = new Player(this,FlxColor.GREEN, new Controller(this));
		p2.setMenu(new BattleMenu(p2,1));
		var char2:Ranger = new Ranger(Std.int(p2.menu.menuImage.x+240-48), 400, p2);
		char2.setTeam(t1);
		//*/
		
		///*
		
		
		
		//*/
		
		/*
		var dot:FlxSprite = new FlxSprite(1920 / 2-1, 1080 / 2-1);
		dot.makeGraphic(4, 4, FlxColor.BLACK);
		dot.cameras = [Cameras.mainCam.flxCam()];
		add(dot);
		//*/
		
		//var rg:RhinoGroup = new RhinoGroup();
		
		rg = new RhinoGroup(this);
		rg.setTeam(t3);
		
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		///*
		if (rg.dead() && summonedNext == false){
			var dp:DarkPair = new DarkPair(this);
			dp.setTeam(new Team());
			summonedNext = true;
		}
		//*/
	}
}