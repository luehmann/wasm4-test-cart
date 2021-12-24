const w4 = @import("wasm4.zig");

const smiley = [8]u8{
    0b11000010,
    0b10000001,
    0b00100100,
    0b00100100,
    0b00000000,
    0b00100100,
    0b10011001,
    0b11000011,
};

const bunny = [_]u8{ 0xaa, 0x9e, 0xac, 0xaa, 0xaa, 0x57, 0xbf, 0x2a, 0xaa, 0x57, 0xbf, 0x2a, 0xaa, 0x17, 0xbf, 0x2a, 0xaa, 0x17, 0x03, 0x2a, 0xaa, 0x57, 0x54, 0x2a, 0xa8, 0x55, 0x55, 0x6a, 0xa9, 0x55, 0x05, 0x0a, 0xaf, 0xd5, 0x55, 0x4a, 0xa8, 0x75, 0x55, 0x4a, 0xaa, 0xd5, 0x57, 0x2a, 0xaa, 0x1d, 0x7c, 0xaa, 0xa8, 0x75, 0x15, 0x2a, 0xa8, 0x45, 0x15, 0x2a, 0xaa, 0x10, 0x54, 0xaa, 0xaa, 0x85, 0x52, 0xaa };

const small_sprite = [2]u8{ 0b11000011, 0b11000011 };

const frames_per_rotation = 60;
var t: u32 = 0;

export fn update() void {
    const rotation = switch (t / frames_per_rotation) {
        0 => 0,
        1 => w4.BLIT_FLIP_Y | w4.BLIT_FLIP_X | w4.BLIT_ROTATE,
        2 => w4.BLIT_FLIP_Y | w4.BLIT_FLIP_X,
        3 => w4.BLIT_ROTATE,
        else => unreachable,
    };
    w4.DRAW_COLORS.* = 2;
    w4.text("Hello from Zig!", 10, 10);

    const gamepad = w4.GAMEPAD1.*;
    if (gamepad & w4.BUTTON_1 != 0) {
        w4.DRAW_COLORS.* = 4;
    }

    w4.blit(&smiley, 76, 76, 8, 8, w4.BLIT_1BPP | rotation);
    w4.text("Press X to blink", 16, 90);

    w4.blit(&small_sprite, 0, 0, 4, 4, w4.BLIT_1BPP | rotation);
    w4.blit(&small_sprite, 140, 0, 2, 2, w4.BLIT_2BPP | rotation);

    w4.DRAW_COLORS.* = 0x3024;
    w4.blit(&bunny, 10, 40, 16, 16, w4.BLIT_2BPP | rotation);

    t += 1;
    t %= frames_per_rotation * 4;
}
