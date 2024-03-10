defmodule ContentfulElixir do
  @moduledoc """
  Provides functions to interact with the Contentful Content Delivery API,
  allowing for fetching entries, assets, and lists of entries based on content type and locale.

  This module is designed to facilitate easy integration with Contentful for Elixir applications,
  abstracting away the HTTP request handling and focusing on returning the relevant content directly to the caller.

  ## Configuration

  The module relies on the following module attributes to be set for making API requests:

  - `@base_url`: The base URL for the Contentful API. Typically, this would be set to Contentful's Content Delivery API endpoint.
  - `@space_id`: The Space ID provided by Contentful, which identifies the content space from which to fetch data.
  - `@access_token`: The access token for authenticating requests to the Contentful API. This should be a Content Delivery API access token with permissions appropriate for the requested operations.

  It is essential to configure these attributes correctly for the module functions to operate. These can be set directly in the module or dynamically before the module functions are called, depending on the application's configuration strategy.

  ## Available Functions

  - `fetch_entry/2`: Fetches a single entry by its ID and optional locale.
  - `fetch_asset/2`: Retrieves a single asset by its ID and optional locale.
  - `fetch_entries/2`: Gets a list of entries filtered by content type and optional locale.

  Each function is designed to return an `{:ok, data}` tuple on success, where `data` contains the requested Contentful resource. In case of an error (such as a network error or if the requested resource does not exist), the functions will raise an error, indicating that the operation was unsuccessful.

  ## Usage Example

      config :my_app, ContentfulElixir,
        base_url: "https://cdn.contentful.com",
        space_id: "your_space_id",
        access_token: "your_access_token"

      # Fetch a specific entry
      {:ok, entry} = ContentfulElixir.fetch_entry("entry_id")

      # Fetch a specific asset
      {:ok, asset} = ContentfulElixir.fetch_asset("asset_id")

      # Fetch entries of a specific content type
      {:ok, entries} = ContentfulElixir.fetch_entries("content_type")

  Ensure that error handling is implemented in the calling code to gracefully handle potential exceptions raised by these functions.
  """

  def config do
    %{
      base_url: Application.get_env(:contentful_elixir, :base_url, "https://cdn.contentful.com"),
      space_id: Application.fetch_env!(:contentful_elixir, :space_id),
      access_token: Application.fetch_env!(:contentful_elixir, :access_token)
    }
  end

  @doc """
  Fetches a list of entries of a specific content type from Contentful for a given locale.

  This function sends a GET request to the Contentful API to retrieve entries that match a specified content type. It allows specifying the locale of the entries, defaulting to "en-US" if not provided. The function expects a successful response (HTTP status 200) from Contentful and returns the entries wrapped in an `:ok` tuple. If the request fails or does not return a 200 status code, `Req.get!` will raise an error.

  ## Parameters

  - `content_type`: The Contentful content type ID for which to fetch entries. This parameter is required.
  - `locale`: The locale for the entries data to retrieve. Defaults to "en-US" if not specified.

  ## Returns

  - `{:ok, entries}`: On success, returns an `:ok` tuple with a list of entries as received from Contentful in response to the request.

  ## Examples

      iex> Kredentials.Content.fetch_entries("blogPost")
      {:ok, [%{"title" => "First Post", "body" => "Hello, world!"}, ...]}

      iex> Kredentials.Content.fetch_entries("blogPost", "de-DE")
      {:ok, [%{"title" => "Erster Beitrag", "body" => "Hallo Welt!"}, ...]}

  ## Errors

  - If the Contentful API request fails or does not return a 200 status code, `Req.get!` will raise an error. It is recommended to handle potential errors in the calling code, potentially using `try` and `catch`, or by using `Req.get` instead of `Req.get!` for more nuanced error handling.

  ## Notes

  - The function requires the configuration of `@base_url`, `@space_id`, and `@access_token` module attributes with appropriate values to access the Contentful API.
  - The API access token must have the required permissions to access entries within the specified space and content type.

  """
  @spec fetch_entries(String.t(), String.t()) :: {:ok, map()} | {:error, term()}
  def fetch_entries(content_type, locale \\ "en-US") do
    get_contentful_resource("entries", params: [content_type: content_type, locale: locale])
  end

  @doc """
  Fetches an entry from Contentful based on the provided entry ID and locale.

  This function sends a GET request to the Contentful API, attempting to retrieve a specific content entry by its ID. The entry is fetched for the specified locale, defaulting to "en-US" if no locale is provided. The function expects a successful response from Contentful (HTTP status 200) and returns the body of the response wrapped in an `:ok` tuple. If the request does not succeed, `Req.get!` will raise an error.

  ## Parameters

  - `entry_id`: The ID of the entry to fetch. This is a required parameter.
  - `locale`: The locale of the entry content to fetch. It defaults to "en-US".

  ## Returns

  - `{:ok, entry}`: On success, returns an `:ok` tuple containing the body of the response from Contentful, which includes the requested entry data.

  ## Examples

      iex> Kredentials.Content.fetch_entry("someEntryId")
      {:ok, %{"fields" => %{"title" => "Entry Title", "description" => "Entry Description"}, ...}}

      iex> Kredentials.Content.fetch_entry("someEntryId", "de-DE")
      {:ok, %{"fields" => %{"title" => "Eintragstitel", "description" => "Eintragsbeschreibung"}, ...}}

  ## Errors

  - If the request to Contentful fails or does not return a 200 status code, `Req.get!` will raise an error. It's recommended to handle potential errors in the calling code, possibly using `try` and `catch` or by leveraging `Req.get` instead of `Req.get!` for more granular error handling.

  ## Notes

  - This function requires the configuration of `@base_url`, `@space_id`, and `@access_token` module attributes, which should be set to appropriate values for accessing the Contentful API.
  - Ensure that the API access token has sufficient permissions to read entries in the specified space.

  """
  @spec fetch_entry(String.t(), String.t()) :: {:ok, map()} | {:error, term()}
  def fetch_entry(entry_id, locale \\ "en-US") do
    get_contentful_resource("entries/#{entry_id}", params: [locale: locale])
  end

  @doc """
  Fetches an asset from Contentful using the specified asset ID and locale.

  This function issues a GET request to the Contentful API to retrieve a specific asset identified by its asset ID. It allows for specifying the locale of the asset information, defaulting to "en-US" if not provided. The function anticipates a successful response (HTTP status 200) from Contentful and returns the response body containing the asset data wrapped in an `:ok` tuple. If the request is unsuccessful, `Req.get!` will raise an error.

  ## Parameters

  - `asset_id`: The unique identifier for the asset to fetch. This parameter is required.
  - `locale`: The locale for the asset data to retrieve. Defaults to "en-US" if not specified.

  ## Returns

  - `{:ok, asset}`: Returns an `:ok` tuple with the asset data as received from Contentful in the case of a successful request.

  ## Examples

      iex> Kredentials.Content.fetch_asset("someAssetId")
      {:ok, %{"fields" => %{"title" => "Asset Title", "file" => %{"url" => "//assets.ctfassets.net/..."}}, ...}}

      iex> Kredentials.Content.fetch_asset("someAssetId", "de-DE")
      {:ok, %{"fields" => %{"title" => "Asset-Titel", "file" => %{"url" => "//assets.ctfassets.net/..."}}, ...}}

  ## Errors

  - If the Contentful API request fails or does not return a 200 status code, `Req.get!` will raise an error. It is advised to handle potential errors in the calling code, potentially using `try` and `catch`, or by employing `Req.get` instead of `Req.get!` for more nuanced error handling.

  ## Notes

  - The function necessitates the configuration of `@base_url`, `@space_id`, and `@access_token` module attributes with appropriate values to access the Contentful API.
  - The API access token must have the required permissions to access assets within the specified space.

  """
  @spec fetch_asset(String.t(), String.t()) :: {:ok, map()} | {:error, term()}
  def fetch_asset(asset_id, locale \\ "en-US") do
    get_contentful_resource("assets/#{asset_id}", params: [locale: locale])
  end

  defp get_contentful_resource(path, options) do
    case Req.get(url(path), Keyword.put(options, :access_token, config().access_token)) do
      {:ok, %Req.Response{status: 200, body: body}} ->
        {:ok, body}

      {:ok, %Req.Response{status: status, body: body}} when status in 400..599 ->
        {:error, {:http_error, status, body}}

      {:error, reason} ->
        {:error, reason}
    end
  end

  defp url(path) do
    "#{config().base_url}/spaces/#{config().space_id}/#{path}"
  end
end
