# ContentfulElixir

A simple solution to fetching Contentful entries and assets in Phoenix, with a focus on LiveView.

I built this as existing solutions did not provide an easy way to fetch data based on locales. I also wanted an automated way for content to be rendered, hence the `render_node` method.

I did not need much, but wanted to put this up for anyone else that might have need for it.

If you have any requests for additional features, open an issue and ideally give me a contentful example so I can understand your use case and how best to implement it.

PRs are also welcome.

## Installation

The package can be installed by adding `contentful_elixir` to your list of dependencies in `mix.exs`:

HexDocs should have all the information you need to get going.

```elixir
def deps do
  [
    {:contentful_elixir, "~> 0.1.0"}
  ]
end
```
