extends Node

var song_selected = 0

var shoujo_rei_map = [
	[14.5, 200, 350, "honnou ga"],
	[15.7, 400, 200, "kurui"],
	[16.4, 600, 300, "hajimeru"],
	[17.7, 300, 250, "oitsumerareta"],
	[19.2, 500, 400, "hatsukanezumi"],
	[20.7, 200, 200, "ima,"],
	[21.3, 350, 300, "zetsubou"],
	[22.3, 500, 190, "no fuchi"],
	[22.9, 220, 400, "ni tatte"],
	[24.2, 400, 290, "fumikiri"],
	[25.0, 200, 300, "e to"],
	[25.8, 500, 200, "tobidashita"],
	[27.2, 300, 400, "sou,"],
	[28.0, 170, 200, "kimi wa"],
	[28.8, 350, 450, "tomodachi"],
	[30.4, 200, 500, "boku no"],
	[31.4, 350, 200, "te wo"],
	[32.2, 500, 400, "tsukame yo"],
	[33.8, 180, 230, "sou,"],
	[34.4, 250, 400, "kimi wa"],
	[35.2, 360, 200, "hitori sa"],
	[36.7, 600, 300, "ibasho"],
	[37.7, 500, 400, "nante"],
	[38.5, 700, 200, "nai"],
	[38.95, 600, 500, "daro"],
	[40.2, 200, 300, "futarikiri"],
	[41.4, 500, 200, "kono"],
	[42.1, 600, 400, "mama"],
	[43.5, 350, 150, "aishiaeru"],
	[44.7, 600, 200, "saa"],
	[47.0, 450, 300, "kurikaesu"],
	[48.2, 700, 400, "furasshu"],
	[49.1, 500, 200, "bakku semi"],
	[49.9, 400, 500, "no koe"],
	[51.0, 600, 350, "nidoto wa"],
	[52.2, 300, 300, "kaeranu"],
	[53.6, 450, 510, "kimi"],
	[54.7, 200, 400, "towa ni"],
	[55.8, 420, 180, "chigireteku"],
	[57.6, 300, 300, "osoroi no"],
	[59.4, 500, 330, "kiihorudaa"],
	[60.9, 650, 500, "natsu ga"],
	[62.2, 400, 280, "keshisatta"],
	[63.7, 200, 330, "shiroi"],
	[64.6, 360, 500, "hada no"],
	[65.8, 500, 190, "shoujo ni"],
	[67.2, 300, 300, "kanashii"],
	[68.2, 400, 460, "hodo"],
	[68.8, 600, 200, "toritsukarete"],
	[70.3, 200, 400, "shimaitai"],
	[74.3, 450, 300, "kurikaesu"],
	[75.6, 700, 400, "furasshu"],
	[76.6, 500, 200, "bakku semi"],
	[77.4, 400, 500, "no koe"],
	[78.6, 600, 350, "nidoto wa"],
	[79.8, 300, 300, "kaeranu"],
	[81.2, 450, 510, "kimi"],
	[82.3, 200, 400, "towa ni"],
	[83.4, 420, 180, "chigireteku"],
	[85.2, 300, 300, "osoroi no"],
	[87.0, 500, 330, "kiihorudaa"],
	[88.8, 650, 500, "natsu ga"],
	[89.8, 400, 280, "keshisatta"],
	[91.3, 200, 330, "shiroi"],
	[92.2, 360, 500, "hada no"],
	[93.3, 500, 190, "shoujo ni"],
	[94.8, 300, 300, "kanashii"],
	[95.6, 400, 460, "hodo"],
	[96.5, 600, 200, "toritsukarete"],
	[97.9, 200, 400, "shimaitai"],
	[101.1, 300, 500, "toumeina"],
	[102.8, 600, 200, "kimi wa"],
	[103.8, 400, 400, "boku wo"],
	[104.5, 500, 190, "yubi"],
	[106.2, 300, 500, "sashitetaa"]
]



var song_list = [
	[0, "shoujo rei", shoujo_rei_map, 75],
	[1, "just_be_friends", 1, 1]
]

func get_beatmap(index):
	match index:
		0: return shoujo_rei_map
	return[]
	
