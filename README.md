# CITC 1351: A+ Hardware Website

This repo contains the [Quarto](https://quarto.org/docs/websites/) source code for the student website for CITC 1321: A+ Hardware.  It is generated using Quarto version 1.7.33.

The project includes a github workflow task to render the site when the changes are pushed to the repository.

You can veiw the rendered site at [https://chuck650.github.io/edu-pstcc-citc1351/](https://chuck650.github.io/edu-pstcc-citc1351/).

## The `youtube_video` Extension for Quarto

This extension provides a way to embed YouTube videos in your Quarto documents using a shortcode.  It retrieves video metadata (title, author, description, etc.) from a YAML file or document metadata and generates the necessary HTML to embed the video.

### Installing

To install the extension, run the following command in your Quarto project directory:

```bash
quarto add chuck650/youtube_video
```

This will install the extension under the `_extensions` subdirectory.
If you're using version control, you will want to check in this directory.

### Using

The youtube_video extension adds a shortcode to format a YouTube video lising in this format:

```yaml
videos:
  - title: "How To Learn Anything So Fast It Feels Illegal (Evidence based)"
    url: "https://www.youtube.com/watch?v=Z24Td5mtKOs"
    author: Giles McMullen
    channel: https://www.youtube.com/@gilesmcmullen
    video_id: "Z24Td5mtKOs"
    description: "Justin Sung shares evidence-based techniques for rapid learning."
```

The shortcode is used by passing the `video_id` from the listing as an argument.

```qmd
{{< youtube_video Z24Td5mtKOs >}}
```

### Example

Here is the source code for a minimal example: [example.qmd](example.qmd).
