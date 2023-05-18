precision highp float;
uniform sampler2D image;
uniform vec2 resolution;
uniform int kernelsize;
uniform float sigma;

in vec2 vUv;
out vec4 fragColor;

const float PI = 3.1415;
const float e = 2.7183;

void main(void) {
    vec2 uv = vUv.xy;
    
    vec2 cellSize = 1./resolution.xy;
    vec4 textureValue = vec4(0.);
    
    float filterSum = 0.;
    for (int j=-kernelsize/2; j<kernelsize/2+kernelsize%2; j++) {
        for (int i=-kernelsize/2; i<kernelsize/2+kernelsize%2; i++) {
            float logValue = -1./(PI*pow(sigma,4.)) * (1. - float(i*i+j*j)/(2.*pow(sigma,2.))) * pow(e, -float(i*i+j*j)/(2.*pow(sigma,2.))); // take probability value from LoG curve
            textureValue += logValue * texture2D(image, uv + vec2(float(i)*cellSize.x, float(j)*cellSize.y));
        }
    }
    
    fragColor = vec4(vec3(length(textureValue)), textureValue.a);
}