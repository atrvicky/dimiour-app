import 'dart:math';

import 'package:app/components/timeline/timeline.dart';
import 'package:app/components/timeline/timeline_entry.dart';

/// Data container for all the sub-elements of the [MenuSection].
class MenuItemData {
  String label = '';
  double start = 0.0;
  double end = 0.0;
  bool pad = false;
  double padTop = 0.0;
  double padBottom = 0.0;

  MenuItemData();

  /// When initializing this object from a [TimelineEntry], fill in the
  /// fields according to the [entry] provided. The entry in fact specifies
  /// a [label], a [start] and [end] times.
  /// Padding is built depending on the type of the [entry] provided.
  MenuItemData.fromEntry(TimelineEntry entry) {
    label = entry.label;

    /// Pad the edges of the screen.
    pad = true;
    TimelineAsset? asset = entry.asset;

    /// Extra padding for the top base don the asset size.
    padTop = asset == null ? 0.0 : asset.height * Timeline.AssetScreenScale;
    if (asset is TimelineAnimatedAsset) {
      padTop += asset.gap;
    }

    if (entry.type == TimelineEntryType.Era) {
      start = entry.start;
      end = entry.end;
    } else {
      /// No need to pad here as we are centering on a single item.
      double rangeBefore = double.maxFinite;
      for (TimelineEntry? prev = entry.previous;
          prev != null;
          prev = prev.previous) {
        double diff = entry.start - prev.start;
        if (diff > 0.0) {
          rangeBefore = diff;
          break;
        }
      }

      double rangeAfter = double.maxFinite;
      for (TimelineEntry? next = entry.next; next != null; next = next.next) {
        double diff = next.start - entry.start;
        if (diff > 0.0) {
          rangeAfter = diff;
          break;
        }
      }
      double range = min(rangeBefore, rangeAfter) / 2.0;
      start = entry.start;
      end = entry.end + range;
    }
  }
}
