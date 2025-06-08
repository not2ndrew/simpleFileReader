const std = @import("std");
const fs = std.fs;

const lineReader = @import("fileLineReader.zig");

const print = std.debug.print;

pub fn main() !void {
    const file_path = "test.csv";

    var debugAllocator = std.heap.DebugAllocator(.{}){};
    const allocator = debugAllocator.allocator();

    var timer1 = try std.time.Timer.start();
    // try fileReader(file_path, allocator);
    try lineReader.readFileLines(file_path, allocator);
    const elapsed_ns = timer1.read();
    const elapsed_ms = @divTrunc(elapsed_ns, 1_000_000);

    std.debug.print("Time taken for fileReader: {} ns ({} ms)\n", .{elapsed_ns, elapsed_ms});
}


pub fn fileReader (file_path: []const u8, allocator: std.mem.Allocator) !void {
    const file = try fs.cwd().openFile(file_path, .{});
    defer file.close();

    const fileSize = try file.getEndPos();

    const buffer = try allocator.alloc(u8, fileSize);
    defer allocator.free(buffer);

    const bytes_read: usize = try file.read(buffer);

    print("file contents {s}\n", .{buffer[0..bytes_read]});
}
