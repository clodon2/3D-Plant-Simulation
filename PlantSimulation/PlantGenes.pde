import java.util.ArrayList;
import java.util.List;


// baisc interface for a Gene, any gene calss will have these methods
public interface Gene<T> {
  void mutate();
  Gene<T> copy();
  T getValue();
}


// gene where the value is a boolean, can be used for basic attributes
public class BoolGene implements Gene<Boolean> {
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
  @Override
  public Boolean getValue() {
    return this.value;
  }
  
  // override from class, used for printing
  @Override
  public String toString() {
    return Boolean.toString(value);
  }
}


// gene where the value is an integer
public class IntGene implements Gene<Integer> {
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
  @Override
  public Integer getValue() {
    return this.value;
  }
  
  // override from class, used for printing
  @Override
  public String toString() {
    return Integer.toString(value);
  }
}


// gene where value is a float
public class FloatGene implements Gene<Float> {
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
  @Override
  public Float getValue() {
    return this.value;
  }
  
  // override from class, used for printing
  @Override
  public String toString() {
    return Float.toString(value);
  }
}


// gene where value is a 2d PVector
public class Vector2DGene implements Gene<PVector> {
  private PVector value;
  
  // construct instance of float gene with value
  public Vector2DGene(PVector value) {
    this.value = value;
  }
  
  // override from interface, mutate by adding or subtracting a value within 20 percent of value
  @Override
  public void mutate() {
    this.value.x += random(this.value.x * -.2, this.value.x * .2);
    this.value.y += random(this.value.y * -.2, this.value.y * .2);
  }
  
  // override from interface, copy gene
  @Override
  public Gene copy() {
    return new Vector2DGene(this.value);
  }
  
  // get value from gene
  @Override
  public PVector getValue() {
    return this.value;
  }
  
  // override from class, used for printing
  @Override
  public String toString() {
    return this.value.toString();
  }
}


// gene where value is a 3d Pvector
public class Vector3DGene implements Gene<PVector> {
  private PVector value;
  
  // construct instance of float gene with value
  public Vector3DGene(PVector value) {
    this.value = value;
  }
  
  // override from interface, mutate by adding or subtracting a value within 20 percent of value
  @Override
  public void mutate() {
    this.value.x += random(this.value.x * -.2, this.value.x * .2);
    this.value.y += random(this.value.y * -.2, this.value.y * .2);
    this.value.z += random(this.value.z * -.2, this.value.z * .2);
  }
  
  // override from interface, copy gene
  @Override
  public Gene copy() {
    return new Vector3DGene(this.value);
  }
  
  // get value from gene
  @Override
  public PVector getValue() {
    return this.value;
  }
  
  // override from class, used for printing
  @Override
  public String toString() {
    return this.value.toString();
  }
}

// gene where value is a 3d Pvector
public class Rotation3DGene implements Gene<PVector> {
  private PVector value;
  
  // construct instance of float gene with value
  public Rotation3DGene(PVector value) {
    this.value = value;
    this.fixMaxMinRotation();
  }
  
  // override from interface, mutate by adding or subtracting a value within 20 percent of value
  @Override
  public void mutate() {
    this.value.x += random(this.value.x * -.2, this.value.x * .2);
    this.value.y += random(this.value.y * -.2, this.value.y * .2);
    this.value.z += random(this.value.z * -.2, this.value.z * .2);
    this.fixMaxMinRotation();
  }
  
  public void fixMaxMinRotation() {
    this.value.x = setRangeFloat(0.0, PI, this.value.x);
    this.value.y = setRangeFloat(0.0, PI, this.value.y);
    this.value.z = setRangeFloat(0.0, PI, this.value.z);
  }
  
  // override from interface, copy gene
  @Override
  public Gene copy() {
    return new Rotation3DGene(this.value);
  }
  
  // get value from gene
  @Override
  public PVector getValue() {
    return this.value;
  }
  
  // override from class, used for printing
  @Override
  public String toString() {
    return this.value.toString();
  }
}
