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

}


public class Plant {
  private Genotype genotype;
  
  Plant(Genotype genotype) {
    this.genotype = genotype;
  }
}
