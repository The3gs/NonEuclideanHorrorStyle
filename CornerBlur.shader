shader_type spatial;
render_mode unshaded;

void vertex(){
     VERTEX += (sin(VERTEX * VERTEX.y) + vec3(sin(TIME * 2.0))) * (VERTEX.y + 1.0) / 100.0;
   }

void fragment(){
    vec2 view = normalize((CAMERA_MATRIX * vec4(VIEW, 0.0)).xz);
    vec2 normal = normalize((CAMERA_MATRIX * vec4(NORMAL, 0.0)).xz);
    float dot_prod = dot(normal, view);
    float blur = dot_prod*dot_prod*dot_prod;
    float pixel_size = 1.0 / VIEWPORT_SIZE.x;
    vec3 total_color = vec3(0);
    for (int i = -20; i <= 20; i++){
        total_color += texture(SCREEN_TEXTURE, 
                               SCREEN_UV + pixel_size * blur * float(i)).rgb;
       }
    total_color /= 41.0;
    float brightness = length(total_color);
    total_color += sin(vec3(3.1415, 2.7182, 1.6180) * TIME * 0.1) * 0.01 * blur;
    total_color = normalize(total_color) * brightness;
    ALBEDO = total_color;
   }