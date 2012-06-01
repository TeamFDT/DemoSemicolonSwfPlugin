package {
	import fdt.ast.FdtAstBreak;
	import fdt.FdtTextEdit;
	import fdt.ast.FdtAstStatement;
	import fdt.ast.IFdtAstNode;
	import fdt.ast.util.FdtAstVisitor;

	public class FixSemicolonVisitor extends FdtAstVisitor {
		private var _edits : Vector.<FdtTextEdit> = new Vector.<FdtTextEdit>();
		
		override protected function enterNode(depth : int, parent : IFdtAstNode, name : String, index : int, node : IFdtAstNode) : Boolean {
			// Depending on you look at, this could be a lot or not much. Depends how good you are with parsers and ASTs
			// High level is that we are checking all valid statements in the file and then seeing if at the end of the statement has 
			// a semicolon. If not we get the offset of the statment and then add the semicolon to the end.
			var s : FdtAstStatement = node as FdtAstStatement;
			if (s != null){
				// This is not documented yet. If no semicolon exists, s.semicolon = -1.   
				if (s.semicolon < 0 && s.exp != null){
					// Ok there is no semicolon and it's a valid statment. 
					var teOffset : int = s.exp.offset + s.exp.length;
					var te : FdtTextEdit = new FdtTextEdit(teOffset, 0, ";");
					trace("Semicolon to add for Statement: "+teOffset);
					_edits.push(te);
				}
			} else {
				var b : FdtAstBreak = node as FdtAstBreak;
				if (b != null && b.semicolon < 0){
					var teOffset : int = b.offset + b.length;					
					var te : FdtTextEdit = new FdtTextEdit(teOffset, 0, ";");
					trace("Semicolon to add for Break: "+teOffset);
					_edits.push(te);				
				}
			}
			return true;
		}

		public function get edits() : Vector.<FdtTextEdit> {
			return _edits;
		}

	}
}
