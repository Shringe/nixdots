#version 440

layout(location = 0) in vec2 qt_TexCoord0;
layout(location = 0) out vec4 fragColor;

layout(std140, binding = 0) uniform buf {
  mat4 qt_Matrix;
  float qt_Opacity;
  float angle;
  float split;
  float time;
  vec3 src;
  vec3 dst;
};

layout(binding = 1) uniform sampler2D source;

void main() {
  vec4 tex = texture(source, qt_TexCoord0);
  if (tex.a < 0.01) discard;

  vec2 direction = vec2(cos(radians(angle)), sin(radians(angle)));
  float t = dot(qt_TexCoord0 - 0.5, direction) + 0.5;

  float raw = t + time; // no fract — stripe moves off naturally past 1.0
  float tri = 1.0 - abs(2.0 * raw - 1.0); // triangle wave: 0 → 1 → 0
  t = tri;

  t = clamp(t + (split - 0.5) * 2.0, 0.0, 1.0);

  vec3 gradient = mix(src, dst, t);

  // Multiply by texture alpha to mask to text shape
  fragColor = vec4(gradient * tex.a, tex.a) * qt_Opacity;
}
