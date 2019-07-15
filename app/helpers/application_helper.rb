module ApplicationHelper
	
	def title(page_title)
    content_for :title, page_title.to_s
	end
	
	def meta
    content_for :meta
	end

	def markdown(text)
		options = {
			filter_html: true,
			hard_wrap: true,
			space_after_headers: true, 
			fenced_code_blocks: true,
			with_toc_data: true
		}

		extensions = {
			no_intra_emphasis: true,
			tables: true,
			strikethrough: true,
			superscript: true,
			disable_indented_code_blocks: true,
			highlight: true,
			autolink: true
		}

		renderer = Redcarpet::Render::HTML.new(options)
		markdown = Redcarpet::Markdown.new(renderer, extensions)

		markdown.render(text).html_safe
	end

end