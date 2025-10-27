/*
File for world creation code (light, elevation, soil, etc.) put drawing stuff in RenderPlantWorld function
*/


// region within the world that has specific conditions
public class WorldRegion {
  private PVector size;
  private PVector position;
  private HashMap<String, Float> conditions;
  
  // construct instance with a size, center position, and conditions
  WorldRegion(PVector region_size, PVector region_position, HashMap<String, Float> region_conditions) {
    this.size = region_size;
    this.position = region_position;
    this.conditions = region_conditions;
  }
  
  // construct instance with a size, and center position
  WorldRegion(PVector region_size, PVector region_position) {
    this.size = region_size;
    this.position = region_position;
    this.generateConditions();
  }
  
  // generate conditions of the region based on position and some functions
  public void generateConditions() {
    if (this.conditions == null) {
      this.conditions = new HashMap<String, Float>(); 
    }
    this.conditions.put("fertility", sigmoid(this.position.y));
  }
}


// world plants are in with some regions
public class World {
  private PVector world_max_size = new PVector(100, 20, 100);
  private PVector[] world_regions;
  private PShape ground;
  
  // construct a world of a size
  World(PVector size) {
    this.world_max_size = size;
    this.generateWorld();
  }
  
  // create the ground within the world, unfinished
  private void generateGround() {
    this.ground = createShape();
    this.ground.beginShape(TRIANGLE_STRIP);
    this.ground.stroke(255);
    this.ground.fill(100, 255, 0);
    for (float x=-10; x<10; x+=.01) {
      float y = sin(x);
      float z = cos(x) * 5;
      this.ground.vertex(x * 20, y * 10, z);
      this.ground.vertex(x * 20, y * 10, z + 5 * 5);
    } 
    this.ground.endShape();
  }
  
  // generate the whole world, unfinished
  public void generateWorld() {
    generateGround();
  }
  
  // get the ground shape to draw
  public PShape getGround() {
    return this.ground;
  }
}
