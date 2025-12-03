/*
Main program, ideally we keep this as clean as possible
no need to import other files here, in compiling they all get thrown together automatically
*/

World my_world;
PlantPopulation my_plant_simulator;
FlyCamera my_camera;
void setup() {
  size (600, 480, P3D);
  my_world = new World(new PVector(100, 10, 100));
  my_plant_simulator = new PlantPopulation(my_world);
  my_plant_simulator.initPopulation(3, 5);
  my_camera = new FlyCamera();
  my_camera.z = 170;
  my_camera.y = -55;
  my_camera.pitch = .36;
  my_camera.yaw = 4.7;
}

void draw() {
  background(0);
  lights();
  //translate(width/2, height/2 + 100, -200);
  my_camera.update();
  my_world.draw();
  my_plant_simulator.updatePopulation();
  my_plant_simulator.draw();
  text(my_camera.x, 50, 50);
  text(my_camera.y, 50, 40);
  text(my_camera.z, 50, 30);
  text(my_camera.yaw, 50, 20);
  text(my_camera.pitch, 50, 10);
}
