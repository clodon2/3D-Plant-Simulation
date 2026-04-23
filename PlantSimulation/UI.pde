public class StandardText {
  private String text;
  public int font_size = 10;
  public float pos_x = 0;
  public float pos_y = 0;
  private float t_width = 1;
  private float t_height = 1;
  
  StandardText(int display_int, float pos_x, float pos_y) {
    this.text = str(display_int);
    this.setSize(this.font_size);
    this.pos_x = pos_x;
    this.pos_y = pos_y;
  }
  
  StandardText(String display_str, float pos_x, float pos_y) {
    this.text = display_str;
    this.setSize(this.font_size);
    this.pos_x = pos_x;
    this.pos_y = pos_y;
  }
  
  StandardText(String display_str, int size, float pos_x, float pos_y) {
    this.text = display_str;
    this.setSize(size);
    this.pos_x = pos_x;
    this.pos_y = pos_y;
  }
  
  StandardText(int display_int, int size, float pos_x, float pos_y) {
    this.text = str(display_int);
    this.setSize(size);
    this.pos_x = pos_x;
    this.pos_y = pos_y;
  }
  
  StandardText(String display_str) {
    this.text = display_str;
  }
  
  StandardText(int display_int) {
    this.text = str(display_int);
  }
  
  void setSize(int font_size) {
    this.font_size = font_size;
    this.t_width =  this.text.length() * 7 * (this.font_size / 8);
    if (this.text.length() == 1){
      this.t_width += 2;
    }
    if (this.text.length() <= 0 ){
      return;
    }
    this.t_height = (this.font_size / 4) + this.font_size;
  }
  
  void draw() {
    text(this.text, this.pos_x, this.pos_y, this.t_width, this.t_height);
  }
  
  void draw(float pos_x, float pos_y) {
    text(this.text, pos_x, pos_y, this.t_width, this.t_height);
  }
}


// only lists vertically for now
public class TextList {
  private float start_x = 0;
  private float start_y = 0;
  private float spacing = 10;
  public ArrayList<StandardText> text_list = new ArrayList<StandardText>();
  
  TextList(float starting_x, float starting_y, float text_spacing) {
    this.start_x = starting_x;
    this.start_y = starting_y;
    this.spacing = text_spacing;
  }
  
  void addText(StandardText new_text) {
    this.text_list.add(new_text);
  }
  
  void draw() {
    for (int i=0; i<text_list.size(); i++) {
      text_list.get(i).draw(start_x, start_y + spacing*i);
    }
  }
}


public class Button {
  float x = 0;
  float y = 0;
  float w = 4;
  float h = 5;
  String text = "Button";
  int font_size = 12;
  String label = "Label:";
  int label_side = 0; // left = 0, right = 1, up = 2, down = 3
  boolean value = false;
  
  Button(float x, float y, float w, float h, String text) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.text = text;
  }
  
  Button(float x, float y, float w, float h, String text, int font_size) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.text = text;
    this.font_size = font_size;
  }
  
  Button(float x, float y, float w, float h, String text, String label, int label_side) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.text = text;
    this.label = label;
    this.label_side = label_side;
  }
  
  boolean getValue() {
    return this.value;
  }
  
  void update() {
    if ((this.x - this.w/2) < mouseX && mouseX < (this.x + this.w/2)) {
      if ((this.y - this.h/2) < mouseY && mouseY < (this.y + this.h/2)) {
        this.clicked();
      }
    }
  }
  
  void bind() {
  
  }
  
  void clicked() {
    
  }
  
  void draw() {
    if (this.text.length() == 1){
      this.w += 2;
    }
    if (this.text.length() <= 0 ){
      return;
    }
    pushMatrix();
    resetMatrix();
    rectMode(CENTER);
    textAlign(CENTER, CENTER);
    ortho();
    translate(-width/2.0, -height/2.0);
    // text(str, x, y, w, h)
    fill(100);
    rect(this.x, this.y, this.w, this.h);
    fill(255);
    text(this.text, this.x, this.y, this.w, this.h);
    popMatrix();
  }
}


public class BoolButton extends Button {
  boolean value = false;
  
  BoolButton(float x, float y, float w, float h, String text) {
    super(x, y, w, h, text);
  }
  
  BoolButton(float x, float y, float w, float h, String text, int font_size) {
    super(x, y, w, h, text, font_size);
  }
  
  BoolButton(float x, float y, float w, float h, String text, String label, int label_side) {
    super(x, y, w, h, text, label, label_side);
  }

  void bind(boolean[] value) {
    this.value = value[0];
  }

  void clicked() {
    this.value = !this.value;
  }
  
  boolean getValue() {
    return this.value;
  }
  
  void draw() {
    if (this.text.length() == 1){
      this.w += 2;
    }
    if (this.text.length() <= 0 ){
      return;
    }
    pushMatrix();
    resetMatrix();
    rectMode(CENTER);
    textAlign(CENTER, CENTER);
    ortho();
    translate(-width/2.0, -height/2.0);
    // text(str, x, y, w, h)
    if (this.value) {
      fill(color(50, 200, 50));
    }
    else {
      fill(color(255, 0, 0));
    }
    rect(this.x, this.y, this.w, this.h);
    fill(255);
    textSize(this.font_size);
    text(this.text, this.x, this.y, this.w, this.h);
    popMatrix();
  }
}


