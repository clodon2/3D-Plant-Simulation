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

public float setRangeFloat(float min, float max, float value) {
  if (value > max) {
    return max;
  }
  else if (value < min) {
    return min;
  }
  return value;
}

void drawCylinder(PVector start, PVector end, float radius, int detail) {
  PVector dir = PVector.sub(end, start);
  float length = dir.mag();
  if (length < 0.0001) return;

  dir.normalize();

  PVector up = new PVector(0, 1, 0);
  float dot = up.dot(dir);

  pushMatrix();
  translate(start.x, start.y, start.z);

  if (dot < 0.9999 && dot > -0.9999) {
    // General case
    PVector rotAxis = up.cross(dir).normalize();
    float angle = acos(dot);
    rotate(angle, rotAxis.x, rotAxis.y, rotAxis.z);
  }
  else if (dot <= -0.9999) {
    // 180-degree flip
    rotate(PI, 1, 0, 0); // rotate around X (any perpendicular axis works)
  }
  // dot > 0.9999 → no rotation needed

  beginShape(QUAD_STRIP);
  for (int i = 0; i <= detail; i++) {
    float theta = TWO_PI * i / detail;
    float x = radius * cos(theta);
    float z = radius * sin(theta);
    vertex(x, 0, z);
    vertex(x, length, z);
  }
  endShape();

  popMatrix();
}


PVector componentMultiply(PVector a, PVector b) {
  return new PVector(a.x * b.x, a.y * b.y, a.z * b.z);
}

PVector rotateAroundAxis(PVector point, PVector axis, float angle) {
    axis = axis.copy().normalize(); // make sure axis is unit length
    float cosA = cos(angle);
    float sinA = sin(angle);

    // Rodrigues’ rotation formula
    PVector term1 = point.copy().mult(cosA);
    PVector term2 = axis.cross(point).mult(sinA);
    PVector term3 = axis.copy().mult(axis.dot(point) * (1 - cosA));

    return term1.add(term2).add(term3);
}
