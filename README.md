# CITC 1351: A+ Hardware Website

This repo contains the [Quarto](https://quarto.org/docs/websites/) source code for the student website for CITC 1321: A+ Hardware.  It is generated using Quarto version 1.7.33.

The project includes a github workflow task to render the site when the changes are pushed to the repository.

You can veiw the rendered site at [https://chuck650.github.io/edu-pstcc-citc1351/](https://chuck650.github.io/edu-pstcc-citc1351/).

## Rendering

All the  site resources are in the `src/` folder.  Render the site using the VSCode build task or directly in the terminal from the project rood like this.

```sh
quarto render src/
```

Verbose debugging output can help with troubleshooting rending problems.

```sh
quarto render src/ --verbose
```

## Testing

Test the rendered site using the LiveServer extension inside of VSCode.  The site needs to be served over HTTP and accessed using the `http://` or `https://` protocol, not just viewed in a browser using the `file://` local file system access protocol

## Deploy to GitHub Pages

See https://quarto.org/docs/publishing/github-pages.html.

Prepare for deployment by creating an orphan branch for deployments.

```sh
git checkout --orphan gh-pages
git reset --hard # make sure all changes are committed before running this!
git commit --allow-empty -m "Initialising gh-pages branch"
git push origin gh-pages
```

Ensure any current or future R, Python, or Julia code is only executed locally.  Ensure this  snippet is in the `/.quarto.yml` file.

```yaml
execute:
  freeze: auto
```

Before configuring the publishing action, it’s important that you run `quarto publish gh-pages` locally, once. This will create the _publish.yml configuration required by the subsequent invocations of the GitHub Action. To do this, run the following from within your project:

```sh
quarto publish gh-pages src/
```


## Custom Quarto extensions

There are several types of extensions you can create for Quarto.  Shotcodes are one type of extension.

### The `youtube_video` shortcode for Quarto

This extension provides a way to embed YouTube videos in your Quarto documents using a shortcode.  It retrieves video metadata (title, author, description, etc.) from a YAML file or document metadata and generates the necessary HTML to embed the video.

#### Creating the shortcode

See:

- https://quarto.org/docs/extensions/shortcodes.html
- https://quarto.org/docs/extensions/distributing.html

Create the shortcode by running this command and following the prompts.

```sh
quarto create extension shortcode
```

Once the scaffolding is ready, modify the lua script to create the required functionality.

#### Configure for publishing

Using `quarto create extension shortcode` will create the `_extensions` directory tree for the shortcode and allows the render process to proceed normally and servicn the site from the local render target will work.  However, publishing will generally yield a Warning messag and result in a site that fails on use of the shortcode.  To ensure the shortcode is available on published sites, add this to the `_quarto.yml` file.

```yaml
shortcodes:
  - ./_extensions/youtube_video/youtube_video.lua
```

#### Installing

The short code can be separately created and resie within it's own github repo for distribution to other projects.

To install the extension from a GitHub repository, run the following command in your Quarto project directory:

```bash
quarto add chuck650/youtube_video
```

This will install the extension under the `_extensions` subdirectory.
If you're using version control, you will want to check in this directory.

The extension can also be packaged in a zip or tar file and installed from the archive file directly.

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
