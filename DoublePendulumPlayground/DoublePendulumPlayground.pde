/*
 * Adapted from Daniel Shiffman's Pendulum exercise.
 * Found in Chapter 3 of The Nature Of Code.
 *
 * Double Pendulum calculations from: http://www.myphysicslab.com/dbl_pendulum.html
*/

/*
* TODO:
*   - Add sliders to adjust variables
*   - Add option to set fading trails -> keep track of past points in an array, loop through and draw all every frame
*
* DONE:
*   - Breakout all variables into bob class objects
*   - Toggle views (show rods/bob1/bob2)
*/

enum DISPLAY_TRAIL {
    TRAIL, NO_TRAIL;
}

enum DISPLAY_MODE {
    LINE, POINT;
}

class DoublePendulum {
    Bob b1, b2;
    PVector origin;

    float r; // rod length ****MODIFY LATER FOR ADJUSTABLE ROD LENGTHS***
    float g = 0.4; // arbitrary gravity constant
    float damping = 1; // Change this to add 'friction'

    DoublePendulum(PVector origin, float r) {
        this.origin = origin.copy();
        this.r = r;

        b1 = new Bob(10);
        b2 = new Bob(2);
    }

    void go() {
        update();
        display();
    }

    void update() {
        b1.update(calcAlpha1(), origin, r);
        b2.update(calcAlpha2(), b1.location, r);
    }

    void display() {
        stroke(175);
        fill(175);

        if(dm == DISPLAY_MODE.LINE) {
            line(origin.x, origin.y, b1.location.x, b1.location.y);
            line(b1.location.x, b1.location.y, b2.location.x, b2.location.y);
        }
        
        b1.display();
        b2.display();
    }

    // calculates angular acceleration for bob 1
    float calcAlpha1() {
        float top = -1*g*(2*b1.mass*b2.mass)*sin(b1.theta) - b2.mass*g*sin(b1.theta-(2*b2.theta)) - 
            2*(sin(b1.theta-b2.theta)*b2.mass*(b2.omega*b2.omega*r+b1.omega*b1.omega*r*cos(b1.theta-b2.theta)));

        float bot = r*(2*b1.mass+b2.mass-b2.mass*cos(2*b1.theta-2*b2.theta));

        return top / bot;
    }

    // calculates angular acceleration for bob 2
    float calcAlpha2() {
        float top = 2*sin(b1.theta-b2.theta)*(b1.omega*b1.omega*r*(b1.mass+b2.mass)+g*(b1.mass+b2.mass)*cos(b1.theta)+b2.omega*b2.omega*r*b2.mass*cos(b1.theta-b2.theta));

        float bot = r*(2*b1.mass+b2.mass-b2.mass*cos(2*b1.theta-2*b2.theta));

        return top / bot;
    }
}

DoublePendulum p;
DISPLAY_TRAIL dt;
DISPLAY_MODE dm;

void setup() {
    dt = DISPLAY_TRAIL.TRAIL;
    dm = DISPLAY_MODE.POINT;
    size(640,640);
    if(dt == DISPLAY_TRAIL.TRAIL)
        background(0); // show trails
    frameRate(30);
    blendMode(ADD);
    p = new DoublePendulum(new PVector(width/2, 75), 100);
}

void draw() {
    if(dt == DISPLAY_TRAIL.NO_TRAIL)
        background(0); // don't show trails
    p.go();
}