const std = @import("std");
const testing = std.testing;
const facilio = @import("facilio").Http;

export fn add(a: i32, b: i32) i32 {
    return a + b;
}

fn on_request(request: [*c]facilio.http_s) callconv(.C) void {
    std.debug.print("REQUEST!\n", .{});
    var msg: []const u8 = "Hello from ZAP!";
    _ = facilio.http_send_body(request, @intToPtr(
        *anyopaque,
        @ptrToInt(msg.ptr),
    ), msg.len);
}

test "basic add functionality" {
    try testing.expect(add(3, 7) == 10);
}

test "http" {
    _ = facilio.http_listen("3000", null, .{
        .on_request = on_request,
        .log = 1,
        .on_upgrade = null,
        .on_response = null,
        .on_finish = null,
        .udata = null,
        .public_folder = null,
        .public_folder_length = 0,
        .max_header_size = 4096,
        .max_body_size = 4096,
        .max_clients = 42,
        .tls = null,
        .reserved1 = 0,
        .reserved2 = 0,
        .reserved3 = 0,
        .ws_max_msg_size = 250 * 1024,
        .timeout = 0,
        .ws_timeout = 0,
        .is_client = 0,
    });
    _ = facilio.fio_start(.{
        .threads = 4,
        .workers = 4,
    });
}
