/*
File that holds the class for the camera which can move around
*/


class FlyCamera {
  float x, y, z;
  float yaw, pitch;
  float moveSpeed = 3;
  float lookSpeed = 0.03;  // arrow key sensitivity
  
  // orbit at a point if in mode
  boolean orbitMode = false;

  float targetX = 0;
  float targetY = 0;
  float targetZ = 0;
  float distance = 300;
  float orbitSpeed = 0.01;
  float orbitPitch = -PI / 6;

  FlyCamera() {
    x = 0;
    y = 0;
    z = 200;
    yaw = 0;
    pitch = 0;
  }
  
  void setOrbitControls(float targetX, float targetY, float targetZ, float distance, float orbitSpeed, float orbitPitch) {
    this.targetX = targetX;
    this.targetY = targetY;
    this.targetZ = targetZ;
    this.distance = distance;
    this.orbitSpeed = orbitSpeed;
  }

  void update() {
    handleLook();
    if (orbitMode) {
      this.yaw += this.orbitSpeed;
      if (yaw > TWO_PI) yaw -= TWO_PI;
      if (yaw < 0) yaw += TWO_PI;
      pitch = this.orbitPitch;
      applyOrbitCamera();
    } else {
      handleMove();
      applyCamera();
    }
  }

  void handleLook() {
    // Arrow keys to rotate
    if (keyPressed) {
      if (keyCode == LEFT)  yaw -= lookSpeed;
      if (keyCode == RIGHT) yaw += lookSpeed;
      if (keyCode == UP)    pitch -= lookSpeed;
      if (keyCode == DOWN)  pitch += lookSpeed;
    }

    // Keep pitch within -90° to +90°
    pitch = constrain(pitch, -PI/2, PI/2);
  }
  
  void applyOrbitCamera() {
    x = targetX + cos(yaw) * cos(pitch) * distance;
    y = targetY + sin(pitch) * distance;
    z = targetZ + sin(yaw) * cos(pitch) * distance;
  
    camera(x, y, z, targetX, targetY, targetZ, 0, 1, 0);
  }

  void handleMove() {
    // Direction vectors
    float forwardX = cos(yaw) * cos(pitch);
    float forwardY = sin(pitch);
    float forwardZ = sin(yaw) * cos(pitch);

    float rightX = cos(yaw + HALF_PI);
    float rightZ = sin(yaw + HALF_PI);

    if (keyPressed) {
      if (key == 'w' || key == 'W') {
        x += forwardX * moveSpeed;
        y += forwardY * moveSpeed;
        z += forwardZ * moveSpeed;
      }
      if (key == 's' || key == 'S') {
        x -= forwardX * moveSpeed;
        y -= forwardY * moveSpeed;
        z -= forwardZ * moveSpeed;
      }
      if (key == 'a' || key == 'A') {
        x -= rightX * moveSpeed;
        z -= rightZ * moveSpeed;
      }
      if (key == 'd' || key == 'D') {
        x += rightX * moveSpeed;
        z += rightZ * moveSpeed;
      }
      if (key == 'q' || key == 'Q') y -= moveSpeed;
      if (key == 'e' || key == 'E') y += moveSpeed;
    }
  }

  void applyCamera() {
    float dirX = cos(yaw) * cos(pitch);
    float dirY = sin(pitch);
    float dirZ = sin(yaw) * cos(pitch);
    camera(x, y, z, x + dirX, y + dirY, z + dirZ, 0, 1, 0);
  }
}
