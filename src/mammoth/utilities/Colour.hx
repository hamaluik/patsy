package mammoth.utilities;

class Colour {
    public var r:Float = 0;
    public var g:Float = 0;
    public var b:Float = 0;

    public function new(?r:Float, ?g:Float, ?b:Float) {
        if(r != null) this.r = r;
        if(g != null) this.g = g;
        if(b != null) this.b = b;
    }

    public static var Black:Colour = new Colour(0, 0, 0);
    public static var White:Colour = new Colour(1, 1, 1);
}