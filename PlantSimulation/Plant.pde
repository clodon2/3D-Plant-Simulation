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
  
  // construct plant with a genotype
  Plant(Genotype genotype) {
    this.genotype = genotype;
    this.body = new PlantBody(new PVector(0, 0, 0));
    this.body.addBranchToBody(new ArrayList<PVector>());
    this.body.addPointToBranch(new PVector(0, 0, 0), 0);
  }
  
  // construct plant with a genotype and body
  Plant(Genotype genotype, PVector position) {
    this.genotype = genotype;
    this.body = new PlantBody(position);
    this.body.addBranchToBody(new ArrayList<PVector>());
    this.body.addPointToBranch(position, 0);
  }
  
  // get the energy of this plant
  public float getEnergy() {
    return this.energy;
  }
  
  // change plant's energy by some amount
  public void updateEnergy(float change) {
    this.energy += change;
  }
  
  public void generateBody() {
    ArrayList<PVector> plantBase = new ArrayList<>();
    plantBase.add(this.body.position);
    plantBase.add(new PVector(this.body.position.x, this.body.position.y + 10, this.body.position.z));
    this.body.addBranchToBody(plantBase);
  }
  
  public void update() {
    Chromosome growth_chromosome = this.genotype.getChromosome(0);
    Gene<Float> max_size_gene = growth_chromosome.getGene(1);
    Gene<Float> growth_rate_gene = growth_chromosome.getGene(0);
    if (max_size_gene.getValue() < this.body.getSize()) {
      return;
    }
    ArrayList<ArrayList<PVector>> plant_branches = this.body.getBody();
    for (int i=0; i<plant_branches.size(); i++) {
      PVector last_point = plant_branches.get(i).get(plant_branches.get(i).size() - 1);
      this.body.addPointToBranch(new PVector(last_point.x, last_point.y - growth_rate_gene.getValue(), last_point.z), i);
      this.body.updateSize(growth_rate_gene.getValue());
    }
  }
  
  public void draw() {
    this.body.draw();
  }
}


// visual part of a plant, used for rendering in the world
public class PlantBody {
  private PVector position = new PVector(0, 0, 0);
  private float total_size = 0.0;
  // structured such that each list in body represents a collection of points forming a line, so we store branches and the main trunk or stem in separate lists in body
  private ArrayList<ArrayList<PVector>> body;
  // structured such that each list in leaves represents a collection of points forming a shape for a leaf
  private ArrayList<ArrayList<PVector>> leaves;
  
  PlantBody(PVector position) {
    this.position = position;
    this.body = new ArrayList<ArrayList<PVector>>();
    this.leaves = new ArrayList<ArrayList<PVector>>();
  }
  
  PlantBody(ArrayList<ArrayList<PVector>> body, ArrayList<ArrayList<PVector>>leaves) {
    this.body = body;
    this.leaves = leaves;
  }
  
  public void addBranchToBody(ArrayList<PVector> branch) {
    this.body.add(branch);
  }
  
  public void addPointToBranch(PVector point, int index) {
    this.body.get(index).add(point);
  }
  
  public void addLeafToBody(ArrayList<PVector> leaf) {
    this.leaves.add(leaf);
  }
  
  public void addPointToLeaf(PVector point, int index) {
    this.leaves.get(index).add(point);
  }
  
  public ArrayList<ArrayList<PVector>> getBody() {
    return this.body;
  }
  
  public ArrayList<ArrayList<PVector>> getLeaves() {
    return this.leaves;
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
  
    for (ArrayList<PVector> branch : this.body) {
      for (int i = 0; i < branch.size() - 1; i++) {
        drawCylinder(branch.get(i), branch.get(i + 1), 1.5, 16);
      }
    }
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
      
      // generate a random chromosome
      List<Gene> randGenes = new ArrayList<>();
      // growth rate
      randGenes.add(new FloatGene(random(.5, 1)));
      // max growth length
      randGenes.add(new FloatGene(random(10, 30)));
      // rotation gene (useless now)
      randGenes.add(new Rotation3DGene(new PVector(random(0, PI), random(0, PI), random(0, PI))));
      
      // add chromosome to genotype and create new plant with genotype
      newGenotype.addChromosome(new Chromosome(randGenes));
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
