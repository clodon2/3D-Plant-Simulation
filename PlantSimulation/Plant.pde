/*
Code for plants here, for rendering them create a function in RenderPlantWorld
*/

// chromosome, collection of genes representing a trait
public class Chromosome {
  private List<Gene> genes;
  
  // construct instance of chromosome with list of genes
  public Chromosome(List<Gene> genes) {
    this.genes = genes;
  }
  
  public Gene getGene(int index) {
    return this.genes.get(index);
  }
  
  // mutate all genes in chromosome
  public void mutateGenes() {
    for (Gene gene : genes) {
      gene.mutate();
    }
  }
  
  // perform a crossover reproduction between this chromosome and another
  // generates a new chromsome with the first half of this chromosome and second half of other
  public Chromosome crossover(Chromosome partner) { 
    List<Gene> newGenes = new ArrayList<>();
    // crossover logic here, gene.copy to not overwrite
    //right now crossover just takes 1st half of one and the second half of the other, should be more advanced
    for (int i=0; i<this.genes.size(); i++) {
      if (i < ( this.genes.size() / 2 ) ) {
        newGenes.add(this.genes.get(i).copy());
      }
      else {
        newGenes.add(partner.genes.get(i).copy());
      }
    }
    return new Chromosome(newGenes);
  }
  
  // override from class, used for printing
  @Override
  public String toString() {
    String gene_str = new String();
    for (Gene g : genes) {
      gene_str += g + " ";
    }
    return gene_str;
  }
}


// genotype, collection of chromosomes represnting all traits
public class Genotype {
  private List<Chromosome> chromosomes;
  
  // construct new empty genotype
  public Genotype() {
    this.chromosomes = new ArrayList<>();
  }
  
  public Chromosome getChromosome(int index) {
    return this.chromosomes.get(index);
  }
  
  // add chromsome to genotype
  public void addChromosome(Chromosome chromosome) {
    this.chromosomes.add(chromosome);
  }

  // reproduce this genotype with another using chromsome crossover on all chromosomes
  public Genotype reproduce(Genotype partner_genome) {
    Genotype result_genome = new Genotype();
    // combine chromsomes of each genome together
    for (int i=0; i<this.chromosomes.size(); i++) {
      result_genome.addChromosome(this.chromosomes.get(i).crossover(partner_genome.chromosomes.get(i)));
    }
    return result_genome;
  }

  // override from class, used for printing
  @Override
  public String toString() {
    String genotype_str = new String();
    for (Chromosome c : chromosomes) {
      genotype_str += c + "\n";
    }
    return genotype_str;
  }
}


// actual plant, holding body, genotype, energy, and other information
public class Plant {
  public Genotype genotype;
  private float energy = 100;
  private PlantBody body;
  
  private float leaf_growth_frequency_tracker = 0;
  
  // construct plant with a genotype
  Plant(Genotype genotype) {
    this.genotype = genotype;
    this.body = new PlantBody(new PVector(0, 0, 0));
  }
  
  // construct plant with a genotype and position
  Plant(Genotype genotype, PVector position) {
    this.genotype = genotype;
    this.body = new PlantBody(position);
  }
  
  // get the energy of this plant
  public float getEnergy() {
    return this.energy;
  }
  
  // change plant's energy by some amount
  public void updateEnergy(float change) {
    this.energy += change;
  }
  
  public void update() {
    Chromosome growth_chromosome = this.genotype.getChromosome(0);
    Gene<Float> max_size_gene = growth_chromosome.getGene(1);
    Gene<Float> growth_rate_gene = growth_chromosome.getGene(0);
    if (max_size_gene.getValue() < this.body.getSize()) {
      return;
    }
    // leaf gene references
    Chromosome leaf_chromosome = this.genotype.getChromosome(1);
    Gene<Float> leaf_width_gene = leaf_chromosome.getGene(0);
    Gene<Float> leaf_length_gene = leaf_chromosome.getGene(1);
    Gene<Float> leaf_growth_frequency_gene = leaf_chromosome.getGene(2);
    Gene<Float> leaf_rotation_bias_gene = leaf_chromosome.getGene(4);
    
    PlantBranch trunkBranch = this.body.trunk_branch;
    this.recursiveUpdateTraversal(trunkBranch);
  }
  
