/*
Main program, ideally we keep this as clean as possible
no need to import other files here, in compiling they all get thrown together automatically
*/

World my_world;
void setup() {
  size (200, 200, P3D);
  my_world = new World(new PVector(100, 5, 100));
}

void draw() {
  background(0);
  lights();
  translate(width/2, height/2 + 100, -200);
  rotateX(PI/3);
  rotateY(frameCount * 0.01);
  // debug box
  pushMatrix();
  translate(0, 0, 0);
  stroke(255, 0, 0);
  noFill();
  box(200);
  popMatrix();
  shape(my_world.getGround());
}
