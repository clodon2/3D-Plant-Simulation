/*
Main program, ideally we keep this as clean as possible
no need to import other files here, in compiling they all get thrown together automatically
*/


void setup() {
  size (200, 200, P3D);
  PlantPopulation test_pop = new PlantPopulation();
  test_pop.initPopulation(100, 5);
  test_pop.printPopulation();
}

void draw() {
  background(0);
  sphere(50);
}