  private void recursiveUpdateTraversal(PlantBranch startBranch) {
    Chromosome growth_chromosome = this.genotype.getChromosome(0);
    Gene<Float> max_size_gene = growth_chromosome.getGene(1);
    Gene<Float> growth_rate_gene = growth_chromosome.getGene(0);
    
    Chromosome leaf_chromosome = this.genotype.getChromosome(1);
    Gene<Float> leaf_width_gene = leaf_chromosome.getGene(0);
    Gene<Float> leaf_length_gene = leaf_chromosome.getGene(1);
    Gene<Float> leaf_growth_frequency_gene = leaf_chromosome.getGene(2);
    Gene<Float> leaf_rotation_bias_gene = leaf_chromosome.getGene(4);

    // update current branch
    if (max_size_gene.getValue() > this.body.getSize()) {
      startBranch.grow(growth_rate_gene.getValue());
      this.body.updateSize(growth_rate_gene.getValue());
      
      // generate leaf
      if (leaf_growth_frequency_gene.getValue() <= (this.leaf_growth_frequency_tracker / max_size_gene.getValue())) {
        float leaf_rotation = random(0, 2*PI);
        ArrayList<PVector> new_leaf_points = this.generateLeaf(startBranch.points.get(startBranch.points.size() - 1).copy(), startBranch.getGrowthDirection(), leaf_width_gene.getValue(), leaf_length_gene.getValue(), leaf_rotation);
        startBranch.addLeaf(new PlantLeaf(new_leaf_points));
        this.leaf_growth_frequency_tracker = 0;
      }
      this.leaf_growth_frequency_tracker += growth_rate_gene.getValue();
    }
    
    // check if sub branches
    ArrayList<PlantBranch> nextBranches = startBranch.getBranches();
    if (nextBranches == null) {
      return;
    }
    
    // recursive call rest of sub branches
    for (PlantBranch branch: startBranch.getBranches()) {
      this.recursiveUpdateTraversal(branch);
    }
  }
  
  public void draw() {
    this.body.draw();
  }
  
  private ArrayList<PVector> generateLeaf(PVector source_point, PVector growth_direction, float leaf_width, float leaf_length, float rotation_angle) {
    ArrayList<PVector> new_leaf = new ArrayList<PVector>();
    new_leaf.add(source_point);
    PVector left_base = new PVector(-leaf_width/2, .1, leaf_length/2);
    PVector right_base = new PVector(leaf_width/2, .1, leaf_length/2);
    PVector tip_base = new PVector(0, .1, leaf_length);
    
    PVector left_point = source_point.copy().add(rotateAroundAxis(left_base, growth_direction, rotation_angle));
    PVector right_point = source_point.copy().add(rotateAroundAxis(right_base, growth_direction, rotation_angle));
    PVector tip_point = source_point.copy().add(rotateAroundAxis(tip_base, growth_direction, rotation_angle));
    
    new_leaf.add(left_point);
    new_leaf.add(right_point);
    new_leaf.add(tip_point);
    return new_leaf;
  }
}


// visual part of a plant, used for rendering in the world
public class PlantBody {
  private PVector position = new PVector(0, 0, 0);
  private float total_size = 0.0;
  // structured where each branch stores leaves and sub branches
  private PlantBranch trunk_branch;
  
  PlantBody(PVector position) {
    this.position = position;
    this.trunk_branch = new PlantBranch(position);
    this.trunk_branch.addPoint(new PVector (position.x, position.y, position.z));
  }
  
  public PlantBranch getTrunk() {
    return this.trunk_branch;
  }
  
  public Float getSize() {
    return this.total_size;
  }
  
  public Float updateSize(float amount) {
    this.total_size += amount;
    return this.total_size;
  }
  
  public void draw() {
    fill(100, 255, 100);
    noStroke();
    
    this.recursiveDrawTraversal(this.trunk_branch);
  }
  
  private void recursiveDrawTraversal(PlantBranch startBranch) {
     // draw current branch
    for (int i = 0; i < startBranch.points.size() - 1; i++) {
      drawCylinder(startBranch.getPoints().get(i), startBranch.getPoints().get(i+1), 1.5, 4);
    }
    // draw current leaves
    for (PlantLeaf leaf : startBranch.leaves) {
      PVector source = leaf.points.get(0);
      PVector left = leaf.points.get(1);
      PVector right = leaf.points.get(2);
      PVector tip = leaf.points.get(3);
  
      // Draw as a simple triangle fan
      fill(0, 255, 0, 200); // green with some transparency
      noStroke();
      beginShape();
      vertex(source.x, source.y, source.z);
      vertex(left.x, left.y, left.z);
      vertex(tip.x, tip.y, tip.z);
      vertex(right.x, right.y, right.z);
      endShape(CLOSE);
    }
    
    // check if sub branches
    ArrayList<PlantBranch> nextBranches = startBranch.getBranches();
    if (nextBranches == null) {
      return;
    }
    
    // recursive call rest of sub branches
    for (PlantBranch branch: startBranch.getBranches()) {
      this.recursiveDrawTraversal(branch);
    }
  }
  
}


public class PlantLeaf {
  private ArrayList<PVector> points;
  
  PlantLeaf(ArrayList<PVector> points) {
    this.points = points;
  }
  
  public void setLeaf(ArrayList<PVector> new_points) {
    this.points = new_points;
  }
  
  public ArrayList<PVector> getPoints() {
    return this.points;
  }
}


//class for a branch of a plant
public class PlantBranch {
  private PVector growth_direction;
  private ArrayList<PVector> points;
  private ArrayList<PlantLeaf> leaves;
  private ArrayList<PlantBranch> sub_branches;
  
