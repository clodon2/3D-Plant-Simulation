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
    this.ground.beginShape(TRIANGLES);
    this.ground.stroke(255);
    this.ground.fill(100, 255, 0);
    float vertex_size = 20;
    float noiseScale = 0.05;
    float heightScale = 50;
    for (float x=-this.world_max_size.x/2; x<this.world_max_size.x/2; x+=vertex_size) {
      for (float z=-this.world_max_size.z/2; z<this.world_max_size.z/2; z+=vertex_size) {
        // Compute unique heights for all four corners of the current quad
        float y1 = noise(x * noiseScale, z * noiseScale) * heightScale;
        float y2 = noise((x + vertex_size) * noiseScale, z * noiseScale) * heightScale;
        float y3 = noise((x + vertex_size) * noiseScale, (z + vertex_size) * noiseScale) * heightScale;
        float y4 = noise(x * noiseScale, (z + vertex_size) * noiseScale) * heightScale;
  
        // First triangle
        ground.vertex(x, y1, z);
        ground.vertex(x + vertex_size, y2, z);
        ground.vertex(x + vertex_size, y3, z + vertex_size);
  
        // Second triangle
        ground.vertex(x, y1, z);
        ground.vertex(x + vertex_size, y3, z + vertex_size);
        ground.vertex(x, y4, z + vertex_size);
      } 
    } 
    this.ground.endShape();
  }
  
  PVector getRandomPointOnGround() {
    float vertex_size = 20;
    float noiseScale = 0.05;
    float heightScale = 50;
  
    float halfX = world_max_size.x / 2;
    float halfZ = world_max_size.z / 2;
  
    // Pick a random cell
    float x0 = random(-halfX, halfX - vertex_size);
    float z0 = random(-halfZ, halfZ - vertex_size);
  
    // Random local position inside the cell
    float localX = random(0, vertex_size);
    float localZ = random(0, vertex_size);
  
    // Heights at the four corners of the quad
    float y1 = noise((x0) * noiseScale, (z0) * noiseScale) * heightScale;
    float y2 = noise((x0 + vertex_size) * noiseScale, (z0) * noiseScale) * heightScale;
    float y3 = noise((x0 + vertex_size) * noiseScale, (z0 + vertex_size) * noiseScale) * heightScale;
    float y4 = noise((x0) * noiseScale, (z0 + vertex_size) * noiseScale) * heightScale;
  
    // Bilinear interpolation
    float tX = localX / vertex_size;
    float tZ = localZ / vertex_size;
    float yA = lerp(y1, y2, tX);
    float yB = lerp(y4, y3, tX);
    float y = lerp(yA, yB, tZ);
  
    return new PVector(x0 + localX, y, z0 + localZ);
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
}
