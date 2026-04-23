/*
Main program, ideally we keep this as clean as possible
no need to import other files here, in compiling they all get thrown together automatically
*/

World my_world;
PlantPopulation my_plant_simulator;
FlyCamera my_camera;
WorldTime world_timer = new WorldTime(200);

int max_plants = 800;

float world_update_timer = 0;
float update_tick = 1;

float global_base_growth = .08;
float global_energy_loss = global_base_growth * .001;

float resource_loss_multiplier = .01;
float resource_gain_multiplier = .01;
float base_resource_gain = .1;

int ui_font_size = 25;
boolean simulate_sun = false;


void setup() {
  // ui setup
  PFont UIFont = createFont("Consolas", ui_font_size);
  textFont(UIFont);
  createUI();
  // world setup
  size (600, 480, P3D);
  my_world = new World(new PVector(200, 10, 200));
  my_plant_simulator = new PlantPopulation(my_world);
  my_plant_simulator.initPopulation(10, 5);
  // camera
  my_camera = new FlyCamera();
  my_camera.z = 170;
  my_camera.y = -55;
  my_camera.pitch = .36;
  my_camera.yaw = 4.7;
}

void draw() {
  world_timer.stepTime();
  if (buttons.get(0).getValue()) {
    background(getSunColor(sin(map(world_timer.time % 86400, 0, 86400, 0, TWO_PI))));
  }
  else {
    background(0);
  }
  perspective();
  if (buttons.get(0).getValue()) {
    ambient(100, 100, 50);
    updateSun(world_timer.time);
  }
  else {
    lights();
  }
  specular(0);
  //translate(width/2, height/2 + 100, -200);
  my_camera.update();
  world_update_timer += (1.0 / frameRate) * world_timer.time_multiplier;
  while (world_update_timer >= update_tick) {
    my_plant_simulator.stepPopulation();
    my_world.updateWorld();
    world_update_timer -= update_tick;
  }
  my_world.draw();
  my_plant_simulator.draw();
  
  for (Plant p : my_plant_simulator.plants) {
    p.updateScreenPos();
  }
  updateUI();
  drawUI();
}

void mouseClicked() {
  for (Button button: buttons) {
    button.update();
  }
}

void mousePressed() {
  for (Slider slider: sliders) {
    slider.sliding_box.clicked();
  }
}

void mouseReleased() {
  if (sliders.get(0).sliding_box.focused) {
    world_timer.time_multiplier = sliders.get(0).getValue();
  }
  for (Slider slider: sliders) {
    slider.sliding_box.unclicked();
  }
}
