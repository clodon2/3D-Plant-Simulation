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
  private float max_resources = 100;
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
    this.rows = int(this.world_max_size.x / vertex_size) + 1;
    this.cols = int(this.world_max_size.z / vertex_size) + 1;
    
    this.height_map = new float[this.rows][this.cols];
    this.world_resources = new float[this.rows][this.cols][this.resource_types];
    
    float start_x = -this.world_max_size.x / 2;
    float start_z = -this.world_max_size.z / 2;
    
    // build height map to build world
    for (int i = 0; i < this.rows; i++) {
      for (int j = 0; j < this.cols; j++) {
        float x = start_x + i * this.vertex_size;
        float z = start_z + j * this.vertex_size;
        this.height_map[i][j] = noise(x * this.noise_scale, z * this.noise_scale) * this.height_scale;
        
        float[] newResources = {this.base_resource_amount, this.base_resource_amount, this.base_resource_amount, this.base_resource_amount, this.base_resource_amount};
        this.world_resources[i][j] = newResources;
      }
    }
    
    this.ground = createShape();
    this.ground.beginShape(TRIANGLES);
    hint(ENABLE_DEPTH_TEST);
    this.ground.noStroke();
    
  // We loop to (rows-1) and (cols-1) because we are looking at the "cells" between vertices
    for (int i = 0; i < this.rows - 1; i++) {
      for (int j = 0; j < this.cols - 1; j++) {
              
        // Calculate indices for the 4 corners of the current square
        int topLeft     = i * this.cols + j;
        int topRight    = (i + 1) * this.cols + j;
        int bottomRight = (i + 1) * this.cols + (j + 1);
        int bottomLeft  = i * this.cols + (j + 1);

        // Triangle 1
        addVertexFromGrid(topLeft);
        addVertexFromGrid(topRight);
        addVertexFromGrid(bottomRight);

        // Triangle 2
        addVertexFromGrid(topLeft);
        addVertexFromGrid(bottomRight);
        addVertexFromGrid(bottomLeft);
        }
    }
  this.ground.endShape();
  }
  
  // Helper to keep the generateGround code clean
  private void addVertexFromGrid(int index) {
      int r = index / this.cols; // Recover row (X)
      int c = index % this.cols; // Recover col (Z)
      
      float x = (-this.world_max_size.x / 2) + (r * this.vertex_size);
      float z = (-this.world_max_size.z / 2) + (c * this.vertex_size);
      float y = this.height_map[r][c];
      
      this.ground.fill(150, 75, 15);
      this.ground.vertex(x, y, z);
  }
  
  PVector getRandomPointOnGround() {
  
    float x = random(-this.world_max_size.x / 2, this.world_max_size.x / 2);
    float z = random(-this.world_max_size.z / 2, this.world_max_size.z / 2);
  
    float start_x = -this.world_max_size.x / 2;
    float start_z = -this.world_max_size.z / 2;
  
    float fx = (x - start_x) / this.vertex_size;
    float fz = (z - start_z) / this.vertex_size;
  
    int i = constrain(floor(fx), 0, this.rows - 2);
    int j = constrain(floor(fz), 0, this.cols - 2);
  
    float tX = fx - i;
    float tZ = fz - j;
  
    float y1 = this.height_map[i][j];
    float y2 = this.height_map[i+1][j];
    float y3 = this.height_map[i+1][j+1];
    float y4 = this.height_map[i][j+1];
  
    float y;
  
    if (tX + tZ <= 1) {
      y = y1 * (1 - tX - tZ) + y2 * tX + y3 * tZ;
    } else {
      y = (1 - tX) * y1 + (tX + tZ - 1) * y3 + (1 - tZ) * y4;
    }
  
    return new PVector(x, y, z);
  }

  
  // generate the whole world, unfinished
  public void generateWorld() {
    noiseSeed((int)random(100000));
    generateGround();
  }
  
  public void draw() {
    pushStyle();
    fill(255);   // global fill shouldn't matter if vertex colors work
    
    shape(this.ground);
    popStyle();
  }
  
  // get the ground shape to draw
  public PShape getGround() {
    return this.ground;
  }
  
  private int calculateResourceColor(float[] resources) {
    float r1 = resources[0] / this.max_resources; // moisture
    float r2 = resources[1] / this.max_resources; // nitrogen
    float r3 = resources[2] / this.max_resources; // iron
    float r4 = resources[3] / this.max_resources; // phosphorus
    float r5 = resources[4] / this.max_resources; // brightness
  
    // overall resource richness
    float total = (r1 + r2 + r3 + r4) / 4.0;
  
    // base brown
    float red   = 95;
    float green = 75;
    float blue  = 50;
  
    // subtle color influence (still brown-biased)
    red   += (r3 * 35) + (r4 * 20);
    green += (r2 * 25);
    blue  += (r1 * 15);
  
    // back toward brown
    float avg = (red + green + blue) / 3.0;
    float brownBias = 0.5;
  
    red   = lerp(avg + 10, red, brownBias);
    green = lerp(avg,      green, brownBias);
    blue  = lerp(avg - 10, blue, brownBias);
  
    // desaturate 
    float grey = (red + green + blue) / 3.0;
    float saturation = 0.5;
  
    red   = lerp(grey, red, saturation);
    green = lerp(grey, green, saturation);
    blue  = lerp(grey, blue, saturation);
  
    // Low resources much darker
    // High resources near normal
    float richnessBrightness = pow(total, 1.5); // exaggerates low-resource darkness
    richnessBrightness = lerp(0.3, 1.1, richnessBrightness);
  
    // normal brightness
    float brightness = map(r5, 0, 1, 0.9, 1.1);
  
    float finalScale = richnessBrightness * brightness;
  
    return color(
      constrain(red * finalScale, 0, 255),
      constrain(green * finalScale, 0, 255),
      constrain(blue * finalScale, 0, 255)
    );
  }
  
  public void updateColor(int world_row, int world_col) {
    world_row = constrain(world_row, 0, this.rows - 2);
    world_col = constrain(world_col, 0, this.cols - 2);
    int vertex_number = (world_row * (this.cols - 1) + world_col) * 6;
    float[] resources = getResources(world_row, world_col);
    
    for (int i=0; i<6; i++) {
      
      this.ground.setFill(vertex_number + i, this.calculateResourceColor(resources));
    }
  }
  
  public float updateResources(int world_row, int world_col, int resource_index, float change) {
    float current = this.world_resources[world_row][world_col][resource_index];
    this.world_resources[world_row][world_col][resource_index] = constrain(current + change, 0, this.max_resources);
    return this.world_resources[world_row][world_col][resource_index];
  }
  
  public float updateResources(float world_x, float world_z, int resource_index, float change) {
    // shift x and z since world is centered at 0 0
    world_x += (this.world_max_size.x / 2);
    world_z += (this.world_max_size.z / 2);
    
    // update resources based on x/z conversion to matrix
    int world_row = int(world_x / this.vertex_size);
    int world_col = int(world_z / this.vertex_size);
    
    float current = this.world_resources[world_row][world_col][resource_index];
    this.world_resources[world_row][world_col][resource_index] = constrain(current + change, 0, this.max_resources);
    
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
      float current = this.world_resources[world_row][world_col][i];
      float change = change_array[i];
      this.world_resources[world_row][world_col][i] = constrain(current + change, 0, this.max_resources);
    }
    return this.world_resources[world_row][world_col];
  }
  
  public void updateResourcesRadius(float world_x, float world_z, float[] change_array, float radius) {
    // shift x and z since world is centered at 0 0
    world_x += (this.world_max_size.x / 2);
    world_z += (this.world_max_size.z / 2);
    
    int min_row = max(0, int((world_x - radius) / this.vertex_size));
    int max_row = min(this.rows - 1, int((world_x + radius) / this.vertex_size));
    int min_col = max(0, int((world_z - radius) / this.vertex_size));
    int max_col = min(this.cols - 1, int((world_z + radius) / this.vertex_size));
    
    for (int r=min_row; r<=max_row; r++) {
      for (int c=min_col; c<=max_col; c++) {
        float groundX = (r * this.vertex_size);
        float groundZ = (c * this.vertex_size);
        float distance = dist(world_x, world_z, groundX, groundZ);
        
        if (distance <= radius) {
          float falloff = 1.0 - (distance / radius);
          for (int i=0; i<change_array.length; i++) {
            float current = this.world_resources[r][c][i];
            float change = change_array[i] * falloff;
            this.world_resources[r][c][i] = constrain(current + change, 0, this.max_resources);
          }
        }
      }
    }
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
          float current = this.world_resources[i][k][r];
          float change = base_resource_gain * resource_gain_multiplier;
          this.world_resources[i][k][r] = constrain(current + change, 0, this.max_resources);
        }
        this.updateColor(i,k);
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


public void updateSun(float worldTime) {
  // Map time to a 0-PI cycle (Sun up to Sun down)
  // 86400 is seconds in a day; adjust based on your time_multiplier [cite: 76, 80]
  float dayCycle = (worldTime % 86400) / 86400.0;
  float angle = map(dayCycle, 0, 1, 0, PI); 
  
  // X moves East to West, Y is the height in the sky
  float sunX = cos(angle);
  float sunY = sin(angle); // sin(0 to PI) is always positive (pointing down)
  
  // Determine color based on how high the sun is
  int sunColor = getSunColor(sunY);
  
  // Apply the light: The direction vector (sunX, sunY, 0) 
  // now points down toward the height_map [cite: 13]
  directionalLight(red(sunColor), green(sunColor), blue(sunColor), sunX, sunY, 0);
}


int getSunColor(float sunY) {
  // If sunY is near 0, it's sunrise/sunset
  if (sunY < 0.2) {
    return lerpColor(color(255, 100, 50), color(255, 200, 100), map(sunY, 0, 0.2, 0, 1));
  } 
  // High sun (Midday)
  return color(255, 255, 240);
}
