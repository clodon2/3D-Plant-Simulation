/*
Code for plants here, for rendering them create a function in RenderPlantWorld
*/
import java.util.ArrayList;
import java.util.List;


public interface Gene {
  void mutate();
  Gene copy();
}


public class BoolGene implements Gene {
  private boolean value;
  
  public BoolGene(boolean value) {
    this.value = value;
  }
  
  @Override
  public void mutate() {
    this.value = !this.value;
  }
  
  @Override
  public Gene copy() {
    return new BoolGene(this.value);
  }
  
  public boolean getValue() {
    return this.value;
  }
  
  @Override
  public String toString() {
    return Boolean.toString(value);
  }
}


public class IntGene implements Gene {
  private int value;
  
  public IntGene(int value) {
    this.value = value;
  }
  
  @Override
  public void mutate() {
    this.value = this.value + int(random(this.value * -.2, this.value * .2));
  }
  
  @Override
  public Gene copy() {
    return new IntGene(this.value);
  }
  
  public int getValue() {
    return this.value;
  }
  
  @Override
  public String toString() {
    return Integer.toString(value);
  }
}


public class FloatGene implements Gene {
  private float value;
  
  public FloatGene(float value) {
    this.value = value;
  }
  
  @Override
  public void mutate() {
    this.value = this.value + random(this.value * -.2, this.value * .2);
  }
  
  @Override
  public Gene copy() {
    return new FloatGene(this.value);
  }
  
  public float getValue() {
    return this.value;
  }
  
  @Override
  public String toString() {
    return Float.toString(value);
  }
}


public class Chromosome {
  private List<Gene> genes;
  
  public Chromosome(List<Gene> genes) {
    this.genes = genes;
  }
  
  public void mutateGenes() {
    for (Gene gene : genes) {
      gene.mutate();
    }
  }
    
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
  
  @Override
  public String toString() {
    String gene_str = new String();
    for (Gene g : genes) {
      gene_str += g + " ";
    }
    return gene_str;
  }
}


public class Genotype {
  private List<Chromosome> chromosomes;
  
  public Genotype() {
    this.chromosomes = new ArrayList<>();
  }
  
  public void addChromosome(Chromosome chromosome) {
    this.chromosomes.add(chromosome);
  }

  public Genotype reproduce(Genotype partner_genome) {
    Genotype result_genome = new Genotype();
    // combine chromsomes of each genome together
    for (int i=0; i<this.chromosomes.size(); i++) {
      result_genome.addChromosome(this.chromosomes.get(i).crossover(partner_genome.chromosomes.get(i)));
    }
    return result_genome;
  }

  @Override
  public String toString() {
    String genotype_str = new String();
    for (Chromosome c : chromosomes) {
      genotype_str += c + "\n";
    }
    return genotype_str;
  }
}


public class Plant {
  public Genotype genotype;
  private float energy = 100;
  private PVector position = new PVector(0, 0, 0);
  
  Plant(Genotype genotype) {
    this.genotype = genotype;
  }
  
  public float getEnergy() {
    return this.energy;
  }
  
  public void updateEnergy(float change) {
    this.energy += change;
  }
}


public class PlantPopulation {
  private List<Plant> plants;
  
  PlantPopulation() {
    this.plants = new ArrayList<>();
  }
  
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
  
  public void stepPopulation() {
    this.reproducePopulation();
    this.updatePopulation();
    this.cullPopulation();
  }
  
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
  
  public void updatePopulation() {
  }
  
  public void cullPopulation() {
    List<Plant> new_plants = new ArrayList<>();
    for (int i=0; i<(this.plants.size()); i++) {
      if (this.plants.get(i).getEnergy() > 0) {
        new_plants.add(this.plants.get(i));
      }
    }
    this.plants = new_plants;
  }
  
  public void printPopulation() {
    for (int i=0; i<this.plants.size(); i++) {
      println(str(i) + this.plants.get(i).genotype);
    }
  }
}
