/*
File for extra random functions and stuff
*/


public boolean randomBool() {
  if (random(1) > .5) {
    return true;
  }
  else {
    return false;
  }
}

public float sigmoid(float x) {
  return 1.0 / (1.0 + exp(-x));
}
