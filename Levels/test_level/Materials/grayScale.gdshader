shader_type canvas_item;

uniform float saturation : hint_range(0.0, 1.0) = 0.0;
uniform float color_boost : hint_range(1.0, 2.0) = 1.5;

varying vec4 originalColor;
varying vec3 gray_color;
varying float pixel_alpha;

void fragment() {
    originalColor = COLOR;
    vec4 tex = texture(TEXTURE, UV);

    float gray = dot(tex.rgb, vec3(0.299, 0.587, 0.114));

    gray_color = vec3(gray);
    pixel_alpha = tex.a;

    COLOR = vec4(gray_color, pixel_alpha);
}

void light() {
    float light_amount = clamp(
        max(max(LIGHT_COLOR.r, LIGHT_COLOR.g), LIGHT_COLOR.b)
        * LIGHT_ENERGY,
        0.0,
        1.0
    );

    light_amount = min(light_amount * 3.0, 1.0);

    vec3 gray = vec3(
        dot(originalColor.rgb, vec3(0.299, 0.587, 0.114))
    );

    vec3 lit_color = mix(
        gray,
        originalColor.rgb,
        light_amount
    );

    lit_color = gray + (lit_color - gray) * color_boost;
    lit_color = clamp(lit_color, 0.0, 1.0);

    LIGHT = vec4(lit_color, 1.0) * LIGHT_COLOR;
}