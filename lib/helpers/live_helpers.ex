defmodule ContentfulElixir.LiveHelpers do
  @moduledoc """
  Provides helper functions to render HTML content from Contentful data structures.

  This module is designed to transform Contentful's rich text and other complex data types into HTML for display on web pages. It supports a variety of Contentful node types, such as paragraphs, headings, lists, and hyperlinks, converting them into their corresponding HTML tags. This allows for a direct and flexible way to integrate Contentful content into Phoenix LiveView applications or any Elixir-based web rendering context.

  The main function, `render_content/2`, accepts Contentful data as input and returns a string of HTML. It is capable of handling both individual content entries and lists of entries, making it versatile for different types of content structures fetched from Contentful.

  ## Usage

  The `render_content/2` function can be used within Phoenix templates or LiveViews to dynamically render HTML content based on the data retrieved from Contentful. This simplifies the process of incorporating Contentful's managed content into Elixir applications, providing an easy-to-use interface for content transformation.

  ## Examples

      # Rendering a list of content blocks from Contentful
      contentful_data = [
        %{"nodeType" => "paragraph", "content" => [%{"nodeType" => "text", "value" => "Hello, world!"}]},
        %{"nodeType" => "heading-1", "content" => [%{"nodeType" => "text", "value" => "Welcome"}]}
      ]
      html_content = ContentfulElixir.LiveHelpers.render_content(contentful_data)
      # html_content is now "<p>Hello, world!</p><h1>Welcome</h1>"

  This module simplifies the integration of Contentful content into your web application, allowing you to focus on the application logic and user experience while easily managing content through Contentful.
  """

  @doc """
  Compile elements from contentful direct into html elements
  """

  def render_content(data, opts \\ %{}) when is_list(data),
    do: Enum.map(data, &render_node(&1, opts)) |> Enum.join()

  defp render_node(%{"nodeType" => type, "content" => content} = node, opts) do
    case type do
      "paragraph" -> "<p>#{render_content(content, opts)}</p>"
      "heading-1" -> "<h1>#{render_content(content, opts)}</h1>"
      "heading-2" -> "<h2>#{render_content(content, opts)}</h2>"
      "heading-3" -> "<h3>#{render_content(content, opts)}</h3>"
      "heading-4" -> "<h4>#{render_content(content, opts)}</h4>"
      "heading-5" -> "<h5>#{render_content(content, opts)}</h5>"
      "heading-6" -> "<h6>#{render_content(content, opts)}</h6>"
      "list-item" -> "<li>#{render_content(content, opts)}</li>"
      "unordered-list" -> "<ul>#{render_content(content, opts)}</ul>"
      "ordered-list" -> "<ol>#{render_content(content, opts)}</ol>"
      "table" -> "<table>#{render_content(content, opts)}</table>"
      "table-row" -> "<tr>#{render_content(content, opts)}</tr>"
      "table-header-cell" -> "<th>#{render_content(content, opts)}</th>"
      "table-cell" -> "<td>#{render_content(content, opts)}</td>"
      "hyperlink" -> render_hyperlink(node, opts)
      _ -> render_node(node, opts)
    end
  end

  defp render_node(%{"nodeType" => "hr"}, _opts), do: "<hr />"

  defp render_node(%{"nodeType" => "text", "value" => value, "marks" => marks}, _opts),
    do: apply_marks(value, marks)

  defp render_hyperlink(%{"data" => %{"uri" => uri}, "content" => content}, opts) do
    link_content = render_content(content, opts)
    "<a href=\"#{uri}\">#{link_content}</a>"
  end

  defp apply_marks(text, marks) do
    marks_map = %{"bold" => ["<strong>", "</strong>"], "italic" => ["<em>", "</em>"]}

    Enum.reduce(marks, text, fn mark, acc ->
      [open, close] = marks_map[mark["type"]]
      "#{open}#{acc}#{close}"
    end)
  end
end
