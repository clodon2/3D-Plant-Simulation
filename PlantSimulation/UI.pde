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
  
}
