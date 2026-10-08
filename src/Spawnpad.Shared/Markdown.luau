local Markdown = {}

local function escapeRichText(text: string): string
	text = text:gsub("&", "&amp;")
	text = text:gsub("<", "&lt;")
	text = text:gsub(">", "&gt;")
	text = text:gsub('"', "&quot;")
	text = text:gsub("'", "&apos;")
	return text
end

local function renderInline(text)
	text = escapeRichText(text)

	-- code
	text = text:gsub("`([^`]+)`", '<font family="rbxasset://fonts/families/BuilderMono.json">%1</font>')

	-- bold
	text = text:gsub("%*%*([^*]+)%*%*", "<b>%1</b>")

	-- italic
	text = text:gsub("%*([^*]+)%*", "<i>%1</i>")

	-- strike
	text = text:gsub("~~([^~]+)~~", "<s>%1</s>")

	return text
end

function Markdown.render(markdown)
	local output = {}

	for line in markdown:gmatch("[^\r\n]+") do
		local rendered

		-- headings
		local heading = line:match("^###%s+(.+)$")
		if heading then
			rendered = '<font size="18"><b>' .. renderInline(heading) .. "</b></font>"
		else
			heading = line:match("^##%s+(.+)$")
			if heading then
				rendered = '<font size="22"><b>' .. renderInline(heading) .. "</b></font>"
			else
				heading = line:match("^#%s+(.+)$")
				if heading then
					rendered = '<font size="28"><b>' .. renderInline(heading) .. "</b></font>"
				end
			end
		end

		-- list item
		if not rendered then
			local item = line:match("^%s*%-%s+(.+)$")

			if item then
				rendered = "• " .. renderInline(item)
			end
		end

		-- normal text
		if not rendered then
			rendered = renderInline(line)
		end

		table.insert(output, rendered)
	end

	return table.concat(output, "\n")
end

return Markdown
