class Thumbnail {
  String url;
  int height;

  Thumbnail(this.url, this.height);
  Thumbnail.empty()
      : this.url = "",
        this.height = -1;
}
