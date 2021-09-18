import 'package:flutter/material.dart';
import 'episode_view.dart';
import 'package:podcast_search/podcast_search.dart';
import 'package:intl/intl.dart';
import 'dart:developer';

class PodcastApp extends StatefulWidget {
  const PodcastApp({Key? key}) : super(key: key);

  @override
  _PodcastAppState createState() => _PodcastAppState();
}

class _PodcastAppState extends State<PodcastApp> {
  // int page = 0;

  Future<List<Episode>> fetchPodcastEpisodes() async {
    // page++;
    final podcastURL = 'https://freecodecamp.libsyn.com/rss';
    // final podcastURL = 'https://themattwalshblog.com/category/podcast/feed';

    Podcast podcast = await Podcast.loadFeed(url: podcastURL);
    log("Podcast episodes: ${podcast.episodes?.length}");
    return podcast.episodes!;
  }

  @override
  void initState() {
    super.initState();
    fetchPodcastEpisodes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Podcasts'),
        backgroundColor: Color(0xFF0a0a23),
      ),
      backgroundColor: Color(0xFF0a0a23),
      body: FutureBuilder<List<Episode>>(
        future: fetchPodcastEpisodes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Center(child: const CircularProgressIndicator.adaptive());
          }
          if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          // log(podcastEpisodes);
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (BuildContext context, int index) {
              return PodcastEpisodeTemplate(
                  episode: snapshot.data![index], i: index);
            },
          );
        },
      ),
    );
  }
}

class PodcastEpisodeTemplate extends StatelessWidget {
  const PodcastEpisodeTemplate(
      {Key? key, required this.episode, required this.i})
      : super(key: key);

  final Episode episode;
  final int i;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        log("Clicked ${episode.title}");
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => EpisodeView(episode: episode)));
      },
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 50),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                width: 1,
                color: Colors.grey,
              ),
            ),
          ),
          child: Row(
            // crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      episode.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        DateFormat.yMMMd().format(episode.publicationDate!),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                flex: 0,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Icon(
                    Icons.download,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
