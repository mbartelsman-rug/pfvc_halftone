# 1. Introduction

- Introduction
    - Sets the topic against a wider background, gives the context
    - Clearly states the topic/problem at hand
    - Defines key notions

---

Pixel art is a digital art technique defined by pixel-level control with strict color and resolution limitations imposed by the computer hardware typically seen in the late 80s and early 90s.

Pixel art diminished in popularity as hardware technology improved and the constraints that gave rise to this art form disappeared. However, in recent years with the advent of indie games and a general resurgence of "old-school" inspired aesthetics, pixel art has reappeared, albeit in a more loosely defined form now that any constraints are arbitrary.

This project aims to contribute to the production of games and visuals anchored in the aesthetics of pixel art by investigating the effectiveness of state-of-the-art, structure preserving error diffusion algorithms on the quantization of down-sampled, up-scaled images.

The immediate goal is to find a configuration that is most effective at producing a pixel-art version of an image — one that best preserves the tone and texture of the original image. The ultimate goal is to develop a system that can produce accurate pixel-art in real time based on non-pixel art visuals.

Error diffusion is a technique for color quantization in images. The core mechanism in the technique is that the residual of the quantization is diffused to nearby pixels so that the local and overall tone of the image is best reproduced. Error diffusion has the side effect that edges are well preserved due to the means by which error is propagated. This feature has been expanded on and developed with the goal of producing quantized images that retain as much structural information as possible, without sacrificing tone.

One of the mayor disadvantages of error diffusion is the presence of visual artifacts in mid-tone areas caused by the formation of repeating patterns in the distribution of black and white pixels product of the diffusion techniques employed. Much research has also gone into minimizing these artifacts.

A second mayor disadvantage of error diffusion is that it is, by it's very nature, sequential, making it a poor target for real time graphics in its standard form. Techniques exist for turning ED into a parallelizable iterative algorithm but the adaptation of the techniques that this project will explore to the iterative ED approach are outside of the scope of this project.