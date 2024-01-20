import 'package:motivate_me/Models/thumbnail.dart';

class Quote {
  int id;
  String url;
  String author;
  String authorPermalink;
  String body;
  Thumbnail thumbnail;

  Quote(this.id, this.url, this.author, this.authorPermalink, this.body,
      this.thumbnail);

  Quote.empty()
      : id = -1,
        url = "",
        author = "",
        authorPermalink = "",
        body = "",
        thumbnail = Thumbnail.empty();

  Quote.noData()
      : id = -2,
        url = "",
        author = "",
        authorPermalink = "",
        body = "",
        thumbnail = Thumbnail.empty();
}
