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
  // compute vector from start to end
  PVector dir = PVector.sub(end, start);
  float length = dir.mag();

  // unit direction
  PVector up = new PVector(0, 1, 0);
  PVector axis = dir.copy().normalize();

  // angle between Y-axis and direction
  float angle = acos(PVector.dot(up, axis));
  PVector rotAxis = up.cross(axis).normalize();

  pushMatrix();
  translate(start.x, start.y, start.z);

  if (rotAxis.mag() > 0.001) {
    rotate(angle, rotAxis.x, rotAxis.y, rotAxis.z);
  }

  // draw cylinder along Y-axis
  beginShape(QUAD_STRIP);
  for (int i = 0; i <= detail; i++) {
    float theta = TWO_PI * i / detail;
    float x = radius * cos(theta);
    float z = radius * sin(theta);
    vertex(x, 0, z);        // bottom circle
    vertex(x, length, z);   // top circle
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
