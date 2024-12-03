shader_type canvas_item;

uniform vec4 white_color : source_color;
uniform vec4 black_color : source_color;

uniform float balance : hint_range(0.0, 1.0);

void fragment() {
	float rounded_balance = round(balance * 16.);
	rounded_balance = rounded_balance / 16.0;
	if (UV.x > rounded_balance) {
		COLOR = black_color;
	} else {
		COLOR = white_color;
	}
}