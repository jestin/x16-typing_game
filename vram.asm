.ifndef VRAM_ASM
VRAM = 1

; This file defines addresses for the game's vram map

tile_map_vram_data  		= $00000
tile_vram_data  			= $04000
sprite_vram_data  			= $0b000
bitmap_base_data 			= $0c000
palette_vram_data			= $1FA00

.endif ; VRAM_ASM
