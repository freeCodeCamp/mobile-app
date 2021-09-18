// import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/dom.dart' as dom;
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_html/style.dart';
import 'package:podcast_search/podcast_search.dart';
import 'package:intl/intl.dart';
import 'dart:developer';
import 'package:just_audio/just_audio.dart';

// class AudioPlayerTask extends BackgroundAudioTask {
//   final _audioPlayer = AudioPlayer();
//   final _completer = Completer();

//   @override
//   Future<void> onStart(Map<String, dynamic>? params) async {
//     // Connect to the URL
//     // log(params?['url']);
//     await _audioPlayer.setUrl(
//         "https://traffic.libsyn.com/secure/freecodecamp/freecodecamp-changelog-podcast.mp3?dest-id=603849");
//     // Now we're ready to play
//     _audioPlayer.play();
//   }

//   @override
//   Future<void> onStop() async {
//     // Stop playing audio
//     await _audioPlayer.stop();
//     // Shut down this background task
//     await super.onStop();
//   }
// }

class EpisodeView extends StatefulWidget {
  const EpisodeView({Key? key, required this.episode}) : super(key: key);

  final Episode episode;

  @override
  State<EpisodeView> createState() => _EpisodeViewState();
}

class _EpisodeViewState extends State<EpisodeView> {
  final _audioPlayer = AudioPlayer();
  bool _playing = false;

  final TextStyle _titleStyle =
      const TextStyle(color: Colors.white, fontSize: 20);

  final TextStyle _subTitleStyle =
      const TextStyle(color: Colors.white, fontSize: 14);

  final TextStyle _textStyle =
      const TextStyle(color: Colors.white, fontSize: 16);

  String _parseDuration(Duration dur) {
    if (dur.inMinutes > 59) {
      return '${widget.episode.duration!.inMinutes ~/ 60} hr ${widget.episode.duration!.inMinutes % 60} min';
    } else {
      return '${widget.episode.duration!.inMinutes % 60} min';
    }
  }

  // _backgroundTaskEntrypoint() {
  //   AudioServiceBackground.run(() => AudioPlayerTask());
  // }

  @override
  void initState() {
    super.initState();
    _audioPlayer.setUrl(widget.episode.contentUrl!);
    _audioPlayer.load();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF0a0a23),
      ),
      backgroundColor: Color(0xFF0a0a23),
      body: Container(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image.network(
                'https://ssl-static.libsyn.com/p/assets/2/f/f/7/2ff7cc8aa33fe438/freecodecamp-square-logo-large-1400.jpg',
                height: 250,
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                widget.episode.title,
                style: _titleStyle,
              ),
              SizedBox(
                height: 7.5,
              ),
              Text(
                DateFormat.yMMMd().format(widget.episode.publicationDate!) +
                    ' • ' +
                    _parseDuration(widget.episode.duration!),
                style: _subTitleStyle,
              ),
              SizedBox(
                height: 7.5,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                child: TextButton.icon(
                  onPressed: () {
                    log("CLICKED PLAY BUTTON");
                    if (!_playing) {
                      _audioPlayer.play();
                      setState(() {
                        _playing = true;
                      });
                    } else {
                      _audioPlayer.pause();
                      setState(() {
                        _playing = false;
                      });
                    }
                    // AudioService.start(
                    //   backgroundTaskEntrypoint: _backgroundTaskEntrypoint(),
                    //   // params: {'url': widget.episode.contentUrl!},
                    // );
                  },
                  icon: Icon(
                    _playing ? Icons.pause : Icons.play_arrow,
                    color: Colors.white,
                  ),
                  label: Text(
                    _playing ? 'Pause' : 'Play',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateColor.resolveWith(
                        (states) => Color(0xff3b3b4f)),
                    overlayColor: MaterialStateColor.resolveWith(
                        (states) => Color(0xff2a2a40)),
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                child: TextButton.icon(
                  onPressed: () =>
                      log("CLICKED DOWNLOAD BUTTON ${widget.episode.title}"),
                  icon: Icon(
                    Icons.download,
                    color: Colors.white,
                  ),
                  label: Text(
                    'Download',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateColor.resolveWith(
                        (states) => Color(0xff3b3b4f)),
                    overlayColor: MaterialStateColor.resolveWith(
                        (states) => Color(0xff2a2a40)),
                  ),
                ),
              ),
              Html(
                data: widget.episode.description,
                shrinkWrap: true,
                onLinkTap: (String? url, RenderContext context,
                    Map<String, String> attributes, dom.Element? element) {
                  launch(url!);
                },
                style: {
                  'body': Style(
                    fontSize: FontSize(16),
                    color: Colors.white,
                    padding: EdgeInsets.zero,
                  )
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
