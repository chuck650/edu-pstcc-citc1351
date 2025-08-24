-- youtube_video.lua

return {
  ['youtube_video'] = function(args, kwargs, meta, raw_args, context)
    local video_id_str = pandoc.utils.stringify(args[1])

    local videos_list = {}

    if context and context.doc and context.doc.metadata and context.doc.metadata.videos then
      videos_list = context.doc.metadata.videos
    end

    if meta and meta.videos then
      videos_list = meta.videos
    end

    local video_data = nil
    for _, video in ipairs(videos_list) do
      if video.video_id and pandoc.utils.stringify(video.video_id) == video_id_str then
        video_data = video
        break
      end
    end

    if video_data then
      local html = [[
<style>
.video-responsive {
  position: relative;
  padding-bottom: 56.25%; /* 16:9 aspect ratio */
  height: 0;
  overflow: hidden;
  max-width: 100%;
}
.video-responsive iframe {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
}
</style>
<div class="video-container">
  <h2><a href="]] ..
      pandoc.utils.stringify(video_data.url) .. [[">]] .. pandoc.utils.stringify(video_data.title) .. [[</a></h2>
  <p><strong>Author:</strong> ]] ..
      pandoc.utils.stringify(video_data.author) ..
      [[ | <a href="]] .. pandoc.utils.stringify(video_data.channel) .. [[">View Channel</a></p>
  <p>]] .. pandoc.utils.stringify(video_data.description) .. [[</p>
  <div class="video-responsive">
    <iframe
      src="https://www.youtube.com/embed/]] .. pandoc.utils.stringify(video_data.video_id) .. [["
      frameborder="0"
      allowfullscreen
    ></iframe>
  </div>
</div>
]]
      return pandoc.RawBlock('html', html)
    else
      return pandoc.RawBlock('html',
        '<p>Error: Video with ID "' ..
        video_id_str ..
        '" not found in document metadata. This may be because the shortcode is being used in an unsupported context, such as a listing page.</p>')
    end
  end
}
