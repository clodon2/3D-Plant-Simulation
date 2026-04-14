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
  private int cols,rows;
  private float[][] height_map;
  private float[][][] world_resources;
  private int resource_types = 5;
  private float base_resource_amount = 50;
  private float vertex_size = 20;
  private float noise_scale = 0.01;
  private float height_scale = 100;
  
  // construct a world of a size
  World(PVector size) {
    this.world_max_size = size;
    this.generateWorld();
  }
  
  // create the ground within the world, unfinished
  private void generateGround() {
    this.cols = int(this.world_max_size.x / vertex_size) + 1;
    this.rows = int(this.world_max_size.z / vertex_size) + 1;
    
    this.height_map = new float[cols][rows];
    this.world_resources = new float[cols][rows][this.resource_types];
    
    float start_x = -this.world_max_size.x / 2;
    float start_z = -this.world_max_size.z / 2;
    
    // build height map to build world
    for (int i = 0; i < this.cols; i++) {
      for (int j = 0; j < this.rows; j++) {
        float x = start_x + i * this.vertex_size;
        float z = start_z + j * this.vertex_size;
        this.height_map[i][j] = noise(x * this.noise_scale, z * this.noise_scale) * this.height_scale;
        
        float[] newResources = {this.base_resource_amount, this.base_resource_amount, this.base_resource_amount, this.base_resource_amount, this.base_resource_amount};
        this.world_resources[i][j] = newResources;
      }
    }
    
    this.ground = createShape();
    this.ground.beginShape(TRIANGLES);
    this.ground.stroke(255);
    this.ground.fill(100, 255, 0);
    
    for (int i = 0; i < this.cols - 1; i++) {
      for (int j = 0; j < this.rows - 1; j++) {
    
        float x = start_x + i * this.vertex_size;
        float z = start_z + j * this.vertex_size;
    
        float y1 = this.height_map[i][j];
        float y2 = this.height_map[i+1][j];
        float y3 = this.height_map[i+1][j+1];
        float y4 = this.height_map[i][j+1];
    
        // Triangle A
        ground.vertex(x, y1, z);
        ground.vertex(x + this.vertex_size, y2, z);
        ground.vertex(x + this.vertex_size, y3, z + this.vertex_size);
    
        // Triangle B
        ground.vertex(x, y1, z);
        ground.vertex(x + this.vertex_size, y3, z + this.vertex_size);
        ground.vertex(x, y4, z + this.vertex_size);
      }
    }
    this.ground.endShape();
  }
  
  PVector getRandomPointOnGround() {
    float x = random(-this.world_max_size.x / 2, this.world_max_size.x / 2);
    float z = random(-this.world_max_size.z / 2, this.world_max_size.z / 2);
    float y;
    
    float start_x = -this.world_max_size.x / 2;
    float start_z = -this.world_max_size.z / 2;
  
    float fx = (x - start_x) / this.vertex_size;
    float fz = (z - start_z) / this.vertex_size;
  
    int i = floor(fx);
    int j = floor(fz);
  
    if (i < 0 || j < 0 || i >= this.cols - 1 || j >= this.rows - 1) {
      y = 0;
    }
    
    else {
      float tX = fx - i;
      float tZ = fz - j;
    
      float y1 = this.height_map[i][j];
      float y2 = this.height_map[i+1][j];
      float y3 = this.height_map[i+1][j+1];
      float y4 = this.height_map[i][j+1];
    
      if (tX + tZ <= 1) {
        // Triangle A: y1, y2, y3
        y = y1 * (1 - tX - tZ)
          + y2 * tX
          + y3 * tZ;
      } else {
        // Triangle B: y1, y3, y4
        float w1 = 1 - tX;
        float w3 = tX + tZ - 1;
        float w4 = 1 - tZ;
      
        y = w1 * y1 + w3 * y3 + w4 * y4;
      }
    }
    
    return new PVector(x, y, z);
  }

  
  // generate the whole world, unfinished
  public void generateWorld() {
    generateGround();
  }
  
  public void draw() {
    shape(this.ground);
  }
  
  // get the ground shape to draw
  public PShape getGround() {
    return this.ground;
  }
  
  public float updateResources(int world_row, int world_col, int resource_index, float change) {
    this.world_resources[world_row][world_col][resource_index] += change;
    return this.world_resources[world_row][world_col][resource_index];
  }
  
  public float updateResources(float world_x, float world_z, int resource_index, float change) {
    // shift x and z since world is centered at 0 0
    world_x += (this.world_max_size.x / 2);
    world_z += (this.world_max_size.z / 2);
    
    // update resources based on x/z conversion to matrix
    int world_row = int(world_x / this.vertex_size);
    int world_col = int(world_z / this.vertex_size);
    this.world_resources[world_row][world_col][resource_index] += change;
    return this.world_resources[world_row][world_col][resource_index];
  }
  
  public float[] updateResources(float world_x, float world_z, float[] change_array) {
    // shift x and z since world is centered at 0 0
    world_x += (this.world_max_size.x / 2);
    world_z += (this.world_max_size.z / 2);
    
    // update resources based on x/z conversion to matrix
    int world_row = int(world_x / this.vertex_size);
    int world_col = int(world_z / this.vertex_size);
    for (int i=0; i<change_array.length; i++) {
      this.world_resources[world_row][world_col][i] += change_array[i];
    }
    return this.world_resources[world_row][world_col];
  }
  
  public float[] getResources(float world_x, float world_z) {
    // shift x and z since world is centered at 0 0
    world_x += (this.world_max_size.x / 2);
    world_z += (this.world_max_size.z / 2);
    
    // return respurces based on x/z conversion to matrix
    int world_row = int(world_x / this.vertex_size);
    int world_col = int(world_z / this.vertex_size);
    return this.world_resources[world_row][world_col];
  }
  
  public float[] getResources(int world_row, int world_col) {
    return this.world_resources[world_row][world_col];
  }
  
  public void updateWorld() {
    // add base additions to all resource fields
    for (int i=0; i<this.rows; i++) {
      for (int k=0; k<this.cols; k++) {
        for (int r=0; r<this.world_resources[0][0].length; r++) {
          this.world_resources[i][k][r] += base_resource_gain * resource_gain_multiplier;
        }
      }
    }
  }
}


public class WorldTime {
  public float time_multiplier = 1;
  public int year;
  public int season;
  public float time;
  private int delta;
  private int last_delta = 0;
  
  WorldTime() {
    this.year = 0;
    this.season = 0;
    this.time = 0;
  }
  
  WorldTime(float time_speed_multiplier) {
    this.year = 0;
    this.season = 0;
    this.time = 0;
    this.time_multiplier = time_speed_multiplier;
  }
  
  void stepTime() {
    this.delta = millis() - last_delta;
    
    this.time += this.delta * this.time_multiplier;
    this.year = int(time / 31556952);
    this.season = int(time / (31556952/4));
    
    this.last_delta = millis();
  }
}
