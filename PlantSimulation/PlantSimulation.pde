/*
Main program, ideally we keep this as clean as possible
no need to import other files here, in compiling they all get thrown together automatically
*/

World my_world;
PlantPopulation my_plant_simulator;
FlyCamera my_camera;
WorldTime world_timer = new WorldTime(1000);
float world_update_timer = 0;
float update_tick = 1;
float global_base_growth = .08;
float global_energy_loss = global_base_growth * .001;
float resource_loss_multiplier = .001;
float resource_gain_multiplier = 1;
float base_resource_gain = .1;
int ui_font_size = 25;

void setup() {
  // ui setup
  PFont UIFont = createFont("Consolas", ui_font_size);
  textFont(UIFont);
  size (600, 480, P3D);
  my_world = new World(new PVector(200, 10, 200));
  my_plant_simulator = new PlantPopulation(my_world);
  my_plant_simulator.initPopulation(10, 5);
  my_camera = new FlyCamera();
  my_camera.z = 170;
  my_camera.y = -55;
  my_camera.pitch = .36;
  my_camera.yaw = 4.7;
}

void draw() {
  world_timer.stepTime();
  background(0);
  perspective();
  lights();
  //translate(width/2, height/2 + 100, -200);
  my_camera.update();
  my_world.draw();
  if ((world_update_timer + update_tick) < world_timer.time) {
    world_update_timer = world_timer.time;
    my_plant_simulator.stepPopulation();
    my_world.updateWorld();
  }
  my_plant_simulator.draw();
  drawUI();
}
