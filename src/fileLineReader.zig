const std = @import("std");

pub fn readFileLines(file_path: []const u8, allocator: std.mem.Allocator) !void {
    var file = try std.fs.cwd().openFile(file_path, .{});
    defer file.close();

    const fileSize = try file.getEndPos();

    var buffered_reader = std.io.bufferedReader(file.reader());
    var reader = buffered_reader.reader();

    while (true) {
        const maybe_line = try reader.readUntilDelimiterOrEofAlloc(allocator, '\n', fileSize);

        if (maybe_line == null) break;

        const line = maybe_line.?;

        defer allocator.free(line);

        std.debug.print("{s}\n", .{line});
    }
}