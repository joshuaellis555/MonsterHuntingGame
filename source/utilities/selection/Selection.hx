package utilities.selection;

import utilities.observer.Observer;
import utilities.observer.Subject;
import utilities.button.Button;

/**
 * ...
 * @author ...
 */
class Selection 
{
	public var buttons:Array<Array<Button>>;
	private var index:Int = 0;
	private var currentSliceIndex:Int = 0;
	private var selectionSubject:Subject;
	private var superSelection:Null<Selection> = null;
	private var subSelection:Null<Selection> = null;
	
	//public var max:Null<Int>=null
	
	private var up:Null<Void->Void>=null;
	private var down:Null<Void->Void>=null;
	private var left:Null<Void->Void>=null;
	private var right:Null<Void->Void>=null;
	private var ok:Null<Void->Void>=null;
	private var esc:Null<Void->Void> = null;
	private var Y:Null<Void->Void>=null;
	private var upLeft:Null<Void->Void> = null;
	private var upRight:Null<Void->Void> = null;
	private var downLeft:Null<Void->Void> = null;
	private var downRight:Null<Void->Void> = null;
	
	public function new(buttons:Array<Array<Button>>, ?up:Null<Void->Void> = null, ?down:Null<Void->Void> = null, ?left:Null<Void->Void> = null, ?right:Null<Void->Void> = null, ?ok:Null<Void->Void> = null, ?esc:Null<Void->Void> = null, ?Y:Null<Void->Void> = null, ?upLeft:Null<Void->Void> = null, ?upRight:Null<Void->Void> = null, ?downLeft:Null<Void->Void> = null, ?downRight:Null<Void->Void> = null)
	{
		buttons = [for (b in buttons) if (b.length > 0) b];
		
		this.buttons = buttons;
		this.up = up;
		this.down = down;
		this.left = left;
		this.right = right;
		this.ok = ok;
		this.esc = esc;
		this.Y = Y;
		this.upLeft = upLeft;
		this.upRight = upRight;
		this.downLeft = downLeft;
		this.downRight = downRight;
	}
	public function interact(action:SelectionActions)
	{
		if (subSelection == null){
			switch(action){
				case SelectionActions.Up:{
					if (up != null) up();
				}
				case SelectionActions.Down:{
					if (down != null) down();
				}
				case SelectionActions.Left:{
					if (left != null) left();
				}
				case SelectionActions.Right:{
					if (right != null) right();
				}
				case SelectionActions.Ok:{
					if (ok != null) ok();
				}
				case SelectionActions.Esc:{
					if (esc != null) esc();
				}
				case SelectionActions.Y:{
					trace(Y);
					if (Y != null) Y();
				}
				case SelectionActions.UpLeft:{
					if (upLeft != null) upLeft();
				}
				case SelectionActions.UpRight:{
					if (upRight != null) upRight();
				}
				case SelectionActions.DownLeft:{
					if (downLeft != null) downLeft();
				}
				case SelectionActions.DownRight:{
					if (downRight != null) downRight();
				}
				default:null;
			}
		}
		else{
			subSelection.interact(action);
		}
	}
	public function addSubSelection(selection:Selection)
	{
		if (subSelection == null){
			subSelection = selection;
			selection.superSelection = this;
		}
		else{
			subSelection.addSubSelection(selection);
		}
	}
	public function popSubSelection(?evenSelf:Bool=false)
	{
		if (subSelection == null){
			if (superSelection != null || evenSelf){
			//trace("pop subselection",subSelection == null,superSelection != null,evenSelf,subSelection == null && (superSelection != null || evenSelf),(superSelection != null || evenSelf));
				superSelection.subSelection = null;
				superSelection = null;
				
				this.buttons = [];
				this.up = null;
				this.down = null;
				this.left = null;
				this.right = null;
				this.ok = null;
				this.esc = null;
				this.Y = null;
				this.upLeft = null;
				this.upRight = null;
				this.downLeft = null;
				this.downRight = null;
			}
		}
		else{
			subSelection.popSubSelection(evenSelf);
		}
	}
	public function getButtons():Array<Button>
	{
		if (subSelection == null){
			return [for (arr in buttons) for (btn in arr) btn];
		}
		else{
			return subSelection.getButtons();
		}
	}
	public function getIndex():Int
	{
		if (subSelection == null){
			var i:Int = 0;
			for (c in 0...currentSliceIndex)
				i += buttons[c].length;
			return index + i;
		}
		else{
			return subSelection.getIndex();
		}
	}
	public function setIndex(i:Int)
	{
		if (subSelection == null){
			var c:Int = 0;
			for (arr in buttons){
				if (i >= arr.length){
					c += 1;
					i -= arr.length;
				}
				else break;
			}
			index = i;
			currentSliceIndex = c;
		}
		else{
			subSelection.setIndex(i);
		}
	}
	public function removeCurrent():Bool
	{
		if (subSelection == null){
			buttons[currentSliceIndex].remove(buttons[currentSliceIndex][index]);
			if (buttons[currentSliceIndex].length == 0){
				buttons.remove(buttons[currentSliceIndex]);
				if (buttons.length == 0)
					return false;
				else
					currentSliceIndex = (currentSliceIndex % buttons.length);
			}
			else
				index = (index % buttons[currentSliceIndex].length);
			return true;
		}
		else{
			return subSelection.removeCurrent();
		}
	}
	public function next()
	{
		if (subSelection == null){
			index++;
			index=(index % buttons[currentSliceIndex].length);
		}
		else{
			subSelection.next();
		}
	}
	public function previous()
	{
		if (subSelection == null){
			index--;
			index = ((index % buttons[currentSliceIndex].length + buttons[currentSliceIndex].length) % buttons[currentSliceIndex].length);
		}
		else{
			subSelection.previous();
		}	
	}
	public function nextSlice()
	{
		if (subSelection == null){
			currentSliceIndex++;
			currentSliceIndex = (currentSliceIndex % buttons.length);
			//trace('currentSliceIndex', currentSliceIndex);
			index=(index % buttons[currentSliceIndex].length);
		}
		else{
			subSelection.nextSlice();
		}
	}
	public function previousSlice()
	{
		if (subSelection == null){
			currentSliceIndex--;
			currentSliceIndex = ((currentSliceIndex % buttons.length + buttons.length) % buttons.length);
			//trace('currentSliceIndex', currentSliceIndex);
			index=(index % buttons[currentSliceIndex].length);
		}
		else{
			subSelection.previousSlice();
		}	
	}
	public function getTarget():Button
	{
		if (subSelection == null){
			return buttons[currentSliceIndex][index];
		}
		else{
			return subSelection.getTarget();
		}
	}
	
}