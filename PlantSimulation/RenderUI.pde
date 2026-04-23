// be warned font size currently does nothing 

ArrayList<Button> buttons = new ArrayList<Button>();
ArrayList<Slider> sliders = new ArrayList<Slider>();

void createUI() {
  BoolButton sun_button = new BoolButton(100, 100, 150, 50, "Toggle Sun", 10);
  buttons.add(sun_button);
  
  Slider time_mult_slider = new Slider(1, 1000, 20, 200, 200, 40, "Time Scale:");
  sliders.add(time_mult_slider);
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
        // Use standard text at the mouse position
        text("Plant Energy: " + int(hovered.getEnergy()), mouseX + 15, mouseY);
        text("Maturity: " + (hovered.getMaturityLevel()), mouseX + 15, mouseY - 20);
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
