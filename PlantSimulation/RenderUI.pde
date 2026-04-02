// be warned font size currently does nothing 

void drawUI(){
    pushMatrix();
    resetMatrix();
    rectMode(CENTER);
    textAlign(CENTER, CENTER);
    ortho();
    translate(-width/2.0, -height/2.0);
    textAlign(LEFT);
    fill(255);
    plantStatsList(my_plant_simulator.plants.size());
    timeStatsList(world_timer.time, world_timer.year, world_timer.season);
    popMatrix();
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
