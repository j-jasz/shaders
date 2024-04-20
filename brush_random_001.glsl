
float blob(vec2 uvSmall, float maxsize, float minsize) {
    // Distance to center
    float d = length(uvSmall);
    float m = smoothstep(maxsize, minsize, d);
    return m;
}

float Hash21(vec2 p) {
    p = fract(p*vec2(123.456, 345.565));
    p += dot(p, p+45.32);
    return fract(p.x*p.y);
}

void mainImage( out vec4 fragColor, in vec2 fragCoord ) {
    vec2 uv = (fragCoord-.5*iResolution.xy)/iResolution.y;
    vec2 uvSmall = uv * 10.0;

    // Add opacity here
    vec3 col = vec3(1);

    //Distribute points
    //col.rg = gv;
    vec2 gv = fract(uvSmall)-0.5;
    vec2 id = floor(uvSmall);

    // Mask
    float d = length(uv);
    float mask = smoothstep(0.4, 0.3, d);
    mask = mix(mask - 1.2, mask, mask);

    // Iteration kernel
    for(int y=-1;y<=1;y++) {
        for(int x=-1;x<=1;x++) {
            vec2 offset = vec2(x, y);

            float n = Hash21(id+offset)*(iTime/100.0);
            float r = Hash21(id+offset);
            col -= blob(gv-offset-vec2(n, fract(n*34.0))+0.5, 0.9, 0.01);
        }
    }

    // Color mix
    col = col + (1.0 - mask);
    fragColor = vec4(col, 1.0);
}