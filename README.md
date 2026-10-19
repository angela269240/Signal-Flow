# Signal Flow
An interactive Processing installation that uses real-time face detection and microphone input to generate dynamic particles that respond to human presence and sound.

## 🛠 Built With
- Processing
- Processing Sound Library
- Processing Video Library
- OpenCV for Processing

## ⚙️ How It Works
1. The webcam captures live video
2. OpenCV detects the largest visible face
3. The center of the detected face becomes the particle system's origin
4. The microphone measures sound amplitude
5. Louder sounds increase the particles' orbital radius
6. Particles smoothly animate around the face, creating a responsive visual effect

## 📚 Libraries Required
Install these Processing libraries before running:
- Sound
- Video
- OpenCV for Processing
You can install them from:
**Sketch → Import Library → Add Library...**

Search for:
- Sound
- Video
- OpenCV for Processing

## 🎮 Controls
- Allow webcam access
- Allow microphone access
- Move your face to reposition the particle system
- Speak or make sounds to expand the particle orbit
