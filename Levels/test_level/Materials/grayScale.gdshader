shader_type canvas_item;

uniform float saturation : hint_range(0.0, 1.0) = 0.0;
varying vec4 originalColor;

void fragment() {
	originalColor = COLOR;
    vec4 tex = texture(TEXTURE, UV);

    float gray = dot(tex.rgb, vec3(0.299, 0.587, 0.114));

    vec3 gray_color = vec3(gray);

    COLOR = vec4(gray_color, tex.a);
}

void light() {
    float light_amount = clamp(
        max(max(LIGHT_COLOR.r, LIGHT_COLOR.g), LIGHT_COLOR.b)
        * LIGHT_ENERGY,
        0.0,
        1.0
    );

    light_amount *= 3.0;
	if (light_amount > 1.0) {
		light_amount = 1.0;
	}

    LIGHT = originalColor * light_amount;
}