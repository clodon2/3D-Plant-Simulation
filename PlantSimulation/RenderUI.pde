// be warned font size currently does nothing 

ArrayList<Button> buttons = new ArrayList<Button>();
ArrayList<Slider> sliders = new ArrayList<Slider>();

void createUI() {  
  ClassFunctionButton reset_button = new ClassFunctionButton(100, 80, 150, 50, "Reset Sim", 20, new SimController());
  buttons.add(reset_button);
  
  ClassFunctionButton spin_button = new ClassFunctionButton(100, 140, 150, 50, "Toggle Spin", 20, new OrbitController());
  buttons.add(spin_button);
  
  BoolButton sun_button = new BoolButton(100, 200, 150, 50, "Toggle Sun", 20);
  buttons.add(sun_button);
  
  BoolButton auto_button = new BoolButton(100, 280, 150, 50, "Auto Restart", 20);
  buttons.add(auto_button);
  
  Slider time_mult_slider = new Slider(1, 1000, 20, 360, 200, 40, "Time Scale:");
  sliders.add(time_mult_slider);
  textSize(20);
}

void drawUI(){
    hint(DISABLE_DEPTH_TEST);
    noLights();
    pushMatrix();
    resetMatrix();
    rectMode(CENTER);
    textAlign(CENTER, CENTER);
    ortho();
    translate(-width/2.0, -height/2.0);
    textAlign(LEFT);
    fill(255);
    Plant hovered = my_plant_simulator.getHoveredPlant();
    if (hovered != null) {
    
      fill(255);
    
      String line1 = "Plant Energy: " + int(hovered.getEnergy());
      String line2 = "Maturity: " + hovered.getMaturityLevel();
      String line3 = "Critical Resource: " + round(hovered.resource_situation);
    
      float boxWidth = 180;  // estimate tooltip width
      float boxHeight = 60;  // estimate tooltip height
    
      int tx = mouseX + 15;
      int ty = mouseY;
    
      // keep inside right edge
      if (tx + boxWidth > width) {
        tx = mouseX - (int)boxWidth - 15;
      }
    
      // keep inside bottom edge
      if (ty + boxHeight > height) {
        ty = mouseY - (int)boxHeight;
      }
    
      fill(255);
      text(line1, tx, ty);
      text(line2, tx, ty - 20);
      text(line3, tx, ty + 20);
    }
    plantStatsList(my_plant_simulator.plants.size());
    timeStatsList(world_timer.time, world_timer.year, world_timer.season);
    
    for (Button button : buttons) {
      button.draw();
    }
    for (Slider slider : sliders) {
      slider.draw();
    }
    popMatrix();
    hint(ENABLE_DEPTH_TEST);
}

void updateUI() {
  for (Slider slider : sliders) {
    slider.update();
  }
}

void plantStatsList(int plant_number) {
  TextList statList = new TextList(float(120), float(20), float(10));
  String plant_num_str = str(plant_number) + " Plants";
  StandardText plant_num = new StandardText(plant_num_str, ui_font_size, 0, 0);
  statList.addText(plant_num);
  statList.draw();
}


void timeStatsList(float world_time, int world_year, int world_season) {
  String time_text = str(int(world_time/86400)) + " day";
  String year_text = str(world_year) + " year";
  String season_text = str(world_season) + " season";
  TextList statList = new TextList(float(120), float(height - 20), float(-20));
  StandardText time_t = new StandardText(time_text, ui_font_size, 0, 0);
  StandardText year_t = new StandardText(year_text, ui_font_size, 0, 0);
  StandardText season_t = new StandardText(season_text, ui_font_size, 0, 0);
  statList.addText(time_t);
  statList.addText(year_t);
  statList.addText(season_t);
  statList.draw();
}


class ButtonController {
  public void execute() {}
}


class SimController extends ButtonController {
  public void execute() {
    my_world = new World(new PVector(200, 10, 200));
    my_plant_simulator = new PlantPopulation(my_world);
    my_plant_simulator.initPopulation(10, 5);
  }
}


class OrbitController extends ButtonController {
  public void execute() {
    my_camera.orbitMode = !my_camera.orbitMode;
    if (!my_camera.orbitMode) {
      my_camera.z = 170;
      my_camera.y = -55;
      my_camera.pitch = .36;
      my_camera.yaw = 4.7;
    }
  }
}
