import 'package:app/components/timeline/timeline.dart';
import 'package:app/components/timeline/timeline_entry.dart';
import 'package:app/components/timeline/timeline_widget.dart';
import 'package:app/helpers/constants.dart';
import 'package:app/helpers/network/network_service.dart';

import 'package:timelines/timelines.dart' as timelinesView;
import 'package:app/models/models.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TimelinePage extends StatefulWidget {
  static MaterialPage page() => const MaterialPage(
        child: TimelinePage(),
        name: TIMELINE_PATH,
        key: ValueKey(TIMELINE_PATH),
      );

  const TimelinePage({Key? key}) : super(key: key);

  @override
  _TimelineState createState() => _TimelineState();
}

class _TimelineState extends State<TimelinePage> {
  late UserManager userManager;
  late ThemeData theme;
  late NetworkService networkService;

  bool isLoading = false;
  UserTimeline userTimeline = UserTimeline();

  bool _isDebug = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    theme = Theme.of(context);
    userManager = Provider.of<UserManager>(context);

    networkService = NetworkService(context: context);
    networkService.setHandleState(false);

    _getTimeline();
  }

  @override
  Widget build(BuildContext context) {
    return userTimeline.notifications.isEmpty
        ? _displayEmptyList()
        : Stack(
            children: [
              _displayTimeline(),
              Switch(
                  value: _isDebug,
                  onChanged: (newState) {
                    setState(() {
                      _isDebug = newState;
                    });
                  }),
            ],
          );
  }

  Widget _displayTimeline() {
    Timeline timeline = Timeline(TargetPlatform.android);
    if (_isDebug) {
      timeline
          .loadFromBundle("assets/timeline.json")
          .then((List<TimelineEntry> entries) {
        timeline.setViewport(
            start: entries.first.start * 2.0,
            end: entries.first.start,
            animate: true);

        /// Advance the timeline to its starting position.
        timeline.advance(0.0, false);
      });
      return TimelineWidget(timeline);
    }

    return _easyView();
  }

  Widget _easyView() {
    return timelinesView.Timeline.tileBuilder(
      builder: timelinesView.TimelineTileBuilder.fromStyle(
        contentsAlign: timelinesView.ContentsAlign.alternating,
        contentsBuilder: (context, index) => Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Text(userTimeline.notifications[index].formattedTime),
              const SizedBox(height: 12,),
              Text(userTimeline.notifications[index].getFormattedType()),
            ],
          ),
        ),
        itemCount: userTimeline.notifications.length,
      ),
    );
  }

  Widget _displayEmptyList() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'No events logged yet. Check back later!',
            style: theme.textTheme.caption,
          ),
        ],
      ),
    );
  }

  Future<void> _getTimeline() async {
    setState(() {
      isLoading = true;
    });

    userTimeline = userManager.id != null
        ? await networkService.getUserTimeline(userManager.id!)
        : UserTimeline();

    setState(() {
      isLoading = false;
    });
  }
}
