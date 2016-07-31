class Bob {
    PVector location;
    float theta, omega, alpha;
    float mass;

    Bob(float mass) {
        location = new PVector();
        theta = PI/4;
        omega = 0.0;
        alpha = 0.0;
        this.mass = mass;
    }

    void update(float calculatedAlpha, PVector origin, float r) {
        alpha = calculatedAlpha;
        omega += alpha;
        theta += omega;

        // Origin is point we are moving from
        // For first bob, origin is the 'true' origin
        // For second bob, origin is the first bob
        location.set(origin.copy());
        location.add(r * sin(theta), r * cos(theta), 0);
    }

    void display() {
        ellipse(location.x, location.y, 2, 2);
    }
}