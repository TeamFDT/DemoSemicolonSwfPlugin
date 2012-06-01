package {
	import fdt.ast.IFdtAstNode;

	import swf.bridge.FdtEditorContext;
	import swf.bridge.IFdtActionBridge;
	import swf.plugin.ISwfActionPlugin;

	import flash.display.Sprite;
	import flash.utils.Dictionary;

	[FdtSwfPlugin(name="DemoSemicolonSwfPlugin", pluginType="action", toolTip="Fix semicolons")]
	public class DemoSemicolonSwfPlugin extends Sprite implements ISwfActionPlugin {
		private var _bridge : IFdtActionBridge;
		private var currentFile : String;

		public function init(bridge : IFdtActionBridge) : void {
			_bridge = bridge;
			
			// 'Semicolons' is how FDT identifies the selection of your Menu
			_bridge.ui.registerMenuEntry("Semicolons", "Fix semicolons", "Hui Puh","", "mainMenu/file/new:before").sendTo(null,null);
		}

		public function createProposals(ec : FdtEditorContext) : void {
		}

		public function callEntryAction(entryId : String) : void {
			
//			Once we know that a menu entry has been selected, we check which one (suppose you have manyy) 
			if ("Semicolons" == entryId){
				// ok now execute behaviour
				fixSemicolons();
			}
		}

		public function setOptions(options : Dictionary) : void {
		}

		public function dialogClosed(dialogInstanceId : String, result : String) : void {
		}

		private function fixSemicolons() : void {
			// Grabbing the editor context
			_bridge.editor.getCurrentContext().sendTo(this, useContext);
		}

		private function useContext(context : FdtEditorContext) : void {
			// once we have it, we get the AST (Abstract Syntax Tree) for the file that was selected
			currentFile = context.currentFile;
			_bridge.model.fileAst(currentFile).sendTo(this, useAst);
		}

		private function useAst(root : IFdtAstNode) : void {
			var fsv : FixSemicolonVisitor = new FixSemicolonVisitor();
			trace("Try to find missing semicolons in "+currentFile, root);
			// Now we have the AST for the file. We then scan it and add changes
			fsv.visit(root);
			// once the edits have been collected we pass the changes to the current file.
			_bridge.model.fileDocumentModify(currentFile, fsv.edits).sendTo(null, null);
		}
	}
}
