/*
File for extra random functions and stuff
*/


// get true/false randomly
public boolean randomBool() {
  if (random(1) > .5) {
    return true;
  }
  else {
    return false;
  }
}

// sigmoid function
public float sigmoid(float x) {
  return 1.0 / (1.0 + exp(-x));
}