public class ClassFunctionButton extends Button {
   ButtonController controller;
  
  ClassFunctionButton(float x, float y, float w, float h, String text, ButtonController controller) {
    super(x, y, w, h, text);
    this.controller = controller;
  }
  
  ClassFunctionButton(float x, float y, float w, float h, String text, int font_size, ButtonController controller) {
    super(x, y, w, h, text, font_size);
    this.controller = controller;
  }
  
  ClassFunctionButton(float x, float y, float w, float h, String text, String label, int label_side, ButtonController controller) {
    super(x, y, w, h, text, label, label_side);
    this.controller = controller;
  }

  void clicked() {
    this.controller.execute();
  }
  
  void draw() {
    if (this.text.length() == 1){
      this.w += 2;
    }
    if (this.text.length() <= 0 ){
      return;
    }
    pushMatrix();
    resetMatrix();
    rectMode(CENTER);
    textAlign(CENTER, CENTER);
    ortho();
    translate(-width/2.0, -height/2.0);
    // text(str, x, y, w, h)
    fill(100);
    rect(this.x, this.y, this.w, this.h);
    fill(255);
    text(this.text, this.x, this.y, this.w, this.h);
    popMatrix();
  }
}


class Slider {
  int value = 1;
  int min_value = 0;
  int max_value = 0;
  // x, y on screen
  float x = 0;
  float y = 0;
  float w = 200;
  float h = 50;
  SliderDragBox sliding_box;
  SliderBackground sliding_bg;
  String label = "";
  
  Slider(int min_value, int max_value, float x, float y, float w, float h) {
    this.min_value = min_value;
    this.max_value = max_value;
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.sliding_box = new SliderDragBox(this, this.x, this.y, w / 10, h, this.x, this.x + w);
    this.sliding_bg = new SliderBackground(this, this.x, this.y, w, h);
  }
  
  Slider(int min_value, int max_value, float x, float y, float w, float h, String label) {
    this.min_value = min_value;
    this.max_value = max_value;
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.sliding_box = new SliderDragBox(this, this.x, this.y, w / 10, h, this.x, this.x + w);
    this.sliding_bg = new SliderBackground(this, this.x, this.y, w, h);
    this.label = label;
  }

  public float getValuePercentMedian() {
    // return percentage slider is dragged to from middle (-1 to 1)
    float median = (this.min_value + this.max_value) / 2;
    float value_percent = (this.value - median) / (this.max_value - median);
    return value_percent;
  }
  
  public float getValuePercent() {
    return float(this.value) / this.max_value;
  }
  
  public float getValue() {
    return this.value;
  }
  
  public void update() {
    this.sliding_box.update();
  }
  
  public void draw() {
    this.sliding_bg.drawBackground();
    this.sliding_box.drawDragBox();
    if (str(this.value).length() <= 0 ){
      return;
    }
    pushMatrix();
    resetMatrix();
    rectMode(CENTER);
    textAlign(CENTER, CENTER);
    ortho();
    translate(-width/2.0, -height/2.0);
    // text(str, x, y, w, h)
    fill(100);
    rect(this.x + this.w/2, this.y + this.h + 20, this.w, this.h);
    fill(255);
    String display_text = label + str(this.value);
    text(display_text, this.x + this.w/2, this.y + this.h + 20);
    popMatrix();
  }

}


class SliderDragBox {
  Slider parent;
  float x = 0;
  float y = 0;
  float w = 5;
  float h = 10;
  float min_x = 0;
  float max_x = 0;
  boolean focused = false;
  
  public SliderDragBox(Slider parent, float x, float y, float w, float h, float min_x, float max_x) {
    this.parent = parent;
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.min_x = min_x;
    this.max_x = max_x;
  }
  
  public void clicked() {
    if ((this.x - this.w/2) < mouseX && mouseX < (this.x + this.w/2)) {
      if ((this.y - this.h/2) < mouseY && mouseY < (this.y + this.h/2)) {
        this.focused = true;
      }
    }
  }
  
  public void unclicked() {
    this.focused = false;
  }
  
  private void update() {
    if (!this.focused) {
      return;
    }
    this.x = constrain(mouseX, this.min_x, this.max_x);
    this.parent.value = int(map(this.x, this.min_x, this.max_x, this.parent.min_value, this.parent.max_value));
  }
  
  public void drawDragBox() {
    pushMatrix();
    ortho();
    resetMatrix();
    rectMode(CENTER);
    fill(50);
    translate(-width/2.0, -height/2.0);
    rect(this.x, this.y, this.w, this.h);
    popMatrix();
  }
}


class SliderBackground {
  Slider parent;
  float x = 0;
  float y = 0;
  float w = 0;
  float h = 0;

  public SliderBackground(Slider parent, float x, float y, float w, float h) {
    this.parent = parent;
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
  }
  
  public void drawBackground() {
    pushMatrix();
    ortho();
    resetMatrix();
    rectMode(CENTER);
    fill(100);
    translate(-width/2.0, -height/2.0);
    // center line (slider along here)
    rect(this.x + (this.w / 2), this.y, this.w, this.h / 5);
    // left bounding box
    rect(this.x, this.y, this.w / 10, this.h);
    // right bounding box
    rect(this.x + this.w, this.y, this.w / 10, this.h);
    popMatrix();
  }
}
