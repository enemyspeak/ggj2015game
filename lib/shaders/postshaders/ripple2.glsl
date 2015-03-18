extern number time = 0.0;
extern number size = 64.0;
extern number strength = 1.0;
extern vec2 res = vec2(480.0, 360.0);
uniform sampler2D tex0;

vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 pixel_coords)
{
    float tmp = sin(sqrt(pow(texture_coords.x * size - size / 2.0, 2.0) + pow(texture_coords.y * size - size / 2.0, 2.0)) - time * 16.0);
    vec2 uv         = vec2(
        texture_coords.x - tmp * strength / 1024.0,
        texture_coords.y - tmp * strength / 1024.0
    );
    vec4 col        = vec4(
        texture2D(tex0,uv).x,
        texture2D(tex0,uv).y,
        texture2D(tex0,uv).z,
        texture2D(tex0,uv).a
    ); 
    float white_level = col.x;

    // a discarded fragment will fail the stencil test.
    if (white_level == 0.0)
    {
        discard;
    }
    return vec4(1.0);
}
