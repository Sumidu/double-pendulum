/*
* TODO:
*   - Add starting angle higher to build velocity
*   - Add sliders to adjust variables
*   - Add option to set fading trails
*   - Toggle views (show rods/bob1/bob2)
*/

class DoublePendulum {
    PVector location1;
    PVector location2;
    PVector origin;

    float r; // rod length ****MODIFY LATER FOR ADJUSTABLE ROD LENGTHS***
    float theta1, theta2; // angle of rods in respect to origin/first bob
    float omega1, omega2; // anglular velocity of respective bobs
    float alpha1, alpha2; // anglular acceleration of respective bobs
    float damping; // arbitrary damping value to simulate real life kinda
    float mass1, mass2; // mass of respective blobs;
    float g = 0.4; // arbitrary gravity constant

    DoublePendulum(PVector origin, float r) {
        this.origin = origin.copy();
        this.r = r;

        location1 = new PVector();
        location2 = new PVector();

        theta1 = PI/4;
        omega1 = 0.0;
        alpha1 = 0.0;
        damping = 1;

        // Update masses for different interactions
        mass1 = 10;
        mass2 = 1;
    }

    void go() {
        update();
        display();
    }

    void update() {
        // UPDATE alpha by calling calcAlpha
        alpha1 = calcAlpha1();
        alpha2 = calcAlpha2();
        // UPDATE omega by adding alpha to omega
        omega1 += alpha1;
        omega2 += alpha2;
        // UPDATE theta by adding omega to theta
        theta1 += omega1;
        theta2 += omega2;
    }

    void display() {
        location1.set(r * sin(theta1), r * cos(theta1), 0); // get where ball should be based on angle (to cartesian converstion);
        location1.add(origin); // add origin offset

        location2.set(location1); // set location 2 to location 1 bob
        location2.add(r * sin(theta2), r * cos(theta2), 0); // off set with calculated angle from bob 1

        stroke(175);
        fill(175);
        line(origin.x, origin.y, location1.x, location1.y);
        line(location1.x, location1.y, location2.x, location2.y);
        // ellipse(location1.x, location1.y, 16,16);
        // ellipse(location2.x, location2.y, 16,16);
        ellipse(location1.x, location1.y, 2, 2);
        ellipse(location2.x, location2.y, 2, 2);
    }

    // calculates angular acceleration for bob 1
    float calcAlpha1() {
        float top = -1*g*(2*mass1*mass2)*sin(theta1) - mass2*g*sin(theta1-(2*theta2)) - 
            2*(sin(theta1-theta2)*mass2*(omega2*omega2*r+omega1*omega1*r*cos(theta1-theta2)));

        float bot = r*(2*mass1+mass2-mass2*cos(2*theta1-2*theta2));

        return top / bot;
    }

    // calculates angular acceleration for bob 2
    float calcAlpha2() {
        float top = 2*sin(theta1-theta2)*(omega1*omega1*r*(mass1+mass2)+g*(mass1+mass2)*cos(theta1)+omega2*omega2*r*mass2*cos(theta1-theta2));

        float bot = r*(2*mass1+mass2-mass2*cos(2*theta1-2*theta2));

        return top / bot;
    }
}

DoublePendulum p;

void setup() {
    size(640,360);
    //background(0); // show trails
    frameRate(30);
    blendMode(ADD);
    p = new DoublePendulum(new PVector(width/2, 10), 100);
}

void draw() {
    background(0); // don't show trails
    p.go();
}