  PlantBranch(PVector position) {
    this.points = new ArrayList<PVector>();
    this.leaves = new ArrayList<PlantLeaf>();
    this.points.add(position);
    this.growth_direction = new PVector(0, -1, 0);
  }
  
  public void grow(float amount) {
    PVector last_point = this.points.get(this.points.size() - 1);
    last_point.add(this.growth_direction.copy().mult(amount));
  }
  
  public void addPoint(PVector point) {
    this.points.add(point);
  }
  
  public void addBranch(PlantBranch branch) {
    if (this.sub_branches == null) {
      this.sub_branches = new ArrayList<PlantBranch>();
    }
    this.sub_branches.add(branch);
  }
  
  public void addLeaf(PlantLeaf leaf) {
    this.leaves.add(leaf);
  }
  
  public void setGrowthDirection(PVector direction) {
    this.growth_direction = direction;
  }
  
  public PVector getGrowthDirection() {
    return this.growth_direction;
  }
  
  public ArrayList<PVector> getPoints() {
    return this.points;
  }
  
  public ArrayList<PlantBranch> getBranches() {
    return this.sub_branches;
  }
}


// holds the entire population of plants
public class PlantPopulation {
  private List<Plant> plants;
  private World world;
  
  // construct new empty population
  PlantPopulation(World world) {
    this.plants = new ArrayList<>();
    this.world = world;
  }
  
  // create an initial population of size and number of chromosomes for each plant
  public void initPopulation(int population_size, int chromosome_size) {
    for (int i=0; i<population_size; i++) {
      Genotype newGenotype = new Genotype();
      
      // generate a random chromosome for growth info
      List<Gene> growthGenes = new ArrayList<>();
      // growth rate
      growthGenes.add(new FloatGene(random(.5, 1)));
      // max growth length
      growthGenes.add(new FloatGene(random(10, 30)));
      // rotation gene (useless now)
      growthGenes.add(new Rotation3DGene(new PVector(random(0, PI), random(0, PI), random(0, PI))));
      
      List<Gene> leafGenes = new ArrayList<>();
      // leaf width
      leafGenes.add(new FloatGene(random(8, 15)));
      // leaf length
      leafGenes.add(new FloatGene(random(12, 26)));
      // leaf frequency (1 per growth percentage)
      leafGenes.add(new FloatGene(random(.1, 1)));
      // leaf branch modifier (branches have more or less leaves)
      leafGenes.add(new FloatGene(random(0, 5)));
      // leaf rotation bias
      leafGenes.add(new FloatGene(random(0, 2 * PI)));
      
      List<Gene> branchGenes = new ArrayList<>();
      // branch amount
      branchGenes.add(new IntGene(int(random(0, 10))));
      
      
      // add chromosome to genotype and create new plant with genotype
      newGenotype.addChromosome(new Chromosome(growthGenes));
      newGenotype.addChromosome(new Chromosome(leafGenes));
      newGenotype.addChromosome(new Chromosome(branchGenes));
      this.plants.add(new Plant(newGenotype, this.world.getRandomPointOnGround()));
    }
  }
  
  // move the simulation forward one step
  public void stepPopulation() {
    this.reproducePopulation();
    this.updatePopulation();
    this.cullPopulation();
  }
  
  // reproduce all plants in population based on energy
  public void reproducePopulation() {
    List<Plant> new_plants = new ArrayList<>();
    List<Plant> healthy_plants = new ArrayList<>();
    for (int i=0; i<(this.plants.size() - 1); i++) {
      if (this.plants.get(i).getEnergy() > 90) {
          healthy_plants.add(this.plants.get(i));
      }
    }
    for (int i=0; i<(healthy_plants.size() - 1); i++) {
      Genotype newGenome = healthy_plants.get(i).genotype.reproduce(healthy_plants.get(i+1).genotype);
      new_plants.add(new Plant(newGenome, this.world.getRandomPointOnGround()));
    }
    this.plants.addAll(new_plants);
  }
  
  // update population (growing and stuff)
  public void updatePopulation() {
    for (int i=0; i<(this.plants.size()); i++) {
      this.plants.get(i).update();
    }
  }
  
  // kill plants below a certain energy level
  public void cullPopulation() {
    List<Plant> new_plants = new ArrayList<>();
    for (int i=0; i<(this.plants.size()); i++) {
      if (this.plants.get(i).getEnergy() > 0) {
        new_plants.add(this.plants.get(i));
      }
    }
    this.plants = new_plants;
  }
  
  // print all plant genotypes in population
  public void printPopulation() {
    for (int i=0; i<this.plants.size(); i++) {
      println(str(i) + this.plants.get(i).genotype);
    }
  }
  
  public void draw() {
    for (int i=0; i<this.plants.size(); i++) {
      this.plants.get(i).draw();
    }
  }
}
