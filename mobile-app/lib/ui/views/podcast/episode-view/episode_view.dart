import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:freecodecamp/models/podcasts/episodes_model.dart';
import 'package:freecodecamp/models/podcasts/podcasts_model.dart';
import 'package:freecodecamp/ui/views/podcast/episode-view/episode_viewmodel.dart';
import 'package:freecodecamp/ui/widgets/podcast_widgets/podcast_tilte_widget.dart';
import 'package:stacked/stacked.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:html/dom.dart' as dom;

class EpisodeView extends StatelessWidget {
  const EpisodeView({Key? key, required this.episode, required this.podcast})
      : super(key: key);

  final Episodes episode;
  final Podcasts podcast;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<EpisodeViewModel>.reactive(
        viewModelBuilder: () => EpisodeViewModel(),
        builder: (context, model, child) => Scaffold(
              appBar: AppBar(title: Text(podcast.title!)),
              body: ListView(children: [
                Column(
                  children: [
                    CachedNetworkImage(imageUrl: podcast.image!),
                    PodcastTile(
                        podcast: podcast,
                        episode: episode,
                        isFromEpisodeView: true,
                        isFromDownloadView: false),
                    Container(
                      padding: const EdgeInsets.all(8),
                      color: const Color(0xFF0a0a23),
                      child: description(model),
                    ),
                  ],
                ),
              ]),
            ));
  }

  Widget description(EpisodeViewModel model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Episode Description',
          style:
              TextStyle(fontSize: 24, fontWeight: FontWeight.bold, height: 1.2),
        ),
        Html(
          data: episode.description,
          onLinkTap: (
            String? url,
            RenderContext context,
            Map<String, String> attributes,
            dom.Element? element,
          ) {
            launchUrlString(url!);
          },
          style: {
            '#': Style(
                fontSize: const FontSize(18),
                color: Colors.white.withOpacity(0.87),
                padding: const EdgeInsets.all(8),
                margin: EdgeInsets.zero,
                maxLines: model.viewMoreDescription ? null : 8,
                fontFamily: 'Lato')
          },
        ),
        TextButton(
            onPressed: () {
              model.setViewMoreDescription = !model.viewMoreDescription;
            },
            child: Text(
              model.viewMoreDescription ? 'Show Less' : 'Show all',
              style: const TextStyle(
                  decoration: TextDecoration.underline,
                  fontSize: 16,
                  color: Color.fromRGBO(0x99, 0xc9, 0xff, 1)),
            )),
      ],
    );
  }
}