/*
Code for plants here, for rendering them create a function in RenderPlantWorld
*/
import java.util.ArrayList;
import java.util.List;


// baisc interface for a Gene, any gene calss will have these methods
public interface Gene {
  void mutate();
  Gene copy();
}


// gene where the value is a boolean, can be used for basic attributes
public class BoolGene implements Gene {
  private boolean value;
  
  // construct instance of class with value
  public BoolGene(boolean value) {
    this.value = value;
  }
  
  // override from interface, mutate gene by flipping
  @Override
  public void mutate() {
    this.value = !this.value;
  }
  
  // override from interface, create a copy of the gene
  @Override
  public Gene copy() {
    return new BoolGene(this.value);
  }
  
  // get the value in the gene
  public boolean getValue() {
    return this.value;
  }
  
  // override from class, used for printing
  @Override
  public String toString() {
    return Boolean.toString(value);
  }
}


// gene where the value is an integer
public class IntGene implements Gene {
  private int value;
  
  // construct gene with value
  public IntGene(int value) {
    this.value = value;
  }
  
  // override from interface, mutate by subtracting or adding a random value within 20 percent of value
  @Override
  public void mutate() {
    this.value = this.value + int(random(this.value * -.2, this.value * .2));
  }
  
  // override from interface, create a copy of the gene
  @Override
  public Gene copy() {
    return new IntGene(this.value);
  }
  
  // get value of gene
  public int getValue() {
    return this.value;
  }
  
  // override from class, used for printing
  @Override
  public String toString() {
    return Integer.toString(value);
  }
}


// gene where value is a float
public class FloatGene implements Gene {
  private float value;
  
  // construct instance of float gene with value
  public FloatGene(float value) {
    this.value = value;
  }
  
  // override from interface, mutate by adding or subtracting a value within 20 percent of value
  @Override
  public void mutate() {
    this.value = this.value + random(this.value * -.2, this.value * .2);
  }
  
  // override from interface, copy gene
  @Override
  public Gene copy() {
    return new FloatGene(this.value);
  }
  
  // get value from gene
  public float getValue() {
    return this.value;
  }
  
  // override from class, used for printing
  @Override
  public String toString() {
    return Float.toString(value);
  }
}


// chromosome, collection of genes representing a trait
public class Chromosome {
  private List<Gene> genes;
  
  // construct instance of chromosome with list of genes
  public Chromosome(List<Gene> genes) {
    this.genes = genes;
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
  
  public void draw() {
    this.body.draw();
  }
}


// visual part of a plant, used for rendering in the world
public class PlantBody {
  private PVector position = new PVector(0, 0, 0);
  // structured such that each list in body represents a collection of points forming a line, so we store branches and the main trunk or stem in separate lists in body
  private ArrayList<ArrayList<PVector>> body;
  // structured such that each list in leaves represents a collection of points forming a shape for a leaf
  private ArrayList<ArrayList<PVector>> leaves;
  
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
  
  public void draw() {
    stroke(0);
    noFill();
    for (ArrayList<PVector> branch: this.body) {
      beginShape();
      for (PVector point: branch) {
        vertex(point.x, point.y, point.z);
      }
      endShape();
    }
  }
}


// holds the entire population of plants
public class PlantPopulation {
  private List<Plant> plants;
  
  // construct new empty population
  PlantPopulation() {
    this.plants = new ArrayList<>();
  }
  
  // create an initial population of size and number of chromosomes for each plant
  public void initPopulation(int population_size, int chromosome_size) {
    for (int i=0; i<population_size; i++) {
      Genotype newGenotype = new Genotype();
      
      // generate a random chromosome
      List<Gene> randGenes = new ArrayList<>();
      for (int j=0; j<chromosome_size; j++) {
        randGenes.add(new BoolGene(randomBool()));
      }
      
      // add chromosome to genotype and create new plant with genotype
      newGenotype.addChromosome(new Chromosome(randGenes));
      this.plants.add(new Plant(newGenotype));
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
      new_plants.add(new Plant(newGenome));
    }
    this.plants.addAll(new_plants);
  }
  
  // update population (growing and stuff)
  public void updatePopulation() {
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
}
