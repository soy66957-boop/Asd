// flow_order.dart - Pure BFS from source over logic-connected tiles.
// Returns per-tile distance and entry side.

import 'package:pipes/domain/use_cases/pipe_rules.dart';

/// Result of flow order computation for a single tile.
class FlowTileInfo {
  const FlowTileInfo({
    required this.distance,
    required this.entrySide,
    required this.connected,
  });

  /// BFS distance from source (0 for source).
  final int distance;

  /// Side water enters this tile from (0=N,1=E,2=S,3=W), -1 for source.
  final int entrySide;

  /// Whether this tile is connected to source in the logic.
  final bool connected;
}

/// Computes flow order for all tiles on the board.
/// Returns a 2D array of FlowTileInfo matching board dimensions.
List<List<FlowTileInfo>> computeFlowOrder({
  required List<List<int>> board,
  required int sourceRow,
  required int sourceCol,
}) {
  final n = board.length;
  final infos = List.generate(n, (_) => List<FlowTileInfo>.filled(n, const FlowTileInfo(distance: -1, entrySide: -1, connected: false)));

  if (sourceRow < 0 || sourceRow >= n || sourceCol < 0 || sourceCol >= n) {
    return infos;
  }

  // BFS queue: [row, col, distance, entrySide]
  final queue = <List<int>>[];
  final visited = List.generate(n, (_) => List<bool>.filled(n, false));

  // Source tile
  infos[sourceRow][sourceCol] = const FlowTileInfo(distance: 0, entrySide: -1, connected: true);
  visited[sourceRow][sourceCol] = true;
  queue.add([sourceRow, sourceCol, 0, -1]);

  while (queue.isNotEmpty) {
    final curr = queue.removeFirst();
    final r = curr[0];
    final c = curr[1];
    final dist = curr[2];
    final mask = board[r][c];

    // Check all four directions
    // North
    if ((mask & 1) != 0 && r > 0 && (board[r - 1][c] & 4) != 0 && !visited[r - 1][c]) {
      visited[r - 1][c] = true;
      infos[r - 1][c] = FlowTileInfo(distance: dist + 1, entrySide: 2, connected: true); // water enters from South (2)
      queue.add([r - 1, c, dist + 1, 2]);
    }
    // East
    if ((mask & 2) != 0 && c < n - 1 && (board[r][c + 1] & 8) != 0 && !visited[r][c + 1]) {
      visited[r][c + 1] = true;
      infos[r][c + 1] = FlowTileInfo(distance: dist + 1, entrySide: 3, connected: true); // enters from West (3)
      queue.add([r, c + 1, dist + 1, 3]);
    }
    // South
    if ((mask & 4) != 0 && r < n - 1 && (board[r + 1][c] & 1) != 0 && !visited[r + 1][c]) {
      visited[r + 1][c] = true;
      infos[r + 1][c] = FlowTileInfo(distance: dist + 1, entrySide: 0, connected: true); // enters from North (0)
      queue.add([r + 1, c, dist + 1, 0]);
    }
    // West
    if ((mask & 8) != 0 && c > 0 && (board[r][c - 1] & 2) != 0 && !visited[r][c - 1]) {
      visited[r][c - 1] = true;
      infos[r][c - 1] = FlowTileInfo(distance: dist + 1, entrySide: 1, connected: true); // enters from East (1)
      queue.add([r, c - 1, dist + 1, 1]);
    }
  }

  return infos;
}

/// Computes the maximum BFS distance (for stagger clamping).
int maxFlowDistance(List<List<FlowTileInfo>> flowInfos) {
  int maxDist = 0;
  for (final row in flowInfos) {
    for (final info in row) {
      if (info.connected && info.distance > maxDist) {
        maxDist = info.distance;
      }
    }
  }
  return maxDist;
}
